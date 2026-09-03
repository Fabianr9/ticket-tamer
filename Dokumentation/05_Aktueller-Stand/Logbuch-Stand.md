# Projektlogbuch — Ticket Tamer

**Projektversion:** v1.2 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**Stand:** Start v1.2 vor Modul `021` — Replay-Layoutstabilisierung  
**Eingearbeitet am:** 2026-09-03

## Versionsentscheidung

Version 1.1 gilt als abgeschlossen und bildet die stabile Ausgangsbasis für v1.2.

F-01 bis F-24 und AK-01 bis AK-24 werden nicht neu implementiert. Sie bleiben Regression-Basis.

Version 1.2 beginnt mit:

- F-25 / AK-25 — Replay-Layoutstabilität
- F-26 / AK-26 — Ergebnis als „X Punkte“
- F-27 / AK-27 — `0 Punkte` bei falscher Entscheidung
- F-28 / AK-28 — Symbole an Teamstationen
- F-29 / AK-29 — DEV-Schaltfläche aus normalem Flow entfernen
- F-30 / AK-30 — 16 Monster-Farbvarianten

## v1.2-Modul-Landkarte

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 021 | Replay-Layoutstabilisierung | F-25 / AK-25 | als Nächstes |
| 022 | Punktekommunikation v1.2 | F-26, F-27 / AK-26, AK-27 | offen |
| 023 | Teamstation-Symbole | F-28 / AK-28 | offen |
| 024 | Debug-UI-Isolation | F-29 / AK-29 | offen |
| 025 | Monster-Farbvarianten | F-30 / AK-30 | offen |
| 026 | Integration und Abnahme v1.2 | AK-25 bis AK-30 | offen |

## v1.2-Grundsätze

Unverändert bleiben:

- Scoringregeln
- 50-%-Drop-Regel
- Z-Toleranz
- Snapback
- Exactly-once
- lineare Phasenfolge
- Ticketreferenzwerte
- Audiofeedback
- ca. 1,5-s-Transition
- genau ein zentrales Volume
- kein Immersive Space
- kein zweites Volume

`SessionModel` bleibt die einzige fachliche Source of Truth.

## Replay-Stabilität

Nach Ergebnis → `Erneut spielen` dürfen Startansicht, Slider, Texte, Prioritätsziele und Teamziele nicht replaybedingt schrumpfen, wachsen oder kumulativ driften.

Die aktuell tatsächlich verwendete Volume-Größe bleibt erhalten.

`SessionModel.reset()` setzt die fachliche Sitzung zurück, nicht die Volume-/Root-Geometrie.

Die Replay-Korrektur gehört primär in:

- `Ticket_TamerApp`
- `RootVolumeView`
- gegebenenfalls eine gemeinsame Root-Layoutkomponente

Nicht in mehrere voneinander unabhängige phasenspezifische Replay-Hacks.

## Neue v1.2-Erweiterungen nach Modul 021

### Modul 022

- Ergebnis `X Punkte`
- falsch: rotes Kreuz + `0 Punkte`
- richtig bleibt grüner Haken + `+100 Punkte`

### Modul 023

Teamstationen erhalten zusätzlich zum Text semantische Symbole.

### Modul 024

`🔧 Team [DEV]` verschwindet vollständig aus dem normalen App-Flow.

### Modul 025

Vier Monstertypen × vier Varianten = 16 lokale Assets.

Pro Sitzungsticket:

- genau eine konkrete Variante
- in allen Phasen stabil
- Retry lädt dieselbe Variante
- neue Sitzung darf neu wählen
- Reset verwirft Mapping

## Offene Ausgangsdaten vor 021

Ein finaler `020-Report.md` wurde in diesem Logbuch nicht eingearbeitet. v1.1 wurde vom Projektteam als abgeschlossen bestätigt.

Modul 021 muss daher real aus dem Repository ermitteln:

- finalen v1.1-Branch
- finalen v1.1-Commit
- aktuelle Testzahl
- aktuellen Buildstatus
- Simulator-/Gerätestatus

Keine Werte aus älteren Reports erfinden.

## Nächster Schritt

`021-Eingangsprompt.md` ausführen.

Modul 021 reproduziert den Replay-Skalierungsfehler zuerst messbar, behebt ihn zentral und nimmt mindestens fünf aufeinanderfolgende Replay-Zyklen ab.
