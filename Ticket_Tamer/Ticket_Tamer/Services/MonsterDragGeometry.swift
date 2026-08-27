import Foundation
import RealityKit
import UIKit
import simd

// MARK: - Gemeinsame Drag-/Drop-Geometrie (Modul 013)

/// Zentrale Geometriequelle für **beide** Zieh-Phasen (Priorisierung und Teamzuordnung).
///
/// Beide Ansichten unterscheiden sich nur noch in Raster, Ziel-IDs, Farben und fachlichem
/// Mapping. Panelgröße, Panelposition, sicherer Zieh-Bereich, 50-%-Prüfung und Z-Prüfung
/// entstehen ausschließlich hier — es gibt keine zweite, abweichende Rechnung.
///
/// ## Drei strikt getrennte Aufgaben
///
/// ```text
/// 1. DRAG-GRENZEN   → safeBounds        (DragBounds)
///    Wo darf sich das Monster bewegen, ohne abgeschnitten zu werden?
///
/// 2. DARSTELLUNG    → panelSize/centers (TargetPanelLayout + TargetPanelFactory)
///    Wo stehen die sichtbaren 3D-Zielpanels und wie groß sind sie?
///
/// 3. DROP-ERKENNUNG → bestTarget(at:)   (DropEvaluator)
///    Liegt das Monster zu mindestens 50 % auf einem Panel und ist es in Z nah genug?
/// ```
///
/// Aufgabe 2 und 3 teilen sich dieselbe Box: die Trefferfläche entsteht aus derselben
/// Panelgröße wie das Mesh. Aufgabe 1 ist davon vollständig unabhängig — der sichere
/// Bereich darf ein Panelzentrum unerreichbar machen, die Drop-Erkennung fragt ohnehin
/// nicht nach Zentren, sondern nach Flächen.
///
/// ## Datenfluss
///
/// ```text
/// GeometryReader3D + RealityView →  update(metrics:)         →  Volume in Metern
/// MonsterAssetProvider.fit(...)  →  measureMonster(_:)       →  sichtbare Monster-Bounds
///           ↓ beides vorhanden
///                                   safeBounds               →  clamped(_:)      (Ziehen)
///                                   applyPanelGeometry(...)  →  Panels + targetBounds
///                                   bestTarget(at:)          →  Highlight + Drop
/// ```
@MainActor
struct MonsterDragGeometry {

    // MARK: - Feste Vorgaben der Phase

    /// Raster und Ziel-IDs dieser Phase.
    let layout: TargetPanelLayout

    /// Tiefenebene, auf der das Monster gezogen wird.
    let monsterPlaneZ: Float

    // MARK: - Gemessener Zustand

    /// Vermessung des Volumes und der Layoutebene. `nil`, solange nicht gemessen.
    private(set) var metrics: VolumeMetrics?

    /// Sichtbare Monster-Ausdehnung relativ zum Root, inklusive Skalierung und Rotation.
    private(set) var monsterBounds: BoundingBox?

    /// Erlaubter Bereich der Monster-Root-Position. `nil`, solange eine Messung fehlt.
    private(set) var safeBounds: DragBounds?

    /// Abmessungen eines Zielpanels. `nil`, solange eine Messung fehlt.
    private(set) var panelSize: SIMD3<Float>?

    /// Trefferflächen in Szenen-Koordinaten, je Ziel-ID — deckungsgleich mit den Panels.
    private(set) var targetBounds: [String: BoundingBox] = [:]

    // MARK: - Einstellungen

    /// Unsichtbarer Zusatzabstand zur Volume-Kante.
    var padding: Float = InteractionConstants.dragSafetyPadding

    // MARK: - Init

    init(layout: TargetPanelLayout, monsterPlaneZ: Float) {
        self.layout = layout
        self.monsterPlaneZ = monsterPlaneZ
    }

    // MARK: - Tatsächliche Zieh-Ebene

