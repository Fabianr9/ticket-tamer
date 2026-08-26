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

    /// Neue Position auf der Tiefenebene von `start`, begrenzt auf die Spielfläche.
    ///
    /// - Parameters:
    ///   - start: Position der Entity zu Beginn der Zieh-Geste (Weltkoordinaten).
    ///   - translation: 2D-Translation der Geste in Punkten.
    ///   - limits: Maximaler Betrag je Achse für den **Mittelpunkt** der Entity, gemessen
    ///     vom Volume-Mittelpunkt. Siehe `playAreaLimits(forEntityOfSize:)`.
    /// - Returns: Position mit angepasstem X und Y bei **unveränderter Z-Tiefe**,
    ///   geklemmt auf `limits`.
    ///   - maximumY: Zusätzliche Obergrenze für Y, unabhängig von `limits`. Wird genutzt,
    ///     um das Monster unterhalb der Label-Zeile zu halten
    ///     (`PrioritizationConstants.monsterCeiling(forMonsterHeight:)`).
    static func position(
        from start: SIMD3<Float>,
        translation: CGSize,
        limits: SIMD3<Float> = SIMD3<Float>(repeating: .greatestFiniteMagnitude),
        maximumY: Float = .greatestFiniteMagnitude
    ) -> SIMD3<Float> {
        let pointsPerMeter = LayoutConstants.pointsPerMeter

        let moved = SIMD3<Float>(
            start.x + Float(translation.width / pointsPerMeter),
            // Minus: SwiftUI-Y wächst nach unten, RealityKit-Y nach oben.
            start.y - Float(translation.height / pointsPerMeter),
            // Tiefe bleibt konstant — kein Sprung nach vorne, kein Wandern nach hinten.
            start.z
        )

        return SIMD3<Float>(
            clamp(moved.x, to: limits.x),
            // Zusätzlich zur symmetrischen Volume-Grenze die Label-Unterkante beachten.
            min(clamp(moved.y, to: limits.y), maximumY),
            // Z wird nicht geklemmt: der Wert stammt unverändert aus `start` und liegt
            // damit per Definition bereits innerhalb der Spielfläche.
            moved.z
        )
    }

    // MARK: - Spielfläche

    /// Maximaler Betrag je Achse für den Mittelpunkt einer Entity der Kantenlänge `size`.
    ///
    /// Ergibt sich aus der halben Volume-Kante abzüglich der halben Modellgröße und
    /// `LayoutConstants.playAreaSafetyMargin`. Dadurch bleibt zwischen Modellhülle und
    /// Clipping-Kante des Volumes immer sichtbarer Rand — das Monster kann konstruktiv
    /// nicht mehr angeschnitten werden, egal wie weit gezogen wird.
    ///
    /// - Parameter size: Größte Kantenlänge der Entity in Metern.
    static func playAreaLimits(forEntityOfSize size: Float) -> SIMD3<Float> {
        let halfVolume = SIMD3<Float>(
            Float(LayoutConstants.centralVolumeWidth / 2),
            Float(LayoutConstants.centralVolumeHeight / 2),
            Float(LayoutConstants.centralVolumeDepth / 2)
        )
        let inset = size / 2 + LayoutConstants.playAreaSafetyMargin

        return SIMD3<Float>(
            max(halfVolume.x - inset, 0),
            max(halfVolume.y - inset, 0),
            max(halfVolume.z - inset, 0)
        )
    }

    // MARK: - Hilfsfunktion

    /// Begrenzt `value` symmetrisch auf `[-limit, limit]`.
    private static func clamp(_ value: Float, to limit: Float) -> Float {
        min(max(value, -limit), limit)
    }
}

// MARK: - Ungeklemmte Wunschposition (Modul 013 — Drag-/Drop-Randfix)

extension PlanarDrag {

    /// Gewünschte Position ohne jede Begrenzung — der reine Gestenanteil.
    ///
    /// Trennt bewusst zwei Schritte, die zuvor in `position(from:translation:limits:maximumY:)`
    /// vermischt waren:
    ///
    /// ```text
    /// Finger / Pinch möchte Monster hierhin bewegen
    ///                  ↓
    ///           requestedPosition          ← diese Funktion
    ///                  ↓
    ///      Clamp auf sicheren Bereich      ← DragBounds.clamp(_:)
    ///                  ↓
    ///           allowedPosition
    ///                  ↓
    ///          Entity bewegen
    /// ```
    ///
    /// Die Begrenzung stammt seit dem Modul-013-Randfix aus gemessenen Werten
    /// (`MonsterDragGeometry`) statt aus den Volume-Konstanten. `playAreaLimits(forEntityOfSize:)`
    /// bleibt als Rückfallebene erhalten, falls die Messung noch nicht vorliegt.
    ///
    /// - Parameters:
    ///   - start: Position der Entity zu Beginn der Zieh-Geste.
    ///   - translation: 2D-Translation der Geste in Punkten.
    /// - Returns: Position mit angepasstem X und Y bei unveränderter Z-Tiefe.
    static func requestedPosition(
        from start: SIMD3<Float>,
        translation: CGSize
    ) -> SIMD3<Float> {
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
