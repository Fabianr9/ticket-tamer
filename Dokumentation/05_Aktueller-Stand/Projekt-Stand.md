# Projekt-Stand — Ticket Tamer

> Aktuelle technische Landkarte nach Modul 030 der Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**Stand:** nach Modul 030
**Branch:** `v1.3`  
**Modul-028-Commit:** `120ab6d`  
**Modul-029-Commit:** `baf8a55`
**Modul-030-Commit:** offen
**Reale Testdeklarationen:** **474**
**Build/Test/Simulator:** offen

## v1.3-Funktionsstand

### 027 — Tickets

- TT-001 bis TT-016
- Auswahl 1...16
- Standard/Reset 6
- `videoAssetName = TT-xxx.mp4`

### 028 — Teamlogos

Zentrale Zuordnung:

`TeamLogoCatalog`

Vier lokale JPEGs unter:

`Resources/TeamLogos/`

### 029 — Audio

Zentrale Zuordnung:

`AudioResourceCatalog`

#### Monster Correct

`Resources/Audio/MonsterSounds/Correct/`

- monster_correct_01.wav
- monster_correct_02.wav
- monster_correct_03.wav
- monster_correct_04.wav

#### Monster Incorrect

`Resources/Audio/MonsterSounds/Incorrect/`

- monster_incorrect_01.wav
- monster_incorrect_02.wav
- monster_incorrect_03.wav
- monster_incorrect_04.wav

#### Streak

`Resources/Audio/StreakSounds/`

- streak_01.wav → x2/x3
- streak_02.wav → x4+

## AudioService

Zentrale Schnittstellen sinngemäß:

- `playMonsterFeedback(evaluation:selector:)`
- `playStreak(for:)`

Monsterfeedback:

- correct → 1 von 4
- incorrect → 1 von 4
- direkte Wiederholung erlaubt
- kein Anti-Repeat

Streak-Mapping vorhanden, produktiver Trigger aber noch nicht aktiv.

### 030 — Ticketvideos

- 16 lokale MP4s unter `Resources/Videos/`
- zentrale Auflösung über `TicketVideoResourceProvider`
- `Video ansehen` nur in der Investigation
- volumeninternes `TicketVideoView`-Overlay mit Auto-Play nach Tap
- Pause/Fortsetzen über `VideoPlayer`, sichtbares X und Auto-Close
- lokalisierter, schließbarer Fehlerzustand
- lokaler `TicketVideoPresentationState`; kein Videozustand im `SessionModel`

## Tests

Realer Stand:

- 401 vor Modul 029
- +35
- +38 in Modul 030
- **474 aktuell**

Apple-Toolchain-Lauf offen.

## v1.3-Modul-Landkarte

| Modul | Status |
|---|---|
| 027 | committed |
| 028 | committed; Laufzeit OPEN |
| 029 | committed `baf8a55`; Laufzeit OPEN |
| 030 | implementiert; Playback-/Simulatorlauf OPEN; Commit offen |
| 031 | offen |
| 032 | offen |
| 033 | offen |

## Für Modul 031 relevant

Jedes Ticket besitzt bereits:

`videoAssetName`

mit:

TT-001.mp4 bis TT-016.mp4.

Noch nicht vorhanden: Streak-State, Multiplikator-Scoring und Score-Differenzgutschrift. Das Video-System darf in Modul 031 nicht in den Fachzustand verschoben oder mit Streak-/Audiofeedback gekoppelt werden.

## Geschützt

Nicht ändern:

- Audio
- Teamlogos
- Sessionauswahl
- Tickettexte
- Monsterlogik
- Drop/Drag
- Score
- Exactly-once
- Replay
- ResultView
- Streak noch nicht einführen
