import RealityKit
import simd
import Foundation

// MARK: - Drop-Auswertung (Modul 007 — F-10 / AK-10)

/// Bewertet, ob ein Drop gültig oder ungültig ist.
///
/// Die positionsbasierte Kernfunktion (`evaluate(entityPosition:targets:)`) arbeitet
/// mit reinen SIMD3-Werten und ist ohne laufenden RealityKit-Render-Loop unit-testbar.
/// Die Entity-Convenience-Methode ist für den Einsatz in Gesture-Handlern gedacht.
///
/// **Strategie:** Sphärische Proximity-Prüfung im Weltkoordinatensystem.
/// Keine Bildschirmkoordinaten-Hacks, keine Physik-Simulation.
/// Bei mehreren gleichzeitig getroffenen Zielen gewinnt das räumlich nächste.
/// Konstruktiv werden Überschneidungen durch ausreichend große Abstände zwischen
/// Zielbereichen verhindert (Verantwortung der aufrufenden Phase).
enum DropEvaluator {

    // MARK: - Ziel-Descriptor (für Unit-Tests ohne RealityKit-Szene)

    /// Positionsbasierter Descriptor eines generischen Zielbereichs.
    struct TargetDescriptor {
        /// Fachlich neutrale Ziel-ID.
        let id: String
        /// Position des Zielbereichs im Weltkoordinatensystem.
        let position: SIMD3<Float>
        /// Trefferradius in Metern.
        let radius: Float
    }

    // MARK: - Positionsbasierte Auswertung (unit-testbar)

    /// Prüft, ob `entityPosition` in einem der Zielbereiche liegt.
    ///
    /// - Parameters:
    ///   - entityPosition: Weltposition der gedroppten Entity.
    ///   - targets: Zu prüfende Zielbereiche.
    /// - Returns: ID des getroffenen Ziels bei gültigem Drop, `nil` bei ungültigem Drop.
    static func evaluate(
        entityPosition: SIMD3<Float>,
        targets: [TargetDescriptor]
    ) -> String? {
        var bestID: String?
        var bestDistance = Float.infinity

        for target in targets {
            let distance = simd_distance(entityPosition, target.position)
            if distance <= target.radius, distance < bestDistance {
                bestDistance = distance
                bestID = target.id
            }
        }

        return bestID
    }

    // MARK: - Spaltenbasierte Auswertung (Ziele in einer horizontalen Reihe)

    /// Wählt unter Zielen, die in einer Reihe nebeneinander liegen, dasjenige mit der
    /// geringsten **X-Abweichung** — sofern die Entity gegenüber `origin` weit genug
    /// angehoben wurde.
    ///
    /// **Warum zusätzlich zur radiusbasierten Prüfung:**
    /// `evaluate(entityPosition:targets:)` verlangt, dass die Entity innerhalb eines
    /// absoluten Radius um einen absoluten Meterwert landet. Wie weit sich eine Entity per
    /// Drag überhaupt bewegen lässt, hängt aber von der tatsächlichen Fenster- und
    /// Volumegröße ab und ist im Voraus nicht bekannt. Liegt ein Ziel außerhalb der
    /// erreichbaren Fläche, kann es mit einer Radiusprüfung nie getroffen werden.
    ///
    /// Genau das war der Fehler in der Priorisierungsphase: das mittlere Ziel lag 0.21 m von
    /// der Ausgangsposition entfernt und war ab 0.06 m Bewegung erreichbar, die äußeren
    /// Ziele lagen 0.38 m entfernt und hätten 0.23 m Bewegung erfordert. Deshalb ließ sich
    /// ausschließlich „Wichtig" zuweisen.
    ///
    /// Die Spaltenaufteilung ist gegenüber dieser Unbekannten robust: die erreichbare Fläche
    /// wird implizit unter allen Zielen aufgeteilt, die Entscheidungsgrenze liegt jeweils
    /// genau mittig zwischen zwei benachbarten Zielen. Alle Ziele sind damit gleichwertig —
    /// gleiche Trefferqualität, gleiche Validierung, gleiche Zustandsaktualisierung.
    ///
    /// - Parameters:
    ///   - entityPosition: Weltposition der abgelegten Entity.
    ///   - origin: Ausgangsposition der Entity zu Beginn der Phase.
    ///   - targets: Ziele der Reihe. `radius` wird hier bewusst nicht ausgewertet.
    ///   - minimumLift: Mindesthöhe über `origin.y`, ab der eine Ablage als gewollt gilt.
    /// - Returns: ID des gewählten Ziels, oder `nil` wenn die Entity nicht weit genug
    ///   angehoben wurde. `nil` bedeutet ungültige Ablage (F-10 / AK-10): kein
    ///   Zustandswechsel, Rückkehr zur Ausgangsposition.
    static func evaluateColumn(
        entityPosition: SIMD3<Float>,
        origin: SIMD3<Float>,
        targets: [TargetDescriptor],
        minimumLift: Float
    ) -> String? {
        // Ungültige Ablage: die Entity wurde nicht spürbar in Richtung der Zielreihe bewegt.
        guard entityPosition.y - origin.y >= minimumLift else { return nil }

        var bestID: String?
        var bestDistance = Float.infinity

        for target in targets {
            let distance = abs(entityPosition.x - target.position.x)
            if distance < bestDistance {
                bestDistance = distance
                bestID = target.id
            }
        }

        return bestID
    }

