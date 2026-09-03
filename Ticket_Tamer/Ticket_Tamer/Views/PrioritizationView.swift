import RealityKit
import Spatial
import SwiftUI
import UIKit
import simd

// MARK: - Ziel-ID → TicketPriority Mapping (Modul 008 — F-08 / AK-08)

/// Zentrale Zuordnung der drei technischen Ziel-IDs auf `TicketPriority`-Werte.
///
/// `internal` (kein expliziter Modifier), damit automatisierte Tests das Mapping
/// direkt prüfen können. Nutzerinnen und Nutzer sehen ausschließlich
/// `TicketPriority.displayName` (deutsche Labels). Technische IDs sind nie sichtbar.
enum PriorityTargetMapping {

    // MARK: - Technische Ziel-IDs

    /// Die drei Ziel-IDs als Konstanten.
    ///
    /// Werden an drei Stellen gebraucht — `DropTargetComponent`, Panelraster und
    /// RealityView-Attachment — und müssen dort identisch sein. Als Konstante statt als
    /// Stringliteral, damit ein Tippfehler nicht erst zur Laufzeit auffällt.
    enum ID {
        static let normal = "priority_normal"
        static let wichtig = "priority_wichtig"
        static let kritisch = "priority_kritisch"
    }

    // MARK: - Ziel-Descriptor

    struct TargetDefinition {
        /// Fachlich neutrale technische Ziel-ID (erscheint nie in der UI).
        let id: String
        /// Fachlicher Prioritätswert.
        let priority: TicketPriority
        /// Räumliche Position im Volume-Koordinatensystem.
        ///
        /// **Nur noch Rückfallwert.** Die tatsächliche Position der Zielpanels entsteht seit
        /// dem Modul-013-Randfix aus dem gemessenen Volume (`TargetPanelLayout`), damit
        /// Panel und Trefferfläche deckungsgleich sind und mit der Volumegröße mitwandern.
        let position: SIMD3<Float>
    }

    // MARK: - Vollständige Zielliste

    /// Genau drei Prioritätsziele — nicht mehr, nicht weniger.
    static let allTargets: [TargetDefinition] = [
        .init(id: ID.normal,   priority: .normal,   position: PrioritizationConstants.targetPositionNormal),
        .init(id: ID.wichtig,  priority: .wichtig,  position: PrioritizationConstants.targetPositionWichtig),
        .init(id: ID.kritisch, priority: .kritisch, position: PrioritizationConstants.targetPositionKritisch),
    ]

    // MARK: - Panelraster

    /// Eine Reihe, drei Spalten — `Normal | Wichtig | Kritisch` nebeneinander, oben im
    /// Volume, bündig an der Kante.
    static let panelLayout = TargetPanelLayout(
        columns: 3,
        rows: 1,
        maximumWidth: LayoutConstants.priorityTargetGridMaximumWidth,
        slots: [
            .init(id: ID.normal,   column: 0),
            .init(id: ID.wichtig,  column: 1),
            .init(id: ID.kritisch, column: 2),
        ]
    )

    // MARK: - Mapping

    /// Gibt die `TicketPriority` für eine technische Ziel-ID zurück, oder `nil` bei
    /// unbekannter ID.
    static func priority(for targetID: String) -> TicketPriority? {
        allTargets.first { $0.id == targetID }?.priority
    }
}

// MARK: - Priorisierungsansicht (Modul 008 — F-08 / AK-08 / AK-10)

/// Räumliche Priorisierungsansicht für `GamePhase.priorisieren`.
///
/// Zeigt das Monster des aktuellen Tickets und drei flache 3D-Zielstationen mit deutschen
/// Beschriftungen (Normal, Wichtig, Kritisch). Das Monster ist per Blickfokus, Pinch und
/// Drag interaktiv.
///
/// - Gültiger Drop: `SessionModel.savePriority(_:)` speichert die Priorität genau einmal.
/// - Ungültiger Drop: Monster kehrt zur Ausgangsposition zurück, kein Zustandswechsel.
/// - Keine automatische Phasenweiterleitung (Modul 010 / F-13).
/// - Keine Bewertung gegen `referencePriority` (Modul 010).
@MainActor
struct PrioritizationView: View {

    // MARK: - Environment

    @Environment(SessionModel.self) private var model

    // MARK: - Scene State

