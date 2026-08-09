# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `009` — Teamzuordnungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Modul-008-Commit:** `200093b 008: Priorisierungsphase`  
**008-Fix-Commits:** `af4cbe4` (Docs), `b716ed1` (PrioritizationView visuell korrigiert) — beide committed ✓  
**Modul-009-Commit:** steht aus (`009: Teamzuordnungsphase`)  
**Build:** nach Modul 009 offen  
**Simulatorstart:** nach Modul 009 offen  
**Testdeklarationen:** 110  
**Vollständiger Testlauf:** nicht nachgewiesen  
**Manuelle Priorisierungs-Gestenprüfung:** offen  
**Manuelle Teamzuordnungs-Gestenprüfung:** offen

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
- Input-Lock nach gültigem Prioritätsdrop,
- Teamzuordnungsphase,
- vier räumliche Teamstationen (2×2-Layout),
- atomare Speicherung einer Teamentscheidung,
- Input-Lock nach gültigem Teamdrop.

Noch nicht vorhanden:

- Bewertung gegen `referenceTeam` / `referencePriority`,
- Punkte,
- Audio,
- automatischer 1,5-Sekunden-Übergang (F-13),
- automatischer Wechsel zum nächsten Ticket,
- Ergebnisansicht.

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
│  │  ├─ StartView.swift
│  │  └─ TeamAssignmentView.swift          ← neu in 009
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
│  └─ 009-Eingangsprompt.md
├─ 04_Modul-Reports/
│  ├─ 001-Report.md
│  ├─ ...
│  ├─ 008-Report.md
│  └─ 009-Report.md                        ← neu
└─ 05_Aktueller-Stand/
   ├─ Logbuch-Stand.md
   └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status |
|---|---|---|
| `App/Ticket_TamerApp.swift` | App-Einstieg, Volume, SessionModel, Component-Registrierung | aktiv |
| `Views/RootVolumeView.swift` | Root-Routing: Start, Untersuchung, Priorisierung, Teamzuordnung | geändert in 009 |
| `Views/StartView.swift` | Startansicht | aktiv |
| `Views/InvestigationView.swift` | Untersuchungsphase | aktiv |
| `Views/PrioritizationView.swift` | drei Prioritätsziele + Monster-Drag/Drop + `#if DEBUG`-Team-Button | ergänzt in 009 |
| `Views/TeamAssignmentView.swift` | vier Teamstationen + Monster-Drag/Drop + Labels als Overlay | neu in 009 |
| `Views/Debug/DebugInteractionHarnessView.swift` | Development-Harness aus 007 | vorhanden, nicht im normalen Routing |
| `Models/SessionModel.swift` | zentrale Zustandsquelle inkl. `beginTeamAssignmentPhase()`, `saveTeam(_:)` | ergänzt in 009 |
| `Models/Ticket.swift` | Ticket inkl. Referenzdaten und `monsterAssetId` | aktiv |
| `Data/LocalTicketCatalog.swift` | zwölf lokale Tickets | aktiv |
| `Assets/MonsterAssetProvider.swift` | lokales Monsterladen | aktiv |
| `Components/DropTargetComponent.swift` | generischer Drop-Zielmarker | aktiv |
| `Services/MonsterInteractionConfigurator.swift` | Hover/Input/Collision/Drag-Konfiguration | aktiv |
| `Services/DropEvaluator.swift` | räumliche Drop-Auswertung | aktiv |
| `Support/AppConstants.swift` | Layout-, Gameplay-, Interaction-, Priorisierungs- und Teamkonstanten | ergänzt in 009 |
| `Resources/Localizable.xcstrings` | deutsche UI-Texte | aktiv |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | 110 Testdeklarationen | ergänzt in 009 |

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
│  └─ TeamAssignmentView                   ← neu in 009
└─ .ergebnis
   └─ neutraler Platzhalter
```

## Priorisierungsphase

### Ziele

| technische ID | Label | Wert |
|---|---|---|
| `priority_normal` | Normal | `TicketPriority.normal` |
| `priority_wichtig` | Wichtig | `TicketPriority.wichtig` |
| `priority_kritisch` | Kritisch | `TicketPriority.kritisch` |

### Mapping

`PriorityTargetMapping` kapselt `allTargets` und `priority(for:)`.

### DEBUG-Einstieg in Teamphase

`PrioritizationView` zeigt nach gespeicherter Priorität einen `#if DEBUG`-Button „🔧 Team [DEV]". Tippen ruft `model.beginTeamAssignmentPhase()` auf. Nur im Debug-Build, kein normaler Nutzerpfad.

## Teamzuordnungsphase

### Ziele (2×2-Layout)

