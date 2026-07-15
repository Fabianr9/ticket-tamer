//
//  DebugManager.swift
//  Ticket_Tamer
//
//  Created by Fabian Raczkowski on 15.07.26.
//

import OSLog
import SwiftUI

/// Zentrale Debug-Steuerung mit kategorisiertem Logging.
enum DebugManager {

    // MARK: - Categories

    /// Log-Kategorien des Projekts.
    enum Category: String, CaseIterable, Identifiable {
        case lifecycle
        case input
        case physics
        case spawning
        case state
        case audio

        /// Stabile ID fuer SwiftUI-Listen und Toggles.
        var id: String { rawValue }
    }

    // MARK: - Switches

    /// Master-Schalter fuer Debug-Ausgaben.
    static var isEnabled = true

    /// Aktive Kategorien. Modul 001 nutzt bewusst nur Lifecycle-Logging im regulaeren Ablauf.
    static var enabled: Set<Category> = [.lifecycle]

    // MARK: - Logging

    private static let subsystem = Bundle.main.bundleIdentifier ?? "Ticket_Tamer"

    /// Schreibt eine Debug-Meldung, wenn die Kategorie aktiv ist.
    ///
    /// - Parameters:
    ///   - category: Log-Kategorie der Meldung.
    ///   - message: Meldung als Autoclosure, damit inaktive Logs keine Strings aufbauen.
    ///   - function: Aufrufende Funktion.
    static func log(
        _ category: Category,
        _ message: @autoclosure () -> String,
        function: String = #function
    ) {
        guard isEnabled, enabled.contains(category) else { return }
        let logger = Logger(subsystem: subsystem, category: category.rawValue)
        logger.debug("[\(category.rawValue, privacy: .public)] \(function, privacy: .public): \(message(), privacy: .public)")
    }

    // MARK: - Convenience

    /// Schaltet eine Kategorie zur Laufzeit um.
    static func toggle(_ category: Category) {
        if enabled.contains(category) {
            enabled.remove(category)
        } else {
            enabled.insert(category)
        }
    }
}

// MARK: - Optional Debug Panel

/// Optionales SwiftUI-Panel fuer die Entwicklung; es ist nicht Teil des regulaeren Nutzerablaufs.
struct DebugPanel: View {
    @State private var active: Set<DebugManager.Category> = DebugManager.enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Debug aktiv", isOn: Binding(
                get: { DebugManager.isEnabled },
                set: { DebugManager.isEnabled = $0 }
            ))
            Divider()
            ForEach(DebugManager.Category.allCases) { category in
                Toggle(category.rawValue, isOn: Binding(
                    get: { active.contains(category) },
                    set: { isOn in
                        if isOn {
                            active.insert(category)
                        } else {
                            active.remove(category)
                        }
                        DebugManager.enabled = active
                    }
                ))
            }
        }
        .padding()
    }
}