    @State private var monsterEntity: Entity? = nil
    @State private var targetEntities: [Entity] = []
    @State private var originTransform: Transform? = nil
    @State private var loadError: String? = nil
    @State private var monsterLoadRecovery = MonsterLoadRecovery()

    // MARK: - Modul 010: Feedback-Zustand

    /// Verhindert mehrfachen Task-Start bei View-Refresh nach gespeicherter Priorität.
    @State private var feedbackTaskStarted: Bool = false
    /// Rein lokaler Sichtzustand fuer das bestehende Feedbackfenster (Modul 018).
    @State private var decisionFeedback: DecisionFeedbackResult? = nil
    /// Lokale Audio-Kapselung — kein globaler Service-Locator.
    @State private var audioService = AudioService()

    /// Position des Monsters zu Beginn der laufenden Zieh-Geste.
    ///
    /// Die Bewegung wird relativ zu diesem Wert berechnet (`PlanarDrag`), damit die
    /// Tiefenebene erhalten bleibt. `nil`, solange keine Geste läuft.
    @State private var dragStartPosition: SIMD3<Float>? = nil

    // MARK: - Modul 013: gemessene Drag-/Drop-Geometrie

    /// Gemeinsame Geometriequelle beider Zieh-Phasen — gemessenes Volume, gemessene
    /// Monster-Bounds, sicherer Zieh-Bereich, Panelgeometrie und Drop-Auswertung.
    @State private var geometry = MonsterDragGeometry(
        layout: PriorityTargetMapping.panelLayout,
        monsterPlaneZ: PrioritizationConstants.monsterStartPosition.z
    )

    /// Das aktuell hervorgehobene Ziel, oder `nil`.
    ///
    /// Reines Anzeigefeedback: „Wenn du jetzt loslässt, wird dieses Ziel gewählt."
    /// Die Entscheidung fällt ausschließlich in `handleDragEnded(value:)`.
    @State private var highlightedTargetID: String? = nil

    /// Verhindert, dass die Grenz-Debugausgabe während einer Geste in jedem Frame erscheint.
    @State private var clampLogged: Bool = false

    // MARK: - Modul 016: lokale Ticketinfo

    @State private var isTicketInfoPresented = TicketInfoInteraction.initialPresentation

    // MARK: - Body

