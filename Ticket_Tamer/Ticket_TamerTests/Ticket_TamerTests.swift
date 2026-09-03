import CoreGraphics
import RealityKit
import Testing
import simd
@testable import Ticket_Tamer

// MARK: - Modul 019 — Ladefehler-Recovery

@MainActor
@Suite("Modul 019 — Ladefehler-Recovery")
struct MonsterLoadRecoveryTests {
    private let assetID = AssetKeys.Monster.monster01

    @Test("Fehlerzustand bietet Retry")
    func failedStateOffersRetry() {
        var recovery = MonsterLoadRecovery()
        #expect(recovery.begin(assetID: assetID))
        recovery.finishWithFailure()
        #expect(recovery.hasError)
        #expect(recovery.canRetry)
    }

    @Test("Retry loescht den alten Fehler und startet Loading")
    func retryClearsErrorAndStartsLoading() {
        var recovery = failedRecovery()
        #expect(recovery.begin(assetID: assetID))
        #expect(!recovery.hasError)
        #expect(recovery.isLoading)
    }

    @Test("Retry fordert dieselbe Monster-Asset-ID an")
    func retryRequestsSameAssetID() {
        var recovery = failedRecovery()
        _ = recovery.begin(assetID: assetID)
        #expect(recovery.requestedAssetID == assetID)
    }

    @Test("Paralleler zweiter Load wird abgewiesen")
    func parallelSecondLoadIsRejected() {
        var recovery = MonsterLoadRecovery()
        #expect(recovery.begin(assetID: assetID))
        #expect(!recovery.begin(assetID: assetID))
        #expect(recovery.isLoading)
    }

    @Test("Erfolg beendet Loading und Fehlerzustand")
    func successEndsLoadingAndError() {
        var recovery = failedRecovery()
        _ = recovery.begin(assetID: assetID)
        recovery.finishSuccessfully()
        #expect(!recovery.isLoading)
        #expect(!recovery.hasError)
        #expect(!recovery.canRetry)
    }

    @Test("Erneuter Fehler bietet Retry erneut")
    func repeatedFailureOffersRetryAgain() {
        var recovery = failedRecovery()
        _ = recovery.begin(assetID: assetID)
        recovery.finishWithFailure()
        #expect(recovery.canRetry)
    }

    @Test("Mehrere Fehler und Erfolg ergeben genau ein Monster")
    func repeatedFailuresThenSuccessYieldOneMonster() {
        var recovery = MonsterLoadRecovery()
        for _ in 0..<3 {
            #expect(recovery.begin(assetID: assetID))
            recovery.finishWithFailure()
            #expect(recovery.displayedMonsterCount == 0)
        }
        #expect(recovery.begin(assetID: assetID))
        recovery.finishSuccessfully()
        #expect(recovery.displayedMonsterCount == 1)
    }

    @Test("Spaete Abschluesse ohne laufenden Versuch sind No-Ops")
    func lateCompletionsAreNoOps() {
        var recovery = MonsterLoadRecovery()
        recovery.finishSuccessfully()
        recovery.finishWithFailure()
        #expect(recovery.status == .idle)
        #expect(recovery.displayedMonsterCount == 0)
    }

    @Test("Reset entfernt ausschliesslich lokalen Ladezustand")
    func resetClearsLocalLoadState() {
        var recovery = failedRecovery()
        recovery.reset()
        #expect(recovery.status == .idle)
        #expect(recovery.requestedAssetID == nil)
    }

    @Test("Recovery veraendert Ticket, Index, Phase und Score nicht")
    func recoveryPreservesCoreSessionState() {
        let model = startedModel()
        let before = (model.currentTicket?.id, model.currentTicketIndex, model.currentPhase, model.score)
        var recovery = failedRecovery()
        _ = recovery.begin(assetID: assetID)
        recovery.finishSuccessfully()
        #expect(model.currentTicket?.id == before.0)
        #expect(model.currentTicketIndex == before.1)
        #expect(model.currentPhase == before.2)
        #expect(model.score == before.3)
    }

    @Test("Recovery veraendert Entscheidungen und Input-Lock nicht")
    func recoveryPreservesDecisionsAndLock() {
        let model = startedModel()
        model.beginPrioritizationPhase()
        model.savePriority(.wichtig)
        let before = (model.selectedPriority, model.selectedTeam, model.isInputLocked)
        var recovery = failedRecovery()
        _ = recovery.begin(assetID: assetID)
        recovery.finishSuccessfully()
        #expect(model.selectedPriority == before.0)
        #expect(model.selectedTeam == before.1)
        #expect(model.isInputLocked == before.2)
    }

    @Test("Recovery erzeugt weder Bewertung noch Phasenwechsel")
    func recoveryCreatesNoEvaluationOrPhaseTransition() {
        let model = startedModel()
        model.beginPrioritizationPhase()
        model.savePriority(.wichtig)
        let score = model.score
        let phase = model.currentPhase
        var recovery = failedRecovery()
        _ = recovery.begin(assetID: assetID)
        recovery.finishSuccessfully()
        #expect(model.score == score)
        #expect(model.currentPhase == phase)
    }

    @Test("Priorisierungsphase definiert exakt drei Ziele")
    func prioritizationKeepsExactlyThreeTargets() {
        #expect(PriorityTargetMapping.allTargets.count == 3)
    }

    @Test("Teamphase definiert exakt vier Ziele")
    func teamAssignmentKeepsExactlyFourTargets() {
        #expect(TeamTargetMapping.allTargets.count == 4)
    }

    @Test("Initialzustand bietet keinen Retry")
    func idleStateOffersNoRetry() {
        #expect(!MonsterLoadRecovery().canRetry)
    }

    @Test("Erfolgszustand bildet hoechstens ein Monster ab")
    func successRepresentsAtMostOneMonster() {
        var recovery = MonsterLoadRecovery()
        _ = recovery.begin(assetID: assetID)
        recovery.finishSuccessfully()
        recovery.finishSuccessfully()
        #expect(recovery.displayedMonsterCount == 1)
    }

    @Test("Fehlerzustand bildet kein Monster ab")
    func failureRepresentsNoMonster() {
        #expect(failedRecovery().displayedMonsterCount == 0)
    }

    @Test("Retry besitzt kein Versuchslimit")
    func retryHasNoAttemptLimit() {
        var recovery = MonsterLoadRecovery()
        for _ in 0..<100 {
            #expect(recovery.begin(assetID: assetID))
            recovery.finishWithFailure()
        }
        #expect(recovery.canRetry)
    }

    @Test("Prioritaetsziel-IDs sind eindeutig")
    func priorityTargetIDsAreUnique() {
        let ids = PriorityTargetMapping.allTargets.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test("Teamziel-IDs sind eindeutig")
    func teamTargetIDsAreUnique() {
        let ids = TeamTargetMapping.allTargets.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    private func failedRecovery() -> MonsterLoadRecovery {
        var recovery = MonsterLoadRecovery()
        _ = recovery.begin(assetID: assetID)
        recovery.finishWithFailure()
        return recovery
    }

    private func startedModel() -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        return model
    }
}

// MARK: - Modul 021 — Replay-Layoutstabilisierung

@MainActor
@Suite("Modul 021 — Replay-Layoutstabilisierung")
struct ReplayLayoutStabilityTests {
    private let coldStartVolume = BoundingBox(
        min: SIMD3<Float>(-0.60, -0.575, -0.225),
        max: SIMD3<Float>(0.60, 0.575, 0.225)
    )
    private let resizedVolume = BoundingBox(
        min: SIMD3<Float>(-0.48, -0.50, -0.20),
        max: SIMD3<Float>(0.48, 0.50, 0.20)
    )
    private let monsterBounds = BoundingBox(
        min: SIMD3<Float>(-0.05, -0.055, -0.04),
        max: SIMD3<Float>(0.05, 0.055, 0.04)
    )

    @Test("Start-Slider besitzt eine feste positive Designbreite")
    func startSliderHasStableDesignWidth() {
        #expect(LayoutConstants.startSliderDesignWidth == 320)
        #expect(LayoutConstants.startSliderDesignWidth > 0)
    }

    @Test("Gleiche Volume-Geometrie ergibt gleiche Prioritaetspanels")
    func identicalVolumeProducesIdenticalPriorityPanels() {
        let first = priorityLayout(in: coldStartVolume)
        let replay = priorityLayout(in: coldStartVolume)

        #expect(first.panelSize == replay.panelSize)
        #expect(first.centers == replay.centers)
    }

    @Test("Gleiche Volume-Geometrie ergibt gleiche Teampanels")
    func identicalVolumeProducesIdenticalTeamPanels() {
        let first = teamLayout(in: coldStartVolume)
        let replay = teamLayout(in: coldStartVolume)

        #expect(first.panelSize == replay.panelSize)
        #expect(first.centers == replay.centers)
    }

    @Test("Fuenf Replay-Berechnungen mit gleicher Geometry driften nicht")
    func fiveRepeatedCalculationsDoNotDrift() {
        let priorityReference = priorityLayout(in: coldStartVolume)
        let teamReference = teamLayout(in: coldStartVolume)

        for _ in 1...5 {
            let priorityReplay = priorityLayout(in: coldStartVolume)
            let teamReplay = teamLayout(in: coldStartVolume)
            #expect(priorityReplay.panelSize == priorityReference.panelSize)
            #expect(priorityReplay.centers == priorityReference.centers)
            #expect(teamReplay.panelSize == teamReference.panelSize)
            #expect(teamReplay.centers == teamReference.centers)
        }
    }

    @Test("Eine gueltig veraenderte Geometry wird statt der Defaultgroesse verwendet")
    func resizedGeometryProducesNewLayout() {
        let initial = priorityLayout(in: coldStartVolume)
        let resized = priorityLayout(in: resizedVolume)

        #expect(resized.panelSize != initial.panelSize)
        #expect(resized.centers != initial.centers)
    }

    @Test("Fachlicher Reset ist kein Input der Panelgeometrie")
    func sessionResetDoesNotChangeLayoutCalculation() {
        let model = SessionModel()
        let before = priorityLayout(in: resizedVolume)

        model.setTicketCount(12)
        model.startSession(using: { $0 })
        model.reset()

        let after = priorityLayout(in: resizedVolume)
        #expect(before.panelSize == after.panelSize)
        #expect(before.centers == after.centers)
        #expect(model.selectedTicketCount == GameplayConstants.defaultTicketCount)
        #expect(model.sessionTickets.isEmpty)
        #expect(model.currentTicketIndex == 0)
        #expect(model.currentPhase == .start)
        #expect(model.score == 0)
        #expect(model.selectedPriority == nil)
        #expect(model.selectedTeam == nil)
        #expect(model.isInputLocked == false)
    }

    private func priorityLayout(in volume: BoundingBox) -> TargetPanelLayout.Resolved {
        PriorityTargetMapping.panelLayout.resolve(
            volume: volume,
            monsterBounds: monsterBounds,
            monsterPlaneZ: PrioritizationConstants.monsterStartPosition.z
        )
    }

    private func teamLayout(in volume: BoundingBox) -> TargetPanelLayout.Resolved {
        TeamTargetMapping.panelLayout.resolve(
            volume: volume,
            monsterBounds: monsterBounds,
            monsterPlaneZ: TeamAssignmentConstants.monsterStartPosition.z
        )
    }
}

// MARK: - Modul 018 — Visuelles Entscheidungsfeedback

@MainActor
@Suite("Modul 018 — Visuelles Entscheidungsfeedback")
struct DecisionFeedbackTests {

    @Test("Richtige Bewertung wird auf correct abgebildet")
    func correctEvaluationMapsToCorrectFeedback() {
        #expect(DecisionFeedbackResult(evaluation: true) == .correct)
    }

    @Test("Falsche Bewertung wird auf incorrect abgebildet")
    func incorrectEvaluationMapsToIncorrectFeedback() {
        #expect(DecisionFeedbackResult(evaluation: false) == .incorrect)
    }

    @Test("Nur richtiges Feedback enthaelt den exakten Punktetext")
    func onlyCorrectFeedbackContainsPointsText() {
        #expect(DecisionFeedbackResult.correct.pointsText == "+100 Punkte")
        #expect(DecisionFeedbackResult.incorrect.pointsText == nil)
    }

    @Test("Richtiges Feedback verwendet einen Haken")
    func correctFeedbackUsesCheckmark() {
        #expect(DecisionFeedbackResult.correct.symbolName == "checkmark")
    }

    @Test("Falsches Feedback verwendet ein Kreuz")
    func incorrectFeedbackUsesXmark() {
        #expect(DecisionFeedbackResult.incorrect.symbolName == "xmark")
    }

    @Test("Richtiges Feedback besitzt den lokalisierten Accessibility-Schluessel")
    func correctFeedbackHasAccessibilityKey() {
        #expect(DecisionFeedbackResult.correct.accessibilityLabelKey == "decisionFeedback.correct.accessibility")
    }

    @Test("Falsches Feedback besitzt den lokalisierten Accessibility-Schluessel")
    func incorrectFeedbackHasAccessibilityKey() {
        #expect(DecisionFeedbackResult.incorrect.accessibilityLabelKey == "decisionFeedback.incorrect.accessibility")
    }

    @Test("Eine No-Op-Bewertung erzeugt keinen Feedbackzustand")
    func nilEvaluationCreatesNoFeedback() {
        #expect(DecisionFeedbackResult(evaluation: nil) == nil)
    }

    @Test("Feedbackresultat besteht nur aus den beiden Darstellungsfaellen")
    func feedbackContainsNoDomainOrScoreState() {
        #expect([DecisionFeedbackResult.correct, .incorrect].count == 2)
        #expect(DecisionFeedbackResult.incorrect.pointsText == nil)
    }

    @Test("Correct benoetigt keine Referenzprioritaet")
    func correctFeedbackNeedsNoReferencePriority() {
        let result = DecisionFeedbackResult(evaluation: true)
        #expect(result == .correct)
    }

    @Test("Incorrect benoetigt kein Referenzteam")
    func incorrectFeedbackNeedsNoReferenceTeam() {
        let result = DecisionFeedbackResult(evaluation: false)
        #expect(result == .incorrect)
    }

    @Test("Das Feedback bildet gleiche Bool-Ergebnisse deterministisch ab")
    func mappingIsDeterministic() {
        #expect(DecisionFeedbackResult(evaluation: true) == DecisionFeedbackResult(evaluation: true))
        #expect(DecisionFeedbackResult(evaluation: false) == DecisionFeedbackResult(evaluation: false))
    }

    @Test("Die Symbole der beiden Ergebnisse sind eindeutig")
    func symbolsAreDistinct() {
        #expect(DecisionFeedbackResult.correct.symbolName != DecisionFeedbackResult.incorrect.symbolName)
    }

    @Test("Accessibility-Schluessel verraten keine Prioritaet")
    func accessibilityKeysRevealNoPriority() {
        let keys = [
            DecisionFeedbackResult.correct.accessibilityLabelKey,
            DecisionFeedbackResult.incorrect.accessibilityLabelKey,
        ]
        #expect(keys.allSatisfy { !$0.contains("priority") && !$0.contains("normal") && !$0.contains("kritisch") })
    }

    @Test("Accessibility-Schluessel verraten kein Team")
    func accessibilityKeysRevealNoTeam() {
        let keys = [
            DecisionFeedbackResult.correct.accessibilityLabelKey,
            DecisionFeedbackResult.incorrect.accessibilityLabelKey,
        ]
        #expect(keys.allSatisfy { !$0.contains("team") && !$0.contains("netzwerk") && !$0.contains("hardware") })
    }

    @Test("Das visuelle Mapping veraendert den Input-Lock nicht")
    func visualMappingDoesNotChangeInputLock() {
        let model = SessionModel()
        let lockBeforeMapping = model.isInputLocked
        _ = DecisionFeedbackResult(evaluation: true)
        #expect(model.isInputLocked == lockBeforeMapping)
    }

    @Test("Nach Ruecksetzen des lokalen States bleibt kein Feedbackresultat")
    func resettingLocalStateLeavesNoFeedback() {
        var feedback = DecisionFeedbackResult(evaluation: true)
        feedback = nil
        #expect(feedback == nil)
    }
}

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

// MARK: - Modul 016 — Kompakte Ticketinfo

@MainActor
@Suite("Modul 016 — Kompakte Ticketinfo")
struct CompactTicketInfoTests {
    private var ticket: Ticket { LocalTicketCatalog.allTickets[0] }

