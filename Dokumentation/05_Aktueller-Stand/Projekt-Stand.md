# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `008` — Priorisierungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Modul-007-Commit:** `e450114 feat: update docs module 007`  
**Modul-008-Commit:** `200093b 008: Priorisierungsphase`  
**Build nach Modul 008:** nicht nachgewiesen  
**Simulatorstart nach Modul 008:** nicht nachgewiesen  
**Testlauf nach Modul 008:** nicht nachgewiesen  
**Testdeklarationen im Quellstand:** 86

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- deutsche Startansicht,
- zwölf lokale Tickets,
- zentrales `SessionModel`,
- Monsterzuordnung über `monsterAssetId`,
- lokale Monster-Ladepipeline,
- vier USDA-Platzhalter,
- Untersuchungsphase,
- kontrollierten Übergang `.untersuchen → .priorisieren`,
- generische RealityKit-Drag-/Drop-Grundlage,
- **echte `PrioritizationView`** mit drei räumlichen Prioritätszielen,
- deutsche Labels (Normal, Wichtig, Kritisch) als SwiftUI-Label-Attachments,
- `SessionModel.savePriority(_:)` für atomische Prioritätsspeicherung + Lock,
- Ziel-ID → `TicketPriority`-Mapping in `PriorityTargetMapping`,
- Input-Lock nach gültigem Drop,
- Monster-Rückkehr nach ungültigem Drop.

Noch nicht vorhanden:

- Teamstationen / `TeamAssignmentView`,
- Bewertung gegen `referencePriority`,
- Audio (Erfolg/Fehler),
- automatischer Übergang nach gültiger Entscheidung (Modul 010 / F-13),
- Ergebnisansicht.

## Repository- und Dokumentationsstruktur

