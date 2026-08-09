import RealityKit

// MARK: - Interaktionsmodus (Modul 007 — F-10 / AK-10)

/// Steuert, welche Eingabekomponenten eine Monster-Entity erhält.
enum MonsterInteractionMode {
    /// Volles Gameplay: Hover-Fokus, indirekte Eingabe (Blick + Pinch), räumliches Bewegen.
    case dragDrop
    /// Nur-Ansehen: keine Eingabekomponenten. Gilt für die Untersuchungsphase (Modul 006).
    case inspectionOnly
}

// MARK: - Configurator

/// Konfiguriert Monster-Entities für visionOS-Interaktion.
///
/// Kapselt das Einrichten von `InputTargetComponent`, `CollisionComponent` und
/// `HoverEffectComponent`, damit Module 008 und 009 lediglich den Modus wählen müssen.
///
/// **Gewählte API:** Gesture-basiertes Drag (`DragGesture().targetedToAnyEntity()`) statt
/// `ManipulationComponent`. Begründung: Der explizite `.onEnded`-Callback liefert den
/// genauen Loslasszeitpunkt, der für die Drop-Auswertung (gültig/ungültig) und die
/// genau-einmal-Eingabesperre unerlässlich ist. `ManipulationComponent` abstrahiert
/// den Release-Moment zu stark und würde eine eigene Positionsüberwachung erfordern.
///
/// Die Kollisionsform ist bewusst kleiner als die sichtbare Monsteranzeige, damit
/// benachbarte Zielentities nicht unbeabsichtigt getroffen werden.
enum MonsterInteractionConfigurator {

    /// Wendet den gewählten Interaktionsmodus auf eine Entity an.
    ///
    /// - Parameters:
    ///   - entity: Die Monster-Root-Entity.
    ///   - mode: `.dragDrop` oder `.inspectionOnly`.
    static func configure(_ entity: Entity, mode: MonsterInteractionMode) {
        switch mode {
        case .dragDrop:
            // Indirekte Eingabe: Blickfokus + Pinch — kein eigenes Handtracking nötig.
            entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))

            // Kollisionsform: Kugel (radius InteractionConstants.monsterCollisionRadius).
            // Groß genug für zuverlässige Interaktion, aber kleiner als der Zielbereich,
            // damit Drop-Targets ohne Überschneidung nebeneinander existieren können.
            entity.components.set(
                CollisionComponent(
                    shapes: [.generateSphere(radius: InteractionConstants.monsterCollisionRadius)]
                )
            )

            // Natives visionOS Hover-/Fokus-Feedback ohne eigene Logik.
            entity.components.set(HoverEffectComponent())

            DebugManager.log(.input, "Monster konfiguriert: dragDrop")

        case .inspectionOnly:
            // Untersuchungsphase: alle Interaktionskomponenten entfernen.
            entity.components.remove(InputTargetComponent.self)
            entity.components.remove(CollisionComponent.self)
            entity.components.remove(HoverEffectComponent.self)

            DebugManager.log(.input, "Monster konfiguriert: inspectionOnly")
        }
    }
}
