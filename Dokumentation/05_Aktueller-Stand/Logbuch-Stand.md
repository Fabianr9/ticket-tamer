# Projektlogbuch — Ticket Tamer

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Stand:** Start v1.3 vor Modul `027` — Neue Ticketdaten und 16er-Sitzung  
**Eingearbeitet am:** 2026-09-03

## Versionsentscheidung

Version 1.2 gilt auf ausdrückliche Projektentscheidung als abgeschlossen und bildet die stabile Ausgangsbasis für v1.3.

Die neue v1.3-Planung erweitert gezielt den bestehenden Stand. Navigation, räumliche Kerninteraktion, Replay-Fix, Monster-Farbvarianten, Drop-Regeln und Exactly-once werden nicht neu aufgebaut.

## Neue v1.3-Anforderungen

- 16 vollständig neue Ticketinhalte TT-001 bis TT-016
- Ticketanzahlbereich 1...16 bei Standard 6
- feste lokale Video-Referenz pro Ticket
- optionale lokale Ticketvideos
- vier bereitgestellte JPEG-Teamlogos
- 4 Correct- + 4 Incorrect-Monster-Sounds
- 2 zusätzliche Streak-Sounds
- zentraler Streak-State
- Multiplikator-Scoring vollständig korrekter Tickets
- temporäre x2/x3/x4+-Streakvisualisierung
- klare Ressourcenstruktur für Audio, Logos und Videos

## v1.3-Modul-Landkarte

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung | F-01, F-02, F-03, F-04, F-22, F-31 | als Nächstes |
| 028 | Teamlogos v1.3 | F-28, F-39 | offen |
| 029 | Monster- und Streak-Audio | F-12, F-34, F-35, F-39 | offen |
| 030 | Ticketvideo-System | F-03, F-32, F-33, F-39 | offen |
| 031 | Streak-State und Scoring | F-11, F-16, F-36, F-37 | offen |
| 032 | Streak-Feedback v1.3 | F-18, F-21, F-35, F-38 | offen |
| 033 | Integration und Abnahme v1.3 | F-01 bis F-39, Schwerpunkt F-31 bis F-39 | offen |

## Verbindliche Ticketverteilung

TT-001 bis TT-012 behalten die bestätigten Referenzlösungen der bisherigen vollständigen 4×3-Matrix.

Zusätzliche Tickets:

- TT-013 → Netzwerk + Wichtig
- TT-014 → Konto + Normal
- TT-015 → Software + Wichtig
- TT-016 → Hardware + Kritisch

Gesamt:

| Team | Normal | Wichtig | Kritisch | Gesamt |
|---|---|---|---|---:|
| Netzwerk | TT-001 | TT-002, TT-013 | TT-003 | 4 |
| Konto | TT-004, TT-014 | TT-005 | TT-006 | 4 |
| Software | TT-007 | TT-008, TT-015 | TT-009 | 4 |
| Hardware | TT-010 | TT-011 | TT-012, TT-016 | 4 |
| **Gesamt** | **5** | **6** | **5** | **16** |

## Verbindliche Ticketquelle

Neue sichtbare Ticketinhalte werden nicht erfunden.

Verbindliche Quelle:

`Tickets/Ticket-Tamer_Tickets.md`

Diese Datei wird in Modul 027 vollständig gelesen und strukturiert in den lokalen Swift-Ticketkatalog übertragen.

Die Markdown-Datei wird nicht zur Laufzeit geparst.

## Ticketvideo-Referenzen

Jedes Ticket besitzt genau eine feste Referenz:

- TT-001 → `TT-001.mp4`
- ...
- TT-016 → `TT-016.mp4`

Modul 027 darf die Datenreferenz ergänzen; die Videoansicht und Wiedergabelogik gehören zu Modul 030.

## Ticketanzahl

Neue Grenze:

`1...16`

Standard:

`6`

Bei 1 Minus disabled, bei 16 Plus disabled.

## Streak-Grundsatz für spätere Module

Noch nicht in Modul 027 implementieren.

Verbindlich:

- neue Sitzung `streak = 0`
- nur vollständig korrektes Ticket erhöht Streak
- teilweise/falsches Ticket setzt auf 0
- kein künstlicher Cap
- vollständig korrektes Ticket bei Streak n → `200 × n` Ticketpunkte
- Multiplikator erst bei Teamabschluss sichtbar
- x2/x3 normal, x4+ prägnanter
- kein dauerhafter Streak im HUD

## Ressourcenstruktur v1.3

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

Die konkrete Übernahme erfolgt in den Modulen 028–030.

## Geschützter v1.2-Bestand

Nicht regressieren:

- Replay-Layoutstabilität
- Ergebnis `X Punkte`
- falsches Feedback `0 Punkte`
- Debug-UI-Isolation
- 16 Monster-Farbvarianten
- Session-HUD
- Ticketinfo
- Interaktionshinweise
- Monster-Retry
- Drag/Drop
- 50-%-Overlap
- Z-Toleranz
- Snapback
- Exactly-once
- zentrales Volume

## Offene Ausgangsdaten vor Modul 027

Ein finaler `026-Report.md` wurde in diesem Logbuch nicht eingearbeitet. v1.2 wurde vom Projektteam ausdrücklich als abgeschlossen bestätigt.

Modul 027 muss deshalb im Repository real feststellen:

- finalen v1.2-Branch
- finalen v1.2-Commit
- aktuelle Testzahl
- aktuellen Build-/Simulatorstatus
- aktuellen lokalen Ticketkatalog
- tatsächliche Position von `Tickets/Ticket-Tamer_Tickets.md`

Keine alten Werte erfinden.

## Nächster Schritt

`027-Eingangsprompt.md` ausführen.
