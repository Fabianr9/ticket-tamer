import Testing
@testable import Ticket_Tamer

/// Smoke-Tests für die technische Grundlage aus Modul 001.
struct TicketTamerTests {

    @Test("Die Maße des zentralen Volumes sind positiv")
    func centralVolumeDimensionsArePositive() {
        #expect(LayoutConstants.centralVolumeWidth > 0)
        #expect(LayoutConstants.centralVolumeHeight > 0)
        #expect(LayoutConstants.centralVolumeDepth > 0)
    }

    @Test("Der lokale Ticketkatalog enthält genau zwölf Tickets")
    func localCatalogContainsExactlyTwelveTickets() {
        #expect(LocalTicketCatalog.allTickets.count == 12)
        #expect(LocalTicketCatalog.allTickets.count == GameplayConstants.maximumTicketCount)
    }

    @Test("Jede Kombination aus Support-Team und Priorität kommt genau einmal vor")
    func localCatalogCoversEveryTeamPriorityCombinationExactlyOnce() {
        let tickets = LocalTicketCatalog.allTickets
        let combinations = tickets.map { "\($0.referenceTeam.rawValue)-\($0.referencePriority.rawValue)" }
        let uniqueCombinations = Set(combinations)
        let expectedCombinationCount = SupportTeam.allCases.count * TicketPriority.allCases.count

        #expect(uniqueCombinations.count == expectedCombinationCount)
        #expect(combinations.count == uniqueCombinations.count)

        for team in SupportTeam.allCases {
            for priority in TicketPriority.allCases {
                let matchingTickets = tickets.filter {
                    $0.referenceTeam == team && $0.referencePriority == priority
                }

                #expect(matchingTickets.count == 1)
            }
        }
    }

    @Test("Alle Tickets haben vollständige fachliche Pflichtdaten")
    func localCatalogTicketsContainRequiredData() {
        for ticket in LocalTicketCatalog.allTickets {
            #expect(!ticket.id.isEmpty)
            #expect(!ticket.ticketNumber.isEmpty)
            #expect(!ticket.title.isEmpty)
            #expect(!ticket.shortDescription.isEmpty)
            #expect(!ticket.userImpact.isEmpty)
            #expect((1...3).contains(ticket.symptoms.count))
            #expect(ticket.symptoms.allSatisfy { !$0.isEmpty })
        }
    }

    @Test("Ticketnummern und IDs sind eindeutig")
    func localCatalogUsesStableUniqueIdentifiers() {
        let tickets = LocalTicketCatalog.allTickets
        let ids = Set(tickets.map(\.id))
        let ticketNumbers = Set(tickets.map(\.ticketNumber))

        #expect(ids.count == tickets.count)
        #expect(ticketNumbers.count == tickets.count)
    }

    @Test("Der lokale Ticketkatalog ist statisch und ohne externe Quelle verfügbar")
    func localCatalogIsAvailableWithoutExternalSource() {
        let firstRead = LocalTicketCatalog.allTickets
        let secondRead = LocalTicketCatalog.allTickets

        #expect(firstRead == secondRead)
        #expect(firstRead.count == 12)
        #expect(firstRead.allSatisfy { !$0.ticketNumber.hasPrefix("http") })
    }

    @Test("Prioritäten und Support-Teams bilden nur die fachlich erlaubten Werte ab")
    func domainEnumsContainOnlyRequiredCases() {
        #expect(TicketPriority.allCases == [.normal, .wichtig, .kritisch])
        #expect(SupportTeam.allCases == [.netzwerk, .konto, .software, .hardware])

        #expect(TicketPriority.allCases.map(\.displayName) == ["Normal", "Wichtig", "Kritisch"])
        #expect(SupportTeam.allCases.map(\.displayName) == ["Netzwerk", "Konto", "Software", "Hardware"])
    }
}

// MARK: - Modul 003: Sitzungsmodell und Zufallsauswahl

/// Tests für das zentrale Sitzungsmodell (SPEC F-04, F-16, AK-04, AK-16 Modellanteil).
///
/// Der Struct ist `@MainActor`, weil `SessionModel` in einem App-Target mit
/// `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` kompiliert wurde und daher
/// implizit `@MainActor`-isoliert ist.
/// Tests dürfen nicht von SwiftUI, RealityKit, Audio oder einem laufenden Simulatorfenster abhängen.
@MainActor
struct SessionModelTests {