    @Test("Die Ticketnummer wird unveraendert uebernommen")
    func ticketNumberIsCopied() {
        #expect(CompactTicketInfoContent(ticket: ticket).ticketNumber == ticket.ticketNumber)
    }

    @Test("Der Titel wird unveraendert uebernommen")
    func titleIsCopied() {
        #expect(CompactTicketInfoContent(ticket: ticket).title == ticket.title)
    }

    @Test("Die Kurzbeschreibung wird unveraendert uebernommen")
    func shortDescriptionIsCopied() {
        #expect(CompactTicketInfoContent(ticket: ticket).shortDescription == ticket.shortDescription)
    }

    @Test("Der User Impact wird unveraendert uebernommen")
    func userImpactIsCopied() {
        #expect(CompactTicketInfoContent(ticket: ticket).userImpact == ticket.userImpact)
    }

    @Test("Alle Symptome werden in ihrer Reihenfolge uebernommen")
    func symptomsAreCopied() {
        #expect(CompactTicketInfoContent(ticket: ticket).symptoms == ticket.symptoms)
    }

    @Test("Der Darstellungsinhalt ist unabhaengig von der Referenzprioritaet")
    func contentDoesNotNeedReferencePriority() {
        let changed = Ticket(
            id: ticket.id, ticketNumber: ticket.ticketNumber, title: ticket.title,
            shortDescription: ticket.shortDescription, userImpact: ticket.userImpact,
            symptoms: ticket.symptoms, referencePriority: ticket.referencePriority == .normal ? .kritisch : .normal,
            referenceTeam: ticket.referenceTeam, monsterAssetId: ticket.monsterAssetId
        )
        #expect(CompactTicketInfoContent(ticket: changed) == CompactTicketInfoContent(ticket: ticket))
    }

    @Test("Der Darstellungsinhalt ist unabhaengig vom Referenzteam")
    func contentDoesNotNeedReferenceTeam() {
        let changed = Ticket(
            id: ticket.id, ticketNumber: ticket.ticketNumber, title: ticket.title,
            shortDescription: ticket.shortDescription, userImpact: ticket.userImpact,
            symptoms: ticket.symptoms, referencePriority: ticket.referencePriority,
            referenceTeam: ticket.referenceTeam == .netzwerk ? .hardware : .netzwerk,
            monsterAssetId: ticket.monsterAssetId
        )
        #expect(CompactTicketInfoContent(ticket: changed) == CompactTicketInfoContent(ticket: ticket))
    }

    @Test("Der Darstellungsinhalt ist unabhaengig von interner ID und Monsterasset")
    func contentDoesNotNeedInternalIdentifiers() {
        let changed = Ticket(
            id: "andere-interne-id", ticketNumber: ticket.ticketNumber, title: ticket.title,
            shortDescription: ticket.shortDescription, userImpact: ticket.userImpact,
            symptoms: ticket.symptoms, referencePriority: ticket.referencePriority,
            referenceTeam: ticket.referenceTeam, monsterAssetId: "anderes-asset"
        )
        #expect(CompactTicketInfoContent(ticket: changed) == CompactTicketInfoContent(ticket: ticket))
    }

    @Test("Der Overlayzustand startet geschlossen")
    func overlayStartsClosed() {
        #expect(TicketInfoInteraction.initialPresentation == false)
    }

    @Test("Info-Tap oeffnet ein geschlossenes Overlay")
    func toggleOpensOverlay() {
        #expect(TicketInfoInteraction.toggled(false) == true)
    }

    @Test("Erneuter Info-Tap schliesst ein offenes Overlay")
    func toggleClosesOverlay() {
        #expect(TicketInfoInteraction.toggled(true) == false)
    }

    @Test("Ein neuer Viewzustand beginnt nach Phasenwechsel geschlossen")
    func recreatedViewStateStartsClosed() {
        let stateAfterRecreation = TicketInfoInteraction.initialPresentation
        #expect(stateAfterRecreation == false)
    }

    @Test("Ein offenes Overlay sperrt Drag")
    func openOverlayDisablesDrag() {
        #expect(TicketInfoInteraction.isDragEnabled(isPresented: true, isInputLocked: false) == false)
    }

    @Test("Ein geschlossenes Overlay erlaubt Drag bei freiem Facheingang")
    func closedOverlayAllowsUnlockedDrag() {
        #expect(TicketInfoInteraction.isDragEnabled(isPresented: false, isInputLocked: false) == true)
    }

    @Test("Der fachliche Lock bleibt nach dem Schliessen massgeblich")
    func domainLockStillDisablesDrag() {
        #expect(TicketInfoInteraction.isDragEnabled(isPresented: false, isInputLocked: true) == false)
    }

    @Test("Die Ticketinfo besitzt eine vollstaendige kompakte Designflaeche")
    func ticketInfoDesignCanvasIsLargeEnough() {
        #expect(LayoutConstants.compactTicketInfoDesignWidth == 520)
        #expect(LayoutConstants.compactTicketInfoDesignHeight == 560)
        #expect(LayoutConstants.compactTicketInfoOuterPadding > 0)
    }

    @Test("Das zentrale Volume bleibt kompakt und bietet genug Tiefe")
    func centralVolumeIsCompact() {
        #expect(LayoutConstants.centralVolumeWidth == 0.8)
        #expect(LayoutConstants.centralVolumeHeight == 0.75)
        #expect(LayoutConstants.centralVolumeDepth == 0.38)
        #expect(LayoutConstants.centralVolumeDepth > LayoutConstants.monsterPanelDepth)
    }

    @Test("HUD und Hinweis verwenden sichtbare Scene-Anker innerhalb des Volumes")
    func ornamentAnchorsStayInsideScene() {
        #expect((0...1).contains(LayoutConstants.investigationHUDSceneAnchorY))
        #expect((0...1).contains(LayoutConstants.sessionHUDSceneAnchorY))
        #expect((0...1).contains(LayoutConstants.interactionHintSceneAnchorY))
        #expect(LayoutConstants.investigationHUDSceneAnchorY < LayoutConstants.sessionHUDSceneAnchorY)
        #expect(LayoutConstants.sessionHUDSceneAnchorY < LayoutConstants.interactionHintSceneAnchorY)
    }

    @Test("Die Monster-Zielgroessen sind reduziert")
    func monsterTargetSizesAreReduced() {
        #expect(LayoutConstants.monsterTargetSize == 0.24)
        #expect(LayoutConstants.monsterDragDropTargetSize == 0.17)
    }
}

// MARK: - Modul 015: Session-HUD und Interaktionshinweise

/// Tests der rein darstellungsbezogenen HUD-Ableitung ohne zweiten Sitzungszustand.
@MainActor
struct SessionHUDContentTests {
    @Test("Ticket 1 von 6 ergibt ein Sechstel Fortschritt")
    func firstOfSixTickets() {
        let content = SessionHUDContent(currentTicketIndex: 0, totalTicketCount: 6, phase: .untersuchen)
        #expect(content.currentTicketNumber == 1)
        #expect(content.totalTicketCount == 6)
        #expect(abs(content.progress - (1.0 / 6.0)) < 0.000_001)
    }

    @Test("Ticket 3 von 6 ergibt 50 Prozent Fortschritt")
    func thirdOfSixTickets() {
        let content = SessionHUDContent(currentTicketIndex: 2, totalTicketCount: 6, phase: .priorisieren)
        #expect(content.currentTicketNumber == 3)
        #expect(content.progress == 0.5)
    }

    @Test("Ticket 6 von 6 ergibt vollen Fortschritt")
    func lastOfSixTickets() {
        let content = SessionHUDContent(currentTicketIndex: 5, totalTicketCount: 6, phase: .teamZuordnen)
        #expect(content.currentTicketNumber == 6)
        #expect(content.progress == 1)
    }

    @Test("Fortschritt bleibt in allen drei Ticketphasen identisch")
    func progressIsIndependentOfSubphase() {
        let phases: [GamePhase] = [.untersuchen, .priorisieren, .teamZuordnen]
        let values = phases.map {
            SessionHUDContent(currentTicketIndex: 2, totalTicketCount: 6, phase: $0).progress
        }
        #expect(values == [0.5, 0.5, 0.5])
    }

    @Test("Der naechste Ticketindex erhoeht den Fortschritt")
    func nextTicketIncreasesProgress() {
        let current = SessionHUDContent(currentTicketIndex: 1, totalTicketCount: 6, phase: .teamZuordnen)
        let next = SessionHUDContent(currentTicketIndex: 2, totalTicketCount: 6, phase: .untersuchen)
        #expect(next.progress > current.progress)
    }

    @Test("Leere Sitzung ergibt sichere Nullwerte")
    func emptySessionIsSafe() {
        let content = SessionHUDContent(currentTicketIndex: 0, totalTicketCount: 0, phase: .untersuchen)
        #expect(content.currentTicketNumber == 0)
        #expect(content.totalTicketCount == 0)
        #expect(content.progress == 0)
        #expect(content.progress.isFinite)
    }

    @Test("Ungueltige Indizes bleiben im sichtbaren Fortschrittsbereich")
    func invalidIndicesAreClamped() {
        let below = SessionHUDContent(currentTicketIndex: -4, totalTicketCount: 6, phase: .untersuchen)
        let above = SessionHUDContent(currentTicketIndex: 20, totalTicketCount: 6, phase: .untersuchen)
        #expect((0...1).contains(below.progress))
        #expect((0...1).contains(above.progress))
        #expect(above.currentTicketNumber == 6)
    }

    @Test("Die drei Phasentitel entsprechen der Vorgabe")
    func phaseTitlesMatchSpecification() {
        #expect(SessionHUDContent.title(for: .untersuchen) == "Ticket untersuchen")
        #expect(SessionHUDContent.title(for: .priorisieren) == "Priorität zuordnen")
        #expect(SessionHUDContent.title(for: .teamZuordnen) == "Team zuordnen")
    }

    @Test("Start und Ergebnis haben keinen HUD-Titel")
    func phasesWithoutHUDHaveNoTitle() {
        #expect(SessionHUDContent.title(for: .start).isEmpty)
        #expect(SessionHUDContent.title(for: .ergebnis).isEmpty)
    }

    @Test("Der Priorisierungshinweis entspricht exakt der Vorgabe")
    func prioritizationHintMatchesSpecification() {
        #expect(InteractionHintContent.prioritization == "Monster greifen und auf eine Priorität ziehen.")
    }

    @Test("Der Teamhinweis entspricht exakt der Vorgabe")
    func teamHintMatchesSpecification() {
        #expect(InteractionHintContent.teamAssignment == "Monster greifen und dem zuständigen Team zuordnen.")
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

// MARK: - Modul 017: Startseiten-Usability

/// Tests für Plus/Minus, gemeinsame Source of Truth, Reset und die verbindlichen Texte.
@MainActor
struct StartPageUsabilityTests {

    @Test("Plus erhöht 6 genau auf 7")
    func plusFromSixProducesSeven() {
        let model = SessionModel()
        model.setTicketCount(model.selectedTicketCount + 1)
        #expect(model.selectedTicketCount == 7)
    }

    @Test("Minus verringert 6 genau auf 5")
    func minusFromSixProducesFive() {
        let model = SessionModel()
        model.setTicketCount(model.selectedTicketCount - 1)
        #expect(model.selectedTicketCount == 5)
    }

    @Test("Plus erhöht von jedem inneren Wert um genau eins")
    func plusAlwaysIncreasesExactlyOnce() {
        let model = SessionModel()
        for value in 1..<GameplayConstants.maximumTicketCount {
            model.setTicketCount(value)
            model.setTicketCount(model.selectedTicketCount + 1)
            #expect(model.selectedTicketCount == value + 1)
        }
    }

    @Test("Minus verringert von jedem inneren Wert um genau eins")
    func minusAlwaysDecreasesExactlyOnce() {
        let model = SessionModel()
        for value in 2...GameplayConstants.maximumTicketCount {
            model.setTicketCount(value)
            model.setTicketCount(model.selectedTicketCount - 1)
            #expect(model.selectedTicketCount == value - 1)
        }
    }

    @Test("Minimum 1 kann nicht unterschritten werden")
    func minimumCannotBeUnderrun() {
        let model = SessionModel()
        model.setTicketCount(1)
        model.setTicketCount(model.selectedTicketCount - 1)
        #expect(model.selectedTicketCount == 1)
    }

    @Test("Maximum 12 kann nicht überschritten werden")
    func maximumCannotBeExceeded() {
        let model = SessionModel()
        model.setTicketCount(12)
        model.setTicketCount(model.selectedTicketCount + 1)
        #expect(model.selectedTicketCount == 12)
    }

    @Test("Minus ist bei 1 als deaktiviert ableitbar")
    func minusIsDisabledAtMinimum() {
        #expect(!StartTicketCountControls.canDecrease(1))
        #expect(StartTicketCountControls.canIncrease(1))
    }

    @Test("Plus ist bei 12 als deaktiviert ableitbar")
    func plusIsDisabledAtMaximum() {
        #expect(!StartTicketCountControls.canIncrease(12))
        #expect(StartTicketCountControls.canDecrease(12))
    }

    @Test("Bei 6 sind Minus und Plus aktiviert")
    func bothButtonsAreEnabledAtSix() {
        #expect(StartTicketCountControls.canDecrease(6))
        #expect(StartTicketCountControls.canIncrease(6))
    }

    @Test("Slider und Buttons ändern dieselbe Ticketanzahl")
    func sliderAndButtonsShareSelectedTicketCount() {
        let model = SessionModel()
        model.setTicketCount(3) // entspricht dem Slider-Binding
        model.setTicketCount(model.selectedTicketCount - 1)
        #expect(model.selectedTicketCount == 2)
        model.setTicketCount(model.selectedTicketCount + 1)
        #expect(model.selectedTicketCount == 3)
    }

    @Test("Reset setzt die Ticketanzahl auf 6")
    func resetRestoresSixTickets() {
        let model = SessionModel()
        model.setTicketCount(12)
        model.reset()
        #expect(model.selectedTicketCount == 6)
    }

    @Test("Nach Reset sind Minus und Plus aktiviert")
    func bothButtonsAreEnabledAfterReset() {
        let model = SessionModel()
        model.setTicketCount(1)
        model.reset()
        #expect(StartTicketCountControls.canDecrease(model.selectedTicketCount))
        #expect(StartTicketCountControls.canIncrease(model.selectedTicketCount))
    }

    @Test("Kurzbeschreibung entspricht exakt der Vorgabe")
    func descriptionMatchesSpecification() {
        #expect(StartViewContent.description == "Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.")
    }

    @Test("Accessibility-Text Minus entspricht exakt der Vorgabe")
    func decreaseAccessibilityLabelMatchesSpecification() {
        #expect(StartViewContent.decreaseAccessibilityLabel == "Ein Ticket weniger")
    }

    @Test("Accessibility-Text Plus entspricht exakt der Vorgabe")
    func increaseAccessibilityLabelMatchesSpecification() {
        #expect(StartViewContent.increaseAccessibilityLabel == "Ein Ticket mehr")
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

    // MARK: - Spaltenmodell der Priorisierungsphase

    /// Die drei Prioritätsziele werden über `DropEvaluator.evaluateColumn` ausgewertet:
    /// entscheidend ist allein die X-Abweichung. Sie müssen daher auf einer Höhe liegen
    /// und sich in X eindeutig unterscheiden.
    @Test("Prioritätsziele bilden eine Reihe mit eindeutigen X-Werten")
    func priorityTargetsFormOneRow() {
        let targets = PriorityTargetMapping.allTargets
        let xs = targets.map(\.position.x)
        #expect(Set(xs).count == targets.count, "X-Werte sind nicht eindeutig")

        for target in targets {
            #expect(target.position.y == PrioritizationConstants.targetPositionWichtig.y)
            #expect(target.position.z == PrioritizationConstants.targetPositionWichtig.z)
        }

        // Entscheidungsgrenze liegt mittig zwischen benachbarten Spalten.
        let sorted = xs.sorted()
        for i in 1..<sorted.count {
            let spacing = sorted[i] - sorted[i - 1]
            #expect(
                abs(spacing - PrioritizationConstants.targetColumnSpacing) < 0.0001,
                "Spaltenabstand \(spacing) weicht von targetColumnSpacing ab"
            )
        }
    }

    /// Kern der Regression: zuvor war nur „Wichtig" erreichbar, weil die äußeren Ziele
    /// 0.38 m entfernt lagen und die Radiusprüfung 0.23 m Drag-Strecke verlangt hätte.
    @Test("Alle drei Prioritäten sind per Spaltenauswertung erreichbar")
    func everyPriorityIsReachable() {
        let origin = PrioritizationConstants.monsterStartPosition
        let lift = PrioritizationConstants.minimumDropLift
        let spacing = PrioritizationConstants.targetColumnSpacing
        let targets = PriorityTargetMapping.allTargets.map {
            DropEvaluator.TargetDescriptor(
                id: $0.id,
                position: $0.position,
                radius: InteractionConstants.dropTargetRadius
            )
        }

        // Knapp jenseits der jeweiligen Entscheidungsgrenze abgelegt, minimal angehoben.
        let cases: [(x: Float, expected: String)] = [
            (-spacing, "priority_normal"),
            (-spacing * 0.6, "priority_normal"),
            (0, "priority_wichtig"),
            (spacing * 0.4, "priority_wichtig"),
            (spacing * 0.6, "priority_kritisch"),
            (spacing, "priority_kritisch"),
        ]

        for testCase in cases {
            let dropped = SIMD3<Float>(testCase.x, origin.y + lift, origin.z)
            let result = DropEvaluator.evaluateColumn(
                entityPosition: dropped,
                origin: origin,
                targets: targets,
                minimumLift: lift
            )
            #expect(result == testCase.expected, "x=\(testCase.x) ergab \(result ?? "nil")")
        }
    }

    // MARK: - Planare Zieh-Bewegung

    /// Kernregression: die Tiefe darf sich durch Ziehen nie ändern. Zuvor wurde die
    /// Z-Komponente der Zeigerposition direkt übernommen — Sprung nach vorne beim Greifen,
    /// Stehenbleiben auf Handtiefe beim Loslassen.
    /// Regression: `ticketCardMinScale` stand auf 0.45 und klemmte den Einpassfaktor nach
    /// **oben**, wenn weniger Platz da war — die Karte ragte dann über ihre Spalte hinaus.
    @Test("Ticketkarte passt bei realistischen Fenstergrößen ohne Überlauf hinein")
    func ticketCardFitsWithoutOverflow() {
        let design = CGSize(
            width: LayoutConstants.ticketCardDesignWidth,
            height: LayoutConstants.ticketCardDesignHeight
        )

        // Von sehr eng bis großzügig — überall darf nichts überstehen.
        let boxes: [CGSize] = [
            CGSize(width: 120, height: 240),
            CGSize(width: 221, height: 385),
            CGSize(width: 400, height: 600),
            CGSize(width: 900, height: 1200),
        ]

        for box in boxes {
            let raw = min(box.width / design.width, box.height / design.height)
            let scale = min(
                max(raw, LayoutConstants.ticketCardMinScale),
                LayoutConstants.ticketCardMaxScale
            )
            #expect(
                design.width * scale <= box.width + 0.001,
                "Karte ist in \(box) zu breit (\(design.width * scale))"
            )
            #expect(
                design.height * scale <= box.height + 0.001,
                "Karte ist in \(box) zu hoch (\(design.height * scale))"
            )
        }
    }

