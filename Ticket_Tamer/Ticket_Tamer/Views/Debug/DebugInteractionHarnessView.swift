#if DEBUG
import RealityKit
import SwiftUI

// MARK: - DEBUG-Interaktionstestzone (Modul 007 — F-10 / AK-10)

/// DEBUG-only Testzone für Modul 007.
///
/// Zeigt das Monster des aktuellen Tickets mit vollständiger Drag-/Drop-Interaktion
/// und einem neutral beschrifteten Testziel (ID: „testTargetA"). Kein Prioritäts-
/// und kein Teamwert.
///
/// **Sichtbarkeit:** Nur in DEBUG-Builds und ausschließlich in der `.priorisieren`-Phase,
/// die im Normalbetrieb nach „Weiter zur Priorisierung" erscheint.
/// In Modul 008 wird diese View durch die echte Priorisierungsansicht ersetzt.
///
/// **Rückkehrsemantik:** Bei ungültigem Drop kehrt das Monster mit einer
/// `InteractionConstants.monsterReturnDuration`-Sekunden-Animation zur Ausgangsposition
/// zurück. Die Ausgangsposition driftet nicht: Sie wird einmalig nach dem Laden gespeichert
/// und bei keinem Drop überschrieben.
///
/// **Verbleib im finalen Modulstand:** Diese Datei bleibt in Modul 007 erhalten und wird
/// in Modul 008 durch die echte Priorisierungsansicht verdrängt. Die `#if DEBUG`-Direktive
/// in `RootVolumeView` verhindert, dass sie im Release-Build erscheint.
@MainActor
struct DebugInteractionHarnessView: View {

    // MARK: - Environment

    @Environment(SessionModel.self) private var model

    // MARK: - Scene State

    /// Geladene Monster-Entity.
    @State private var monsterEntity: Entity? = nil

    /// Neutrales Testziel (ID: testTargetA).
    @State private var targetEntity: Entity? = nil

    /// Ausgangstransformation des Monsters — einmalig nach dem Laden gesetzt.
    /// Dient der Rücksetzung nach ungültigem Drop; driftet nicht.
    @State private var originTransform: Transform? = nil

    /// Ziel-ID des letzten akzeptierten Drops (nur für DEBUG-Anzeige).
    @State private var lastAcceptedTargetID: String? = nil

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            debugHeader

