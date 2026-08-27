import SwiftUI

// MARK: - Rahmen der sichtbaren Zielbeschriftungen (Modul 013 — Drag-/Drop-Randfix)

/// Sammelt die Rahmen aller sichtbaren Zielbeschriftungen einer Phase.
///
/// Schlüssel ist die fachlich neutrale Ziel-ID, Wert der Rahmen in Punkten im
/// gemeinsamen benannten Koordinatenraum der Ansicht.
///
/// Zweck: die sichtbaren Ziele sind SwiftUI-2D-Labels, die technischen DropTargets sind
/// RealityKit-Entities. Ohne diese Messung sind beide unabhängig voneinander platziert —
/// genau die Situation, in der ein Monster in der Mitte losgelassen wird und eine weit
/// außen stehende Box auslöst. Mit ihr liegt jedes DropTarget konstruktiv genau dort, wo
/// die Nutzerin die Box sieht.
struct TargetFramePreferenceKey: PreferenceKey {

    static var defaultValue: [String: CGRect] { [:] }

    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue()) { _, latest in latest }
    }
}

// MARK: - View-Hilfe

extension View {

    /// Meldet den eigenen Rahmen unter der angegebenen Ziel-ID.
    ///
    /// - Parameters:
    ///   - id: Fachlich neutrale Ziel-ID, identisch zur `DropTargetComponent.id`.
    ///   - space: Benannter Koordinatenraum, in dem gemessen wird. Muss derselbe sein,
    ///     den die umgebende Ansicht per `.coordinateSpace(_:)` aufspannt.
    func reportTargetFrame(id: String, in space: NamedCoordinateSpace) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(
                    key: TargetFramePreferenceKey.self,
                    value: [id: proxy.frame(in: space)]
                )
            }
        )
    }
}
