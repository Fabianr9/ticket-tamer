import Foundation
import Observation

// MARK: - Session Model

/// Zentraler, ausschließlich im Arbeitsspeicher gehaltener Sitzungszustand.
///
/// Dies ist die **einzige** Quelle der Wahrheit für den aktuellen Spielzustand (SPEC F-04, F-16).
/// Keine zweite, parallele Datenstruktur darf denselben Zustand abbilden.
///
/// Alle Felder sind `private(set)` – Folgemodule mutieren den Zustand ausschließlich
/// über die bereitgestellten Methoden.
@Observable
@MainActor
final class SessionModel {

    // MARK: - Sitzungsfelder

    /// Gewählte Ticketanzahl für die nächste Sitzung.
    ///
    /// Liegt immer im Bereich `GameplayConstants.minimumTicketCount...GameplayConstants.maximumTicketCount`.
    /// Setzen über `setTicketCount(_:)` – nicht direkt, um den Gültigkeitsbereich zu erzwingen.
    private(set) var selectedTicketCount: Int = GameplayConstants.defaultTicketCount

    /// Die zufällig ausgewählten Tickets der laufenden Sitzung.
    ///
    /// Leer vor dem ersten `startSession()`-Aufruf und nach jedem `reset()`.
    private(set) var sessionTickets: [Ticket] = []

    /// Genau eine beim Sitzungsstart gewaehlte konkrete Farbvariante je Sitzungsticket.
    private(set) var selectedMonsterVariantByTicketID: [Ticket.ID: MonsterAssetVariant] = [:]

    /// Index des aktuell betrachteten Tickets innerhalb von `sessionTickets`.
    ///
    /// Startet beim Sitzungsbeginn bei 0. Am Ende der Liste bleibt der Index beim
    /// letzten gültigen Index (Klemm-Semantik, kein Wrap-around, kein Überlauf).
    private(set) var currentTicketIndex: Int = 0

    /// Aktuelle Spielphase laut SPEC-Phasendefinition.
    ///
    /// Startet bei `.start`, wechselt beim Sitzungsbeginn auf `.untersuchen` und
    /// kehrt nach einem Reset zu `.start` zurück.
    private(set) var currentPhase: GamePhase = .start

    /// Punktestand der laufenden Sitzung.
    ///
    /// Wird in diesem Modul noch nicht vergeben; Bewertungslogik folgt ab Modul 006.
    /// Vorhanden, weil der vollständige Reset auf 0 einen klaren Startwert benötigt.
    private(set) var score: Int = 0

    /// Vom Spieler gewählte Priorität für das aktuelle Ticket.
    ///
    /// `nil`, solange keine Prioritätswahl getroffen wurde oder nach einem Reset.
    private(set) var selectedPriority: TicketPriority? = nil

    /// Vom Spieler gewähltes Support-Team für das aktuelle Ticket.
    ///
    /// `nil`, solange keine Teamwahl getroffen wurde oder nach einem Reset.
    private(set) var selectedTeam: SupportTeam? = nil

    /// Gibt an, ob Eingaben momentan gesperrt sind (z. B. während eines Übergangsanimation).
    ///
    /// Vorhanden, weil AK-16 einen vollständigen Reset der Eingabesperre verlangt.
    /// Das tatsächliche Sperren und Entsperren folgt in späteren Modulen.
    private(set) var isInputLocked: Bool = false

    // MARK: - Init

    init() {}

    // MARK: - Ticketanzahl

    /// Setzt die gewünschte Ticketanzahl für die nächste Sitzung.
    ///
    /// Technisch ungültige Werte (< 1 oder > 16) werden defensiv auf den erlaubten Bereich begrenzt,
    /// damit keine Sitzung mit zu wenigen oder zu vielen Tickets entstehen kann (SPEC F-04).
    /// Die sichtbare Reglerbindung gehört erst zu Modul 004.
    ///
    /// - Parameter count: Gewünschte Anzahl. Werte außerhalb von 1–16 werden begrenzt.
    func setTicketCount(_ count: Int) {
        // Explizites Klemmen statt Magic Numbers: Grenzen kommen aus GameplayConstants.
        let clamped = max(
            GameplayConstants.minimumTicketCount,
            min(count, GameplayConstants.maximumTicketCount)
        )
        selectedTicketCount = clamped
        DebugManager.log(.state, "Ticketanzahl gesetzt: \(clamped)")
    }

