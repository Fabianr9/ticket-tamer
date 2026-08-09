import Testing
import simd
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

// MARK: - Modul 004: Startansicht und Einstellungen

/// Tests für den Zustandsfluss der Startansicht (SPEC F-01, AK-01).
///
/// Prüft die Modellseite der Startansicht: Initialphase, Phasenwechsel durch startSession
/// und die korrekte Ticketanzahl nach dem Start. Die sichtbaren UI-Elemente (Regler,
/// Schaltfläche, Zahlenwert) werden manuell im visionOS-Simulator geprüft (AK-01).
@MainActor
struct StartViewModelTests {

    @Test("Initialphase nach Modellerzeugung ist .start")
    func initialPhaseIsStart() {
        let model = SessionModel()
        #expect(model.currentPhase == .start)
    }

    @Test("startSession wechselt Phase auf .untersuchen")
    func startSessionSetsPhaseToUntersuchen() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        #expect(model.currentPhase == .untersuchen)
    }

    @Test("Startaktion mit Standardwert 6 erzeugt genau 6 Sitzungstickets")
    func startActionWithDefaultCountProducesSixSessionTickets() {
        let model = SessionModel()
        // Standardwert bleibt 6 — kein explizites setTicketCount nötig
        #expect(model.selectedTicketCount == GameplayConstants.defaultTicketCount)
        model.startSession(using: { $0 })
        #expect(model.sessionTickets.count == 6)
        #expect(model.currentTicket != nil)
    }

    @Test("Nach startSession ist currentPhase nicht mehr .start")
    func afterStartSessionPhaseIsNotStart() {
        let model = SessionModel()
        #expect(model.currentPhase == .start)
        model.startSession(using: { $0 })
        #expect(model.currentPhase != .start)
    }

    @Test("Reset nach gestarteter Sitzung stellt Phase .start wieder her")
    func resetAfterSessionRestoresStartPhase() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        #expect(model.currentPhase == .untersuchen)
        model.reset()
        #expect(model.currentPhase == .start)
        #expect(model.selectedTicketCount == GameplayConstants.defaultTicketCount)
    }
}

// MARK: - Modul 005: Monster-Asset-Pipeline

/// Tests für die Monster-Asset-Pipeline (SPEC F-14 / AK-14).
///
/// Prüft Asset-IDs, Eindeutigkeit, Katalogzuordnung und das Fehlen einer
/// festen 1:1-Korrelation zwischen Monster, Team und Priorität.
/// RealityKit-Ladetests (Entity-Load) erfordern den Simulator und sind manuell zu prüfen.
struct MonsterAssetPipelineTests {

    // MARK: - Asset-Schlüssel

    @Test("Genau vier Monster-Asset-IDs sind definiert")
    func exactlyFourMonsterIDsDefined() {
        #expect(AssetKeys.Monster.allIDs.count == 4)
    }

    @Test("Alle vier Monster-IDs sind eindeutig")
    func allMonsterIDsAreUnique() {
        let ids = AssetKeys.Monster.allIDs
        #expect(Set(ids).count == ids.count)
    }

    @Test("Monster-IDs enthalten keine team- oder prioritätsbezogenen Begriffe")
    func monsterIDsAreNeutral() {
        let forbiddenTerms = ["netzwerk", "konto", "software", "hardware",
                              "normal", "wichtig", "kritisch",
                              "network", "critical", "account"]
        for id in AssetKeys.Monster.allIDs {
            let lowered = id.lowercased()
            for term in forbiddenTerms {
                #expect(!lowered.contains(term), "ID '\(id)' enthält verbotenen Begriff '\(term)'")
            }
        }
    }

    // MARK: - Ticketkatalog und Zuordnung

    @Test("Alle zwölf Tickets besitzen eine nicht-leere monsterAssetId")
    func allTicketsHaveNonEmptyMonsterAssetId() {
        for ticket in LocalTicketCatalog.allTickets {
            #expect(!ticket.monsterAssetId.isEmpty, "Ticket \(ticket.id) hat leere monsterAssetId")
        }
    }

