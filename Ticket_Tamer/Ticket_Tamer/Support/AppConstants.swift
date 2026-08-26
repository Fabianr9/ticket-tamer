//
//  AppConstants.swift
//  Ticket_Tamer
//
//  Created by Fabian Raczkowski on 15.07.26.
//

import Foundation

/// Layoutwerte, die das Modul-001-Grundvolume direkt verwendet.
enum LayoutConstants {

    // MARK: - Central Volume

    // Die drei Volume-Masse bestimmen zweierlei zugleich:
    // 1. die Clipping-Kante der `RealityView` — alles darueber hinaus wird abgeschnitten,
    // 2. die Groesse der SwiftUI-Ebene in Punkten (ueber `layoutPointsPerMeter`).
    // Punkt 2 ist der Grund fuer diese Masse: bei 0.8 m ergab sich eine Ebene von nur
    // 334 x 334 pt, wodurch die Ticketkarte auf Faktor 0.34 heruntergerechnet werden musste.

    /// Breite des zentralen Volumes in Metern.
    ///
    /// Von 0.8 auf 1.0 erhoeht: die Ticketkarte erhaelt dadurch 221 statt 157 Punkte
    /// Spaltenbreite und rendert mit Faktor 0.48 statt 0.34.
    static let centralVolumeWidth = 1.0

    /// Hoehe des zentralen Volumes in Metern.
    ///
    /// Verlauf: 0.6 → 0.8 → 1.0. Bei 0.6 m lag die Obergrenze bei y = 0.30 m; ein 0.13 m
    /// hohes Monster wurde beim Ziehen zu den Prioritaetsfeldern ab y = 0.235 m
    /// angeschnitten. Der aktuelle Wert gibt zusaetzlich der Ticketkarte vertikal Luft.
    static let centralVolumeHeight = 1.0

    /// Tiefe des zentralen Volumes in Metern.
    static let centralVolumeDepth = 0.4

    // MARK: - Root View

    /// Aussenabstand der minimalen Root-View.
    static let rootPadding = 32.0

    /// Abstand zwischen 3D-Inhalt und Textblock.
    static let rootSpacing = 24.0

    /// Abstand innerhalb des Textblocks.
    static let textSpacing = 8.0

    /// Abstand unter dem vorhandenen RealityKit-Default-Modell.
    static let modelBottomPadding = 24.0

    // MARK: - Investigation View (Modul 006)

    /// Abstand zwischen Monster-Panel und Ticketkarte.
    static let investigationSpacing = 16.0

    /// Aussenabstand der Untersuchungsansicht.
    static let investigationPadding = 16.0

    /// Zeilenabstand innerhalb der Statusanzeigen des Monster-Panels.
    static let investigationCardSpacing = 8.0

    /// Anteil der verfuegbaren Breite, den die Ticketkarte erhaelt (Rest: Monster-Panel).
    ///
    /// Die Aufteilung erfolgt bewusst mit expliziten Breiten statt mit `maxWidth: .infinity`,
    /// weil die `RealityView` des Monster-Panels keine intrinsische Groesse besitzt und die
    /// flexible Verteilung dadurch zu einer zu schmalen, "laenglichen" Ticketkarte fuehrte.
    static let investigationCardWidthFraction = 0.60

    // MARK: - Ticketkarte: Fit-to-Space (Design-Canvas)

    /// Breite der festen Design-Canvas der Ticketkarte in Punkten.
    ///
    /// Die Karte wird immer in dieser Groesse gelayoutet und anschliessend gleichmaessig
    /// (aspect-ratio-treu) in den verfuegbaren Bereich eingepasst. Dadurch bleibt das
    /// Seitenverhaeltnis unabhaengig von der Fenstergroesse konstant.
    static let ticketCardDesignWidth = 460.0

    /// Hoehe der festen Design-Canvas der Ticketkarte in Punkten.
    ///
    /// Bemessen am laengsten Ticket des lokalen Katalogs (Titel 45, Kurzbeschreibung 76,
    /// User Impact 85 Zeichen, drei Symptome à max. 55 Zeichen) inklusive Reserve, damit
    /// ohne Scrollen nichts abgeschnitten wird. Kalkulierter Bedarf: ca. 556 pt.
    static let ticketCardDesignHeight = 620.0

