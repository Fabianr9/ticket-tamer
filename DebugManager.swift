//
//  DebugManager.swift
//  Zentrale, kategorisierte Debug-Steuerung für das Projekt.
//
//  Gehört in den Ordner:  Debug/
//  Nutzung:               DebugManager.log(.input, "Tap auf \(entity.name)")
//
//  Idee: Statt verstreuter print()-Aufrufe gibt es EINE Stelle, an der
//  Log-Ausgaben nach Kategorien gebündelt und einzeln ein-/ausgeschaltet
//  werden. So sieht man beim Entwickeln gezielt nur, was gerade interessiert.
//

import OSLog
import SwiftUI

/// Zentrale Debug-Steuerung: kategorisiertes Logging, pro Kategorie schaltbar.
enum DebugManager {

    // MARK: - Kategorien

    /// Alle Log-Kategorien des Projekts.
    /// JEDES Modul ergänzt hier bei Bedarf seine eigene Kategorie (eine `case`-Zeile).
    enum Category: String, CaseIterable, Identifiable {
        case lifecycle   // App-/View-Lebenszyklus
        case input       // Gesten: Tap, Drag, Blick
        case physics     // Kollision, Schwerkraft, Simulation
        case spawning    // Erzeugen/Entfernen von Entities
        case state       // Änderungen am geteilten Modell
        case audio       // Sound-Auslösung

        var id: String { rawValue }
    }

    // MARK: - Schalter

    /// Master-Schalter. Für die Abgabe/Release auf `false` setzen.
    static var isEnabled = true

    /// Aktive Kategorien. NUR was hier enthalten ist, wird geloggt.
    /// Standard-Set bewusst klein halten — im Debug-Panel zur Laufzeit erweitern.
    static var enabled: Set<Category> = [.lifecycle, .input]

    // MARK: - Logging

    private static let subsystem = Bundle.main.bundleIdentifier ?? "Projekt"

    /// Zentrale Log-Funktion.
    ///
    /// - Parameters:
    ///   - category: Die Kategorie der Meldung (steuert das Ein-/Ausschalten).
    ///   - message: Die Meldung. `@autoclosure`, damit sie NUR gebaut wird,
    ///              wenn die Kategorie aktiv ist — deshalb auch im Frame-Tick günstig.
    ///   - function: Automatisch der aufrufende Funktionsname.
    static func log(_ category: Category,
                    _ message: @autoclosure () -> String,
                    function: String = #function) {
        guard isEnabled, enabled.contains(category) else { return }
        let logger = Logger(subsystem: subsystem, category: category.rawValue)
        logger.debug("[\(category.rawValue, privacy: .public)] \(function, privacy: .public) — \(message(), privacy: .public)")
    }

    // MARK: - Komfort

    /// Kategorie zur Laufzeit umschalten (für das Debug-Panel).
    static func toggle(_ category: Category) {
        if enabled.contains(category) { enabled.remove(category) }
        else { enabled.insert(category) }
    }
}

// MARK: - Optionales Debug-Panel (SwiftUI)

/// Kleines Bedienfeld: je Kategorie ein Toggle. In eine Menü-/Einstellungs-View einbetten.
/// Schaltet `DebugManager.enabled` zur Laufzeit um.
struct DebugPanel: View {
    // Lokaler Spiegel, damit die Toggles SwiftUI-Bindings bekommen.
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
                        if isOn { active.insert(category) } else { active.remove(category) }
                        DebugManager.enabled = active
                    }
                ))
            }
        }
        .padding()
    }
}
