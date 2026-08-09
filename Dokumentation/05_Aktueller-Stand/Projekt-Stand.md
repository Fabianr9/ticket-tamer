# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `004` — Startansicht und Einstellungen  
**Eingearbeitet am:** 2026-08-09  
**Branch:** `main`  
**Commit Modul 003:** `dd78700 Feat: addModul3`  
**Commit Modul 004:** `84bb767 004: Startansicht und Einstellungen`  
**Build nach Modul 004:** nicht mit Xcode nachgewiesen (xcodebuild im Sandbox-Umfeld nicht verfügbar)  
**Testlauf nach Modul 004:** nicht mit Xcode nachgewiesen

## Technischer Gesamtstand

Modul 004 ergänzt das Sitzungsmodell aus Modul 003 um eine vollständige deutsche Startansicht. Die App zeigt beim Start einen Projekttitel, einen ganzzahligen Ticketregler (1–12, Standardwert 6) mit sichtbarem Zahlenwert und die Schaltfläche „Spiel starten". Nach dem Start erscheint ein neutraler Platzhalter, bis Modul 005 die Untersuchungsansicht implementiert. `SessionModel` wird einmalig in `Ticket_TamerApp` besessen und per SwiftUI-Environment weitergegeben.

Bestätigte Bestandteile:

- genau ein zentrales volumetrisches Fenster
- keine zweite Scene und keinen Immersive Space
- deutsche Basistexte und die RealityKit-Standardszene
- fachliche Tickettypen und genau zwölf lokale Tickets
- `GamePhase`-Enum mit fünf Phasen
- zentrales `SessionModel` (`@Observable @MainActor`)
- Besitz von `SessionModel` in `Ticket_TamerApp`, Weitergabe per Environment
- phasenabhängige `RootVolumeView`
- deutsche `StartView` mit Projekttitel, Regler, Zahlenwert, Startschaltfläche
- vier neue Lokalisierungsschlüssel
- 27 Swift-Testing-Tests (22 aus Modul 001–003, 5 neu in Modul 004)

## Repository- und Dokumentationsstruktur

```
Ticket-Tamer/
├─ Ticket_Tamer/
│  ├─ Ticket_Tamer.xcodeproj/
│  │  └─ project.pbxproj
│  ├─ Ticket_Tamer/
│  │  ├─ App/
│  │  │  └─ Ticket_TamerApp.swift
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
│  │  ├─ Support/
│  │  │  └─ AppConstants.swift
│  │  ├─ Views/
│  │  │  ├─ RootVolumeView.swift
│  │  │  └─ StartView.swift          ← neu in Modul 004
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
│  │              └─ Materials/
│  │                 └─ GridMaterial.usda
│  └─ Products/
│     ├─ Ticket_Tamer.app
│     └─ Ticket_TamerTests.xctest
│
└─ Dokumentation/
   ├─ 00_Projektsteuerung/
   │  ├─ Start-Prompt-Projektlogbuch.md
   │  └─ Code-im-Projektraum.md
   ├─ 01_Kontext/
   │  ├─ Projektbeschreibung.md
   │  ├─ SPEC.md
   │  └─ Akzeptanzkriterien.md
   ├─ 02_Vorlagen/
   │  ├─ Projektlogbuch-Vorlage.md
   │  ├─ Projekt-Stand-Vorlage.md
   │  ├─ Modul-Eingangsprompt-Vorlage.md
   │  ├─ Modul-Report-Vorlage.md
   │  └─ DebugManager.swift
   ├─ 03_Modul-Eingangsprompts/
   │  ├─ 001-Eingangsprompt.md
   │  ├─ 002-Eingangsprompt.md
   │  ├─ 003-Eingangsprompt.md
   │  └─ 004-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  ├─ 002-Report.md
   │  ├─ 003-Report.md
   │  └─ 004-Report.md               ← neu in Modul 004
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Hinweise zum Dateibaum

- `StartView.swift` wurde in Modul 004 neu in `Views/` angelegt.
- `RootVolumeView.swift` wurde in Modul 004 ersetzt (phasenabhängige Steuerung).
- `Ticket_TamerApp.swift` wurde in Modul 004 ergänzt (SessionModel-Besitz und Environment).
- `Localizable.xcstrings` wurde in Modul 004 um vier Keys ergänzt.
- `Ticket_TamerTests.swift` wurde in Modul 004 um Struct `StartViewModelTests` mit 5 Tests ergänzt.
- Das Projekt verwendet `PBXFileSystemSynchronizedRootGroup`; `StartView.swift` sollte automatisch erfasst werden. Falls nicht, muss die Datei in Xcode manuell zur Gruppe hinzugefügt werden.
- `Products/` ist eine Xcode-Buildproduktgruppe und kein Quellcodeordner.

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` | Xcode-Projektstruktur | unverändert in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg; besitzt SessionModel, gibt ihn per Environment weiter | ergänzt in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Phasenabhängige Root-Ansicht | ersetzt in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | Deutsche Startansicht (F-01, AK-01) | neu | 004 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung | unverändert in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout-, Ticketanzahl- und Asset-Konstanten | unverändert in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche Lokalisierung; vier neue Keys in 004 | ergänzt in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Info.plist` | volumetrische Scene-Rolle | unverändert in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Assets.xcassets` | Asset-Katalog | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | TicketPriority, SupportTeam, Ticket | unverändert in 004 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | statischer Katalog mit genau zwölf Tickets | unverändert in 004 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf Spielphasen | unverändert in 004 | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentraler beobachtbarer Sitzungszustand | unverändert in 004 | 003 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | 27 Tests für alle Module | ergänzt in 004 | 001–004 |
| `Ticket_Tamer/Packages/RealityKitContent/…` | RealityKit-Paket und Standardszene | unverändert | Ausgangsprojekt |