    // MARK: - Sitzungsstart

    /// Startet eine neue Sitzung mit der aktuell gewählten Ticketanzahl (SPEC F-04, AK-04).
    ///
    /// Ablauf:
    /// 1. `LocalTicketCatalog.allTickets` wird über `shuffle` gemischt.
    /// 2. Die ersten `selectedTicketCount` Einträge des Ergebnisses werden übernommen.
    /// 3. Fuer jedes Sitzungsticket wird genau eine konkrete Monster-Variante gespeichert.
    /// 4. Index, Phase, Punkte, Entscheidungen und Eingabesperre werden zurückgesetzt.
    ///
    /// Da `shuffle` als Parameter übergeben wird, können Tests eine deterministische
    /// Funktion injizieren, ohne komplexe Abhängigkeiten einzuführen.
    /// Diese minimale Testnaht ist die einzige Abweichung vom sonst direkten Methodenstil.
    ///
    /// - Parameters:
    ///   - shuffle: Funktion, die `[Ticket]` mischt und zurückgibt.
    ///     Standard ist echter Zufall via `Array.shuffled()`.
    ///   - variantSelector: Injizierbare Auswahl aus den vier Varianten des Monstertyps.
    ///     Standard ist `randomElement()`; Tests koennen eine feste Auswahl vorgeben.
    func startSession(
        using shuffle: ([Ticket]) -> [Ticket] = { $0.shuffled() },
        variantSelector: ([MonsterAssetVariant]) -> MonsterAssetVariant? = { $0.randomElement() }
    ) {
        let shuffled = shuffle(LocalTicketCatalog.allTickets)
        // Defensiv begrenzen: sollte der Katalog je kleiner als selectedTicketCount sein,
        // entstehen keine ungültigen Array-Zugriffe.
        let count = min(selectedTicketCount, shuffled.count)
        sessionTickets = Array(shuffled.prefix(count))
        selectedMonsterVariantByTicketID = Dictionary(
            uniqueKeysWithValues: sessionTickets.compactMap { ticket in
                let available = MonsterVariantCatalog.variants(for: ticket.monsterAssetId)
                guard let selected = variantSelector(available), available.contains(selected) else {
                    DebugManager.log(.spawning, "Keine gueltige Variante fuer \(ticket.monsterAssetId)")
                    return nil
                }
                DebugManager.log(.spawning, "Variante gewaehlt: \(ticket.id) → \(selected.assetFileName)")
                return (ticket.id, selected)
            }
        )
        currentTicketIndex = 0
        currentPhase = .untersuchen
        score = 0
        selectedPriority = nil
        selectedTeam = nil
        isInputLocked = false
        priorityEvaluated = false
        teamEvaluated = false
        DebugManager.log(.state, "Sitzung gestartet: \(count) Ticket(s), Phase: untersuchen")
    }

    // MARK: - Ticketzugriff

    /// Das aktuell betrachtete Ticket oder `nil`, wenn keine Sitzung aktiv ist
    /// oder der Index außerhalb der Grenzen liegt.
    ///
    /// Greift nie mit einem ungültigen Index auf `sessionTickets` zu.
    var currentTicket: Ticket? {
        guard !sessionTickets.isEmpty,
              sessionTickets.indices.contains(currentTicketIndex) else {
            return nil
        }
        return sessionTickets[currentTicketIndex]
    }

    /// Liefert ausschliesslich die beim Sitzungsstart gespeicherte Variante.
    /// Ein fehlendes Mapping loest niemals eine spaete Neuauswahl aus.
    func selectedMonsterVariant(for ticket: Ticket) -> MonsterAssetVariant? {
        selectedMonsterVariantByTicketID[ticket.id]
    }

    // MARK: - Indexfortschaltung

