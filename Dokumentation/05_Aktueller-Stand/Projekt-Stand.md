# Projekt-Stand — Ticket Tamer

> Aktuelle technische Landkarte nach Modul 029 der Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**Stand:** nach Modul 029  
**Branch:** `v1.3`  
**Modul-027-Commit:** `72d3e04`  
**Modul-028-Commit:** `120ab6d`  
**Reale Testdeklarationen:** **436**  
**Build/Test/Simulator:** offen

## Teststand

Die realen Gitstände ergeben:

- Modul-027-Commit `72d3e04`: 372 Testdeklarationen
- Modul-028-Commit `120ab6d`: 401 Testdeklarationen
- Modul 029: +35
- aktueller Stand: 436

## v1.3-Funktionsstand

### 027 — Tickets

- TT-001 bis TT-016
- Auswahl 1...16
- Standard/Reset 6
- Video-Datenreferenz TT-xxx.mp4

### 028 — Teamlogos

Zentrale Ressource:

`Support/TeamLogoCatalog.swift`

Produktive Logos:

- Netzwerk → `Network_team_icon_design_202609032139.jpeg`
- Konto → `Team_icon_design_profile_lock_202609032138.jpeg`
- Software → `Software_team_icon_design_202609032138.jpeg`
- Hardware → `Hardware_team_icon_design_202609032138.jpeg`

Zielpfad:

`Resources/TeamLogos/`

Teamtext bleibt.

SF Symbols sind für die produktive v1.3-Teamstation abgelöst.

## Teamgeometrie unverändert

- Panelbreite Referenz: 0.195 m
- Panelhöhe: 0.117 m
- Paneltiefe: 0.020 m
- Drop overlap: 0.50
- Z-Toleranz: 0.05 m

## v1.3-Modul-Landkarte

| Modul | Status |
|---|---|
| 027 | committed |
| 028 | committed `120ab6d`; Laufzeit OPEN |
| 029 | implementiert; Laufzeit OPEN |
| 030 | als Nächstes |
| 031 | offen |
| 032 | offen |
| 033 | offen |

## Modul 029 — Audio

v1.3 verlangt:

### Monster-Feedback

- 4 lokale Correct-WAVs
- 4 lokale Incorrect-WAVs
- je gültiger Einzelentscheidung genau 1 Monster-Sound
- passende Gruppe nach Bewertung
- Auswahl zufällig
- direkte Wiederholung erlaubt
- deterministisch testbare Auswahl

### Streak-Audio

- 2 lokale WAVs
- Sound 01 → x2/x3
- Sound 02 → x4+
- 0/1 → kein Streak-Sound
- niemals bei Prioritätsentscheidung
- produktiver Trigger erst zusammen mit realem Streak-State/Teamabschluss in Modul 032

## Zielstruktur

```text
Resources/
└── Audio/
    ├── MonsterSounds/
    │   ├── Correct/
    │   └── Incorrect/
    └── StreakSounds/
```

Produktive Dateien sind eindeutig als `monster_correct_01...04.wav`,
`monster_incorrect_01...04.wav` und `streak_01...02.wav` benannt.

`MonsterFeedbackSoundCatalog` kapselt die 4+4-Gruppen und die injizierbare Auswahl.
`StreakSoundCatalog` mappt 2/3 auf Sound 01 und 4+ auf Sound 02. Der produktive
Streak-Trigger bleibt bis Modul 032 offen.

## Audioarchitektur

`AudioService.playMonsterFeedback(evaluation:selector:)` ersetzt den historischen
Einzel-Soundaufruf innerhalb der bestehenden Exactly-once-Tasks. Separate Monster-
und Streak-Player bereiten eine spätere zeitversetzte Streak-Wiedergabe vor.

Die historischen `correct.wav` und `incorrect.wav` bleiben unreferenziert bestehen.

## Noch nicht in Modul 029

Nicht implementieren:

- `streak` in SessionModel
- Streak-Mutation
- Multiplikator-Scoring
- x2/x3/x4+-Overlay
- Team-Zusatzpunktelogik
- Video-UI
