//
//  Ticket_TamerApp.swift
//  Ticket_Tamer
//
//  Created by Fabian Raczkowski on 15.07.26.
//

import SwiftUI

/// App-Einstieg fuer Ticket Tamer mit genau einer zentralen volumetrischen Szene.
@main
struct Ticket_TamerApp: App {

    // MARK: - Lifecycle

    init() {
        DebugManager.log(.lifecycle, "App-Einstieg initialisiert")
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            RootVolumeView()
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