    /// Schaltet auf das nächste Ticket weiter.
    ///
    /// **Endsemantik (Klemm-Semantik):** Ist `currentTicketIndex` bereits beim letzten Ticket,
    /// bleibt er dort stehen – kein Wrap-around, kein Überlauf, kein Absturz.
    /// Die aufrufende Schicht (ab Modul 006) entscheidet, ob ein Phasenwechsel folgt.
    /// Eine Indexfortschaltung bei leerer Sitzung ist ein No-Op.
    func advanceToNextTicket() {
        guard !sessionTickets.isEmpty else { return }
        let lastIndex = sessionTickets.count - 1
        if currentTicketIndex < lastIndex {
            currentTicketIndex += 1
            DebugManager.log(.state, "Ticketindex vorgerückt: \(currentTicketIndex)")
        } else {
            // An letzter Position: kein Wrap-around. Dokumentierte Klemm-Semantik.
            DebugManager.log(.state, "Ticketindex an letzter Position (\(currentTicketIndex)), kein Vorruecken")
        }
    }

    // MARK: - Phasenwechsel Modul 006 (F-06 / F-07 / AK-07)

    /// Wechselt von der Untersuchungsphase in die Priorisierungsphase desselben Tickets.
    ///
    /// Vorbedingung: `currentPhase == .untersuchen`.
    /// Verstöße gegen die Vorbedingung werden als No-Op behandelt – kein Absturz, kein Zustandsbruch.
    ///
    /// Garantien:
    /// - Ändert ausschließlich `currentPhase`.
    /// - `currentTicketIndex` bleibt unverändert.
    /// - `selectedPriority` und `selectedTeam` bleiben `nil`.
    /// - `score` bleibt unverändert.
    func beginPrioritizationPhase() {
        guard currentPhase == .untersuchen else {
            DebugManager.log(.state, "beginPrioritizationPhase ignoriert: Phase ist \(currentPhase), erwartet .untersuchen")
            return
        }
        currentPhase = .priorisieren
        DebugManager.log(.state, "Phase gewechselt: untersuchen -> priorisieren, Ticketindex: \(currentTicketIndex)")
    }

    // MARK: - Eingabesperre (Modul 007 — F-10 / AK-10)

    /// Sperrt Eingaben, wenn sie noch nicht gesperrt sind.
    ///
    /// No-Op, wenn `isInputLocked` bereits `true` ist (verhindert Mehrfachauswertung).
    /// Verändert weder `score` noch `currentPhase` noch `selectedPriority` noch `selectedTeam`.
    func lockInput() {
        guard !isInputLocked else {
            DebugManager.log(.state, "lockInput ignoriert: bereits gesperrt")
            return
        }
        isInputLocked = true
        DebugManager.log(.state, "Input gesperrt (isInputLocked = true)")
    }

    /// Entsperrt die Eingabe für den nächsten Phasenaufbau.
    ///
    /// Wird von Modul 008 / 009 beim Aufbau des nächsten Tickets verwendet.
    /// Verändert weder `score` noch `currentPhase` noch `selectedPriority` noch `selectedTeam`.
    func unlockInput() {
        isInputLocked = false
        DebugManager.log(.state, "Input freigegeben (isInputLocked = false)")
    }

    // MARK: - Prioritätsentscheidung (Modul 008 — F-08 / AK-08 / AK-10)