    @Test("Jede im Katalog verwendete Monster-ID ist bekannt")
    func allCatalogMonsterIDsAreKnown() {
        let knownIDs = Set(AssetKeys.Monster.allIDs)
        for ticket in LocalTicketCatalog.allTickets {
            #expect(
                knownIDs.contains(ticket.monsterAssetId),
                "Ticket \(ticket.id) verwendet unbekannte ID '\(ticket.monsterAssetId)'"
            )
        }
    }

    @Test("Alle vier Monster-IDs kommen im Katalog tatsächlich vor")
    func allFourMonsterIDsAppearInCatalog() {
        let usedIDs = Set(LocalTicketCatalog.allTickets.map(\.monsterAssetId))
        for id in AssetKeys.Monster.allIDs {
            #expect(usedIDs.contains(id), "Monster-ID '\(id)' erscheint in keinem Ticket")
        }
    }

    // MARK: - Keine 1:1-Korrelation (F-14 / AK-14)

    @Test("Kein Monster ist eindeutig einem einzigen Team zugeordnet")
    func noMonsterIsExclusiveToOneTeam() {
        let tickets = LocalTicketCatalog.allTickets
        for monsterID in AssetKeys.Monster.allIDs {
            let teamsForMonster = Set(
                tickets.filter { $0.monsterAssetId == monsterID }.map(\.referenceTeam)
            )
            #expect(
                teamsForMonster.count > 1,
                "Monster '\(monsterID)' erscheint nur bei Team(s): \(teamsForMonster.map(\.rawValue))"
            )
        }
    }

    @Test("Kein Monster ist eindeutig einer einzigen Priorität zugeordnet")
    func noMonsterIsExclusiveToOnePriority() {
        let tickets = LocalTicketCatalog.allTickets
        for monsterID in AssetKeys.Monster.allIDs {
            let prioritiesForMonster = Set(
                tickets.filter { $0.monsterAssetId == monsterID }.map(\.referencePriority)
            )
            #expect(
                prioritiesForMonster.count > 1,
                "Monster '\(monsterID)' erscheint nur bei Prioritaet(en): \(prioritiesForMonster.map(\.rawValue))"
            )
        }
    }

    @Test("Jedes Monster kommt bei mindestens zwei verschiedenen Teams vor")
    func eachMonsterAppearsWithMultipleTeams() {
        let tickets = LocalTicketCatalog.allTickets
        for monsterID in AssetKeys.Monster.allIDs {
            let teams = Set(tickets.filter { $0.monsterAssetId == monsterID }.map(\.referenceTeam))
            #expect(teams.count >= 2)
        }
    }

    @Test("Jedes Monster kommt bei mindestens zwei verschiedenen Prioritäten vor")
    func eachMonsterAppearsWithMultiplePriorities() {
        let tickets = LocalTicketCatalog.allTickets
        for monsterID in AssetKeys.Monster.allIDs {
            let priorities = Set(tickets.filter { $0.monsterAssetId == monsterID }.map(\.referencePriority))
            #expect(priorities.count >= 2)
        }
    }

    // MARK: - Vollständigkeit

    @Test("MonsterAssetProvider-Fehler: unbekannte ID wird abgewiesen")
    @MainActor
    func unknownAssetIDThrows() async {
        do {
            _ = try await MonsterAssetProvider.loadMonster(assetID: "monsterXX")
            #expect(Bool(false), "Erwartet einen Fehler fuer unbekannte ID")
        } catch MonsterAssetProvider.LoadError.unknownAssetID(let id) {
            #expect(id == "monsterXX")
        } catch {
            #expect(Bool(false), "Unerwarteter Fehlertyp: \(error)")
        }
    }
}

// MARK: - Modul 006: Untersuchungsphase

/// Tests für Phasenwechsel und Datenverfügbarkeit in der Untersuchungsphase (F-06 / F-07 / AK-06 / AK-07).
///
/// Geprüft werden ausschließlich Modell- und Datenbedingungen.
/// Die sichtbare UI (Monster, Ticketkarte, Button-Position) wird manuell im Simulator geprüft.
@MainActor
struct InvestigationPhaseTests {

    // MARK: - Phasenwechsel (AK-07)

