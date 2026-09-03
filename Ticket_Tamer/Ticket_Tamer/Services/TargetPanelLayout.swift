import RealityKit
import simd

// MARK: - Anordnung der Zielpanels (Modul 013 — 3D-Zielstationen)

/// Beschreibt die räumliche Anordnung der Zielpanels **einer** Phase und rechnet sie
/// gegen das tatsächlich gemessene Volume aus.
///
/// ## Warum zentral und nicht je View
///
/// Priorisierung (1 Reihe × 3 Spalten) und Teamzuordnung (2 Reihen × 2 Spalten) sind
/// derselbe Fall mit anderen Zahlen. Die Views geben deshalb nur noch das Raster und die
/// Ziel-IDs an; sämtliche Geometrie — Panelgröße, Mittelpunkte, Tiefenebene — entsteht
/// genau hier. Damit gibt es keine zweite, abweichende Rechnung in der zweiten Ansicht.
///
/// ## Randtreue statt Mittelverschiebung
///
/// Die Spalten füllen die Volume-Breite abzüglich der Zwischenräume vollständig aus, die
/// Reihen sind an Ober- und Unterkante verankert:
///
/// ```text
/// ┌───────────────────────────────────────────┐  ← Volume
/// │ ┌────────┐ ┌────────┐ ┌────────┐          │
/// │ │ Normal │ │Wichtig │ │Kritisch│          │  ← Reihe 0, bündig oben
/// │ └────────┘ └────────┘ └────────┘          │
/// │                                           │
/// └───────────────────────────────────────────┘
/// ```
///
/// Die **Außenkanten** der äußeren Panels liegen `gap` von der Volume-Kante entfernt.
/// Ein Panel wird also nach innen größer, statt dass ein Ziel nach innen wandert.
struct TargetPanelLayout {

    // MARK: - Raster

    /// Platz eines Ziels im Raster.
    struct Slot {
        /// Fachlich neutrale Ziel-ID, identisch zur `DropTargetComponent.id`.
        let id: String
        /// Spalte, 0-basiert, von links.
        let column: Int
        /// Reihe, 0-basiert, von oben.
        let row: Int

        init(id: String, column: Int, row: Int = 0) {
            self.id = id
            self.column = column
            self.row = row
        }
    }

    /// Anzahl der Spalten.
    let columns: Int

    /// Anzahl der Reihen.
    let rows: Int

    /// Maximale Gesamtbreite dieses phasenspezifischen Rasters.
    let maximumWidth: Float

    /// Die Ziele mit ihrem Rasterplatz.
    let slots: [Slot]

    // MARK: - Ergebnis

    /// Fertig berechnete Geometrie einer Phase.
    struct Resolved {
        /// Abmessungen eines Panels (Breite, Höhe, Tiefe) in Metern — für alle gleich.
        let panelSize: SIMD3<Float>
        /// Mittelpunkt jedes Panels in Szenen-Koordinaten, je Ziel-ID.
        let centers: [String: SIMD3<Float>]

        /// Trefferfläche eines Ziels — deckungsgleich mit dem sichtbaren Panel.
        func bounds(for id: String) -> BoundingBox? {
            guard let center = centers[id] else { return nil }
            let half = panelSize / 2
            return BoundingBox(min: center - half, max: center + half)
        }

        /// Alle Trefferflächen.
        var allBounds: [String: BoundingBox] {
            var result: [String: BoundingBox] = [:]
            for (id, center) in centers {
                let half = panelSize / 2
                result[id] = BoundingBox(min: center - half, max: center + half)
            }
            return result
        }
    }

    // MARK: - Berechnung

