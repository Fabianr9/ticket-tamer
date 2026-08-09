# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `008` — Priorisierungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Modul-008-Commit:** `200093b 008: Priorisierungsphase`  
**008-Fix:** implementiert, Commit/Hash noch offen  
**Build:** bestätigt  
**Simulatorstart:** bestätigt  
**Testdeklarationen:** 86  
**Vollständiger Testlauf:** nicht nachgewiesen  
**Manuelle Priorisierungs-Gestenprüfung:** offen

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- deutsche Startansicht,
- zwölf lokale Tickets,
- zentrales `SessionModel`,
- lokale Monster-Pipeline,
- Untersuchungsphase,
- generische Drag-/Drop-Grundlage,
- echte Priorisierungsphase,
- drei beschriftete Prioritätsziele,
- atomare Speicherung einer Priorität,
- Input-Lock nach gültigem Prioritätsdrop.

Noch nicht vorhanden:

- normale Teamzuordnungsansicht,
- `saveTeam(_:)`,
- Übergang zur Teamphase im normalen Flow,
- Bewertung,
- Punkte,
- Audio,
- automatischer 1,5-Sekunden-Übergang.

## Tatsächlicher relevanter Dateibaum

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
│  │  └─ Localizable.xcstrings
│  ├─ Services/
│  │  ├─ DropEvaluator.swift
│  │  └─ MonsterInteractionConfigurator.swift
│  ├─ Support/
│  │  └─ AppConstants.swift
│  ├─ Views/
│  │  ├─ Debug/
│  │  │  └─ DebugInteractionHarnessView.swift
│  │  ├─ InvestigationView.swift
│  │  ├─ PrioritizationView.swift
│  │  ├─ RootVolumeView.swift
│  │  └─ StartView.swift
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

## Dokumentationsstruktur

```text
Dokumentation/
├─ 00_Projektsteuerung/
├─ 01_Kontext/
├─ 02_Vorlagen/
├─ 03_Modul-Eingangsprompts/
│  ├─ 001-Eingangsprompt.md
│  ├─ ...
│  ├─ 008-Eingangsprompt.md
│  └─ 009-Eingangsprompt.md
├─ 04_Modul-Reports/
│  ├─ 001-Report.md
│  ├─ ...
│  └─ 008-Report.md
└─ 05_Aktueller-Stand/
   ├─ Logbuch-Stand.md
   └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status |
|---|---|---|
| `App/Ticket_TamerApp.swift` | App-Einstieg, Volume, SessionModel, Component-Registrierung | aktiv |
| `Views/RootVolumeView.swift` | Root-Routing für Start, Untersuchung und Priorisierung | geändert in 008 |
| `Views/StartView.swift` | Startansicht | aktiv |
| `Views/InvestigationView.swift` | Untersuchungsphase | aktiv |
| `Views/PrioritizationView.swift` | drei Prioritätsziele + Monster-Drag/Drop | neu in 008, danach visuell korrigiert |
| `Views/Debug/DebugInteractionHarnessView.swift` | Development-Harness aus 007 | vorhanden, nicht mehr normales `.priorisieren`-Routing |
| `Models/SessionModel.swift` | zentrale Zustandsquelle inkl. `savePriority(_:)` | ergänzt |
| `Models/Ticket.swift` | Ticket inkl. Referenzdaten und `monsterAssetId` | aktiv |
| `Data/LocalTicketCatalog.swift` | zwölf lokale Tickets | aktiv |
| `Assets/MonsterAssetProvider.swift` | lokales Monsterladen | aktiv |
| `Components/DropTargetComponent.swift` | generischer Drop-Zielmarker | aktiv |
| `Services/MonsterInteractionConfigurator.swift` | Hover/Input/Collision/Drag-Konfiguration | aktiv |
| `Services/DropEvaluator.swift` | räumliche Drop-Auswertung | aktiv |
| `Support/AppConstants.swift` | Layout-, Gameplay-, Interaction- und Priorisierungsconstants | ergänzt |
| `Resources/Localizable.xcstrings` | deutsche UI-Texte | aktiv |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | 86 Testdeklarationen | ergänzt |

## Root-Phasenrouting

```text
RootVolumeView
├─ .start
│  └─ StartView
├─ .untersuchen
│  └─ InvestigationView
├─ .priorisieren
│  └─ PrioritizationView
└─ .teamZuordnen / .ergebnis
   └─ derzeit neutraler Platzhalter
