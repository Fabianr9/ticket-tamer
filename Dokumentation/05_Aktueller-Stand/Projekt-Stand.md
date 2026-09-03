# Projekt-Stand — Ticket Tamer

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Nächstes Modul:** 027 — Neue Ticketdaten und 16er-Sitzung

## Bestehender stabiler Kern

Aus v1.0–v1.2 vorhanden:

- genau ein zentrales Volume
- Startansicht
- Minus/Slider/Plus
- Standard 6
- SessionModel
- zufällige Auswahl ohne Wiederholung
- Untersuchung
- Priorisierung
- Teamzuordnung
- HUD
- Ticketinfo
- Interaktionshinweise
- Drag/Drop
- 50-%-Dropregel
- Snapback
- Exactly-once
- Scoring
- Audiofeedback
- visuelles Punktefeedback
- Monster-Retry
- Replay-Layoutstabilisierung
- Ergebnis `X Punkte`
- Debug-UI-Isolation
- vier Monstertypen mit 16 Farbvarianten

## v1.3-Modul-Landkarte

| Modul | Titel |
|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung |
| 028 | Teamlogos v1.3 |
| 029 | Monster- und Streak-Audio |
| 030 | Ticketvideo-System |
| 031 | Streak-State und Scoring |
| 032 | Streak-Feedback v1.3 |
| 033 | Integration und Abnahme v1.3 |

## Modul 027 — Zielzustand

### Ticketpool

Genau TT-001 bis TT-016.

### Verteilung

- jedes Team exakt 4 Tickets
- Normal 5
- Wichtig 6
- Kritisch 5

### Referenzmatrix

TT-001 bis TT-012 behalten die bestehende 4×3-Matrix.

Zusätzlich:

- TT-013 Netzwerk + Wichtig
- TT-014 Konto + Normal
- TT-015 Software + Wichtig
- TT-016 Hardware + Kritisch

## Ticketmodell v1.3

Zielstruktur laut SPEC:

```text
Ticket
- id
- ticketNumber
- title
- shortDescription
- userImpact
- symptoms
- referencePriority
- referenceTeam
- monsterTypeId
- videoAssetName
```

Modul 027 darf `videoAssetName` als Datenreferenz ergänzen, falls der reale Tickettyp es noch nicht besitzt.

Wiedergabe gehört erst zu Modul 030.

## Ticketquelle

Verbindlich:

`Tickets/Ticket-Tamer_Tickets.md`

Die 16 sichtbaren Tickettexte müssen daraus übernommen werden.

Nicht aus diesem Projektstand erfinden.

## Auswahlgrenze

Neu:

`1...16`

Standard:

`6`

Slider, Minus/Plus und technische Clamp müssen dieselbe Grenze verwenden.

## Noch nicht in Modul 027

Nicht implementieren:

- JPEG-Teamlogos
- neue Monster-/Streak-Sounds
- Videoansicht
- AVPlayer/AVKit
- Streak-State
- Streak-Scoring
- Streak-Overlay
- Streak-Sounds

## Preflight erforderlich

Da kein 026-Report in diesem Logbuch vorliegt:

- finalen v1.2-Gitstand real ermitteln
- reale aktuelle Testzahl ermitteln
- aktuellen Tickettyp/Katalog lesen
- Ticket-Markdown real lesen
