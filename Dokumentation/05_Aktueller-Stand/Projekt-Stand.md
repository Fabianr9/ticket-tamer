# Projekt-Stand — Ticket Tamer

**Projektversion:** v1.2 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**Nächstes Modul:** 021 — Replay-Layoutstabilisierung

## Bestehender Kern

Vorhanden aus v1.0/v1.1:

- Startansicht mit Ticketsteuerung
- Startseitenbeschreibung
- lokaler Ticketkatalog
- SessionModel
- Untersuchung
- Priorisierung
- Teamzuordnung
- Session-HUD
- Interaktionshinweise
- kompakte Ticketinfo
- Drag-Sperre bei Ticketinfo
- 50-%-Drop-Regel
- Snapback
- Exactly-once
- Scoring
- Audio
- visuelles Feedback
- Ladefehler-Recovery
- Ergebnis
- Reset
- vier Monstertypen

## v1.2-Zielstand

### 021 — Replay-Layoutstabilisierung
Replaybedingtes Schrumpfen/Wachsen/Driften beseitigen und aktuelle Volume-Größe erhalten.

### 022 — Punktekommunikation v1.2
- Ergebnis `X Punkte`
- falsches Feedback `0 Punkte`

### 023 — Teamstation-Symbole
Text + semantisches Symbol.

### 024 — Debug-UI-Isolation
DEV-Schaltfläche aus normalem Flow entfernen.

### 025 — Monster-Farbvarianten
16 Varianten mit sitzungsstabiler Auswahl.

### 026 — Integration v1.2
AK-25 bis AK-30 gemeinsam abnehmen.

## Replay-Layoutregeln

Beim Replay:

- aktuelle Volume-Größe erhalten
- keine Rückkehr auf Cold-Start-Defaultgröße
- keine kumulative Größenänderung
- StartView stabil
- Slider stabil
- Prioritätsziele stabil
- Teamziele stabil
- mindestens fünf Replay-Zyklen stabil

Fachlicher Reset bleibt:

- Ticketanzahl 6
- Score 0
- Index 0
- keine Entscheidungen
- keine alten Sitzungstickets

## Relevante Architektur für Modul 021

Primäre Kandidaten:

- `Ticket_TamerApp.swift`
- `RootVolumeView.swift`
- gemeinsame Root-/Volume-Layoutlogik
- `StartView.swift`
- `PrioritizationView.swift`
- `TeamAssignmentView.swift`
- `VolumeMetrics`
- `TargetPanelLayout`
- `ScaledToFitView`

Verbindlich:

- keine unabhängigen Replay-Hacks in mehreren Phasen
- tatsächliche gewährte Geometrie verwenden
- `.defaultSize` nicht als Replay-Reset verwenden
- Nutzer-/System-Resize erhalten
- keine kumulativen Scale-Faktoren

## Neue v1.2-Zustände erst ab Modul 025

Monster-Variantenmapping ist noch nicht Teil von Modul 021.

Später fachlich:

```text
selectedMonsterVariantByTicketID
```

aber noch nicht jetzt implementieren.

## Modul-Landkarte

| Modul | Status |
|---|---|
| 021 | als Nächstes |
| 022 | offen |
| 023 | offen |
| 024 | offen |
| 025 | offen |
| 026 | offen |

## Im 021-Preflight real zu ermitteln

- finaler v1.1-Branch
- finaler v1.1-Commit
- tatsächliche aktuelle Testzahl
- Buildstatus
- aktuelle Volume-/Window-Konfiguration
- reproduzierbares Replay-Verhalten