## Öffentliche Schnittstellen

| Typ oder Methode | Datei | Zweck |
|---|---|---|
| `Ticket_TamerApp` | `App/Ticket_TamerApp.swift` | App-Einstieg; besitzt und verteilt SessionModel |
| `RootVolumeView` | `Views/RootVolumeView.swift` | Phasenabhängige Root-Ansicht |
| `StartView` | `Views/StartView.swift` | Startansicht (F-01, AK-01) |
| `DebugManager` | `Debug/DebugManager.swift` | Debug-Steuerung |
| `LayoutConstants` | `Support/AppConstants.swift` | Volume- und Layoutwerte |
| `GameplayConstants` | `Support/AppConstants.swift` | Ticketanzahl 1–12, Standard 6 |
| `AssetKeys` | `Support/AppConstants.swift` | Asset-Schlüssel |
| `TicketPriority` | `Models/Ticket.swift` | .normal, .wichtig, .kritisch |
| `SupportTeam` | `Models/Ticket.swift` | vier Support-Teams |
| `Ticket` | `Models/Ticket.swift` | Ticketfachmodell |
| `LocalTicketCatalog.allTickets` | `Data/LocalTicketCatalog.swift` | vollständiger lokaler Ticketpool |
| `GamePhase` | `Models/GamePhase.swift` | .start, .untersuchen, .priorisieren, .teamZuordnen, .ergebnis |
| `SessionModel` | `Models/SessionModel.swift` | @Observable @MainActor; einzige Zustandsquelle |
| `SessionModel.selectedTicketCount` | `Models/SessionModel.swift` | gewählte Ticketanzahl (1–12) |
| `SessionModel.setTicketCount(_:)` | `Models/SessionModel.swift` | Ticketanzahl auf 1–12 klemmen |
| `SessionModel.startSession(using:)` | `Models/SessionModel.swift` | Sitzung starten; Phase → .untersuchen |
| `SessionModel.sessionTickets` | `Models/SessionModel.swift` | ausgewählte Tickets |
| `SessionModel.currentTicket` | `Models/SessionModel.swift` | sicherer Zugriff auf aktuelles Ticket |
| `SessionModel.currentTicketIndex` | `Models/SessionModel.swift` | aktueller Ticketindex |
| `SessionModel.advanceToNextTicket()` | `Models/SessionModel.swift` | Index sicher vorschalten |
| `SessionModel.currentPhase` | `Models/SessionModel.swift` | aktuelle Spielphase |
| `SessionModel.reset()` | `Models/SessionModel.swift` | vollständiger Modellreset → Phase .start |

## SessionModel — Besitz und Bereitstellung

| Aspekt | Details |
|---|---|
| Eigentümer | `Ticket_TamerApp` via `@State private var sessionModel = SessionModel()` |
| Weitergabe | `.environment(sessionModel)` in der `WindowGroup` |
| Lesen in Views | `@Environment(SessionModel.self) private var model` |
| Zweite Instanz | nicht vorhanden |

## SessionModel-Zustand

| Feld | Typ | Resetwert | Wert nach startSession() |
|---|---|---|---|
| `selectedTicketCount` | `Int` | 6 | unverändert |
| `sessionTickets` | `[Ticket]` | `[]` | selectedTicketCount Tickets |
| `currentTicketIndex` | `Int` | 0 | 0 |
| `currentPhase` | `GamePhase` | `.start` | `.untersuchen` |
| `score` | `Int` | 0 | 0 |
| `selectedPriority` | `TicketPriority?` | `nil` | `nil` |
| `selectedTeam` | `SupportTeam?` | `nil` | `nil` |
| `isInputLocked` | `Bool` | `false` | `false` |

## Zentrale Konstanten (unverändert)