```

## Priorisierungsphase

### Ziele

| technische ID | Label | Wert |
|---|---|---|
| `priority_normal` | Normal | `TicketPriority.normal` |
| `priority_wichtig` | Wichtig | `TicketPriority.wichtig` |
| `priority_kritisch` | Kritisch | `TicketPriority.kritisch` |

### Mapping

`PriorityTargetMapping` kapselt:

- `allTargets`,
- `priority(for:)`.

### SessionModel

Neue Methode:

`savePriority(_ priority: TicketPriority)`

Vorbedingungen:

- Phase `.priorisieren`,
- noch keine Priorität,
- Input nicht gesperrt.

Effekte:

- Priorität speichern,
- Input sperren.

Keine Änderung an:

- Score,
- Team,
- Ticketindex,
- Phase.

## Sichtbarkeits-Fix aus Modul 008

### Vor Fix

- Zielkugeln wegen Alpha 0,15 kaum sichtbar.
- RealityView-Attachment-Labels nicht sichtbar.

### Nach Fix

- drei farblich unterscheidbare Zielkugeln mit Opacity 0,55,
- Labels als SwiftUI-Overlay,
- Funktionslogik unverändert.

**Git:** Fix-Commit noch nicht bestätigt.

## Build- und Verifikationsstand

| Prüfung | Stand |
|---|---|
| App-Build | bestätigt |
| Simulatorstart | bestätigt |
| Startansicht sichtbar | bestätigt |
| Untersuchungsansicht sichtbar | bestätigt |
| Priorisierungsansicht sichtbar | bestätigt |
| korrigierte Zielkugeln im finalen Commit | Implementierung gemeldet; Commit offen |
| korrigierte Labels im finalen Commit | Implementierung gemeldet; Commit offen |
| Drag auf Normal | offen |
| Drag auf Wichtig | offen |
| Drag auf Kritisch | offen |
| Invalid-Drop | offen |
| Lock-Laufzeitprüfung | offen |
| vollständige 86 Tests | offen |

## Schnittstellen für Modul 009/010

| Schnittstelle | Zweck |
|---|---|
| `SessionModel.selectedPriority` | bereits gespeicherte Priorität |
| `SessionModel.selectedTeam` | Teamentscheidung ab Modul 009 |
| `SessionModel.savePriority(_:)` | Muster für atomare Teamentscheidung |
| `SessionModel.lockInput()` | Eingabe sperren |
| `SessionModel.unlockInput()` | Eingabe für neue Phase freigeben |
| `SupportTeam` | `.netzwerk`, `.konto`, `.software`, `.hardware` |
| `SupportTeam.displayName` | deutsche Labels |
| `DropTargetComponent` | Teamstationen markieren |
| `DropEvaluator` | Teamdrop auswerten |
| `MonsterInteractionConfigurator` | Monster `.dragDrop` konfigurieren |
| `MonsterAssetProvider` | aktuelles Monster laden |
| `PriorityTargetMapping` | später für Bewertungs-/Debugkontext verfügbar |
| `PrioritizationConstants` | Priorisierungspositionen |

## Noch zu ergänzende SessionModel-Schnittstellen

Modul 009 benötigt voraussichtlich:

- `beginTeamAssignmentPhase()`
- `saveTeam(_:)`

### `beginTeamAssignmentPhase()`

Soll einen kontrollierten Wechsel ermöglichen:

- nur von `.priorisieren`,
- nur wenn `selectedPriority != nil`,
- wechselt zu `.teamZuordnen`,
- entsperrt Input für die neue Teamentscheidung,
- verändert Score und Ticketindex nicht,
- speichert kein Team.

**Wichtig:** Modul 009 darf diese Methode im normalen Spielablauf noch nicht automatisch nach Zeit auslösen. Modul 010 übernimmt den zeitgesteuerten Übergang gemäß F-13.

### `saveTeam(_:)`

Soll analog zu `savePriority(_:)`:

- nur in `.teamZuordnen`,
- nur einmal,
- nur bei ungesperrtem Input,
- `selectedTeam` setzen,
- Input sperren,
- Score/Phase/Index unverändert lassen.

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| monster01 | USDA-Platzhalter | fehlt |
| monster02 | USDA-Platzhalter | fehlt |
| monster03 | USDA-Platzhalter | fehlt |
| monster04 | USDA-Platzhalter | fehlt |

## Teststand

- 64 Testdeklarationen vor Modul 008,
- 22 neue Tests,
- 86 Testdeklarationen nach Modul 008,
- kein vollständiger Testlauf nachgewiesen.

## Offene Punkte

- Fix-Commit für Modul 008 fehlt.
- `.git/index.lock` prüfen.
- vollständigen Testlauf mit 86 Tests ausführen.
- Priorisierungs-Gesten manuell prüfen.
- vier finale Blender-Monster fehlen.
- `.DS_Store`-Bereinigung bleibt offen.
- Audioassets für Modul 010 fehlen beziehungsweise sind noch nicht bestätigt.
