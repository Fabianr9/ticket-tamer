# Projekt-Stand — Ticket Tamer

> Aktuelle technische Landkarte nach Modul 031 der Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**Stand:** nach Modul 031  
**Branch:** `v1.3`  
**Modul-030-Commit:** `8041bf9`  
**Modul-031-Commit:** offen  
**Testdeklarationen:** **522**  
**Build/Test/Simulator:** offen

## v1.3-Stand

### 027 — Tickets
- TT-001...TT-016
- Auswahl 1...16
- Video-Referenzen

### 028 — Teamlogos
- vier lokale JPEGs
- `TeamLogoCatalog`

### 029 — Audio
- 4 Correct
- 4 Incorrect
- Streak 01 / 02
- `playStreak(for:)`

### 030 — Videos
- 16 lokale MP4s
- `TicketVideoResourceProvider`
- `TicketVideoView`

### 031 — Streak & Scoring

Neu in `SessionModel`:

```text
streak
currentPriorityWasCorrect
lastTeamAwardedPoints
lastCompletedTicketWasFullyCorrect
lastCompletedTicketStreak
```

## Scoring

Vollständig korrekt:

```text
ticketTotal = 200 × streak
teamCredit = ticketTotal - 100
```

Beispiele:

- x1 → Team +100
- x2 → Team +300
- x3 → Team +500
- x4 → Team +700

Teilweise richtig:

nur Basispunkte, Streak 0.

## Modul 032 — Source of Truth

Die UI soll nach `evaluateTeam()` nur lesen:

- `lastTeamAwardedPoints`
- `lastCompletedTicketWasFullyCorrect`
- `lastCompletedTicketStreak`

Nicht:

- Referenzpriorität erneut vergleichen
- Referenzteam erneut vergleichen
- Score-Deltas aus globalem Score ableiten
- Streak lokal berechnen

## Aktuelles visuelles Feedback

Historisch:

Priorität:
- correct → Haken + `+100 Punkte`
- incorrect → X + `0 Punkte`

Team:
- aktuell noch gleiche statische Darstellung
- muss in Modul 032 dynamisch werden

v1.3-Ziel:

Priorität:
- richtig immer `+100 Punkte`

Team:
- richtig zeigt exakt `lastTeamAwardedPoints`
- falsch `0 Punkte`

Beispiele:
- x1 vollständig korrekt → `+100 Punkte`
- x2 → `+300 Punkte`
- x3 → `+500 Punkte`
- x4 → `+700 Punkte`
- Priority falsch / Team richtig → `+100 Punkte`

## Streak-Overlay

Nur Teamphase.

Nur wenn:

```text
lastCompletedTicketWasFullyCorrect == true
&& lastCompletedTicketStreak >= 2
```

Darstellung:

- x2 / x3 normal
- x4+ sichtbar größer
- x4+ zusätzliche kurze Puls-/Scale-Animation
- nicht dauerhaft im HUD

## Streak-Audio

Vorhandenes Mapping aus 029:

- 0/1 → kein Sound
- 2/3 → `streak_01.wav`
- 4+ → `streak_02.wav`

Nur qualifizierter vollständig korrekter Teamabschluss.

Monster-Correct-Sound bleibt ebenfalls genau einmal.

Streak-Sound leicht zeitversetzt/nacheinander, nicht versehentlich gleichzeitig.

## Tests

Aktuell:

**522 Testdeklarationen**

Apple-Toolchainlauf offen.

## v1.3-Modul-Landkarte

| Modul | Status |
|---|---|
| 027 | committed |
| 028 | committed |
| 029 | committed |
| 030 | committed |
| 031 | implementiert; Toolchain OPEN |
| 032 | als Nächstes |
| 033 | offen |
