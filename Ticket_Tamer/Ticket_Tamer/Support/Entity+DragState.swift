import RealityKit
import Foundation

// MARK: - Transform-Diagnose für Drag-Interaktionen (Modul 013 — AK-10)

extension Entity {

    /// Kompakte Beschreibung des **lokalen** Transforms samt Elternentity.
    ///
    /// Lokal, weil das die Bezugsgröße aller Drag-, Auswertungs- und Reset-Schritte ist:
    /// Start- und Zielpositionen aus `PrioritizationConstants` / `TeamAssignmentConstants`
    /// werden über `entity.position` gesetzt und sind damit ebenfalls lokal.
    ///
    /// Nur für `DebugManager`-Ausgaben gedacht — erscheint nie in der Benutzeroberfläche.
    var dragStateSummary: String {
        let t = transform
        let p = t.translation
        let s = t.scale
        let r = t.rotation.vector
        return String(
            format: "pos=(%.4f, %.4f, %.4f) scale=(%.4f, %.4f, %.4f) rot=(%.3f, %.3f, %.3f, %.3f) parent=%@",
            p.x, p.y, p.z,
            s.x, s.y, s.z,
            r.x, r.y, r.z, r.w,
            parent.map { $0.name.isEmpty ? "<unnamed>" : $0.name } ?? "nil"
        )
    }
}
