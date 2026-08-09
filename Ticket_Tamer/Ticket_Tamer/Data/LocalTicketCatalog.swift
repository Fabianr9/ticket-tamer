import Foundation

// MARK: - Local Ticket Catalog

/// Vollständiger statischer Ticketpool für Modul 002 (erweitert in Modul 005 um monsterAssetId).
enum LocalTicketCatalog {
    /// Genau zwölf lokal definierte Tickets ohne Netzwerk-, Datei- oder API-Zugriff.
    ///
    /// Modul 005 (F-14 / AK-14): Jedes Ticket trägt einen neutralen Monster-Bezeichner.
    /// Die Verteilung ist bewusst so gewählt, dass kein Monster eindeutig einem Team
    /// oder einer Priorität zugeordnet werden kann.
    ///
    /// Modul 006: Alle ae/oe/ue-Substitutionen wurden durch korrekte deutsche Umlaute ersetzt.
    /// Fachliche Werte (referencePriority, referenceTeam, monsterAssetId) sind unverändert.
    ///
    /// Verteilungsübersicht:
    /// - monster01: netzwerk/normal, konto/wichtig, software/kritisch
    /// - monster02: netzwerk/wichtig, konto/kritisch, hardware/normal
    /// - monster03: netzwerk/kritisch, software/normal, hardware/wichtig
    /// - monster04: konto/normal, software/wichtig, hardware/kritisch
    static let allTickets: [Ticket] = [
        Ticket(
            id: "ticket-001",
            ticketNumber: "TT-001",
            title: "Langsamer Zugriff auf interne Dienste",
            shortDescription: "Mehrere interne Webseiten laden deutlich verzögert.",
            userImpact: "Mitarbeitende können Kundenanfragen nur mit Wartezeiten bearbeiten.",
            symptoms: [
                "Intranet-Seiten öffnen erst nach mehreren Sekunden.",
                "Videokonferenzen bleiben stabil.",
                "Das Problem tritt nur im Büro-Netz auf."
            ],
            referencePriority: .normal,
            referenceTeam: .netzwerk,
            monsterAssetId: AssetKeys.Monster.monster01
        ),
        Ticket(
            id: "ticket-002",
            ticketNumber: "TT-002",
            title: "VPN-Verbindung bricht regelmäßig ab",
            shortDescription: "Remote arbeitende Personen verlieren mehrmals pro Stunde die VPN-Verbindung.",
            userImpact: "Laufende Arbeiten in Fachsystemen müssen wiederholt neu gestartet werden.",
            symptoms: [
                "VPN-Client meldet Zeitüberschreitung.",
                "Lokale Internetverbindung bleibt verfügbar."
            ],
            referencePriority: .wichtig,
            referenceTeam: .netzwerk,
            monsterAssetId: AssetKeys.Monster.monster02
        ),
        Ticket(
            id: "ticket-003",
            ticketNumber: "TT-003",
            title: "Standort ohne Netzwerkzugang",
            shortDescription: "Ein kompletter Standort erreicht weder interne noch externe Dienste.",
            userImpact: "Der betroffene Standort kann keine Tickets, Bestellungen oder Kundendaten bearbeiten.",
            symptoms: [
                "Alle Arbeitsplätze zeigen keine Netzwerkverbindung.",
                "Telefonie über das Datennetz ist ebenfalls ausgefallen.",
                "Andere Standorte melden keine Störung."
            ],
            referencePriority: .kritisch,
            referenceTeam: .netzwerk,
            monsterAssetId: AssetKeys.Monster.monster03
        ),
        Ticket(
            id: "ticket-004",
            ticketNumber: "TT-004",
            title: "Profilbild lässt sich nicht ändern",
            shortDescription: "Eine Person kann das Profilbild im Unternehmensportal nicht aktualisieren.",
            userImpact: "Die Arbeit ist möglich, aber das Personenprofil bleibt unvollständig.",
            symptoms: [
                "Upload endet ohne sichtbare Fehlermeldung.",
                "Andere Profileinstellungen werden gespeichert."
            ],
            referencePriority: .normal,
            referenceTeam: .konto,
            monsterAssetId: AssetKeys.Monster.monster04
        ),
        Ticket(
            id: "ticket-005",
            ticketNumber: "TT-005",
            title: "Mehrfaktorcode kommt nicht an",
            shortDescription: "Eine Person erhält beim Anmelden keinen Mehrfaktorcode mehr.",
            userImpact: "Wichtige Fachanwendungen sind für diese Person nicht erreichbar.",
            symptoms: [
                "Passwort wird akzeptiert.",
                "Der zweite Faktor wird nicht zugestellt.",
                "Ein Ersatzgerät ist bereits registriert."
            ],
            referencePriority: .wichtig,
            referenceTeam: .konto,
            monsterAssetId: AssetKeys.Monster.monster01
        ),
        Ticket(
            id: "ticket-006",
            ticketNumber: "TT-006",
            title: "Administratorkonto gesperrt",
            shortDescription: "Ein privilegiertes Betriebskonto ist nach mehreren Fehlversuchen gesperrt.",
            userImpact: "Kritische Wartungsarbeiten an Produktivsystemen können nicht ausgeführt werden.",
            symptoms: [
                "Anmeldung wird trotz bekanntem Kennwort abgelehnt.",
                "Sperrhinweis erscheint in der Kontoverwaltung.",
                "Mehrere geplante Deployments warten auf Freigabe."
            ],
            referencePriority: .kritisch,
            referenceTeam: .konto,
            monsterAssetId: AssetKeys.Monster.monster02
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
            referenceTeam: .software,
            monsterAssetId: AssetKeys.Monster.monster03
        ),
        Ticket(
            id: "ticket-008",
            ticketNumber: "TT-008",
            title: "Fachanwendung speichert Aufträge nicht",
            shortDescription: "Neue Aufträge bleiben nach dem Speichern nicht erhalten.",
            userImpact: "Auftragsdaten müssen doppelt erfasst und nachkontrolliert werden.",
            symptoms: [
                "Speichern meldet Erfolg.",
                "Nach dem Neuladen fehlt der Auftrag.",
                "Bestandsdaten lassen sich anzeigen."
            ],
            referencePriority: .wichtig,
            referenceTeam: .software,
            monsterAssetId: AssetKeys.Monster.monster04
        ),
        Ticket(
            id: "ticket-009",
            ticketNumber: "TT-009",
            title: "Kassensoftware startet nicht",
            shortDescription: "Die Kassensoftware stürzt direkt beim Start auf allen Kassen ab.",
            userImpact: "Verkäufe können am betroffenen Standort nicht abgeschlossen werden.",
            symptoms: [
                "Startbildschirm erscheint kurz und schließt sich.",
                "Neustart der Kassen ändert das Verhalten nicht.",
                "Der Fehler begann nach dem letzten Update."
            ],
            referencePriority: .kritisch,
            referenceTeam: .software,
            monsterAssetId: AssetKeys.Monster.monster01
        ),
        Ticket(
            id: "ticket-010",
            ticketNumber: "TT-010",
            title: "Externer Monitor bleibt dunkel",
            shortDescription: "Ein Arbeitsplatz erkennt den angeschlossenen Monitor nicht zuverlässig.",
            userImpact: "Die betroffene Person arbeitet vorübergehend nur mit dem Notebook-Display.",
            symptoms: [
                "Monitor zeigt kein Signal.",
                "Anderes Kabel wurde bereits getestet."
            ],
            referencePriority: .normal,
            referenceTeam: .hardware,
            monsterAssetId: AssetKeys.Monster.monster02
        ),
        Ticket(
            id: "ticket-011",
            ticketNumber: "TT-011",
            title: "Etikettendrucker druckt unleserlich",
            shortDescription: "Ein Lagerdrucker erzeugt verschobene und kaum lesbare Etiketten.",
            userImpact: "Warenausgänge verzögern sich, weil Etiketten neu erstellt werden müssen.",
            symptoms: [
                "Druckbild ist horizontal versetzt.",
                "Reinigung wurde bereits durchgeführt.",
                "Andere Drucker im Lager funktionieren."
            ],
            referencePriority: .wichtig,
            referenceTeam: .hardware,
            monsterAssetId: AssetKeys.Monster.monster03
        ),
        Ticket(
            id: "ticket-012",
            ticketNumber: "TT-012",
            title: "Arbeitsplätze starten nach Stromausfall nicht",
            shortDescription: "Mehrere Rechner in der Leitstelle lassen sich nicht mehr einschalten.",
            userImpact: "Die Leitstelle kann nur eingeschränkt auf operative Systeme zugreifen.",
            symptoms: [
                "Netzteile zeigen keine Statusleuchte.",
                "Steckdosenleiste wurde geprüft.",
                "Ersatzarbeitsplätze sind nicht ausreichend vorhanden."
            ],
            referencePriority: .kritisch,
            referenceTeam: .hardware,
            monsterAssetId: AssetKeys.Monster.monster04
        )
    ]
}
