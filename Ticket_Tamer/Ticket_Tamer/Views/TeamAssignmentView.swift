import RealityKit
import simd
import Spatial
import SwiftUI

// MARK: - Ziel-ID → SupportTeam Mapping (Modul 009 — F-09 / AK-09)

/// Zentrale Zuordnung der vier technischen Ziel-IDs auf `SupportTeam`-Werte.
///
/// `internal` (kein expliziter Modifier), damit automatisierte Tests das Mapping
/// direkt prüfen können. Technische IDs erscheinen nie in der Benutzeroberfläche;
/// sichtbar sind ausschließlich die deutschen `SupportTeam.displayName`-Werte.
enum TeamTargetMapping {

    // MARK: - Ziel-Descriptor

    struct TargetDefinition {
        /// Fachlich neutrale technische Ziel-ID (erscheint nie in der UI).
        let id: String
        /// Fachlicher Team-Wert.
        let team: SupportTeam
        /// Räumliche Position im Volume-Koordinatensystem.
        let position: SIMD3<Float>
    }

    // MARK: - Vollständige Zielliste

    /// Genau vier Teamstationen — nicht mehr, nicht weniger.
    ///
    /// Positionen aus `TeamAssignmentConstants`: 2×2-Layout.
    /// Alle Abstände > 2 × `InteractionConstants.dropTargetRadius` — keine Überschneidung.
    static let allTargets: [TargetDefinition] = [
        .init(id: "team_netzwerk",  team: .netzwerk,  position: TeamAssignmentConstants.targetPositionNetzwerk),
        .init(id: "team_konto",     team: .konto,     position: TeamAssignmentConstants.targetPositionKonto),
        .init(id: "team_software",  team: .software,  position: TeamAssignmentConstants.targetPositionSoftware),
        .init(id: "team_hardware",  team: .hardware,  position: TeamAssignmentConstants.targetPositionHardware),
    ]

    // MARK: - Mapping

    /// Gibt das `SupportTeam` für eine technische Ziel-ID zurück, oder `nil` bei unbekannter ID.
    static func team(for targetID: String) -> SupportTeam? {
        allTargets.first { $0.id == targetID }?.team
    }

    /// Gibt die technische Ziel-ID für ein `SupportTeam` zurück.
    ///
    /// Nötig, damit das sichtbare Label seinen gemessenen Rahmen unter derselben ID
    /// meldet, unter der die zugehörige `DropTargetComponent` registriert ist.
    static func targetID(for team: SupportTeam) -> String? {
        allTargets.first { $0.team == team }?.id
    }
}

// MARK: - Teamzuordnungsansicht (Modul 009 — F-09 / AK-09 / AK-10)