    /// Die Tiefenebene, auf der das Monster beim Ziehen **tatsächlich** liegt.
    ///
    /// `monsterPlaneZ` ist nur der Wunschwert aus den Phasenkonstanten. Die Zieh-Bewegung
    /// läuft aber durch `DragBounds.clamp(_:)`, und der klemmt **auch Z**. Liegt der
    /// gemessene Z-Bereich des Volumes nicht symmetrisch um den Wunschwert, verschiebt der
    /// Clamp das Monster in der Tiefe.
    ///
    /// ## Warum das wichtig ist
    ///
    /// Genau diese Verwechslung ließ in der Teamphase jeden Drop scheitern: Die Panels
    /// wurden aus dem **Wunschwert** platziert (Priorisierung 0.06 m, Team 0.00 m), das
    /// Monster lag beim Ziehen aber auf der **geklemmten** Ebene. Der Z-Spalt wuchs
    /// dadurch über `dropDepthTolerance` hinaus — in der Priorisierung blieb er wegen der
    /// 6 cm höheren Konstante gerade noch darunter, in der Teamphase nicht mehr.
    /// Sichtbar war das als „Overlap stimmt, Drop passiert trotzdem nicht".
    ///
    /// Durch die Klemmung hier steht das Panel per Konstruktion immer genau
    /// `targetPanelStandoff` hinter der Ebene, die das Monster erreichen kann — unabhängig
    /// davon, wo der Z-Bereich des Volumes liegt.
    var effectiveMonsterPlaneZ: Float {
        guard let safeBounds else { return monsterPlaneZ }
        return safeBounds.clamp(SIMD3<Float>(0, 0, monsterPlaneZ)).z
    }

    // MARK: - Bereitschaft

    /// `true`, wenn die Zieh-Begrenzung aus echten Messwerten arbeiten kann.
    var canClamp: Bool { safeBounds != nil }

    /// `true`, wenn die Drop-Erkennung über Flächen arbeiten kann.
    var canEvaluateOverlap: Bool { monsterBounds != nil && !targetBounds.isEmpty }

    // MARK: - Volume vermessen

    /// Übernimmt eine neue Volume-Messung.
    ///
    /// - Returns: `true`, wenn sich die Messung geändert hat. Aufrufer nutzen das, um
    ///   nicht bei jedem `RealityView`-Update Zustand zu schreiben.
    @discardableResult
    mutating func update(metrics newMetrics: VolumeMetrics) -> Bool {
        guard newMetrics.isUsable else { return false }
        guard metrics != newMetrics else { return false }

        metrics = newMetrics
        recomputeSafeBounds()
        DebugManager.log(.physics, "Volume gemessen: \(newMetrics.debugSummary)")
        return true
    }

    // MARK: - Monster vermessen

    /// Misst die sichtbare Hülle des geladenen Monsters.
    ///
    /// Muss **nach** `MonsterAssetProvider.fit(_:toMaxExtent:)` aufgerufen werden, damit
    /// die Skalierung in die Messung eingeht. Die Messung schließt Child-Transforms,
    /// Origin-Versatz, Skalierung und Rotation ein — die 50-%-Regel arbeitet dadurch für
    /// jedes der vier Assets auf dessen tatsächlicher Ausdehnung.
    mutating func measureMonster(_ entity: Entity, assetID: String) {
        let bounds = MonsterAssetProvider.localVisualBounds(of: entity)
        monsterBounds = bounds
        recomputeSafeBounds()

        DebugManager.log(
            .physics,
            String(
                format: "Monster asset: %@ | Visual bounds: minX=%.4f maxX=%.4f minY=%.4f maxY=%.4f minZ=%.4f maxZ=%.4f | Breite=%.4f Hoehe=%.4f Tiefe=%.4f",
                assetID,
                bounds.min.x, bounds.max.x,
                bounds.min.y, bounds.max.y,
                bounds.min.z, bounds.max.z,
                bounds.extents.x, bounds.extents.y, bounds.extents.z
            )
        )
        if let safeBounds {
            DebugManager.log(.physics, "Safe drag bounds: \(safeBounds.debugSummary)")
        }
    }

    /// Leitet den sicheren Root-Bereich neu ab, sobald beide Messungen vorliegen.
    private mutating func recomputeSafeBounds() {
        guard let metrics, metrics.isUsable, let monsterBounds else {
            safeBounds = nil
            return
        }

        let safe = DragBounds.safeRegion(
            volume: metrics.volume,
            monsterBounds: monsterBounds,
            padding: padding
        )
        safeBounds = safe

        if safe.hasCollapsedAxis {
            DebugManager.log(
                .physics,
                "Hinweis: Monster fuellt eine Achse des Volumes vollstaendig aus — \(safe.debugSummary)"
            )
        }
    }

    // MARK: - Panels bemaßen und platzieren

