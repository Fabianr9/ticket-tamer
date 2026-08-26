import CoreGraphics
import RealityKit
import simd
import Foundation

// MARK: - Gemeinsame Drag-/Drop-Geometrie (Modul 013 — Drag-/Drop-Randfix)

/// Zentrale Geometriequelle für **beide** Zieh-Phasen (Priorisierung und Teamzuordnung).
///
/// Priorisierung und Teamzuordnung hatten dieselbe technische Ursache — geratene statt
/// gemessener Grenzen — und bekommen deshalb bewusst **eine** Lösung, nicht zwei.
/// `PrioritizationView` und `TeamAssignmentView` unterscheiden sich danach nur noch in
/// Zielanzahl, Anordnung und fachlichem Mapping.
///
/// ## Zwei strikt getrennte Aufgaben
///
/// ```text
/// 1. DRAG-GRENZEN   → safeBounds      (DragBounds)
///    Wo darf sich das Monster bewegen, ohne abgeschnitten zu werden?
///
/// 2. DROP-ERKENNUNG → targetBounds    (DropEvaluator.evaluateOverlap)
///    Überlappt die sichtbare Monsterhülle eine sichtbare Zielfläche ausreichend?
/// ```
///
/// Beide teilen keine Konstante. Der sichere Bereich darf ein Ziel-Zentrum unerreichbar
/// machen — die Drop-Erkennung interessiert sich nicht für Zentren, sondern für Flächen.
///
/// ## Datenfluss
///
/// ```text
/// GeometryReader3D + RealityView   →  update(metrics:)      →  Volume in Metern
/// MonsterAssetProvider.fit(...)    →  measureMonster(_:)    →  sichtbare Monster-Bounds
///           ↓ beides vorhanden
///                                     safeBounds            →  clamped(_:) beim Ziehen
///
/// TargetFramePreferenceKey         →  updateTargets(...)    →  Zielflächen in Metern
///                                     targetBounds          →  hitTarget(at:) beim Release
/// ```
@MainActor
struct MonsterDragGeometry {

    // MARK: - Gemessener Zustand

    /// Vermessung des Volumes und der Layoutebene. `nil`, solange nicht gemessen.
    private(set) var metrics: VolumeMetrics?

    /// Sichtbare Monster-Ausdehnung relativ zum Root, inklusive Skalierung.
    private(set) var monsterBounds: BoundingBox?

    /// Erlaubter Bereich der Monster-Root-Position. `nil`, solange eine Messung fehlt.
    private(set) var safeBounds: DragBounds?

    /// Zielflächen in Szenen-Koordinaten, je Ziel-ID.
    private(set) var targetBounds: [String: BoundingBox] = [:]

    // MARK: - Einstellungen

    /// Unsichtbarer Zusatzabstand zur Volume-Kante.
    var padding: Float = InteractionConstants.dragSafetyPadding

    // MARK: - Init

    /// Leerer Ausgangszustand — noch nichts vermessen.
    ///
    /// Explizit ausgeschrieben, weil die gemessenen Eigenschaften `private(set)` sind und
    /// der synthetisierte memberwise-Initialisierer dadurch nicht ansichtsweit sichtbar wäre.
    init() {}

    // MARK: - Bereitschaft

    /// `true`, wenn die Zieh-Begrenzung aus echten Messwerten arbeiten kann.
    var canClamp: Bool { safeBounds != nil }

