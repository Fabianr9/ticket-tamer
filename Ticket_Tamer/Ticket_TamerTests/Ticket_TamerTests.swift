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