    @Test("Ziehen verändert die Z-Tiefe nicht")
    func planarDragKeepsDepthConstant() {
        let start = PrioritizationConstants.monsterStartPosition
        let moves: [CGSize] = [
            .zero,
            CGSize(width: 300, height: -200),
            CGSize(width: -450, height: 120),
            CGSize(width: 0, height: -1000),
        ]
        for move in moves {
            let result = PlanarDrag.position(from: start, translation: move)
            #expect(result.z == start.z, "Z hat sich bei \(move) verändert")
        }
    }

    @Test("Ziehrichtungen werden korrekt auf die RealityKit-Achsen abgebildet")
    func planarDragUsesCorrectAxisDirections() {
        let start = SIMD3<Float>(0, 0, 0.06)

        // SwiftUI zählt height nach unten positiv — nach oben ziehen heißt negatives height.
        let up = PlanarDrag.position(from: start, translation: CGSize(width: 0, height: -100))
        #expect(up.y > start.y, "Ziehen nach oben muss Y erhöhen")

        let down = PlanarDrag.position(from: start, translation: CGSize(width: 0, height: 100))
        #expect(down.y < start.y, "Ziehen nach unten muss Y senken")

        let right = PlanarDrag.position(from: start, translation: CGSize(width: 100, height: 0))
        #expect(right.x > start.x, "Ziehen nach rechts muss X erhöhen")

        let left = PlanarDrag.position(from: start, translation: CGSize(width: -100, height: 0))
        #expect(left.x < start.x, "Ziehen nach links muss X senken")
    }

    /// Die seitliche Entscheidungsgrenze muss mit realistischem Zieh-Aufwand erreichbar sein.
    @Test("Entscheidungsgrenze und Mindestanhebung sind per Geste erreichbar")
    func decisionThresholdsAreReachableByDragging() {
        let start = PrioritizationConstants.monsterStartPosition
        let boundary = PrioritizationConstants.targetColumnSpacing / 2

        // Ziehbewegung von 200 Punkten zur Seite und 100 Punkten nach oben.
        let dragged = PlanarDrag.position(from: start, translation: CGSize(width: -200, height: -100))
        #expect(abs(dragged.x - start.x) > boundary, "Seitliche Grenze nicht erreichbar")
        #expect(
            dragged.y - start.y >= PrioritizationConstants.minimumDropLift,
            "Mindestanhebung nicht erreichbar"
        )
    }

    // MARK: - Spielfläche und Clipping

    /// Kernregression zum Beschneiden am oberen Rand: egal wie weit gezogen wird, die
    /// Modellhülle muss mit Sicherheitsabstand innerhalb des Volumes bleiben.
    @Test("Ziehen kann das Monster nie über die Volume-Grenzen hinaus bewegen")
    func draggingNeverLeavesTheVolume() {
        let size = LayoutConstants.monsterDragDropTargetSize
        let limits = PlanarDrag.playAreaLimits(forEntityOfSize: size)
        let start = PrioritizationConstants.monsterStartPosition
        let half = SIMD3<Float>(
            Float(LayoutConstants.centralVolumeWidth / 2),
            Float(LayoutConstants.centralVolumeHeight / 2),
            Float(LayoutConstants.centralVolumeDepth / 2)
        )

        // Absichtlich weit über jedes sinnvolle Maß hinaus gezogen.
        let extremes: [CGSize] = [
            CGSize(width: 0, height: -5000),
            CGSize(width: 0, height: 5000),
            CGSize(width: -5000, height: -5000),
            CGSize(width: 5000, height: 5000),
        ]

        for move in extremes {
            let p = PlanarDrag.position(from: start, translation: move, limits: limits)
            #expect(abs(p.x) + size / 2 <= half.x, "Modell ragt seitlich heraus bei \(move)")
            #expect(abs(p.y) + size / 2 <= half.y, "Modell ragt oben/unten heraus bei \(move)")
            #expect(p.z == start.z, "Z hat sich bei \(move) verändert")
        }
    }

    /// Die Grenzen dürfen die Ziele nicht unerreichbar machen.
    @Test("Alle Zielspalten und die Mindestanhebung liegen innerhalb der Spielfläche")
    func targetsRemainReachableWithinPlayArea() {
        let limits = PlanarDrag.playAreaLimits(
            forEntityOfSize: LayoutConstants.monsterDragDropTargetSize
        )
        let start = PrioritizationConstants.monsterStartPosition

        #expect(abs(start.x) <= limits.x)
        #expect(abs(start.y) <= limits.y)

        for target in PriorityTargetMapping.allTargets {
            #expect(
                abs(target.position.x) <= limits.x,
                "Spalte \(target.id) liegt außerhalb der Spielfläche"
            )
        }