    /// Speichert genau eine Prioritätsentscheidung für das aktuelle Ticket.
    ///
    /// Vorbedingungen (alle müssen erfüllt sein, sonst No-Op):
    /// - `currentPhase == .priorisieren`
    /// - `selectedPriority == nil` (noch keine Entscheidung getroffen)
    /// - `isInputLocked == false`
    ///
    /// Nach erfolgreicher Speicherung:
    /// - `selectedPriority` enthält die übergebene Priorität.
    /// - `isInputLocked == true`.
    /// - `score`, `selectedTeam`, `currentTicketIndex` und `currentPhase` bleiben unverändert.
    ///
    /// Kapselt Speicherung und Lock atomisch, damit die aufrufende View beides
    /// nicht separat auslösen muss (verhindert Rasse zwischen Drop-Auswertung und Lock).
    ///
    /// - Parameter priority: Die zu speichernde Priorität.
    func savePriority(_ priority: TicketPriority) {
        guard currentPhase == .priorisieren else {
            DebugManager.log(.state, "savePriority ignoriert: Phase ist \(currentPhase), erwartet .priorisieren")
            return
        }
        guard selectedPriority == nil else {
            DebugManager.log(.state, "savePriority ignoriert: Prioritaet bereits gesetzt (\(selectedPriority!.rawValue))")
            return
        }
        guard !isInputLocked else {
            DebugManager.log(.state, "savePriority ignoriert: Input bereits gesperrt")
            return
        }
        selectedPriority = priority
        lockInput()
        DebugManager.log(.state, "Prioritaet gespeichert: \(priority.rawValue), isInputLocked=true")
    }

    // MARK: - Teamzuordnungsphase (Modul 009 — F-09 / AK-09 / AK-10)

    /// Wechselt kontrolliert von der Priorisierungs- in die Teamzuordnungsphase.
    ///
    /// Vorbedingungen (beide müssen erfüllt sein, sonst No-Op):
    /// - `currentPhase == .priorisieren`
    /// - `selectedPriority != nil`
    ///
    /// Effekte:
    /// - `currentPhase = .teamZuordnen`
    /// - `isInputLocked = false` (Input für neue Teamentscheidung freigegeben)
    ///
    /// Unverändert: `score`, `currentTicketIndex`, `currentTicket`, `selectedPriority`, `selectedTeam`.
    ///
    /// **Verwendung:** Unit-Tests, SwiftUI-Preview, `#if DEBUG`-Entwicklungsweg.
    /// Darf im normalen Release-Spielablauf (Modul 009) **nicht** automatisch aufgerufen werden.
    /// Modul 010 übernimmt den zeitgesteuerten Übergang gemäß F-13.
    func beginTeamAssignmentPhase() {
        guard currentPhase == .priorisieren else {
            DebugManager.log(.state, "beginTeamAssignmentPhase ignoriert: Phase ist \(currentPhase), erwartet .priorisieren")
            return
        }
        guard selectedPriority != nil else {
            DebugManager.log(.state, "beginTeamAssignmentPhase ignoriert: keine Prioritaet gespeichert")
            return
        }
        currentPhase = .teamZuordnen
        // Input kontrolliert freigeben.
        // selectedTeam ist nil — kein View-Refresh kann diesen Unlock nach
        // gespeichertem Team erneut auslösen (saveTeam sperrt danach definitiv).
        isInputLocked = false
        DebugManager.log(.state, "Phase gewechselt: priorisieren -> teamZuordnen, Input freigegeben, Ticketindex: \(currentTicketIndex)")
    }

    /// Speichert genau eine Teamentscheidung für das aktuelle Ticket.
    ///
    /// Vorbedingungen (alle müssen erfüllt sein, sonst No-Op):
    /// - `currentPhase == .teamZuordnen`
    /// - `selectedTeam == nil` (noch keine Teamentscheidung)
    /// - `isInputLocked == false`
    ///
    /// Effekte:
    /// - `selectedTeam` enthält das übergebene Team.
    /// - `isInputLocked == true`.
    ///
    /// Unverändert: `selectedPriority`, `score`, `currentTicketIndex`, `currentPhase`.
    ///
    /// Kapselt Speicherung und Lock atomisch analog zu `savePriority(_:)`.
    ///
    /// - Parameter team: Das zu speichernde Support-Team.
    func saveTeam(_ team: SupportTeam) {
        guard currentPhase == .teamZuordnen else {
            DebugManager.log(.state, "saveTeam ignoriert: Phase ist \(currentPhase), erwartet .teamZuordnen")
            return
        }
        guard selectedTeam == nil else {
            DebugManager.log(.state, "saveTeam ignoriert: Team bereits gesetzt (\(selectedTeam!.rawValue))")
            return
        }
        guard !isInputLocked else {
            DebugManager.log(.state, "saveTeam ignoriert: Input bereits gesperrt")
            return
        }
        selectedTeam = team
        lockInput()
        DebugManager.log(.state, "Team gespeichert: \(team.rawValue), isInputLocked=true")
    }

