# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 032 für Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Stand:** nach Modul `032` — Streak-Feedback v1.3  
**Eingearbeitet am:** 2026-09-04  
**Branch laut 032-Report:** `v1.3`  
**HEAD vor Modul 032:** `df4b6f5e41f134459399b6a4de5354b67c2adabe` (`feat: Modul 31`)  
**Modul-031-Commit:** `df4b6f5`  
**Modul-032-Commit:** offen  
**Testdeklarationen vor 032:** 522  
**Neue Tests:** 54  
**Testdeklarationen nach 032:** **576**  
**Build/Test/Simulator/Audio:** offen

## v1.3-Modulstatus

| Modul | Titel | Status |
|---|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung | committed |
| 028 | Teamlogos v1.3 | committed; Laufzeitanteile OPEN |
| 029 | Monster- und Streak-Audio | committed; Hör-/Bundlelauf OPEN |
| 030 | Ticketvideo-System | committed; Playback-/Bundlelauf OPEN |
| 031 | Streak-State und Scoring | committed `df4b6f5`; Toolchainlauf OPEN |
| 032 | Streak-Feedback v1.3 | implementiert; Code/Test PASS; Simulator/Audio OPEN; Commit offen |
| 033 | Integration und Abnahme v1.3 | als Nächstes |

## Modul 032 — dynamisches Entscheidungsfeedback

Neue finale Schnittstelle:

`DecisionFeedbackView(presentation:)`

mit:

`DecisionFeedbackPresentation(result, awardedPoints)`

Die UI zeigt keine selbst berechneten Punkte.

### Priorität

- korrekt → grüner Haken + `+100 Punkte`
- falsch → rotes Kreuz + `0 Punkte`

### Team

Die Teamphase liest ausschließlich:

`SessionModel.lastTeamAwardedPoints`

Beispiele:

- Streak 1 → `+100 Punkte`
- Streak 2 → `+300 Punkte`
- Streak 3 → `+500 Punkte`
- Streak 4 → `+700 Punkte`
- Streak 5 → `+900 Punkte`
- Team korrekt nach falscher Priorität → `+100 Punkte`
- Team falsch → `0 Punkte`

Keine UI-Scoremutation.

## Streak-Presentation

Neu:

`StreakFeedbackView`

und eine reine Team-/Streak-Präsentationsableitung.

Sichtbarkeit nur wenn:

```text
lastCompletedTicketWasFullyCorrect == true
&& lastCompletedTicketStreak >= 2
```

Darstellung:

| Streak | Anzeige | Stil |
|---:|---|---|
| 0 | keine | – |
| 1 | keine | – |
| 2 | x2 | normal |
| 3 | x3 | normal |
| 4+ | xN | größer + einmaliger Scale-Pulse |

Kein künstlicher Cap.

x5, x6 ... x16 verwenden dieselbe stärkere Logik wie x4.

## HUD

Unverändert.

Das Session-HUD zeigt weiterhin nur:

- Ticket X von Y
- Phasentitel
- Fortschritt

Nicht dauerhaft:

- Score
- Streak
- Multiplikator

## Teamabschluss-Snapshot

Direkt nach genau einer `evaluateTeam()`-Auswertung snapshottet die View lokal:

- Evaluation Bool
- `lastTeamAwardedPoints`
- `lastCompletedTicketWasFullyCorrect`
- `lastCompletedTicketStreak`

Dieser Snapshot ist nur Darstellung und schreibt nichts ins `SessionModel`.

## Audioorchestrierung

Qualifizierter vollständig korrekter Teamabschluss:

1. positiver Monster-Sound
2. `0.2 s` Delay
3. Streak-Sound
4. verbleibende `1.3 s`
5. Phasenwechsel

Gesamtfeedbackdauer:

`1.5 s`

Unverändert.

Mapping:

- Streak 0/1 → kein Streak-Sound
- x2/x3 → `streak_01.wav`
- x4+ → `streak_02.wav`

Priorität:

niemals Streak-Sound.

Pro qualifiziertem Teamabschluss:

höchstens ein Streak-Sound.

## Exactly-once

Der bestehende einzige Feedbacktask bleibt erhalten.

Weiterhin geschützt durch:

- `feedbackTaskStarted`
- Input-Lock
- zentrale Exactly-once-Auswertung

Keine zweite:

- Bewertung
- Scoremutation
- Streakerhöhung
- Overlayauslösung
- Monster-Soundauslösung
- Streak-Soundauslösung
- Transition

## Dateien Modul 032

Neu:

- `Views/Components/StreakFeedbackView.swift`
- `Ticket_TamerTests/StreakFeedbackTests.swift`

Geändert:

- `Views/Components/DecisionFeedbackView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Support/AppConstants.swift`
- `Resources/Localizable.xcstrings`

Unverändert:

- `SessionModel`
- Audio-Katalog/Random-Selector
- Session-HUD
- Video
- Teamlogos
- Dropgeometrie
- Ticketdaten
- ResultView

## Test-/Prüfstand

| Prüfung | Status |
|---|---|
| Tests vor 032 | 522 |
| neue Tests | 54 |
| Tests nach 032 | **576** |
| String Catalog JSON | PASS |
| Modul-Scope `git diff --check` | PASS |
| Punktetext-/Streak-Gates | PASS auf Testebene |
| Sound-Mapping | PASS auf Testebene |
| Gesamtzeit 1.5 s | PASS auf Testebene |
| HUD unverändert | PASS auf Testebene |
| 1200-Punkte-Regression | PASS auf Testebene |
| vollständiger Testlauf | OPEN |
| Build | OPEN |
| Simulator | OPEN |
| hörbare Audiofolge | OPEN |

## Akzeptanzstatus Modul 032

### AK-18
Code: PASS  
Simulator: OPEN

### AK-21
Code: PASS  
Runtime: OPEN

### AK-35
Code: PASS  
Audio-/Runtime: OPEN

### AK-38
Code: PASS  
Simulator: OPEN

## Offene v1.3-Abnahme vor Modul 033

Die Featureimplementierung aus 027–032 ist abgeschlossen.

Noch real abzunehmen:

- AK-31 neue Ticketinhalte im Simulator
- AK-32 Videozuordnung/Start
- AK-33 Videowiedergabe/Schließen/Fehler
- AK-34 4+4 Monster-Sounds hörbar/zufällig
- AK-35 Streak-Sounds im echten Teamabschluss
- AK-36 Streak-State/Reset
- AK-37 Multiplikator-Scoring
- AK-38 x2/x3/x4+-Darstellung
- AK-39 vollständige Bundle-/Ressourcenauffindbarkeit

Zusätzlich:

- vollständiger Xcode-Build
- vollständiger 576-Testlauf
- v1.2-Regression
- 1/6/16-Ticket-Sitzungen
- mindestens fünf Replay-Zyklen
- Layout-/Video-/Audio-/Drop-/Retry-Stabilität

## Nächster Schritt

`033-Eingangsprompt.md` ausführen.

Modul 033 ist ausschließlich Integration, Abnahme und kleine notwendige Integrationsfixes.

Keine neuen Features.