    var body: some View {
        // `GeometryReader3D` liefert den tatsächlichen Layoutrahmen; zusammen mit
        // `content.convert(_:from:to:)` ergibt sich daraus die echte Volume-Größe in
        // Metern. Panelraster, sicherer Zieh-Bereich und Trefferflächen leiten sich alle
        // aus dieser einen Messung ab.
        GeometryReader3D { proxy in
        ZStack(alignment: .top) {
            // 3D-Szene
            // update: liest monsterEntity und targetEntities direkt — notwendig damit
            // RealityKit den Closure nach @State-Änderungen erneut ausführt (AK-08 Fix).
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
                // Beschriftung der Panels als RealityView-Attachment.
                //
                // Bewusst kein SwiftUI-Overlay mehr: die frühere Label-Zeile lag als
                // 2D-Ebene über der Szene und hatte keine definierte Tiefe gegenüber den
                // Panels. Als Attachment hängt der Text als Kind am Panel, steht
                // `targetLabelStandoff` vor dessen Vorderfläche und dreht sich mit ihm —
                // kein Z-Fighting, keine im Mesh versenkte Schrift.
                Attachment(id: PriorityTargetMapping.ID.normal) {
                    panelLabel(TicketPriority.normal.displayName)
                }
                Attachment(id: PriorityTargetMapping.ID.wichtig) {
                    panelLabel(TicketPriority.wichtig.displayName)
                }
                Attachment(id: PriorityTargetMapping.ID.kritisch) {
                    panelLabel(TicketPriority.kritisch.displayName)
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

            // DEBUG-Einstieg in die Teamphase — nur für Entwicklung/Simulator-Prüfung.
            // Nicht im Release-Build, nicht als F-09-Nutzerfunktion (AK-09).
            #if DEBUG
            if model.selectedPriority != nil {
                VStack {
                    Spacer()
                    Button("🔧 Team [DEV]") {
                        model.beginTeamAssignmentPhase()
                        DebugManager.log(.state, "[DEV] beginTeamAssignmentPhase manuell ausgeloest")
                    }
                    .font(.caption)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, 12)
                }
            }
            #endif

            // Ladeindikator — liest monsterEntity im Body (SwiftUI-Dependency-Tracking).
            if monsterLoadRecovery.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .padding(.top, 100)
            }

            // Fehlermeldung bei Ladefehlern (kein Crash, kein Auto-Wechsel).
            if let error = loadError {
                VStack(spacing: 8) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                    if monsterLoadRecovery.canRetry {
                        Button("Erneut laden") {
                            Task { await loadCurrentMonster() }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(monsterLoadRecovery.isLoading)
                    }
                }
                .padding(10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(.top, 80)
                .zIndex(10)
            }

            if let decisionFeedback {
                DecisionFeedbackView(result: decisionFeedback)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity.combined(with: .scale(scale: 0.92)))
                    .zIndex(3)
            }
        }
        .ornament(
            attachmentAnchor: .scene(
                UnitPoint3D(
                    x: 0.5,
                    y: LayoutConstants.sessionHUDSceneAnchorY,
                    z: 0.5
                )
            ),
            contentAlignment: .bottom
        ) {
            SessionHUDView(
                currentTicketIndex: model.currentTicketIndex,
                totalTicketCount: model.sessionTickets.count,
                phase: model.currentPhase
            )
        }
        .ornament(
            attachmentAnchor: .scene(
                UnitPoint3D(
                    x: 0.5,
                    y: LayoutConstants.interactionHintSceneAnchorY,
                    z: 0.5
                )
            ),
            contentAlignment: .top
        ) {
            InteractionHintView(text: InteractionHintContent.prioritization)
        }
        .task {
            await setupScene()
        }
        .onAppear {
            isTicketInfoPresented = false
            decisionFeedback = nil
            // Eingabe nur freigeben, wenn noch keine Entscheidung getroffen wurde.
            // Kein Unlock nach View-Refresh bei bereits gespeicherter Priorität (AK-10).
            if model.selectedPriority == nil {
                model.unlockInput()
                feedbackTaskStarted = false
                DebugManager.log(.state, "PrioritizationView erschienen, Input freigegeben")
            } else {
                DebugManager.log(.state, "PrioritizationView erschienen, Prioritaet bereits gespeichert: \(model.selectedPriority!.rawValue)")
            }
        }
        .onChange(of: model.currentPhase) { _, _ in
            isTicketInfoPresented = false
            decisionFeedback = nil
        }
        // MARK: Modul 010 — Prioritätsfeedback und automatischer Übergang (F-11 / F-12 / F-13)
        .onChange(of: model.selectedPriority) { _, newPriority in
            guard newPriority != nil, !feedbackTaskStarted else { return }
            feedbackTaskStarted = true
            Task { @MainActor in
                // 1. Genau einmal bewerten.
                guard let isCorrect = model.evaluatePriority() else {
                    DebugManager.log(.state, "Prioritaetsbewertung war No-Op — Task beendet")
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
                guard model.currentPhase == .priorisieren else {
                    DebugManager.log(.state, "Prioritaets-Task: Phase hat sich geaendert, kein Uebergang")
                    return
                }
                // 6. In Teamphase wechseln.
                model.beginTeamAssignmentPhase()
                DebugManager.log(.state, "Prioritaets-Feedbacktask abgeschlossen → teamZuordnen")
            }
        }
        }
    }

    // MARK: - Panel-Beschriftung

    /// Beschriftung eines Zielpanels.
    ///
    /// Größer als die frühere Label-Zeile und mit Schlagschatten, damit sie auch aus
    /// schräger Perspektive und vor der halbtransparenten Panelfläche klar lesbar bleibt.
    /// `allowsHitTesting(false)`, damit der Text die Zieh-Geste des Monsters nicht abfängt.
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

    /// Farbe eines Zielpanels.
    ///
    /// Rein zur Unterscheidbarkeit der drei Stationen. Die Farbe sagt nichts über richtig
    /// oder falsch — sie entspricht der fachlichen Prioritätsstufe, die die Nutzerin
    /// ohnehin liest.
    private func panelTint(for targetID: String) -> UIColor {
        switch PriorityTargetMapping.priority(for: targetID) {
        case .normal:   return .systemGreen
        case .wichtig:  return .systemOrange
        case .kritisch: return .systemRed
        case .none:     return .systemGray
        }
    }

