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
    ///
    /// Einzige Stelle im Code, an der Ziel-ID auf fachlichen Wert übersetzt wird.
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
/// **Gültiger Drop:** `SessionModel.savePriority(_:)` speichert die Priorität genau einmal
/// und setzt den Input-Lock. Weitere Gesten werden ignoriert.
///
/// **Ungültiger Drop:** Monster kehrt mit Animation zur Ausgangsposition zurück.
/// Kein Zustandswechsel, kein Lock.
///
/// **Keine automatische Phasenweiterleitung** — das gehört Modul 010 (F-13).
/// **Keine Bewertung** gegen `referencePriority` — das gehört Modul 010.
/// **Keine Teamstationen** — das gehört Modul 009.
@MainActor
struct PrioritizationView: View {

    // MARK: - Environment

    @Environment(SessionModel.self) private var model

    // MARK: - Scene State

    /// Geladene Monster-Entity oder `nil` bei Ladefehler.
    @State private var monsterEntity: Entity? = nil

    /// Ziel-Entities, parallel zu `PriorityTargetMapping.allTargets` indiziert.
    @State private var targetEntities: [Entity] = []

    /// Ausgangstransformation des Monsters — einmalig nach dem Laden gesetzt.
    /// Dient der Rücksetzung nach ungültigem Drop; driftet nicht.
    @State private var originTransform: Transform? = nil

    /// Fehlermeldung bei nicht ladbarem Monster oder fehlendem Ticket.
    @State private var loadError: String? = nil

    // MARK: - Body

