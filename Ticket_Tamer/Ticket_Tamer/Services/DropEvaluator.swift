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

// MARK: - Überlappungsbasierte Auswertung (Modul 013 — Drag-/Drop-Randfix)

extension DropEvaluator {

    // MARK: - Ziel-Descriptor mit Fläche

    /// Zielbereich als achsenparallele Box statt als Punkt mit Radius.
    ///
    /// `bounds` liegt räumlich auf der **sichtbaren** Zielfläche; die Views leiten den
    /// Wert aus dem gemessenen Rahmen des sichtbaren Labels ab (`VolumeMetrics`).
    /// Es gibt damit keine unsichtbare, nach innen verschobene Trefferfläche mehr.
    struct BoxTarget {
        /// Fachlich neutrale Ziel-ID.
        let id: String
        /// Zielfläche in Szenen-Koordinaten (Meter).
        let bounds: BoundingBox
    }

    // MARK: - Überlappungsmaß

    /// Anteil der X/Y-Schnittfläche zweier Boxen an der **kleineren** der beiden Flächen.
    ///
    /// ## Warum nur X und Y
    ///
    /// Beide Phasen sind planare Anordnungen: das Monster zieht auf einer festen
    /// Tiefenebene (`PlanarDrag` hält Z konstant), die Ziele sind flache Beschriftungen
    /// am Volume-Rand. Eine Z-Prüfung würde nur Rauschen aus zwei unterschiedlich tiefen
    /// Ebenen einbringen und gültige Drops verhindern.
    ///
    /// ## Warum die kleinere Fläche als Bezug
    ///
    /// Monster und Zielfläche haben sehr unterschiedliche Formate — ein annähernd
    /// quadratisches Modell gegen ein breites, flaches Label. Bezöge man die
    /// Überlappung auf die Monsterfläche, wäre ein flaches Label nie „ausreichend"
    /// überdeckt; bezöge man sie auf die Zielfläche, würde ein sehr kleines Ziel schon
    /// bei Streifkontakt auslösen. Der Bezug auf die kleinere der beiden Flächen ist
    /// gegen beide Formatunterschiede robust.
    ///
    /// - Returns: 0 bei fehlender Überlappung, 1 bei vollständiger Überdeckung der
    ///   kleineren Fläche.
    static func overlapRatioXY(_ a: BoundingBox, _ b: BoundingBox) -> Float {
        let overlapWidth  = Swift.min(a.max.x, b.max.x) - Swift.max(a.min.x, b.min.x)
        let overlapHeight = Swift.min(a.max.y, b.max.y) - Swift.max(a.min.y, b.min.y)

        guard overlapWidth > 0, overlapHeight > 0 else { return 0 }

        let intersection = overlapWidth * overlapHeight
        let areaA = Swift.max((a.max.x - a.min.x) * (a.max.y - a.min.y), .leastNormalMagnitude)
        let areaB = Swift.max((b.max.x - b.min.x) * (b.max.y - b.min.y), .leastNormalMagnitude)

        return intersection / Swift.min(areaA, areaB)
    }

    // MARK: - Auswertung

    /// Wählt das Ziel, mit dem die sichtbare Monsterhülle am stärksten überlappt.
    ///
    /// ## Abgrenzung gegen die beiden bisherigen Verfahren
    ///
    /// * `evaluate(entityPosition:targets:)` verlangt, dass der **Root** des Monsters
    ///   innerhalb eines Radius um das **Zentrum** des Ziels landet. Sobald die
    ///   Zieh-Bewegung korrekt auf den sicheren Bereich begrenzt ist, kann der Root ein
    ///   randnahes Ziel-Zentrum aber gar nicht mehr erreichen — ein visuell eindeutiger
    ///   Drop würde als ungültig gewertet.
    /// * `evaluateColumn` / `evaluateNearest` teilen umgekehrt die **gesamte** erreichbare
    ///   Fläche unter den Zielen auf. Jede Ablage jenseits einer Mindestbewegung trifft
    ///   dadurch zwangsläufig irgendein Ziel — auch eine Ablage genau zwischen zwei
    ///   Boxen. Beide Verfahren bleiben für die bestehenden Tests erhalten, werden von
    ///   den Views aber nicht mehr verwendet.
    ///
    /// Dieses Verfahren orientiert sich stattdessen an dem, was die Nutzerin sieht: die
    /// Hülle des Monsters muss die sichtbare Zielfläche ausreichend überdecken. Der Root
    /// muss dafür kein Zentrum erreichen, und zwischen zwei Zielen abgelegt wird nichts
    /// ausgelöst, weil dort keine Fläche ausreichend überdeckt ist.
    ///
    /// - Parameters:
    ///   - monsterBounds: Sichtbare Hülle des Monsters in Szenen-Koordinaten, an der
    ///     Position beim Loslassen.
    ///   - targets: Zielflächen, räumlich deckungsgleich mit den sichtbaren Zielboxen.
    ///   - minimumOverlapRatio: Mindestüberdeckung (siehe `overlapRatioXY`). Kleinere
    ///     Werte machen Drops leichter, größere strenger.
    /// - Returns: ID des Ziels mit der größten Überdeckung oberhalb der Schwelle,
    ///   sonst `nil` (ungültiger Drop ⇒ Snapback, F-10 / AK-10).
    static func evaluateOverlap(
        monsterBounds: BoundingBox,
        targets: [BoxTarget],
        minimumOverlapRatio: Float
    ) -> String? {
        var bestID: String?
        var bestRatio: Float = 0

        for target in targets {
            let ratio = overlapRatioXY(monsterBounds, target.bounds)
            if ratio >= minimumOverlapRatio, ratio > bestRatio {
                bestRatio = ratio
                bestID = target.id
            }
        }

        return bestID
    }

    /// Alle Überdeckungsgrade als Text — ausschließlich für `DebugManager`-Ausgaben.
    ///
    /// Enthält bewusst nur Ziel-IDs und Geometrie, keine fachlichen Bezeichnungen und
    /// keine Referenzlösungen.
    static func overlapDebugSummary(
        monsterBounds: BoundingBox,
        targets: [BoxTarget]
    ) -> String {
        targets
            .map { String(format: "%@=%.3f", $0.id, overlapRatioXY(monsterBounds, $0.bounds)) }
            .joined(separator: " ")
    }
}