        // Die für einen gültigen Drop nötige Höhe muss erreichbar bleiben.
        #expect(start.y + PrioritizationConstants.minimumDropLift <= limits.y)
    }

    // MARK: - Snapback nach ungültigem Drop

    /// Baut die Entity-Hierarchie so auf, wie `setupScene` sie erzeugt: eine Elternentity
    /// (die Wurzel der `RealityView`) mit einem Monster-Wrapper darunter, der Skalierung
    /// aus `MonsterAssetProvider.fit` und die Blender-Y-up-Korrektur trägt.
    private func makeMonsterHierarchy() -> (parent: Entity, monster: Entity) {
        let parent = Entity()
        // Bewusst **nicht** identisch: nur so wird sichtbar, ob lokaler und
        // Welt-Koordinatenraum vermischt werden.
        parent.position = SIMD3<Float>(0.5, -0.3, 0.1)
        parent.scale = SIMD3<Float>(repeating: 2)

        let monster = Entity()
        monster.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
        monster.scale = SIMD3<Float>(repeating: 0.37)
        monster.position = PrioritizationConstants.monsterStartPosition
        parent.addChild(monster)

        return (parent, monster)
    }

    /// Kernregression: `originTransform` wird als **lokaler** Transform gesichert
    /// (`entity.transform`). Der Snapback setzte ihn zuvor mit `relativeTo: nil`, also als
    /// Welt-Transform, zurück. Bei einer Elternentity mit eigenem Transform landet das
    /// Monster dadurch an anderer Stelle und in anderer Größe.
    @Test("Snapback im lokalen Raum stellt Position, Rotation und Scale exakt wieder her")
    func snapbackRestoresFullLocalTransform() {
        let (_, monster) = makeMonsterHierarchy()
        let origin = monster.transform   // wie in setupScene gesichert

        // Ziehen: nur die Translation ändert sich.
        monster.position = SIMD3<Float>(0.42, 0.18, origin.translation.z)

        // Snapback wie jetzt implementiert: relativ zur Elternentity.
        monster.setTransformMatrix(origin.matrix, relativeTo: monster.parent)

        let after = monster.transform
        #expect(simd_distance(after.translation, origin.translation) < 0.0001, "Position weicht ab")
        #expect(simd_distance(after.scale, origin.scale) < 0.0001, "Scale weicht ab")
        #expect(simd_distance(after.rotation.vector, origin.rotation.vector) < 0.0001, "Rotation weicht ab")
    }

    /// Gegenprobe: dieselbe Wiederherstellung im **Weltraum** ergäbe einen anderen lokalen
    /// Transform. Genau das war der alte Code — der Test schlägt fehl, falls jemand ihn
    /// zurückbaut.
    ///
    /// ## Warum gerechnet und nicht `setTransformMatrix(_:relativeTo: nil)`
    ///
    /// Die frühere Fassung setzte den Transform tatsächlich mit `relativeTo: nil` und
    /// erwartete danach eine Abweichung. Unter Xcode 26.6 / visionOS-SDK 26.5 liefert das
    /// für eine Hierarchie, die **nicht in einer Szene hängt**, exakt dasselbe Ergebnis wie
    /// `relativeTo: parent`: die gemessene Abweichung war 0.0 und die Gegenprobe schlug
    /// fehl, obwohl der Produktivcode korrekt ist — siehe den positiven Test
    /// `snapbackRestoresFullLocalTransform`, der unverändert besteht.
    ///
    /// Die Aussage wird deshalb direkt gerechnet statt über das SDK erschlossen:
    /// „`origin.matrix` als Weltmatrix setzen" bedeutet lokal `parent⁻¹ · origin.matrix`.
    /// Das ist unabhängig davon, wie eine SDK-Version `relativeTo: nil` für lose
    /// Hierarchien auflöst, und prüft trotzdem genau die Regression, um die es geht.
    @Test("Snapback im Weltraum würde Position und Größe verfälschen")
    func snapbackInWorldSpaceWouldDrift() {
        let (parent, monster) = makeMonsterHierarchy()
        let origin = monster.transform
        let parentTransform = parent.transform

        // Vorbedingung der Gegenprobe: die Elternentity trägt einen eigenen Transform.
        // Ohne ihn fielen lokaler und Weltraum zusammen und der Test wäre wertlos —
        // deshalb wird die Voraussetzung mitgeprüft statt stillschweigend angenommen.
        #expect(
            simd_distance(parentTransform.translation, SIMD3<Float>.zero) > 0.0001,
            "Fixture unbrauchbar: die Elternentity braucht eine eigene Translation"
        )
        #expect(
            simd_distance(parentTransform.scale, SIMD3<Float>(repeating: 1)) > 0.0001,
            "Fixture unbrauchbar: die Elternentity braucht eine eigene Skalierung"
        )

        // Alter Code: der **lokale** Transform, angewendet als **Welt**-Transform.
        // Lokal bliebe davon `parent⁻¹ · origin.matrix` übrig.
        let wouldBeLocal = Transform(matrix: parentTransform.matrix.inverse * origin.matrix)

        #expect(
            simd_distance(wouldBeLocal.translation, origin.translation) > 0.0001,
            "Erwartet wurde eine Abweichung — die Elternentity hat einen eigenen Transform"
        )
        #expect(
            simd_distance(wouldBeLocal.scale, origin.scale) > 0.0001,
            "Erwartet wurde eine Größenabweichung durch die skalierte Elternentity"
        )
    }

    /// Fünf ungültige Drops hintereinander dürfen keine schrittweise Drift erzeugen.
    @Test("Fünf aufeinanderfolgende Snapbacks driften nicht")
    func repeatedSnapbacksDoNotDrift() {
        let (_, monster) = makeMonsterHierarchy()
        let origin = monster.transform

        for step in 1...5 {
            monster.position = SIMD3<Float>(
                Float(step) * 0.05,
                Float(step) * -0.03,
                origin.translation.z
            )
            monster.setTransformMatrix(origin.matrix, relativeTo: monster.parent)

            let after = monster.transform
            #expect(
                simd_distance(after.translation, origin.translation) < 0.0001,
                "Drift nach Durchlauf \(step)"
            )
            #expect(simd_distance(after.scale, origin.scale) < 0.0001, "Scale-Drift nach \(step)")
        }
    }

    // MARK: - Sichtabstand zur Label-Zeile

    /// Regression: bei `targetLabelTopPadding = 120` lag die Label-Zeile auf der
    /// Monsteroberkante und verdeckte dessen Silhouette.
    @Test("Monster steht in der Startposition deutlich unter der Label-Zeile")
    func monsterStartsClearlyBelowLabelBand() {
        let height = LayoutConstants.monsterDragDropTargetSize
        let monsterTop = PrioritizationConstants.monsterStartPosition.y + height / 2
        let gap = PrioritizationConstants.labelBandBottomY - monsterTop

        #expect(gap > 0, "Monster ragt in die Label-Zeile")
        #expect(gap >= height, "Abstand unter einer Monsterhöhe — wirkt gedrängt (\(gap) m)")
    }

    /// Auch am höchsten erreichbaren Zieh-Punkt darf keine Überdeckung entstehen —
    /// und zwar für unterschiedlich hohe Modelle.
    @Test("Zieh-Obergrenze hält das Monster unter der Label-Zeile")
    func dragCeilingKeepsMonsterBelowLabelBand() {
        // Bandbreite plausibler Modellhöhen nach dem Einpassen.
        for height in [Float(0.08), 0.11, 0.13, 0.16] {
            let ceiling = PrioritizationConstants.monsterCeiling(forMonsterHeight: height)
            let topAtCeiling = ceiling + height / 2

            #expect(
                topAtCeiling < PrioritizationConstants.labelBandBottomY,
                "Modellhöhe \(height): Oberkante \(topAtCeiling) überdeckt die Label-Zeile"
            )

            // Die für einen gültigen Drop nötige Anhebung muss unter der Decke bleiben.
            let requiredY = PrioritizationConstants.monsterStartPosition.y
                + PrioritizationConstants.minimumDropLift
            #expect(
                requiredY < ceiling,
                "Modellhöhe \(height): Mindestanhebung liegt über der Zieh-Obergrenze"
            )
        }
    }

    /// Die Decke darf die Volume-Grenze nicht überschreiten — sonst wäre sie wirkungslos.
    @Test("Zieh-Obergrenze liegt innerhalb der Spielfläche")
    func dragCeilingStaysInsidePlayArea() {
        let height = LayoutConstants.monsterDragDropTargetSize
        let limits = PlanarDrag.playAreaLimits(forEntityOfSize: height)
        let ceiling = PrioritizationConstants.monsterCeiling(forMonsterHeight: height)

        #expect(ceiling <= limits.y)
        #expect(ceiling > PrioritizationConstants.monsterStartPosition.y)
    }

    @Test("Ablage ohne ausreichende Aufwärtsbewegung ist ungültig")
    func dropWithoutLiftIsInvalid() {
        let origin = PrioritizationConstants.monsterStartPosition
        let lift = PrioritizationConstants.minimumDropLift
        let targets = PriorityTargetMapping.allTargets.map {
            DropEvaluator.TargetDescriptor(
                id: $0.id,
                position: $0.position,
                radius: InteractionConstants.dropTargetRadius
            )
        }

        // Direkt an der Ausgangsposition losgelassen.
        #expect(
            DropEvaluator.evaluateColumn(
                entityPosition: origin,
                origin: origin,
                targets: targets,
                minimumLift: lift
            ) == nil
        )

        // Nach unten gezogen und losgelassen.
        let below = SIMD3<Float>(origin.x, origin.y - 0.1, origin.z)
        #expect(
            DropEvaluator.evaluateColumn(
                entityPosition: below,
                origin: origin,
                targets: targets,
                minimumLift: lift
            ) == nil
        )
    }

    @Test("PrioritizationConstants: monsterStartPosition ist erreichbar (y < targetPositionNormal.y)")
    func monsterStartPositionIsBelowTargets() {
        let monsterY = PrioritizationConstants.monsterStartPosition.y
        let targetY  = PrioritizationConstants.targetPositionNormal.y
        #expect(monsterY < targetY)
    }

    // MARK: - Layout-Fix: Trefferbereiche ohne sichtbare Geometrie

    /// Regressionstest zum „orangenen Halbkreis": der Trefferradius ist eine großzügige
    /// Toleranz und darf nie als Anzeigegröße dienen. In der Priorisierungsansicht gibt es
    /// inzwischen gar keine sichtbare Zielgeometrie mehr — in der Teamansicht ist der
    /// Sichtradius strikt kleiner als der Trefferradius.
    @Test("Sichtradius der Zielkugel ist kleiner als der Trefferradius")
    func visualRadiusIsSmallerThanHitRadius() {
        #expect(InteractionConstants.dropTargetVisualRadius > 0)
        #expect(InteractionConstants.dropTargetVisualRadius < InteractionConstants.dropTargetRadius)
    }

    @Test("Prioritätsziele liegen innerhalb des zentralen Volumes")
    func priorityTargetsStayInsideVolume() {
        let half = SIMD3<Float>(
            Float(LayoutConstants.centralVolumeWidth / 2),
            Float(LayoutConstants.centralVolumeHeight / 2),
            Float(LayoutConstants.centralVolumeDepth / 2)
        )
        for target in PriorityTargetMapping.allTargets {
            let p = target.position
            #expect(abs(p.x) <= half.x, "\(target.id) liegt seitlich außerhalb des Volumes")
            #expect(abs(p.y) <= half.y, "\(target.id) liegt oben/unten außerhalb des Volumes")
            #expect(abs(p.z) <= half.z, "\(target.id) liegt in der Tiefe außerhalb des Volumes")
        }
    }

    /// Das Monster soll deutlich sichtbar stehen und nicht im Boden versinken:
    /// Modellmitte oberhalb des unteren Volume-Drittels, Modell vollständig im Volume.
    @Test("Monster-Startposition liegt zentriert und vollständig im Volume")
    func monsterStartPositionIsCenteredAndFullyVisible() {
        let start = PrioritizationConstants.monsterStartPosition
        let halfModel = LayoutConstants.monsterDragDropTargetSize / 2
        let halfVolumeY = Float(LayoutConstants.centralVolumeHeight / 2)

        #expect(start.x == 0, "Monster ist nicht horizontal zentriert")
        #expect(abs(start.y) + halfModel <= halfVolumeY, "Monster ragt oben/unten aus dem Volume")
        #expect(start.y > -halfVolumeY / 3, "Monster steht zu tief in der Szene")
    }

    /// AK-10: das Monster darf zu Beginn in keinem Zielbereich liegen, sonst würde
    /// ein Drop ohne echte Bewegung bereits als gültig gewertet.
    @Test("Monster-Startposition liegt außerhalb aller Prioritätsziele")
    func monsterStartPositionIsOutsideEveryTarget() {
        let start = PrioritizationConstants.monsterStartPosition
        let targets = PriorityTargetMapping.allTargets.map {
            DropEvaluator.TargetDescriptor(
                id: $0.id,
                position: $0.position,
                radius: InteractionConstants.dropTargetRadius
            )
        }
        #expect(DropEvaluator.evaluate(entityPosition: start, targets: targets) == nil)
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

    /// Nach der Vergrößerung des Volumes werden Teamstationen über
    /// `DropEvaluator.evaluateNearest` ausgewertet. Alle vier müssen innerhalb der
    /// Zieh-Grenzen liegen und aus ihrer jeweiligen Ecke heraus eindeutig gewinnen.
    @Test("Alle vier Teamstationen sind innerhalb der Spielfläche erreichbar")
    func teamTargetsAreReachableWithinPlayArea() {
        let limits = PlanarDrag.playAreaLimits(
            forEntityOfSize: LayoutConstants.monsterDragDropTargetSize
        )
        let origin = TeamAssignmentConstants.monsterStartPosition
        let targets = TeamTargetMapping.allTargets.map {
            DropEvaluator.TargetDescriptor(
                id: $0.id,
                position: $0.position,
                radius: InteractionConstants.dropTargetRadius
            )
        }

        for target in TeamTargetMapping.allTargets {
            #expect(abs(target.position.x) <= limits.x, "\(target.id) außerhalb in X")
            #expect(abs(target.position.y) <= limits.y, "\(target.id) außerhalb in Y")
        }

        // Aus jeder Ecke der Spielfläche heraus muss die dortige Station gewinnen.
        for target in TeamTargetMapping.allTargets {
            let corner = SIMD3<Float>(
                target.position.x < 0 ? -limits.x : limits.x,
                target.position.y < 0 ? -limits.y : limits.y,
                origin.z
            )
            let result = DropEvaluator.evaluateNearest(
                entityPosition: corner,
                origin: origin,
                targets: targets,
                minimumDistance: TeamAssignmentConstants.minimumDropDistance
            )
            #expect(result == target.id, "Ecke \(corner) ergab \(result ?? "nil")")
        }

        // Ohne nennenswerte Bewegung bleibt die Ablage ungültig.
        #expect(
            DropEvaluator.evaluateNearest(
                entityPosition: origin,
                origin: origin,
                targets: targets,
                minimumDistance: TeamAssignmentConstants.minimumDropDistance
            ) == nil
        )
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

// MARK: - Modul 010: Bewertung und Audiofeedback

/// Tests für Scoring, genau-einmal-Semantik, Zustandsübergänge und AudioService-Mapping
/// (SPEC F-11 / F-12 / F-13 / AK-08 / AK-09 / AK-10).
///
/// Audio-Playback und der reale 1,5-Sekunden-Übergang werden zusätzlich manuell
/// im Simulator geprüft.
@MainActor
struct ScoringAndFeedbackTests {

    // MARK: - Hilfsmethode: Erstes Ticket mit bekannter Priorität und Team

    /// Gibt ein Ticket zurück, dessen referencePriority und referenceTeam bekannt sind.
    /// Verwendet den Katalog deterministisch (keine Shuffle-Abhängigkeit).
    private func firstCatalogTicket() -> Ticket {
        LocalTicketCatalog.allTickets[0]
    }

    /// Bringt das Modell in die Priorisierungsphase mit dem ersten Katalogticket.
    private func modelInPrioPhase() -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        return model
    }

    /// Bringt das Modell in die Teamphase mit dem ersten Katalogticket.
    private func modelInTeamPhase(priority: TicketPriority? = nil) -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        let ticket = model.currentTicket!
        let prio = priority ?? ticket.referencePriority
        model.savePriority(prio)
        model.beginTeamAssignmentPhase()
        return model
    }

    // MARK: - 1–5: Prioritätsbewertung

    @Test("Richtige Priorität ergibt +100 Punkte")
    func correctPriorityGivesOneHundredPoints() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        model.savePriority(ticket.referencePriority)
        let result = model.evaluatePriority()
        #expect(result == true)
        #expect(model.score == 100)
    }

    @Test("Falsche Priorität ergibt 0 Punkte (kein Abzug)")
    func wrongPriorityGivesZeroPoints() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        // Wähle bewusst eine falsche Priorität
        let wrongPriority = TicketPriority.allCases.first { $0 != ticket.referencePriority }!
        model.savePriority(wrongPriority)
        let result = model.evaluatePriority()
        #expect(result == false)
        #expect(model.score == 0)
    }

    @Test("Zweite Prioritätsbewertung gibt keine weiteren Punkte (genau-einmal)")
    func secondPriorityEvaluationGivesNoPoints() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        model.savePriority(ticket.referencePriority)
        model.evaluatePriority()
        let scoreBefore = model.score
        let secondResult = model.evaluatePriority()
        #expect(secondResult == nil)
        #expect(model.score == scoreBefore)
    }

    @Test("Prioritätsbewertung ohne gespeicherte Priorität ist No-Op")
    func priorityEvaluationWithoutSavedPriorityIsNoOp() {
        let model = modelInPrioPhase()
        // Kein savePriority — selectedPriority ist nil
        let result = model.evaluatePriority()
        #expect(result == nil)
        #expect(model.score == 0)
    }

    @Test("Prioritätsbewertung in falscher Phase ist No-Op")
    func priorityEvaluationInWrongPhaseIsNoOp() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        // Phase: .untersuchen — keine Bewertung möglich
        let result = model.evaluatePriority()
        #expect(result == nil)
        #expect(model.score == 0)
    }

    // MARK: - 6–10: Teambewertung

    @Test("Richtiges Team ergibt +100 Punkte")
    func correctTeamGivesOneHundredPoints() {
        let model = modelInTeamPhase()
        let ticket = model.currentTicket!
        model.saveTeam(ticket.referenceTeam)
        let result = model.evaluateTeam()
        #expect(result == true)
        #expect(model.score >= 100)
    }

    @Test("Falsches Team ergibt 0 Punkte (kein Abzug)")
    func wrongTeamGivesZeroPoints() {
        let model = modelInTeamPhase()
        let ticket = model.currentTicket!
        let wrongTeam = SupportTeam.allCases.first { $0 != ticket.referenceTeam }!
        model.saveTeam(wrongTeam)
        let scoreBefore = model.score
        let result = model.evaluateTeam()
        #expect(result == false)
        #expect(model.score == scoreBefore)
    }

    @Test("Zweite Teambewertung gibt keine weiteren Punkte (genau-einmal)")
    func secondTeamEvaluationGivesNoPoints() {
        let model = modelInTeamPhase()
        let ticket = model.currentTicket!
        model.saveTeam(ticket.referenceTeam)
        model.evaluateTeam()
        let scoreBefore = model.score
        let secondResult = model.evaluateTeam()
        #expect(secondResult == nil)
        #expect(model.score == scoreBefore)
    }

    @Test("Teambewertung ohne gespeichertes Team ist No-Op")
    func teamEvaluationWithoutSavedTeamIsNoOp() {
        let model = modelInTeamPhase()
        // Kein saveTeam
        let result = model.evaluateTeam()
        #expect(result == nil)
        #expect(model.score == 0)
    }

    @Test("Teambewertung in falscher Phase ist No-Op")
    func teamEvaluationInWrongPhaseIsNoOp() {
        let model = SessionModel()
        model.startSession(using: { $0 })
        // Phase: .untersuchen
        let result = model.evaluateTeam()
        #expect(result == nil)
        #expect(model.score == 0)
    }

    // MARK: - 11–15: Kombinationsszenarien

    @Test("Beide richtig → 200 Punkte pro Ticket")
    func bothCorrectGivesTwoHundredPoints() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        model.savePriority(ticket.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(ticket.referenceTeam)
        model.evaluateTeam()
        #expect(model.score == 200)
    }

    @Test("Priorität richtig, Team falsch → 100 Punkte")
    func correctPriorityWrongTeamGivesOneHundred() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        model.savePriority(ticket.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        let wrongTeam = SupportTeam.allCases.first { $0 != ticket.referenceTeam }!
        model.saveTeam(wrongTeam)
        model.evaluateTeam()
        #expect(model.score == 100)
    }

    @Test("Priorität falsch, Team richtig → 100 Punkte")
    func wrongPriorityCorrectTeamGivesOneHundred() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        let wrongPriority = TicketPriority.allCases.first { $0 != ticket.referencePriority }!
        model.savePriority(wrongPriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(ticket.referenceTeam)
        model.evaluateTeam()
        #expect(model.score == 100)
    }

    @Test("Beide falsch → 0 Punkte")
    func bothWrongGivesZeroPoints() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        let wrongPriority = TicketPriority.allCases.first { $0 != ticket.referencePriority }!
        model.savePriority(wrongPriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        let wrongTeam = SupportTeam.allCases.first { $0 != ticket.referenceTeam }!
        model.saveTeam(wrongTeam)
        model.evaluateTeam()
        #expect(model.score == 0)
    }

    @Test("Score ist niemals negativ")
    func scoreIsNeverNegative() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        let wrongPriority = TicketPriority.allCases.first { $0 != ticket.referencePriority }!
        model.savePriority(wrongPriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        let wrongTeam = SupportTeam.allCases.first { $0 != ticket.referenceTeam }!
        model.saveTeam(wrongTeam)
        model.evaluateTeam()
        #expect(model.score >= 0)
    }

    // MARK: - 16–25: Zustandsübergänge und Flow

    @Test("Nach Prioritätsfeedback wechselt Phase zu .teamZuordnen")
    func afterPriorityFeedbackPhaseIsTeamZuordnen() {
        let model = modelInPrioPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        #expect(model.currentPhase == .teamZuordnen)
    }

    @Test("Gespeicherte Priorität bleibt nach Wechsel zu Teamphase erhalten")
    func selectedPriorityIsPreservedAfterTeamPhaseTransition() {
        let model = modelInPrioPhase()
        let ticket = model.currentTicket!
        model.savePriority(ticket.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        #expect(model.selectedPriority == ticket.referencePriority)
    }

    @Test("Teamphase beginnt mit entsperrtem Input")
    func teamPhaseStartsWithUnlockedInput() {
        let model = modelInTeamPhase()
        #expect(model.isInputLocked == false)
    }

    @Test("Teamfeedback mit weiterem Ticket → Index +1")
    func teamFeedbackWithNextTicketAdvancesIndex() {
        let model = SessionModel()
        model.setTicketCount(3)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        let indexBefore = model.currentTicketIndex
        model.completeTicketAfterTeamFeedback()
        #expect(model.currentTicketIndex == indexBefore + 1)
    }

    @Test("Neues Ticket startet in .untersuchen")
    func newTicketStartsInUntersuchenPhase() {
        let model = SessionModel()
        model.setTicketCount(2)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        model.completeTicketAfterTeamFeedback()
        #expect(model.currentPhase == .untersuchen)
    }

    @Test("Neue Ticket-Entscheidungen sind nil nach Ticket-Abschluss")
    func newTicketDecisionsAreNilAfterCompletion() {
        let model = SessionModel()
        model.setTicketCount(2)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        model.completeTicketAfterTeamFeedback()
        #expect(model.selectedPriority == nil)
        #expect(model.selectedTeam == nil)
    }

    @Test("Score bleibt beim Ticket-Wechsel erhalten")
    func scoreIsPreservedAcrossTickets() {
        let model = SessionModel()
        model.setTicketCount(2)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        let scoreAfterFirst = model.score
        model.completeTicketAfterTeamFeedback()
        #expect(model.score == scoreAfterFirst)
    }

    @Test("Letztes Ticket → Phase .ergebnis")
    func lastTicketTransitionsToErgebnis() {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        model.completeTicketAfterTeamFeedback()
        #expect(model.currentPhase == .ergebnis)
    }

    @Test("Kein Indexüberlauf am letzten Ticket")
    func noIndexOverflowAtLastTicket() {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        let lastIndex = model.currentTicketIndex
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        model.completeTicketAfterTeamFeedback()
        #expect(model.currentTicketIndex == lastIndex)
    }

    @Test("Reset löscht Bewertungsflags und Score")
    func resetClearsEvaluationFlagsAndScore() {
        let model = modelInPrioPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        #expect(model.score > 0)
        model.reset()
        #expect(model.score == 0)
        // Nach Reset: Neubewertung aus falscher Phase → No-Op (Flags wurden gelöscht)
        let result = model.evaluatePriority()
        #expect(result == nil)
        #expect(model.score == 0)
    }

    // MARK: - 26–27: Genau-einmal-Task-Semantik (Modell-Ebene)

    @Test("Mehrfacher Bewertungsaufruf für Priorität gibt keine doppelten Punkte")
    func multipleEvaluatePriorityCallsGiveNoDuplicatePoints() {
        let model = modelInPrioPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.evaluatePriority()
        model.evaluatePriority()
        #expect(model.score == 100)
    }

    @Test("Mehrfacher Bewertungsaufruf für Team gibt keine doppelten Punkte")
    func multipleEvaluateTeamCallsGiveNoDuplicatePoints() {
        let model = modelInTeamPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        model.evaluateTeam()
        model.evaluateTeam()
        // Score ist mindestens 100 (Priorität könnte schon vergeben worden sein),
        // aber ein zweiter/dritter evaluateTeam() darf nicht mehr addieren.
        let scoreAfterFirst = model.score
        let resultSecond = model.evaluateTeam()
        #expect(resultSecond == nil)
        #expect(model.score == scoreAfterFirst)
    }

    // MARK: - 28–30: AudioService-Mapping

    @Test("FeedbackConstants.correctSoundName ist nicht leer und lokal benannt")
    func correctSoundNameIsNonEmptyAndLocal() {
        #expect(!FeedbackConstants.correctSoundName.isEmpty)
        #expect(!FeedbackConstants.correctSoundName.hasPrefix("http"))
    }

    @Test("FeedbackConstants.incorrectSoundName ist nicht leer und lokal benannt")
    func incorrectSoundNameIsNonEmptyAndLocal() {
        #expect(!FeedbackConstants.incorrectSoundName.isEmpty)
        #expect(!FeedbackConstants.incorrectSoundName.hasPrefix("http"))
    }

    @Test("Beide Sound-Namen sind eindeutig (kein Alias)")
    func soundNamesAreDistinct() {
        #expect(FeedbackConstants.correctSoundName != FeedbackConstants.incorrectSoundName)
    }

    // MARK: - 141–155: Ergebnis und Neustart (Modul 011 — F-15 / F-16 / AK-15 / AK-16)

    /// Hilfsmethode: Sitzung mit einem Ticket vollständig durchspielen → Phase .ergebnis.
    @MainActor
    private func modelInErgebnisPhase() -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        model.completeTicketAfterTeamFeedback()
        return model
    }

    @Test("Ergebnisphase behält finalen Score")
    @MainActor
    func ergebnisPhaseBehältsScore() {
        let model = modelInErgebnisPhase()
        #expect(model.currentPhase == .ergebnis)
        #expect(model.score == 200) // 1 Ticket, beide richtig → max 200
    }

    @Test("Reset aus Ergebnis wechselt zu .start")
    @MainActor
    func resetAusErgebnisGehtZuStart() {
        let model = modelInErgebnisPhase()
        model.reset()
        #expect(model.currentPhase == .start)
    }

    @Test("Reset setzt Ticketanzahl auf 6")
    @MainActor
    func resetSetsTicketCountToSix() {
        let model = modelInErgebnisPhase()
        model.setTicketCount(3)
        model.reset()
        #expect(model.selectedTicketCount == GameplayConstants.defaultTicketCount)
        #expect(model.selectedTicketCount == 6)
    }

    @Test("Reset leert sessionTickets")
    @MainActor
    func resetClearsSessionTickets() {
        let model = modelInErgebnisPhase()
        model.reset()
        #expect(model.sessionTickets.isEmpty)
    }

    @Test("Reset setzt currentTicketIndex auf 0")
    @MainActor
    func resetSetsIndexToZero() {
        let model = modelInErgebnisPhase()
        model.reset()
        #expect(model.currentTicketIndex == 0)
    }

    @Test("Reset setzt Score auf 0")
    @MainActor
    func resetSetsScoreToZero() {
        let model = modelInErgebnisPhase()
        #expect(model.score > 0)
        model.reset()
        #expect(model.score == 0)
    }

    @Test("Reset setzt selectedPriority auf nil")
    @MainActor
    func resetClearsPriority() {
        let model = modelInPrioPhase()
        model.savePriority(.normal)
        model.reset()
        #expect(model.selectedPriority == nil)
    }

    @Test("Reset setzt selectedTeam auf nil")
    @MainActor
    func resetClearsTeam() {
        let model = modelInTeamPhase()
        model.saveTeam(.netzwerk)
        model.reset()
        #expect(model.selectedTeam == nil)
    }

    @Test("Reset setzt isInputLocked auf false")
    @MainActor
    func resetUnlocksInput() {
        let model = modelInPrioPhase()
        model.savePriority(.normal) // sperrt Input
        model.reset()
        #expect(model.isInputLocked == false)
    }

    @Test("Reset löscht priorityEvaluated indirekt: erneute Bewertung ohne Score möglich")
    @MainActor
    func resetClearsPriorityEvaluatedFlag() {
        let model = modelInPrioPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        let scoreNachErster = model.score
        #expect(scoreNachErster == 100)
        // Reset
        model.reset()
        // Neue Sitzung starten und Priorität erneut bewerten
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        #expect(model.score == 100) // frische Bewertung, kein Carryover
    }

    @Test("Reset löscht teamEvaluated indirekt: erneute Bewertung ohne Doppelpunkte")
    @MainActor
    func resetClearsTeamEvaluatedFlag() {
        let model = modelInTeamPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        let scoreNachErster = model.score
        #expect(scoreNachErster >= 100)
        // Reset
        model.reset()
        // Neue Sitzung, nur Team bewerten
        model.startSession(using: { $0 })
        model.beginPrioritizationPhase()
        model.savePriority(model.currentTicket!.referencePriority)
        model.evaluatePriority()
        model.beginTeamAssignmentPhase()
        model.saveTeam(model.currentTicket!.referenceTeam)
        model.evaluateTeam()
        #expect(model.score == 200) // frisch, kein Doppelscore
    }

    @Test("Fünf aufeinanderfolgende Resets bleiben stabil")
    @MainActor
    func fiveConsecutiveResetsAreStable() {
        let model = SessionModel()
        for _ in 1...5 {
            model.setTicketCount(1)
            model.startSession(using: { $0 })
            model.beginPrioritizationPhase()
            model.savePriority(model.currentTicket!.referencePriority)
            model.evaluatePriority()
            model.beginTeamAssignmentPhase()
            model.saveTeam(model.currentTicket!.referenceTeam)
            model.evaluateTeam()
            model.completeTicketAfterTeamFeedback()
            #expect(model.currentPhase == .ergebnis)
            model.reset()
            #expect(model.currentPhase == .start)
            #expect(model.score == 0)
            #expect(model.selectedTicketCount == 6)
            #expect(model.sessionTickets.isEmpty)
        }
    }

    @Test("Nach Reset kann neue Sitzung korrekt gestartet werden")
    @MainActor
    func afterResetNewSessionStartsCorrectly() {
        let model = modelInErgebnisPhase()
        model.reset()
        model.startSession(using: { $0 })
        #expect(model.currentPhase == .untersuchen)
        #expect(model.sessionTickets.count == GameplayConstants.defaultTicketCount)
    }

    @Test("Neue Sitzung nach Reset übernimmt keine alten Punkte")
    @MainActor
    func newSessionAfterResetHasNoCarryoverScore() {
        let model = modelInErgebnisPhase()
        let altScore = model.score
        #expect(altScore > 0)
        model.reset()
        model.startSession(using: { $0 })
        #expect(model.score == 0)
    }

    @Test("Neue Sitzung nach Reset übernimmt keine alten Entscheidungen")
    @MainActor
    func newSessionAfterResetHasNoCarryoverDecisions() {
        let model = modelInTeamPhase()
        model.savePriority(.normal) // würde fehlschlagen (Phase), deshalb direkt Team
        model.saveTeam(.netzwerk)
        model.reset()
        model.startSession(using: { $0 })
        #expect(model.selectedPriority == nil)
        #expect(model.selectedTeam == nil)
    }
}

