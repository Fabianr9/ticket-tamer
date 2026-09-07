# Modul-Report — 032 Streak-Feedback v1.3

## 1. Vorab-Check

| Punkt | Realer Stand |
|---|---|
| Branch | `v1.3` |
| HEAD vor Modul 032 | `df4b6f5e41f134459399b6a4de5354b67c2adabe` (`feat: Modul 31`) |
| tatsächlicher Modul-031-Commit | `df4b6f5` |
| Working Tree vor Modul | nur vorbereitete Änderungen an `Projekt-Stand.md`, `Logbuch-Stand.md` und untracked `032-Eingangsprompt.md`; unangetastet übernommen |
| Tests vor Modul | 522 `@Test`-Deklarationen |
| Build/Test/Simulator | OPEN: In der Arbeitsumgebung fehlen `xcodebuild` und die Swift-Toolchain |

Der bestehende Flow setzte in beiden Zuordnungsviews nach genau einer Auswertung ein
lokales `DecisionFeedbackResult`, spielte genau einen Monster-Sound, wartete im einzigen
Feedbacktask 1,5 Sekunden und wechselte danach die Phase. In der Teamphase ruft dieser
Task anschließend `completeTicketAfterTeamFeedback()` auf. Dieser Ablauf wurde erweitert,
nicht dupliziert.

## 2. Dynamisches Punktefeedback

| Fall | Awarded Points | Anzeige |
|---|---:|---|
| Priority correct | 100 | `+100 Punkte` |
| Team x1 | 100 | `+100 Punkte` |
| Team x2 | 300 | `+300 Punkte` |
| Team x3 | 500 | `+500 Punkte` |
| Team x4 | 700 | `+700 Punkte` |
| Incorrect | 0 | `0 Punkte` |

Finale Schnittstelle: `DecisionFeedbackView(presentation:)` erhält eine
`DecisionFeedbackPresentation(result, awardedPoints)`. Die Teamphase liest die Punkte
direkt aus `SessionModel.lastTeamAwardedPoints`; die UI berechnet und mutiert keinen Score.

## 3. Streak-Presentation

| Streak | sichtbar | Stil |
|---:|---|---|
| 0 | nein | – |
| 1 | nein | – |
| 2 | `x2` | normal |
| 3 | `x3` | normal |
| 4+ | `xN` | emphasized, größere Schrift und einmaliger Scale-Pulse |

`TeamFeedbackPresentation` snapshottet direkt nach `evaluateTeam()` Ergebnis,
`lastTeamAwardedPoints`, `lastCompletedTicketWasFullyCorrect` und
`lastCompletedTicketStreak`. Nur vollständig korrekte Teamabschlüsse ab Streak 2 sind
sichtbar. Das HUD bleibt unverändert und enthält weder Score noch Streak.

## 4. Audioorchestrierung

- Monster-Sound: unmittelbar nach der einzigen Team-Auswertung, genau einmal.
- Delay: 0,2 Sekunden (`FeedbackConstants.streakSoundDelay`).
- Streak-Sound: nur bei vollständig korrektem Teamabschluss mit Streak ≥ 2; Sound 01 für
  x2/x3 und Sound 02 für x4+ über den unveränderten Katalog.
- Restdelay: defensiv `max(0, 1,5 - 0,2) = 1,3` Sekunden.
- Exactly-once: bestehender `feedbackTaskStarted`-Guard und die einzige Taskkette bleiben
  erhalten. Prioritätsentscheidungen rufen keinen Streak-Sound auf.
- Gesamtfeedbackdauer bleibt 1,5 Sekunden und wurde nicht verlängert.

## 5. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `DecisionFeedbackView.swift` | geändert | Punktesnapshot, dynamischer lokalisierter Text und Accessibility | F/AK-21 |
| `StreakFeedbackView.swift` | neu | reine Streak-/Team-Presentation, x2/x3 normal, x4+ groß und gepulst | F/AK-38 |
| `PrioritizationView.swift` | geändert | Übergabe der bereits bekannten 100/0 Punkte | F/AK-21 |
| `TeamAssignmentView.swift` | geändert | lokaler Abschluss-Snapshot, Overlay und sequenzieller Soundtrigger | F/AK-21, -35, -38 |
| `AppConstants.swift` | geändert | zentrale 0,2-s-Verzögerung, Restzeit und Pulsdauer | F/AK-35, -38 |
| `Localizable.xcstrings` | geändert | dynamische Punkte- und Accessibility-Strings; vorhandene Abschlussklammern validiert | F/AK-21, -38 |
| `StreakFeedbackTests.swift` | neu | 54 Modul-032-Tests | alle |

Unverändert blieben Scoringmodell, Audio-Katalog/Random-Selector, Session-HUD, Video,
Teamlogos, Dropgeometrie, Ticketdaten und Ergebnisansicht.

## 6. Tests

- Vorher: 522 Deklarationen.
- Neu: 54 Deklarationen.
- Nachher: 576 Deklarationen.
- Ausführung: OPEN, weil auf der Linux-Arbeitsumgebung weder `xcodebuild` noch `swift`
  installiert ist.
- Statisch geprüft: String Catalog ist valides JSON; Modul-Scope besteht
  `git diff --check`. Bereits vorhandene Trailing-Whitespace-Meldungen liegen ausschließlich
  in den vorbereiteten Nutzerdokumenten und wurden nicht verändert.

## 7. Simulator-/Regressionstest

OPEN mangels visionOS/Xcode-Simulator. Daher sind Priorität correct/incorrect, Team
x1/x2/x3/x4/x5, Partial-Fälle, hörbare Audiofolge, schnelles Mehrfach-Pinchen und reales
Layout auf dem Simulator noch manuell zu bestätigen. Quellcode und Tests decken die
Punktetexte, Gates, Soundzuordnung, Gesamtzeit, Exactly-once-Modelguard, unverändertes HUD,
Video-, Logo-, Drop-, Monster-Audio- und 1200-Punkte-Regressionsverhalten ab.

## 8. Abnahme

| Kriterium | Status | Begründung |
|---|---|---|
| AK-18 | PASS (Code) / OPEN (Simulator) | HUD wurde nicht erweitert; Streak ist temporär und separat. |
| AK-21 | PASS (Code) / OPEN (Runtime) | Teamfeedback übernimmt exakt `lastTeamAwardedPoints`; kein UI-Scoring. |
| AK-35 | PASS (Code) / OPEN (Audio) | Kein Sound bei x1/Priorität; 01 für x2/x3, 02 für x4+, höchstens einmal je Task. |
| AK-38 | PASS (Code) / OPEN (Simulator) | Kein x1; x2/x3 normal; x4+ größer mit Scale-Pulse. |

Offenes Risiko bleibt ausschließlich die nicht mögliche Apple-Plattformprüfung von Build,
Tests, Audio und räumlichem Layout. Empfehlung für **Modul 033 — Integration und Abnahme
v1.3**: vollständigen Xcode-Build und Testlauf sowie die im Eingangsprompt definierte
x1–x5-, Partial-, Audio-, Exactly-once-, HUD- und Layout-Simulator-Matrix durchführen.
