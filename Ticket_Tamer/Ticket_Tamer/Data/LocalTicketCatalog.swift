import Foundation

// MARK: - Local Ticket Catalog

/// Vollständiger statischer Ticketpool für Modul 002.
enum LocalTicketCatalog {
    /// Genau zwölf lokal definierte Tickets ohne Netzwerk-, Datei- oder API-Zugriff.
    static let allTickets: [Ticket] = [
        Ticket(
            id: "ticket-001",
            ticketNumber: "TT-001",
            title: "Langsamer Zugriff auf interne Dienste",
            shortDescription: "Mehrere interne Webseiten laden deutlich verzögert.",
            userImpact: "Mitarbeitende koennen Kundenanfragen nur mit Wartezeiten bearbeiten.",
            symptoms: [
                "Intranet-Seiten oeffnen erst nach mehreren Sekunden.",
                "Videokonferenzen bleiben stabil.",
                "Das Problem tritt nur im Buero-Netz auf."
            ],
            referencePriority: .normal,
            referenceTeam: .netzwerk
        ),
        Ticket(
            id: "ticket-002",
            ticketNumber: "TT-002",
            title: "VPN-Verbindung bricht regelmaessig ab",
            shortDescription: "Remote arbeitende Personen verlieren mehrmals pro Stunde die VPN-Verbindung.",
            userImpact: "Laufende Arbeiten in Fachsystemen muessen wiederholt neu gestartet werden.",
            symptoms: [
                "VPN-Client meldet Zeitueberschreitung.",
                "Lokale Internetverbindung bleibt verfuegbar."
            ],
            referencePriority: .wichtig,
            referenceTeam: .netzwerk
        ),
        Ticket(
            id: "ticket-003",
            ticketNumber: "TT-003",
            title: "Standort ohne Netzwerkzugang",
            shortDescription: "Ein kompletter Standort erreicht weder interne noch externe Dienste.",
            userImpact: "Der betroffene Standort kann keine Tickets, Bestellungen oder Kundendaten bearbeiten.",
            symptoms: [
                "Alle Arbeitsplaetze zeigen keine Netzwerkverbindung.",
                "Telefonie ueber das Datennetz ist ebenfalls ausgefallen.",
                "Andere Standorte melden keine Stoerung."
            ],
            referencePriority: .kritisch,
            referenceTeam: .netzwerk
        ),
        Ticket(
            id: "ticket-004",
            ticketNumber: "TT-004",
            title: "Profilbild laesst sich nicht aendern",
            shortDescription: "Eine Person kann das Profilbild im Unternehmensportal nicht aktualisieren.",
            userImpact: "Die Arbeit ist moeglich, aber das Personenprofil bleibt unvollstaendig.",
            symptoms: [
                "Upload endet ohne sichtbare Fehlermeldung.",
                "Andere Profileinstellungen werden gespeichert."
            ],
            referencePriority: .normal,
            referenceTeam: .konto
        ),
        Ticket(
            id: "ticket-005",
            ticketNumber: "TT-005",
            title: "Mehrfaktorcode kommt nicht an",
            shortDescription: "Eine Person erhaelt beim Anmelden keinen Mehrfaktorcode mehr.",
            userImpact: "Wichtige Fachanwendungen sind fuer diese Person nicht erreichbar.",
            symptoms: [
                "Passwort wird akzeptiert.",
                "Der zweite Faktor wird nicht zugestellt.",
                "Ein Ersatzgeraet ist bereits registriert."
            ],
            referencePriority: .wichtig,
            referenceTeam: .konto
        ),
        Ticket(
            id: "ticket-006",
            ticketNumber: "TT-006",
            title: "Administratorkonto gesperrt",
            shortDescription: "Ein privilegiertes Betriebskonto ist nach mehreren Fehlversuchen gesperrt.",
            userImpact: "Kritische Wartungsarbeiten an Produktivsystemen koennen nicht ausgefuehrt werden.",
            symptoms: [
                "Anmeldung wird trotz bekanntem Kennwort abgelehnt.",
                "Sperrhinweis erscheint in der Kontoverwaltung.",
                "Mehrere geplante Deployments warten auf Freigabe."
            ],
            referencePriority: .kritisch,
            referenceTeam: .konto
        ),
        Ticket(
            id: "ticket-007",
            ticketNumber: "TT-007",
            title: "Export erzeugt falsches Datumsformat",
            shortDescription: "Ein Bericht exportiert Datumswerte im falschen Format.",
            userImpact: "Die Auswertung muss vor dem Versand manuell korrigiert werden.",
            symptoms: [
                "CSV-Datei nutzt Monat vor Tag.",
                "Die Anzeige in der Anwendung ist korrekt."
            ],
            referencePriority: .normal,
            referenceTeam: .software
        ),
        Ticket(
            id: "ticket-008",
            ticketNumber: "TT-008",
            title: "Fachanwendung speichert Auftraege nicht",
            shortDescription: "Neue Auftraege bleiben nach dem Speichern nicht erhalten.",
            userImpact: "Auftragsdaten muessen doppelt erfasst und nachkontrolliert werden.",
            symptoms: [
                "Speichern meldet Erfolg.",
                "Nach dem Neuladen fehlt der Auftrag.",
                "Bestandsdaten lassen sich anzeigen."
            ],
            referencePriority: .wichtig,
            referenceTeam: .software
        ),
        Ticket(
            id: "ticket-009",
            ticketNumber: "TT-009",
            title: "Kassensoftware startet nicht",
            shortDescription: "Die Kassensoftware stuerzt direkt beim Start auf allen Kassen ab.",
            userImpact: "Verkaeufe koennen am betroffenen Standort nicht abgeschlossen werden.",
            symptoms: [
                "Startbildschirm erscheint kurz und schliesst sich.",
                "Neustart der Kassen aendert das Verhalten nicht.",
                "Der Fehler begann nach dem letzten Update."
            ],
            referencePriority: .kritisch,
            referenceTeam: .software
        ),
        Ticket(
            id: "ticket-010",
            ticketNumber: "TT-010",
            title: "Externer Monitor bleibt dunkel",
            shortDescription: "Ein Arbeitsplatz erkennt den angeschlossenen Monitor nicht zuverlaessig.",
            userImpact: "Die betroffene Person arbeitet voruebergehend nur mit dem Notebook-Display.",
            symptoms: [
                "Monitor zeigt kein Signal.",
                "Anderes Kabel wurde bereits getestet."
            ],
            referencePriority: .normal,
            referenceTeam: .hardware
        ),
        Ticket(
            id: "ticket-011",
            ticketNumber: "TT-011",
            title: "Etikettendrucker druckt unleserlich",
            shortDescription: "Ein Lagerdrucker erzeugt verschobene und kaum lesbare Etiketten.",
            userImpact: "Warenausgaenge verzoegern sich, weil Etiketten neu erstellt werden muessen.",
            symptoms: [
                "Druckbild ist horizontal versetzt.",
                "Reinigung wurde bereits durchgefuehrt.",
                "Andere Drucker im Lager funktionieren."
            ],
            referencePriority: .wichtig,
            referenceTeam: .hardware
        ),
        Ticket(
            id: "ticket-012",
            ticketNumber: "TT-012",
            title: "Arbeitsplaetze starten nach Stromausfall nicht",
            shortDescription: "Mehrere Rechner in der Leitstelle lassen sich nicht mehr einschalten.",
            userImpact: "Die Leitstelle kann nur eingeschraenkt auf operative Systeme zugreifen.",
            symptoms: [
                "Netzteile zeigen keine Statusleuchte.",
                "Steckdosenleiste wurde geprueft.",
                "Ersatzarbeitsplaetze sind nicht ausreichend vorhanden."
            ],
            referencePriority: .kritisch,
            referenceTeam: .hardware
        )
    ]
}