    @Test("Phasenwechsel von untersuchen zu priorisieren")
    func phaseTransitionsFromUntersuchenToPriorisieren() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        #expect(model.currentPhase == .untersuchen)
        model.beginPrioritizationPhase()
        #expect(model.currentPhase == .priorisieren)
    }

    @Test("Ticketindex bleibt beim Phasenwechsel unverändert")
    func ticketIndexRemainsUnchangedAfterPhaseTransition() {
        let model = SessionModel()
        model.setTicketCount(3)
        model.startSession(using: { $0 })
        model.advanceToNextTicket()
        let indexBefore = model.currentTicketIndex
        model.beginPrioritizationPhase()
        #expect(model.currentTicketIndex == indexBefore)
    }

    @Test("currentTicket bleibt beim Phasenwechsel dasselbe")
    func currentTicketRemainsTheSameAfterPhaseTransition() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        let ticketBefore = model.currentTicket
        model.beginPrioritizationPhase()
        #expect(model.currentTicket == ticketBefore)
    }

    @Test("selectedPriority bleibt nil nach Phasenwechsel")
    func selectedPriorityRemainsNilAfterPhaseTransition() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        #expect(model.selectedPriority == nil)
    }

    @Test("Phasenwechsel aus falscher Phase wird ignoriert")
    func phaseTransitionFromWrongPhaseIsIgnored() {
        let model = SessionModel()
        // Vor Sitzungsstart: Phase ist .start — Aufruf ist No-Op
        #expect(model.currentPhase == .start)
        model.beginPrioritizationPhase()
        #expect(model.currentPhase == .start)

        // Nach Sitzungsstart und Wechsel zu .priorisieren: weiterer Aufruf ist No-Op
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        #expect(model.currentPhase == .priorisieren)
        model.beginPrioritizationPhase()
        #expect(model.currentPhase == .priorisieren)
    }

    // MARK: - Datenverfügbarkeit (AK-06)

    @Test("currentTicket enthält alle für die Untersuchungsansicht benötigten Daten")
    func currentTicketHasAllRequiredInvestigationData() {
        let model = SessionModel()
        model.setTicketCount(12)
        model.startSession(using: { $0 })
        for ticket in model.sessionTickets {
            #expect(!ticket.ticketNumber.isEmpty, "ticketNumber fehlt: \(ticket.id)")
            #expect(!ticket.title.isEmpty, "title fehlt: \(ticket.id)")
            #expect(!ticket.shortDescription.isEmpty, "shortDescription fehlt: \(ticket.id)")
            #expect(!ticket.userImpact.isEmpty, "userImpact fehlt: \(ticket.id)")
            #expect(!ticket.symptoms.isEmpty, "symptoms leer: \(ticket.id)")
            #expect(!ticket.monsterAssetId.isEmpty, "monsterAssetId fehlt: \(ticket.id)")
        }
    }

    @Test("Alle Tickets im Katalog haben 1 bis 3 Symptome")
    func allCatalogTicketsHaveOneToThreeSymptoms() {
        for ticket in LocalTicketCatalog.allTickets {
            #expect(
                (1...3).contains(ticket.symptoms.count),
                "Ticket \(ticket.ticketNumber) hat \(ticket.symptoms.count) Symptome, erwartet 1–3"
            )
        }
    }
}

// MARK: - Modul 007: Räumliche Interaktionsgrundlagen

/// Tests für Input-Lock-Semantik und Drop-Auswertung (SPEC F-10 / AK-10).
///
/// Prüft ausschließlich Modell- und Servicelogik ohne laufenden RealityKit-Render-Loop.
/// RealityKit-Gesten (Hover, Pinch, Drag) sind manuell im Simulator zu prüfen.
@MainActor
struct InteractionFoundationTests {

    // MARK: - Input-Lock — Initialzustand

    @Test("Input-Lock startet false")
    func inputLockStartsFalse() {
        let model = SessionModel()
        #expect(model.isInputLocked == false)
    }