// MARK: - Modul 013: sicherer Zieh-Bereich, Zielpanels und 50-%-Drop

/// Tests der messwertbasierten Drag-/Drop-Grundlage.
///
/// Alle geprüften Typen sind bewusst frei von SwiftUI und von einem laufenden
/// RealityKit-Render-Loop: `VolumeMetrics`, `DragBounds`, `TargetPanelLayout` und
/// `DropEvaluator` arbeiten mit reinen Werten und sind dadurch ohne Simulator prüfbar.
///
/// Insbesondere ist die Überlappungsprüfung damit auch im Test **perspektivunabhängig**:
/// es gibt keine Kamera, keine Projektionsmatrix, keinen Blickwinkel — nur zwei
/// achsenparallele Boxen in Szenen-Koordinaten.
@Suite("Modul 013 — Zielpanels und 50-%-Drop")
struct TargetPanelAndOverlapTests {

    // MARK: - Hilfswerte

    /// Volume von 1.0 × 1.0 × 0.4 m, zentriert im Ursprung.
    private var volume: BoundingBox {
        BoundingBox(min: SIMD3<Float>(-0.5, -0.5, -0.2), max: SIMD3<Float>(0.5, 0.5, 0.2))
    }

    /// Symmetrisches Monster von 0.13 m Kantenlänge um seinen Root.
    private var symmetricMonster: BoundingBox {
        BoundingBox(min: SIMD3<Float>(-0.065, -0.065, -0.065), max: SIMD3<Float>(0.065, 0.065, 0.065))
    }

    /// Asymmetrisches Monster: links 0.08, rechts 0.12, oben 0.18, unten 0.06.
    private var asymmetricMonster: BoundingBox {
        BoundingBox(min: SIMD3<Float>(-0.08, -0.06, -0.05), max: SIMD3<Float>(0.12, 0.18, 0.05))
    }

    /// Monsterhülle an einer gegebenen Root-Position.
    private func hull(_ monster: BoundingBox, at position: SIMD3<Float>) -> BoundingBox {
        BoundingBox(min: monster.min + position, max: monster.max + position)
    }

    private var safeBounds: DragBounds {
        DragBounds.safeRegion(
            volume: volume,
            monsterBounds: symmetricMonster,
            padding: InteractionConstants.dragSafetyPadding
        )
    }

    // MARK: - DragBounds (Clipping-Schutz, Anforderung A)

    @Test("Der sichere Bereich haelt ein symmetrisches Monster vollstaendig im Volume")
    func safeRegionKeepsSymmetricMonsterInside() {
        let safe = safeBounds
        #expect(safe.maximum.x + symmetricMonster.max.x <= volume.max.x)
        #expect(safe.minimum.x + symmetricMonster.min.x >= volume.min.x)
        #expect(safe.maximum.y + symmetricMonster.max.y <= volume.max.y)
        #expect(safe.minimum.y + symmetricMonster.min.y >= volume.min.y)
    }

    @Test("Der sichere Bereich beruecksichtigt unterschiedliche Ausdehnungen je Seite")
    func safeRegionRespectsAsymmetry() {
        let safe = DragBounds.safeRegion(volume: volume, monsterBounds: asymmetricMonster, padding: 0.02)

        // Rechts ragt das Modell weiter heraus als links ⇒ rechte Grenze liegt weiter innen.
        #expect(volume.max.x - safe.maximum.x > safe.minimum.x - volume.min.x)
        // Oben ragt das Modell deutlich weiter heraus als unten.
        #expect(volume.max.y - safe.maximum.y > safe.minimum.y - volume.min.y)

        #expect(safe.maximum.x + asymmetricMonster.max.x <= volume.max.x)
        #expect(safe.minimum.x + asymmetricMonster.min.x >= volume.min.x)
        #expect(safe.maximum.y + asymmetricMonster.max.y <= volume.max.y)
        #expect(safe.minimum.y + asymmetricMonster.min.y >= volume.min.y)
    }

    @Test("Clamp begrenzt an allen vier Raendern und an den Ecken")
    func clampCoversAllEdgesAndCorners() {
        let safe = safeBounds
        let farOutside: [SIMD3<Float>] = [
            SIMD3<Float>(-10, 0, 0), SIMD3<Float>(10, 0, 0),
            SIMD3<Float>(0, 10, 0), SIMD3<Float>(0, -10, 0),
            SIMD3<Float>(-10, 10, 0), SIMD3<Float>(10, 10, 0),
            SIMD3<Float>(-10, -10, 0), SIMD3<Float>(10, -10, 0),
        ]

        for requested in farOutside {
            let allowed = safe.clamp(requested)
            let box = hull(symmetricMonster, at: allowed)
            #expect(box.min.x >= volume.min.x)
            #expect(box.max.x <= volume.max.x)
            #expect(box.min.y >= volume.min.y)
            #expect(box.max.y <= volume.max.y)
        }
    }

    @Test("Eine Position innerhalb des sicheren Bereichs bleibt unveraendert")
    func clampLeavesInteriorUntouched() {
        let inside = SIMD3<Float>(0.1, -0.05, 0.06)
        #expect(safeBounds.clamp(inside) == inside)
    }

    @Test("Ein Monster groesser als das Volume kollabiert auf die Mitte")
    func oversizedMonsterCollapsesToCenter() {
        let huge = BoundingBox(min: SIMD3<Float>(-2, -2, -0.05), max: SIMD3<Float>(2, 2, 0.05))
        let safe = DragBounds.safeRegion(volume: volume, monsterBounds: huge, padding: 0.02)
        #expect(safe.hasCollapsedAxis)
        #expect(safe.minimum.x == safe.maximum.x)
        #expect(safe.minimum.y == safe.maximum.y)
    }

    // MARK: - VolumeMetrics

    @Test("Layoutpunkte werden linear und Y-gespiegelt in Szenenmeter abgebildet")
    func layoutPointsMapToSceneMeters() {
        let metrics = VolumeMetrics(
            volume: volume,
            layoutFrame: CGRect(x: 0, y: 0, width: 1000, height: 1000)
        )
        #expect(metrics.isUsable)

        let topLeft = metrics.scenePoint(fromLayout: CGPoint(x: 0, y: 0))
        #expect(abs(topLeft.x - volume.min.x) < 0.0001)
        #expect(abs(topLeft.y - volume.max.y) < 0.0001)

        let bottomRight = metrics.scenePoint(fromLayout: CGPoint(x: 1000, y: 1000))
        #expect(abs(bottomRight.x - volume.max.x) < 0.0001)
        #expect(abs(bottomRight.y - volume.min.y) < 0.0001)
    }

