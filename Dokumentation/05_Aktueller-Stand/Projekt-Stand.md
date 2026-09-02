# Projekt-Stand — Ticket Tamer

> Aktuelle Code-Landkarte nach Modul 016 der Version 1.1.

**Projektversion:** v1.1 in Arbeit  
**v1.0:** abgeschlossen  
**Stand:** nach Modul `016` — Kompakte Ticketinfo  
**Branch laut Report:** `side`  
**HEAD vor 016:** `9fd8706363983cf1ad4ccabbfddab1f5aef08424`  
**Modul-015-Commit:** `afe4bce feat: Modul 15`  
**Modul-016-Commit:** offen  
**Testdeklarationen:** 246  
**Build/Test/Simulator nach 016:** offen

## v1.1-Funktionsstand

### Modul 015

Vorhanden:

- Session-HUD
- Ticket X von Y
- Phasentitel
- ProgressView
- dauerhafte Drag-Hinweise

### Modul 016

Vorhanden:

- kompakte Ticketinfo in Priorisierung
- kompakte Ticketinfo in Team
- lokaler Overlay-State
- Schließen per X
- Schließen per erneutem Info-Tap
- Drag-Sperre bei offenem Overlay
- Reset des Overlays bei View-/Phasenwechsel

## Relevanter Dateibaum

```text
Ticket_Tamer/Ticket_Tamer/
├─ Models/
│  ├─ SessionModel.swift
│  └─ Ticket.swift
├─ Resources/
│  └─ Localizable.xcstrings
├─ Views/
│  ├─ StartView.swift
│  ├─ InvestigationView.swift
│  ├─ PrioritizationView.swift
│  ├─ TeamAssignmentView.swift
│  └─ Components/
│     ├─ CompactTicketInfoView.swift
│     ├─ InteractionHintView.swift
│     ├─ ScaledToFitView.swift
│     └─ SessionHUDView.swift
└─ ...
```

`ScaledToFitView.swift` wird vom 016-Report als vorhandene Layoutkomponente referenziert; tatsächlichen Pfad im nächsten Preflight verifizieren.

## `CompactTicketInfoContent`

Enthält ausschließlich:

- ticketNumber
- title
- shortDescription
- userImpact
- symptoms

Nicht enthalten:

- referencePriority
- referenceTeam
- score
- selectedPriority
- selectedTeam
- interne ID
- monsterAssetId

## Overlay-State

Jeweils lokal in:

- `PrioritizationView`
- `TeamAssignmentView`

Semantik:

```text
isTicketInfoPresented = false
```

Keine SessionModel-Erweiterung.

## Drag-Freigabe

```text
!isTicketInfoPresented && !model.isInputLocked
```

Overlay darf den fachlichen Lock weder setzen noch lösen.

## Nachbesserte Layoutwerte aus Modul 016

Gemeldet:

### Volume

`1.2 × 1.15 × 0.45 m`

vorher:

`1.0 × 1.0 × 0.4 m`

### Monster-Zielgrößen

Untersuchung:

`0.20 m`

Priorisierung/Team:

`0.11 m`

### Ticketinfo-Designfläche

`520 × 560 pt`

Diese Werte sind laut Report durch Layouttests abgedeckt.

**Achtung:** Die reale Dateiänderungstabelle des Reports weist die Dateien hinter Volume-/Monstergrößenänderungen nicht vollständig aus. Nächster Preflight muss sie im Code/Git-Diff ermitteln.

## Tests

- vor 016: 228
- neu: 18
- nach 016: 246 Deklarationen
- vollständiger Xcode-Lauf offen

## v1.1-Modul-Landkarte

| Modul | Aufgabe | Status |
|---|---|---|
| 015 | HUD + Hinweise | implementiert; Laufzeitabnahme offen |
| 016 | Kompakte Ticketinfo | implementiert; Laufzeitabnahme offen |
| 017 | Startseiten-Usability | als Nächstes |
| 018 | Visuelles Feedback | offen |
| 019 | Ladefehler-Recovery | offen |
| 020 | v1.1-Integration | offen |

## Für Modul 017 relevante bestehende Schnittstellen

### `SessionModel`

- `selectedTicketCount`
- `setTicketCount(_:)`
- `reset()`
- `startSession()`

`setTicketCount(_:)` klemmt auf 1...12.

`reset()` setzt Ticketanzahl zurück auf 6.

### `StartView`

Bestehend aus v1.0:

- Titel
- `Anzahl Tickets`
- Slider
- aktuelle Zahl
- `Spiel starten`

Slider bindet direkt an `SessionModel.selectedTicketCount`.

## Modul 017

Ergänzt ausschließlich:

- Minus-Button
- Plus-Button
- Kurzbeschreibung unter Titel

Slider bleibt bestehen.

Alle drei Auswahloberflächen:

- Minus
- Slider
- Plus

müssen exakt denselben `SessionModel.selectedTicketCount` verwenden.

Kein lokaler Spiegelzustand.
