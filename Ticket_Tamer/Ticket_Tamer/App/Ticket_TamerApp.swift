//
//  Ticket_TamerApp.swift
//  Ticket_Tamer
//
//  Created by Fabian Raczkowski on 15.07.26.
//

import SwiftUI

/// App-Einstieg fuer Ticket Tamer mit genau einer zentralen volumetrischen Szene.
///
/// `sessionModel` ist die einzige `SessionModel`-Instanz der gesamten App-Laufzeit.
/// Sie wird ueber die SwiftUI-Environment an alle Views weitergegeben, damit kein
/// zweiter, konkurrierender Zustand entstehen kann (Modul 004, SPEC F-01).
@main
struct Ticket_TamerApp: App {

    // MARK: - Zustand

    /// Einzige `SessionModel`-Instanz; Besitz liegt am App-Einstieg.
    ///
    /// `@State` stellt sicher, dass SwiftUI die Instanz ueber den gesamten
    /// App-Lebenszyklus haelt und nicht neu erzeugt. Die Weitergabe erfolgt
    /// ausschliesslich ueber `.environment(sessionModel)`.
    @State private var sessionModel = SessionModel()

    // MARK: - Lifecycle

    init() {
        DebugManager.log(.lifecycle, "App-Einstieg initialisiert")
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            RootVolumeView()
                // Macht sessionModel fuer alle Kind-Views per @Environment(SessionModel.self) verfuegbar.
                .environment(sessionModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(
            width: LayoutConstants.centralVolumeWidth,
            height: LayoutConstants.centralVolumeHeight,
            depth: LayoutConstants.centralVolumeDepth,
            in: .meters
        )
    }
}
