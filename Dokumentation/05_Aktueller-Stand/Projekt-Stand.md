# Projekt-Stand — Ticket Tamer

> Aktuelle technische Landkarte nach Modul 032 der Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**Stand:** nach Modul 032  
**Branch:** `v1.3`  
**Modul-031-Commit:** `df4b6f5`  
**Modul-032-Commit:** offen  
**Testdeklarationen:** **576**  
**Build/Test/Simulator:** offen

## v1.3 Featurestand

### 027 — Tickets
- TT-001 bis TT-016
- Auswahl 1...16
- Standard/Reset 6

### 028 — Teamlogos
- vier lokale JPEGs
- `TeamLogoCatalog`
- Text bleibt sichtbar
- Dropgeometrie unverändert

### 029 — Audio
- 4 Correct-Monster-Sounds
- 4 Incorrect-Monster-Sounds
- 2 Streak-Sounds
- zentrale Kataloge
- zufällige, deterministisch testbare Auswahl

### 030 — Videos
- 16 lokale MP4s
- `TicketVideoResourceProvider`
- `TicketVideoView`
- Auto-Play nach Tap
- Pause/Fortsetzen
- X
- Auto-Close
- Fehlerzustand

### 031 — Streak & Scoring
- `streak`
- `currentPriorityWasCorrect`
- `lastTeamAwardedPoints`
- `lastCompletedTicketWasFullyCorrect`
- `lastCompletedTicketStreak`

Vollständig korrekt:

`Ticket total = 200 × streak`

### 032 — Streak-Feedback

- dynamische Team-Punkte
- x2/x3 normal
- x4+ größer + Scale-Pulse
- kein x1
- kein dauerhafter Streak im HUD
- Streak-Sound 0.2 s nach positivem Monster-Sound
- Gesamtfeedback weiter 1.5 s

## Audiofolge

```text
Team evaluate
→ Monster-Sound
→ 0.2 s
→ optional Streak-Sound
→ verbleibende 1.3 s
→ Transition
```

Nur wenn vollständig korrekt und Streak >= 2.

## Tests

Aktuell:

**576 Testdeklarationen**

Vollständiger Apple-Toolchain-Lauf offen.

## v1.3-Modul-Landkarte

| Modul | Status |
|---|---|
| 027 | implementiert |
| 028 | implementiert |
| 029 | implementiert |
| 030 | implementiert |
| 031 | implementiert |
| 032 | implementiert |
| 033 | als Nächstes: Integration & Abnahme |

## Modul 033 — Fokus

SPEC:

`F-01 bis F-39, Schwerpunkt F-31 bis F-39`

Verbindlich abzunehmen:

- 16 neue Tickets
- 16 Videos
- 4 Teamlogos
- 8 Monster-Sounds
- 2 Streak-Sounds
- zentrale Ressourcenstruktur
- Streak-State
- Multiplikator-Scoring
- dynamische Zusatzpunkte
- x2/x3/x4+-Feedback
- Reset
- Replay
- Regression gegen v1.2

## v1.3 Ressourcenstruktur

```text
Resources/
├── Audio/
│   ├── MonsterSounds/
│   │   ├── Correct/
│   │   └── Incorrect/
│   └── StreakSounds/
├── TeamLogos/
└── Videos/
```

## Geschützte Kernregeln

- genau ein zentrales Volume
- keine neue Produktnavigation
- `SessionModel` zentrale fachliche Source of Truth
- 1...16 Tickets
- 50-%-Drop
- Z-Toleranz 0.05 m
- Snapback
- Retry gleiche Monstervariante
- Exactly-once
- Replay-Layoutstabilität
- keine Lösungsausgabe
