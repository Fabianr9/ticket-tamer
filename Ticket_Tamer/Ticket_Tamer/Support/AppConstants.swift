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

/// Zentralisierte Schluessel fuer bereits vorhandene lokale Ressourcen.
enum AssetKeys {

    // MARK: - Reality Composer Pro

    /// Name der im Default-RealityKitContent-Package vorhandenen Szene.
    static let defaultRealityKitScene = "Scene"
}
