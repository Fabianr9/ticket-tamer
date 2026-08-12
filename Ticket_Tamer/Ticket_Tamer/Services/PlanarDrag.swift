import CoreGraphics
import simd

// MARK: - Planare Zieh-Bewegung (Modul 008 / 009 — F-08 / F-09 / AK-10)

/// Berechnet Zielpositionen für Zieh-Gesten auf einer **festen Tiefenebene**.
///
/// ## Warum nicht `EntityTargetValue.convert(_:from:to:)`?
///
/// Die vorherige Umsetzung übernahm die absolute 3D-Position des Zeigers:
///
/// ```swift
/// let scenePoint = value.convert(value.gestureValue.location3D, from: .local, to: .scene)
/// entity.position = SIMD3(scenePoint.x, scenePoint.y, scenePoint.z)
/// ```
///
/// Daraus folgten drei Fehler gleichzeitig:
///
/// 1. **Sprung nach vorne beim Greifen.** Die Z-Komponente des Zeigers — also die Tiefe der
///    Hand im Raum — wurde direkt in die Entity geschrieben. Das Monster sprang im selben
///    Moment auf die Tiefe der Hand, typischerweise deutlich vor seine Startposition.
/// 2. **Wandern nach hinten beim Loslassen.** Ebenfalls kein Physik-Effekt: die Entity blieb
///    schlicht auf der Z-Position stehen, an der die Hand zuletzt war. Im Projekt existiert
///    keine `PhysicsBodyComponent` und keine Gravitation.
/// 3. **Kaum horizontale Bewegung.** `.local` bezieht sich auf den Koordinatenraum der
///    gezogenen Entity. Deren eigene Skalierung ging damit in die Umrechnung ein — bei einem
///    per `MonsterAssetProvider.fit` eingepassten Monster ein Faktor in der Größenordnung
///    0.02–0.1. Gemessen wurden 0.011 m X-Versatz über eine Ziehbewegung durch die halbe
///    Ansicht, weshalb ausschließlich das mittlere Ziel erreichbar war.
///
/// ## Verwendeter Ansatz
///
/// Grundlage ist die **2D-Translation der Geste in Punkten**. Sie ist unabhängig von
/// Skalierung, Orientierung und Tiefe der gezogenen Entity und damit vorhersagbar.
/// Angewendet wird sie relativ zur Position beim Gestenbeginn:
///
/// - X folgt der horizontalen Translation,
/// - Y folgt der vertikalen Translation, gespiegelt (SwiftUI zählt nach unten positiv,
///   RealityKit nach oben),
/// - **Z bleibt unverändert** auf dem Wert vom Gestenbeginn.
enum PlanarDrag {

    /// Neue Position auf der Tiefenebene von `start`.
    ///
    /// - Parameters:
    ///   - start: Position der Entity zu Beginn der Zieh-Geste (Weltkoordinaten).
    ///   - translation: 2D-Translation der Geste in Punkten.
    /// - Returns: Position mit angepasstem X und Y bei **unveränderter Z-Tiefe**.
    static func position(from start: SIMD3<Float>, translation: CGSize) -> SIMD3<Float> {
        let pointsPerMeter = LayoutConstants.pointsPerMeter

        return SIMD3<Float>(
            start.x + Float(translation.width / pointsPerMeter),
            // Minus: SwiftUI-Y wächst nach unten, RealityKit-Y nach oben.
            start.y - Float(translation.height / pointsPerMeter),
            // Tiefe bleibt konstant — kein Sprung nach vorne, kein Wandern nach hinten.
            start.z
        )
    }
}
