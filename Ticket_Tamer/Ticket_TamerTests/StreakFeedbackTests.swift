import Testing
@testable import Ticket_Tamer

@MainActor
@Suite("Modul 032 — Streak-Feedback v1.3")
struct StreakFeedbackTests {
    @Test("Prioritaet korrekt zeigt plus 100") func t01() { #expect(decision(true, 100).pointsText == "+100 Punkte") }
    @Test("Prioritaet falsch zeigt 0") func t02() { #expect(decision(false, 100).pointsText == "0 Punkte") }
    @Test("Team korrekt mit 100") func t03() { #expect(decision(true, 100).pointsText == "+100 Punkte") }
    @Test("Team korrekt mit 300") func t04() { #expect(decision(true, 300).pointsText == "+300 Punkte") }
    @Test("Team korrekt mit 500") func t05() { #expect(decision(true, 500).pointsText == "+500 Punkte") }
    @Test("Team korrekt mit 700") func t06() { #expect(decision(true, 700).pointsText == "+700 Punkte") }
    @Test("Team korrekt mit 900") func t07() { #expect(decision(true, 900).pointsText == "+900 Punkte") }
    @Test("Team falsch ignoriert uebergebene Punkte") func t08() { #expect(decision(false, 900).awardedPoints == 0) }
    @Test("Presentation mutiert Score nicht") func t09() { let m = SessionModel(); let score = m.score; _ = decision(true, 300); #expect(m.score == score) }
    @Test("Presentation braucht keine Referenzwerte") func t10() { #expect(DecisionFeedbackPresentation(evaluation: true, awardedPoints: 300) != nil) }

    @Test("Streak 0 unsichtbar") func t11() { #expect(!streak(true, 0).isVisible) }
    @Test("Streak 1 unsichtbar") func t12() { #expect(!streak(true, 1).isVisible) }
    @Test("Streak 2 normal") func t13() { let p = streak(true, 2); #expect(p.isVisible && p.text == "x2" && p.emphasis == .normal) }
    @Test("Streak 3 normal") func t14() { let p = streak(true, 3); #expect(p.isVisible && p.text == "x3" && p.emphasis == .normal) }
    @Test("Streak 4 emphasized") func t15() { let p = streak(true, 4); #expect(p.isVisible && p.text == "x4" && p.emphasis == .emphasized) }
    @Test("Streak 5 emphasized") func t16() { let p = streak(true, 5); #expect(p.isVisible && p.text == "x5" && p.emphasis == .emphasized) }
    @Test("Streak 16 emphasized") func t17() { let p = streak(true, 16); #expect(p.isVisible && p.text == "x16" && p.emphasis == .emphasized) }
    @Test("Streak hat keinen Cap") func t18() { #expect(streak(true, 10_000).text == "x10000") }
    @Test("Nicht voll korrekt bleibt unsichtbar") func t19() { #expect(!streak(false, 4).isVisible) }
    @Test("Prioritaetskontext bleibt unsichtbar") func t20() { #expect(!StreakFeedbackPresentation(fullyCorrect: true, streak: 4, context: .priorityDecision).isVisible) }

    @Test("Streak 0 spielt keinen Sound") func t21() { #expect(!streak(true, 0).shouldPlaySound) }
    @Test("Streak 1 spielt keinen Sound") func t22() { #expect(!streak(true, 1).shouldPlaySound) }
    @Test("Streak 2 nutzt Sound 01") func t23() { #expect(streak(true, 2).shouldPlaySound && StreakSoundCatalog.resource(forStreak: 2) == StreakSoundCatalog.sound01) }
    @Test("Streak 3 nutzt Sound 01") func t24() { #expect(streak(true, 3).shouldPlaySound && StreakSoundCatalog.resource(forStreak: 3) == StreakSoundCatalog.sound01) }
    @Test("Streak 4 nutzt Sound 02") func t25() { #expect(streak(true, 4).shouldPlaySound && StreakSoundCatalog.resource(forStreak: 4) == StreakSoundCatalog.sound02) }
    @Test("Streak 5 nutzt Sound 02") func t26() { #expect(streak(true, 5).shouldPlaySound && StreakSoundCatalog.resource(forStreak: 5) == StreakSoundCatalog.sound02) }
    @Test("Partial spielt keinen Streaksound") func t27() { #expect(!streak(false, 5).shouldPlaySound) }
    @Test("Prioritaet spielt keinen Streaksound") func t28() { #expect(!StreakFeedbackPresentation(fullyCorrect: true, streak: 5, context: .priorityDecision).shouldPlaySound) }
    @Test("Ein Snapshot liefert genau eine Soundentscheidung") func t29() { let p = team(true, 300, true, 2); #expect(p.streak.shouldPlaySound) }

    @Test("Monsterfeedback bleibt correct") func t30() { #expect(team(true, 300, true, 2).decision.result == .correct) }
    @Test("Streaksound folgt nur qualifiziert") func t31() { #expect(!team(true, 100, false, 0).streak.shouldPlaySound) }
    @Test("Zweite Teamauswertung ist No Op") func t32() { let m = evaluatedModel(); let before = m.score; #expect(m.evaluateTeam() == nil); #expect(m.score == before) }
    @Test("Feedbackdauer bleibt 1 Komma 5") func t33() { #expect(FeedbackConstants.streakSoundDelay + FeedbackConstants.remainingDelayAfterStreakSound == FeedbackConstants.feedbackTransitionDelay) }
    @Test("Sounddelay ist kleiner als Gesamtzeit") func t34() { #expect(FeedbackConstants.streakSoundDelay < FeedbackConstants.feedbackTransitionDelay) }
    @Test("Restdelay ist nicht negativ") func t35() { #expect(FeedbackConstants.remainingDelayAfterStreakSound >= 0) }

    @Test("Snapshot verwendet letzte Teampunkte") func t36() { let m = evaluatedModel(); #expect(team(true, m.lastTeamAwardedPoints, m.lastCompletedTicketWasFullyCorrect, m.lastCompletedTicketStreak).decision.awardedPoints == m.lastTeamAwardedPoints) }
    @Test("Snapshot verwendet resultierende Streak 2") func t37() { #expect(team(true, 300, true, 2).streak.text == "x2") }
    @Test("Fully Correct ist Gate") func t38() { #expect(!team(true, 300, false, 2).streak.isVisible) }
    @Test("Team korrekt nach falscher Prioritaet") func t39() { let p = team(true, 100, false, 0); #expect(p.decision.pointsText == "+100 Punkte" && !p.streak.isVisible) }
    @Test("Team falsch nach richtiger Prioritaet") func t40() { let p = team(false, 0, false, 0); #expect(p.decision.pointsText == "0 Punkte" && !p.streak.isVisible) }

    @Test("HUD-Inhalt bleibt ohne Streak") func t41() { let h = SessionHUDContent(currentTicketIndex: 0, totalTicketCount: 3, phase: .teamZuordnen); #expect(h.currentTicketNumber == 1 && h.phaseTitle == "Team zuordnen") }
    @Test("HUD-Inhalt bleibt ohne Score") func t42() { let h = SessionHUDContent(currentTicketIndex: 0, totalTicketCount: 3, phase: .teamZuordnen); #expect(h.totalTicketCount == 3 && h.progress == 1.0 / 3.0) }
    @Test("Streakpresentation ist separat") func t43() { #expect(streak(true, 2).text == "x2") }

    @Test("Accessibility nennt 300 Punkte") func t44() { #expect(decision(true, 300).accessibilityText.contains("300 Punkte")) }
    @Test("Accessibility nennt 500 Punkte") func t45() { #expect(decision(true, 500).accessibilityText.contains("500 Punkte")) }
    @Test("x2 Accessibility ist verstaendlich") func t46() { #expect(streak(true, 2).accessibilityText.contains("2")) }
    @Test("x4 Accessibility ist verstaendlich") func t47() { #expect(streak(true, 4).accessibilityText.contains("4")) }
    @Test("Accessibility nennt keine Loesung") func t48() { let s = decision(true, 300).accessibilityText.lowercased(); #expect(!s.contains("netzwerk") && !s.contains("kritisch")) }

    @Test("Resultscore bleibt Punkteformat") func t49() { #expect(ResultPresentation.scoreText(for: 1200) == "1200 Punkte") }
    @Test("Videozustand aendert Feedback nicht") func t50() { let p = team(true, 300, true, 2); _ = TicketVideoPresentationState(); #expect(p.decision.awardedPoints == 300) }
    @Test("Teamlogos bleiben vier") func t51() { #expect(SupportTeam.allCases.count == 4) }
    @Test("Dropgeometrie bleibt 50 Prozent") func t52() { #expect(InteractionConstants.minimumDropOverlapRatio == 0.5) }
    @Test("Monster Soundgruppen bleiben unveraendert") func t53() { #expect(MonsterFeedbackSoundCatalog.correct.count == 4 && MonsterFeedbackSoundCatalog.incorrect.count == 4) }
    @Test("Scoringsequenz bleibt 1200") func t54() { let m = model(3); play(m); play(m); play(m, complete: false); #expect(m.score == 1_200) }

    private func decision(_ evaluation: Bool, _ points: Int) -> DecisionFeedbackPresentation {
        DecisionFeedbackPresentation(evaluation: evaluation, awardedPoints: points)!
    }

    private func streak(_ fullyCorrect: Bool, _ value: Int) -> StreakFeedbackPresentation {
        StreakFeedbackPresentation(fullyCorrect: fullyCorrect, streak: value, context: .teamCompletion)
    }

    private func team(_ evaluation: Bool, _ points: Int, _ fullyCorrect: Bool, _ value: Int) -> TeamFeedbackPresentation {
        TeamFeedbackPresentation(evaluation: evaluation, awardedPoints: points, fullyCorrect: fullyCorrect, resultingStreak: value)!
    }

    private func model(_ count: Int) -> SessionModel {
        let m = SessionModel(); m.setTicketCount(count); m.startSession(using: { $0 }); return m
    }

    private func evaluatedModel() -> SessionModel {
        let m = model(1); play(m, complete: false); return m
    }

    private func play(_ m: SessionModel, complete: Bool = true) {
        m.beginPrioritizationPhase(); m.savePriority(m.currentTicket!.referencePriority); _ = m.evaluatePriority()
        m.beginTeamAssignmentPhase(); m.saveTeam(m.currentTicket!.referenceTeam); _ = m.evaluateTeam()
        if complete { m.completeTicketAfterTeamFeedback() }
    }
}
