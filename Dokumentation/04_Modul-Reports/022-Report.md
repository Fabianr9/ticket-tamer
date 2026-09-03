# Modul-Report — 022 Punktekommunikation v1.2

## Zusammenfassung

Die Ergebnisansicht zeigt den unveränderten `SessionModel.score` nun als lokalisierten vollständigen String `<score> Punkte`. Das zentrale Entscheidungsfeedback zeigt bei `.incorrect` zusätzlich zum roten Kreuz exakt `0 Punkte`; `.correct` bleibt grüner Haken plus `+100 Punkte`. Es wurden keine Ergebnisstatistiken und kein neuer fachlicher Zustand eingeführt.

## 1. Vorab-Check

| Punkt | Reales Ergebnis |
|---|---|
| Branch | `A` |
| HEAD vor Modul 022 | `c11b464 fix: Modul 21` |
| Modul-021-Commits | `68268cb` bis `c11b464` (neun vorhandene Commits nach `3536b46`) |
| Working Tree vor 022 | dirty: zwei bereits geänderte Standdateien und neuer `022-Eingangsprompt.md` |
| Testdeklarationen vorher | 306 `@Test` |
| Xcode / xcodebuild | nicht vorhanden |
| Build/Test/Simulator-Baseline | OPEN, Apple-Toolchain in dieser Linux-Umgebung nicht verfügbar |

Die vorgefundenen Änderungen an `Projekt-Stand.md`, `Logbuch-Stand.md` und dem Eingangsprompt wurden nicht bereinigt. Die 021-Änderungen sind bereits commitweise vorhanden und wurden nicht mit Modul 022 vermischt.

## 2. Punktekommunikations-Entwurf

`ResultPresentation.scoreText(for:)` erhält ausschließlich den von `ResultView` gelesenen `model.score` und setzt ihn in den vollständigen String-Catalog-Formatstring `%lld Punkte` ein. Dadurch entstehen beispielsweise exakt `0 Punkte`, `100 Punkte`, `600 Punkte` und `1200 Punkte`.

`DecisionFeedbackResult` bleibt auf `.correct` und `.incorrect` beschränkt. Beide Fälle liefern lediglich ihren sichtbaren Punktetext:

- `.correct`: `checkmark`, grün, `+100 Punkte`
- `.incorrect`: `xmark`, rot, `0 Punkte`

Das Accessibility-Label für falsch lautet lokalisiert `Entscheidung falsch, 0 Punkte`; das vorhandene Label für richtig bleibt `Entscheidung richtig, 100 Punkte`.

## 3. Schutz von Scoring, Audio, Exactly-once und Transition

Unverändert blieben:

- `SessionModel.score`
- `evaluatePriority()` und `evaluateTeam()`
- `AudioService`
- `feedbackTaskStarted`
- `isInputLocked`
- Exactly-once-Schutz
- Sleep-Dauer und ca. 1,5-s-Transition
- Phasenwechsel
- Priorisierungs- und Teamansichten
- Replay-Rootarchitektur aus Modul 021

`0 Punkte` kommuniziert ausschließlich den bereits vorhandenen +0-Effekt. Es gibt keinen Abzug und weder Referenzpriorität noch Referenzteam oder Lösungstext werden an das Feedback übergeben.

## 4. Änderungen je Datei

| Datei | Änderung |
|---|---|
| `Views/ResultView.swift` | lokalisierte Formatierung als `<score> Punkte`; weiterhin nur `model.score` |
| `Views/Components/DecisionFeedbackView.swift` | zentraler `0 Punkte`-Text für `.incorrect`; richtig unverändert |
| `Resources/Localizable.xcstrings` | `%lld Punkte`, `0 Punkte` und erweitertes Incorrect-Accessibility-Label |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | vorhandene Feedbacktests angepasst und sieben Modul-022-Tests ergänzt |

## 5. Tests

| Stand | Deklarationen | Ergebnis |
|---|---:|---|
| vorher | 306 | reale Preflight-Zählung |
| neu | 7 | statisch ergänzt |
| nachher | 313 | vollständiger Lauf OPEN |

Die 19 geforderten Prüfpunkte werden durch die sieben neuen Format-/Negativtests, die angepassten Feedbacktests und bestehende Reset-, Mapping-, Scoring- und Exactly-once-Tests abgedeckt. Insbesondere bestehen bereits eigenständige Tests für falsche Prioritäts-/Teambewertung mit +0, zweite Bewertung als No-Op, Bool-zu-Feedback-Mapping, Symbole, fehlende Referenzwerte und Reset-Semantik.

Ausgeführte statische Prüfungen:

- String Catalog als JSON validiert: PASS
- `git diff --check` für alle vier Moduldateien: PASS
- reale `@Test`-Zählung: 313

Nicht ausführbar: Build und vollständige Tests, weil `xcodebuild` und die visionOS-Toolchain fehlen.

## 6. Simulator- und Regressionstest

**Status: OPEN.** Auf macOS/Xcode noch zu prüfen:

- Ergebnis für 0, 100 und 600 Punkte sowie `Erneut spielen`
- keine Maximalpunktzahl, Prozentzahl, Statistik oder Rang
- falsche Priorität und falsches Team: rotes Kreuz, `0 Punkte`, Incorrect-Sound, unveränderter Score, keine Lösung
- richtige Entscheidung: grüner Haken, `+100 Punkte`, Correct-Sound
- schnelles Mehrfach-Pinchen: Bewertung, Sound, Feedback und Phasenwechsel genau einmal
- unveränderte ca. 1,5-s-Transition
- Replay-Layoutregression aus Modul 021

## 7. Akzeptanzkriterien

- **AK-26: OPEN** — Code und statische Tests erfüllen das exakte Ergebnisformat sowie die Negativanforderungen; Build und Simulatorprüfung stehen aus.
- **AK-27: OPEN** — Code und statische Tests erfüllen Kreuz/Haken und `0 Punkte`/`+100 Punkte`; Sound, Timing und Exactly-once sind unverändert, die Laufzeitabnahme steht aus.

## 8. Git

- vorgesehener Commit: `022: Punktekommunikation v1.2`
- Commit/Hash: nicht erzeugt, da Build, vollständiger Testlauf und Simulatorprüfung in dieser Umgebung offen sind

## 9. Offene Risiken

- Kompilierung und String-Catalog-Auflösung müssen mit der Apple-Toolchain bestätigt werden.
- Die sichtbare und barrierefreie Ausgabe muss im visionOS-Simulator abgenommen werden.
- AK-25 aus Modul 021 bleibt mangels Laufzeitabnahme ebenfalls OPEN.

## Empfehlung für Modul 023 — Teamstation-Symbole

Vor Modul 023 Build, alle 313 Tests und die kombinierte Simulatorabnahme für Replay und Punktekommunikation ausführen. Modul 023 anschließend auf die semantischen Teamstationssymbole begrenzen und das zentrale Feedback sowie die Bewertungslogik unverändert lassen.
