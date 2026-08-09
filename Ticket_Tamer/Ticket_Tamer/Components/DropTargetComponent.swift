import RealityKit

// MARK: - Drop-Zielbereich-Komponente (Modul 007 — F-10 / AK-10)

/// Generische, fachlich neutrale Komponente zum Markieren einer Entity als gültigen Drop-Zielbereich.
///
/// Enthält bewusst keine Prioritätswerte und keine Teambezeichnungen.
/// Module 008 (Priorisierung) und 009 (Teamzuordnung) erweitern ihre konkreten Ziele
/// mit dieser Grundlage, ohne dass diese Komponente geändert werden muss.
///
/// **Registrierung:** `DropTargetComponent.registerComponent()` muss beim App-Start
/// aufgerufen werden (in `Ticket_TamerApp.init()`).
struct DropTargetComponent: Component {

    /// Stabile, fachlich neutrale Ziel-ID (z. B. „testTargetA", nie „normal" oder „netzwerk").
    let id: String

    /// Radius des sphärischen Trefferbereichs in Metern.
    ///
    /// Der Abstand zwischen Entity-Position und Ziel-Position muss ≤ radius sein,
    /// damit der Drop als gültig gilt.
    let radius: Float

    /// Optionaler Debug-Name für Logging (erscheint nie im normalen Nutzerablauf).
    let debugName: String?

    // MARK: - Init

    /// Erzeugt einen generischen Zielbereich.
    ///
    /// - Parameters:
    ///   - id: Fachlich neutrale Ziel-ID.
    ///   - radius: Trefferradius in Metern. Standard: `InteractionConstants.dropTargetRadius`.
    ///   - debugName: Optionaler Name für Debug-Ausgaben.
    init(id: String, radius: Float = InteractionConstants.dropTargetRadius, debugName: String? = nil) {
        self.id = id
        self.radius = radius
        self.debugName = debugName
    }
}
