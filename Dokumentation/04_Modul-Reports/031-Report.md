# Modul-Report 031 — Streak-State und Scoring

## 1. Vorab-Check

- Branch: `v1.3`
- HEAD vor Modul 031: `8041bf9d8cbe8f2a63c982a2418a32e56a3b3d36` (`feat: Modul 30`)
- tatsächlicher Modul-030-Commit: `8041bf9`
- Working Tree vor Modul 031: ausschließlich aktualisierte Stand-Dokumente und untracked `031-Eingangsprompt.md`; kein uncommitteter Video-Code
- reale Testzahl vor Modul 031: 474 `@Test`-Deklarationen
- Signaturen unverändert: `evaluatePriority() -> Bool?`, `evaluateTeam() -> Bool?`, `completeTicketAfterTeamFeedback() -> Void`
- Xcode, Swift-Toolchain und Simulator sind auf dieser Plattform nicht vorhanden; Build und automatischer Testlauf bleiben OPEN

## 2. Streak-State

`SessionModel` ist weiterhin die einzige fachliche Zustandsquelle. Neu sind:

```swift
private(set) var streak: Int = 0
private(set) var currentPriorityWasCorrect: Bool? = nil
```

Ein neues Modell, `startSession()` und `reset()` setzen die Streak auf 0. Das gespeicherte Prioritätsergebnis ist initial und nach Sitzungsstart, Reset sowie dem Wechsel zum nächsten Ticket `nil`. Eine falsche Priorität setzt die Streak unmittelbar auf 0; eine richtige Priorität erhöht sie noch nicht.

## 3. Scoringarchitektur

Die Prioritätsauswertung bleibt exactly-once und schreibt bei korrekter Entscheidung sofort 100 Punkte. `evaluateTeam()` verwendet ausschließlich `currentPriorityWasCorrect` und bewertet das Ticket genau einmal fachlich fertig.

Für ein vollständig korrektes Ticket gilt nach Erhöhung der Streak:

```text
ticketTotal = 200 × streak
teamCredit = ticketTotal - 100
```

Damit wird die bereits gutgeschriebene Priorität nicht doppelt gezählt. Ist nur das Team korrekt, werden normale 100 Teampunkte vergeben. Bei falschem Team sind es 0. Sobald eine Entscheidung falsch ist, wird die Streak 0. Bereits vergebene Punkte werden nie zurückgezogen. `teamCredit(forCompletedTicketAtStreak:)` enthält keinen künstlichen Cap.

## 4. Rechenmatrix

| vorherige Streak | Priority | Team | neue Streak | Priority Credit | Team Credit | Ticket total |
|---:|---|---|---:|---:|---:|---:|
| 0 | ✓ | ✓ | 1 | 100 | 100 | 200 |
| 1 | ✓ | ✓ | 2 | 100 | 300 | 400 |
| 2 | ✓ | ✓ | 3 | 100 | 500 | 600 |
| 3 | ✓ | ✓ | 4 | 100 | 700 | 800 |
| 3 | ✓ | ✗ | 0 | 100 | 0 | 100 |
| 3 | ✗ | ✓ | 0 | 0 | 100 | 100 |
| 3 | ✗ | ✗ | 0 | 0 | 0 | 0 |

## 5. Übergabedaten für Modul 032

Die Bool-Rückgabe von `evaluateTeam()` bleibt für Monster-Sound und `DecisionFeedback` kompatibel. Zusätzlich stellt das Modell nach der einzigen Team-Auswertung bereit:

- `lastTeamAwardedPoints`: tatsächlich bei der Teamentscheidung gutgeschriebene Punkte
- `lastCompletedTicketWasFullyCorrect`: vollständige Korrektheit des Tickets
- `lastCompletedTicketStreak`: resultierende Streak

Diese Metadaten werden beim nächsten Ticket, bei neuer Sitzung und Reset neutralisiert. Eine zweite Auswertung verändert sie nicht.

## 6. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Models/SessionModel.swift` | geändert | zentraler Streak-/Prioritätszustand, Differenzscoring, Übergabedaten | F-11, F-16, F-36, F-37 |
| `Ticket_TamerTests/StreakScoringTests.swift` | neu | 48 semantische Streak-, Scoring-, Sequenz- und Regressionstests | AK-11, AK-16, AK-36, AK-37 |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | geändert | bestehende Team-Testvorbereitung an gespeichertes Prioritätsergebnis angepasst | AK-11 |

## 7. Tests und Prüfungen

- vorher: 474 Testdeklarationen
- neu: 48
- nachher: 522
- Scoring-Matrix statisch und durch Sequenztests abgedeckt
- Streak 5 und 16 sowie reine Formel für Werte über 16 abgedeckt
- Exactly-once für Score, Streak und Übergabedaten abgedeckt
- Sequenzen 1200, 500 und 300 Punkte abgedeckt
- `git diff --check` für den Modul-Diff: PASS; vorhandene nachgestellte Leerzeichen in den zuvor geänderten Stand-Dokumenten gehören zum Eingangszustand
- Build/Testlauf: OPEN, Apple-Toolchain fehlt
- Simulator: OPEN

## 8. Regression und Modulgrenze

- Audio 029 wurde nicht verändert; `playStreak(for:)` wird noch nicht produktiv aufgerufen.
- Video 030 wurde nicht verändert; ein Regressionstest bestätigt, dass lokaler Videopräsentationszustand die Streak nicht beeinflusst.
- Monster-Retry beeinflusst die Streak nicht.
- `ResultView`, Replay-Root, Dropgeometrie, Ticketdaten, Logos und Monster-Varianten bleiben unverändert.
- Noch kein Streak-Overlay, keine Streak-Animation und kein neuer Teamfeedback-Punktetext. Dass die aktuelle Teamfeedbackdarstellung Zusatzpunkte noch nicht vollständig kommuniziert, ist die erwartete Modulgrenze bis Modul 032.

## 9. Akzeptanzstatus und Risiken

- AK-11: Code-/Testebene PASS; Toolchainlauf OPEN
- AK-16: Code-/Testebene PASS; Toolchainlauf OPEN
- AK-36: Code-/Testebene PASS; Toolchainlauf OPEN
- AK-37: Code-/Testebene PASS; Toolchainlauf OPEN

Offenes Risiko ist ausschließlich die noch fehlende Kompilierungs-, Test- und Simulatorprüfung auf einer Apple-Plattform. Empfohlen als Nächstes: **Modul 032 — Streak-Feedback v1.3**, das die zentral bereitgestellten Abschlussdaten für Punkteanzeige, Multiplikatoroverlay und zeitversetzten Streaksound verwendet.