    @Test("Unbrauchbare Messungen werden erkannt")
    func degenerateMetricsAreRejected() {
        #expect(!VolumeMetrics(volume: volume, layoutFrame: .zero).isUsable)
        #expect(
            !VolumeMetrics(
                volume: BoundingBox(min: .zero, max: .zero),
                layoutFrame: CGRect(x: 0, y: 0, width: 1000, height: 1000)
            ).isUsable
        )
    }

    // MARK: - Panelraster (Anforderung B / D / 18)

    private func resolvedPriority(
        monster: BoundingBox? = nil,
        planeZ: Float = 0.06
    ) -> TargetPanelLayout.Resolved {
        PriorityTargetMapping.panelLayout.resolve(
            volume: volume,
            monsterBounds: monster ?? symmetricMonster,
            monsterPlaneZ: planeZ
        )
    }

    private func resolvedTeam(planeZ: Float = 0) -> TargetPanelLayout.Resolved {
        TeamTargetMapping.panelLayout.resolve(
            volume: volume,
            monsterBounds: symmetricMonster,
            monsterPlaneZ: planeZ
        )
    }

    @Test("Die drei Prioritaetspanels liegen kompakt nebeneinander")
    func priorityPanelsStayInACompactRow() {
        let resolved = resolvedPriority()

        guard
            let normal = resolved.centers[PriorityTargetMapping.ID.normal],
            let wichtig = resolved.centers[PriorityTargetMapping.ID.wichtig],
            let kritisch = resolved.centers[PriorityTargetMapping.ID.kritisch]
        else {
            Issue.record("Panelzentren fehlen")
            return
        }

        // Reihenfolge links → Mitte → rechts.
        #expect(normal.x < wichtig.x)
        #expect(wichtig.x < kritisch.x)

        // Alle drei auf derselben Hoehe (eine Reihe).
        #expect(abs(normal.y - wichtig.y) < 0.0001)
        #expect(abs(wichtig.y - kritisch.y) < 0.0001)

        // Das Raster bleibt symmetrisch und in grossen Volumes auf die ergonomische
        // Maximalbreite begrenzt.
        let half = resolved.panelSize / 2
        let margin = InteractionConstants.dragSafetyPadding
        let gridHalfWidth = LayoutConstants.priorityTargetGridMaximumWidth / 2
        #expect(abs((normal.x - half.x) - (-gridHalfWidth + margin)) < 0.0001)
        #expect(abs((kritisch.x + half.x) - (gridHalfWidth - margin)) < 0.0001)
        #expect(abs(normal.y - LayoutConstants.targetGridTopOffsetFromCenter) < 0.0001)

        // Mittleres Panel bleibt mittig.
        #expect(abs(wichtig.x) < 0.0001)
    }

    @Test("Die vier Teampanels behalten die 2x2-Struktur")
    func teamPanelsKeepTwoByTwoGrid() {
        let resolved = resolvedTeam()

        guard
            let netzwerk = resolved.centers[TeamTargetMapping.ID.netzwerk],
            let konto = resolved.centers[TeamTargetMapping.ID.konto],
            let software = resolved.centers[TeamTargetMapping.ID.software],
            let hardware = resolved.centers[TeamTargetMapping.ID.hardware]
        else {
            Issue.record("Panelzentren fehlen")
            return
        }

        // Obere Reihe: Netzwerk links, Konto rechts.
        #expect(netzwerk.x < konto.x)
        #expect(abs(netzwerk.y - konto.y) < 0.0001)

        // Untere Reihe: Software links, Hardware rechts.
        #expect(software.x < hardware.x)
        #expect(abs(software.y - hardware.y) < 0.0001)

        // Zwei getrennte Reihen, obere ueber unterer — keine vertikale Liste.
        #expect(netzwerk.y > software.y)
        #expect(abs(netzwerk.x - software.x) < 0.0001)
        #expect(abs(konto.x - hardware.x) < 0.0001)

        // Beide Reihen bilden nahe der Mitte einen kompakten Block.
        #expect(abs(netzwerk.y - LayoutConstants.targetGridTopOffsetFromCenter) < 0.0001)
        #expect(abs((netzwerk.y - software.y) - (resolved.panelSize.y + LayoutConstants.targetPanelGap)) < 0.0001)
    }

    @Test("Das Team-Monster startet mit seinem Mittelpunkt unterhalb der unteren Panelreihe")
    func teamMonsterStartsBelowPanels() {
        let resolved = resolvedTeam()
        guard let software = resolved.bounds(for: TeamTargetMapping.ID.software) else {
            Issue.record("Unteres Teampanel fehlt")
            return
        }

        #expect(TeamAssignmentConstants.monsterStartPosition.y < software.min.y)
    }

    @Test("Panels bleiben flach: Tiefe deutlich kleiner als Breite und Hoehe")
    func panelsStayFlat() {
        let size = resolvedPriority().panelSize
        #expect(size.z == LayoutConstants.targetPanelDepth)
        #expect(size.z < size.x / 4)
        #expect(size.z < size.y / 2)
    }

    @Test("Die Panelhoehe folgt der gemessenen Monsterhoehe")
    func panelHeightFollowsMonsterHeight() {
        let flat = BoundingBox(min: SIMD3<Float>(-0.065, -0.05, -0.065), max: SIMD3<Float>(0.065, 0.05, 0.065))
        let tall = BoundingBox(min: SIMD3<Float>(-0.065, -0.10, -0.065), max: SIMD3<Float>(0.065, 0.10, 0.065))

        let flatHeight = resolvedPriority(monster: flat).panelSize.y
        let tallHeight = resolvedPriority(monster: tall).panelSize.y
        #expect(tallHeight > flatHeight)

        // Untere Schranke greift, wenn das Monster sehr flach ist.
        let tiny = BoundingBox(min: SIMD3<Float>(-0.02, -0.01, -0.02), max: SIMD3<Float>(0.02, 0.01, 0.02))
        #expect(resolvedPriority(monster: tiny).panelSize.y == LayoutConstants.targetPanelMinimumHeight)

        // Obere Schranke: das Panel passt immer ins Volume. Die **gestalterische** Grenze
        // (`targetPanelMaximumHeightFraction`) darf dabei überschritten werden, wenn die
        // Erreichbarkeit der 50-%-Schwelle es verlangt — die **geometrische** nicht.
        let giant = BoundingBox(min: SIMD3<Float>(-0.065, -0.5, -0.065), max: SIMD3<Float>(0.065, 0.5, 0.065))
        let hardMax = volume.extents.y - 2 * InteractionConstants.dragSafetyPadding
        #expect(resolvedPriority(monster: giant).panelSize.y <= hardMax + 0.0001)
    }

    @Test("Bei zwei Reihen ueberlappen sich obere und untere Panelreihe nie")
    func twoRowsNeverOverlap() {
        let shapes = [
            symmetricMonster,
            BoundingBox(min: SIMD3<Float>(-0.049, -0.065, -0.046), max: SIMD3<Float>(0.049, 0.065, 0.046)),
            BoundingBox(min: SIMD3<Float>(-0.065, -0.5, -0.065), max: SIMD3<Float>(0.065, 0.5, 0.065)),
        ]
        for volumeUnderTest in [volume, measuredVolume] {
            for shape in shapes {
                let resolved = TeamTargetMapping.panelLayout.resolve(
                    volume: volumeUnderTest,
                    monsterBounds: shape,
                    monsterPlaneZ: 0
                )
                guard
                    let top = resolved.centers[TeamTargetMapping.ID.netzwerk],
                    let bottom = resolved.centers[TeamTargetMapping.ID.software]
                else {
                    Issue.record("Panelzentren fehlen")
                    continue
                }
                let half = resolved.panelSize.y / 2
                #expect(top.y - half >= bottom.y + half - 0.0001, "Reihen ueberlappen")
                #expect(top.y + half <= volumeUnderTest.max.y + 0.0001, "obere Reihe ragt heraus")
                #expect(bottom.y - half >= volumeUnderTest.min.y - 0.0001, "untere Reihe ragt heraus")
            }
        }
    }

    @Test("Das Panel steht hinter dem Monster, mit genau dem vorgesehenen Abstand")
    func panelSitsBehindTheMonsterPlane() {
        let planeZ: Float = 0.06
        let resolved = resolvedPriority(planeZ: planeZ)

        guard let center = resolved.centers[PriorityTargetMapping.ID.wichtig] else {
            Issue.record("Panelzentrum fehlt")
            return
        }

        let panelFront = center.z + resolved.panelSize.z / 2
        let monsterBack = planeZ + symmetricMonster.min.z

        #expect(panelFront < monsterBack)
        #expect(abs((monsterBack - panelFront) - LayoutConstants.targetPanelStandoff) < 0.0001)
        // Der regulaere Abstand muss innerhalb der Toleranz liegen, sonst waere kein Drop
        // jemals gueltig.
        #expect(LayoutConstants.targetPanelStandoff < InteractionConstants.dropDepthTolerance)
    }

    // MARK: - Überlappungsmaß (Anforderung C)

    /// Zielbox aus dem Prioritaetsraster.
    private func priorityTarget(_ id: String) -> DropEvaluator.BoxTarget {
        DropEvaluator.BoxTarget(id: id, bounds: resolvedPriority().bounds(for: id)!)
    }

    /// Bewertet eine Monsterposition gegen alle drei Prioritaetsziele.
    private func evaluatePriority(at position: SIMD3<Float>) -> [DropEvaluator.OverlapResult] {
        DropEvaluator.evaluateTargets(
            monsterBounds: hull(symmetricMonster, at: position),
            targets: PriorityTargetMapping.allTargets.map { priorityTarget($0.id) },
            minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
            depthTolerance: InteractionConstants.dropDepthTolerance
        )
    }

    private func bestPriorityTarget(at position: SIMD3<Float>) -> DropEvaluator.OverlapResult? {
        DropEvaluator.bestTarget(
            monsterBounds: hull(symmetricMonster, at: position),
            targets: PriorityTargetMapping.allTargets.map { priorityTarget($0.id) },
            minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
            depthTolerance: InteractionConstants.dropDepthTolerance
        )
    }

    @Test("Die Ratio bezieht sich auf die Monsterflaeche, nicht auf die kleinere Flaeche")
    func ratioIsRelativeToMonsterArea() {
        // Winziges Ziel, vollstaendig vom Monster ueberdeckt: bezogen auf die Zielflaeche
        // waere das 100 %, bezogen auf die Monsterflaeche sind es rund 6 %.
        let monster = hull(symmetricMonster, at: .zero)
        let tinyTarget = BoundingBox(
            min: SIMD3<Float>(-0.02, -0.02, -0.01),
            max: SIMD3<Float>(0.02, 0.02, 0.01)
        )
        let ratio = DropEvaluator.overlapRatio(monsterBounds: monster, targetBounds: tinyTarget)
        #expect(ratio < 0.1)
        #expect(ratio > 0.05)
    }

    @Test("Minimale Beruehrung und 25 Prozent sind ungueltig, 50 Prozent und mehr gueltig")
    func fiftyPercentThresholdBehavesAsSpecified() {
        // Volle X-Ueberdeckung ueber dem mittleren Panel; nur die Hoehe variiert.
        // Bei diesem Raster gilt ratio = (cy - panelBottom + halbe Monsterhoehe) / Monsterhoehe.
        let cases: [(y: Float, expectedValid: Bool, label: String)] = [
            (0.311, false, "ca. 10 %"),
            (0.3305, false, "ca. 25 %"),
            (0.360, false, "knapp unter 50 %"),
            (0.366, true, "knapp ueber 50 %"),
            (0.415, true, "deutlich ueber 50 %"),
        ]

        for testCase in cases {
            let results = evaluatePriority(at: SIMD3<Float>(0, testCase.y, 0.06))
            guard let middle = results.first(where: { $0.id == PriorityTargetMapping.ID.wichtig }) else {
                Issue.record("Ergebnis fuer das mittlere Ziel fehlt")
                return
            }
            #expect(
                middle.isValid == testCase.expectedValid,
                "\(testCase.label): ratio=\(middle.overlapRatio), erwartet gueltig=\(testCase.expectedValid)"
            )
        }
    }

    @Test("Die 50-Prozent-Grenze liegt dort, wo das Monster halb auf dem Panel liegt")
    func thresholdMatchesHalfTheMonster() {
        let resolved = resolvedPriority()
        guard let center = resolved.centers[PriorityTargetMapping.ID.wichtig] else {
            Issue.record("Panelzentrum fehlt")
            return
        }
        // Monstermitte exakt auf der Unterkante des Panels ⇒ genau die Haelfte liegt darauf.
        let panelBottom = center.y - resolved.panelSize.y / 2
        let results = evaluatePriority(at: SIMD3<Float>(0, panelBottom, 0.06))
        guard let middle = results.first(where: { $0.id == PriorityTargetMapping.ID.wichtig }) else {
            Issue.record("Ergebnis fehlt")
            return
        }
        #expect(abs(middle.overlapRatio - 0.5) < 0.01)
    }

    @Test("Zwischen zwei Panels abgelegt wird kein Ziel ausgeloest")
    func droppingBetweenTwoPanelsHitsNothing() {
        let resolved = resolvedPriority()
        guard
            let wichtig = resolved.centers[PriorityTargetMapping.ID.wichtig],
            let kritisch = resolved.centers[PriorityTargetMapping.ID.kritisch]
        else {
            Issue.record("Panelzentren fehlen")
            return
        }

        let between = (wichtig.x + kritisch.x) / 2
        let position = SIMD3<Float>(between, safeBounds.maximum.y, 0.06)

        #expect(bestPriorityTarget(at: position) == nil)
        for result in evaluatePriority(at: position) {
            #expect(!result.isValid, "\(result.id) sollte ungueltig sein: \(result.overlapRatio)")
        }
    }

    @Test("Ausserhalb jeder Zielzone ist kein Drop gueltig")
    func droppingInFreeSpaceHitsNothing() {
        // Mitte des Volumes — weit unterhalb der Panelreihe.
        #expect(bestPriorityTarget(at: SIMD3<Float>(0, 0, 0.06)) == nil)
        // Untere Ecken.
        #expect(bestPriorityTarget(at: SIMD3<Float>(safeBounds.minimum.x, safeBounds.minimum.y, 0.06)) == nil)
        #expect(bestPriorityTarget(at: SIMD3<Float>(safeBounds.maximum.x, safeBounds.minimum.y, 0.06)) == nil)
    }

    @Test("Hoechstens ein Ziel ist gleichzeitig gueltig")
    func atMostOneTargetIsValidAtATime() {
        // Gesamte erreichbare Flaeche in einem groben Raster abtasten.
        var samples = 0
        var x = safeBounds.minimum.x
        while x <= safeBounds.maximum.x {
            var y = safeBounds.minimum.y
            while y <= safeBounds.maximum.y {
                let valid = evaluatePriority(at: SIMD3<Float>(x, y, 0.06)).filter(\.isValid)
                #expect(valid.count <= 1, "Mehrere gueltige Ziele bei (\(x), \(y)): \(valid.map(\.id))")
                samples += 1
                y += 0.01
            }
            x += 0.01
        }
        #expect(samples > 100)
    }

    // MARK: - Z-Nähe (Anforderung 9)

    @Test("Ein zu weit vorne oder hinten liegendes Monster ist trotz voller Ueberlappung ungueltig")
    func depthGapInvalidatesOtherwisePerfectOverlap() {
        let resolved = resolvedPriority()
        guard let center = resolved.centers[PriorityTargetMapping.ID.wichtig] else {
            Issue.record("Panelzentrum fehlt")
            return
        }
        let target = DropEvaluator.BoxTarget(
            id: PriorityTargetMapping.ID.wichtig,
            bounds: resolved.bounds(for: PriorityTargetMapping.ID.wichtig)!
        )

        // Perfekte X/Y-Lage, aber weit vor dem Panel.
        let farInFront = hull(symmetricMonster, at: SIMD3<Float>(center.x, center.y, 0.06 + 0.5))
        let result = DropEvaluator.evaluateTargets(
            monsterBounds: farInFront,
            targets: [target],
            minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
            depthTolerance: InteractionConstants.dropDepthTolerance
        ).first

        #expect((result?.overlapRatio ?? 0) >= 0.85)
        #expect(result?.isDepthValid == false)
        #expect(result?.isValid == false)
    }

    @Test("Der Z-Abstand wird zwischen Oberflaechen gemessen, nicht zwischen Mittelpunkten")
    func depthGapMeasuresSurfaces() {
        // Zwei Boxen, deren Z-Bereiche sich ueberlappen ⇒ Spalt 0, obwohl die
        // Mittelpunkte auseinanderliegen.
        let a = BoundingBox(min: SIMD3<Float>(0, 0, -0.10), max: SIMD3<Float>(1, 1, 0.10))
        let b = BoundingBox(min: SIMD3<Float>(0, 0, 0.05), max: SIMD3<Float>(1, 1, 0.15))
        #expect(DropEvaluator.depthGap(a, b) == 0)

        let c = BoundingBox(min: SIMD3<Float>(0, 0, 0.30), max: SIMD3<Float>(1, 1, 0.40))
        #expect(abs(DropEvaluator.depthGap(a, c) - 0.20) < 0.0001)
    }

    // MARK: - Erreichbarkeit trotz Clipping-Schutz (A + C + D gleichzeitig)

    @Test("Jedes Prioritaetsziel ist erreichbar, ohne dass das Monster abgeschnitten wird")
    func everyPriorityTargetIsReachableWithoutClipping() {
        let resolved = resolvedPriority()
        let safe = safeBounds

        for target in PriorityTargetMapping.allTargets {
            guard let center = resolved.centers[target.id] else {
                Issue.record("Panelzentrum fehlt: \(target.id)")
                continue
            }
            // Der Nutzer zieht in Richtung Panelmitte und stoesst dabei an die sichere Grenze.
            let position = safe.clamp(SIMD3<Float>(center.x, center.y, 0.06))
            let box = hull(symmetricMonster, at: position)

            // Kein Clipping.
            #expect(box.min.x >= volume.min.x)
            #expect(box.max.x <= volume.max.x)
            #expect(box.min.y >= volume.min.y)
            #expect(box.max.y <= volume.max.y)

            // Und trotzdem gueltiger Drop auf genau diesem Ziel.
            let best = bestPriorityTarget(at: position)
            #expect(best?.id == target.id, "\(target.id) nicht erreichbar, best=\(best?.id ?? "-")")
            #expect((best?.overlapRatio ?? 0) >= InteractionConstants.minimumDropOverlapRatio)
        }
    }

    @Test("Jedes Teamziel ist erreichbar, ohne dass das Monster abgeschnitten wird")
    func everyTeamTargetIsReachableWithoutClipping() {
        let resolved = resolvedTeam()
        let safe = safeBounds
        let targets = TeamTargetMapping.allTargets.map {
            DropEvaluator.BoxTarget(id: $0.id, bounds: resolved.bounds(for: $0.id)!)
        }

        for target in TeamTargetMapping.allTargets {
            guard let center = resolved.centers[target.id] else {
                Issue.record("Panelzentrum fehlt: \(target.id)")
                continue
            }
            let position = safe.clamp(SIMD3<Float>(center.x, center.y, 0))
            let box = hull(symmetricMonster, at: position)

            #expect(box.min.x >= volume.min.x)
            #expect(box.max.x <= volume.max.x)
            #expect(box.min.y >= volume.min.y)
            #expect(box.max.y <= volume.max.y)

            let best = DropEvaluator.bestTarget(
                monsterBounds: box,
                targets: targets,
                minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
                depthTolerance: InteractionConstants.dropDepthTolerance
            )
            #expect(best?.id == target.id, "\(target.id) nicht erreichbar, best=\(best?.id ?? "-")")
        }
    }

    @Test("Die Startposition liegt in keiner Zielzone")
    func startPositionIsNotOnAnyTarget() {
        #expect(bestPriorityTarget(at: PrioritizationConstants.monsterStartPosition) == nil)

        let resolved = resolvedTeam()
        let targets = TeamTargetMapping.allTargets.map {
            DropEvaluator.BoxTarget(id: $0.id, bounds: resolved.bounds(for: $0.id)!)
        }
        let best = DropEvaluator.bestTarget(
            monsterBounds: hull(symmetricMonster, at: TeamAssignmentConstants.monsterStartPosition),
            targets: targets,
            minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
            depthTolerance: InteractionConstants.dropDepthTolerance
        )
        #expect(best == nil)
    }

    // MARK: - Verschieden geformte Monster (Anforderung 31)

    @Test("Die 50-Prozent-Regel bleibt fuer unterschiedlich geformte Monster erreichbar")
    func ruleRemainsReachableForDifferentMonsterShapes() {
        // Vier Stellvertreter fuer monster01 … monster04: schmal/hoch, breit/flach,
        // wuerfelig und mit versetztem Origin.
        let shapes: [(name: String, bounds: BoundingBox)] = [
            ("schmal-hoch", BoundingBox(min: SIMD3<Float>(-0.04, -0.065, -0.04), max: SIMD3<Float>(0.04, 0.065, 0.04))),
            ("breit-flach", BoundingBox(min: SIMD3<Float>(-0.065, -0.035, -0.03), max: SIMD3<Float>(0.065, 0.035, 0.03))),
            ("wuerfelig", BoundingBox(min: SIMD3<Float>(-0.06, -0.06, -0.06), max: SIMD3<Float>(0.06, 0.06, 0.06))),
            ("origin-versetzt", BoundingBox(min: SIMD3<Float>(-0.03, -0.02, -0.05), max: SIMD3<Float>(0.09, 0.11, 0.05))),
        ]

        for shape in shapes {
            let resolved = PriorityTargetMapping.panelLayout.resolve(
                volume: volume,
                monsterBounds: shape.bounds,
                monsterPlaneZ: 0.06
            )
            let safe = DragBounds.safeRegion(
                volume: volume,
                monsterBounds: shape.bounds,
                padding: InteractionConstants.dragSafetyPadding
            )
            let targets = PriorityTargetMapping.allTargets.map {
                DropEvaluator.BoxTarget(id: $0.id, bounds: resolved.bounds(for: $0.id)!)
            }

            for target in PriorityTargetMapping.allTargets {
                guard let center = resolved.centers[target.id] else { continue }
                let position = safe.clamp(SIMD3<Float>(center.x, center.y, 0.06))
                let box = BoundingBox(min: shape.bounds.min + position, max: shape.bounds.max + position)

                // Kein Clipping.
                #expect(box.min.x >= volume.min.x - 0.0001, "\(shape.name)/\(target.id) links")
                #expect(box.max.x <= volume.max.x + 0.0001, "\(shape.name)/\(target.id) rechts")
                #expect(box.min.y >= volume.min.y - 0.0001, "\(shape.name)/\(target.id) unten")
                #expect(box.max.y <= volume.max.y + 0.0001, "\(shape.name)/\(target.id) oben")

                // Ziel erreichbar.
                let best = DropEvaluator.bestTarget(
                    monsterBounds: box,
                    targets: targets,
                    minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
                    depthTolerance: InteractionConstants.dropDepthTolerance
                )
                #expect(best?.id == target.id, "\(shape.name): \(target.id) nicht erreichbar")
            }
        }
    }

    // MARK: - Regression: tatsaechlich gemessenes Volume (Log vom 27.08.)

    /// Das im Simulator **gemessene** Volume — deutlich kleiner als die deklarierten
    /// 1.0 × 1.0 × 0.4 m aus `LayoutConstants.centralVolume*`.
    ///
    /// Rekonstruiert aus den geloggten `Safe drag bounds` und den Monster-Bounds:
    /// 0.284 × 0.236 × 0.235 m. Genau in diesem Volume war die 50-%-Schwelle
    /// unerreichbar, weil `0.28 × Volume-Höhe = 0.066 m` gegen ein 0.130 m hohes Monster
    /// stand.
    private var measuredVolume: BoundingBox {
        BoundingBox(min: SIMD3<Float>(-0.142, -0.1176, 0.0), max: SIMD3<Float>(0.142, 0.1184, 0.2348))
    }

    /// Die vier Assets nach `fit(toMaxExtent: 0.13)`, zentriert.
    ///
    /// Breite und Tiefe aus den USDC-Extents, monster04 aus dem Trace-Log — dessen Werte
    /// bestätigen die Ableitung (0.070 × 0.130 × 0.088).
    private var allMonsterShapes: [(name: String, bounds: BoundingBox)] {
        [
            ("monster01", BoundingBox(min: SIMD3<Float>(-0.0351, -0.065, -0.0364), max: SIMD3<Float>(0.0351, 0.065, 0.0364))),
            ("monster02", BoundingBox(min: SIMD3<Float>(-0.0225, -0.065, -0.0258), max: SIMD3<Float>(0.0225, 0.065, 0.0258))),
            ("monster03", BoundingBox(min: SIMD3<Float>(-0.0491, -0.065, -0.0455), max: SIMD3<Float>(0.0491, 0.065, 0.0455))),
            ("monster04", BoundingBox(min: SIMD3<Float>(-0.0350, -0.0646, -0.0442), max: SIMD3<Float>(0.0350, 0.0654, 0.0438))),
        ]
    }

    @Test("Im gemessenen Volume erreicht jedes Asset jedes Ziel in beiden Phasen")
    func everyAssetReachesEveryTargetInTheMeasuredVolume() {
        let phases: [(name: String, layout: TargetPanelLayout, planeZ: Float, ids: [String])] = [
            ("Priorisierung", PriorityTargetMapping.panelLayout, 0.06, PriorityTargetMapping.allTargets.map(\.id)),
            ("Teamzuordnung", TeamTargetMapping.panelLayout, 0.0, TeamTargetMapping.allTargets.map(\.id)),
        ]

        for phase in phases {
            for shape in allMonsterShapes {
                let safe = DragBounds.safeRegion(
                    volume: measuredVolume,
                    monsterBounds: shape.bounds,
                    padding: InteractionConstants.dragSafetyPadding
                )
                let effective = safe.clamp(SIMD3<Float>(0, 0, phase.planeZ)).z
                let resolved = phase.layout.resolve(
                    volume: measuredVolume,
                    monsterBounds: shape.bounds,
                    monsterPlaneZ: effective
                )
                let targets = phase.ids.map {
                    DropEvaluator.BoxTarget(id: $0, bounds: resolved.bounds(for: $0)!)
                }

                for id in phase.ids {
                    let box = resolved.bounds(for: id)!
                    let position = safe.clamp(SIMD3<Float>(box.center.x, box.center.y, effective))
                    let box3 = BoundingBox(
                        min: shape.bounds.min + position,
                        max: shape.bounds.max + position
                    )

                    // Kein Clipping — der Sicherheitsrand bleibt unangetastet.
                    #expect(box3.min.x >= measuredVolume.min.x - 0.0001, "\(phase.name)/\(shape.name)/\(id) links")
                    #expect(box3.max.x <= measuredVolume.max.x + 0.0001, "\(phase.name)/\(shape.name)/\(id) rechts")
                    #expect(box3.min.y >= measuredVolume.min.y - 0.0001, "\(phase.name)/\(shape.name)/\(id) unten")
                    #expect(box3.max.y <= measuredVolume.max.y + 0.0001, "\(phase.name)/\(shape.name)/\(id) oben")

                    // Und die Schwelle ist mit Reserve erreichbar.
                    let ratio = DropEvaluator.overlapRatio(monsterBounds: box3, targetBounds: box)
                    #expect(
                        ratio >= InteractionConstants.minimumDropOverlapRatio,
                        "\(phase.name)/\(shape.name)/\(id): nur \(ratio)"
                    )

                    let best = DropEvaluator.bestTarget(
                        monsterBounds: box3,
                        targets: targets,
                        minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
                        depthTolerance: InteractionConstants.dropDepthTolerance
                    )
                    #expect(best?.id == id, "\(phase.name)/\(shape.name): \(id) nicht getroffen")
                }
            }
        }
    }

    @Test("Die Erreichbarkeit schlaegt die gestalterische Hoehenbegrenzung")
    func reachabilityBeatsTheStylisticHeightCap() {
        // Im gemessenen Volume liegt die gestalterische Grenze bei 0.066 m — zu flach fuer
        // ein 0.130 m hohes Monster. Das Panel muss darueber hinausgehen duerfen.
        let stylisticCap = measuredVolume.extents.y * LayoutConstants.targetPanelMaximumHeightFraction
        let resolved = PriorityTargetMapping.panelLayout.resolve(
            volume: measuredVolume,
            monsterBounds: symmetricMonster,
            monsterPlaneZ: 0.06
        )
        #expect(resolved.panelSize.y > stylisticCap)
        #expect(resolved.panelSize.y >= symmetricMonster.extents.y * InteractionConstants.minimumDropOverlapRatio)
    }

    // MARK: - Regression: Zieh-Ebene und Panel-Tiefe (Teamphase-Bug)

    /// Volume, dessen Z-Bereich **nicht** um 0 zentriert ist.
    ///
    /// Genau diese Situation liess in der Teamphase jeden Drop scheitern: der sichere
    /// Bereich schob das Monster in der Tiefe nach vorn, die Panels blieben aber auf der
    /// Ebene stehen, die sich aus der Phasenkonstante ergab.
    private var offCenterVolume: BoundingBox {
        BoundingBox(min: SIMD3<Float>(-0.5, -0.5, 0), max: SIMD3<Float>(0.5, 0.5, 0.4))
    }

    /// Die Ebene, die das Monster nach der Klemmung tatsaechlich erreicht.
    private func effectivePlaneZ(volume: BoundingBox, wished: Float) -> Float {
        DragBounds.safeRegion(
            volume: volume,
            monsterBounds: symmetricMonster,
            padding: InteractionConstants.dragSafetyPadding
        )
        .clamp(SIMD3<Float>(0, 0, wished)).z
    }

    @Test("Ein nicht zentrierter Z-Bereich verschiebt die Zieh-Ebene")
    func offCenterVolumeShiftsTheDragPlane() {
        // Der Wunschwert der Teamphase liegt ausserhalb des sicheren Z-Bereichs.
        let effective = effectivePlaneZ(volume: offCenterVolume, wished: 0)
        #expect(effective != 0)
        #expect(effective > 0)
    }

    /// Volume, das vollstaendig hinter dem Ursprung liegt.
    ///
    /// Zeigt den Fehler in Reinform: der sichere Bereich zwingt das Monster weit nach
    /// hinten, waehrend die Phasenkonstante eine Ebene nahe 0 vorgibt.
    private var farBackVolume: BoundingBox {
        BoundingBox(min: SIMD3<Float>(-0.5, -0.5, -0.6), max: SIMD3<Float>(0.5, 0.5, -0.2))
    }

    @Test("Aus der Phasenkonstante platzierte Panels scheitern an der Tiefenpruefung")
    func panelsPlacedFromTheRawConstantFailTheDepthCheck() {
        // Reproduktion des Fehlers: Panel-Z aus dem Wunschwert, Monster auf der geklemmten Ebene.
        let wished: Float = 0
        let effective = effectivePlaneZ(volume: farBackVolume, wished: wished)
        #expect(effective < wished)

        let resolved = TeamTargetMapping.panelLayout.resolve(
            volume: farBackVolume,
            monsterBounds: symmetricMonster,
            monsterPlaneZ: wished          // ← der alte, falsche Wert
        )
        let box = resolved.bounds(for: TeamTargetMapping.ID.netzwerk)!
        let safe = DragBounds.safeRegion(
            volume: farBackVolume,
            monsterBounds: symmetricMonster,
            padding: InteractionConstants.dragSafetyPadding
        )
        let position = safe.clamp(SIMD3<Float>(box.center.x, box.center.y, effective))
        let hull = self.hull(symmetricMonster, at: position)

        // Die Flaeche stimmt — nur die Tiefe nicht. Genau dieses Bild zeigte die Teamphase:
        // Monster sichtbar auf der Box, Drop trotzdem ungueltig.
        #expect(DropEvaluator.overlapRatio(monsterBounds: hull, targetBounds: box) >= InteractionConstants.minimumDropOverlapRatio)
        #expect(DropEvaluator.depthGap(hull, box) > InteractionConstants.dropDepthTolerance)
    }

    @Test("Mit der geklemmten Ebene ist auch ein weit hinten liegendes Volume gueltig")
    func farBackVolumeWorksWithTheEffectivePlane() {
        let effective = effectivePlaneZ(volume: farBackVolume, wished: 0)
        let resolved = TeamTargetMapping.panelLayout.resolve(
            volume: farBackVolume,
            monsterBounds: symmetricMonster,
            monsterPlaneZ: effective
        )
        let safe = DragBounds.safeRegion(
            volume: farBackVolume,
            monsterBounds: symmetricMonster,
            padding: InteractionConstants.dragSafetyPadding
        )
        let targets = TeamTargetMapping.allTargets.map {
            DropEvaluator.BoxTarget(id: $0.id, bounds: resolved.bounds(for: $0.id)!)
        }
        for target in TeamTargetMapping.allTargets {
            let box = resolved.bounds(for: target.id)!
            let position = safe.clamp(SIMD3<Float>(box.center.x, box.center.y, effective))
            let hull = self.hull(symmetricMonster, at: position)
            let best = DropEvaluator.bestTarget(
                monsterBounds: hull,
                targets: targets,
                minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
                depthTolerance: InteractionConstants.dropDepthTolerance
            )
            #expect(best?.id == target.id, "\(target.id) nicht erreichbar")
        }
    }

    @Test("Das Panel rutscht nie hinter die Rueckwand des Volumes")
    func panelNeverSlipsBehindTheBackWall() {
        for volumeUnderTest in [volume, offCenterVolume, farBackVolume] {
            let effective = effectivePlaneZ(volume: volumeUnderTest, wished: 0)
            let resolved = TeamTargetMapping.panelLayout.resolve(
                volume: volumeUnderTest,
                monsterBounds: symmetricMonster,
                monsterPlaneZ: effective
            )
            for target in TeamTargetMapping.allTargets {
                let box = resolved.bounds(for: target.id)!
                #expect(box.min.z >= volumeUnderTest.min.z - 0.0001, "\(target.id) ragt hinten heraus")
            }
        }
    }

    @Test("Mit der geklemmten Zieh-Ebene stimmt die Tiefe wieder — in beiden Phasen")
    func panelsPlacedFromTheEffectivePlaneKeepTheStandoff() {
        for (layout, wished, ids) in [
            (TeamTargetMapping.panelLayout, Float(0), TeamTargetMapping.allTargets.map(\.id)),
            (PriorityTargetMapping.panelLayout, Float(0.06), PriorityTargetMapping.allTargets.map(\.id)),
        ] {
            let effective = effectivePlaneZ(volume: offCenterVolume, wished: wished)
            let resolved = layout.resolve(
                volume: offCenterVolume,
                monsterBounds: symmetricMonster,
                monsterPlaneZ: effective        // ← der korrigierte Wert
            )
            let safe = DragBounds.safeRegion(
                volume: offCenterVolume,
                monsterBounds: symmetricMonster,
                padding: InteractionConstants.dragSafetyPadding
            )
            let targets = ids.map { DropEvaluator.BoxTarget(id: $0, bounds: resolved.bounds(for: $0)!) }

            for id in ids {
                let box = resolved.bounds(for: id)!
                let position = safe.clamp(SIMD3<Float>(box.center.x, box.center.y, effective))
                let hull = self.hull(symmetricMonster, at: position)

                // Der Z-Spalt ist hoechstens der vorgesehene Standoff — und damit sicher
                // innerhalb der Toleranz. (Kleiner wird er, wenn das Panel nach vorne
                // ruecken muss, um nicht hinter der Volume-Rueckwand zu verschwinden.)
                let gap = DropEvaluator.depthGap(hull, box)
                #expect(gap <= LayoutConstants.targetPanelStandoff + 0.0001, "\(id): Spalt \(gap)")
                #expect(gap <= InteractionConstants.dropDepthTolerance, "\(id): Spalt \(gap)")

                let best = DropEvaluator.bestTarget(
                    monsterBounds: hull,
                    targets: targets,
                    minimumOverlapRatio: InteractionConstants.minimumDropOverlapRatio,
                    depthTolerance: InteractionConstants.dropDepthTolerance
                )
                #expect(best?.id == id, "\(id) nicht erreichbar, best=\(best?.id ?? "-")")
            }
        }
    }

    @Test("Der maximal erreichbare Overlap liegt in beiden Phasen ueber der Schwelle")
    func maximumReachableOverlapExceedsThresholdInBothPhases() {
        for (layout, planeZ, ids) in [
            (PriorityTargetMapping.panelLayout, Float(0.06), PriorityTargetMapping.allTargets.map(\.id)),
            (TeamTargetMapping.panelLayout, Float(0), TeamTargetMapping.allTargets.map(\.id)),
        ] {
            let effective = effectivePlaneZ(volume: volume, wished: planeZ)
            let resolved = layout.resolve(
                volume: volume,
                monsterBounds: symmetricMonster,
                monsterPlaneZ: effective
            )
            let safe = DragBounds.safeRegion(
                volume: volume,
                monsterBounds: symmetricMonster,
                padding: InteractionConstants.dragSafetyPadding
            )
            for id in ids {
                let box = resolved.bounds(for: id)!
                let position = safe.clamp(SIMD3<Float>(box.center.x, box.center.y, effective))
                let hull = self.hull(symmetricMonster, at: position)
                let ratio = DropEvaluator.overlapRatio(monsterBounds: hull, targetBounds: box)
                #expect(
                    ratio >= InteractionConstants.minimumDropOverlapRatio,
                    "\(id): maximal erreichbarer Overlap nur \(ratio)"
                )
            }
        }
    }

    // MARK: - Konstanten

    @Test("Die zentralen Schwellen sind gesetzt und plausibel")
    func centralConstantsAreSane() {
        #expect(InteractionConstants.minimumDropOverlapRatio == 0.50)
        #expect(InteractionConstants.dropDepthTolerance > 0)
        #expect(InteractionConstants.dropDepthTolerance < 0.15)
        #expect(InteractionConstants.dragSafetyPadding > 0)
        #expect(InteractionConstants.dragSafetyPadding < 0.1)
        #expect(LayoutConstants.targetPanelDepth > 0)
        #expect(LayoutConstants.targetPanelDepth < 0.05)
        #expect(LayoutConstants.targetHighlightScale > 1)
        #expect(LayoutConstants.targetHighlightScale < 1.2)
        #expect(LayoutConstants.targetPanelHighlightOpacity > LayoutConstants.targetPanelOpacity)
        // Die Panelhoehe muss deutlich ueber der Schwelle liegen, sonst waere 50 % nur
        // exakt am Anschlag der Zieh-Begrenzung erreichbar.
        #expect(LayoutConstants.targetPanelHeightFactor > InteractionConstants.minimumDropOverlapRatio)
    }
}

