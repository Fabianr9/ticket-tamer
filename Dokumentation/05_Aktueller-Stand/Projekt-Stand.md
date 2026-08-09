# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `007` — Räumliche Interaktionsgrundlagen  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Commit vor Modul 007:** `243c56c feat: add docs`  
**Modul-006-Commit:** `177e2b9 feat: Modul006`  
**Modul-007-Commit:** offen  
**Build nach Modul 007:** nicht nachgewiesen  
**Simulatorstart nach Modul 007:** nicht nachgewiesen  
**Testlauf nach Modul 007:** nicht nachgewiesen  
**Testdeklarationen im Quellstand:** 64

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
- generische Drop-Ziele,
- gültig/ungültig-Auswertung,
- Input-Lock,
- DEBUG-only Interaktions-Harness.

Noch nicht vorhanden:

- konkrete Prioritätsziele,
- fachliche Prioritätsentscheidung,
- Teamstationen,
- Bewertung,
- Audio,
- automatischer Übergang nach gültiger Entscheidung.

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
   │  └─ 007-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `App/Ticket_TamerApp.swift` | App-Einstieg, Scene, SessionModel-Besitz, Component-Registrierung | ergänzt in 007 | 001/004/007 |
| `Views/RootVolumeView.swift` | Root-Routing; DEBUG-Harness in `.priorisieren` | ergänzt | 001/004/006/007 |
| `Views/StartView.swift` | Startansicht | unverändert | 004 |
| `Views/InvestigationView.swift` | Untersuchungsphase | unverändert | 006 |
| `Views/Debug/DebugInteractionHarnessView.swift` | DEBUG-only Interaktions-Testbereich | neu | 007 |
| `Models/Ticket.swift` | Ticketmodell inkl. `monsterAssetId` | unverändert | 002/005 |
| `Data/LocalTicketCatalog.swift` | zwölf lokale Tickets | unverändert | 002/005/006 |
| `Models/GamePhase.swift` | Spielphasen | unverändert | 003 |
| `Models/SessionModel.swift` | Sitzungszustand inkl. `lockInput()` / `unlockInput()` | ergänzt | 003/006/007 |
| `Assets/MonsterAssetProvider.swift` | lokales Monsterladen | unverändert | 005 |
| `Components/DropTargetComponent.swift` | generisches Drop-Ziel | neu | 007 |
| `Services/MonsterInteractionConfigurator.swift` | Input-/Collision-/Hover-Konfiguration | neu | 007 |
| `Services/DropEvaluator.swift` | positionsbasierte Drop-Auswertung | neu | 007 |
| `Support/AppConstants.swift` | Constants inkl. `InteractionConstants` | ergänzt | 001/005/006/007 |
| `Debug/DebugManager.swift` | kategorisiertes Logging | unverändert | 001 |
| `Resources/Localizable.xcstrings` | deutsche UI-Strings | unverändert in 007 | 001/004/006 |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | Tests 001–007 | ergänzt auf 64 Testdeklarationen | 001–007 |

## Interaktionsgrundlage

### `MonsterInteractionConfigurator`

Verfügbare Modi laut Report:

- `.dragDrop`
- `.inspectionOnly`

Für `.dragDrop` werden gemeldet:

- `InputTargetComponent(allowedInputTypes: .indirect)`,
- `CollisionComponent`,
- `HoverEffectComponent`,
- Translation über gezieltes `DragGesture`.

### `DropTargetComponent`

Fachlich neutraler Zielmarker:

- `id`,
- `radius`,
- optionaler `debugName`.

### `DropEvaluator`

Zwei Schnittstellen:

- `evaluate(entity:targets:)`
- `evaluate(entityPosition:targets:)`

Semantik:

- sphärische Distanzprüfung,
- Weltkoordinaten,
- Randpunkt gilt als Treffer,
- bei mehreren Treffern gewinnt der nächste,
- keine Bildschirmkoordinaten.

### Input-Lock

`SessionModel` bietet:

- `lockInput()`
- `unlockInput()`

`reset()` setzt `isInputLocked` weiterhin auf `false`.

## DEBUG-Harness

`DebugInteractionHarnessView`:

- nur `#if DEBUG`,
- neutraler Zielbereich `testTargetA`,
- aktuell in `.priorisieren`,
- dient ausschließlich technischer Interaktionsprüfung,
- soll in Modul 008 durch `PrioritizationView` ersetzt werden.

## Teststand

| Bereich | Stand |
|---|---|
| Testdeklarationen vor 007 | 45 |
| neue Tests | 19 |
| **gesamt nach 007** | **64** |
| ausgeführter Testlauf | offen |
| Simulator-Gestenprüfung | offen |

## F-10 / AK-10

| Teil | Stand |
|---|---|
| Drag-/Drop-Grundlage | implementiert |
| ungültiger Drop → kein Zustand | implementiert |
| ungültiger Drop → Rückkehr | implementiert |
| gültiger generischer Drop → Lock | implementiert |
| Mehrfachinteraktion während Lock | implementiert |
| Prioritätsentscheidung speichern | offen bis 008 |
| Teamentscheidung speichern | offen bis 009 |
| Laufzeitprüfung im Simulator | offen |

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| `monster01` | USDA-Kugel | fehlt |
| `monster02` | USDA-Kugel | fehlt |
| `monster03` | USDA-Kugel | fehlt |
| `monster04` | USDA-Kugel | fehlt |

## Für Modul 008 relevante Schnittstellen

| Schnittstelle | Zweck |
|---|---|
| `SessionModel.currentPhase` | `.priorisieren` erkennen |
| `SessionModel.currentTicket` | Monster-ID des aktiven Tickets |
| `SessionModel.selectedPriority` | spätere Prioritätsentscheidung |
| `SessionModel.isInputLocked` | Eingabesperre |
| `SessionModel.lockInput()` | gültigen Drop sperren |
| `SessionModel.unlockInput()` | Eingabe für Phasenaufbau freigeben |
| `MonsterAssetProvider.loadMonster(assetID:)` | Monster laden |
| `MonsterInteractionConfigurator.configure(_:mode:)` | Monster als `.dragDrop` konfigurieren |
| `DropTargetComponent` | drei Prioritätsziele markieren |
| `DropEvaluator` | gültigen Drop bestimmen |
| `TicketPriority` | `.normal`, `.wichtig`, `.kritisch` |
| `TicketPriority.displayName` | deutsche Beschriftungen |

## Noch nicht vorhanden

- Methode zum Speichern einer Prioritätsentscheidung,
- echte `PrioritizationView`,
- drei konkrete Prioritätsziele,
- Mapping Ziel-ID → `TicketPriority`,
- automatische Weiterleitung zur Teamphase,
- Punkte und Audio.

## Offene Punkte

- Modul-007-Commit/Hash fehlt.
- Build, Simulatorstart und Testausführung fehlen.
- Gestenlaufzeitprüfung fehlt.
- AK-01/AK-06/AK-07 Laufzeitnachweise fehlen.
- finale Blender-Monster fehlen.
- `.git/index.lock` war im Modul-Chat ein Git-Risiko.
- `.DS_Store`-Bereinigung bleibt offen.
