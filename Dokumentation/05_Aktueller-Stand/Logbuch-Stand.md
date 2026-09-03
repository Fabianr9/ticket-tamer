# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 022 für Version 1.2.

**Projektversion:** v1.2 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**Stand:** nach Modul `022` — Punktekommunikation v1.2  
**Eingearbeitet am:** 2026-09-03  
**Branch laut 022-Report:** `A`  
**HEAD vor Modul 022:** `c11b464 fix: Modul 21`  
**Modul-021-Commits:** `68268cb` bis `c11b464`  
**Modul-022-Commit:** offen  
**Testdeklarationen vor 022:** 306  
**Neue Tests:** 7  
**Testdeklarationen nach 022:** **313**  
**Build/Test/Simulator nach 022:** offen

## v1.2-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 021 | Replay-Layoutstabilisierung | F-25 / AK-25 | implementiert; Laufzeitabnahme OPEN |
| 022 | Punktekommunikation v1.2 | F-26, F-27 / AK-26, AK-27 | implementiert; statisch geprüft; Laufzeitabnahme OPEN; Commit offen |
| 023 | Teamstation-Symbole | F-28 / AK-28 | als Nächstes |
| 024 | Debug-UI-Isolation | F-29 / AK-29 | offen |
| 025 | Monster-Farbvarianten | F-30 / AK-30 | offen |
| 026 | Integration und Abnahme v1.2 | AK-25 bis AK-30 | offen |

## Eingearbeiteter Stand Modul 022

### Ergebnisansicht

`ResultView` zeigt den unveränderten `SessionModel.score` nun als lokalisierten vollständigen String:

`<score> Punkte`

Beispiele:

- `0 Punkte`
- `100 Punkte`
- `600 Punkte`
- `1200 Punkte`

Keine neuen Ergebnisstatistiken.

Weiterhin vorhanden:

- `Erneut spielen`

Weiterhin nicht vorhanden:

- Maximalpunktzahl
- Prozentzahl
- Rang
- Statistik
- Badge
- weitere Ergebniskennzahlen

### Zentrale Ergebnisformatierung

Laut Report:

`ResultPresentation.scoreText(for:)`

verwendet ausschließlich `model.score` und den String-Catalog-Formatstring:

`%lld Punkte`

Keine neue fachliche Ergebnislogik.

### Visuelles Entscheidungsfeedback

`DecisionFeedbackResult` bleibt unverändert:

- `.correct`
- `.incorrect`

Darstellung:

#### Correct

- grüner Haken
- `+100 Punkte`

#### Incorrect

- rotes Kreuz
- `0 Punkte`

Das falsche Feedback kommuniziert nur den bereits bestehenden Scoreeffekt +0.

### Accessibility

Richtig:

`Entscheidung richtig, 100 Punkte`

Falsch:

`Entscheidung falsch, 0 Punkte`

Keine Lösung, Referenzpriorität oder Referenzteam.

## Geschützte Logik

Laut 022-Report unverändert:

- `SessionModel.score`
- `evaluatePriority()`
- `evaluateTeam()`
- AudioService
- `feedbackTaskStarted`
- `isInputLocked`
- Exactly-once
- ca. 1,5-s-Sleep
- Phasenwechsel
- Priorisierungs-/Teamlogik
- Replay-Rootarchitektur aus Modul 021

`0 Punkte` ist ausschließlich Darstellungslogik.

## Dateien Modul 022

Geändert:

- `Views/ResultView.swift`
- `Views/Components/DecisionFeedbackView.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

## Teststand

| Kennzahl | Stand |
|---|---:|
| Tests vor 022 | 306 |
| neue Tests | 7 |
| Tests nach 022 | **313** |
| String Catalog JSON | PASS |
| `git diff --check` Moduldateien | PASS |
| vollständiger Xcode-Lauf | OPEN |

Die sieben neuen Tests ergänzen vorhandene Scoring-/Feedback-/Reset-/Exactly-once-Tests und decken insbesondere ab:

- Scoreformat `0 Punkte`
- `100 Punkte`
- `600 Punkte`
- `1200 Punkte`
- keine Prozent-/Maximalwertdarstellung
- `0 Punkte` bei incorrect
- unverändertes `+100 Punkte` bei correct
- Accessibility

## AK-26

Code- und statisch testseitig umgesetzt.

Noch offen:

- Xcode-Build
- vollständige 313 Tests
- Simulatorprüfung für verschiedene Scores
- sichtbare/barrierefreie Darstellung

**AK-26 = OPEN bis Laufzeitabnahme.**

## AK-27

Code- und statisch testseitig umgesetzt.

Noch offen:

- falsche Priorität im Simulator
- falsches Team im Simulator
- Sound parallel
- Exactly-once unter Mehrfacheingabe
- 1,5-s-Dauer
- visuelle/Accessibility-Abnahme

**AK-27 = OPEN bis Laufzeitabnahme.**

## AK-25 bleibt ebenfalls OPEN

Modul 022 verändert die Replay-Rootarchitektur nicht.

Weiterhin offen:

- Build
- vollständige Tests
- Cold Start
- Replay 1–5
- Resize-Erhalt
- v1.0/v1.1-Regression

## Offene Punkte vor Modul 023

- [ ] Modul 022 bauen
- [ ] vollständige 313 Tests
- [ ] ResultView 0/100/600 Punkte
- [ ] correct +100 Punkte
- [ ] incorrect 0 Punkte
- [ ] Sound/Timing/Exactly-once Regression
- [ ] Replay-Regression 021
- [ ] Modul 022 separat committen

## Nächster Schritt

`023-Eingangsprompt.md` ausführen.

Modul 023 bearbeitet ausschließlich F-28 / AK-28:

- jede Teamstation erhält zusätzlich zum bestehenden Text ein semantisch passendes Symbol
- Text bleibt vollständig sichtbar
- Farbe bleibt nur ergänzend
- sichtbare Zielgröße bleibt unverändert
- Drop-Bounds bleiben unverändert
- Drop-Auswertung bleibt unverändert