    /// Untere Grenze des gleichmaessigen Skalierungsfaktors der Ticketkarte.
    ///
    /// **Bewusst sehr niedrig.** Diese Grenze war urspruenglich als Lesbarkeitsschutz
    /// gedacht (0.45), kehrte aber den Zweck von „fit to available space" um: liegt der zum
    /// Einpassen noetige Faktor darunter, wird nach oben geklemmt und die Karte ragt ueber
    /// den verfuegbaren Bereich hinaus. Gemessen: noetig 0.34, geklemmt auf 0.45 ⇒ 50 pt
    /// Ueberlauf in der Breite. Ueberlaufende Inhalte sind schlechter als kleine Inhalte,
    /// deshalb gewinnt jetzt immer die Einpassung.
    static let ticketCardMinScale = 0.2

    /// Obere Grenze des gleichmaessigen Skalierungsfaktors der Ticketkarte.
    ///
    /// Erlaubt massvolles Vergroessern, damit die Karte grosse Volumes ausfuellt,
    /// ohne dass hochskalierter Text sichtbar weich wird.
    static let ticketCardMaxScale = 1.4

    /// Eckenradius der Ticketkarte auf der Design-Canvas.
    static let ticketCardCornerRadius = 28.0

    /// Innenabstand der Ticketkarte auf der Design-Canvas.
    static let ticketCardPadding = 24.0

    /// Vertikaler Abstand zwischen den Informationsbloecken der Ticketkarte.
    static let ticketCardSectionSpacing = 14.0

    /// Vertikaler Abstand zwischen Beschriftung und Wert innerhalb eines Blocks.
    static let ticketCardLabelSpacing = 4.0

    /// Vertikaler Abstand zwischen den einzelnen Symptomzeilen.
    static let ticketCardSymptomSpacing = 6.0

    /// Horizontaler Innenabstand des Ticketnummer-Badges.
    static let ticketCardBadgeHorizontalPadding = 10.0

    /// Vertikaler Innenabstand des Ticketnummer-Badges.
    static let ticketCardBadgeVerticalPadding = 4.0

    /// Deckkraft der Badge-Hintergrundflaeche.
    static let ticketCardBadgeBackgroundOpacity = 0.15

    /// Zusaetzlicher Sicherheitsfaktor fuer Text, der die kalkulierte Zeilenzahl ueberschreitet.
    static let ticketCardTextMinimumScaleFactor = 0.8

    /// Maximale Zeilenzahl des Tickettitels auf der Design-Canvas.
    static let ticketCardTitleLineLimit = 2

    /// Maximale Zeilenzahl von Kurzbeschreibung und User Impact.
    static let ticketCardBodyLineLimit = 4

    /// Maximale Zeilenzahl einer Symptomzeile.
    static let ticketCardSymptomLineLimit = 3

    /// Fester Skalierungsfaktor fuer den Monster-Entity.
    ///
    /// Nur noch von `DebugInteractionHarnessView` verwendet. Die Untersuchungsansicht
    /// skaliert stattdessen dynamisch ueber `visualBounds` (siehe Monster-Panel unten),
    /// weil die vier Blender-Exporte unterschiedliche Rohmasse besitzen und ein fester
    /// Faktor je Asset zu einer anderen physischen Groesse fuehrt.
    static let monsterScale: Float = 0.2

    // MARK: - Monster-Panel der Untersuchungsansicht (Framing)

    /// Tiefe des Monster-Panels in Metern.
    ///
    /// Ohne explizite Tiefe hat die `RealityView` in einem 2D-Layout praktisch keine
    /// Z-Ausdehnung; Modellteile vor und hinter der Ebene werden dann beschnitten.
    /// Bleibt deutlich unter `centralVolumeDepth` (0.4 m), damit das Panel nicht
    /// an die Volume-Grenzen stoesst.
    static let monsterPanelDepth = 0.34

    /// Naeherung: Punkte pro Meter in visionOS bei Standard-Betrachtungsabstand.
    ///
    /// Dient ausschliesslich dazu, die in Punkten bekannte Panelflaeche in einen
    /// physischen Rahmen fuer die Monster-Einpassung umzurechnen.
    static let pointsPerMeter = 1360.0

    /// Anteil jeder Panelkante, der als Sicherheitsrand frei bleibt (0.15 = 15 %).
    static let monsterFramingInset: Float = 0.15

    /// Obergrenze der Kantenlaenge des eingepassten Monsters in Metern.
    ///
    /// Verhindert, dass das Monster in sehr grossen Volumes den Bildausschnitt dominiert.
    static let monsterTargetSize: Float = 0.24

