import RealityKit
import simd
import Foundation

// MARK: - Einpassung im Monster-Panel der Untersuchungsansicht (Restpunkt AK-06)

/// Leitet Groesse und Position des Monsters aus dem **gemessenen** Panelquader ab.
///
/// ## Warum dieser Typ existiert
///
/// Bis hierher rechnete `InvestigationView.fitMonster(_:into:)` gegen zwei Annahmen:
///
/// * `LayoutConstants.layoutPointsPerMeter` (417) — laut eigener Dokumentation am
///   Simulator gegen eine Volume-Hoehe von **0.8 m** kalibriert. `centralVolumeHeight`
///   betraegt inzwischen 1.0 m, der Faktor beschreibt die Ebene also nicht mehr.
///   Panelbreite und -hoehe in Metern waren damit systematisch falsch.
/// * `LayoutConstants.monsterPanelDepth` (0.34) — das **angeforderte** Mass der
///   `.frame(depth:)`, nicht das tatsaechlich gewaehrte. Das Volume ist nur 0.4 m tief
///   (`centralVolumeDepth`); wieviel Tiefe die `RealityView` innerhalb der Layoutebene
///   real erhaelt, stand nie fest.
///
/// Fuer die Drag-Phasen wurde dieselbe Klasse von Annahmen in Modul 013 bereits durch
/// eine Messung ersetzt (`VolumeMetrics` / `DragBounds`). Die Untersuchungsansicht ist
/// die letzte Stelle, an der noch geschaetzt wurde.
///
/// ## Warum das asset-abhaengig auffaellt
///
/// `MonsterAssetProvider.fit(_:toMaxExtent:)` bildet die **groesste** Modellausdehnung
/// auf die Grenze ab. Welche Achse das ist, unterscheidet sich je Export. Ein Modell,
/// dessen groesste Ausdehnung in Z liegt, wird deshalb auf die volle Grenze *in der
/// Tiefe* aufgezogen — genau der Achse, deren verfuegbares Mass bisher geraten wurde.
/// Modelle, deren groesste Ausdehnung in Y liegt, bleiben in Z unterhalb der Grenze und
/// fallen nicht auf. Ein Fehler, der nur ein Asset trifft, ist deshalb kein Assetfehler.
///
/// ## Abgrenzung
///
/// Der Typ beantwortet ausschliesslich: *Wie gross darf das Monster in diesem Panel sein
/// und wo liegt sein Ursprung?* Er teilt keine Konstante und keine Annahme mit
/// `DragBounds`, `DropEvaluator` oder `TargetPanelLayout` — die Drag-/Drop-Geometrie
/// bleibt unberuehrt. Keine SwiftUI-Abhaengigkeit, damit ohne Render-Loop testbar.
struct InvestigationFraming {

    // MARK: - Messwert

    /// Tatsaechliche Grenzen des Monster-Panels in Szenen-Koordinaten (Meter).
    ///
    /// Quelle: `content.convert(proxy.frame(in: .local), from: .local, to: .scene)`
    /// innerhalb der `RealityView` des Panels. Die Entity wird per `content.add(_:)`
    /// an dieselbe Szenenwurzel gehaengt, `entity.position` und diese Box beschreiben
    /// deshalb denselben Raum.
    let panel: BoundingBox

    // MARK: - Init

    init(panel: BoundingBox) {
        self.panel = panel
    }

    // MARK: - Plausibilitaet

    /// `true`, wenn die Messung brauchbar ist.
    ///
    /// Waehrend des ersten Layoutdurchlaufs kann die Box noch leer sein. Aufrufer fallen
    /// dann auf die bisherige Schaetzung zurueck, statt mit Nullwerten zu rechnen.
    var isUsable: Bool {
        let extents = panel.extents
        return extents.x > 0.01 && extents.y > 0.01 && extents.z > 0.001
    }

    // MARK: - Nutzbarer Quader

    /// Kantenlaengen des Panels nach Abzug des Sicherheitsrands.
    ///
    /// - Parameter inset: Anteil **je Kante**, der frei bleibt (0.15 = 15 %).
    func usableExtents(inset: Float) -> SIMD3<Float> {
        let factor = max(1 - inset, 0)
        return panel.extents * factor
    }

    /// Konservatives Zielmass ohne Kenntnis des Modells.
    ///
    /// Die kleinste nutzbare Panelkante begrenzt; zusaetzlich deckelt `cap`. Gilt nur,
    /// wenn die Modellausdehnungen nicht brauchbar gemessen werden konnten — sonst ist
    /// `maxExtent(forModelExtents:inset:cap:)` vorzuziehen.
    ///
    /// - Parameters:
    ///   - inset: Sicherheitsrand je Kante als Anteil.
    ///   - cap: Obergrenze der Kantenlaenge in Metern.
    /// - Returns: Zielmass fuer `MonsterAssetProvider.fit(_:toMaxExtent:)`.
    func maxExtent(inset: Float, cap: Float) -> Float {
        let usable = usableExtents(inset: inset)
        let smallestEdge = min(usable.x, min(usable.y, usable.z))
        return min(smallestEdge, max(cap, 0))
    }