    var body: some View {
        RealityView { _, _ in
            // Szene wird via update: aufgebaut, nachdem Entities asynchron bereit sind.
        } update: { content, attachments in
            addEntitiesIfNeeded(to: content, attachments: attachments)
        } attachments: {
            Attachment(id: "label_priority_normal") {
                priorityLabel(TicketPriority.normal.displayName)
            }
            Attachment(id: "label_priority_wichtig") {
                priorityLabel(TicketPriority.wichtig.displayName)
            }
            Attachment(id: "label_priority_kritisch") {
                priorityLabel(TicketPriority.kritisch.displayName)
            }
        }
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in handleDragChanged(value: value) }
                .onEnded { value in handleDragEnded(value: value) }
        )
        .overlay(alignment: .top) {
            if let error = loadError {
                // Klare lokale Fehlerdarstellung bei Ladefehlern (kein Crash, kein Auto-Wechsel).
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 12)
            }
        }
        .task {
            await setupScene()
        }
        .onAppear {
            // Eingabe nur freigeben, wenn noch keine Entscheidung getroffen wurde.
            // Verhindert unkontrolliertes Unlock nach View-Refresh bei bereits gespeicherter
            // Priorität (AK-10: Lock nach gültigem Drop muss stabil bleiben).
            if model.selectedPriority == nil {
                model.unlockInput()
                DebugManager.log(.state, "PrioritizationView erschienen, Input freigegeben fuer neue Entscheidung")
            } else {
                DebugManager.log(.state, "PrioritizationView erschienen, Prioritaet bereits gespeichert: \(model.selectedPriority!.rawValue)")
            }
        }
    }

    // MARK: - Label-Subview

    /// Sichtbares deutsches Label für ein Prioritätsziel.
    private func priorityLabel(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .glassBackgroundEffect()
    }

    // MARK: - Szenenaufbau

    /// Erzeugt die drei Prioritätsziele und lädt das Monster asynchron.
    ///
    /// Wird einmalig nach dem Erscheinen der View via `.task` gerufen.
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
            // Sichtbarer Trefferbereich als halbtransparente Kugel.
            let mesh = MeshResource.generateSphere(radius: InteractionConstants.dropTargetRadius)
            var material = SimpleMaterial()
            material.color = .init(tint: .white.withAlphaComponent(0.15))
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
            // Ausgangstransformation einmalig festhalten — driftet nicht bei Drops.
            originTransform = entity.transform
            // Volles Drag-/Drop-Gameplay: InputTarget + Collision + Hover.
            MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)
            monsterEntity = entity
            DebugManager.log(
                .spawning,
                "Monster bereit: \(ticket.monsterAssetId), Position: \(PrioritizationConstants.monsterStartPosition), Modus: dragDrop"
            )
        } catch {
            DebugManager.log(.spawning, "Monster-Load fehlgeschlagen: \(error.localizedDescription)")
            loadError = "Monster konnte nicht geladen werden."
        }
    }

    // MARK: - RealityView-Update

    /// Fügt Entities und Label-Attachments zur Szene hinzu, sobald sie bereit sind.
    private func addEntitiesIfNeeded(to content: RealityViewContent, attachments: RealityViewAttachments) {
        // Prioritätsziele und ihre Labels.
        for (index, entity) in targetEntities.enumerated() where entity.scene == nil {
            content.add(entity)

            // Label-Attachment oberhalb des Ziels verankern.
            let targetDef = PriorityTargetMapping.allTargets[index]
            let labelKey = "label_\(targetDef.id)"
            if let labelEntity = attachments.entity(for: labelKey) {
                labelEntity.position = SIMD3(0, PrioritizationConstants.labelYOffset, 0)
                entity.addChild(labelEntity)
                DebugManager.log(.spawning, "Label-Attachment verankert: \(labelKey)")
            }
        }

        // Monster.
        if let monster = monsterEntity, monster.scene == nil {
            content.add(monster)
        }
    }

    // MARK: - Gesture-Handler

    /// Verschiebt das Monster während des Drags (nur wenn nicht gesperrt).
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

    /// Wertet den Drop aus:
    /// - Gültiger Drop → Ziel-ID auf `TicketPriority` mappen → `savePriority` → Lock.
    /// - Ungültiger Drop → Monster kehrt zur Ausgangsposition zurück, kein Zustandswechsel.
    private func handleDragEnded(value: EntityTargetValue<DragGesture.Value>) {
        // Guard: Mehrfachauswertung nach gültigem Drop verhindern (AK-10).
        guard !model.isInputLocked else {
            DebugManager.log(.input, "Release ignoriert: Input bereits gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        // Zielbereiche aus geladenen Entities und ihren DropTargetComponents sammeln.
        let targets: [(entity: Entity, component: DropTargetComponent)] = targetEntities.compactMap { e in
            guard let comp = e.components[DropTargetComponent.self] else { return nil }
            return (entity: e, component: comp)
        }

        if let hitID = DropEvaluator.evaluate(entity: entity, targets: targets) {
            DebugManager.log(.physics, "Gültiger Drop: Ziel=\(hitID)")

            // Ziel-ID auf TicketPriority mappen.
            if let priority = PriorityTargetMapping.priority(for: hitID) {
                // Genau einmal speichern und sperren (AK-08 / AK-10).
                model.savePriority(priority)
                DebugManager.log(.state, "Prioritaet gespeichert: \(priority.rawValue), isInputLocked=\(model.isInputLocked)")
            } else {
                // Sollte nie eintreten — Ziel-ID nicht im Mapping (defensive).
                DebugManager.log(.physics, "Unbekannte Ziel-ID — kein Mapping moeglich: \(hitID)")
                returnMonsterToOrigin(entity: entity)
            }
        } else {
            // Ungültiger Drop: Monster zurücksetzen, kein Zustandswechsel (AK-10).
            returnMonsterToOrigin(entity: entity)
            DebugManager.log(.physics, "Ungültiger Drop: Monster kehrt zurueck")
            DebugManager.log(.state, "selectedPriority=\(model.selectedPriority.map(\.rawValue) ?? "nil"), isInputLocked=\(model.isInputLocked) (unveraendert)")
        }
    }

    /// Setzt das Monster mit einer Animation zur einmalig erfassten Ausgangsposition zurück.
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