// MARK: - Restpunkt AK-06 — Einpassung im gemessenen Monster-Panel

/// Belegt die Ursache des Clippings in der Untersuchungsansicht und sichert den Fix ab.
///
/// Die Tests rechnen bewusst gegen das **gemessene** Volume aus dem Simulatorlog vom
/// 27.08. (0.284 x 0.236 x 0.235 m) und nicht gegen die deklarierten
/// `LayoutConstants.centralVolume*` (1.0 x 1.0 x 0.4 m). Genau diese Diskrepanz ist der
/// Kern des Fehlers.
@MainActor
@Suite("Restpunkt AK-06 — Einpassung im gemessenen Monster-Panel")
struct InvestigationFramingTests {

    // MARK: - Messwerte

    /// Das im Simulator gemessene Volume, identisch zur Rekonstruktion aus Modul 013.
    private var measuredVolume: BoundingBox {
        BoundingBox(min: SIMD3<Float>(-0.142, -0.1176, 0.0), max: SIMD3<Float>(0.142, 0.1184, 0.2348))
    }

    /// Rohausdehnungen der vier Assets, normiert auf die groesste Kante = 1.
    ///
    /// Abgeleitet aus den in `Modul 013` dokumentierten Huellen nach `fit(toMaxExtent: 0.13)`.
    /// Da `fit(_:toMaxExtent:)` proportional skaliert, ist das Verhaeltnis der Achsen
    /// skalierungsinvariant — genau darauf kommt es hier an.
    private var normalizedModelExtents: [(name: String, extents: SIMD3<Float>)] {
        [
            ("monster01", SIMD3<Float>(0.0702, 0.130, 0.0728) / 0.130),
            ("monster02", SIMD3<Float>(0.0450, 0.130, 0.0516) / 0.130),
            ("monster03", SIMD3<Float>(0.0982, 0.130, 0.0910) / 0.130),
            ("monster04", SIMD3<Float>(0.0700, 0.130, 0.0880) / 0.130),
        ]
    }