    // MARK: - Ticketanzahl

    @Test("Standardticketanzahl beträgt 6")
    func defaultTicketCountIsSix() {
        let model = SessionModel()
        #expect(model.selectedTicketCount == GameplayConstants.defaultTicketCount)
        #expect(model.selectedTicketCount == 6)
    }

    @Test("Gültige Grenzwerte 1 und 12 werden akzeptiert")
    func validBoundaryValuesAreAccepted() {
        let model = SessionModel()
        model.setTicketCount(GameplayConstants.minimumTicketCount)
        #expect(model.selectedTicketCount == 1)
        model.setTicketCount(GameplayConstants.maximumTicketCount)
        #expect(model.selectedTicketCount == 12)
    }

    @Test("Technisch ungültige Werte werden defensiv auf den Gültigkeitsbereich begrenzt")
    func invalidTicketCountsAreClamped() {
        let model = SessionModel()
        model.setTicketCount(0)
        #expect(model.selectedTicketCount == GameplayConstants.minimumTicketCount)
        model.setTicketCount(-99)
        #expect(model.selectedTicketCount == GameplayConstants.minimumTicketCount)
        model.setTicketCount(13)
        #expect(model.selectedTicketCount == GameplayConstants.maximumTicketCount)
        model.setTicketCount(1000)
        #expect(model.selectedTicketCount == GameplayConstants.maximumTicketCount)
    }

    // MARK: - Sitzungsauswahl (AK-04)

    @Test("Sitzung mit 1 Ticket enthält genau 1 Ticket")
    func sessionWithOneTicketContainsExactlyOneTicket() {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        #expect(model.sessionTickets.count == 1)
    }

    @Test("Sitzung mit 6 Tickets enthält genau 6 Tickets")
    func sessionWithSixTicketsContainsExactlySixTickets() {
        let model = SessionModel()
        model.setTicketCount(6)
        model.startSession(using: { $0 })
        #expect(model.sessionTickets.count == 6)
    }

    @Test("Sitzung mit 12 Tickets enthält genau 12 Tickets")
    func sessionWithTwelveTicketsContainsExactlyTwelveTickets() {
        let model = SessionModel()
        model.setTicketCount(12)
        model.startSession(using: { $0 })
        #expect(model.sessionTickets.count == 12)
    }

