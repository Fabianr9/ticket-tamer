# Projekt-Stand — Ticket Tamer

> Aktuelle Code-Landkarte nach Modul 017 der Version 1.1.

**Projektversion:** v1.1 in Arbeit  
**v1.0:** abgeschlossen  
**Stand:** nach Modul `017` — Startseiten-Usability  
**Branch laut Report:** `side`  
**HEAD vor 017:** `0d25719`  
**Modul-016-Commit:** `8d60045`  
**Modul-016-Layoutfix:** `0d25719`  
**Modul-017-Commit:** offen  
**Testdeklarationen:** 261  
**Build/Test/Simulator nach 017:** offen

## v1.1-Funktionsstand

### Modul 015

- Session-HUD
- Ticketfortschritt
- Phasentitel
- permanente Drag-Hinweise

### Modul 016

- kompakte Ticketinfo
- Info-Toggle
- lokaler Overlay-State
- Drag-Sperre bei offenem Overlay
- X-Schließen
- Phasenreset

### Modul 017

- Kurzbeschreibung auf Startseite
- Minus
- bestehender Slider
- Plus
- Grenzdeaktivierung
- Accessibility

## StartView nach Modul 017

Source of Truth:

`SessionModel.selectedTicketCount`

Bedienelemente:

```text
Ticket Tamer
Kurzbeschreibung

Anzahl Tickets
[ - ] [ Slider ] [ + ]
          6

[ Spiel starten ]
```

Exakte Beschreibung:

`Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.`

Accessibility:

- Minus: `Ein Ticket weniger`
- Plus: `Ein Ticket mehr`

Grenzen:

- 1 → Minus disabled
- 12 → Plus disabled

Reset:

- zurück auf 6

## Relevanter v1.1-Dateibaum

```text
Ticket_Tamer/Ticket_Tamer/
├─ Models/
│  ├─ SessionModel.swift
│  └─ Ticket.swift
├─ Resources/
│  └─ Localizable.xcstrings
├─ Support/
│  └─ AppConstants.swift
└─ Views/
   ├─ StartView.swift
   ├─ InvestigationView.swift
   ├─ PrioritizationView.swift
   ├─ TeamAssignmentView.swift
   └─ Components/
      ├─ CompactTicketInfoView.swift
      ├─ InteractionHintView.swift
      ├─ ScaledToFitView.swift
      └─ SessionHUDView.swift
```

## Modul-016-Layoutstand

Bestätigt aus realem Diff:

- Volume: `1.2 × 1.15 × 0.45 m`
- Investigation-Monsterzielgröße: `0.20 m`
- Priorisierung/Team-Monsterzielgröße: `0.11 m`
- Ticketinfo-Designfläche: `520 × 560 pt`

Modul 017 verändert diese Werte nicht.

## Tests

- vor 017: 246
- +15
- aktuell: 261 Testdeklarationen
- vollständiger Xcode-Lauf offen

## v1.1-Modul-Landkarte

| Modul | Aufgabe | Status |
|---|---|---|
| 015 | HUD + Hinweise | implementiert; Laufzeitabnahme offen |
| 016 | Kompakte Ticketinfo | implementiert; Laufzeitabnahme offen |
| 017 | Startseiten-Usability | implementiert; Laufzeitabnahme offen |
| 018 | Visuelles Entscheidungsfeedback | als Nächstes |
| 019 | Ladefehler-Recovery | offen |
| 020 | v1.1-Integration | offen |

## Für Modul 018 relevant

Vorhandene Bewertungslogik aus Modul 010:

- `evaluatePriority() -> Bool?`
- `evaluateTeam() -> Bool?`
- richtig → +100 / `true`
- falsch → +0 / `false`
- erneut/ungültig → `nil`

Vorhandener Feedbackflow:

```text
gültige Entscheidung
→ evaluate...
→ Bool richtig/falsch
→ passender Sound
→ ca. 1,5 s
→ nächster Phasenwechsel
```

Modul 018 darf ausschließlich das bereits vorhandene Bool-Ergebnis zur Darstellung verwenden.

Nicht erneut vergleichen:

- `referencePriority`
- `referenceTeam`

Nicht erneut Punkte vergeben.

## F-21-Sichtlogik

Richtig:

- grüner Haken
- `+100 Punkte`

Falsch:

- rotes Kreuz
- kein `+0 Punkte`
- kein anderer Punktetext

Immer:

- parallel zu Sound
- nur im bestehenden Feedbackfenster
- keine Lösung
- Lock bleibt bestehen
- genau ein Sound / eine Bewertung / ein Phasenwechsel
