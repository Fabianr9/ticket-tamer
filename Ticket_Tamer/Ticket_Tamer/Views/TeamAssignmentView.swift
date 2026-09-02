import RealityKit
import Spatial
import SwiftUI
import UIKit
import simd

// MARK: - Ziel-ID → SupportTeam Mapping (Modul 009 — F-09 / AK-09)

/// Zentrale Zuordnung der vier technischen Ziel-IDs auf `SupportTeam`-Werte.
///
/// `internal` (kein expliziter Modifier), damit automatisierte Tests das Mapping
/// direkt prüfen können. Technische IDs erscheinen nie in der Benutzeroberfläche;
/// sichtbar sind ausschließlich die deutschen `SupportTeam.displayName`-Werte.
enum TeamTargetMapping {

    // MARK: - Technische Ziel-IDs

    /// Die vier Ziel-IDs als Konstanten — identisch verwendet in `DropTargetComponent`,
    /// Panelraster und RealityView-Attachment.
    enum ID {
        static let netzwerk = "team_netzwerk"
        static let konto = "team_konto"
        static let software = "team_software"
        static let hardware = "team_hardware"
    }

    // MARK: - Ziel-Descriptor

    struct TargetDefinition {
        /// Fachlich neutrale technische Ziel-ID (erscheint nie in der UI).
        let id: String
        /// Fachlicher Team-Wert.
        let team: SupportTeam
        /// Räumliche Position im Volume-Koordinatensystem.
        ///
        /// **Nur noch Rückfallwert** — die tatsächliche Panelposition entsteht aus dem
        /// gemessenen Volume (`TargetPanelLayout`).
        let position: SIMD3<Float>
    }

    // MARK: - Vollständige Zielliste

    /// Genau vier Teamstationen — nicht mehr, nicht weniger.
    static let allTargets: [TargetDefinition] = [
        .init(id: ID.netzwerk, team: .netzwerk, position: TeamAssignmentConstants.targetPositionNetzwerk),
        .init(id: ID.konto,    team: .konto,    position: TeamAssignmentConstants.targetPositionKonto),
        .init(id: ID.software, team: .software, position: TeamAssignmentConstants.targetPositionSoftware),
        .init(id: ID.hardware, team: .hardware, position: TeamAssignmentConstants.targetPositionHardware),
    ]

    // MARK: - Panelraster

    /// Zwei Reihen, zwei Spalten — die 2×2-Struktur bleibt exakt erhalten:
    ///
    /// ```text
    /// Netzwerk             Konto
    ///
    /// Software             Hardware
    /// ```
    ///
    /// Reihe 0 ist bündig an der Oberkante, Reihe 1 bündig an der Unterkante.
    static let panelLayout = TargetPanelLayout(
        columns: 2,
        rows: 2,
        slots: [
            .init(id: ID.netzwerk, column: 0, row: 0),
            .init(id: ID.konto,    column: 1, row: 0),
            .init(id: ID.software, column: 0, row: 1),
            .init(id: ID.hardware, column: 1, row: 1),
        ]
    )

    // MARK: - Mapping

    /// Gibt das `SupportTeam` für eine technische Ziel-ID zurück, oder `nil` bei unbekannter ID.
    static func team(for targetID: String) -> SupportTeam? {
        allTargets.first { $0.id == targetID }?.team
    }

    /// Gibt die technische Ziel-ID für ein `SupportTeam` zurück.
    static func targetID(for team: SupportTeam) -> String? {
        allTargets.first { $0.team == team }?.id
    }
}

// MARK: - Teamzuordnungsansicht (Modul 009 — F-09 / AK-09 / AK-10)

