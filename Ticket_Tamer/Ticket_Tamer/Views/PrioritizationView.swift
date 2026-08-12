import RealityKit
import SwiftUI

// MARK: - Ziel-ID → TicketPriority Mapping (Modul 008 — F-08 / AK-08)

/// Zentrale Zuordnung der drei technischen Ziel-IDs auf `TicketPriority`-Werte.
///
/// `internal` (kein expliziter Modifier), damit automatisierte Tests das Mapping
/// direkt prüfen können. Nutzerinnen und Nutzer sehen ausschließlich
/// `TicketPriority.displayName` (deutsche Labels). Technische IDs sind nie sichtbar.
enum PriorityTargetMapping {

    // MARK: - Ziel-Descriptor

    struct TargetDefinition {
        /// Fachlich neutrale technische Ziel-ID (erscheint nie in der UI).
        let id: String
        /// Fachlicher Prioritätswert.
        let priority: TicketPriority
        /// Räumliche Position im Volume-Koordinatensystem.
        let position: SIMD3<Float>
    }

    // MARK: - Vollständige Zielliste

    /// Genau drei Prioritätsziele — nicht mehr, nicht weniger.
    ///
    /// Positionen aus `PrioritizationConstants`: Abstand jeweils 0.32 m >
    /// 2 × `InteractionConstants.dropTargetRadius` (0.30 m), keine Überschneidung.
    static let allTargets: [TargetDefinition] = [
        .init(id: "priority_normal",   priority: .normal,   position: PrioritizationConstants.targetPositionNormal),
        .init(id: "priority_wichtig",  priority: .wichtig,  position: PrioritizationConstants.targetPositionWichtig),
        .init(id: "priority_kritisch", priority: .kritisch, position: PrioritizationConstants.targetPositionKritisch),
    ]

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
/// Zeigt das Monster des aktuellen Tickets und drei klar mit deutschen Bezeichnungen
/// beschriftete Prioritätsziele (Normal, Wichtig, Kritisch). Das Monster ist per
/// Blickfokus, Pinch und Drag interaktiv.
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

    // MARK: - Modul 010: Feedback-Zustand