```text
Ticket-Tamer/
├─ Ticket_Tamer/
│  ├─ Ticket_Tamer.xcodeproj/
│  │  └─ project.pbxproj
│  ├─ Ticket_Tamer/
│  │  ├─ App/
│  │  │  └─ Ticket_TamerApp.swift
│  │  ├─ Assets/
│  │  │  └─ MonsterAssetProvider.swift
│  │  ├─ Components/
│  │  │  └─ DropTargetComponent.swift
│  │  ├─ Data/
│  │  │  └─ LocalTicketCatalog.swift
│  │  ├─ Debug/
│  │  │  └─ DebugManager.swift
│  │  ├─ Models/
│  │  │  ├─ GamePhase.swift
│  │  │  ├─ SessionModel.swift
│  │  │  └─ Ticket.swift
│  │  ├─ Resources/
│  │  │  └─ Localizable.xcstrings
│  │  ├─ Services/
│  │  │  ├─ DropEvaluator.swift
│  │  │  └─ MonsterInteractionConfigurator.swift
│  │  ├─ Support/
│  │  │  └─ AppConstants.swift
│  │  ├─ Views/
│  │  │  ├─ Debug/
│  │  │  │  └─ DebugInteractionHarnessView.swift
│  │  │  ├─ InvestigationView.swift
│  │  │  ├─ PrioritizationView.swift           ← neu (Modul 008)
│  │  │  ├─ RootVolumeView.swift
│  │  │  └─ StartView.swift
│  │  ├─ Assets.xcassets
│  │  └─ Info.plist
│  ├─ Ticket_TamerTests/
│  │  └─ Ticket_TamerTests.swift
│  ├─ Packages/
│  │  └─ RealityKitContent/
│  │     ├─ README.md
│  │     ├─ Package.swift
│  │     ├─ Package.realitycomposerpro
│  │     └─ Sources/
│  │        └─ RealityKitContent/
│  │           ├─ RealityKitContent.swift
│  │           └─ RealityKitContent.rkassets/
│  │              ├─ Scene.usda
│  │              ├─ monster01.usda
│  │              ├─ monster02.usda
│  │              ├─ monster03.usda
│  │              ├─ monster04.usda
│  │              └─ Materials/
│  │                 └─ GridMaterial.usda
│  └─ Products/
│     ├─ Ticket_Tamer.app
│     └─ Ticket_TamerTests.xctest
│
└─ Dokumentation/
   ├─ 00_Projektsteuerung/
   ├─ 01_Kontext/
   ├─ 02_Vorlagen/
   ├─ 03_Modul-Eingangsprompts/
   │  ├─ 001-Eingangsprompt.md
   │  ├─ 002-Eingangsprompt.md
   │  ├─ 003-Eingangsprompt.md
   │  ├─ 004-Eingangsprompt.md
   │  ├─ 005-Eingangsprompt.md
   │  ├─ 006-Eingangsprompt.md
   │  ├─ 007-Eingangsprompt.md
   │  └─ 008-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  ├─ 002-Report.md
   │  ├─ 003-Report.md
   │  ├─ 004-Report.md
   │  ├─ 005-Report.md
   │  ├─ 006-Report.md
   │  ├─ 007-Report.md
   │  └─ 008-Report.md                         ← neu (Modul 008)
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `App/Ticket_TamerApp.swift` | App-Einstieg, Scene, SessionModel-Besitz, Component-Registrierung | unverändert | 001/004/007 |
| `Views/RootVolumeView.swift` | Root-Routing; `.priorisieren` zeigt jetzt `PrioritizationView()` | geändert | 001/004/006/007/008 |
| `Views/StartView.swift` | Startansicht | unverändert | 004 |
| `Views/InvestigationView.swift` | Untersuchungsphase | unverändert | 006 |
| `Views/PrioritizationView.swift` | Räumliche Priorisierungsansicht (3 Ziele, Drag-/Drop, Labels) | neu | 008 |
| `Views/Debug/DebugInteractionHarnessView.swift` | DEBUG-only Interaktions-Testbereich (nicht mehr im normalen Routing) | unverändert | 007 |
| `Models/Ticket.swift` | Ticketmodell inkl. `monsterAssetId` | unverändert | 002/005 |
| `Data/LocalTicketCatalog.swift` | zwölf lokale Tickets | unverändert | 002/005/006 |
| `Models/GamePhase.swift` | Spielphasen | unverändert | 003 |
| `Models/SessionModel.swift` | Sitzungszustand; `savePriority(_:)` ergänzt | ergänzt | 003/006/007/008 |
| `Assets/MonsterAssetProvider.swift` | lokales Monsterladen | unverändert | 005 |
| `Components/DropTargetComponent.swift` | generisches Drop-Ziel | unverändert | 007 |
| `Services/MonsterInteractionConfigurator.swift` | Input-/Collision-/Hover-Konfiguration | unverändert | 007 |
| `Services/DropEvaluator.swift` | positionsbasierte Drop-Auswertung | unverändert | 007 |
| `Support/AppConstants.swift` | Constants; `PrioritizationConstants` ergänzt | ergänzt | 001/005/006/007/008 |
| `Debug/DebugManager.swift` | kategorisiertes Logging | unverändert | 001 |
| `Resources/Localizable.xcstrings` | deutsche UI-Strings | unverändert in 008 | 001/004/006 |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | Tests 001–008; `PrioritizationPhaseTests` ergänzt | ergänzt auf 86 | 001–008 |

## Priorisierungsphase (Modul 008)

### `PrioritizationView`

Befindet sich in `Views/PrioritizationView.swift`. Enthält:

- `PriorityTargetMapping` (internal) — Ziel-ID → `TicketPriority`-Mapping.
- drei räumliche Prioritätsziele mit `DropTargetComponent`.
- SwiftUI-Label-Attachments (Normal, Wichtig, Kritisch) via `TicketPriority.displayName`.
- Monster geladen via `MonsterAssetProvider`, konfiguriert via `MonsterInteractionConfigurator(.dragDrop)`.
- Drag/Drop via `DragGesture.targetedToAnyEntity()`.
- Gültiger Drop → `model.savePriority(_:)`.
- Ungültiger Drop → Monster kehrt zu `originTransform` zurück.
- `onAppear`: `unlockInput()` nur wenn `selectedPriority == nil`.

### Ziel-IDs und Positionen

| Technische ID | Position (x, y, z) | Priorität | Sichtbares Label |
|---|---|---|---|
| `priority_normal` | (-0.32, 0.10, 0) | `.normal` | Normal |
| `priority_wichtig` | (0.00, 0.10, 0) | `.wichtig` | Wichtig |
| `priority_kritisch` | (0.32, 0.10, 0) | `.kritisch` | Kritisch |

Monster-Startposition: (0.00, -0.12, 0) — unterhalb aller drei Ziele.  
Zielabstand: 0.32 m > 2 × 0.15 m = 0.30 m (keine Überschneidung).

### `SessionModel.savePriority(_:)`

Vorbedingungen: `currentPhase == .priorisieren`, `selectedPriority == nil`, `!isInputLocked`.  
Effekte: `selectedPriority = priority`, `isInputLocked = true`.  
Unverändert: `score`, `selectedTeam`, `currentTicketIndex`, `currentPhase`.

## Interaktionsgrundlage (unverändert seit Modul 007)

### `MonsterInteractionConfigurator`

Verfügbare Modi:
- `.dragDrop`: `InputTargetComponent(.indirect)`, `CollisionComponent`, `HoverEffectComponent`.
- `.inspectionOnly`: Alle Interaktionskomponenten entfernt.

### `DropTargetComponent`

Fachlich neutraler Zielmarker: `id`, `radius`, optionaler `debugName`.

### `DropEvaluator`

Zwei Schnittstellen:
- `evaluate(entity:targets:)` — für Gesture-Handler.
- `evaluate(entityPosition:targets:)` — unit-testbar ohne RealityKit-Render-Loop.

Semantik: sphärische Distanzprüfung, Weltkoordinaten, bei mehreren Treffern gewinnt nächstes.

### Input-Lock

`SessionModel` bietet `lockInput()`, `unlockInput()`, `reset()` setzt `isInputLocked = false`.

## DEBUG-Harness

`DebugInteractionHarnessView` (nur `#if DEBUG`):
- bleibt als Development-Datei erhalten,
- ist seit Modul 008 **nicht mehr** im normalen `.priorisieren`-Routing aktiv.

