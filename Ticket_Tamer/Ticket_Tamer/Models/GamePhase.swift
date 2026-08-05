import Foundation

// MARK: - Game Phase

/// Die fünf Spielphasen einer Sitzung laut SPEC.
///
/// Die Reihenfolge spiegelt den fachlichen Ablauf einer Ticket-Tamer-Sitzung wider.
/// Automatische Phasenübergänge und vollständige Phasenmaschine kommen erst ab Modul 006.
/// In Modul 003 wird dieses Enum ausschließlich für den Reset-Startzustand und den
/// Sitzungsstart benötigt.
enum GamePhase: Equatable {

    /// Startphase: keine laufende Sitzung, Regler und Startschaltfläche sind sichtbar.
    case start

    /// Untersuchungsphase: Spieler liest Ticketdetails; Entscheidungen noch nicht aktiv.
    case untersuchen

    /// Priorisierungsphase: Spieler wählt die Priorität des aktuellen Tickets.
    case priorisieren

    /// Team-Zuordnungsphase: Spieler ordnet das aktuelle Ticket einem Support-Team zu.
    case teamZuordnen

    /// Ergebnisphase: alle Tickets der Sitzung wurden bearbeitet; Auswertung folgt.
    case ergebnis
}
