import Testing
@testable import Ticket_Tamer

@MainActor
@Suite("Modul 031 — Streak-State und Scoring")
struct StreakScoringTests {
    @Test("Neues Modell startet mit Streak 0") func initialStreak() { #expect(SessionModel().streak == 0) }
    @Test("Sitzungsstart setzt Streak 0") func sessionStartResetsStreak() { let m = model(2); play(m); m.startSession(using: { $0 }); #expect(m.streak == 0) }
    @Test("Reset setzt Streak 0") func resetStreak() { let m = model(1); play(m, complete: false); m.reset(); #expect(m.streak == 0) }
    @Test("Prioritaetsergebnis ist initial nil") func initialPriorityResult() { #expect(SessionModel().currentPriorityWasCorrect == nil) }
    @Test("Reset loescht Prioritaetsergebnis") func resetPriorityResult() { let m = model(1); evaluatePriority(m, correct: true); m.reset(); #expect(m.currentPriorityWasCorrect == nil) }

    @Test("Richtige Prioritaet gibt 100") func correctPriorityCredit() { let m = model(1); evaluatePriority(m, correct: true); #expect(m.score == 100) }
    @Test("Richtige Prioritaet wird gespeichert") func correctPriorityStored() { let m = model(1); evaluatePriority(m, correct: true); #expect(m.currentPriorityWasCorrect == true) }
    @Test("Falsche Prioritaet gibt 0") func wrongPriorityCredit() { let m = model(1); evaluatePriority(m, correct: false); #expect(m.score == 0) }
    @Test("Falsche Prioritaet wird gespeichert") func wrongPriorityStored() { let m = model(1); evaluatePriority(m, correct: false); #expect(m.currentPriorityWasCorrect == false) }
    @Test("Falsche Prioritaet unterbricht Streak") func wrongPriorityBreaksStreak() { let m = model(2); play(m); evaluatePriority(m, correct: false); #expect(m.streak == 0) }
    @Test("Prioritaet wird genau einmal bewertet") func priorityExactlyOnce() { let m = model(1); evaluatePriority(m, correct: true); let before = (m.score, m.streak, m.currentPriorityWasCorrect); #expect(m.evaluatePriority() == nil); #expect(m.score == before.0); #expect(m.streak == before.1); #expect(m.currentPriorityWasCorrect == before.2) }

    @Test("Erstes korrektes Ticket ergibt 200 und Streak 1") func firstCorrect() { let m = model(1); let delta = play(m, complete: false); #expect(delta == 200); #expect(m.streak == 1) }
    @Test("Zweites korrektes Ticket ergibt 400 und Streak 2") func secondCorrect() { let m = model(2); play(m); let delta = play(m, complete: false); #expect(delta == 400); #expect(m.streak == 2) }
    @Test("Drittes korrektes Ticket ergibt 600 und Streak 3") func thirdCorrect() { let m = model(3); play(m); play(m); let delta = play(m, complete: false); #expect(delta == 600); #expect(m.streak == 3) }
    @Test("Viertes korrektes Ticket ergibt 800 und Streak 4") func fourthCorrect() { let m = model(4); play(m); play(m); play(m); let delta = play(m, complete: false); #expect(delta == 800); #expect(m.streak == 4) }
    @Test("Streak 2 vergibt 300 Teampunkte") func streakTwoTeamCredit() { let m = model(2); play(m); play(m, complete: false); #expect(m.lastTeamAwardedPoints == 300) }
    @Test("Streak 3 vergibt 500 Teampunkte") func streakThreeTeamCredit() { let m = model(3); play(m); play(m); play(m, complete: false); #expect(m.lastTeamAwardedPoints == 500) }
    @Test("Streak 4 vergibt 700 Teampunkte") func streakFourTeamCredit() { let m = model(4); play(m); play(m); play(m); play(m, complete: false); #expect(m.lastTeamAwardedPoints == 700) }
    @Test("Ticketgesamtwert folgt 200 mal n") func generalFormula() { for n in 1...30 { #expect(100 + SessionModel.teamCredit(forCompletedTicketAtStreak: n) == 200 * n) } }

    @Test("Nur Prioritaet richtig ergibt 100 und Streak 0") func onlyPriorityCorrect() { let m = model(1); #expect(play(m, priorityCorrect: true, teamCorrect: false, complete: false) == 100); #expect(m.streak == 0) }
    @Test("Nur Team richtig ergibt 100 und Streak 0") func onlyTeamCorrect() { let m = model(1); #expect(play(m, priorityCorrect: false, teamCorrect: true, complete: false) == 100); #expect(m.streak == 0) }
    @Test("Beide falsch ergeben 0 und Streak 0") func bothWrong() { let m = model(1); #expect(play(m, priorityCorrect: false, teamCorrect: false, complete: false) == 0); #expect(m.streak == 0) }
    @Test("Teilkorrekt verwendet keinen Multiplikator") func partialHasNoMultiplier() { let m = model(3); play(m); play(m); #expect(play(m, priorityCorrect: true, teamCorrect: false, complete: false) == 100) }
    @Test("Fehler nach laufender Streak setzt 0") func errorAfterStreak() { let m = model(3); play(m); play(m); play(m, priorityCorrect: true, teamCorrect: false, complete: false); #expect(m.streak == 0) }
    @Test("Nach Unterbrechung beginnt Streak wieder bei 1") func restartAfterBreak() { let m = model(4); play(m); play(m, priorityCorrect: false, teamCorrect: true); play(m, complete: false); #expect(m.streak == 1) }

    @Test("Team wird genau einmal fuer Streak bewertet") func teamStreakExactlyOnce() { let m = model(1); play(m, complete: false); #expect(m.evaluateTeam() == nil); #expect(m.streak == 1) }
    @Test("Teamcredit wird genau einmal vergeben") func teamCreditExactlyOnce() { let m = model(1); play(m, complete: false); let score = m.score; _ = m.evaluateTeam(); #expect(m.score == score) }
    @Test("Schnelle Mehrfachauswertung bleibt No-Op") func rapidDuplicateEvaluation() { let m = model(1); evaluatePriority(m, correct: true); _ = m.evaluatePriority(); beginTeam(m); _ = m.evaluateTeam(); let before = m.score; _ = m.evaluateTeam(); #expect(m.score == before) }
    @Test("Score bleibt nichtnegativ") func scoreNonnegative() { let m = model(1); play(m, priorityCorrect: false, teamCorrect: false, complete: false); #expect(m.score >= 0) }
    @Test("Streak-Unterbrechung zieht keine Punkte ab") func breakDoesNotRemovePoints() { let m = model(2); play(m); let before = m.score; play(m, priorityCorrect: false, teamCorrect: false, complete: false); #expect(m.score == before) }

    @Test("Fuenf korrekte Tickets erreichen Streak 5") func fiveTicketStreak() { let m = model(5); for index in 0..<5 { play(m, complete: index < 4) }; #expect(m.streak == 5) }
    @Test("Sechzehn korrekte Tickets erreichen Streak 16") func sixteenTicketStreak() { let m = model(16); for index in 0..<16 { play(m, complete: index < 15) }; #expect(m.streak == 16) }
    @Test("Scoringfunktion besitzt oberhalb 16 keinen Cap") func noArtificialCap() { #expect(SessionModel.teamCredit(forCompletedTicketAtStreak: 20) == 3_900) }

    @Test("Drei korrekte Tickets ergeben 1200") func sequenceAllCorrect() { let m = model(3); play(m); play(m); play(m, complete: false); #expect(m.score == 1_200) }
    @Test("Korrekt teilkorrekt korrekt ergibt 500") func sequenceWithTeamError() { let m = model(3); play(m); play(m, priorityCorrect: true, teamCorrect: false); play(m, complete: false); #expect(m.score == 500) }
    @Test("Nur Team korrekt danach korrekt ergibt 300") func sequenceWithPriorityError() { let m = model(2); play(m, priorityCorrect: false, teamCorrect: true); play(m, complete: false); #expect(m.score == 300) }
    @Test("Ergebnisscore entspricht Ticket-Summe") func resultIsExactSum() { let m = model(3); let a = play(m); let b = play(m); let c = play(m, complete: false); #expect(m.score == a + b + c) }

    @Test("Naechstes Ticket loescht Prioritaetsergebnis") func nextTicketClearsPriorityResult() { let m = model(2); play(m); #expect(m.currentPriorityWasCorrect == nil) }
    @Test("Neue Sitzung loescht laufende Streak") func newSessionClearsStreak() { let m = model(1); play(m, complete: false); m.startSession(using: { $0 }); #expect(m.streak == 0) }
    @Test("Replay-Reset loescht laufende Streak") func replayClearsStreak() { let m = model(1); play(m, complete: false); m.reset(); #expect(m.streak == 0) }
    @Test("Videopraesentationszustand beeinflusst Streak nicht") func videoStateDoesNotAffectStreak() { let m = model(1); play(m, complete: false); _ = TicketVideoPresentationState(); #expect(m.streak == 1) }
    @Test("Monster-Retry beeinflusst Streak nicht") func retryDoesNotAffectStreak() { let m = model(1); play(m, complete: false); var recovery = MonsterLoadRecovery(); _ = recovery.begin(assetID: AssetKeys.Monster.monster01); recovery.finishWithFailure(); #expect(m.streak == 1) }

    @Test("Streak 1 uebergibt 100 Teampunkte") func metadataStreakOne() { let m = model(1); play(m, complete: false); #expect(m.lastTeamAwardedPoints == 100) }
    @Test("Streak 2 uebergibt 300 Teampunkte") func metadataStreakTwo() { let m = model(2); play(m); play(m, complete: false); #expect(m.lastTeamAwardedPoints == 300) }
    @Test("Streak 3 uebergibt 500 Teampunkte") func metadataStreakThree() { let m = model(3); play(m); play(m); play(m, complete: false); #expect(m.lastTeamAwardedPoints == 500) }
    @Test("Nur Team korrekt uebergibt 100 und nicht vollstaendig korrekt") func metadataPartial() { let m = model(1); play(m, priorityCorrect: false, teamCorrect: true, complete: false); #expect(m.lastTeamAwardedPoints == 100); #expect(!m.lastCompletedTicketWasFullyCorrect); #expect(m.lastCompletedTicketStreak == 0) }
    @Test("Falsches Team uebergibt 0") func metadataWrongTeam() { let m = model(1); play(m, priorityCorrect: true, teamCorrect: false, complete: false); #expect(m.lastTeamAwardedPoints == 0) }
    @Test("Zweite Teambewertung laesst Uebergabedaten stabil") func metadataExactlyOnce() { let m = model(1); play(m, complete: false); let before = (m.lastTeamAwardedPoints, m.lastCompletedTicketWasFullyCorrect, m.lastCompletedTicketStreak); _ = m.evaluateTeam(); #expect(m.lastTeamAwardedPoints == before.0); #expect(m.lastCompletedTicketWasFullyCorrect == before.1); #expect(m.lastCompletedTicketStreak == before.2) }

    private func model(_ count: Int) -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(count)
        model.startSession(using: { $0 })
        return model
    }

    private func evaluatePriority(_ model: SessionModel, correct: Bool) {
        model.beginPrioritizationPhase()
        let ticket = model.currentTicket!
        let priority = correct ? ticket.referencePriority : TicketPriority.allCases.first { $0 != ticket.referencePriority }!
        model.savePriority(priority)
        _ = model.evaluatePriority()
    }

    private func beginTeam(_ model: SessionModel, correct: Bool = true) {
        model.beginTeamAssignmentPhase()
        let ticket = model.currentTicket!
        let team = correct ? ticket.referenceTeam : SupportTeam.allCases.first { $0 != ticket.referenceTeam }!
        model.saveTeam(team)
    }

    @discardableResult
    private func play(
        _ model: SessionModel,
        priorityCorrect: Bool = true,
        teamCorrect: Bool = true,
        complete: Bool = true
    ) -> Int {
        let scoreBefore = model.score
        evaluatePriority(model, correct: priorityCorrect)
        beginTeam(model, correct: teamCorrect)
        _ = model.evaluateTeam()
        let delta = model.score - scoreBefore
        if complete { model.completeTicketAfterTeamFeedback() }
        return delta
    }
}