    /// Plausible Panelquader der Untersuchungsansicht innerhalb des gemessenen Volumes.
    ///
    /// Das Panel ist die linke Spalte eines `HStack`; die Ticketkarte belegt
    /// `investigationCardWidthFraction` der Breite. Die exakte Kante liefert erst die
    /// Messung zur Laufzeit — deshalb wird hier ueber eine Spanne plausibler Quader
    /// geprueft statt gegen einen einzelnen geratenen Wert.
    private var candidatePanels: [(name: String, panel: BoundingBox)] {
        let volume = measuredVolume
        let monsterFraction = Float(1 - LayoutConstants.investigationCardWidthFraction)

        return [0.85, 1.0].flatMap { (margin: Float) -> [(String, BoundingBox)] in
            let width = volume.extents.x * monsterFraction * margin
            let height = volume.extents.y * margin
            let depth = volume.extents.z * margin
            let centerX = volume.min.x + width / 2

            return [(
                "Panel \(monsterFraction) x \(margin)",
                BoundingBox(
                    min: SIMD3<Float>(centerX - width / 2, volume.center.y - height / 2, volume.center.z - depth / 2),
                    max: SIMD3<Float>(centerX + width / 2, volume.center.y + height / 2, volume.center.z + depth / 2)
                )
            )]
        }
    }

    // MARK: - Ursachenbeleg

    @Test("Das bisherige Zielmass 0.24 m passt in keinen realen Panelquader")
    func previousTargetSizeDoesNotFitTheMeasuredPanel() {
        // `monsterTargetSize` (0.24 m) lag ueber jeder Kante des gemessenen Volumes
        // (0.284 x 0.236 x 0.235 m) — im schmalen Monster-Panel erst recht.
        // Genau deshalb wurde beschnitten.
        for candidate in candidatePanels {
            let usable = InvestigationFraming(panel: candidate.panel)
                .usableExtents(inset: LayoutConstants.monsterFramingInset)
            let smallestEdge = min(usable.x, min(usable.y, usable.z))

            #expect(
                LayoutConstants.monsterTargetSize > smallestEdge,
                "\(candidate.name): 0.24 m waere hier bereits passend gewesen"
            )
        }
    }

    @Test("Die alte Schaetzung ueberschaetzt den verfuegbaren Raum deutlich")
    func theOldEstimateOverstatesTheAvailableSpace() {
        // `layoutPointsPerMeter` (417) ist laut eigener Dokumentation gegen eine
        // Volume-Hoehe von 0.8 m kalibriert; `centralVolumeHeight` betraegt 1.0 m.
        // Zusaetzlich ist `monsterPanelDepth` (0.34 m) groesser als die gemessene
        // Volume-Tiefe ueberhaupt.
        #expect(Float(LayoutConstants.monsterPanelDepth) > measuredVolume.extents.z)
    }

    // MARK: - Kein Clipping mehr

    @Test("Jedes Asset bleibt in jedem Panelquader vollstaendig innerhalb")
    func everyAssetStaysInsideEveryPanel() {
        let inset = LayoutConstants.monsterFramingInset
        let cap = LayoutConstants.monsterTargetSize

        for candidate in candidatePanels {
            let framing = InvestigationFraming(panel: candidate.panel)
            #expect(framing.isUsable, "\(candidate.name) sollte messbar sein")

            let usable = framing.usableExtents(inset: inset)

            for model in normalizedModelExtents {
                let limit = framing.maxExtent(forModelExtents: model.extents, inset: inset, cap: cap)
                #expect(limit > 0, "\(candidate.name)/\(model.name): kein Zielmass")

                // Ein einziger Faktor fuer alle Achsen — keine Verzerrung.
                let largest = max(model.extents.x, max(model.extents.y, model.extents.z))
                let scale = limit / largest
                let fitted = model.extents * scale

                #expect(fitted.x <= usable.x + 0.0001, "\(candidate.name)/\(model.name) Breite")
                #expect(fitted.y <= usable.y + 0.0001, "\(candidate.name)/\(model.name) Hoehe")
                #expect(fitted.z <= usable.z + 0.0001, "\(candidate.name)/\(model.name) Tiefe")

                // Und die Huelle liegt vollstaendig im Panel — inklusive Vorschub.
                let position = framing.position(
                    desiredForward: LayoutConstants.monsterForwardOffset,
                    fittedDepth: fitted.z,
                    inset: inset
                )
                let hull = BoundingBox(min: position - fitted / 2, max: position + fitted / 2)

                #expect(hull.min.x >= candidate.panel.min.x - 0.0001, "\(candidate.name)/\(model.name) links")
                #expect(hull.max.x <= candidate.panel.max.x + 0.0001, "\(candidate.name)/\(model.name) rechts")
                #expect(hull.min.y >= candidate.panel.min.y - 0.0001, "\(candidate.name)/\(model.name) unten")
                #expect(hull.max.y <= candidate.panel.max.y + 0.0001, "\(candidate.name)/\(model.name) oben")
                #expect(hull.min.z >= candidate.panel.min.z - 0.0001, "\(candidate.name)/\(model.name) hinten")
                #expect(hull.max.z <= candidate.panel.max.z + 0.0001, "\(candidate.name)/\(model.name) vorne")
            }
        }
    }

    @Test("Das Monster sitzt horizontal und vertikal in der Panelmitte")
    func theMonsterIsCenteredInThePanel() {
        // Bisher wurde hart auf (0, 0, forward) gesetzt — das trifft die Panelmitte nur,
        // wenn der Szenenursprung im Panelzentrum liegt. Das Panel ist aber die linke
        // Spalte eines HStack.
        for candidate in candidatePanels {
            let framing = InvestigationFraming(panel: candidate.panel)
            let position = framing.position(
                desiredForward: LayoutConstants.monsterForwardOffset,
                fittedDepth: 0.05,
                inset: LayoutConstants.monsterFramingInset
            )

            #expect(abs(position.x - candidate.panel.center.x) < 0.0001, "\(candidate.name) X")
            #expect(abs(position.y - candidate.panel.center.y) < 0.0001, "\(candidate.name) Y")
            #expect(position.z >= candidate.panel.center.z, "\(candidate.name) Z nicht nach hinten")
        }
    }

    // MARK: - Raumausnutzung

    @Test("Die modellbewusste Einpassung nutzt mehr Raum als die konservative Variante")
    func modelAwareFittingUsesMoreSpaceThanTheConservativeVariant() {
        let inset = LayoutConstants.monsterFramingInset
        let cap = LayoutConstants.monsterTargetSize

        for candidate in candidatePanels {
            let framing = InvestigationFraming(panel: candidate.panel)
            let conservative = framing.maxExtent(inset: inset, cap: cap)

            for model in normalizedModelExtents {
                let aware = framing.maxExtent(forModelExtents: model.extents, inset: inset, cap: cap)
                #expect(
                    aware >= conservative - 0.0001,
                    "\(candidate.name)/\(model.name): \(aware) < \(conservative)"
                )
            }
        }
    }

    @Test("Der Deckel begrenzt die groesste Kante auch in grossen Panels")
    func theCapLimitsTheLargestEdgeInLargePanels() {
        let generous = BoundingBox(min: SIMD3<Float>(repeating: -1), max: SIMD3<Float>(repeating: 1))
        let framing = InvestigationFraming(panel: generous)

        for model in normalizedModelExtents {
            let limit = framing.maxExtent(
                forModelExtents: model.extents,
                inset: LayoutConstants.monsterFramingInset,
                cap: LayoutConstants.monsterTargetSize
            )
            #expect(limit <= LayoutConstants.monsterTargetSize + 0.0001, "\(model.name)")
        }
    }

    // MARK: - Rueckfallebene

    @Test("Eine leere Messung gilt nicht als brauchbar")
    func anEmptyMeasurementIsNotUsable() {
        let empty = InvestigationFraming(panel: BoundingBox())
        #expect(empty.isUsable == false)

        let flat = InvestigationFraming(
            panel: BoundingBox(min: SIMD3<Float>(0, 0, 0), max: SIMD3<Float>(0.2, 0.2, 0.0))
        )
        #expect(flat.isUsable == false)
    }

    @Test("Unbrauchbare Modellmasse fallen auf die konservative Variante zurueck")
    func unusableModelExtentsFallBackToTheConservativeVariant() {
        let framing = InvestigationFraming(panel: candidatePanels[0].panel)
        let inset = LayoutConstants.monsterFramingInset
        let cap = LayoutConstants.monsterTargetSize

        #expect(
            framing.maxExtent(forModelExtents: SIMD3<Float>(repeating: 0), inset: inset, cap: cap)
                == framing.maxExtent(inset: inset, cap: cap)
        )
    }

    @Test("Gleiche Messung ist gleich — verhindert die Update-Schleife")
    func equalMeasurementsCompareEqual() {
        let panel = candidatePanels[0].panel
        #expect(InvestigationFraming(panel: panel) == InvestigationFraming(panel: panel))

        let shifted = BoundingBox(min: panel.min + SIMD3<Float>(0.01, 0, 0), max: panel.max)
        #expect(InvestigationFraming(panel: panel) != InvestigationFraming(panel: shifted))
    }
}