    /// Gewuenschte Verschiebung des Monsters zur betrachtenden Person (+Z) in Metern.
    ///
    /// Wird beim Einpassen so begrenzt, dass das Modell die Panel-Tiefe nicht verlaesst.
    static let monsterForwardOffset: Float = 0.06

    /// Untere Schwelle, ab der ein `visualBounds`-Ergebnis als brauchbar gilt.
    static let monsterMinimumUsableExtent: Float = 0.0001

    // MARK: - Monster in den Drag-Drop-Phasen

    /// Groesste Kantenlaenge des eingepassten Monsters in Prioritaets- und Teamphase (Meter).
    ///
    /// Ersetzt den festen Faktor `monsterScaleDragDrop`: die vier Blender-Exporte haben
    /// unterschiedliche Rohmasse, ein konstanter Faktor ergibt daher je Asset eine andere
    /// physische Groesse. Ueber `visualBounds` gemessen ist die Groesse assetunabhaengig.
    ///
    /// Bewusst kleiner als `InteractionConstants.monsterCollisionRadius × 2`, damit die
    /// Greifsphaere das Modell sicher umschliesst.
    static let monsterDragDropTargetSize: Float = 0.13

    /// Sichtbarer Sicherheitsabstand zwischen Modellhuelle und Volume-Grenze (Meter).
    ///
    /// Die Zieh-Bewegung wird so begrenzt, dass zwischen der Aussenkante des Monsters und
    /// der Clipping-Kante des Volumes immer mindestens dieser Abstand bleibt. Damit ist
    /// Beschneiden konstruktiv ausgeschlossen — unabhaengig davon, wie weit gezogen wird.
    static let playAreaSafetyMargin: Float = 0.03

    // MARK: - Ziel-Labels (Priorisierung / Teamzuordnung)

    /// Abstand zwischen den Ziel-Labels in der Kopfzeile.
    static let targetLabelRowSpacing = 8.0

    /// Aussenabstand der Label-Zeile nach oben.
    ///
    /// **Layout-Fix:** dieser Wert lag zwischenzeitlich bei 120 pt. Da die SwiftUI-Ebene
    /// nur rund `layoutPointsPerMeter` Punkte pro Meter umfasst, entsprachen 120 pt fast
    /// 0.29 m — die Zeile rutschte damit genau auf die Oberkante des Monsters und verdeckte
    /// dessen Silhouette. Mit 16 pt (≈ 0.04 m) sitzt sie wieder am oberen Rand.
    static let targetLabelTopPadding = 16.0

    /// Geschaetzte Gesamthoehe eines Ziel-Labels in Punkten.
    ///
    /// Schriftgroesse `title3` (~28 pt Zeilenhoehe) plus zweimal
    /// `targetLabelVerticalPadding`. Dient ausschliesslich dazu, die Unterkante der
    /// Label-Zeile in Metern abzuschaetzen (siehe `PrioritizationConstants.labelBandBottomY`).
    static let targetLabelHeight = 28.0 + 2 * targetLabelVerticalPadding

    /// Punkte pro Meter der **SwiftUI-Ebene** des volumetrischen Fensters.
    ///
    /// Am Simulator kalibriert: bei `targetLabelTopPadding = 120` lag die Mitte der
    /// Label-Zeile exakt auf der Oberkante des Monsters (y = 0.045 m). Daraus folgt
    /// (120 + 28) pt ≙ (0.4 − 0.045) m ⇒ rund 417 pt/m.
    ///
    /// Bewusst getrennt von `pointsPerMeter`: jener Wert steuert die Empfindlichkeit der
    /// Zieh-Geste und ist so eingestellt, wie sich die Interaktion gut anfuehlt. Dieser Wert
    /// hier beschreibt dagegen die tatsaechliche Groesse der 2D-Ebene und wird nur fuer
    /// Layoutberechnungen verwendet.
    ///
    /// Nachmessen: `targetLabelTopPadding` veraendern und pruefen, auf welcher Hoehe die
    /// Label-Zeile relativ zum Monster liegt.
    static let layoutPointsPerMeter = 417.0

    /// Seitlicher Aussenabstand der Label-Zeile.
    static let targetLabelRowHorizontalPadding = 16.0

    /// Horizontaler Innenabstand eines Ziel-Labels.
    static let targetLabelHorizontalPadding = 14.0

    /// Vertikaler Innenabstand eines Ziel-Labels.
    static let targetLabelVerticalPadding = 8.0