    // MARK: - Nächster-Nachbar-Auswertung (Ziele in mehreren Richtungen)

    /// Wählt das räumlich nächstgelegene Ziel — sofern die Entity `origin` um mindestens
    /// `minimumDistance` verlassen hat.
    ///
    /// Pendant zu `evaluateColumn` für Anordnungen, die sich nicht auf eine Achse
    /// reduzieren lassen (Teamphase: 2×2-Raster). Dieselbe Begründung gilt: absolute
    /// Trefferradien um absolute Meterpositionen setzen voraus, dass die erreichbare Fläche
    /// bekannt ist. Sie hängt aber von der Volumegröße ab und ändert sich mit ihr — nach der
    /// Vergrößerung des Volumes auf 1.0 × 1.0 m lagen die Teamstationen außerhalb des
    /// Radius, den man beim Ziehen zum jeweiligen Label tatsächlich erreicht.
    ///
    /// Die Nächster-Nachbar-Auswahl teilt die erreichbare Fläche implizit unter den Zielen
    /// auf; die Grenzen verlaufen mittig zwischen benachbarten Zielen.
    ///
    /// - Parameters:
    ///   - entityPosition: Weltposition der abgelegten Entity.
    ///   - origin: Ausgangsposition der Entity zu Beginn der Phase.
    ///   - targets: Zu prüfende Ziele. `radius` wird hier bewusst nicht ausgewertet.
    ///   - minimumDistance: Mindestbewegung gegenüber `origin`, ab der eine Ablage als
    ///     gewollt gilt.
    /// - Returns: ID des gewählten Ziels, oder `nil` bei zu geringer Bewegung
    ///   (ungültige Ablage, F-10 / AK-10).
    static func evaluateNearest(
        entityPosition: SIMD3<Float>,
        origin: SIMD3<Float>,
        targets: [TargetDescriptor],
        minimumDistance: Float
    ) -> String? {
        guard simd_distance(entityPosition, origin) >= minimumDistance else { return nil }

        var bestID: String?
        var bestDistance = Float.infinity

        for target in targets {
            let distance = simd_distance(entityPosition, target.position)
            if distance < bestDistance {
                bestDistance = distance
                bestID = target.id
            }
        }

        return bestID
    }

    // MARK: - Entity-Convenience (für Gesture-Handler)

    /// Prüft, ob `entity` in einem der als `DropTargetComponent` markierten Ziele liegt.
    ///
    /// Nutzt `entity.position(relativeTo: nil)` für konsistente Weltkoordinaten.
    ///
    /// - Parameters:
    ///   - entity: Die gedroppte Monster-Entity.
    ///   - targets: Paare aus Ziel-Entity und zugehöriger `DropTargetComponent`.
    /// - Returns: ID des getroffenen Ziels bei gültigem Drop, `nil` bei ungültigem Drop.
    static func evaluate(
        entity: Entity,
        targets: [(entity: Entity, component: DropTargetComponent)]
    ) -> String? {
        let entityPos = entity.position(relativeTo: nil)
        let descriptors = targets.map {
            TargetDescriptor(
                id: $0.component.id,
                position: $0.entity.position(relativeTo: nil),
                radius: $0.component.radius
            )
        }
        return evaluate(entityPosition: entityPos, targets: descriptors)
    }
}