/// Räumliche Teamzuordnungsansicht für `GamePhase.teamZuordnen`.
///
/// Zeigt das Monster des aktuellen Tickets und vier flache 3D-Zielstationen mit deutschen
/// Beschriftungen (Netzwerk, Konto, Software, Hardware) im 2×2-Layout. Das Monster ist per
/// Blickfokus, Pinch und Drag interaktiv.
///
/// - Gültiger Drop: `SessionModel.saveTeam(_:)` speichert die Teamentscheidung genau einmal.
/// - Ungültiger Drop: Monster kehrt zur Ausgangsposition zurück, kein Zustandswechsel.
/// - Keine Bewertung gegen `referenceTeam` (Modul 010).
/// - Keine automatische Phasenweiterleitung (Modul 010 / F-13).
@MainActor
struct TeamAssignmentView: View {

    // MARK: - Environment

    @Environment(SessionModel.self) private var model

    // MARK: - Scene State

    @State private var monsterEntity: Entity? = nil
    @State private var targetEntities: [Entity] = []
    @State private var originTransform: Transform? = nil

    /// Position des Monsters zu Beginn der laufenden Zieh-Geste.
    @State private var dragStartPosition: SIMD3<Float>? = nil
    @State private var loadError: String? = nil

    // MARK: - Modul 010: Feedback-Zustand

    /// Verhindert mehrfachen Task-Start bei View-Refresh nach gespeichertem Team.
    @State private var feedbackTaskStarted: Bool = false
    /// Rein lokaler Sichtzustand fuer das bestehende Feedbackfenster (Modul 018).
    @State private var decisionFeedback: DecisionFeedbackResult? = nil
    /// Lokale Audio-Kapselung — kein globaler Service-Locator.
    @State private var audioService = AudioService()

    // MARK: - Modul 013: gemessene Drag-/Drop-Geometrie

    /// Gemeinsame Geometriequelle beider Zieh-Phasen — identisch zur Priorisierungsphase.
    @State private var geometry = MonsterDragGeometry(
        layout: TeamTargetMapping.panelLayout,
        monsterPlaneZ: TeamAssignmentConstants.monsterStartPosition.z
    )

    /// Das aktuell hervorgehobene Ziel, oder `nil`. Reines Anzeigefeedback.
    @State private var highlightedTargetID: String? = nil

    /// Verhindert, dass die Grenz-Debugausgabe während einer Geste in jedem Frame erscheint.
    @State private var clampLogged: Bool = false

    // MARK: - Modul 016: lokale Ticketinfo

    @State private var isTicketInfoPresented = TicketInfoInteraction.initialPresentation

    // MARK: - Body

    var body: some View {
        // Siehe `PrioritizationView`: der Layoutrahmen aus `GeometryReader3D` zusammen mit
        // `content.convert(_:from:to:)` ergibt die tatsächliche Volume-Größe in Metern.
        GeometryReader3D { proxy in
        ZStack(alignment: .top) {
            // 3D-Szene
            RealityView { content, _ in
                measureVolume(proxy: proxy, content: content)
            } update: { content, attachments in
                // Direkte Reads stellen SwiftUI-Dependency-Tracking sicher.
                let currentMonster = monsterEntity
                let currentTargets = targetEntities

                for entity in currentTargets where entity.scene == nil {
                    content.add(entity)
                }
                if let monster = currentMonster, monster.scene == nil {
                    content.add(monster)
                }

                measureVolume(proxy: proxy, content: content)
                attachPanelLabels(attachments)
            } attachments: {
                // Beschriftung der Panels als RealityView-Attachment — siehe
                // `PrioritizationView` zur Begründung.
                Attachment(id: TeamTargetMapping.ID.netzwerk) {
                    panelLabel(SupportTeam.netzwerk.displayName)
                }
                Attachment(id: TeamTargetMapping.ID.konto) {
                    panelLabel(SupportTeam.konto.displayName)
                }
                Attachment(id: TeamTargetMapping.ID.software) {
                    panelLabel(SupportTeam.software.displayName)
                }
                Attachment(id: TeamTargetMapping.ID.hardware) {
                    panelLabel(SupportTeam.hardware.displayName)
                }
            }
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in handleDragChanged(value: value) }
                    .onEnded { value in handleDragEnded(value: value) }
            )
            .allowsHitTesting(
                TicketInfoInteraction.isDragEnabled(
                    isPresented: isTicketInfoPresented,
                    isInputLocked: model.isInputLocked
                )
            )

            if isTicketInfoPresented, let ticket = model.currentTicket {
                ScaledToFitView(
                    designSize: CGSize(
                        width: LayoutConstants.compactTicketInfoDesignWidth,
                        height: LayoutConstants.compactTicketInfoDesignHeight
                    ),
                    maxScale: 1
                ) {
                    CompactTicketInfoView(ticket: ticket) {
                        isTicketInfoPresented = false
                    }
                }
                .padding(LayoutConstants.compactTicketInfoOuterPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.22))
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                .zIndex(1)
            }