    /// Rechnet das Raster gegen das gemessene Volume aus.
    ///
    /// - Parameters:
    ///   - volume: Tatsächlich gemessene Volume-Grenzen (siehe `VolumeMetrics`).
    ///   - monsterBounds: Sichtbare Monster-Ausdehnung relativ zu seinem Root. Bestimmt
    ///     Panelhöhe und Tiefenebene — beides muss sich am Monster orientieren, sonst ist
    ///     die 50-%-Schwelle je nach Asset unterschiedlich streng oder gar unerreichbar.
    ///   - monsterPlaneZ: Tiefenebene, auf der das Monster gezogen wird.
    /// - Returns: Panelgröße und Mittelpunkte.
    func resolve(
        volume: BoundingBox,
        monsterBounds: BoundingBox,
        monsterPlaneZ: Float
    ) -> Resolved {
        // Randabstand bewusst == `dragSafetyPadding`, nicht == `targetPanelGap`.
        //
        // Der sichere Zieh-Bereich endet bei `Volume-Kante − dragSafetyPadding`; genau dort
        // liegt am Anschlag auch die Außenkante der Monsterhülle. Setzt man die Panelkante
        // auf denselben Wert, decken sich beide per Konstruktion und der erreichbare
        // Überlappungsanteil hängt nur noch von der Panelhöhe ab. Zuvor stimmten die beiden
        // Werte nur zufällig überein.
        let outerMargin = InteractionConstants.dragSafetyPadding
        let gap = LayoutConstants.targetPanelGap
        let volumeWidth = volume.extents.x
        let volumeHeight = volume.extents.y

        // Das Volume bleibt vollstaendig vermessen und nutzbar. Nur das Zielraster
        // erhaelt in grossen Volumes eine ergonomische Obergrenze, damit weder Panels
        // noch Drag-Strecken mit der Fenstergroesse ins Unpraktische wachsen.
        let gridWidth = Swift.min(volumeWidth, maximumWidth)
        let gridMinX = volume.center.x - gridWidth / 2

        // Breite: verfügbare Breite abzüglich Rand und Zwischenräumen, gleichmäßig verteilt.
        let usableWidth = gridWidth - 2 * outerMargin - gap * Float(Swift.max(columns - 1, 0))
        let panelWidth = Swift.max(usableWidth / Float(Swift.max(columns, 1)), 0.01)

        let monsterWidth = Swift.max(monsterBounds.extents.x, 0.0001)
        let monsterHeight = Swift.max(monsterBounds.extents.y, 0.0001)

        // Höhe: aus der gemessenen Monsterhöhe abgeleitet …
        let preferredHeight = monsterHeight * LayoutConstants.targetPanelHeightFactor

        // … aber mindestens so hoch, dass die Schwelle geometrisch erreichbar bleibt.
        //
        // Der maximal erreichbare Anteil ist `xr × yr` mit
        // `xr = min(panelWidth, monsterWidth) / monsterWidth` und
        // `yr = min(panelHeight, monsterHeight) / monsterHeight`.
        // Ist das Panel schmaler als das Monster, muss die Höhe das ausgleichen — sonst
        // wäre die Schwelle unerreichbar, ohne dass es jemand merkt.
        let reachableWidthRatio = Swift.min(panelWidth, monsterWidth) / monsterWidth
        let requiredRatio = InteractionConstants.minimumDropOverlapRatio
            + LayoutConstants.targetPanelReachabilityHeadroom
        let requiredHeight = Swift.min(
            monsterHeight * requiredRatio / Swift.max(reachableWidthRatio, 0.0001),
            monsterHeight
        )

        // Zwei Obergrenzen mit unterschiedlichem Gewicht:
        //
        // * `softMaxHeight` ist eine **gestalterische** Grenze — sie verhindert, dass die
        //   Panels die Spielfläche optisch dominieren.
        // * `hardMaxHeight` ist eine **geometrische** Grenze — bei zwei Reihen dürfen sich
        //   obere und untere Reihe nicht überlappen, und keine Reihe darf aus dem Volume
        //   herausragen.
        //
        // Die Erreichbarkeit (`requiredHeight`) schlägt die gestalterische Grenze, aber
        // nicht die geometrische.
        //
        // ## Warum diese Reihenfolge nötig ist
        //
        // Zuvor gewann die gestalterische Grenze über alles. Im tatsächlich gemessenen
        // Volume (0.284 × 0.236 m — deutlich kleiner als die deklarierten 1.0 × 1.0 m)
        // ergab `0.28 × Volume-Höhe` eine Panelhöhe von 0.066 m gegen ein 0.130 m hohes
        // Monster. Der maximal erreichbare Überlappungsanteil lag damit bei
        // `0.066/0.130 × xr ≈ 0.49` — **unter** der eigenen Schwelle von 0.50. Kein Drop
        // konnte je gültig werden, unabhängig davon, wie weit gezogen wurde. Betroffen
        // waren rechnerisch alle Assets; nur das schmalste (monster02) kam mit 0.508
        // knapp darüber, weshalb der Fehler wie ein Problem einzelner Monster aussah.
        let softMaxHeight = Swift.max(volumeHeight * LayoutConstants.targetPanelMaximumHeightFraction, 0.02)
        let hardMaxHeight = Swift.max(
            (volumeHeight - 2 * outerMargin - gap * Float(Swift.max(rows - 1, 0))) / Float(Swift.max(rows, 1)),
            0.02
        )

        let styledHeight = Swift.min(
            Swift.max(preferredHeight, LayoutConstants.targetPanelMinimumHeight),
            softMaxHeight
        )
        let panelHeight = Swift.min(Swift.max(styledHeight, requiredHeight), hardMaxHeight)

        let panelDepth = LayoutConstants.targetPanelDepth
        let panelSize = SIMD3<Float>(panelWidth, panelHeight, panelDepth)

        // Tiefenebene: das Panel steht hinter dem Monster, mit genau
        // `targetPanelStandoff` freiem Abstand zwischen Monsterrückseite und
        // Panelvorderseite.
        //
        // **`monsterPlaneZ` muss die Ebene sein, die das Monster beim Ziehen tatsächlich
        // erreicht** — also der bereits durch `DragBounds` geklemmte Wert, nicht der
        // Wunschwert aus den Phasenkonstanten. Genau diese Verwechslung ließ in der
        // Teamphase jeden Drop an der Tiefenprüfung scheitern: der Clamp schob das Monster
        // nach vorne, das Panel blieb auf der alten Ebene stehen, und der Z-Spalt wuchs
        // über `dropDepthTolerance` hinaus. Siehe `MonsterDragGeometry.effectiveMonsterPlaneZ`.
        let monsterBackZ = monsterPlaneZ + monsterBounds.min.z
        let wishedPanelZ = monsterBackZ - LayoutConstants.targetPanelStandoff - panelDepth / 2

        // Das Panel darf nicht hinter die Rückwand des Volumes rutschen — dort würde es
        // angeschnitten. Notfalls rückt es nach vorne; der Z-Spalt wird dadurch nur
        // kleiner, nie größer, die Tiefenprüfung also nie strenger.
        let panelZ = Swift.max(wishedPanelZ, volume.min.z + panelDepth / 2)

        // Das Raster bleibt in grossen Volumes nahe beim Monster statt an die weit
        // entfernten Volume-Kanten zu wandern. In kleinen Volumes gewinnen weiterhin
        // die real gemessenen Grenzen.
        let edgeTopY = volume.max.y - outerMargin - panelHeight / 2
        let topY = Swift.min(
            edgeTopY,
            volume.center.y + LayoutConstants.targetGridTopOffsetFromCenter
        )
        let edgeBottomY = volume.min.y + outerMargin + panelHeight / 2
        let compactBottomY = topY - Float(Swift.max(rows - 1, 0)) * (panelHeight + gap)
        let bottomY = Swift.max(edgeBottomY, compactBottomY)

        var centers: [String: SIMD3<Float>] = [:]
        for slot in slots {
            let x = gridMinX
                + outerMargin
                + panelWidth / 2
                + Float(slot.column) * (panelWidth + gap)

            let y: Float
            if rows <= 1 {
                y = topY
            } else {
                let step = (topY - bottomY) / Float(rows - 1)
                y = topY - Float(slot.row) * step
            }

            centers[slot.id] = SIMD3<Float>(x, y, panelZ)
        }

        return Resolved(panelSize: panelSize, centers: centers)
    }
}