    @Test("Input-Lock nach Sitzungsstart weiterhin false")
    func inputLockIsFalseAfterSessionStart() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        #expect(model.isInputLocked == false)
    }

    // MARK: - lockInput

    @Test("lockInput setzt isInputLocked auf true")
    func lockInputSetsLockTrue() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.lockInput()
        #expect(model.isInputLocked == true)
    }

    @Test("Zweites lockInput während Lock ist No-Op (genau-einmal-Semantik)")
    func secondLockInputWhileLockedIsNoOp() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.lockInput()
        #expect(model.isInputLocked == true)
        // Zweiter Aufruf — darf keinen Fehler verursachen und den Zustand nicht doppelt setzen.
        model.lockInput()
        #expect(model.isInputLocked == true)
    }

    @Test("lockInput verändert score nicht")
    func lockInputDoesNotChangeScore() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        let scoreBefore = model.score
        model.lockInput()
        #expect(model.score == scoreBefore)
    }

    @Test("lockInput verändert currentPhase nicht")
    func lockInputDoesNotChangePhase() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        let phaseBefore = model.currentPhase
        model.lockInput()
        #expect(model.currentPhase == phaseBefore)
    }

    @Test("lockInput verändert selectedPriority nicht")
    func lockInputDoesNotChangeSelectedPriority() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.lockInput()
        #expect(model.selectedPriority == nil)
    }

    @Test("lockInput verändert selectedTeam nicht")
    func lockInputDoesNotChangeSelectedTeam() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.lockInput()
        #expect(model.selectedTeam == nil)
    }

    // MARK: - unlockInput

    @Test("unlockInput entsperrt die Eingabe")
    func unlockInputUnlocks() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.lockInput()
        #expect(model.isInputLocked == true)
        model.unlockInput()
        #expect(model.isInputLocked == false)
    }

    @Test("unlockInput aus entsperrtem Zustand ist stabil")
    func unlockInputFromUnlockedStateIsStable() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        #expect(model.isInputLocked == false)
        model.unlockInput()
        #expect(model.isInputLocked == false)
    }

    // MARK: - Reset und Lock

    @Test("Reset setzt isInputLocked auf false zurück")
    func resetSetsInputLockFalse() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.lockInput()
        #expect(model.isInputLocked == true)
        model.reset()
        #expect(model.isInputLocked == false)
    }

    // MARK: - DropEvaluator — Positionsbasiert (kein RealityKit-Render-Loop)

    @Test("DropEvaluator: Entity innerhalb Radius gilt als gültig")
    func dropEvaluatorMatchInsideRadius() {
        let entityPos = SIMD3<Float>(0.1, 0, 0)
        let target = DropEvaluator.TargetDescriptor(
            id: "testTargetA",
            position: SIMD3(0, 0, 0),
            radius: 0.15
        )
        let result = DropEvaluator.evaluate(entityPosition: entityPos, targets: [target])
        #expect(result == "testTargetA")
    }

    @Test("DropEvaluator: Entity auf Randpunkt (== radius) gilt als gültig")
    func dropEvaluatorMatchAtExactRadius() {
        let entityPos = SIMD3<Float>(0.15, 0, 0)
        let target = DropEvaluator.TargetDescriptor(
            id: "testTargetA",
            position: SIMD3(0, 0, 0),
            radius: 0.15
        )
        let result = DropEvaluator.evaluate(entityPosition: entityPos, targets: [target])
        #expect(result == "testTargetA")
    }

    @Test("DropEvaluator: Entity außerhalb Radius gilt als ungültig")
    func dropEvaluatorNilOutsideRadius() {
        let entityPos = SIMD3<Float>(0.30, 0, 0)
        let target = DropEvaluator.TargetDescriptor(
            id: "testTargetA",
            position: SIMD3(0, 0, 0),
            radius: 0.15
        )
        let result = DropEvaluator.evaluate(entityPosition: entityPos, targets: [target])
        #expect(result == nil)
    }

    @Test("DropEvaluator: Bei leerer Zielliste immer nil")
    func dropEvaluatorEmptyTargetsIsNil() {
        let result = DropEvaluator.evaluate(
            entityPosition: SIMD3(0, 0, 0),
            targets: []
        )
        #expect(result == nil)
    }

    @Test("DropEvaluator: Bei mehreren Zielen gewinnt das nächste")
    func dropEvaluatorPicksNearestTarget() {
        let entityPos = SIMD3<Float>(0.05, 0, 0)
        let near = DropEvaluator.TargetDescriptor(id: "near", position: SIMD3(0, 0, 0), radius: 0.15)
        let far  = DropEvaluator.TargetDescriptor(id: "far",  position: SIMD3(0.5, 0, 0), radius: 0.15)
        let result = DropEvaluator.evaluate(entityPosition: entityPos, targets: [near, far])
        #expect(result == "near")
    }

    // MARK: - DropTargetComponent — Neutralität

    @Test("Generische Ziel-IDs sind fachlich neutral (keine Prioritäts-/Teambezeichner)")
    func dropTargetIDsAreNeutral() {
        let forbiddenTerms = ["normal", "wichtig", "kritisch",
                              "netzwerk", "konto", "software", "hardware"]
        let testIDs = ["testTargetA", "testTargetB", "zoneLeft", "zoneRight"]
        for id in testIDs {
            let lowered = id.lowercased()
            for term in forbiddenTerms {
                #expect(!lowered.contains(term), "ID '\(id)' enthält verbotenen Begriff '\(term)'")
            }
        }
    }

    @Test("DropTargetComponent speichert ID und Radius unveränderlich")
    func dropTargetComponentStoresFieldsImmutably() {
        let comp = DropTargetComponent(id: "testTargetA", radius: 0.15, debugName: "Test")
        #expect(comp.id == "testTargetA")
        #expect(comp.radius == 0.15)
        #expect(comp.debugName == "Test")
    }

    @Test("DropTargetComponent-Standardradius entspricht InteractionConstants")
    func dropTargetDefaultRadiusMatchesConstants() {
        let comp = DropTargetComponent(id: "x")
        #expect(comp.radius == InteractionConstants.dropTargetRadius)
    }
}