    // MARK: - Szenenaufbau

    /// Erzeugt die drei Zielpanels und lädt das Monster asynchron.
    private func setupScene() async {
        // Drei Zielstationen aufbauen — noch ohne Bemaßung, die folgt aus der Messung.
        if targetEntities.isEmpty {
            for targetDef in PriorityTargetMapping.allTargets {
                let entity = TargetPanelFactory.makeTarget(
                    id: targetDef.id,
                    debugName: targetDef.priority.displayName
                )
                // Rückfallposition, bis Volume und Monster vermessen sind.
                entity.position = targetDef.position
                targetEntities.append(entity)
                DebugManager.log(.spawning, "Prioritaetsziel bereit: \(targetDef.id)")
            }
        }

        await loadCurrentMonster()
    }

    /// Laedt nur das Monster. Bestehende Zielpanels bleiben unveraendert erhalten.
    private func loadCurrentMonster() async {
        guard let ticket = model.currentTicket else {
            DebugManager.log(.spawning, "Kein aktives Ticket — Monster-Load abgebrochen")
            loadError = "Kein aktives Ticket."
            return
        }
        guard monsterLoadRecovery.begin(assetID: ticket.monsterAssetId) else { return }
        loadError = nil
        monsterEntity = nil
        DebugManager.log(.spawning, "Monster-Retry/Laden gestartet: \(ticket.monsterAssetId)")

        do {
            let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
            // Größe aus den tatsächlichen Modellmaßen ableiten statt aus einem festen Faktor —
            // sonst ist die physische Größe je Blender-Export unterschiedlich.
            MonsterAssetProvider.fit(entity, toMaxExtent: LayoutConstants.monsterDragDropTargetSize)
            entity.position = PrioritizationConstants.monsterStartPosition
            originTransform = entity.transform
            MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)
            monsterEntity = entity
            monsterLoadRecovery.finishSuccessfully()

            // Tatsächliche sichtbare Hülle messen — Grundlage für den sicheren
            // Zieh-Bereich, für die Panelhöhe und für die 50-%-Prüfung.
            geometry.measureMonster(entity, assetID: ticket.monsterAssetId)
            syncPanels()

            DebugManager.log(.spawning, "Monster-Retry/Laden erfolgreich: \(ticket.monsterAssetId), Modus: dragDrop")
        } catch {
            monsterLoadRecovery.finishWithFailure()
            DebugManager.log(.spawning, "Monster-Retry/Laden fehlgeschlagen: \(error.localizedDescription)")
            loadError = "Monster konnte nicht geladen werden."
        }
    }

    // MARK: - Geometrie (Modul 013)

    /// Misst das tatsächliche Volume und die Layoutebene.
    ///
    /// Wird sowohl beim Aufbau als auch bei jedem `RealityView`-Update aufgerufen, damit
    /// eine Größenänderung des Volumes sofort in Zieh-Grenzen und Panelraster einfließt.
    /// Der Zustand wird nur geschrieben, wenn sich die Messung tatsächlich geändert hat —
    /// sonst entstünde eine Update-Schleife.
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
    ///
    /// Setzt Mesh, Position und Trefferfläche aus **einer** Quelle — sichtbares Panel und
    /// Drop-Zone bleiben dadurch deckungsgleich.
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

        for targetDef in PriorityTargetMapping.allTargets {
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
    ///
    /// Nutzt dieselbe Auswertung wie der Drop selbst. Das Highlight kann dadurch nie etwas
    /// anderes ankündigen, als beim Loslassen tatsächlich passiert. Es speichert nichts
    /// und sagt nichts über richtig oder falsch.
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

        // Position bei Gestenbeginn merken — Grundlage für die relative Bewegung.
        //
        // Bewusst `entity.position` (lokal, also relativ zur Elternentity) statt
        // `position(relativeTo: nil)` (Weltraum). Lokal ist der Raum, in dem sämtliche
        // Geometrie dieser Phase formuliert ist.
        let start = dragStartPosition ?? entity.position
        if dragStartPosition == nil {
            dragStartPosition = start
            DebugManager.log(.input, "[Monster Transform BEFORE DRAG] \(entity.dragStateSummary)")
            // Kontrollausgabe zum Koordinatenraum (Modul 014 / Phase 6 geprüft).
            //
            // Erwartet wird **kein** identisches Wertepaar: `entity.position` ist die
            // Position im Raum der Elternentity (Szenenwurzel des `RealityView`),
            // `position(relativeTo: nil)` die im Weltraum. Beide unterscheiden sich um
            // die Platzierung des volumetrischen Fensters — im Simulatortrace vom
            // 27.08.2026 konstant um +0.1176 m in Z, X und Y identisch.
            //
            // Entscheidend ist nur, dass **beide Seiten derselben Rechnung** im selben
            // Raum liegen: `content.convert(_:from: .local, to: .scene)` liefert die
            // Volume-Grenzen im Raum der Szenenwurzel, und dort liegt wegen
            // `content.add(_:)` auch `entity.position`. Weltkoordinaten werden in
            // produktivem Code nirgends mit Volume-Grenzen verrechnet — sie erscheinen
            // ausschließlich in dieser Ausgabe und im DROP-DEBUG-Trace.
            //
            // Ein Z-Versatz zwischen local und world ist deshalb erwartungsgemäß und
            // **kein** Fehler, der „korrigiert" werden dürfte.
            DebugManager.log(
                .physics,
                "Raumprobe: local=\(entity.position) world=\(entity.position(relativeTo: nil))"
            )
        }

        // Planare Bewegung: X/Y folgen der Geste, Z bleibt auf der Starttiefe.
        // Nur die Translation wird geschrieben — Rotation und Scale der Entity bleiben
        // unangetastet. Die Blender-Y-up-Korrektur und die Einpassung aus
        // `MonsterAssetProvider` überstehen das Ziehen dadurch unverändert.
        let requested = PlanarDrag.requestedPosition(
            from: start,
            translation: value.gestureValue.translation
        )

        if let allowed = geometry.clamped(requested) {
            // Grenze aus gemessenem Volume minus gemessener Monsterhülle minus Padding.
            // Wirkt an allen vier Rändern und achsenweise unabhängig, sodass das Monster an
            // einer Ecke entlang der jeweils freien Achse weitergleitet.
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
            // Rückfallebene, solange Volume oder Monster noch nicht vermessen sind
            // (erster Layoutdurchlauf).
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

        // Flächenbasierte Auswertung: mindestens `minimumDropOverlapRatio` der projizierten
        // Monsterfläche muss auf der Panelfläche liegen, und der Z-Spalt muss innerhalb der
        // Toleranz sein. Gerechnet wird in Szenen-Koordinaten, nicht in Bildkoordinaten —
        // der Blickwinkel ändert das Ergebnis nicht.
        // Der Zustand, den das Highlight zuletzt angezeigt hat — vor jedem Zurücksetzen
        // gesichert, damit der Trace „vor dem Release" und „beim Release" vergleichen kann.
        let highlightBeforeRelease = highlightedTargetID

        var hit: String? = nil
        if geometry.canEvaluateOverlap {
            hit = geometry.logDropTrace(
                view: "Priorisierung",
                monster: entity,
                at: dropped,
                highlightBeforeRelease: highlightBeforeRelease,
                inputLocked: model.isInputLocked,
                alreadyCommitted: model.selectedPriority != nil
            )?.id
        } else {
            DebugManager.log(
                .physics,
                "=== DROP DEBUG === Priorisierung: Geometrie noch nicht vermessen (metrics oder Monster-Bounds fehlen) — Kette bricht vor der Auswertung ab, Drop ungueltig"
            )
        }

        clearHighlight()

        if let hitID = hit {
            if let priority = PriorityTargetMapping.priority(for: hitID) {
                model.savePriority(priority)
                DebugManager.log(.state, "Prioritaet gespeichert: \(priority.rawValue), isInputLocked=\(model.isInputLocked)")
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
    ///
    /// `originTransform` ist der **lokale** Transform, wie er in `setupScene` gesichert
    /// wurde (Position, Rotation, Skalierung). Deshalb wird auch relativ zur Elternentity
    /// zurückgesetzt. `move(to:)` überträgt Translation, Rotation und Scale gemeinsam — es
    /// wird kein neuer `Transform(translation:)` gebaut, bei dem Rotation oder Scale
    /// verloren gingen.
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
    return PrioritizationView()
        .environment(model)
}