    /// Berechnet die Panelgeometrie und schreibt sie in die Ziel-Entities.
    ///
    /// Setzt Position, Mesh und `DropTargetComponent.halfExtents` aus **einer** Quelle —
    /// dadurch sind sichtbares Panel und Drop-Zone konstruktiv deckungsgleich.
    ///
    /// - Parameters:
    ///   - entities: Die Ziel-Entities aus `TargetPanelFactory.makeTarget(id:debugName:)`.
    ///   - tint: Farbe je Ziel-ID. Rein zur Unterscheidbarkeit, keine Bewertungssemantik.
    ///   - highlightedID: Das aktuell hervorgehobene Ziel, falls eines hervorgehoben ist.
    mutating func applyPanelGeometry(
        to entities: [Entity],
        tint: (String) -> UIColor,
        highlightedID: String?
    ) {
        guard let metrics, metrics.isUsable, let monsterBounds else { return }

        let resolved = layout.resolve(
            volume: metrics.volume,
            monsterBounds: monsterBounds,
            // Nicht `monsterPlaneZ`, sondern die Ebene, die das Monster tatsächlich
            // erreicht — siehe `effectiveMonsterPlaneZ`.
            monsterPlaneZ: effectiveMonsterPlaneZ
        )

        panelSize = resolved.panelSize
        targetBounds = resolved.allBounds

        for entity in entities {
            guard let component = entity.components[DropTargetComponent.self],
                  let center = resolved.centers[component.id]
            else { continue }

            TargetPanelFactory.updateGeometry(
                of: entity,
                size: resolved.panelSize,
                center: center,
                tint: tint(component.id),
                highlighted: component.id == highlightedID
            )
        }

        logPanelGeometry(resolved)
    }

    /// Protokolliert Panelmaße, Zielflächen und den **maximal erreichbaren** Überlappungsanteil.
    ///
    /// Der letzte Wert ist der wichtigste: er beantwortet ohne Ausprobieren die Frage, ob
    /// die 50-%-Schwelle für ein Ziel überhaupt erreichbar ist. Dazu wird das Monster
    /// rechnerisch so nah wie erlaubt an die Panelmitte gesetzt — also durch dieselbe
    /// Klemmung geführt wie beim echten Ziehen — und das Ergebnis bewertet.
    ///
    /// Liegt der Wert unter der Schwelle, nennt die Ausgabe den geometrischen Grund.
    private func logPanelGeometry(_ resolved: TargetPanelLayout.Resolved) {
        guard let monsterBounds, let safeBounds else { return }

        DebugManager.log(
            .physics,
            String(
                format: "Panelgroesse: %.3f x %.3f x %.3f m | Monster: %.3f x %.3f x %.3f m | Zieh-Ebene Z: gewuenscht %.3f, tatsaechlich %.3f",
                resolved.panelSize.x, resolved.panelSize.y, resolved.panelSize.z,
                monsterBounds.extents.x, monsterBounds.extents.y, monsterBounds.extents.z,
                monsterPlaneZ, effectiveMonsterPlaneZ
            )
        )

        let allTargets = resolved.allBounds.map { DropEvaluator.BoxTarget(id: $0.key, bounds: $0.value) }

        for slot in layout.slots {
            guard let box = resolved.bounds(for: slot.id) else { continue }

            DebugManager.log(
                .physics,
                String(
                    format: "Target: %@ | Target bounds: min=(%.3f, %.3f, %.3f) max=(%.3f, %.3f, %.3f)",
                    slot.id,
                    box.min.x, box.min.y, box.min.z,
                    box.max.x, box.max.y, box.max.z
                )
            )

            // Bestmögliche erlaubte Position: Panelmitte, geklemmt auf den sicheren Bereich.
            let best = safeBounds.clamp(box.center)
            guard let hull = monsterWorldBounds(at: best) else { continue }

            let results = DropEvaluator.evaluateTargets(
                monsterBounds: hull,
                targets: allTargets,
                minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
                depthTolerance: InteractionConstants.dropDepthTolerance
            )
            guard let own = results.first(where: { $0.id == slot.id }) else { continue }

            DebugManager.log(
                .physics,
                String(
                    format: "Target: %@ | Maximum reachable overlap: %.3f | Depth distance: %.3f (%@) | erreichbar: %@",
                    slot.id,
                    own.overlapRatio,
                    own.depthGap,
                    own.isDepthValid ? "valid" : "invalid",
                    own.isValid ? "ja" : "NEIN"
                )
            )

            if !own.isValid {
                DebugManager.log(.physics, "Target: \(slot.id) | Grund: \(reason(for: own, panelSize: resolved.panelSize, monsterBounds: monsterBounds))")
            }
        }
    }

