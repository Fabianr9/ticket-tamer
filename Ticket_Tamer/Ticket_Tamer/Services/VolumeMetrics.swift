import CoreGraphics
import RealityKit
import simd
import Foundation

// MARK: - Volume-Vermessung (Modul 013 — Drag-/Drop-Randfix)

/// Affine Abbildung zwischen der **SwiftUI-Layoutebene** (Punkte) und der
/// **RealityKit-Szene** (Meter) eines volumetrischen Fensters.
///
/// ## Warum dieser Typ existiert
///
/// Bis hierher stammten sämtliche Grenzwerte der Drag-Logik aus Annahmen:
///
/// * `LayoutConstants.centralVolume*` beschreibt nur die `defaultSize` des Fensters,
///   nicht dessen tatsächliche Größe zur Laufzeit,
/// * `LayoutConstants.layoutPointsPerMeter` (417) wurde per Augenmaß gegen eine
///   Volume-Höhe von 0.8 m kalibriert, die inzwischen 1.0 m beträgt,
/// * `LayoutConstants.monsterDragDropTargetSize` ist das **Nennmaß** der Einpassung,
///   nicht die gemessene Ausdehnung des geladenen Modells.
///
/// Weichen diese Annahmen zur Laufzeit ab, rechnet die Zieh-Begrenzung gegen eine
/// Grenze, die es nicht gibt — das Monster läuft über die Clipping-Kante hinaus.
///
/// `VolumeMetrics` ersetzt alle drei Annahmen durch **eine einzige Messung**:
///
/// ```swift
/// GeometryReader3D { proxy in
///     RealityView { content in
///         let volume = content.convert(proxy.frame(in: .local), from: .local, to: .scene)
///     }
/// }
/// ```
///
/// Aus dem Paar (Layoutrahmen in Punkten, Volume-Box in Metern) folgt die Umrechnung
/// beider Richtungen exakt — ohne weitere Konstante. Die Abbildung ist achsenparallel
/// und linear, weil das Volume achsenparallel zur Layoutebene liegt; einzig die
/// Y-Achse ist gespiegelt (SwiftUI zählt nach unten, RealityKit nach oben).
///
/// Der Typ hat bewusst **keine** SwiftUI-Abhängigkeit und ist damit ohne laufenden
/// Render-Loop unit-testbar.
struct VolumeMetrics {

    // MARK: - Messwerte

    /// Tatsächliche Volume-Grenzen in Szenen-Koordinaten (Meter).
    let volume: BoundingBox

    /// Tatsächlicher Rahmen der SwiftUI-Layoutebene in Punkten.
    let layoutFrame: CGRect

    // MARK: - Init

    init(volume: BoundingBox, layoutFrame: CGRect) {
        self.volume = volume
        self.layoutFrame = layoutFrame
    }

    // MARK: - Plausibilität

    /// `true`, wenn beide Messungen brauchbar sind.
    ///
    /// Während des ersten Layoutdurchlaufs können Rahmen oder Box noch leer sein.
    /// Aufrufer fallen in diesem Fall auf die bisherigen Konstanten zurück, statt mit
    /// Nullwerten zu rechnen.
    var isUsable: Bool {
        layoutFrame.width > 1
            && layoutFrame.height > 1
            && volume.extents.x > 0.01
            && volume.extents.y > 0.01
    }

    /// Meter pro Layoutpunkt je Achse.
    var metersPerPoint: SIMD2<Float> {
        SIMD2<Float>(
            volume.extents.x / Float(layoutFrame.width),
            volume.extents.y / Float(layoutFrame.height)
        )
    }

    // MARK: - Umrechnung Punkte → Meter

    /// Punkt der Layoutebene → X/Y in Szenen-Metern.
    ///
    /// Y wird gespiegelt: der obere Rand der Layoutebene entspricht `volume.max.y`.
    func scenePoint(fromLayout point: CGPoint) -> SIMD2<Float> {
        let scale = metersPerPoint
        return SIMD2<Float>(
            volume.min.x + Float(point.x - layoutFrame.minX) * scale.x,
            volume.max.y - Float(point.y - layoutFrame.minY) * scale.y
        )
    }

    /// Rechteck der Layoutebene → achsenparallele Box in Szenen-Metern.
    ///
    /// - Parameters:
    ///   - rect: Rahmen des sichtbaren Elements in Punkten, im selben Koordinatenraum
    ///     wie `layoutFrame`.
    ///   - z: Tiefenebene der resultierenden Box in Metern.
    ///   - depth: Tiefe der resultierenden Box in Metern. Für die Drop-Auswertung
    ///     ohne Bedeutung — sie prüft ausschließlich die X/Y-Überlappung —, aber
    ///     nützlich für Debug-Ausgaben und mögliche spätere 3D-Prüfungen.
    func sceneBox(fromLayout rect: CGRect, z: Float, depth: Float) -> BoundingBox {
        let cornerA = scenePoint(fromLayout: CGPoint(x: rect.minX, y: rect.minY))
        let cornerB = scenePoint(fromLayout: CGPoint(x: rect.maxX, y: rect.maxY))
        let halfDepth = Swift.max(depth, 0.001) / 2

        return BoundingBox(
            min: SIMD3<Float>(
                Swift.min(cornerA.x, cornerB.x),
                Swift.min(cornerA.y, cornerB.y),
                z - halfDepth
            ),
            max: SIMD3<Float>(
                Swift.max(cornerA.x, cornerB.x),
                Swift.max(cornerA.y, cornerB.y),
                z + halfDepth
            )
        )
    }

    // MARK: - Debug

    /// Kompakte Beschreibung für `DebugManager`-Ausgaben.
    var debugSummary: String {
        String(
            format: "volume minX=%.3f maxX=%.3f minY=%.3f maxY=%.3f minZ=%.3f maxZ=%.3f | layout %.0fx%.0f pt | %.1f pt/m",
            volume.min.x, volume.max.x,
            volume.min.y, volume.max.y,
            volume.min.z, volume.max.z,
            layoutFrame.width, layoutFrame.height,
            metersPerPoint.x > 0 ? 1 / metersPerPoint.x : 0
        )
    }
}

// MARK: - Equatable

extension VolumeMetrics: Equatable {

    /// Vergleicht die beiden Messungen komponentenweise.
    ///
    /// Nötig, damit die Views nur dann neuen Zustand schreiben, wenn sich die Messung
    /// tatsächlich geändert hat — sonst entstünde beim Messen innerhalb des
    /// `RealityView`-Updates eine Endlosschleife.
    static func == (lhs: VolumeMetrics, rhs: VolumeMetrics) -> Bool {
        lhs.layoutFrame == rhs.layoutFrame
            && lhs.volume.min == rhs.volume.min
            && lhs.volume.max == rhs.volume.max
    }
}