// MARK: - Modul 008: Priorisierungsphase

/// Tests für Prioritätsspeicherung und Ziel-/Mapping-Struktur (SPEC F-08 / AK-08 / AK-10).
///
/// Prüft ausschließlich Modell- und Mapping-Logik ohne laufenden RealityKit-Render-Loop.
/// RealityKit-Gesten (Hover, Pinch, Drag, Drop) sind manuell im Simulator zu prüfen (AK-08).
@MainActor
struct PrioritizationPhaseTests {

    // MARK: - savePriority — Speicherung

    @Test("Priorität .normal kann in .priorisieren gespeichert werden")
    func priorityNormalCanBeSavedInPriorityPhase() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        #expect(model.selectedPriority == .normal)
    }

    @Test("Priorität .wichtig wird korrekt gespeichert")
    func priorityWichtigIsStoredCorrectly() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.wichtig)
        #expect(model.selectedPriority == .wichtig)
    }

    @Test("Priorität .kritisch wird korrekt gespeichert")
    func priorityKritischIsStoredCorrectly() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.kritisch)
        #expect(model.selectedPriority == .kritisch)
    }

    @Test("Nach erster Speicherung ist isInputLocked == true")
    func inputIsLockedAfterFirstSave() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        #expect(model.isInputLocked == false)
        model.savePriority(.normal)
        #expect(model.isInputLocked == true)
    }

    @Test("Zweiter Speicherversuch wird ignoriert (genau-einmal-Semantik)")
    func secondSaveAttemptIsIgnored() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        model.savePriority(.wichtig)
        #expect(model.selectedPriority == .normal)
    }

    @Test("Zweite Priorität überschreibt die erste nicht")
    func secondPriorityDoesNotOverwriteFirst() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.kritisch)
        model.savePriority(.normal)
        model.savePriority(.wichtig)
        #expect(model.selectedPriority == .kritisch)
    }

    @Test("Speicherversuch außerhalb .priorisieren wird ignoriert")
    func savePriorityOutsidePriorityPhaseIsIgnored() {
        let model = SessionModel()
        // Phase: .start
        model.savePriority(.normal)
        #expect(model.selectedPriority == nil)

        // Phase: .untersuchen
        model.startSession(using: { $0 })
        model.savePriority(.normal)
        #expect(model.selectedPriority == nil)
    }

    @Test("Speicherung verändert score nicht")
    func savePriorityDoesNotChangeScore() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        let scoreBefore = model.score
        model.savePriority(.normal)
        #expect(model.score == scoreBefore)
    }

    @Test("Speicherung verändert selectedTeam nicht")
    func savePriorityDoesNotChangeSelectedTeam() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        #expect(model.selectedTeam == nil)
    }

    @Test("Speicherung verändert currentTicketIndex nicht")
    func savePriorityDoesNotChangeTicketIndex() {
        let model = SessionModel()
        model.setTicketCount(3)
        model.startSession(using: { $0 })
        model.advanceToNextTicket()
        let indexBefore = model.currentTicketIndex
        model.beginPrioritizationPhase()
        model.savePriority(.wichtig)
        #expect(model.currentTicketIndex == indexBefore)
    }

    @Test("Speicherung verändert currentPhase nicht (kein automatischer Übergang in Modul 008)")
    func savePriorityDoesNotChangePhase() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        #expect(model.currentPhase == .priorisieren)
        model.savePriority(.kritisch)
        #expect(model.currentPhase == .priorisieren)
    }

    // MARK: - savePriority — gesperrter Zustand

    @Test("Weitere Gesten während Lock verändern die gespeicherte Entscheidung nicht")
    func inputLockedPreventsOverwrite() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        #expect(model.isInputLocked == true)
        // Direktversuch: isInputLocked ist true → savePriority muss No-Op sein
        model.savePriority(.kritisch)
        #expect(model.selectedPriority == .normal)
    }

    // MARK: - Ungültiger Drop (Modell-Ebene)

    @Test("Ungültiger Drop speichert keine Priorität (selectedPriority bleibt nil)")
    func invalidDropLeavesSelectedPriorityNil() {
        // Simuliert ungültigen Drop: DropEvaluator gibt nil → savePriority wird nie aufgerufen.
        let entityPos = SIMD3<Float>(5.0, 0, 0)  // weit außerhalb aller Ziele
        let targets = PriorityTargetMapping.allTargets.map {
            DropEvaluator.TargetDescriptor(id: $0.id, position: $0.position, radius: InteractionConstants.dropTargetRadius)
        }
        let result = DropEvaluator.evaluate(entityPosition: entityPos, targets: targets)
        #expect(result == nil)

        // Wenn DropEvaluator nil liefert, wird savePriority nicht aufgerufen.
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        // Kein savePriority → selectedPriority bleibt nil
        #expect(model.selectedPriority == nil)
        #expect(model.isInputLocked == false)
    }

    // MARK: - PriorityTargetMapping — Struktur

    @Test("Genau drei Prioritätsziele existieren")
    func exactlyThreePriorityTargetsExist() {
        #expect(PriorityTargetMapping.allTargets.count == 3)
    }

    @Test("Alle drei technischen Ziel-IDs sind eindeutig")
    func allThreeTargetIDsAreUnique() {
        let ids = PriorityTargetMapping.allTargets.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test("Mapping deckt genau .normal, .wichtig, .kritisch ab")
    func mappingCoversExactlyAllThreePriorities() {
        let priorities = Set(PriorityTargetMapping.allTargets.map(\.priority))
        #expect(priorities == Set(TicketPriority.allCases))
    }

    @Test("Mapping gibt für priority_normal .normal zurück")
    func mappingReturnsNormalForNormalID() {
        #expect(PriorityTargetMapping.priority(for: "priority_normal") == .normal)
    }

    @Test("Mapping gibt für priority_wichtig .wichtig zurück")
    func mappingReturnsWichtigForWichtigID() {
        #expect(PriorityTargetMapping.priority(for: "priority_wichtig") == .wichtig)
    }

    @Test("Mapping gibt für priority_kritisch .kritisch zurück")
    func mappingReturnsKritischForKritischID() {
        #expect(PriorityTargetMapping.priority(for: "priority_kritisch") == .kritisch)
    }

    @Test("Mapping gibt nil für unbekannte Ziel-ID zurück")
    func mappingReturnsNilForUnknownID() {
        #expect(PriorityTargetMapping.priority(for: "unbekannt") == nil)
        #expect(PriorityTargetMapping.priority(for: "") == nil)
    }

    @Test("Zielabstände sind größer als 2 × dropTargetRadius (keine Überschneidung)")
    func targetPositionsDoNotOverlap() {
        let targets = PriorityTargetMapping.allTargets
        let radius = InteractionConstants.dropTargetRadius
        for i in targets.indices {
            for j in targets.indices where j > i {
                let dist = simd_distance(targets[i].position, targets[j].position)
                #expect(
                    dist > 2 * radius,
                    "Ziele '\(targets[i].id)' und '\(targets[j].id)' überschneiden sich (Abstand \(dist) ≤ \(2*radius))"
                )
            }
        }
    }

    @Test("PrioritizationConstants: monsterStartPosition ist erreichbar (y < targetPositionNormal.y)")
    func monsterStartPositionIsBelowTargets() {
        let monsterY = PrioritizationConstants.monsterStartPosition.y
        let targetY  = PrioritizationConstants.targetPositionNormal.y
        #expect(monsterY < targetY)
    }
}

