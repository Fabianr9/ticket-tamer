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

    /// Breite des zentralen Volumes in Metern.
    static let centralVolumeWidth = 0.8

    /// Hoehe des zentralen Volumes in Metern.
    static let centralVolumeHeight = 0.6

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
    static let investigationSpacing = 24.0

    /// Aussenabstand der Untersuchungsansicht.
    static let investigationPadding = 24.0

    /// Innenabstand der Ticketkarte.
    static let investigationCardPadding = 16.0

    /// Zeilenabstand innerhalb der Ticketkarte.
    static let investigationCardSpacing = 12.0

    /// Skalierungsfaktor fuer den Monster-Entity im Volume (RealityKit-Float, ca. 20 cm Kantenlänge).
    static let monsterScale: Float = 0.2
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
    /// Kleiner als `dropTargetRadius`, damit die Kollisionsform das Ziel nicht überdeckt.
    static let monsterCollisionRadius: Float = 0.10

    // MARK: - Drop-Zielbereich

    /// Standard-Trefferradius eines generischen Drop-Ziels in Metern.
    static let dropTargetRadius: Float = 0.15

    // MARK: - Rückkehr-Animation

    /// Dauer der Rückkehrbewegung bei ungültigem Drop in Sekunden.
    static let monsterReturnDuration: Double = 0.3
}

/// Maße und Positionen für die Priorisierungsphase (Modul 008 — F-08 / AK-08).
enum PrioritizationConstants {

    // MARK: - Monster-Startposition

    /// Startposition des Monsters — unterhalb der drei Ziele, von allen drei erreichbar.
    static let monsterStartPosition = SIMD3<Float>(0, -0.12, 0)

    // MARK: - Label-Offset

    /// Y-Offset des SwiftUI-Label-Attachments relativ zur Zielentity (oberhalb der Zielkugel).
    static let labelYOffset: Float = 0.20

    // MARK: - Zielpositionen

    /// Position von Ziel „Normal" (links).
    ///
    /// Abstand zu „Wichtig": 0.32 m > 2 × `InteractionConstants.dropTargetRadius` (0.30 m).
    /// Zielbereiche überschneiden sich nicht.
    static let targetPositionNormal   = SIMD3<Float>(-0.32, 0.10, 0)

    /// Position von Ziel „Wichtig" (Mitte).
    static let targetPositionWichtig  = SIMD3<Float>( 0.00, 0.10, 0)

    /// Position von Ziel „Kritisch" (rechts).
    ///
    /// Abstand zu „Wichtig": 0.32 m > 2 × `InteractionConstants.dropTargetRadius`.
    static let targetPositionKritisch = SIMD3<Float>( 0.32, 0.10, 0)
}

/// Maße und Positionen für die Teamzuordnungsphase (Modul 009 — F-09 / AK-09).
enum TeamAssignmentConstants {

    // MARK: - Monster-Startposition

    /// Startposition des Monsters — Mittelpunkt zwischen allen vier Teamstationen.
    ///
    /// Abstand zu jeder Station ≈ 0.29 m > `InteractionConstants.dropTargetRadius` (0.15 m),
    /// damit das Monster nicht von Beginn an in einem Zielbereich liegt.
    static let monsterStartPosition = SIMD3<Float>(0, 0, 0)

    // MARK: - Zielpositionen (2×2-Layout)
    //
    // Horizontaler Abstand: 0.48 m > 2 × 0.15 m = 0.30 m ✓
    // Vertikaler Abstand:   0.32 m > 2 × 0.15 m = 0.30 m ✓
    // Diagonaler Abstand:   ≈ 0.58 m ✓

    /// Position Teamstation „Netzwerk" (oben links).
    static let targetPositionNetzwerk  = SIMD3<Float>(-0.24,  0.16, 0)

    /// Position Teamstation „Konto" (oben rechts).
    static let targetPositionKonto     = SIMD3<Float>( 0.24,  0.16, 0)

    /// Position Teamstation „Software" (unten links).
    static let targetPositionSoftware  = SIMD3<Float>(-0.24, -0.16, 0)

    /// Position Teamstation „Hardware" (unten rechts).
    static let targetPositionHardware  = SIMD3<Float>( 0.24, -0.16, 0)
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