    /// Nennt den geometrischen Grund, warum ein Ziel nicht erreichbar ist.
    ///
    /// Bewusst als Text und nicht als Zahl: die Ausgabe soll ohne Nachrechnen lesbar sein.
    private func reason(
        for result: DropEvaluator.OverlapResult,
        panelSize: SIMD3<Float>,
        monsterBounds: BoundingBox
    ) -> String {
        if !result.isDepthValid {
            return String(
                format: "Z-Abstand %.3f m ueberschreitet die Toleranz %.3f m — Panel und Zieh-Ebene liegen nicht auf derselben Tiefe",
                result.depthGap, InteractionConstants.dropDepthTolerance
            )
        }
        if panelSize.y < monsterBounds.extents.y * InteractionConstants.minimumDropOverlapRatio {
            return String(
                format: "Panel ist mit %.3f m zu flach fuer ein %.3f m hohes Monster (Schwelle braucht mindestens %.3f m)",
                panelSize.y, monsterBounds.extents.y,
                monsterBounds.extents.y * InteractionConstants.minimumDropOverlapRatio
            )
        }
        if panelSize.x < monsterBounds.extents.x * InteractionConstants.minimumDropOverlapRatio {
            return String(
                format: "Panel ist mit %.3f m zu schmal fuer ein %.3f m breites Monster",
                panelSize.x, monsterBounds.extents.x
            )
        }
        return String(
            format: "Sicherer Zieh-Bereich laesst das Monster nicht nah genug heran (erreicht %.3f, noetig %.2f)",
            result.overlapRatio, InteractionConstants.minimumDropOverlapRatio
        )
    }

    // MARK: - Anwendung beim Ziehen

    /// Begrenzt eine gewünschte Root-Position auf den sicheren Bereich.
    ///
    /// - Returns: Die geklemmte Position, oder `nil`, solange keine Messung vorliegt.
    func clamped(_ requested: SIMD3<Float>) -> SIMD3<Float>? {
        safeBounds?.clamp(requested)
    }

    // MARK: - Auswertung

    /// Sichtbare Monsterhülle in Szenen-Koordinaten für eine gegebene Root-Position.
    func monsterWorldBounds(at position: SIMD3<Float>) -> BoundingBox? {
        guard let monsterBounds else { return nil }
        return BoundingBox(
            min: monsterBounds.min + position,
            max: monsterBounds.max + position
        )
    }

    /// Zielflächen im Format des `DropEvaluator`.
    var boxTargets: [DropEvaluator.BoxTarget] {
        targetBounds
            .map { DropEvaluator.BoxTarget(id: $0.key, bounds: $0.value) }
            .sorted { $0.id < $1.id }
    }

    /// Das Ziel, das bei einem Loslassen an dieser Position gewählt würde.
    ///
    /// Dieselbe Funktion versorgt das Hover-Highlight **und** die Drop-Auswertung. Das
    /// Highlight kann dadurch nie etwas anderes ankündigen, als der Drop dann tut.
    /// Sie speichert nichts und verändert keinen Zustand — die Entscheidung fällt
    /// ausschließlich im `onEnded` des Gesture-Handlers.
    func bestTarget(at position: SIMD3<Float>) -> DropEvaluator.OverlapResult? {
        guard let hull = monsterWorldBounds(at: position), !targetBounds.isEmpty else {
            return nil
        }
        return DropEvaluator.bestTarget(
            monsterBounds: hull,
            targets: boxTargets,
            minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
            depthTolerance: InteractionConstants.dropDepthTolerance
        )
    }

