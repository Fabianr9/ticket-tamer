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
            // InputTarget und Collision auf dem Wrapper-Root (der das visuelle Zentrum trägt).
            entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))

            // Kollisionsform: Kugel am Wrapper-Origin = visuelles Zentrum (nach wrapAndCenter).
            // Größer als früher (0.12 m) damit das Greifen bei Skalierung 0.08–0.10 zuverlässig ist.
            entity.components.set(
                CollisionComponent(
                    shapes: [.generateSphere(radius: InteractionConstants.monsterCollisionRadius)]
                )
            )

            // HoverEffect auf Root (für Gesten-Erkennung) und auf alle Mesh-Kinder
            // (für das native visionOS-Leucht-Feedback, das nur auf ModelComponents wirkt).
            entity.components.set(HoverEffectComponent())
            applyHoverEffectToDescendants(entity)

            DebugManager.log(.input, "Monster konfiguriert: dragDrop")

        case .inspectionOnly:
            // Untersuchungsphase: alle Interaktionskomponenten entfernen.
            entity.components.remove(InputTargetComponent.self)
            entity.components.remove(CollisionComponent.self)
            entity.components.remove(HoverEffectComponent.self)

            DebugManager.log(.input, "Monster konfiguriert: inspectionOnly")
        }
    }

    // MARK: - HoverEffect-Propagation

    /// Setzt `HoverEffectComponent` rekursiv auf alle Kindentities mit Geometrie.
    ///
    /// Der Wrapper-Root (keine Geometrie) zeigt den nativen visionOS-Hover-Effekt nicht,
    /// weil der Effekt eine `ModelComponent` voraussetzt. Durch das Setzen auf Mesh-Kinder
    /// leuchten die sichtbaren Modellteile beim Anblicken korrekt auf.
    private static func applyHoverEffectToDescendants(_ entity: Entity) {
        for child in entity.children {
            if child.components.has(ModelComponent.self) {
                child.components.set(HoverEffectComponent())
            }
            applyHoverEffectToDescendants(child)
        }
    }
}
