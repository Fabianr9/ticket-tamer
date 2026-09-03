# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 030 für Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Stand:** nach Modul `030` — Ticketvideo-System
**Eingearbeitet am:** 2026-09-04
**Branch:** `v1.3`
**HEAD vor Modul 030:** `baf8a55495e9605bbc011dbf01de061638f6a11c`
**Modul-028-Commit:** `120ab6d` (`feat: Modul 28`)  
**Modul-029-Commit:** `baf8a55` (`feat: Modul 29`)
**Modul-030-Commit:** offen
**Reale Testdeklarationen vor 030:** 436
**Neue Tests:** 38
**Reale Testdeklarationen nach 030:** **474**
**Build/Test/Simulator/Hörprüfung:** offen

## Wichtige Teststand-Korrektur

Der Eingangsprompt für Modul 029 ging von 369 Tests aus.

Der reale committed Modul-028-Stand `120ab6d` enthielt jedoch bereits:

**401 `@Test`-Deklarationen**

Damit gilt für den aktuellen Stand:

- vor Modul 029: 401
- neu: 35
- nach Modul 029: **436**

Die frühere 369-Angabe wird nicht weitergeführt.

## v1.3-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung | F-01, F-02, F-03, F-04, F-22, F-31 | committed |
| 028 | Teamlogos v1.3 | F-28, F-39 | committed `120ab6d`; Laufzeitanteile OPEN |
| 029 | Monster- und Streak-Audio | F-12, F-34, F-35, F-39 | committed `baf8a55`; Hör-/Bundlelauf OPEN |
| 030 | Ticketvideo-System | F-03, F-32, F-33, F-39 | implementiert; Ressourcen/Code statisch PASS; Playback-/Simulatorlauf OPEN; Commit offen |
| 031 | Streak-State und Scoring | F-11, F-16, F-36, F-37 | offen |
| 032 | Streak-Feedback v1.3 | F-18, F-21, F-35, F-38 | offen |
| 033 | Integration und Abnahme v1.3 | F-01 bis F-39 | offen |

## Modul 029 — Audioinventar

### Correct

- `monster_correct_01.wav`
- `monster_correct_02.wav`
- `monster_correct_03.wav`
- `monster_correct_04.wav`

Produktiver Pfad:

`Resources/Audio/MonsterSounds/Correct/`

### Incorrect

- `monster_incorrect_01.wav`
- `monster_incorrect_02.wav`
- `monster_incorrect_03.wav`
- `monster_incorrect_04.wav`

Produktiver Pfad:

`Resources/Audio/MonsterSounds/Incorrect/`

### Streak

- `streak_01.wav` → x2/x3
- `streak_02.wav` → x4+

Produktiver Pfad:

`Resources/Audio/StreakSounds/`

Alle zehn Dateien wurden statisch als RIFF/WAVE, PCM 16 Bit, Stereo, 48 kHz validiert.

Quell- und Zielkopien besitzen laut Report identische SHA-256-Hashes.

## Audioarchitektur

Neu:

`Support/AudioResourceCatalog.swift`

### `LocalAudioResource`

Kapselt:

- Ressourcenname
- WAV-Endung
- Unterordner
- fehlertoleranten Bundle-Lookup

### `MonsterFeedbackSoundCatalog`

Besitzt getrennte Gruppen:

- Correct: exakt 4
- Incorrect: exakt 4

Auswahl:

```text
select(for evaluation: Bool?, using selector:)
```

Produktiv:

`randomElement()`

Tests:

injizierbar/deterministisch.

Keine Anti-Repeat-Logik.

Direkte Wiederholung derselben Soundvariante ist ausdrücklich zulässig.

### `AudioService`

Neue Verantwortung:

- `playMonsterFeedback(evaluation:selector:)`
- separater Monster-Player
- separater Streak-Player
- `playStreak(for:)`

Fehlende/defekte Audioressourcen:

- werden über `.audio` geloggt
- verändern keinen fachlichen Flow

## Entscheidungsflow

```text
gültige Entscheidung
→ Exactly-once-Bewertung
→ Correct/Incorrect-Gruppe
→ genau 1 von 4 auswählen
→ genau 1 Monster-Sound
→ bestehendes visuelles Feedback
→ bestehender Transitionflow
```

Ungültiger Drop oder `nil`-Bewertung:

kein Bewertungssound.

## Streak-Mapping

| Streak | Sound |
|---:|---|
| <= 1 | keiner |
| 2 | 01 |
| 3 | 01 |
| >= 4 | 02 |

