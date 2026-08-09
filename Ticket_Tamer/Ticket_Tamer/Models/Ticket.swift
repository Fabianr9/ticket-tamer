import Foundation

// MARK: - Ticket Priority

/// Fachliche Referenzpriorität eines Support-Tickets.
enum TicketPriority: String, CaseIterable, Equatable {
    case normal
    case wichtig
    case kritisch

    /// Deutsche Bezeichnung für spätere sichtbare UI-Texte.
    var displayName: String {
        switch self {
        case .normal:
            "Normal"
        case .wichtig:
            "Wichtig"
        case .kritisch:
            "Kritisch"
        }
    }
}

// MARK: - Support Team

/// Fachliches Referenzteam, dem ein Support-Ticket eindeutig zugeordnet ist.
enum SupportTeam: String, CaseIterable, Equatable {
    case netzwerk
    case konto
    case software
    case hardware

    /// Deutsche Bezeichnung für spätere sichtbare UI-Texte.
    var displayName: String {
        switch self {
        case .netzwerk:
            "Netzwerk"
        case .konto:
            "Konto"
        case .software:
            "Software"
        case .hardware:
            "Hardware"
        }
    }
}

// MARK: - Ticket

/// Lokales fachliches Support-Ticket mit genau einer Referenzpriorität und einem Referenzteam.
struct Ticket: Identifiable, Equatable {
    /// Stabile eindeutige Kennung für interne Auswahl und spätere Sitzungslogik.
    let id: String

    /// Sichtbare Ticketnummer für die Ticketkarte.
    let ticketNumber: String

    /// Kurzer fachlicher Titel des Support-Falls.
    let title: String

    /// Kompakte Beschreibung der gemeldeten Störung.
    let shortDescription: String

    /// Beschreibung der Auswirkung auf die betroffene Arbeit.
    let userImpact: String

    /// Ein bis drei beobachtbare Symptome oder Hinweise ohne Lösungserklärung.
    let symptoms: [String]

    /// Eindeutige fachliche Referenzpriorität für die spätere Bewertung.
    let referencePriority: TicketPriority

    /// Eindeutiges fachliches Referenzteam für die spätere Bewertung.
    let referenceTeam: SupportTeam

    // MARK: - Modul 005: Monster-Asset-Pipeline (F-14 / AK-14)

    /// Neutraler Asset-Bezeichner des zugeordneten Monsters (z. B. "monster01").
    ///
    /// Verweist auf einen der vier Schlüssel in `AssetKeys.Monster`.
    /// Die Zuordnung ist modellunabhängig: kein Monster steht eindeutig für ein Team
    /// oder eine Priorität, sodass das Modell keinen Rückschluss auf die Lösung erlaubt.
    /// Entspricht dem in der SPEC-Architekturskizze vorgesehenen Feld `monsterAssetId`.
    let monsterAssetId: String
}
