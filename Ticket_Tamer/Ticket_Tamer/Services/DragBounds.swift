import RealityKit
import simd
import Foundation

// MARK: - Sicherer Bewegungsbereich der Monster-Root (Modul 013 — Drag-/Drop-Randfix)

/// Der **unsichtbare** Bereich, in dem sich der Ursprung der Monster-Entity bewegen darf.
///
/// ## Idee
///
/// Das Volume ist die Clipping-Kante. Gezogen wird aber nicht die sichtbare Hülle,
/// sondern die Root-Entity — und deren Ursprung liegt irgendwo *innerhalb* dieser Hülle.
/// Begrenzt man den Ursprung auf das Volume, ragt die Hülle darüber hinaus und wird
/// beschnitten.
///
/// `DragBounds` zieht deshalb von jeder Volume-Seite genau so viel ab, wie die sichtbare
/// Geometrie auf dieser Seite über den Ursprung hinausragt — plus ein kleines Padding:
///
/// ```text
/// ┌──────────────────────────────────────────┐
/// │          UNSICHTBARER SICHERHEITSRAND    │
/// │   ┌──────────────────────────────────┐   │
/// │   │      ERLAUBTER DRAG-BEREICH      │   │
/// │   └──────────────────────────────────┘   │
/// └──────────────────────────────────────────┘
/// ```
///
/// Der Rand ist **rein mathematisch**: keine Entity, keine Geometrie, kein Material,
/// keine UI. Er begrenzt ausschließlich die erlaubte Root-Position.
///
/// ## Asymmetrie
///
/// Die Rechnung verwendet `minimum`/`maximum` der Monster-Bounds **getrennt je Seite**,
/// nicht die halbe Kantenlänge. Ein Modell, das links 0.08 m und rechts 0.12 m über
/// seinen Ursprung hinausragt, erhält links und rechts entsprechend unterschiedliche
/// Grenzen. Das gilt ebenso für oben/unten und deckt damit auch Modelle ab, deren
/// Ursprung nicht im Zentrum der sichtbaren Hülle liegt.
///
/// ## Trennung von der Drop-Erkennung
///
/// `DragBounds` beantwortet **ausschließlich**: *Wo darf sich das Monster bewegen, ohne
/// abgeschnitten zu werden?* Ob ein Ziel getroffen wurde, entscheidet allein
/// `DropEvaluator`. Beide Systeme teilen keine Konstante und keine Annahme.
struct DragBounds {

    // MARK: - Grenzen

    /// Kleinster erlaubter Wert der Root-Position je Achse (Meter, Szenen-Koordinaten).
    let minimum: SIMD3<Float>

    /// Größter erlaubter Wert der Root-Position je Achse (Meter, Szenen-Koordinaten).
    let maximum: SIMD3<Float>

    // MARK: - Berechnung

    /// Leitet den sicheren Root-Bereich aus Volume und sichtbaren Monster-Bounds ab.
    ///
    /// - Parameters:
    ///   - volume: Tatsächlich gemessene Volume-Grenzen (siehe `VolumeMetrics`).
    ///   - monsterBounds: Sichtbare Ausdehnung des Monsters **relativ zu seinem Root**,
    ///     inklusive Skalierung (siehe `MonsterAssetProvider.localVisualBounds(of:)`).
    ///     Für ein zentriertes Modell sind das etwa `±extents/2`, für ein Modell mit
    ///     Ursprung am Fuß entsprechend verschobene Werte.
    ///   - padding: Zusätzlicher unsichtbarer Abstand zur Volume-Kante in Metern.
    /// - Returns: Erlaubter Bereich der Root-Position.
    ///
    /// Ist ein Monster auf einer Achse breiter als das Volume, wäre die Grenze invertiert.
    /// In diesem Fall kollabiert die Achse auf die Position, bei der die Hülle mittig im
    /// Volume steht — ein Rest an Beschnitt ist dann unvermeidbar, aber symmetrisch und
    /// minimal statt einseitig.
    static func safeRegion(
        volume: BoundingBox,
        monsterBounds: BoundingBox,
        padding: Float
    ) -> DragBounds {
        let low = axisRange(
            volumeMin: volume.min,
            volumeMax: volume.max,
            monsterMin: monsterBounds.min,
            monsterMax: monsterBounds.max,
            padding: padding
        )
        return DragBounds(minimum: low.minimum, maximum: low.maximum)
    }

    /// Achsenweise Auswertung der Formel — für alle drei Achsen identisch.
    ///
    /// ```text
    /// safeMin = volumeMin - monsterMin + padding      (monsterMin ist negativ ⇒ nach innen)
    /// safeMax = volumeMax - monsterMax - padding
    /// ```
    private static func axisRange(
        volumeMin: SIMD3<Float>,
        volumeMax: SIMD3<Float>,
        monsterMin: SIMD3<Float>,
        monsterMax: SIMD3<Float>,
        padding: Float
    ) -> (minimum: SIMD3<Float>, maximum: SIMD3<Float>) {
        var resultMin = SIMD3<Float>.zero
        var resultMax = SIMD3<Float>.zero

        for axis in 0..<3 {
            let lower = volumeMin[axis] - monsterMin[axis] + padding
            let upper = volumeMax[axis] - monsterMax[axis] - padding

            if lower <= upper {
                resultMin[axis] = lower
                resultMax[axis] = upper
            } else {
                // Monster breiter als das Volume: Hülle mittig stellen.
                let volumeCenter = (volumeMin[axis] + volumeMax[axis]) / 2
                let monsterCenter = (monsterMin[axis] + monsterMax[axis]) / 2
                let collapsed = volumeCenter - monsterCenter
                resultMin[axis] = collapsed
                resultMax[axis] = collapsed
            }
        }

        return (resultMin, resultMax)
    }

    // MARK: - Anwendung

    /// Begrenzt eine gewünschte Root-Position auf den sicheren Bereich.
    ///
    /// Achsenweise unabhängig — dadurch stoppt das Monster an jedem Rand einzeln und
    /// gleitet an einer Ecke weiterhin entlang der jeweils freien Achse.
    func clamp(_ requested: SIMD3<Float>) -> SIMD3<Float> {
        SIMD3<Float>(
            Swift.min(Swift.max(requested.x, minimum.x), maximum.x),
            Swift.min(Swift.max(requested.y, minimum.y), maximum.y),
            Swift.min(Swift.max(requested.z, minimum.z), maximum.z)
        )
    }

    /// `true`, wenn eine der Achsen kollabiert ist (Monster größer als das Volume).
    var hasCollapsedAxis: Bool {
        minimum.x >= maximum.x || minimum.y >= maximum.y
    }

    // MARK: - Debug

    /// Kompakte Beschreibung für `DebugManager`-Ausgaben.
    var debugSummary: String {
        String(
            format: "safe minX=%.3f maxX=%.3f minY=%.3f maxY=%.3f minZ=%.3f maxZ=%.3f",
            minimum.x, maximum.x,
            minimum.y, maximum.y,
            minimum.z, maximum.z
        )
    }
}

// MARK: - Equatable

extension DragBounds: Equatable {}