/// Räumliche Teamzuordnungsansicht für `GamePhase.teamZuordnen`.
///
/// Zeigt das Monster des aktuellen Tickets und vier klar mit deutschen Bezeichnungen
/// beschriftete Teamstationen (Netzwerk, Konto, Software, Hardware) in einem 2×2-Layout.
/// Das Monster ist per Blickfokus, Pinch und Drag interaktiv.
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
    ///
    /// Die Bewegung wird relativ zu diesem Wert berechnet (`PlanarDrag`), damit die
    /// Tiefenebene erhalten bleibt. `nil`, solange keine Geste läuft.
    @State private var dragStartPosition: SIMD3<Float>? = nil
    @State private var loadError: String? = nil

    // MARK: - Modul 013: gemessene Drag-/Drop-Geometrie

    /// Gemeinsame Geometriequelle beider Zieh-Phasen — identisch zur Priorisierungsphase.
    ///
    /// Beide Ansichten hatten dieselbe technische Ursache (geratene statt gemessener
    /// Grenzen) und teilen sich deshalb bewusst dieselbe Lösung.
    @State private var geometry = MonsterDragGeometry()

    /// Rahmen der sichtbaren Team-Labels in Punkten, je Ziel-ID.
    @State private var labelFrames: [String: CGRect] = [:]

    /// Verhindert, dass die Grenz-Debugausgabe während einer Geste in jedem Frame erscheint.
    @State private var clampLogged: Bool = false

    /// Benannter Koordinatenraum, in dem die Label-Rahmen gemessen werden.
    private static let layoutSpace = "teamAssignmentLayout"

    // MARK: - Modul 010: Feedback-Zustand

    /// Verhindert mehrfachen Task-Start bei View-Refresh nach gespeichertem Team.
    @State private var feedbackTaskStarted: Bool = false
    /// Lokale Audio-Kapselung — kein globaler Service-Locator.
    @State private var audioService = AudioService()

    // MARK: - Body

    var body: some View {
        // Siehe `PrioritizationView`: der Layoutrahmen aus `GeometryReader3D` zusammen mit
        // `content.convert(_:from:to:)` ergibt die tatsächliche Volume-Größe in Metern.
        GeometryReader3D { proxy in
        ZStack(alignment: .top) {
            // 3D-Szene
            // update: liest monsterEntity und targetEntities direkt — notwendig damit
            // RealityKit den Closure nach @State-Änderungen erneut ausführt (AK-09 Fix).
            RealityView { content in
                measureVolume(proxy: proxy, content: content)
            } update: { content in
                // Direkte Reads stellen SwiftUI-Dependency-Tracking sicher.
                let currentMonster  = monsterEntity
                let currentTargets  = targetEntities

                for entity in currentTargets where entity.scene == nil {
                    content.add(entity)
                }
                if let monster = currentMonster, monster.scene == nil {
                    content.add(monster)
                }

                measureVolume(proxy: proxy, content: content)
            }
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in handleDragChanged(value: value) }
                    .onEnded { value in handleDragEnded(value: value) }
            )

            // Deutsche Labels für die vier Teamstationen.
            // Als ZStack-Overlay — zuverlässig ohne Attachment-API (analog zu 008-Fix).
            // 2×2-Grid: oben Netzwerk/Konto, unten Software/Hardware.
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    teamLabel(for: .netzwerk)
                    teamLabel(for: .konto)
                }
                Spacer()
                HStack(spacing: 8) {
                    teamLabel(for: .software)
                    teamLabel(for: .hardware)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)

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
        }
        .coordinateSpace(.named(Self.layoutSpace))
        .onPreferenceChange(TargetFramePreferenceKey.self) { frames in
            Task { @MainActor in
                labelFrames = frames
                syncTargetGeometry()
            }
        }
        .task {
            await setupScene()
        }
        .onAppear {
            // Eingabe nur freigeben, wenn noch keine Teamentscheidung getroffen wurde.
            // Kein Unlock nach View-Refresh bei bereits gespeichertem Team (AK-10).
            // beginTeamAssignmentPhase() übernimmt das initiale Unlock; dieser Guard
            // schützt vor erneutem Entsperren bei View-Refresh nach saveTeam(_:).
            if model.selectedTeam != nil {
                DebugManager.log(.state, "TeamAssignmentView erschienen, Team bereits gespeichert: \(model.selectedTeam!.rawValue)")
            } else {
                feedbackTaskStarted = false
                DebugManager.log(.state, "TeamAssignmentView erschienen, Phase: \(model.currentPhase)")
            }
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
                // 2. Genau einen Sound abspielen.
                audioService.play(isCorrect ? .correct : .incorrect)
                // 3. Eingabe bleibt gesperrt; Szene steht (kein visuelles Feedback-Label).
                // 4. Warten.
                try? await Task.sleep(for: .seconds(FeedbackConstants.feedbackTransitionDelay))
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

    // MARK: - Label-Subview

    /// Sichtbares deutsches Label für eine Teamstation.
    ///
    /// `lineLimit(1)` + `minimumScaleFactor` verhindern Silbentrennung in schmalen Spalten.
    @ViewBuilder
    private func teamLabel(for team: SupportTeam) -> some View {
        Text(team.displayName)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(LayoutConstants.targetLabelMinimumScaleFactor)
            .allowsTightening(true)
            .padding(.horizontal, LayoutConstants.targetLabelHorizontalPadding)
            .padding(.vertical, LayoutConstants.targetLabelVerticalPadding)
            .background(
                labelColor(for: team).opacity(LayoutConstants.targetLabelBackgroundOpacity),
                in: RoundedRectangle(cornerRadius: LayoutConstants.targetLabelCornerRadius)
            )
            // Bewusst **vor** `.frame(maxWidth: .infinity)`: gemeldet wird der Rahmen der
            // sichtbaren farbigen Fläche, nicht der der unsichtbaren Spaltenbreite. Die
            // Beschriftung bleibt an ihrer Layoutposition, nur das DropTarget richtet sich
            // danach aus.
            .reportTargetFrame(
                id: TeamTargetMapping.targetID(for: team) ?? team.rawValue,
                in: .named(Self.layoutSpace)
            )
            .frame(maxWidth: .infinity)
    }

    /// Hintergrundfarbe je Team — visuell unterscheidbar, keine Bewertungssignale.
    ///
    /// Keine Ampelfarben: keine Farbe suggeriert richtig/falsch oder besser/schlechter.
    private func labelColor(for team: SupportTeam) -> Color {
        switch team {
        case .netzwerk:  return .blue
        case .konto:     return .purple
        case .software:  return .teal
        case .hardware:  return .indigo
        }
    }

    // MARK: - Szenenaufbau

    /// Erzeugt die vier Teamstationen und lädt das Monster asynchron.
    private func setupScene() async {
        // Vier Teamstationen aufbauen.
        for targetDef in TeamTargetMapping.allTargets {
            let entity = Entity()
            entity.name = "teamTarget_\(targetDef.id)"
            entity.position = targetDef.position
            entity.components.set(
                DropTargetComponent(
                    id: targetDef.id,
                    radius: InteractionConstants.dropTargetRadius,
                    debugName: targetDef.team.displayName
                )
            )

            // Bewusst KEINE sichtbare Zielkugel mehr.
            //
            // Hier hing eine halbtransparente Kugel am Zielentity. Solange die Zielentity
            // bei festen Meterwerten stand, war das ein eigenständiges drittes Element:
            // sichtbare Beschriftung oben/unten, farbige Kugel in der Mitte, unsichtbarer
            // Trefferbereich um die Kugel. Für die Nutzerin war damit nicht erkennbar,
            // worauf sie das Monster eigentlich ziehen soll.
            //
            // Seit dem Modul-013-Randfix liegt die Trefferfläche deckungsgleich auf der
            // sichtbaren Beschriftung (siehe `MonsterDragGeometry.updateTargets`). Die
            // Kugel würde jetzt mitten auf dem Label sitzen und dessen Text verdecken.
            // Sichtbares Ziel ist deshalb — wie in der Priorisierungsphase — allein die
            // Beschriftung. Damit verhalten sich beide Phasen identisch.
            targetEntities.append(entity)
            DebugManager.log(.spawning, "Teamstation bereit: \(targetDef.id) an \(targetDef.position)")
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
            // Zieh-Bereich und für die Überlappungsprüfung beim Loslassen.
            geometry.measureMonster(entity, assetID: ticket.monsterAssetId)
            syncTargetGeometry()

            DebugManager.log(.spawning, "Monster bereit: \(ticket.monsterAssetId), Modus: dragDrop")
        } catch {
            DebugManager.log(.spawning, "Monster-Load fehlgeschlagen: \(error.localizedDescription)")
            loadError = "Monster konnte nicht geladen werden."
        }
    }

    // Hinweis: `uiColor(for:)` ist entfallen. Die Funktion lieferte ausschließlich den
    // Tint für das `SimpleMaterial` der entfernten Zielkugeln. Die sichtbaren Teamfarben
    // kommen aus `labelColor(for:)`.

    // MARK: - Geometrie (Modul 013 — Drag-/Drop-Randfix)

    /// Misst das tatsächliche Volume und die Layoutebene.
    ///
    /// Identisch zur Priorisierungsphase — dieselbe Ursache, dieselbe Lösung.
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
            syncTargetGeometry()
        }
    }

    /// Richtet die technischen DropTargets auf die gemessenen Rahmen der sichtbaren
    /// Labels aus. Die Labels selbst werden nicht bewegt.
    private func syncTargetGeometry() {
        geometry.updateTargets(
            labelFrames: labelFrames,
            entities: targetEntities,
            dropPlaneZ: TeamAssignmentConstants.monsterStartPosition.z
        )
    }

    // MARK: - Gesture-Handler

    private func handleDragChanged(value: EntityTargetValue<DragGesture.Value>) {
        guard !model.isInputLocked else {
            DebugManager.log(.input, "Drag ignoriert: Input gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        // Position bei Gestenbeginn merken — Grundlage für die relative Bewegung.
        //
        // Lokaler Raum (`entity.position`) statt Weltraum, identisch zur Priorisierungsphase:
        // Start- und Zielpositionen dieser Phase sind ebenfalls lokal gesetzt. Die frühere
        // Mischung beider Räume verursachte den fehlerhaften Rücksprung.
        let start = dragStartPosition ?? entity.position
        if dragStartPosition == nil {
            dragStartPosition = start
            DebugManager.log(.input, "[Monster Transform BEFORE DRAG] \(entity.dragStateSummary)")
            // Kontrollausgabe: lokale und Weltposition müssen übereinstimmen — siehe
            // gleichnamige Ausgabe in `PrioritizationView`.
            DebugManager.log(
                .physics,
                "Raumprobe: local=\(entity.position) world=\(entity.position(relativeTo: nil))"
            )
        }

        // Planare Bewegung auf konstanter Tiefe — identisch zur Priorisierungsphase.
        // Die frühere Übernahme der absoluten Zeigerposition (`location3D` → `.scene`)
        // schrieb die Handtiefe direkt in die Entity: Sprung nach vorne beim Greifen,
        // Stehenbleiben auf Handtiefe beim Loslassen, kaum horizontaler Weg.
        // Nur die Translation wird geschrieben — Rotation und Scale bleiben unangetastet.
        let requested = PlanarDrag.requestedPosition(
            from: start,
            translation: value.gestureValue.translation
        )

        if let allowed = geometry.clamped(requested) {
            // Einmal je Geste protokollieren, sobald die Grenze tatsächlich greift.
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

            // Grenze aus gemessenem Volume minus gemessener Monsterhülle minus Padding.
            // Wirkt an allen vier Rändern und achsenweise unabhängig — an einer Ecke
            // gleitet das Monster entlang der jeweils freien Achse weiter.
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
    }

    private func handleDragEnded(value: EntityTargetValue<DragGesture.Value>) {
        // Immer zuerst: die Geste ist beendet, der gemerkte Startpunkt gilt nicht mehr.
        dragStartPosition = nil
        clampLogged = false

        guard !model.isInputLocked else {
            DebugManager.log(.input, "Release ignoriert: Input bereits gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        // Überlappungsbasierte Auswertung — identisch zur Priorisierungsphase.
        //
        // `evaluateNearest` teilte zuvor die gesamte erreichbare Fläche unter den vier
        // Stationen auf: jede Ablage jenseits von 0.15 m Bewegung traf zwangsläufig eine
        // davon, auch eine Ablage genau zwischen zwei Stationen. `evaluateOverlap` verlangt
        // stattdessen, dass die sichtbare Monsterhülle die sichtbare Zielfläche
        // ausreichend überdeckt.
        let origin = originTransform?.translation ?? TeamAssignmentConstants.monsterStartPosition
        let dropped = entity.position

        DebugManager.log(.physics, "[Monster Transform AT RELEASE] \(entity.dragStateSummary)")
        DebugManager.log(.physics, "Drop bei \(dropped), Start \(origin)")

        let hit: String?
        if geometry.canEvaluateOverlap {
            hit = geometry.hitTarget(at: dropped)
        } else {
            // Rückfallebene, solange die Label-Rahmen noch nicht gemessen sind.
            let descriptors: [DropEvaluator.TargetDescriptor] = targetEntities.compactMap { e in
                guard let comp = e.components[DropTargetComponent.self] else { return nil }
                return DropEvaluator.TargetDescriptor(
                    id: comp.id,
                    position: e.position,
                    radius: comp.radius
                )
            }
            hit = DropEvaluator.evaluateNearest(
                entityPosition: dropped,
                origin: origin,
                targets: descriptors,
                minimumDistance: TeamAssignmentConstants.minimumDropDistance
            )
            DebugManager.log(.physics, "Fallback-Auswertung (Geometrie noch nicht vermessen)")
        }

        if let hitID = hit {
            DebugManager.log(.physics, "Gueltiger Drop: Ziel=\(hitID)")
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

    private func returnMonsterToOrigin(entity: Entity) {
        // `originTransform` ist der lokale Transform aus `setupScene` (Position, Rotation,
        // Skalierung). Deshalb auch relativ zur Elternentity zurücksetzen — vorher stand
        // hier `relativeTo: nil`, also der Weltraum. Identischer Fix wie in der
        // Priorisierungsphase; beide Ansichten hatten dieselbe Ursache.
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