// MARK: - Flächenbasierte Auswertung (Modul 013 — 3D-Zielstationen)

extension DropEvaluator {

    // MARK: - Ziel-Descriptor mit Fläche

    /// Zielbereich als achsenparallele Box statt als Punkt mit Radius.
    ///
    /// `bounds` ist exakt die Box des **sichtbaren** 3D-Panels: beide entstehen in
    /// `TargetPanelFactory.updateGeometry(of:size:center:tint:highlighted:)` aus derselben
    /// Größe. Eine unsichtbare, nach innen verschobene Trefferfläche kann deshalb gar
    /// nicht mehr entstehen.
    struct BoxTarget {
        /// Fachlich neutrale Ziel-ID.
        let id: String
        /// Zielfläche in Szenen-Koordinaten (Meter).
        let bounds: BoundingBox
    }

    // MARK: - Ergebnis einer Einzelprüfung

    /// Vollständiges Prüfergebnis für **ein** Ziel — inklusive aller Zwischenwerte.
    ///
    /// Die Zwischenwerte sind bewusst Teil des Ergebnisses und nicht nur Debug-Ausgabe:
    /// Die 50-%-Regel soll nachvollziehbar sein, nicht geglaubt werden müssen.
    struct OverlapResult {
        /// Fachlich neutrale Ziel-ID.
        let id: String
        /// Projizierte Monsterfläche in m² (X/Y).
        let monsterArea: Float
        /// Schnittfläche von Monster und Ziel in m² (X/Y).
        let intersectionArea: Float
        /// `intersectionArea / monsterArea`.
        let overlapRatio: Float
        /// Abstand der Oberflächen in Z, 0 bei Überlappung der Z-Bereiche.
        let depthGap: Float
        /// Ob der Z-Abstand innerhalb der Toleranz liegt.
        let isDepthValid: Bool
        /// Ob dieses Ziel für sich genommen ein gültiger Drop wäre.
        let isValid: Bool

        /// Eine Zeile je Ziel für `DebugManager`-Ausgaben.
        var debugSummary: String {
            String(
                format: "Target: %@ | Projected monster area: %.5f | Intersection area: %.5f | Overlap ratio: %.3f | Depth distance: %.3f (%@) | Is valid: %@",
                id,
                monsterArea,
                intersectionArea,
                overlapRatio,
                depthGap,
                isDepthValid ? "valid" : "invalid",
                isValid ? "true" : "false"
            )
        }
    }

    // MARK: - Geometrische Grundoperationen

    /// Projizierte Fläche einer Box auf die X/Y-Ebene in m².
    ///
    /// **Projektion auf die Zielebene, nicht auf die Bildebene.** Beide Boxen liegen
    /// achsenparallel in Szenen-Koordinaten; die Rechnung ist damit unabhängig davon, aus
    /// welchem Winkel die Nutzerin gerade schaut. Derselbe räumliche Zustand ergibt immer
    /// dasselbe Ergebnis.
    static func projectedAreaXY(_ box: BoundingBox) -> Float {
        Swift.max(box.max.x - box.min.x, 0) * Swift.max(box.max.y - box.min.y, 0)
    }

    /// Schnittfläche zweier Boxen auf der X/Y-Ebene in m².
    static func intersectionAreaXY(_ a: BoundingBox, _ b: BoundingBox) -> Float {
        let width  = Swift.min(a.max.x, b.max.x) - Swift.max(a.min.x, b.min.x)
        let height = Swift.min(a.max.y, b.max.y) - Swift.max(a.min.y, b.min.y)
        guard width > 0, height > 0 else { return 0 }
        return width * height
    }

