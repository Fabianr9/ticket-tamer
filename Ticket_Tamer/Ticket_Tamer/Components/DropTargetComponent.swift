import RealityKit
import simd

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
    /// **Nur noch für die radiusbasierte Auswertung** (`DropEvaluator.evaluate`) und die
    /// bestehenden Tests. Die Views werten seit dem Modul-013-Randfix über die
    /// X/Y-Überlappung von `halfExtents` aus — siehe `DropEvaluator.evaluateOverlap`.
    let radius: Float

    /// Halbe Kantenlängen der **sichtbaren** Zielfläche in Metern.
    ///
    /// Zusammen mit der Position der Zielentity ergibt sich daraus die Trefferfläche:
    ///
    /// ```text
    /// bounds = entity.position ± halfExtents
    /// ```
    ///
    /// Die Views setzen den Wert aus dem gemessenen Rahmen des **sichtbaren** Labels
    /// (`VolumeMetrics.sceneBox(fromLayout:z:depth:)`). Dadurch gilt konstruktiv
    /// `sichtbare Box ≈ tatsächlicher DropTarget-Bereich`; eine unsichtbare, nach innen
    /// verschobene Trefferfläche kann gar nicht mehr entstehen.
    ///
    /// Solange noch keine Messung vorliegt (erster Layoutdurchlauf), gilt der aus
    /// `radius` abgeleitete Ersatzwert.
    var halfExtents: SIMD3<Float>

    /// Optionaler Debug-Name für Logging (erscheint nie im normalen Nutzerablauf).
    let debugName: String?

    // MARK: - Init

    /// Erzeugt einen generischen Zielbereich.
    ///
    /// - Parameters:
    ///   - id: Fachlich neutrale Ziel-ID.
    ///   - radius: Trefferradius in Metern. Standard: `InteractionConstants.dropTargetRadius`.
    ///   - halfExtents: Halbe Kantenlängen der Zielfläche. Standard: aus `radius` abgeleitet.
    ///   - debugName: Optionaler Name für Debug-Ausgaben.
    init(
        id: String,
        radius: Float = InteractionConstants.dropTargetRadius,
        halfExtents: SIMD3<Float>? = nil,
        debugName: String? = nil
    ) {
        self.id = id
        self.radius = radius
        self.halfExtents = halfExtents ?? SIMD3<Float>(repeating: radius)
        self.debugName = debugName
    }

    // MARK: - Ableitung

    /// Trefferfläche in Szenen-Koordinaten für eine gegebene Zielposition.
    func bounds(at position: SIMD3<Float>) -> BoundingBox {
        BoundingBox(min: position - halfExtents, max: position + halfExtents)
    }
}
