import RealityKit
import simd

// MARK: - Drop-Auswertung (Modul 007 — F-10 / AK-10)

/// Bewertet, ob ein Drop gültig oder ungültig ist.
///
/// Die positionsbasierte Kernfunktion (`evaluate(entityPosition:targets:)`) arbeitet
/// mit reinen SIMD3-Werten und ist ohne laufenden RealityKit-Render-Loop unit-testbar.
/// Die Entity-Convenience-Methode ist für den Einsatz in Gesture-Handlern gedacht.
///
/// **Strategie:** Sphärische Proximity-Prüfung im Weltkoordinatensystem.
/// Keine Bildschirmkoordinaten-Hacks, keine Physik-Simulation.
/// Bei mehreren gleichzeitig getroffenen Zielen gewinnt das räumlich nächste.
/// Konstruktiv werden Überschneidungen durch ausreichend große Abstände zwischen
/// Zielbereichen verhindert (Verantwortung der aufrufenden Phase).
enum DropEvaluator {

    // MARK: - Ziel-Descriptor (für Unit-Tests ohne RealityKit-Szene)

    /// Positionsbasierter Descriptor eines generischen Zielbereichs.
    struct TargetDescriptor {
        /// Fachlich neutrale Ziel-ID.
        let id: String
        /// Position des Zielbereichs im Weltkoordinatensystem.
        let position: SIMD3<Float>
        /// Trefferradius in Metern.
        let radius: Float
    }

    // MARK: - Positionsbasierte Auswertung (unit-testbar)

    /// Prüft, ob `entityPosition` in einem der Zielbereiche liegt.
    ///
    /// - Parameters:
    ///   - entityPosition: Weltposition der gedroppten Entity.
    ///   - targets: Zu prüfende Zielbereiche.
    /// - Returns: ID des getroffenen Ziels bei gültigem Drop, `nil` bei ungültigem Drop.
    static func evaluate(
        entityPosition: SIMD3<Float>,
        targets: [TargetDescriptor]
    ) -> String? {
        var bestID: String?
        var bestDistance = Float.infinity

        for target in targets {
            let distance = simd_distance(entityPosition, target.position)
            if distance <= target.radius, distance < bestDistance {
                bestDistance = distance
                bestID = target.id
            }
        }

        return bestID
    }

    // MARK: - Entity-Convenience (für Gesture-Handler)

    /// Prüft, ob `entity` in einem der als `DropTargetComponent` markierten Ziele liegt.
    ///
    /// Nutzt `entity.position(relativeTo: nil)` für konsistente Weltkoordinaten.
    ///
    /// - Parameters:
    ///   - entity: Die gedroppte Monster-Entity.
    ///   - targets: Paare aus Ziel-Entity und zugehöriger `DropTargetComponent`.
    /// - Returns: ID des getroffenen Ziels bei gültigem Drop, `nil` bei ungültigem Drop.
    static func evaluate(
        entity: Entity,
        targets: [(entity: Entity, component: DropTargetComponent)]
    ) -> String? {
        let entityPos = entity.position(relativeTo: nil)
        let descriptors = targets.map {
            TargetDescriptor(
                id: $0.component.id,
                position: $0.entity.position(relativeTo: nil),
                radius: $0.component.radius
            )
        }
        return evaluate(entityPosition: entityPos, targets: descriptors)
    }
}