    // MARK: - Bewertungsflags (Modul 010 — F-11 / genau-einmal-Semantik)

    /// Gibt an, ob die Prioritätsentscheidung des aktuellen Tickets bereits bewertet wurde.
    ///
    /// Verhindert doppelte Punktevergabe bei mehrfachem View-Refresh, mehrfachem Task-Start
    /// oder erneutem Aufruf der Bewertungsmethode.
    private var priorityEvaluated: Bool = false

    /// Gibt an, ob die Teamentscheidung des aktuellen Tickets bereits bewertet wurde.
    private var teamEvaluated: Bool = false

    // MARK: - Bewertung (Modul 010 — F-11)

    /// Bewertet die gespeicherte Prioritätsentscheidung genau einmal.
    ///
    /// Vorbedingungen (alle müssen erfüllt sein, sonst No-Op → nil):
    /// - `currentPhase == .priorisieren`
    /// - `selectedPriority != nil`
    /// - `currentTicket != nil`
    /// - Priorität wurde für dieses Ticket noch nicht bewertet.
    ///
    /// Effekte bei Erfolg:
    /// - Richtig: `score += 100`, `priorityEvaluated = true`.
    /// - Falsch: keine Scoreänderung, `priorityEvaluated = true`.
    ///
    /// Kein negativer Punkt. Referenzwert darf diesen Scope nie als sichtbarer Text verlassen.
    ///
    /// - Returns: `true` wenn richtig, `false` wenn falsch, `nil` wenn No-Op.
    @discardableResult
    func evaluatePriority() -> Bool? {
        guard currentPhase == .priorisieren else {
            DebugManager.log(.state, "evaluatePriority ignoriert: Phase ist \(currentPhase), erwartet .priorisieren")
            return nil
        }
        guard let priority = selectedPriority else {
            DebugManager.log(.state, "evaluatePriority ignoriert: keine Prioritaet gespeichert")
            return nil
        }
        guard let ticket = currentTicket else {
            DebugManager.log(.state, "evaluatePriority ignoriert: kein aktives Ticket")
            return nil
        }
        guard !priorityEvaluated else {
            DebugManager.log(.state, "evaluatePriority ignoriert: bereits bewertet (genau-einmal-Semantik)")
            return nil
        }

        let isCorrect = (priority == ticket.referencePriority)
        if isCorrect {
            score += FeedbackConstants.correctDecisionScore
            DebugManager.log(.state, "Prioritaet korrekt → +\(FeedbackConstants.correctDecisionScore), Score: \(score)")
        } else {
            DebugManager.log(.state, "Prioritaet falsch → +0, Score: \(score)")
        }
        priorityEvaluated = true
        return isCorrect
    }

    /// Bewertet die gespeicherte Teamentscheidung genau einmal.
    ///
    /// Vorbedingungen (alle müssen erfüllt sein, sonst No-Op → nil):
    /// - `currentPhase == .teamZuordnen`
    /// - `selectedTeam != nil`
    /// - `currentTicket != nil`
    /// - Team wurde für dieses Ticket noch nicht bewertet.
    ///
    /// Effekte bei Erfolg:
    /// - Richtig: `score += 100`, `teamEvaluated = true`.
    /// - Falsch: keine Scoreänderung, `teamEvaluated = true`.
    ///
    /// - Returns: `true` wenn richtig, `false` wenn falsch, `nil` wenn No-Op.
    @discardableResult
    func evaluateTeam() -> Bool? {
        guard currentPhase == .teamZuordnen else {
            DebugManager.log(.state, "evaluateTeam ignoriert: Phase ist \(currentPhase), erwartet .teamZuordnen")
            return nil
        }
        guard let team = selectedTeam else {
            DebugManager.log(.state, "evaluateTeam ignoriert: kein Team gespeichert")
            return nil
        }
        guard let ticket = currentTicket else {
            DebugManager.log(.state, "evaluateTeam ignoriert: kein aktives Ticket")
            return nil
        }
        guard !teamEvaluated else {
            DebugManager.log(.state, "evaluateTeam ignoriert: bereits bewertet (genau-einmal-Semantik)")
            return nil
        }

        let isCorrect = (team == ticket.referenceTeam)
        if isCorrect {
            score += FeedbackConstants.correctDecisionScore
            DebugManager.log(.state, "Team korrekt → +\(FeedbackConstants.correctDecisionScore), Score: \(score)")
        } else {
            DebugManager.log(.state, "Team falsch → +0, Score: \(score)")
        }
        teamEvaluated = true
        return isCorrect
    }