- `LayoutConstants.centralVolumeWidth = 0.8`
- `LayoutConstants.centralVolumeHeight = 0.6`
- `LayoutConstants.centralVolumeDepth = 0.4`
- `LayoutConstants.rootPadding = 32.0`
- `LayoutConstants.rootSpacing = 24.0`
- `LayoutConstants.textSpacing = 8.0`
- `LayoutConstants.modelBottomPadding = 24.0`
- `GameplayConstants.minimumTicketCount = 1`
- `GameplayConstants.maximumTicketCount = 12`
- `GameplayConstants.defaultTicketCount = 6`
- `AssetKeys.defaultRealityKitScene = "Scene"`

## Lokalisierungsschlüssel (vollständig)

| Key | Wert (de) | Seit Modul |
|---|---|---|
| `app.title` | „Ticket Tamer" | 001 |
| `app.modulePlaceholder` | „Grundgerüst für das zentrale Ticket-Tamer-Volume" | 001 (nicht mehr im aktiven Pfad) |
| `start.ticketCount.label` | „Anzahl Tickets" | 004 |
| `start.ticketCount.accessibility` | „Regler für Ticketanzahl" | 004 |
| `start.button.startGame` | „Spiel starten" | 004 |
| `root.sessionPlaceholder` | „Sitzung läuft …" | 004 |

## Regler — technische Details

| Aspekt | Wert |
|---|---|
| Minimum | `GameplayConstants.minimumTicketCount` (1) |
| Maximum | `GameplayConstants.maximumTicketCount` (12) |
| Standardwert | `GameplayConstants.defaultTicketCount` (6) |
| Schrittweite | `step: 1` (SwiftUI Slider) |
| Binding | Custom `Binding<Double>` → `setTicketCount(Int($0.rounded()))` |
| Wahrheitsquelle | `SessionModel.selectedTicketCount` (kein lokaler Spiegel) |

## DebugManager-Stand

| Kategorie | Wo | Seit Modul |
|---|---|---|
| `.lifecycle` | `Ticket_TamerApp.init()` | 001 |
| `.lifecycle` | `StartView.onAppear` | 004 |
| `.state` | `SessionModel` — Ticketanzahl, Sitzungsstart, Indexfortschaltung, Reset | 003 |
| `.state` | `RootVolumeView.sessionPlaceholderView.onAppear` | 004 |
| `.input` | `StartView` — beim Auslösen von „Spiel starten" | 004 |

## Build- und Teststand

| Bereich | Stand |
|---|---|
| App-Build nach Modul 001 | erfolgreich bestätigt |
| Build nach Modul 002–004 | nicht mit Xcode nachgewiesen |
| Tests nach Modul 003 | 22 Tests; Inkonsistenz im 003-Report aufgelöst (15 neue Tests, nicht 12) |
| Tests nach Modul 004 | 27 Tests (22 + 5 neue); Ausführung in Xcode offen |
| Zielplattform | Apple Vision Pro Simulator / visionOS |
| Gerätetest | Modul 013 |

### Teststrukturen

| Struct | Tests | Modul |
|---|---|---|
| `TicketTamerTests` | 7 | 001–002 |
| `SessionModelTests` | 15 | 003 |
| `StartViewModelTests` | 5 | 004 |
| **Gesamt** | **27** | |

## Noch nicht vorhanden beziehungsweise nicht vorwegzunehmen

- Ticketkarte mit Ticketnummer, Titel, Kurzbeschreibung, User Impact, Symptomen
- sichtbare Untersuchungsphase
- Monster-Asset-Pipeline und Monsterzuordnung
- Blickfokus, Pinch, Drag und Drop-Ziele
- Methoden zum Speichern von Prioritäts- oder Teamentscheidungen
- Punktebewertung und Audiofeedback
- automatische Übergänge nach 1,5 Sekunden
- Ergebnisansicht und „Erneut spielen"-Schaltfläche
- optionale Monsterreaktion

## Offene technische und fachliche Punkte

- Lokaler Build und Testlauf nach Modul 004 fehlen.
- `project.pbxproj` wurde nicht manuell angepasst; `StartView.swift` muss ggf. in Xcode zur synchronisierten Gruppe hinzugefügt werden.
- `monsterAssetId` fehlt gegenüber der SPEC-Architekturskizze.
- Tickettexte verwenden teilweise `ae`, `oe`, `ue`.
- Drei `.DS_Store`-Dateien im Repository (Hygieneproblem).
- `SessionModel` besitzt noch keine fachlichen Mutationsmethoden für `selectedPriority`, `selectedTeam` und `isInputLocked`.
- Vollständige Prüfung auf Apple Vision Pro bleibt Modul 013 vorbehalten.

## Nicht mehr vorhanden oder bewusst ersetzt

- Frühere `RootVolumeView` (statische Platzhalteransicht ohne SessionModel) durch phasenabhängige Version ersetzt.
- `app.modulePlaceholder` ist noch im String Catalog vorhanden, aber nicht mehr im aktiven App-Pfad verwendet.
