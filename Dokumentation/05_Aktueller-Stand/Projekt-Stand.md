# Projekt-Stand — Ticket Tamer

> Aktuelle technische Landkarte nach Modul 031 der Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**Stand:** nach Modul 031  
**Branch:** `v1.3`  
**Modul-029-Commit:** `baf8a55`  
**Modul-030-Commit:** `8041bf9`  
**Modul-031-Commit:** offen  
**Testdeklarationen:** **522**  
**Build/Test/Simulator:** offen

## v1.3-Funktionsstand

### 027 — Tickets
- TT-001 bis TT-016
- Auswahl 1...16
- `videoAssetName = TT-xxx.mp4`

### 028 — Teamlogos
- vier lokale JPEGs
- zentrale `TeamLogoCatalog`

### 029 — Audio
- 4 Correct-Monster-Sounds
- 4 Incorrect-Monster-Sounds
- 2 Streak-Sounds
- zentraler Audio-Katalog
- x2/x3 → Sound 01
- x4+ → Sound 02

### 030 — Ticketvideo-System
- 16 lokale MP4s
- zentraler `TicketVideoResourceProvider`
- `TicketVideoView`
- `Video ansehen`
- Auto-Play nach Tap
- Pause/Fortsetzen
- X
- Auto-Close
- Fehlerzustand

## Video-Pfade

`Resources/Videos/TT-001.mp4` bis `TT-016.mp4`

`TT-002A.mp4` bleibt unreferenzierte historische Zusatzdatei außerhalb des produktiven Mappings.

## Tests

- vor Modul 031: 474
- Modul 031: +48
- aktuell **522**

Apple-Toolchain-Lauf offen.

## v1.3-Modul-Landkarte

| Modul | Status |
|---|---|
| 027 | committed |
| 028 | committed |
| 029 | committed; Laufzeit OPEN |
| 030 | implementiert; Laufzeit OPEN |
| 031 | implementiert; Toolchainlauf OPEN |
| 032 | offen |
| 033 | offen |

## Modul 031 — zentraler Scoringzustand

### SessionModel

Implementiert:

```text
SessionState
- selectedTicketCount
- sessionTickets
- currentTicketIndex
- currentPhase
- score
- streak
- selectedPriority
- selectedTeam
- currentPriorityWasCorrect
- isInputLocked
- selectedMonsterVariantByTicket
```

### Scoring

Richtige Priorität:

`+100` sofort.

Falsche Priorität:

`+0`; Ticket kann keine laufende Streak fortsetzen.

Teamabschluss entscheidet über Streak.

Vollständig korrekt:

```text
streak += 1
ticketTotal = 200 × streak
teamCredit = ticketTotal - bereits für dieses Ticket gutgeschriebene Punkte
```

Beispiele:

- Streak 1 → Priority +100, Team +100 = 200
- Streak 2 → Priority +100, Team +300 = 400
- Streak 3 → Priority +100, Team +500 = 600

Teilweise richtig:

- Priority richtig / Team falsch → 100, streak 0
- Priority falsch / Team richtig → 100, streak 0
- beide falsch → 0, streak 0

Kein künstlicher Cap.

### Reset

Neue Sitzung und `reset()`:

`streak = 0`

`currentPriorityWasCorrect = nil`

### Übergabe an Modul 032

UI darf Punkte nicht selbst berechnen.

Modul 031 stellt eine eindeutige fachliche Quelle bereit, aus der Modul 032 nach Team-Evaluation lesen kann:

- tatsächlich beim Teamabschluss gutgeschriebene Punkte
- resultierende Streak
- ob das Ticket vollständig korrekt war

Reale Übergabeschnittstelle:

- `lastTeamAwardedPoints`
- `lastCompletedTicketWasFullyCorrect`
- `lastCompletedTicketStreak`

`evaluatePriority() -> Bool?` und `evaluateTeam() -> Bool?` bleiben kompatibel. Die Streak-Sound- und Feedback-Orchestrierung folgt in Modul 032.