    /// Vollständiger Trace **eines** Drop-Vorgangs — und zugleich die Entscheidung selbst.
    ///
    /// Bewusst eine einzige Funktion für Protokoll und Ergebnis: so kann die Ausgabe
    /// nicht von dem abweichen, was tatsächlich entschieden wird. Der Rückgabewert ist
    /// identisch zu `bestTarget(at:)`; die Auswertungsmathematik ist unverändert.
    ///
    /// Die Ausgabe folgt der Kette
    /// `Drag → Bounds → Target-Bounds → Overlap → Depth → Valid Target → Release`
    /// und zeigt jede Stufe getrennt, damit sichtbar ist, an welcher Stelle sie abbricht.
    @discardableResult
    func logDropTrace(
        view: String,
        monster: Entity,
        at position: SIMD3<Float>,
        highlightBeforeRelease: String?,
        inputLocked: Bool,
        alreadyCommitted: Bool
    ) -> DropEvaluator.OverlapResult? {
        let winner = bestTarget(at: position)

        guard let hull = monsterWorldBounds(at: position) else {
            DebugManager.log(.physics, "=== DROP DEBUG === \(view): keine Monster-Bounds gemessen — Kette bricht vor der Auswertung ab")
            return nil
        }

        let targets = boxTargets
        let results = DropEvaluator.evaluateTargets(
            monsterBounds: hull,
            targets: targets,
            minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
            depthTolerance: InteractionConstants.dropDepthTolerance
        )

        DebugManager.log(.physics, "=== DROP DEBUG ===")
        DebugManager.log(.physics, "View: \(view)")
        DebugManager.log(
            .physics,
            String(
                format: "Monster world transform: pos=(%.4f, %.4f, %.4f) scale=(%.4f, %.4f, %.4f)",
                monster.position(relativeTo: nil).x,
                monster.position(relativeTo: nil).y,
                monster.position(relativeTo: nil).z,
                monster.scale(relativeTo: nil).x,
                monster.scale(relativeTo: nil).y,
                monster.scale(relativeTo: nil).z
            )
        )
        DebugManager.log(.physics, "Monster local transform: \(monster.dragStateSummary)")
        DebugManager.log(
            .physics,
            String(
                format: "Monster bounds: min=(%.3f, %.3f, %.3f) max=(%.3f, %.3f, %.3f)",
                hull.min.x, hull.min.y, hull.min.z, hull.max.x, hull.max.y, hull.max.z
            )
        )
        DebugManager.log(
            .physics,
            "Projection plane / axes: Szenen-X/Y, achsenparallel (Panels ohne Rotation) — keine Kameraprojektion"
        )
        DebugManager.log(
            .physics,
            String(
                format: "Zieh-Ebene Z: gewuenscht %.3f, tatsaechlich %.3f",
                monsterPlaneZ, effectiveMonsterPlaneZ
            )
        )

        for result in results {
            guard let box = targetBounds[result.id] else { continue }
            DebugManager.log(.physics, "--- Target: \(result.id)")
            DebugManager.log(
                .physics,
                String(
                    format: "    Target bounds: min=(%.3f, %.3f, %.3f) max=(%.3f, %.3f, %.3f)",
                    box.min.x, box.min.y, box.min.z, box.max.x, box.max.y, box.max.z
                )
            )
            DebugManager.log(
                .physics,
                String(
                    format: "    Monster relevant area: %.5f | Target area: %.5f | Intersection area: %.5f",
                    result.monsterArea, DropEvaluator.projectedAreaXY(box), result.intersectionArea
                )
            )
            DebugManager.log(
                .physics,
                String(
                    format: "    Overlap ratio: %.3f | Required overlap ratio: %.2f | overlapValid: %@",
                    result.overlapRatio,
                    InteractionConstants.minimumDropOverlapRatio,
                    result.overlapRatio >= InteractionConstants.minimumDropOverlapRatio ? "true" : "false"
                )
            )
            DebugManager.log(
                .physics,
                String(
                    format: "    Depth distance: %.3f | Depth tolerance: %.3f | Depth valid: %@",
                    result.depthGap, InteractionConstants.dropDepthTolerance,
                    result.isDepthValid ? "true" : "false"
                )
            )
            DebugManager.log(.physics, "    Geometry valid: \(result.isValid)")
        }

        DebugManager.log(.physics, "Current valid target before release: \(highlightBeforeRelease ?? "nil")")
        DebugManager.log(.physics, "Current valid target during release: \(winner?.id ?? "nil")")
        DebugManager.log(.physics, "Input locked: \(inputLocked)")
        DebugManager.log(.physics, "Decision already committed: \(alreadyCommitted)")
        DebugManager.log(.physics, "Result: \(winner.map { "VALID -> \($0.id)" } ?? "INVALID -> Snapback")")
        DebugManager.log(.physics, "=== /DROP DEBUG ===")

        return winner
    }
}