// MARK: - Modul 009: Teamzuordnungsphase

/// Tests für Phasenwechsel, Teamspeicherung und Ziel-/Mapping-Struktur (SPEC F-09 / AK-09 / AK-10).
///
/// Prüft ausschließlich Modell- und Mapping-Logik ohne laufenden RealityKit-Render-Loop.
/// RealityKit-Gesten (Hover, Pinch, Drag, Drop) sind manuell im Simulator zu prüfen (AK-09).
@MainActor
struct TeamAssignmentPhaseTests {

    // MARK: - Hilfsmethode: Modell in teamZuordnen-Phase bringen

    private func modelInTeamPhase() -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        model.beginTeamAssignmentPhase()
        return model
    }

    // MARK: - beginTeamAssignmentPhase — gültiger Phasenwechsel

    @Test("Gültiger Wechsel: .priorisieren mit gespeicherter Priorität → .teamZuordnen")
    func beginTeamPhaseTransitionsPriorisierenToTeamZuordnen() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        model.beginTeamAssignmentPhase()
        #expect(model.currentPhase == .teamZuordnen)
    }

    @Test("Gespeicherte Priorität bleibt nach beginTeamAssignmentPhase erhalten")
    func priorityIsPreservedAfterBeginTeamPhase() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.kritisch)
        model.beginTeamAssignmentPhase()
        #expect(model.selectedPriority == .kritisch)
    }

    @Test("Ticketindex bleibt nach beginTeamAssignmentPhase unverändert")
    func ticketIndexIsUnchangedAfterBeginTeamPhase() {
        let model = SessionModel()
        model.setTicketCount(3)
        model.startSession(using: { $0 })
        model.advanceToNextTicket()
        let indexBefore = model.currentTicketIndex
        model.beginPrioritizationPhase()
        model.savePriority(.wichtig)
        model.beginTeamAssignmentPhase()
        #expect(model.currentTicketIndex == indexBefore)
    }

    @Test("Score bleibt nach beginTeamAssignmentPhase unverändert")
    func scoreIsUnchangedAfterBeginTeamPhase() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        let scoreBefore = model.score
        model.beginTeamAssignmentPhase()
        #expect(model.score == scoreBefore)
    }

    @Test("Input ist nach beginTeamAssignmentPhase freigegeben (für Teamphase entsperrt)")
    func inputIsUnlockedAfterBeginTeamPhase() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(.normal)
        // Nach savePriority ist Input gesperrt.
        #expect(model.isInputLocked == true)
        model.beginTeamAssignmentPhase()
        // beginTeamAssignmentPhase gibt Input für die neue Teamentscheidung frei.
        #expect(model.isInputLocked == false)
    }

    // MARK: - beginTeamAssignmentPhase — ungültige Aufrufe (No-Op)

    @Test("Phasenwechsel ohne gespeicherte Priorität wird ignoriert")
    func beginTeamPhaseWithoutPriorityIsIgnored() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        // Keine Priorität gespeichert — No-Op erwartet.
        model.beginTeamAssignmentPhase()
        #expect(model.currentPhase == .priorisieren)
    }

    @Test("Phasenwechsel aus falscher Phase (.untersuchen) wird ignoriert")
    func beginTeamPhaseFromWrongPhaseIsIgnored() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        // Phase ist .untersuchen — No-Op erwartet.
        model.beginTeamAssignmentPhase()
        #expect(model.currentPhase == .untersuchen)
    }

    // MARK: - saveTeam — Speicherung

    @Test("Team .netzwerk kann in .teamZuordnen gespeichert werden")
    func teamNetzwerkCanBeSavedInTeamPhase() {
        let model = modelInTeamPhase()
        model.saveTeam(.netzwerk)
        #expect(model.selectedTeam == .netzwerk)
    }

    @Test("Team .konto kann in .teamZuordnen gespeichert werden")
    func teamKontoCanBeSavedInTeamPhase() {
        let model = modelInTeamPhase()
        model.saveTeam(.konto)
        #expect(model.selectedTeam == .konto)
    }

    @Test("Team .software kann in .teamZuordnen gespeichert werden")
    func teamSoftwareCanBeSavedInTeamPhase() {
        let model = modelInTeamPhase()
        model.saveTeam(.software)
        #expect(model.selectedTeam == .software)
    }

    @Test("Team .hardware kann in .teamZuordnen gespeichert werden")
    func teamHardwareCanBeSavedInTeamPhase() {
        let model = modelInTeamPhase()
        model.saveTeam(.hardware)
        #expect(model.selectedTeam == .hardware)
    }

    @Test("Teamdrop setzt isInputLocked auf true")
    func saveTeamSetsInputLock() {
        let model = modelInTeamPhase()
        #expect(model.isInputLocked == false)
        model.saveTeam(.software)
        #expect(model.isInputLocked == true)
    }

    @Test("Zweiter Teamspeicherversuch wird ignoriert (genau-einmal-Semantik)")
    func secondSaveTeamAttemptIsIgnored() {
        let model = modelInTeamPhase()
        model.saveTeam(.netzwerk)
        model.saveTeam(.konto)
        #expect(model.selectedTeam == .netzwerk)
    }

    @Test("Erstes gespeichertes Team wird durch weiteren Versuch nicht überschrieben")
    func firstTeamIsNotOverwritten() {
        let model = modelInTeamPhase()
        model.saveTeam(.hardware)
        model.saveTeam(.software)
        model.saveTeam(.netzwerk)
        #expect(model.selectedTeam == .hardware)
    }

    @Test("Speichern außerhalb .teamZuordnen wird ignoriert")
    func saveTeamOutsideTeamPhaseIsIgnored() {
        let model = SessionModel()
        // Phase: .start
        model.saveTeam(.netzwerk)
        #expect(model.selectedTeam == nil)

        // Phase: .untersuchen
        model.startSession(using: { $0 })
        model.saveTeam(.konto)
        #expect(model.selectedTeam == nil)

        // Phase: .priorisieren
        model.beginPrioritizationPhase()
        model.saveTeam(.software)
        #expect(model.selectedTeam == nil)
    }

    @Test("saveTeam verändert score nicht")
    func saveTeamDoesNotChangeScore() {
        let model = modelInTeamPhase()
        let scoreBefore = model.score
        model.saveTeam(.netzwerk)
        #expect(model.score == scoreBefore)
    }

    @Test("saveTeam verändert selectedPriority nicht")
    func saveTeamDoesNotChangePriority() {
        let model = modelInTeamPhase()
        // Priorität wurde in beginTeamPhase() gesetzt (.normal durch modelInTeamPhase)
        #expect(model.selectedPriority == .normal)
        model.saveTeam(.konto)
        #expect(model.selectedPriority == .normal)
    }

    @Test("saveTeam verändert currentTicketIndex nicht")
    func saveTeamDoesNotChangeTicketIndex() {
        let model = SessionModel()
        model.setTicketCount(3)
        model.startSession(using: { $0 })
        model.advanceToNextTicket()
        let indexBefore = model.currentTicketIndex
        model.beginPrioritizationPhase()
        model.savePriority(.wichtig)
        model.beginTeamAssignmentPhase()
        model.saveTeam(.software)
        #expect(model.currentTicketIndex == indexBefore)
    }

    @Test("Phase bleibt nach saveTeam .teamZuordnen (kein automatischer Übergang in Modul 009)")
    func saveTeamDoesNotChangePhase() {
        let model = modelInTeamPhase()
        model.saveTeam(.hardware)
        #expect(model.currentPhase == .teamZuordnen)
    }

    // MARK: - TeamTargetMapping — Struktur

    @Test("Genau vier Teamziele existieren")
    func exactlyFourTeamTargetsExist() {
        #expect(TeamTargetMapping.allTargets.count == 4)
    }

    @Test("Alle vier technischen Ziel-IDs sind eindeutig")
    func allFourTeamTargetIDsAreUnique() {
        let ids = TeamTargetMapping.allTargets.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test("Mapping deckt genau alle vier SupportTeam-Werte ab")
    func mappingCoversExactlyAllFourTeams() {
        let teams = Set(TeamTargetMapping.allTargets.map(\.team))
        #expect(teams == Set(SupportTeam.allCases))
    }

    @Test("Unbekannte Ziel-ID liefert kein Team")
    func mappingReturnsNilForUnknownID() {
        #expect(TeamTargetMapping.team(for: "unbekannt") == nil)
        #expect(TeamTargetMapping.team(for: "") == nil)
        #expect(TeamTargetMapping.team(for: "priority_normal") == nil)
    }

    @Test("Teamziel-Abstände sind größer als 2 × dropTargetRadius (keine Überschneidung)")
    func teamTargetPositionsDoNotOverlap() {
        let targets = TeamTargetMapping.allTargets
        let radius = InteractionConstants.dropTargetRadius
        for i in targets.indices {
            for j in targets.indices where j > i {
                let dist = simd_distance(targets[i].position, targets[j].position)
                #expect(
                    dist > 2 * radius,
                    "Ziele '\(targets[i].id)' und '\(targets[j].id)' überschneiden sich (Abstand \(dist) ≤ \(2*radius))"
                )
            }
        }
    }
}