## Teststand

| Bereich | Stand |
|---|---|
| Testdeklarationen vor 008 | 64 |
| neue Tests (PrioritizationPhaseTests) | 22 |
| **gesamt nach 008** | **86** |
| ausgeführter Testlauf | offen |
| Simulator-Gestenprüfung | offen |

## F-08 / AK-08 / AK-10

| Teil | Stand |
|---|---|
| Drei beschriftete Prioritätsziele | implementiert |
| Monster-Drag-/Drop in `.priorisieren` | implementiert |
| Gültiger Drop → Priorität speichern | implementiert |
| Gültiger Drop → Lock | implementiert |
| Ungültiger Drop → kein Zustandswechsel | implementiert |
| Ungültiger Drop → Rückkehr | implementiert |
| Mehrfachinteraktion während Lock | implementiert |
| Laufzeitprüfung im Simulator | offen |
| Prioritätsentscheidung bewerten (F-10) | offen bis 010 |
| Teamentscheidung speichern | offen bis 009 |

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| `monster01` | USDA-Kugel | fehlt |
| `monster02` | USDA-Kugel | fehlt |
| `monster03` | USDA-Kugel | fehlt |
| `monster04` | USDA-Kugel | fehlt |

## Für Modul 009 relevante Schnittstellen

| Schnittstelle | Zweck |
|---|---|
| `SessionModel.savePriority(_:)` | Vorlage für `saveTeam(_:)` |
| `SessionModel.selectedPriority` | gespeicherte Prioritätsentscheidung |
| `SessionModel.isInputLocked` | Eingabesperre nach Entscheidung |
| `SessionModel.lockInput()` / `unlockInput()` | Lock-Verwaltung |
| `PrioritizationView` | Vorlage für `TeamAssignmentView` |
| `PriorityTargetMapping` | Vorlage für Team-Ziel-Mapping |
| `PrioritizationConstants` | Vorlage für Team-Layout-Constants |
| `DropTargetComponent` | Wiederverwendung für Teamziele |
| `DropEvaluator` | Wiederverwendung für Teamziele |
| `MonsterInteractionConfigurator` | Wiederverwendung, Modus `.dragDrop` |

## Offene Punkte

- Build, Simulatorstart und Testausführung nach Modul 008 fehlen.
- Simulator-Gestenprüfung (AK-08: Normal, Wichtig, Kritisch, ungültiger Drop) fehlt.
- AK-01/AK-06/AK-07 Laufzeitnachweise fehlen weiterhin.
- finale Blender-Monster fehlen.
- `.DS_Store`-Bereinigung bleibt offen.
- `Logbuch-Stand.md` muss manuell aktualisiert werden.