            RealityView { _ in
                // Szene wird via update: aufgebaut, nachdem Entities bereit sind.
            } update: { content in
                addEntitiesIfNeeded(to: content)
            }
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in handleDragChanged(value: value) }
                    .onEnded { value in handleDragEnded(value: value) }
            )
            .frame(depth: 0.4)

            if model.isInputLocked {
                debugUnlockButton
            }
        }
        .padding()
        .task {
            await setupScene()
        }
    }

    // MARK: - Debug-Kopfzeile

    private var debugHeader: some View {
        VStack(spacing: 4) {
            Text("[DEBUG] Modul 007 — Interaktionstest")
                .font(.caption)
                .foregroundStyle(.orange)

            if model.isInputLocked {
                Text("✓ Drop akzeptiert — Ziel: \(lastAcceptedTargetID ?? "—") | isInputLocked = true")
                    .font(.caption2)
                    .foregroundStyle(.green)
            } else {
                Text("Monster greifen und auf den blauen Bereich legen")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Debug-Entsperren

    private var debugUnlockButton: some View {
        Button("Lock zurücksetzen (DEBUG)") {
            model.unlockInput()
            lastAcceptedTargetID = nil
            if let origin = originTransform, let entity = monsterEntity {
                entity.move(
                    to: origin,
                    relativeTo: nil,
                    duration: InteractionConstants.monsterReturnDuration,
                    timingFunction: .easeInOut
                )
            }
            DebugManager.log(.state, "[DEBUG] Input-Lock manuell zurückgesetzt")
        }
        .font(.caption)
    }

    // MARK: - Szenenaufbau

    /// Erzeugt Ziel-Entity und lädt Monster asynchron.
    private func setupScene() async {
        // Neutrales Testziel: ID "testTargetA", kein Prioritäts- oder Teamwert.
        let target = Entity()
        target.name = "debugTarget_testTargetA"
        // Position rechts vom Monster (x = +0.25 m).
        target.position = SIMD3(x: 0.25, y: 0, z: 0)
        target.components.set(
            DropTargetComponent(id: "testTargetA", debugName: "Debug-Ziel A")
        )
        // Sichtbarer Trefferbereich (nur DEBUG).
        let mesh = MeshResource.generateSphere(radius: InteractionConstants.dropTargetRadius)
        var material = SimpleMaterial()
        material.color = .init(tint: .blue.withAlphaComponent(0.35))
        let indicator = ModelEntity(mesh: mesh, materials: [material])
        target.addChild(indicator)
        targetEntity = target
        DebugManager.log(.spawning, "[DEBUG] Zielbereich testTargetA bereit")

        // Monster laden.
        guard let ticket = model.currentTicket else {
            DebugManager.log(.spawning, "[DEBUG] Kein aktives Ticket für Monster-Load")
            return
        }
        do {
            let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
            entity.scale = SIMD3(repeating: LayoutConstants.monsterScale)
            // Position links vom Ziel (x = –0.15 m).
            entity.position = SIMD3(x: -0.15, y: 0, z: 0)
            // Ausgangstransformation einmalig erfassen.
            originTransform = entity.transform
            // Für Gameplay konfigurieren: InputTarget + Collision + Hover.
            MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)
            monsterEntity = entity
            DebugManager.log(.spawning, "[DEBUG] Monster bereit: \(ticket.monsterAssetId), Modus: dragDrop")
        } catch {
            DebugManager.log(.spawning, "[DEBUG] Monster-Load fehlgeschlagen: \(error)")
        }
    }

    // MARK: - RealityView-Update

    /// Fügt Entities zum RealityView-Content hinzu, sobald sie verfügbar sind.
    private func addEntitiesIfNeeded(to content: RealityViewContent) {
        if let target = targetEntity, target.scene == nil {
            content.add(target)
        }
        if let monster = monsterEntity, monster.scene == nil {
            content.add(monster)
        }
    }

    // MARK: - Gesture-Handler

    /// Verschiebt das Monster während des Drags (nur wenn nicht gesperrt).
    private func handleDragChanged(value: EntityTargetValue<DragGesture.Value>) {
        guard !model.isInputLocked else {
            DebugManager.log(.input, "[DEBUG] Drag ignoriert: Input gesperrt")
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

    /// Wertet den Drop aus: gültig → Lock setzen; ungültig → Rückkehr zur Ausgangsposition.
    private func handleDragEnded(value: EntityTargetValue<DragGesture.Value>) {
        // Guard 1: Mehrfachauswertung verhindern (AK-10 Lock-Semantik).
        guard !model.isInputLocked else {
            DebugManager.log(.input, "[DEBUG] Release ignoriert: Input bereits gesperrt")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        // Zielbereiche sammeln.
        var targets: [(entity: Entity, component: DropTargetComponent)] = []
        if let t = targetEntity, let comp = t.components[DropTargetComponent.self] {
            targets.append((entity: t, component: comp))
        }

        // Drop auswerten.
        if let hitID = DropEvaluator.evaluate(entity: entity, targets: targets) {
            // Gültiger Drop: genau einmal akzeptieren, Input sperren.
            lastAcceptedTargetID = hitID
            model.lockInput()
            DebugManager.log(.physics, "[DEBUG] Gültiger Drop: Ziel=\(hitID)")
            DebugManager.log(.state, "[DEBUG] isInputLocked=\(model.isInputLocked)")
        } else {
            // Ungültiger Drop: Monster zur Ausgangsposition zurücksetzen.
            if let origin = originTransform {
                entity.move(
                    to: origin,
                    relativeTo: nil,
                    duration: InteractionConstants.monsterReturnDuration,
                    timingFunction: .easeInOut
                )
            }
            DebugManager.log(.physics, "[DEBUG] Ungültiger Drop: Monster kehrt zurück")
            DebugManager.log(.state, "[DEBUG] isInputLocked=\(model.isInputLocked) (unverändert)")
        }
    }
}

// MARK: - Preview

#Preview(windowStyle: .volumetric) {
    let model = SessionModel()
    model.setTicketCount(1)
    model.startSession(using: { $0 })
    model.beginPrioritizationPhase()
    return DebugInteractionHarnessView()
        .environment(model)
}
#endif
