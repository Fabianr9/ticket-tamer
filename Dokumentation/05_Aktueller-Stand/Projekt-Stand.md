# Projekt-Stand — Ticket Tamer

> Aktueller technischer Stand nach Modul 011.

**Stand:** nach Modul `011` — Ergebnis und Neustart  
**Eingearbeitet am:** 2026-08-12  
**Branch laut Report:** `main`  
**010-Commit:** `0ab0ef7 010: Bewertung und Audiofeedback`  
**011-Commit:** Hash offen  
**Build nach 011:** offen  
**Simulator nach 011:** offen  
**Testdeklarationen:** 155  
**Vollständiger Testlauf:** offen

## Aktueller Funktionsstand

Auf Codeebene vorhanden:

- genau ein zentrales volumetrisches Fenster
- deutsche Startansicht
- 1–12 Tickets, Standard 6
- zwölf lokale Tickets
- zentrales `SessionModel`
- Untersuchungsphase
- Priorisierungsphase
- Teamzuordnungsphase
- Drag-/Drop-Grundlage
- genau-einmal-Speicherung von Priorität und Team
- +100/0-Bewertung
- zwei lokale Audio-Platzhalter
- 1,5-Sekunden-Auto-Transition
- Wechsel zum nächsten Ticket
- Ergebnisphase
- Ergebnisansicht
- vollständiger Reset zurück zur Startansicht

Damit ist der vollständige Pflicht-Spielzyklus auf Implementierungsebene geschlossen.

## Relevanter Dateibaum

```text
Ticket_Tamer/
├─ Ticket_Tamer/
│  ├─ App/
│  │  └─ Ticket_TamerApp.swift
│  ├─ Assets/
│  │  └─ MonsterAssetProvider.swift
│  ├─ Components/
│  │  └─ DropTargetComponent.swift
│  ├─ Data/
│  │  └─ LocalTicketCatalog.swift
│  ├─ Debug/
│  │  └─ DebugManager.swift
│  ├─ Models/
│  │  ├─ GamePhase.swift
│  │  ├─ SessionModel.swift
│  │  └─ Ticket.swift
│  ├─ Resources/
│  │  ├─ Localizable.xcstrings
│  │  ├─ correct.wav
│  │  └─ incorrect.wav
│  ├─ Services/
│  │  ├─ AudioService.swift
│  │  ├─ DropEvaluator.swift
│  │  └─ MonsterInteractionConfigurator.swift
│  ├─ Support/
│  │  └─ AppConstants.swift
│  ├─ Views/
│  │  ├─ Debug/
│  │  │  └─ DebugInteractionHarnessView.swift
│  │  ├─ InvestigationView.swift
│  │  ├─ PrioritizationView.swift
│  │  ├─ ResultView.swift
│  │  ├─ RootVolumeView.swift
│  │  ├─ StartView.swift
│  │  └─ TeamAssignmentView.swift
│  ├─ Assets.xcassets
│  └─ Info.plist
├─ Ticket_TamerTests/
│  └─ Ticket_TamerTests.swift
└─ Packages/
   └─ RealityKitContent/
      └─ Sources/RealityKitContent/RealityKitContent.rkassets/
         ├─ Scene.usda
         ├─ monster01.usda
         ├─ monster02.usda
         ├─ monster03.usda
         ├─ monster04.usda
         └─ Materials/
            └─ GridMaterial.usda
```

## Root-Phasenrouting

```text
RootVolumeView
├─ .start
│  └─ StartView
├─ .untersuchen
│  └─ InvestigationView
├─ .priorisieren
│  └─ PrioritizationView
├─ .teamZuordnen
│  └─ TeamAssignmentView
└─ .ergebnis
   └─ ResultView
```

## ResultView

Sichtbar:

- `model.score` als große Zahl
- `Erneut spielen`

Nicht sichtbar:

- Ticketanzahl
- Statistik
- richtige Lösungen
- Badges
- Highscore
- Ranking

Button-Aktion:

`model.reset()`

## Reset

Nach `reset()`:

- Ticketanzahl 6
- leere Sitzungstickets
- Index 0
- Phase `.start`
- Score 0
- Priorität nil
- Team nil
- Input-Lock false
- Bewertungsflags false

## Teststand

| Bereich | Stand |
|---|---|
| Tests vor 011 | 140 |
| neue Tests | 15 |
| Tests nach 011 | 155 |
| vollständiger Lauf | offen |

## Pflichtanforderungen — Implementierungsstatus

| Bereich | Stand |
|---|---|
| Start | implementiert |
| lokale Tickets | implementiert |
| Sitzungsauswahl | implementiert |
| Untersuchung | implementiert |
| Priorisierung | implementiert |
| Teamzuordnung | implementiert |
| Drag/Drop | implementiert |
| Scoring | implementiert |
| Audio | technisch implementiert mit Platzhaltern |
| Auto-Transition | implementiert |
| Ergebnis | implementiert |
| Reset | implementiert |

## Noch offene Pflichtabnahme

- Build
- vollständige 155 Tests
- Simulator-End-to-End
- Audiohörbarkeit
- Gesten
- ResultView
- fünf Neustarts
- finale Blender-Monster
- Vision-Pro-Gerätetest

## Modul 012

F-17 bedeutet **optionale Monsterreaktion**, nicht Highscore/Persistenz.

Modul 012 darf nur einfache visuelle Monsterreaktionen ergänzen und ist nicht verpflichtend.

Bei Zeitdruck direkt Modul 013 starten.

## Monster-Status

Vier USDA-Platzhalter vorhanden. Vier finale eigene Blender-Monster fehlen weiterhin.

## Audio-Status

Zwei projekt-eigene WAV-Platzhalter vorhanden. Hörbarkeit und finale Soundentscheidung offen.