    /// `true`, wenn die Drop-Erkennung über Überlappung arbeiten kann.
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
    /// die Skalierung in die Messung eingeht.
    mutating func measureMonster(_ entity: Entity, assetID: String) {
        let bounds = MonsterAssetProvider.localVisualBounds(of: entity)
        monsterBounds = bounds
        recomputeSafeBounds()

        DebugManager.log(
            .physics,
            String(
                format: "Monster asset: %@ | Visual bounds: minX=%.4f maxX=%.4f minY=%.4f maxY=%.4f minZ=%.4f maxZ=%.4f",
                assetID,
                bounds.min.x, bounds.max.x,
                bounds.min.y, bounds.max.y,
                bounds.min.z, bounds.max.z
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

    // MARK: - Ziele an die sichtbaren Boxen binden

    /// Setzt die DropTarget-Entities exakt auf die gemessenen Rahmen der sichtbaren Labels.
    ///
    /// Die sichtbaren Beschriftungen werden dabei **nicht** bewegt — sie bleiben, wo das
    /// SwiftUI-Layout sie setzt. Bewegt wird ausschließlich die technische Trefferfläche,
    /// und zwar **auf** die sichtbare Box zu, nie zur Mitte hin.
    ///
    /// - Parameters:
    ///   - labelFrames: Rahmen der sichtbaren Labels je Ziel-ID, in Punkten.
    ///   - entities: Die Zielentities mit gesetzter `DropTargetComponent`.
    ///   - dropPlaneZ: Tiefenebene, auf der die Zielflächen liegen sollen. Sinnvoll ist
    ///     die Zieh-Ebene des Monsters; die Auswertung prüft ohnehin nur X und Y.
    mutating func updateTargets(
        labelFrames: [String: CGRect],
        entities: [Entity],
        dropPlaneZ: Float
    ) {
        guard let metrics, metrics.isUsable, !labelFrames.isEmpty else { return }

        var measured: [String: BoundingBox] = [:]

        for entity in entities {
            guard var component = entity.components[DropTargetComponent.self] else { continue }
            guard let frame = labelFrames[component.id], frame.width > 1, frame.height > 1 else { continue }

            let box = metrics.sceneBox(
                fromLayout: frame,
                z: dropPlaneZ,
                depth: InteractionConstants.dropTargetPlaneDepth
            )

            entity.position = box.center
            component.halfExtents = box.extents / 2
            entity.components.set(component)
            measured[component.id] = box

            DebugManager.log(
                .physics,
                String(
                    format: "Target: %@ position=(%.3f, %.3f, %.3f) bounds: minX=%.3f maxX=%.3f minY=%.3f maxY=%.3f",
                    component.id,
                    box.center.x, box.center.y, box.center.z,
                    box.min.x, box.max.x, box.min.y, box.max.y
                )
            )
        }

        guard !measured.isEmpty else { return }
        targetBounds = measured
    }

    // MARK: - Anwendung beim Ziehen

    /// Begrenzt eine gewünschte Root-Position auf den sicheren Bereich.
    ///
    /// - Returns: Die geklemmte Position, oder `nil`, solange keine Messung vorliegt.
    ///   Aufrufer fallen dann auf `PlanarDrag.playAreaLimits(forEntityOfSize:)` zurück.
    func clamped(_ requested: SIMD3<Float>) -> SIMD3<Float>? {
        safeBounds?.clamp(requested)
    }

    // MARK: - Anwendung beim Loslassen

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

    /// Ermittelt das getroffene Ziel über die X/Y-Überlappung der sichtbaren Flächen.
    ///
    /// - Returns: Ziel-ID bei ausreichender Überlappung, sonst `nil` (ungültiger Drop).
    func hitTarget(at position: SIMD3<Float>) -> String? {
        guard let monsterWorld = monsterWorldBounds(at: position), !targetBounds.isEmpty else {
            return nil
        }
        let targets = boxTargets

        DebugManager.log(
            .physics,
            String(
                format: "Monster bounds at release: minX=%.3f maxX=%.3f minY=%.3f maxY=%.3f",
                monsterWorld.min.x, monsterWorld.max.x,
                monsterWorld.min.y, monsterWorld.max.y
            )
        )
        DebugManager.log(
            .physics,
            "overlap/intersection: "
                + DropEvaluator.overlapDebugSummary(monsterBounds: monsterWorld, targets: targets)
                + String(format: " (Schwelle %.2f)", InteractionConstants.minimumDropOverlapRatio)
        )

        let selected = DropEvaluator.evaluateOverlap(
            monsterBounds: monsterWorld,
            targets: targets,
            minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio
        )
        DebugManager.log(.physics, "selected target: \(selected ?? "-")")
        return selected
    }
}