    /// Eckenradius eines Ziel-Labels.
    static let targetLabelCornerRadius = 12.0

    /// Deckkraft der Label-Hintergrundflaeche.
    static let targetLabelBackgroundOpacity = 0.75

    /// Untere Schriftskalierung eines Ziel-Labels.
    ///
    /// Zusammen mit `lineLimit(1)` verhindert dies die Silbentrennung
    /// („Nor-mal", „Wich-tig", „Kri-tisch") bei schmalen Spalten.
    static let targetLabelMinimumScaleFactor = 0.6

    /// Skalierungsfaktor fuer den Monster-Entity in den Drag-Drop-Phasen (Priorisierung / Team).
    ///
    /// Kleiner als `monsterScale`, damit der Entity vollständig im Volume sichtbar bleibt
    /// und genug Platz für die Drop-Zielkugeln verbleibt. Wert: ca. 8 cm Kantenlänge.
    static let monsterScaleDragDrop: Float = 0.08
}

/// Spielweite Grundwerte aus der SPEC, ohne Sitzungslogik vorwegzunehmen.
enum GameplayConstants {

    // MARK: - Ticket Count

    /// Kleinste laut SPEC waehlbare Ticketanzahl.
    static let minimumTicketCount = 1

    /// Groesste laut SPEC waehlbare Ticketanzahl.
    static let maximumTicketCount = 12

    /// Standardwert fuer spaetere Startansicht und Reset.
    static let defaultTicketCount = 6
}

/// Maße und Toleranzen für die räumliche Interaktionsgrundlage (Modul 007 — F-10 / AK-10).
enum InteractionConstants {

    // MARK: - Monster-Kollision

    /// Radius der sphärischen Kollisionsform am Monster in Metern.
    ///
    /// Bewusst großzügig (0.12 m), damit Blick + Pinch bei kleiner Skalierung (0.08–0.10)
    /// zuverlässig registriert wird. Kleiner als `dropTargetRadius`, damit Ziele nicht
    /// unbeabsichtigt überdeckt werden.
    static let monsterCollisionRadius: Float = 0.12

    // MARK: - Drop-Zielbereich

    /// Standard-Trefferradius eines generischen Drop-Ziels in Metern.
    ///
    /// Rein logischer Toleranzradius für `DropEvaluator` — bewusst großzügig, damit
    /// Ablegen per Blick und Pinch zuverlässig gelingt. **Nicht** für sichtbare Geometrie
    /// verwenden.
    static let dropTargetRadius: Float = 0.15

    /// Radius der **sichtbaren** Zielkugel in Metern.
    ///
    /// Deutlich kleiner als `dropTargetRadius`. Zuvor wurde der Trefferradius direkt als
    /// Mesh-Radius verwendet: 0.15 m ergibt Kugeln von 30 cm Durchmesser, die einander und
    /// die Volume-Grenzen schneiden. Sichtbar war davon nur ein angeschnittener Bogen —
    /// der „orangene Halbkreis". Trefferlogik und Zielabstände bleiben unverändert.
    static let dropTargetVisualRadius: Float = 0.05

    // MARK: - Rückkehr-Animation

    /// Dauer der Rückkehrbewegung bei ungültigem Drop in Sekunden.
    static let monsterReturnDuration: Double = 0.3
}

/// Maße und Positionen für die Priorisierungsphase (Modul 008 — F-08 / AK-08).
enum PrioritizationConstants {

    // MARK: - Monster-Startposition

    /// Startposition des Monsters — horizontal zentriert, knapp unterhalb der Volume-Mitte.
    ///
    /// Y bewusst nahe 0 statt im unteren Drittel: tiefer wirkte das Modell im Passthrough,
    /// als versinke es in Tisch oder Boden. Bei einer Modellgröße von
    /// `monsterDragDropTargetSize` (0.13 m) bleibt oben wie unten reichlich Luft
    /// (Modell reicht von y ≈ -0.085 bis 0.045 bei Volume-Grenzen ±0.3).
    ///
    /// Leicht nach vorne versetzt (+Z), damit das Modell klar vor der Zielebene steht.
    /// Abstand zu allen drei Zielen > `InteractionConstants.dropTargetRadius`, das Monster
    /// liegt also zu Beginn in keinem Zielbereich (AK-10).
    static let monsterStartPosition = SIMD3<Float>(0, -0.02, 0.06)

    // MARK: - Label-Band und Sichtabstand zum Monster