| technische ID | Label | Wert | Position |
|---|---|---|---|
| `team_netzwerk` | Netzwerk | `SupportTeam.netzwerk` | (-0.24, +0.16, 0) |
| `team_konto` | Konto | `SupportTeam.konto` | (+0.24, +0.16, 0) |
| `team_software` | Software | `SupportTeam.software` | (-0.24, -0.16, 0) |
| `team_hardware` | Hardware | `SupportTeam.hardware` | (+0.24, -0.16, 0) |

Minimaler Abstand: 0.32 m vertikal > 2 × 0.15 m (dropTargetRadius). Keine Überschneidung.

### Mapping

`TeamTargetMapping` kapselt `allTargets` und `team(for:)`.

### SessionModel — neue Methoden

**`beginTeamAssignmentPhase()`**

Vorbedingungen: Phase `.priorisieren`, `selectedPriority != nil`.  
Effekte: Phase → `.teamZuordnen`, `isInputLocked = false`.  
Unverändert: `score`, `currentTicketIndex`, `selectedPriority`, `selectedTeam`.  
No-Op bei: falscher Phase oder fehlender Priorität.

**`saveTeam(_ team: SupportTeam)`**

Vorbedingungen: Phase `.teamZuordnen`, `selectedTeam == nil`, `isInputLocked == false`.  
Effekte: `selectedTeam = team`, `isInputLocked = true`.  
Unverändert: `selectedPriority`, `score`, `currentTicketIndex`, `currentPhase`.  
No-Op bei: falscher Phase, bereits gespeichertem Team, gesperrtem Input.

## Sichtbarkeits-Fix aus Modul 008

- Drei farblich unterscheidbare Zielkugeln mit Opacity 0.55.
- Labels als SwiftUI-Overlay.
- Fix-Commit: `b716ed1` — vollständig committed und aktiv.

## Build- und Verifikationsstand

| Prüfung | Stand |
|---|---|
| App-Build | offen (nach Modul 009) |
| Simulatorstart | offen |
| Startansicht sichtbar | bestätigt (Modul 008) |
| Untersuchungsansicht sichtbar | bestätigt (Modul 008) |
| Priorisierungsansicht sichtbar | bestätigt (Modul 008) |
| Teamzuordnungsansicht sichtbar | offen |
| Drag auf Normal/Wichtig/Kritisch | offen |
| Drag auf Netzwerk/Konto/Software/Hardware | offen |
| Invalid-Drop Priorität | offen |
| Invalid-Drop Team | offen |
| Lock-Laufzeitprüfung Priorität | offen |
| Lock-Laufzeitprüfung Team | offen |
| vollständige 110 Tests | offen |

## Schnittstellen für Modul 010/011

| Schnittstelle | Zweck |
|---|---|
| `SessionModel.selectedPriority` | gespeicherte Priorität |
| `SessionModel.selectedTeam` | gespeicherte Teamentscheidung |
| `SessionModel.savePriority(_:)` | atomare Prioritätsspeicherung |
| `SessionModel.saveTeam(_:)` | atomare Teamspeicherung |
| `SessionModel.beginTeamAssignmentPhase()` | Phasenwechsel (Modul 010 löst zeitgesteuert aus) |
| `SessionModel.score` | Punktestand (Modul 010 vergibt Punkte) |
| `SessionModel.advanceToNextTicket()` | nächstes Ticket |
| `SupportTeam` / `displayName` | Teamwerte und deutsche Labels |
| `TicketPriority` / `displayName` | Prioritätswerte und Labels |
| `PriorityTargetMapping` | Prioritätsziele und Mapping |
| `TeamTargetMapping` | Teamziele und Mapping |
| `DropTargetComponent` | Zielstationen markieren |
| `DropEvaluator` | Drop auswerten |
| `MonsterInteractionConfigurator` | Monster `.dragDrop` konfigurieren |
| `MonsterAssetProvider` | Monster laden |

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| monster01 | USDA-Platzhalter | fehlt |
| monster02 | USDA-Platzhalter | fehlt |
| monster03 | USDA-Platzhalter | fehlt |
| monster04 | USDA-Platzhalter | fehlt |

## Teststand

| Modul | neue Tests | kumulativ |
|---|---|---|
| vor Modul 008 | — | 64 |
| Modul 008 | +22 | 86 |
| Modul 009 | +24 | 110 |

Kein vollständiger Testlauf nachgewiesen.

## Offene Punkte

- Modul-009-Commit (`009: Teamzuordnungsphase`) steht aus.
- App-Build und Simulatorstart nach Modul 009 prüfen.
- Vollständigen Testlauf mit 110 Tests ausführen.
- Priorisierungs-Gesten manuell prüfen (aus Modul 008 offen).
- Teamzuordnungs-Gesten manuell prüfen (alle vier Teams, Invalid-Drop, Lock).
- Vier finale Blender-Monster fehlen.
- `.DS_Store`-Bereinigung bleibt offen.
- Audioassets für Modul 010 fehlen.