    /// Verhindert mehrfachen Task-Start bei View-Refresh nach gespeicherter Priorität.
    @State private var feedbackTaskStarted: Bool = false
    /// Lokale Audio-Kapselung — kein globaler Service-Locator.
    @State private var audioService = AudioService()

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            // 3D-Szene
            RealityView { _ in
                // Szene wird via update: aufgebaut, nachdem Entities asynchron bereit sind.
            } update: { content in
                addEntitiesIfNeeded(to: content)
            }
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in handleDragChanged(value: value) }
                    .onEnded { value in handleDragEnded(value: value) }
            )

            // Deutsche Labels für die drei Prioritätsziele.
            // Als ZStack-Overlay — zuverlässig ohne Attachment-API.
            // Visuell mit den drei Zielkugeln ausgerichtet (links / Mitte / rechts).
            HStack(spacing: 12) {
                ForEach(PriorityTargetMapping.allTargets, id: \.id) { target in
                    priorityLabel(target.priority.displayName, priority: target.priority)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)

            // DEBUG-Einstieg in die Teamphase — nur für Entwicklung/Simulator-Prüfung.
            // Nicht im Release-Build, nicht als F-09-Nutzerfunktion (AK-09).
            // Modul 010 übernimmt den normalen zeitgesteuerten Übergang (F-13).
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
        .task {
            await setupScene()
        }
        .onAppear {
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
                // 2. Genau einen Sound abspielen.
                audioService.play(isCorrect ? .correct : .incorrect)
                // 3. Eingabe bleibt gesperrt; Szene steht (kein visuelles Feedback-Label).
                // 4. Warten.
                try? await Task.sleep(for: .seconds(FeedbackConstants.feedbackTransitionDelay))
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

    // MARK: - Label-Subview

    /// Sichtbares deutsches Label für ein Prioritätsziel.
    @ViewBuilder
    private func priorityLabel(_ text: String, priority: TicketPriority) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(labelColor(for: priority).opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
            .frame(maxWidth: .infinity)
    }

    /// Hintergrundfarbe je Priorität — visuell unterscheidbar, semantisch passend.
    private func labelColor(for priority: TicketPriority) -> Color {
        switch priority {
        case .normal:   return .green
        case .wichtig:  return .orange
        case .kritisch: return .red
        }
    }

    // MARK: - Szenenaufbau

    /// Erzeugt die drei Prioritätsziele und lädt das Monster asynchron.
    private func setupScene() async {
        // Drei Prioritätsziele aufbauen.
        for targetDef in PriorityTargetMapping.allTargets {
            let entity = Entity()
            entity.name = "priorityTarget_\(targetDef.id)"
            entity.position = targetDef.position
            entity.components.set(
                DropTargetComponent(
                    id: targetDef.id,
                    radius: InteractionConstants.dropTargetRadius,
                    debugName: targetDef.priority.displayName
                )
            )

            // Sichtbare Zielkugel mit Prioritätsfarbe.
            let mesh = MeshResource.generateSphere(radius: InteractionConstants.dropTargetRadius)
            var material = SimpleMaterial()
            material.color = .init(tint: uiColor(for: targetDef.priority).withAlphaComponent(0.55))
            let indicator = ModelEntity(mesh: mesh, materials: [material])
            entity.addChild(indicator)

            targetEntities.append(entity)
            DebugManager.log(.spawning, "Prioritaetsziel bereit: \(targetDef.id) an \(targetDef.position)")
        }

        // Monster laden.
        guard let ticket = model.currentTicket else {
            DebugManager.log(.spawning, "Kein aktives Ticket — Monster-Load abgebrochen")
            loadError = "Kein aktives Ticket."
            return
        }

        do {
            let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
            entity.scale = SIMD3(repeating: LayoutConstants.monsterScale)
            entity.position = PrioritizationConstants.monsterStartPosition
            originTransform = entity.transform
            MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)
            monsterEntity = entity
            DebugManager.log(.spawning, "Monster bereit: \(ticket.monsterAssetId), Modus: dragDrop")
        } catch {
            DebugManager.log(.spawning, "Monster-Load fehlgeschlagen: \(error.localizedDescription)")
            loadError = "Monster konnte nicht geladen werden."
        }
    }

    /// UIColor-Pendant für SimpleMaterial (je Priorität).
    private func uiColor(for priority: TicketPriority) -> UIColor {
        switch priority {
        case .normal:   return .systemGreen
        case .wichtig:  return .systemOrange
        case .kritisch: return .systemRed
        }
    }

    // MARK: - RealityView-Update

    private func addEntitiesIfNeeded(to content: RealityViewContent) {
        for entity in targetEntities where entity.scene == nil {
            content.add(entity)
        }
        if let monster = monsterEntity, monster.scene == nil {
            content.add(monster)
        }
    }

    // MARK: - Gesture-Handler

    private func handleDragChanged(value: EntityTargetValue<DragGesture.Value>) {
        guard !model.isInputLocked else {
            DebugManager.log(.input, "Drag ignoriert: Input gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        let scenePoint = value.convert(value.gestureValue.location3D, from: .local, to: .scene)
        entity.position = SIMD3<Float>(
            Float(scenePoint.x),
            Float(scenePoint.y),
            Float(scenePoint.z)
        )
    }

    private func handleDragEnded(value: EntityTargetValue<DragGesture.Value>) {
        guard !model.isInputLocked else {
            DebugManager.log(.input, "Release ignoriert: Input bereits gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        let targets: [(entity: Entity, component: DropTargetComponent)] = targetEntities.compactMap { e in
            guard let comp = e.components[DropTargetComponent.self] else { return nil }
            return (entity: e, component: comp)
        }

        if let hitID = DropEvaluator.evaluate(entity: entity, targets: targets) {
            DebugManager.log(.physics, "Gueltiger Drop: Ziel=\(hitID)")
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

    private func returnMonsterToOrigin(entity: Entity) {
        guard let origin = originTransform else { return }
        entity.move(
            to: origin,
            relativeTo: nil,
            duration: InteractionConstants.monsterReturnDuration,
            timingFunction: .easeInOut
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