    /// Y-Wert der **Unterkante** der Label-Zeile in Szenenkoordinaten (Meter).
    ///
    /// Die Labels sind eine SwiftUI-2D-Ebene, das Monster eine RealityKit-Entity. Um beide
    /// gegeneinander abstimmen zu können, wird die in Punkten bekannte Position der Zeile
    /// über `LayoutConstants.layoutPointsPerMeter` in Meter umgerechnet:
    ///
    ///     Unterkante = halbe Volume-Höhe − (Aussenabstand + Labelhöhe) / Punkte-pro-Meter
    ///
    /// Alles unterhalb dieses Wertes ist frei — dort darf das Monster stehen, ohne von den
    /// Auswahlflächen überdeckt zu werden.
    static var labelBandBottomY: Float {
        let halfHeight = Float(LayoutConstants.centralVolumeHeight / 2)
        let offsetInMeters = Float(
            (LayoutConstants.targetLabelTopPadding + LayoutConstants.targetLabelHeight)
                / LayoutConstants.layoutPointsPerMeter
        )
        return halfHeight - offsetInMeters
    }

    /// Sichtabstand zwischen Monsteroberkante und Label-Unterkante, **in Monsterhöhen**.
    ///
    /// Bewusst als Vielfaches der Modellhöhe statt als fester Meterwert: höhere Modelle
    /// bekommen automatisch mehr Abstand, flachere weniger. Damit bleibt der optische
    /// Eindruck über alle vier Monster-Assets gleich, obwohl deren Proportionen abweichen.
    static let labelClearanceInMonsterHeights: Float = 0.3

    /// Höchster erlaubter Y-Wert für die **Mitte** des Monsters.
    ///
    /// Ergibt sich aus der Label-Unterkante abzüglich Sichtabstand und halber Modellhöhe.
    /// Dadurch kann das Monster auch am höchsten Zieh-Punkt nicht unter die Auswahlflächen
    /// geraten — die Silhouette bleibt zu jedem Zeitpunkt vollständig sichtbar.
    ///
    /// - Parameter height: **Gemessene** Höhe des geladenen Modells in Metern
    ///   (aus `MonsterAssetProvider.fit`), nicht der Nennwert.
    static func monsterCeiling(forMonsterHeight height: Float) -> Float {
        labelBandBottomY - height * labelClearanceInMonsterHeights - height / 2
    }

    // MARK: - Label-Offset

    /// Y-Offset des SwiftUI-Label-Attachments relativ zur Zielentity (oberhalb der Zielkugel).
    static let labelYOffset: Float = 0.20

    // MARK: - Ablage-Schwellen (Spaltenmodell)

    /// Mindest-Aufwärtsbewegung gegenüber der Startposition, ab der eine Ablage als
    /// gewollt gilt (Meter).
    ///
    /// Unterhalb dieser Schwelle wertet `DropEvaluator.evaluateColumn` die Ablage als
    /// ungültig: kein Zustandswechsel, das Monster kehrt zurück (F-10 / AK-10).
    static let minimumDropLift: Float = 0.04

    /// Horizontaler Abstand zwischen zwei benachbarten Zielspalten (Meter).
    ///
    /// Die Entscheidungsgrenze zwischen zwei Zielen liegt genau mittig, also bei
    /// `targetColumnSpacing / 2` = 0.10 m. So viel muss seitlich bewegt werden, um von
    /// „Wichtig" zu „Normal" bzw. „Kritisch" zu wechseln.
    static let targetColumnSpacing: Float = 0.20

    // MARK: - Zielpositionen
    //
    // Die drei Ziele sind reine Trefferbereiche ohne sichtbare Geometrie; sichtbare
    // Orientierung geben die Labels Normal / Wichtig / Kritisch am oberen Rand.
    //
    // Ausgewertet wird über `DropEvaluator.evaluateColumn`: entscheidend ist allein, welcher
    // Ziel-X-Wert dem abgelegten Monster am nächsten liegt. Der frühere Abstand von 0.32 m
    // stammte aus der radiusbasierten Auswertung und war per Drag nicht erreichbar —
    // deshalb ließ sich nur „Wichtig" (x = 0, direkt über der Startposition) zuweisen.

    /// Position von Ziel „Normal" (links).
    static let targetPositionNormal   = SIMD3<Float>(-targetColumnSpacing, 0.18, 0)

    /// Position von Ziel „Wichtig" (Mitte).
    static let targetPositionWichtig  = SIMD3<Float>( 0.00, 0.18, 0)