            if model.currentTicket != nil {
                HStack {
                    Spacer()
                    Button {
                        isTicketInfoPresented = TicketInfoInteraction.toggled(isTicketInfoPresented)
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .accessibilityLabel(Text("ticketInfo.button.accessibility"))
                }
                .padding(20)
                .zIndex(2)
            }

            // Ladeindikator — liest monsterEntity im Body (SwiftUI-Dependency-Tracking).
            if monsterEntity == nil && loadError == nil {
                ProgressView()
                    .controlSize(.large)
                    .padding(.top, 100)
            }

            // Fehlermeldung bei Ladefehlern (kein Crash, kein Auto-Wechsel).
            if let error = loadError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 80)
            }

            if let decisionFeedback {
                DecisionFeedbackView(result: decisionFeedback)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity.combined(with: .scale(scale: 0.92)))
                    .zIndex(3)
            }
        }
        .ornament(
            attachmentAnchor: .scene(.top),
            contentAlignment: .bottom
        ) {
            SessionHUDView(
                currentTicketIndex: model.currentTicketIndex,
                totalTicketCount: model.sessionTickets.count,
                phase: model.currentPhase
            )
        }
        .ornament(
            attachmentAnchor: .scene(.bottom),
            contentAlignment: .top
        ) {
            InteractionHintView(text: InteractionHintContent.teamAssignment)
        }
        .task {
            await setupScene()
        }
        .onAppear {
            isTicketInfoPresented = false
            decisionFeedback = nil
            // Eingabe nur freigeben, wenn noch keine Teamentscheidung getroffen wurde.
            // beginTeamAssignmentPhase() übernimmt das initiale Unlock; dieser Guard
            // schützt vor erneutem Entsperren bei View-Refresh nach saveTeam(_:).
            if model.selectedTeam != nil {
                DebugManager.log(.state, "TeamAssignmentView erschienen, Team bereits gespeichert: \(model.selectedTeam!.rawValue)")
            } else {
                feedbackTaskStarted = false
                DebugManager.log(.state, "TeamAssignmentView erschienen, Phase: \(model.currentPhase)")
            }
        }
        .onChange(of: model.currentPhase) { _, _ in
            isTicketInfoPresented = false
            decisionFeedback = nil
        }
        // MARK: Modul 010 — Teamfeedback und automatischer Übergang (F-11 / F-12 / F-13)
        .onChange(of: model.selectedTeam) { _, newTeam in
            guard newTeam != nil, !feedbackTaskStarted else { return }
            feedbackTaskStarted = true
            Task { @MainActor in
                // 1. Genau einmal bewerten.
                guard let isCorrect = model.evaluateTeam() else {
                    DebugManager.log(.state, "Teambewertung war No-Op — Task beendet")
                    return
                }
                // 2. Das Bool-Ergebnis ist die einzige Quelle fuer das Sichtfeedback.
                decisionFeedback = DecisionFeedbackResult(evaluation: isCorrect)
                // 3. Genau einen Sound parallel zum Sichtfeedback abspielen.
                audioService.play(isCorrect ? .correct : .incorrect)
                // 4. Eingabe bleibt gesperrt; bestehendes Feedbackfenster abwarten.
                try? await Task.sleep(for: .seconds(FeedbackConstants.feedbackTransitionDelay))
                decisionFeedback = nil
                // 5. Guard: Phase darf sich nicht unerwartet geändert haben.
                guard model.currentPhase == .teamZuordnen else {
                    DebugManager.log(.state, "Team-Task: Phase hat sich geaendert, kein Uebergang")
                    return
                }
                // 6. Ticket abschließen: nächstes Ticket oder Ergebnis.
                model.completeTicketAfterTeamFeedback()
                DebugManager.log(.state, "Team-Feedbacktask abgeschlossen → \(model.currentPhase)")
            }
        }
        }
    }

    // MARK: - Panel-Beschriftung

    /// Beschriftung eines Zielpanels — identisch zur Priorisierungsphase.
    @ViewBuilder
    private func panelLabel(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(LayoutConstants.targetLabelMinimumScaleFactor)
            .allowsTightening(true)
            .shadow(radius: 3)
            .padding(.horizontal, LayoutConstants.targetLabelHorizontalPadding)
            .allowsHitTesting(false)
    }

    /// Farbe eines Zielpanels — neutral, keine Ampelfarben.
    ///
    /// Keine Farbe suggeriert richtig/falsch oder besser/schlechter; sie dient
    /// ausschließlich der Unterscheidbarkeit der vier Stationen.
    private func panelTint(for targetID: String) -> UIColor {
        switch TeamTargetMapping.team(for: targetID) {
        case .netzwerk: return .systemBlue
        case .konto:    return .systemPurple
        case .software: return .systemTeal
        case .hardware: return .systemIndigo
        case .none:     return .systemGray
        }
    }

    // MARK: - Szenenaufbau

    /// Erzeugt die vier Zielpanels und lädt das Monster asynchron.
    private func setupScene() async {
        for targetDef in TeamTargetMapping.allTargets {
            let entity = TargetPanelFactory.makeTarget(
                id: targetDef.id,
                debugName: targetDef.team.displayName
            )
            // Rückfallposition, bis Volume und Monster vermessen sind.
            entity.position = targetDef.position
            targetEntities.append(entity)
            DebugManager.log(.spawning, "Teamstation bereit: \(targetDef.id)")
        }

        // Monster laden.
        guard let ticket = model.currentTicket else {
            DebugManager.log(.spawning, "Kein aktives Ticket — Monster-Load abgebrochen")
            loadError = "Kein aktives Ticket."
            return
        }

        do {
            let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
            // Größe aus den tatsächlichen Modellmaßen ableiten statt aus einem festen Faktor.
            MonsterAssetProvider.fit(entity, toMaxExtent: LayoutConstants.monsterDragDropTargetSize)
            entity.position = TeamAssignmentConstants.monsterStartPosition
            originTransform = entity.transform
            MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)
            monsterEntity = entity

            // Tatsächliche sichtbare Hülle messen — Grundlage für den sicheren
            // Zieh-Bereich, für die Panelhöhe und für die 50-%-Prüfung.
            geometry.measureMonster(entity, assetID: ticket.monsterAssetId)
            syncPanels()

            DebugManager.log(.spawning, "Monster bereit: \(ticket.monsterAssetId), Modus: dragDrop")
        } catch {
            DebugManager.log(.spawning, "Monster-Load fehlgeschlagen: \(error.localizedDescription)")
            loadError = "Monster konnte nicht geladen werden."
        }
    }

    // MARK: - Geometrie (Modul 013)

    /// Misst das tatsächliche Volume und die Layoutebene.
    private func measureVolume(proxy: GeometryProxy3D, content: RealityViewContent) {
        let localFrame = proxy.frame(in: .local)

        // Entities werden über `content.add(_:)` direkt an der Szenenwurzel eingehängt;
        // `entity.position` und `.scene` beschreiben deshalb denselben Raum.
        let volume = content.convert(localFrame, from: .local, to: .scene)

        let measured = VolumeMetrics(
            volume: volume,
            layoutFrame: CGRect(
                x: localFrame.origin.x,
                y: localFrame.origin.y,
                width: localFrame.size.width,
                height: localFrame.size.height
            )
        )

        guard measured.isUsable, geometry.metrics != measured else { return }

        Task { @MainActor in
            geometry.update(metrics: measured)
            syncPanels()
        }
    }

    /// Bemaßt und platziert die Zielpanels aus der aktuellen Messung.
    private func syncPanels() {
        geometry.applyPanelGeometry(
            to: targetEntities,
            tint: panelTint(for:),
            highlightedID: highlightedTargetID
        )
    }

    /// Hängt die Text-Attachments an ihre Panels und setzt sie vor die Vorderfläche.
    private func attachPanelLabels(_ attachments: RealityViewAttachments) {
        guard let panelSize = geometry.panelSize else { return }
        let labelZ = panelSize.z / 2 + LayoutConstants.targetLabelStandoff

        for targetDef in TeamTargetMapping.allTargets {
            guard let root = targetEntity(for: targetDef.id),
                  let label = attachments.entity(for: targetDef.id)
            else { continue }

            if label.parent !== root {
                root.addChild(label)
            }
            label.position = SIMD3<Float>(0, 0, labelZ)
        }
    }

    /// Ziel-Entity zu einer Ziel-ID.
    private func targetEntity(for targetID: String) -> Entity? {
        targetEntities.first { $0.components[DropTargetComponent.self]?.id == targetID }
    }

    // MARK: - Hover-/Valid-Feedback

    /// Hebt genau das Ziel hervor, das bei einem Loslassen gewählt würde — oder keines.
    private func updateHighlight(at position: SIMD3<Float>) {
        let candidate = geometry.bestTarget(at: position)?.id
        guard candidate != highlightedTargetID else { return }

        if let previous = highlightedTargetID, let entity = targetEntity(for: previous) {
            TargetPanelFactory.setHighlighted(false, target: entity, tint: panelTint(for: previous))
        }
        if let candidate, let entity = targetEntity(for: candidate) {
            TargetPanelFactory.setHighlighted(true, target: entity, tint: panelTint(for: candidate))
        }

        highlightedTargetID = candidate
        DebugManager.log(.input, "Highlight: \(candidate ?? "-")")
    }

    /// Nimmt jede Hervorhebung zurück.
    private func clearHighlight() {
        guard let previous = highlightedTargetID else { return }
        if let entity = targetEntity(for: previous) {
            TargetPanelFactory.setHighlighted(false, target: entity, tint: panelTint(for: previous))
        }
        highlightedTargetID = nil
    }

    // MARK: - Gesture-Handler

    private func handleDragChanged(value: EntityTargetValue<DragGesture.Value>) {
        guard !isTicketInfoPresented else { return }
        guard !model.isInputLocked else {
            DebugManager.log(.input, "Drag ignoriert: Input gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        let start = dragStartPosition ?? entity.position
        if dragStartPosition == nil {
            dragStartPosition = start
            DebugManager.log(.input, "[Monster Transform BEFORE DRAG] \(entity.dragStateSummary)")
            // Kontrollausgabe zum Koordinatenraum — siehe die ausführliche Begründung
            // an der gleichnamigen Ausgabe in `PrioritizationView`: local und world
            // unterscheiden sich erwartungsgemäß um die Platzierung des Volumes; in
            // produktivem Code wird ausschließlich im Raum der Szenenwurzel gerechnet.
            DebugManager.log(
                .physics,
                "Raumprobe: local=\(entity.position) world=\(entity.position(relativeTo: nil))"
            )
        }

        // Planare Bewegung auf konstanter Tiefe — identisch zur Priorisierungsphase.
        let requested = PlanarDrag.requestedPosition(
            from: start,
            translation: value.gestureValue.translation
        )

        if let allowed = geometry.clamped(requested) {
            if !clampLogged, simd_distance(allowed, requested) > 0.0005 {
                clampLogged = true
                DebugManager.log(
                    .physics,
                    "Requested drag position: \(requested) | Clamped drag position: \(allowed)"
                )
                if let safe = geometry.safeBounds {
                    DebugManager.log(.physics, safe.debugSummary)
                }
            }
            entity.position = allowed
        } else {
            // Rückfallebene, solange Volume oder Monster noch nicht vermessen sind.
            entity.position = PlanarDrag.position(
                from: start,
                translation: value.gestureValue.translation,
                limits: PlanarDrag.playAreaLimits(
                    forEntityOfSize: LayoutConstants.monsterDragDropTargetSize
                )
            )
        }

        // Feedback, aber noch keine Entscheidung (Anforderung 15).
        updateHighlight(at: entity.position)
    }

    private func handleDragEnded(value: EntityTargetValue<DragGesture.Value>) {
        // Immer zuerst: die Geste ist beendet, der gemerkte Startpunkt gilt nicht mehr.
        dragStartPosition = nil
        clampLogged = false

        guard !isTicketInfoPresented else {
            clearHighlight()
            return
        }

        guard !model.isInputLocked else {
            DebugManager.log(.input, "Release ignoriert: Input bereits gesperrt (AK-10)")
            clearHighlight()
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        let dropped = entity.position
        DebugManager.log(.physics, "[Monster Transform AT RELEASE] \(entity.dragStateSummary)")

        // Der Zustand, den das Highlight zuletzt angezeigt hat — vor jedem Zurücksetzen
        // gesichert, damit der Trace „vor dem Release" und „beim Release" vergleichen kann.
        let highlightBeforeRelease = highlightedTargetID

        var hit: String? = nil
        if geometry.canEvaluateOverlap {
            hit = geometry.logDropTrace(
                view: "Teamzuordnung",
                monster: entity,
                at: dropped,
                highlightBeforeRelease: highlightBeforeRelease,
                inputLocked: model.isInputLocked,
                alreadyCommitted: model.selectedTeam != nil
            )?.id
        } else {
            DebugManager.log(
                .physics,
                "=== DROP DEBUG === Teamzuordnung: Geometrie noch nicht vermessen (metrics oder Monster-Bounds fehlen) — Kette bricht vor der Auswertung ab, Drop ungueltig"
            )
        }

        clearHighlight()

        if let hitID = hit {
            if let team = TeamTargetMapping.team(for: hitID) {
                model.saveTeam(team)
                DebugManager.log(.state, "Team gespeichert: \(team.rawValue), isInputLocked=\(model.isInputLocked)")
            } else {
                DebugManager.log(.physics, "Unbekannte Ziel-ID: \(hitID)")
                returnMonsterToOrigin(entity: entity)
            }
        } else {
            returnMonsterToOrigin(entity: entity)
            DebugManager.log(.physics, "Ungueltiger Drop: Monster kehrt zurueck")
        }
    }

    /// Stellt nach einem ungültigen Drop exakt den Zustand vom Phasenbeginn wieder her.
    private func returnMonsterToOrigin(entity: Entity) {
        guard let origin = originTransform else { return }
        entity.move(
            to: origin,
            relativeTo: entity.parent,
            duration: InteractionConstants.monsterReturnDuration,
            timingFunction: .easeInOut
        )
        DebugManager.log(
            .physics,
            "[Monster Transform AFTER SNAPBACK] Ziel pos=\(origin.translation) scale=\(origin.scale)"
        )
    }
}

// MARK: - Preview

#Preview(windowStyle: .volumetric) {
    let model = SessionModel()
    model.setTicketCount(1)
    model.startSession(using: { $0 })
    model.beginPrioritizationPhase()
    model.savePriority(.normal)
    model.beginTeamAssignmentPhase()
    return TeamAssignmentView()
        .environment(model)
}