    @Test("Keine doppelte Ticket-ID innerhalb einer Sitzung")
    func sessionTicketIdsAreUnique() {
        let model = SessionModel()
        model.setTicketCount(12)
        model.startSession(using: { $0 })
        let ids = model.sessionTickets.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test("Alle Sitzungstickets stammen aus LocalTicketCatalog.allTickets")
    func sessionTicketsComeFromLocalCatalog() {
        let model = SessionModel()
        model.setTicketCount(6)
        model.startSession(using: { $0 })
        let catalogIds = Set(LocalTicketCatalog.allTickets.map(\.id))
        for ticket in model.sessionTickets {
            #expect(catalogIds.contains(ticket.id))
        }
    }

    // MARK: - Zufallsauswahl und Testnaht

    @Test("Neue Sitzungen führen die Auswahlfunktion erneut aus")
    func newSessionsReExecuteShuffleFunction() {
        let model = SessionModel()
        model.setTicketCount(6)
        var callCount = 0
        let countingShuffleFunction: ([Ticket]) -> [Ticket] = { tickets in
            callCount += 1
            return tickets
        }
        model.startSession(using: countingShuffleFunction)
        #expect(callCount == 1)
        model.startSession(using: countingShuffleFunction)
        #expect(callCount == 2)
        #expect(model.sessionTickets.count == 6)
    }

    @Test("Unterschiedliche gültige Auswahlen sind über die deterministische Testnaht möglich")
    func deterministicShuffleFunctionProducesDifferentSelections() {
        let model = SessionModel()
        model.setTicketCount(6)
        // Identitätsfunktion: erste 6 Tickets des Katalogs
        model.startSession(using: { $0 })
        let forwardIds = model.sessionTickets.map(\.id)
        // Umgekehrte Funktion: letzte 6 Tickets des Katalogs
        model.startSession(using: { Array($0.reversed()) })
        let reversedIds = model.sessionTickets.map(\.id)
        // Beide Auswahlen müssen gültig sein ...
        #expect(forwardIds.count == 6)
        #expect(reversedIds.count == 6)
        // ... und bei 12 Katalogtickets plus Präfix-6 unterschiedlich sein.
        #expect(forwardIds != reversedIds)
    }

    // MARK: - Ticketindex

    @Test("Ticketindex startet nach Sitzungsbeginn bei 0")
    func ticketIndexStartsAtZeroAfterSessionStart() {
        let model = SessionModel()
        model.setTicketCount(6)
        model.startSession(using: { $0 })
        #expect(model.currentTicketIndex == 0)
    }

    @Test("Sicherer Zugriff auf das aktuelle Ticket")
    func currentTicketIsAccessibleAndSafe() {
        let model = SessionModel()
        // Vor dem Start: kein aktuelles Ticket — kein Absturz.
        #expect(model.currentTicket == nil)
        model.setTicketCount(6)
        model.startSession(using: { $0 })
        // Nach dem Start: erstes Ticket vorhanden und korrekt.
        #expect(model.currentTicket != nil)
        #expect(model.currentTicket?.id == model.sessionTickets[0].id)
    }

    @Test("Indexfortschaltung klemmt am Ende der Liste ohne Absturz")
    func indexAdvancementClampsAtEndOfList() {
        let model = SessionModel()
        model.setTicketCount(3)
        model.startSession(using: { $0 })
        // Vorwärtslauf bis zum Ende
        model.advanceToNextTicket()
        #expect(model.currentTicketIndex == 1)
        model.advanceToNextTicket()
        #expect(model.currentTicketIndex == 2)
        // Klemm-Semantik: weiteres Vorschalten bleibt bei 2
        model.advanceToNextTicket()
        #expect(model.currentTicketIndex == 2)
        model.advanceToNextTicket()
        #expect(model.currentTicketIndex == 2)
        // Zugriff auf aktuelles Ticket bleibt nach wie vor gültig
        #expect(model.currentTicket != nil)
    }

    // MARK: - Reset (AK-16 Modellanteil)

    @Test("Reset stellt alle Modellfelder auf Startwerte zurück")
    func resetRestoresAllModelFields() {
        let model = SessionModel()
        model.setTicketCount(8)
        model.startSession(using: { $0 })
        model.advanceToNextTicket()
        model.advanceToNextTicket()
        model.reset()
        #expect(model.selectedTicketCount == GameplayConstants.defaultTicketCount)
        #expect(model.sessionTickets.isEmpty)
        #expect(model.currentTicketIndex == 0)
        #expect(model.currentPhase == GamePhase.start)
        #expect(model.score == 0)
        #expect(model.selectedPriority == nil)
        #expect(model.selectedTeam == nil)
        #expect(model.isInputLocked == false)
        // Nach Reset: kein aktuelles Ticket mehr
        #expect(model.currentTicket == nil)
    }

    @Test("Fünf aufeinanderfolgende Resets bleiben stabil und hinterlassen keinen Altzustand")
    func fiveConsecutiveResetsRemainStable() {
        let model = SessionModel()
        for iteration in 1...5 {
            // Variiere Ticketanzahl, um verschiedene Sitzungszustände zu erzeugen.
            let ticketCount = min(iteration * 2, GameplayConstants.maximumTicketCount)
            model.setTicketCount(ticketCount)
            model.startSession(using: { $0 })
            // Index bewegen, um Altzustand zu erzeugen
            model.advanceToNextTicket()
            model.reset()
            // Nach jedem Reset müssen alle Felder wieder die Startwerte haben
            #expect(model.selectedTicketCount == GameplayConstants.defaultTicketCount)
            #expect(model.sessionTickets.isEmpty)
            #expect(model.currentTicketIndex == 0)
            #expect(model.currentPhase == GamePhase.start)
            #expect(model.score == 0)
            #expect(model.selectedPriority == nil)
            #expect(model.selectedTeam == nil)
            #expect(model.isInputLocked == false)
        }
    }
}