    /// Position von Ziel „Kritisch" (rechts).
    static let targetPositionKritisch = SIMD3<Float>( targetColumnSpacing, 0.18, 0)
}

/// Maße und Positionen für die Teamzuordnungsphase (Modul 009 — F-09 / AK-09).
enum TeamAssignmentConstants {

    // MARK: - Monster-Startposition

    /// Startposition des Monsters — Mittelpunkt zwischen allen vier Teamstationen.
    ///
    /// Abstand zu jeder Station ≈ 0.29 m > `InteractionConstants.dropTargetRadius` (0.15 m),
    /// damit das Monster nicht von Beginn an in einem Zielbereich liegt.
    static let monsterStartPosition = SIMD3<Float>(0, 0, 0)

    // MARK: - Ablage-Schwelle

    /// Mindestbewegung gegenüber der Startposition, ab der eine Ablage als gewollt gilt
    /// (Meter).
    ///
    /// Pendant zu `PrioritizationConstants.minimumDropLift`. Darunter wertet
    /// `DropEvaluator.evaluateNearest` die Ablage als ungültig: kein Zustandswechsel,
    /// das Monster kehrt zurück (F-10 / AK-10).
    static let minimumDropDistance: Float = 0.15

    // MARK: - Zielpositionen (2×2-Layout)
    //
    // Horizontaler Abstand: 0.48 m > 2 × 0.15 m = 0.30 m ✓
    // Vertikaler Abstand:   0.32 m > 2 × 0.15 m = 0.30 m ✓
    // Diagonaler Abstand:   ≈ 0.58 m ✓

    /// Position Teamstation „Netzwerk" (oben links).
    static let targetPositionNetzwerk  = SIMD3<Float>(-0.26,  0.30, 0)

    /// Position Teamstation „Konto" (oben rechts).
    static let targetPositionKonto     = SIMD3<Float>( 0.26,  0.30, 0)

    /// Position Teamstation „Software" (unten links).
    static let targetPositionSoftware  = SIMD3<Float>(-0.26, -0.30, 0)

    /// Position Teamstation „Hardware" (unten rechts).
    static let targetPositionHardware  = SIMD3<Float>( 0.26, -0.30, 0)
}

/// Zeitwerte für das Audiofeedback und den automatischen Phasenübergang (Modul 010 — F-13).
enum FeedbackConstants {

    // MARK: - Feedbackdauer

    /// Dauer des Audiofeedbacks, nach der automatisch die nächste Phase eingeleitet wird.
    ///
    /// Zentrale Konstante — keine Magic Numbers in Views oder Services.
    static let feedbackTransitionDelay: Double = 1.5

    // MARK: - Sound-Ressourcen-IDs

    /// Dateiname (ohne Endung) des Richtig-Sounds im App-Bundle.
    static let correctSoundName = "correct"

    /// Dateiname (ohne Endung) des Falsch-Sounds im App-Bundle.
    static let incorrectSoundName = "incorrect"

    /// Bundle-Ressourcenformat der Feedback-Sounds.
    static let soundExtension = "wav"

    // MARK: - Punkte

    /// Punkte für eine richtige Teilentscheidung (F-11).
    static let correctDecisionScore = 100
}

/// Zentralisierte Schluessel fuer bereits vorhandene lokale Ressourcen.
enum AssetKeys {

    // MARK: - Reality Composer Pro

    /// Name der im Default-RealityKitContent-Package vorhandenen Szene.
    static let defaultRealityKitScene = "Scene"

    // MARK: - Modul 005: Monster-Assets (F-14 / AK-14)

    /// Zentralisierte, neutrale Bezeichner fuer die vier lokalen Monster-Assets.
    ///
    /// Namen sind absichtlich neutral: kein Name codiert Team oder Prioritaet,
    /// sodass das angezeigte Modell keinen Rueckschluss auf die korrekte Loesung erlaubt.
    enum Monster {

        /// Erster Monster-Bezeichner.
        static let monster01 = "monster01"

        /// Zweiter Monster-Bezeichner.
        static let monster02 = "monster02"

        /// Dritter Monster-Bezeichner.
        static let monster03 = "monster03"

        /// Vierter Monster-Bezeichner.
        static let monster04 = "monster04"

        /// Alle vier gueltigen Monster-Bezeichner als geordnetes Array.
        ///
        /// Wird fuer Tests und Validierung verwendet.
        static let allIDs: [String] = [monster01, monster02, monster03, monster04]
    }
}
