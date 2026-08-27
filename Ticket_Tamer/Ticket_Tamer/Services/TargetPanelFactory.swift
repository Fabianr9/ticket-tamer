import RealityKit
import UIKit
import simd

// MARK: - Aufbau der 3D-Zielpanels (Modul 013 — 3D-Zielstationen)

/// Erzeugt und pflegt die flachen 3D-Zielstationen beider Zieh-Phasen.
///
/// ## Aufbau je Ziel
///
/// ```text
/// Entity  "target_<id>"                 ← trägt DropTargetComponent, Position = Panelmitte
///   ├── ModelEntity "targetPanelMesh"   ← flache Box (Breite × Höhe × 0.02 m)
///   └── ViewAttachmentEntity            ← SwiftUI-Text, knapp vor der Vorderfläche
/// ```
///
/// Die Trefferfläche (`DropTargetComponent.halfExtents`) wird aus **derselben** Größe
/// gesetzt, aus der auch das Mesh entsteht. Sichtbares Panel und technische Drop-Zone
/// können dadurch konstruktiv nicht auseinanderlaufen.
///
/// ## Keine Kollisionsgeometrie
///
/// Die Panels bekommen bewusst weder `CollisionComponent` noch `InputTargetComponent`:
/// Die Drop-Entscheidung fällt rein rechnerisch über die Bounds-Überlappung
/// (`DropEvaluator`), nicht über Collider-Berührung. Ein unsichtbarer Collider würde die
/// 50-%-Regel wieder unüberprüfbar machen. Zusätzlich könnten die Panels sonst die
/// Zieh-Geste des Monsters abfangen.
@MainActor
enum TargetPanelFactory {

    /// Name der Mesh-Kindentity innerhalb eines Ziels.
    static let meshChildName = "targetPanelMesh"

    // MARK: - Aufbau

    /// Erzeugt ein Ziel mit noch unbemaßtem Panel.
    ///
    /// Die tatsächliche Größe folgt erst, wenn Volume und Monster vermessen sind
    /// (`updateGeometry(of:size:center:tint:highlighted:)`).
    static func makeTarget(id: String, debugName: String?) -> Entity {
        let root = Entity()
        root.name = "target_\(id)"
        root.components.set(DropTargetComponent(id: id, debugName: debugName))

        let panel = ModelEntity()
        panel.name = meshChildName
        root.addChild(panel)

        return root
    }

    // MARK: - Bemaßung

    /// Setzt Position, Mesh und Trefferfläche eines Ziels.
    ///
    /// - Parameters:
    ///   - target: Die Ziel-Entity aus `makeTarget(id:debugName:)`.
    ///   - size: Panelabmessungen (Breite, Höhe, Tiefe) in Metern.
    ///   - center: Panelmittelpunkt in Szenen-Koordinaten.
    ///   - tint: Farbe des Panels. Rein zur Unterscheidbarkeit — keine Bewertungssemantik.
    ///   - highlighted: Ob das Panel gerade das gültige Ziel wäre.
    static func updateGeometry(
        of target: Entity,
        size: SIMD3<Float>,
        center: SIMD3<Float>,
        tint: UIColor,
        highlighted: Bool
    ) {
        target.position = center

        // Trefferfläche aus derselben Größe wie das Mesh — Anforderung D.
        if var component = target.components[DropTargetComponent.self] {
            component.halfExtents = size / 2
            target.components.set(component)
        }

        guard let panel = target.findEntity(named: meshChildName) as? ModelEntity else { return }

        let mesh = MeshResource.generateBox(
            width: size.x,
            height: size.y,
            depth: size.z,
            cornerRadius: Swift.min(
                LayoutConstants.targetPanelCornerRadius,
                Swift.min(size.x, size.y) / 2
            )
        )
        panel.model = ModelComponent(mesh: mesh, materials: [material(tint: tint, highlighted: highlighted)])

        applyHighlightScale(highlighted, to: target, animated: false)
    }

    // MARK: - Hover-/Valid-Feedback

    /// Hebt ein Panel hervor oder nimmt die Hervorhebung zurück.
    ///
    /// Die Hervorhebung bedeutet ausschließlich: *„Wenn du jetzt loslässt, wird dieses Ziel
    /// gewählt."* Sie sagt nichts über richtig oder falsch — die fachliche Bewertung
    /// passiert unverändert erst nach dem Drop.
    ///
    /// Bewusst zurückhaltend: etwas höhere Deckkraft und 5 % Größe, sanft übergeblendet.
    /// Kein Blinken, kein Farbwechsel, keine zusätzliche Geometrie.
    ///
    /// **Die Trefferfläche wächst dabei nicht mit.** `halfExtents` bleibt unverändert,
    /// sonst würde die Hervorhebung ihre eigene Bedingung verstärken und beim Grenzwert
    /// hin- und herspringen.
    static func setHighlighted(_ highlighted: Bool, target: Entity, tint: UIColor) {
        if let panel = target.findEntity(named: meshChildName) as? ModelEntity {
            panel.model?.materials = [material(tint: tint, highlighted: highlighted)]
        }
        applyHighlightScale(highlighted, to: target, animated: true)
    }

    private static func applyHighlightScale(_ highlighted: Bool, to target: Entity, animated: Bool) {
        let factor = highlighted ? LayoutConstants.targetHighlightScale : 1
        let scale = SIMD3<Float>(repeating: factor)

        guard animated, target.parent != nil else {
            target.scale = scale
            return
        }

        var transform = target.transform
        transform.scale = scale
        target.move(
            to: transform,
            relativeTo: target.parent,
            duration: LayoutConstants.targetHighlightDuration,
            timingFunction: .easeInOut
        )
    }

    // MARK: - Material

    /// Halbtransparentes, mattes Material in der Zielfarbe.
    ///
    /// `SimpleMaterial` statt `UnlitMaterial`: Das Panel soll auf Licht reagieren, damit
    /// seine Seitenflächen aus schräger Perspektive erkennbar sind — genau darum geht es
    /// bei der räumlichen Darstellung.
    private static func material(tint: UIColor, highlighted: Bool) -> SimpleMaterial {
        var material = SimpleMaterial()
        let opacity = highlighted
            ? LayoutConstants.targetPanelHighlightOpacity
            : LayoutConstants.targetPanelOpacity
        material.color = .init(tint: tint.withAlphaComponent(opacity))
        material.roughness = 0.9
        material.metallic = 0.0
        return material
    }
}