Wichtig:

Der produktive Teamabschluss-Trigger ist **noch nicht** aktiv.

Modul 029 führt nicht ein:

- `SessionModel.streak`
- Multiplikator-Scoring
- Streak-Overlay
- fachliche Streak-Mutation

Diese folgen erst in Modul 031/032.

## Historische Sounds

Weiter vorhanden, aber produktiv unreferenziert:

- `Resources/correct.wav`
- `Resources/incorrect.wav`

Kein produktiver Code spielt diese Dateien noch ab.

Sie können später als reine Ressourcenbereinigung entfernt werden.

## Dateien Modul 029

Neu:

- `Support/AudioResourceCatalog.swift`
- `Resources/Audio/MonsterSounds/Correct/*.wav`
- `Resources/Audio/MonsterSounds/Incorrect/*.wav`
- `Resources/Audio/StreakSounds/*.wav`
- `AudioResourceCatalogTests.swift`

Geändert:

- `Services/AudioService.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Support/AppConstants.swift`
- `Ticket_TamerTests.swift`

Nicht verändert:

- `SessionModel`
- Ticketdaten
- Teamlogos
- Dropgeometrie
- Monster-Farbvarianten
- Replay-Root

## Test-/Prüfstand

| Prüfung | Status |
|---|---|
| Tests vor 029 | 401 |
| neue Tests | 35 |
| Tests nach 029 | **436** |
| neue Tests Modul 030 | 38 |
| Tests nach 030 | **474** |
| WAV-Struktur 4+4+2 | PASS |
| WAV-Dateiformat | PASS |
| Quell-/Zielhash | PASS |
| produktive Alt-Soundreferenzen | keine |
| Soundpfade in Views/SessionModel | keine |
| Modul-029 `git diff --check` | PASS |
| vollständiger Testlauf | OPEN |
| Build | OPEN |
| Simulator/Hörprüfung | OPEN |

## Akzeptanzstatus

### AK-12

Code-/statische Testebene:

PASS.

Reale Wiedergabe:

OPEN.

### AK-34

Katalog, Zufallsauswahl, deterministische Auswahl und direkte Wiederholung:

PASS.

Hörprüfung:

OPEN.

### AK-35

Ressourcen/Mapping/API:

PASS.

Produktiver Teamabschluss-Streaktrigger:

OPEN bis Modul 031/032.

### AK-39 Audio-Anteil

Code-/Ressourcenebene:

PASS.

Bundle-/Simulatorlauf:

OPEN.

## Modul 030 — Ticketvideo-System

- `TT-001.mp4` bis `TT-016.mp4` liegen gemeinsam unter `Resources/Videos/`.
- `TicketVideoResourceProvider` löst ausschließlich lokale MP4-Dateinamen aus dem Bundle auf.
- `TicketVideoPresentationState` hält den lokalen, nicht fachlichen Präsentationszustand.
- `TicketVideoView` bietet Auto-Play nach Tap, Standardcontrols, sichtbares X, Auto-Close und Fehleranzeige.
- Hintergrundinteraktionen sind während des Overlays gesperrt.
- Ticket-, Phasenwechsel und Verschwinden der Investigation räumen die Videopräsentation auf.
- `SessionModel`, Score, Entscheidungen, Input-Lock und Monster-Mapping bleiben unverändert.

Statisch geprüft: 16 ISO-MP4-Dateien, Größen > 0, identische Quell-/Zielhashes und valider String Catalog. Xcode-Build, Testlauf und Simulator-Playback bleiben OPEN.

## Geschützter Bestand für Modul 031

Nicht verändern:

- Audio-Katalog
- 4+4 Monster-Sounds
- Streak-Soundmapping
- AudioService-Schnittstellen
- TeamLogoCatalog
- Teamlogos
- Tickettexte
- Ticketanzahl 1...16
- Monster-Farbvarianten
- Dropgeometrie
- Replay
- Punktefeedback
- Debug-Isolation
- Ticketvideo-Provider und Videoressourcen
- lokaler Video-Presentation-State
- Video darf kein fachlicher `SessionModel`-State werden

## Nächster Schritt

Modul 031 — Streak-State und Scoring vorbereiten beziehungsweise den zugehörigen Eingangsprompt erzeugen.

Modul 031 bearbeitet ausschließlich den vorgesehenen Streak- und Multiplikator-Fachzustand. Es darf das abgeschlossene Video-System nicht mit Audiofeedback oder Scoring koppeln.