    // MARK: - Ticket-Abschluss (Modul 010 — F-13)

    /// Schließt das aktuelle Ticket nach dem Teamfeedback ab und wechselt kontrolliert
    /// zum nächsten Ticket oder in die Ergebnisphase.
    ///
    /// Vorbedingung: `currentPhase == .teamZuordnen`.
    /// Verstöße sind No-Op — kein Absturz, kein Zustandsbruch.
    ///
    /// Bei weiterem Ticket:
    /// - `currentTicketIndex += 1`
    /// - `selectedPriority = nil`, `selectedTeam = nil`
    /// - Bewertungsflags zurückgesetzt
    /// - `isInputLocked = false`
    /// - `currentPhase = .untersuchen`
    /// - `score` bleibt erhalten.
    ///
    /// Beim letzten Ticket:
    /// - `currentPhase = .ergebnis`
    /// - `isInputLocked = false`
    /// - `score` bleibt erhalten (für Modul 011).
    /// - Kein vollständiger Session-Reset.
    func completeTicketAfterTeamFeedback() {
        guard currentPhase == .teamZuordnen else {
            DebugManager.log(.state, "completeTicketAfterTeamFeedback ignoriert: Phase ist \(currentPhase), erwartet .teamZuordnen")
            return
        }

        let hasNextTicket = currentTicketIndex < sessionTickets.count - 1
        if hasNextTicket {
            currentTicketIndex += 1
            selectedPriority = nil
            selectedTeam = nil
            priorityEvaluated = false
            teamEvaluated = false
            isInputLocked = false
            currentPhase = .untersuchen
            DebugManager.log(.state, "Ticket abgeschlossen → weiter zu Index \(currentTicketIndex), Phase: untersuchen, Score: \(score)")
        } else {
            // Letztes Ticket: kein Indexüberlauf, Phase → Ergebnis.
            isInputLocked = false
            currentPhase = .ergebnis
            DebugManager.log(.state, "Letztes Ticket abgeschlossen → Phase: ergebnis, Score: \(score)")
        }
    }

    // MARK: - Reset

    /// Setzt den gesamten Modellzustand auf die definierten Startwerte zurück (SPEC F-16, AK-16 Modellanteil).
    ///
    /// Funktioniert unabhängig davon, in welchem Zustand sich die Sitzung befindet,
    /// und hinterlässt nach beliebig vielen aufeinanderfolgenden Aufrufen keinen Zustand
    /// aus früheren Sitzungen.
    ///
    /// Noch nicht Teil von Modul 003: der sichtbare Wechsel zur Startansicht,
    /// die Schaltfläche „Erneut spielen" und der sichtbare Reglerwert.
    /// Diese UI-Anteile werden in Modul 004 und Modul 011 umgesetzt.
    func reset() {
        selectedTicketCount = GameplayConstants.defaultTicketCount  // auf 6 zurücksetzen
        sessionTickets = []
        selectedMonsterVariantByTicketID = [:]
        currentTicketIndex = 0
        currentPhase = .start
        score = 0
        selectedPriority = nil
        selectedTeam = nil
        isInputLocked = false
        priorityEvaluated = false
        teamEvaluated = false
        DebugManager.log(.state, "Sitzungsmodell zurueckgesetzt auf Startwerte")
    }
}