    /// Zielmass unter Beruecksichtigung der **tatsaechlichen** Modellausdehnungen.
    ///
    /// ## Warum nicht einfach die kleinste Panelkante
    ///
    /// `MonsterAssetProvider.fit(_:toMaxExtent:)` bildet die groesste Modellausdehnung
    /// auf das Zielmass ab. Setzt man dieses Zielmass auf die kleinste Panelkante, wird
    /// jede andere Achse unnoetig stark beschnitten: ein 0.070 x 0.130 x 0.088 m grosses
    /// Modell in einem 0.085 x 0.170 x 0.200 m grossen Quader duerfte dann nur 0.085 m
    /// hoch werden — obwohl 0.158 m passen. Das Monster waere korrekt, aber winzig.
    ///
    /// Stattdessen wird der groesste gemeinsame Faktor gesucht, mit dem das Modell in
    /// **allen drei** Achsen in den nutzbaren Quader passt, und daraus das Zielmass
    /// zurueckgerechnet. Ergebnis: das Modell nutzt den Panelquader aus und bleibt in
    /// jeder Achse innerhalb — unabhaengig davon, welche Achse seine groesste ist.
    ///
    /// - Parameters:
    ///   - modelExtents: Ausdehnungen des Modells **ohne** eigene Skalierung, also
    ///     `entity.visualBounds(recursive: true, relativeTo: entity).extents`.
    ///   - inset: Sicherheitsrand je Kante als Anteil.
    ///   - cap: Obergrenze der groessten Kantenlaenge in Metern.
    /// - Returns: Zielmass fuer `MonsterAssetProvider.fit(_:toMaxExtent:)`.
    func maxExtent(forModelExtents modelExtents: SIMD3<Float>, inset: Float, cap: Float) -> Float {
        let largest = max(modelExtents.x, max(modelExtents.y, modelExtents.z))

        // Ohne brauchbare Modellmasse bleibt nur die konservative Variante.
        guard largest > 0, modelExtents.x > 0, modelExtents.y > 0, modelExtents.z > 0 else {
            return maxExtent(inset: inset, cap: cap)
        }

        let usable = usableExtents(inset: inset)
        let factor = min(
            usable.x / modelExtents.x,
            min(usable.y / modelExtents.y, usable.z / modelExtents.z)
        )

        return min(largest * factor, max(cap, 0))
    }

    // MARK: - Position

    /// Ursprung des Monsters: Panelmitte, so weit nach vorne geschoben, wie die
    /// **gemessene** nutzbare Tiefe es zulaesst.
    ///
    /// Bisher wurde hart auf `(0, 0, forward)` gesetzt. Das trifft die Panelmitte nur,
    /// wenn der Ursprung der `RealityView` exakt im Panelzentrum liegt. Das Panel ist
    /// aber die linke Spalte eines `HStack` — liegt der Szenenursprung stattdessen in
    /// der Mitte der Layoutebene, sass das Monster horizontal versetzt und lief in die
    /// Ticketkarte hinein. Die gemessene Box loest das ohne weitere Konstante.
    ///
    /// - Parameters:
    ///   - desiredForward: Gewuenschte Verschiebung zur betrachtenden Person (+Z).
    ///   - fittedDepth: Tatsaechliche Z-Ausdehnung des eingepassten Modells.
    ///   - inset: Sicherheitsrand je Kante als Anteil.
    func position(desiredForward: Float, fittedDepth: Float, inset: Float) -> SIMD3<Float> {
        let center = panel.center
        let usableDepth = usableExtents(inset: inset).z
        let maxForward = max((usableDepth - fittedDepth) / 2, 0)
        let forward = min(max(desiredForward, 0), maxForward)

        return SIMD3<Float>(center.x, center.y, center.z + forward)
    }

    // MARK: - Debug

    /// Kompakte Beschreibung fuer `DebugManager`-Ausgaben.
    ///
    /// Bewusst inklusive der bisher **angenommenen** Tiefe: damit ist im Simulatorlog
    /// unmittelbar ablesbar, wie weit `monsterPanelDepth` vom gewaehrten Mass abweicht.
    func debugSummary(assumedDepth: Float) -> String {
        String(
            format: "panel %.3f x %.3f x %.3f m | center (%.3f, %.3f, %.3f) | angenommene Tiefe %.3f m",
            panel.extents.x, panel.extents.y, panel.extents.z,
            panel.center.x, panel.center.y, panel.center.z,
            assumedDepth
        )
    }
}

// MARK: - Equatable

extension InvestigationFraming: Equatable {

    /// Vergleicht die Messung komponentenweise.
    ///
    /// Noetig, damit die View nur bei echter Aenderung neuen Zustand schreibt — sonst
    /// entstuende beim Messen innerhalb des `RealityView`-Updates eine Endlosschleife.
    static func == (lhs: InvestigationFraming, rhs: InvestigationFraming) -> Bool {
        lhs.panel.min == rhs.panel.min && lhs.panel.max == rhs.panel.max
    }
}
