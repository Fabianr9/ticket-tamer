# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 031 für Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Stand:** nach Modul `031` — Streak-State und Scoring  
**Eingearbeitet am:** 2026-09-04  
**Branch laut 031-Report:** `v1.3`  
**HEAD vor Modul 031:** `8041bf9d8cbe8f2a63c982a2418a32e56a3b3d36` (`feat: Modul 30`)  
**Modul-030-Commit:** `8041bf9`  
**Modul-031-Commit:** offen  
**Testdeklarationen vor 031:** 474  
**Neue Tests:** 48  
**Testdeklarationen nach 031:** **522**  
**Build/Test/Simulator:** offen

## v1.3-Modulstatus

| Modul | Titel | Status |
|---|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung | committed |
| 028 | Teamlogos v1.3 | committed; Laufzeitanteile OPEN |
| 029 | Monster- und Streak-Audio | committed; Hör-/Bundlelauf OPEN |
| 030 | Ticketvideo-System | committed `8041bf9`; Playback-/Bundlelauf OPEN |
| 031 | Streak-State und Scoring | implementiert; Code/Test PASS; Toolchainlauf OPEN; Commit offen |
| 032 | Streak-Feedback v1.3 | als Nächstes |
| 033 | Integration und Abnahme v1.3 | offen |

## Modul 031 — zentraler Streak-State

`SessionModel` bleibt die einzige fachliche Zustandsquelle.

Neu:

```swift
private(set) var streak: Int = 0
private(set) var currentPriorityWasCorrect: Bool? = nil
```

Regeln:

- neues Modell → `streak = 0`
- `startSession()` → `streak = 0`
- `reset()` → `streak = 0`
- falsche Priorität → Streak sofort 0
- richtige Priorität → Streak noch nicht erhöhen
- nur vollständig korrektes Ticket erhöht beim Teamabschluss die Streak
- kein künstlicher Cap

`currentPriorityWasCorrect` wird beim nächsten Ticket, beim Sitzungsstart und beim Reset wieder `nil`.

## Scoring

### Priorität

Richtig:

- +100 Punkte
- `currentPriorityWasCorrect = true`

Falsch:

- +0 Punkte
- `currentPriorityWasCorrect = false`
- `streak = 0`

### Teamabschluss

Vollständig korrekt:

```text
streak += 1
ticketTotal = 200 × streak
teamCredit = ticketTotal - 100
```

Teilweise richtig:

- kein Multiplikator
- normale Einzelpunkte
- Streak 0

## Rechenmatrix

| vorherige Streak | Priority | Team | neue Streak | Priority Credit | Team Credit | Ticket total |
|---:|---|---|---:|---:|---:|---:|
| 0 | ✓ | ✓ | 1 | 100 | 100 | 200 |
| 1 | ✓ | ✓ | 2 | 100 | 300 | 400 |
| 2 | ✓ | ✓ | 3 | 100 | 500 | 600 |
| 3 | ✓ | ✓ | 4 | 100 | 700 | 800 |
| 3 | ✓ | ✗ | 0 | 100 | 0 | 100 |
| 3 | ✗ | ✓ | 0 | 0 | 100 | 100 |
| 3 | ✗ | ✗ | 0 | 0 | 0 | 0 |

Keine Doppelzählung.

Bereits vergebene Punkte werden bei Streak-Unterbrechung niemals zurückgezogen.

## Übergabedaten an Modul 032

Nach der einzigen gültigen Team-Auswertung stellt `SessionModel` bereit:

- `lastTeamAwardedPoints`
- `lastCompletedTicketWasFullyCorrect`
- `lastCompletedTicketStreak`

Semantik:

### `lastTeamAwardedPoints`

Tatsächlich **mit der Teamentscheidung** zusätzlich gutgeschriebene Punkte.

Beispiele:

- vollständig korrekt, Streak 1 → 100
- vollständig korrekt, Streak 2 → 300
- vollständig korrekt, Streak 3 → 500
- vollständig korrekt, Streak 4 → 700
- Priorität falsch, Team richtig → 100
- Team falsch → 0

### `lastCompletedTicketWasFullyCorrect`

Nur true, wenn:

- Priorität korrekt
- Team korrekt

### `lastCompletedTicketStreak`

Resultierende Streak nach Teamabschluss.

Diese Metadaten werden:

- beim nächsten Ticket
- bei neuer Sitzung
- bei Reset

neutralisiert.

Eine zweite Team-Auswertung verändert sie nicht.

## Kompatibilität

Unverändert:

```swift
evaluatePriority() -> Bool?
evaluateTeam() -> Bool?
completeTicketAfterTeamFeedback() -> Void
```

Die Bool-Rückgaben bleiben kompatibel mit:

- Monster-Sound
- `DecisionFeedback`

Kein zweiter Bewertungsweg wurde eingeführt.

## Dateien Modul 031

Geändert:

- `Models/SessionModel.swift`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Neu:

- `Ticket_TamerTests/StreakScoringTests.swift`

Nicht verändert:

- Audio 029
- Video 030
- Teamlogos
- Dropgeometrie
- ResultView
- Replay-Root
- Monster-Retry
- Monster-Farbvarianten

## Test-/Prüfstand

| Prüfung | Status |
|---|---|
| Tests vor 031 | 474 |
| neue Tests | 48 |
| Tests nach 031 | **522** |
| Scoring-Matrix | PASS auf Code/Testebene |
| Streak 5/16/>16-Formel | PASS auf Testebene |
| Exactly-once Score/Streak/Metadaten | PASS auf Testebene |
| Sequenz 200+400+600 = 1200 | PASS auf Testebene |
| Sequenz 200+100+200 = 500 | PASS auf Testebene |
| Sequenz 100+200 = 300 | PASS auf Testebene |
| `git diff --check` Modul-Diff | PASS |
| Build | OPEN |
| vollständiger Testlauf | OPEN |
| Simulator | OPEN |

## Akzeptanzstatus

- AK-11: Code/Test PASS; Toolchainlauf OPEN
- AK-16: Code/Test PASS; Toolchainlauf OPEN
- AK-36: Code/Test PASS; Toolchainlauf OPEN
- AK-37: Code/Test PASS; Toolchainlauf OPEN

## Erwartete Zwischenstufe nach Modul 031

Die fachlichen Punkte sind bereits korrekt.

Die Teamfeedback-UI aus v1.2 kommuniziert die höheren Teamgutschriften aber noch nicht vollständig.

Das ist **kein verdeckter Bug**, sondern die geplante Modulgrenze:

Modul 032 übernimmt:

- dynamischen Team-Punktetext aus `lastTeamAwardedPoints`
- `x2`/`x3`/`x4+`-Overlay
- stärkere x4+-Darstellung
- zusätzlichen Streak-Sound bei qualifiziertem Teamabschluss

## Nächster Schritt

`032-Eingangsprompt.md` ausführen.

Modul 032 darf Score und Streak **nicht neu berechnen**. Es liest ausschließlich die von Modul 031 bereitgestellten Abschlussdaten und orchestriert daraus die Darstellung und den bereits vorhandenen Streak-Audio-Service.