    /// Anteil der **Monsterfläche**, der innerhalb der Zielfläche liegt.
    ///
    /// ```text
    /// overlapRatio = Schnittfläche / projizierte Monsterfläche
    /// ```
    ///
    /// Der Nenner ist bewusst die Monsterfläche und nicht die kleinere der beiden Flächen.
    /// Nur so entspricht der Wert dem, was man sieht: *wie viel vom Monster liegt auf dem
    /// Ziel?* Mit der kleineren Fläche als Nenner reichte ein schmaler Monsterstreifen, der
    /// ein kleines Ziel vollständig überdeckt, für eine hohe Ratio — genau daher kamen die
    /// gültigen Drops bei rund 10 % sichtbarer Überlappung.
    ///
    /// - Returns: 0 bei fehlender Überlappung, 1 wenn das Monster vollständig innerhalb
    ///   der Zielfläche liegt.
    static func overlapRatio(monsterBounds: BoundingBox, targetBounds: BoundingBox) -> Float {
        let area = projectedAreaXY(monsterBounds)
        guard area > .leastNormalMagnitude else { return 0 }
        return intersectionAreaXY(monsterBounds, targetBounds) / area
    }

    /// Abstand zweier Boxen entlang Z, gemessen zwischen den **Oberflächen**.
    ///
    /// ```text
    /// gap = max(0, max(aMinZ, bMinZ) - min(aMaxZ, bMaxZ))
    /// ```
    ///
    /// Überlappen sich die Z-Bereiche, ist der Spalt 0. Bewusst nicht der Abstand der
    /// Mittelpunkte: der würde mit der Tiefe des Monsters mitwachsen und die Prüfung je
    /// Asset unterschiedlich streng machen. Das Spaltmaß ist davon unabhängig.
    static func depthGap(_ a: BoundingBox, _ b: BoundingBox) -> Float {
        Swift.max(0, Swift.max(a.min.z, b.min.z) - Swift.min(a.max.z, b.max.z))
    }

    // MARK: - Auswertung

    /// Prüft die Monsterhülle gegen **alle** Ziele und liefert die vollständige Diagnose.
    ///
    /// Die Reihenfolge folgt der Ziel-ID, damit Debug-Ausgaben zwischen zwei Durchläufen
    /// vergleichbar bleiben.
    static func evaluateTargets(
        monsterBounds: BoundingBox,
        targets: [BoxTarget],
        minimumOverlapRatio: Float,
        depthTolerance: Float
    ) -> [OverlapResult] {
        let monsterArea = projectedAreaXY(monsterBounds)

        return targets
            .sorted { $0.id < $1.id }
            .map { target in
                let intersection = intersectionAreaXY(monsterBounds, target.bounds)
                let ratio = monsterArea > .leastNormalMagnitude ? intersection / monsterArea : 0
                let gap = depthGap(monsterBounds, target.bounds)
                let depthValid = gap <= depthTolerance

                return OverlapResult(
                    id: target.id,
                    monsterArea: monsterArea,
                    intersectionArea: intersection,
                    overlapRatio: ratio,
                    depthGap: gap,
                    isDepthValid: depthValid,
                    isValid: depthValid && ratio >= minimumOverlapRatio
                )
            }
    }

    /// Bestimmt das **eine** Ziel, das gerade gewählt würde.
    ///
    /// ## Warum höchstens eines
    ///
    /// Die Panels sind innerhalb einer Reihe in X disjunkt und zwischen den Reihen in Y
    /// disjunkt. Die X-Anteile eines Monsters können sich also über alle Ziele hinweg zu
    /// höchstens 1 summieren — zwei Ziele gleichzeitig über 50 % sind damit geometrisch
    /// ausgeschlossen. Die Auswahl nach größter Ratio ist trotzdem implementiert, damit
    /// das Verhalten auch bei einem künftig geänderten Raster deterministisch bleibt; bei
    /// exakt gleicher Ratio entscheidet die Ziel-ID.
    ///
    /// Dieselbe Funktion liefert das Hover-Highlight **und** den Drop beim Loslassen.
    /// Dadurch kann das Highlight nie etwas anderes anzeigen, als der Drop dann tut.
    static func bestTarget(
        monsterBounds: BoundingBox,
        targets: [BoxTarget],
        minimumOverlapRatio: Float,
        depthTolerance: Float
    ) -> OverlapResult? {
        evaluateTargets(
            monsterBounds: monsterBounds,
            targets: targets,
            minimumOverlapRatio: minimumOverlapRatio,
            depthTolerance: depthTolerance
        )
        .filter(\.isValid)
        .max { lhs, rhs in
            if lhs.overlapRatio == rhs.overlapRatio { return lhs.id > rhs.id }
            return lhs.overlapRatio < rhs.overlapRatio
        }
    }
}
