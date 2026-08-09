# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `005` — Monster-Asset-Pipeline
**Eingearbeitet am:** 2026-08-09
**Branch:** `main`
**Commit vor Modul 005:** `356cb06 feat: update docs`
**Modul-005-Commit:** `005: Monster-Asset-Pipeline` (Hash nach lokalem Commit einzutragen)
**Build nach Modul 005:** nicht nachgewiesen (kein Xcode im Ausführungsumfeld)
**Simulatorstart nach Modul 005:** nicht nachgewiesen
**Tests nach Modul 005:** 38 Testdeklarationen im Quellstand; Ausführung nicht nachgewiesen

## Technischer Gesamtstand

Der Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- keine zweite Scene und keinen Immersive Space,
- deutsche Basistexte und die RealityKit-Standardszene,
- fachliche Tickettypen und genau zwölf lokale Tickets,
- ein zentrales `SessionModel`,
- Ticketanzahl 1 bis 12 mit Standardwert 6,
- zufällige Ticketwahl ohne Wiederholung,
- sicheren Ticketzugriff und vollständigen Modellreset,
- eine deutsche Startansicht,
- eine einzige `SessionModel`-Instanz im App-Baum,
- SwiftUI-Environment-Weitergabe des Sitzungsmodells,
- phasenabhängige Root-Darstellung,
- `monsterAssetId: String` am `Ticket`-Modell (Modul 005),
- vier neutrale Monster-Asset-Schlüssel in `AssetKeys.Monster` (Modul 005),
- vier USDA-Platzhalterszenen im RealityKitContent-Package (Modul 005),
- `MonsterAssetProvider` für lokales async Laden (Modul 005),
- 38 gemeldete Testdeklarationen.

Der Quellstand wurde bisher nicht mit Xcode gebaut, im Simulator gestartet oder vollständig getestet. Diese Verifikation ist vor beziehungsweise zu Beginn von Modul 006 nachzuholen.

## Repository- und Dokumentationsstruktur

```text
Ticket-Tamer/
├─ Ticket_Tamer/
│  ├─ Ticket_Tamer.xcodeproj/
│  │  └─ project.pbxproj
│  ├─ Ticket_Tamer/
│  │  ├─ App/
│  │  │  └─ Ticket_TamerApp.swift
│  │  ├─ Assets/                          ← neu in Modul 005
│  │  │  └─ MonsterAssetProvider.swift
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
│  │              ├─ monster01.usda        ← neu in Modul 005 (Platzhalter)
│  │              ├─ monster02.usda        ← neu in Modul 005 (Platzhalter)
│  │              ├─ monster03.usda        ← neu in Modul 005 (Platzhalter)
│  │              ├─ monster04.usda        ← neu in Modul 005 (Platzhalter)
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
   │  ├─ 004-Eingangsprompt.md
   │  └─ 005-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  ├─ 002-Report.md
   │  ├─ 003-Report.md
   │  ├─ 004-Report.md
   │  └─ 005-Report.md                    ← neu in Modul 005
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Hinweise zum Dateibaum

- `Assets/MonsterAssetProvider.swift` ist in Modul 005 neu angelegt. Der Ordner `Assets/` ist neu — da das Projekt `PBXFileSystemSynchronizedRootGroup` nutzt, wird er automatisch erkannt. Beim ersten Build in Xcode prüfen.
- `monster01–04.usda` sind USDA-Platzhalterszenen im RealityKitContent-Package. Sie werden durch echte Blender-Exporte ersetzt, sobald diese vorliegen.
- `Ticket.swift` und `LocalTicketCatalog.swift` wurden in Modul 005 erweitert.
- `AppConstants.swift` wurde in Modul 005 um `AssetKeys.Monster` erweitert.
- `Ticket_TamerTests.swift` wurde in Modul 005 um 11 Tests erweitert.
- Alle anderen Dateien sind in Modul 005 unverändert geblieben.
- `Products/` ist eine Xcode-Buildproduktgruppe, kein Quellcodeordner.

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` | Xcode-Projektstruktur mit synchronisierten Dateigruppen | unverändert in 005 | 001 |
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg, eine volumetrische Scene, Besitz der einzigen `SessionModel`-Instanz | unverändert in 005 | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Assets/MonsterAssetProvider.swift` | Async-Ladeinterface für lokale Monster-Entities; loggt über `spawning` | neu | 005 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Root-Switch über `currentPhase`; `.start` → `StartView`, sonst neutraler Platzhalter | unverändert in 005 | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | deutsche Startansicht mit Regler und Startschaltfläche | unverändert in 005 | 004 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung | unverändert in 005 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | zentrale Layout-, Ticketanzahl- und Asset-Konstanten; neu: `AssetKeys.Monster` | ergänzt | 001/005 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche Lokalisierungsgrundlage | unverändert in 005 | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Info.plist` | volumetrische Scene-Rolle | unverändert | 001 |
| `Ticket_Tamer/Ticket_Tamer/Assets.xcassets` | Asset-Katalog des App-Targets | unverändert | Ausgangsprojekt |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | `TicketPriority`, `SupportTeam`, `Ticket`; neu: `monsterAssetId: String` | ergänzt | 002/005 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | genau zwölf statische lokale Tickets; neu: `monsterAssetId` für alle 12 | ergänzt | 002/005 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf grundlegende Spielphasen | unverändert in 005 | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentraler beobachtbarer Sitzungszustand | unverändert in 005 | 003 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Tests 001–005; neu: 11 Modul-005-Tests → 38 Gesamt | ergänzt | 001–005 |
| `RealityKitContent.rkassets/Scene.usda` | RealityKit-Standardszene | unverändert | Ausgangsprojekt |
| `RealityKitContent.rkassets/monster01.usda` | USDA-Platzhalter Monster 01 (Kugel r=0.04 m) | neu | 005 |
| `RealityKitContent.rkassets/monster02.usda` | USDA-Platzhalter Monster 02 (Kugel r=0.06 m) | neu | 005 |
| `RealityKitContent.rkassets/monster03.usda` | USDA-Platzhalter Monster 03 (Kugel r=0.08 m) | neu | 005 |
| `RealityKitContent.rkassets/monster04.usda` | USDA-Platzhalter Monster 04 (Kugel r=0.10 m) | neu | 005 |

## Öffentliche beziehungsweise modulinterne Schnittstellen

| Typ oder Methode | Datei | Zweck |
|---|---|---|
| `Ticket_TamerApp` | `App/Ticket_TamerApp.swift` | App-Einstieg und Besitzer des Sitzungsmodells |
| `RootVolumeView` | `Views/RootVolumeView.swift` | phasenabhängige Root-Darstellung |
| `StartView` | `Views/StartView.swift` | Startansicht F-01/AK-01 |
| `DebugManager` | `Debug/DebugManager.swift` | Debug-Steuerung |
| `DebugManager.Category` | `Debug/DebugManager.swift` | `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| `LayoutConstants` | `Support/AppConstants.swift` | Volume- und Layoutwerte |
| `GameplayConstants` | `Support/AppConstants.swift` | Ticketanzahl 1–12, Standard 6 |
| `AssetKeys` | `Support/AppConstants.swift` | vorhandene Asset-Schlüssel |
| `AssetKeys.Monster` | `Support/AppConstants.swift` | vier Monster-Schlüssel + `allIDs` (neu Modul 005) |
| `TicketPriority` | `Models/Ticket.swift` | drei Prioritäten |
| `SupportTeam` | `Models/Ticket.swift` | vier Support-Teams |
| `Ticket` | `Models/Ticket.swift` | Ticketfachmodell inkl. `monsterAssetId` |
| `Ticket.monsterAssetId` | `Models/Ticket.swift` | neutraler Monster-Bezeichner (neu Modul 005) |
| `LocalTicketCatalog.allTickets` | `Data/LocalTicketCatalog.swift` | vollständiger lokaler Ticketpool |
| `GamePhase` | `Models/GamePhase.swift` | `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen`, `.ergebnis` |
| `SessionModel` | `Models/SessionModel.swift` | `@Observable @MainActor`, zentrale Zustandsquelle |
| `SessionModel.startSession(using:)` | `Models/SessionModel.swift` | Sitzung starten |
| `SessionModel.currentTicket` | `Models/SessionModel.swift` | aktuelles Ticket |
| `SessionModel.currentPhase` | `Models/SessionModel.swift` | aktuelle Phase |
| `MonsterAssetProvider` | `Assets/MonsterAssetProvider.swift` | async Ladeinterface (neu Modul 005) |
| `MonsterAssetProvider.loadMonster(assetID:)` | `Assets/MonsterAssetProvider.swift` | `async throws -> Entity` (neu Modul 005) |
| `MonsterAssetProvider.LoadError` | `Assets/MonsterAssetProvider.swift` | typisierte Ladefehler (neu Modul 005) |

## Monster-Asset-Pipeline (Modul 005)

### Asset-Schlüssel

```swift
AssetKeys.Monster.monster01  // "monster01"
AssetKeys.Monster.monster02  // "monster02"
AssetKeys.Monster.monster03  // "monster03"
AssetKeys.Monster.monster04  // "monster04"
AssetKeys.Monster.allIDs     // ["monster01", "monster02", "monster03", "monster04"]
```

### Ticket-Monster-Mapping

| Ticket | Team | Priorität | Monster-ID |
|---|---|---|---|
| TT-001 | netzwerk | normal | monster01 |
| TT-002 | netzwerk | wichtig | monster02 |
| TT-003 | netzwerk | kritisch | monster03 |
| TT-004 | konto | normal | monster04 |
| TT-005 | konto | wichtig | monster01 |
| TT-006 | konto | kritisch | monster02 |
| TT-007 | software | normal | monster03 |
| TT-008 | software | wichtig | monster04 |
| TT-009 | software | kritisch | monster01 |
| TT-010 | hardware | normal | monster02 |
| TT-011 | hardware | wichtig | monster03 |
| TT-012 | hardware | kritisch | monster04 |

Kein Monster steht eindeutig für ein Team oder eine Priorität. AK-14 (Zuordnungsanteil) erfüllt.

## Startansicht und Zustandsfluss

```text
Ticket_TamerApp
└─ besitzt genau ein SessionModel
   └─ .environment(sessionModel)
      └─ RootVolumeView
         ├─ currentPhase == .start
         │  └─ StartView
         │     ├─ Projekttitel
         │     ├─ Ticketanzahl
         │     ├─ Slider 1...12, step 1
         │     └─ "Spiel starten" -> model.startSession()
         │
         └─ currentPhase != .start
            └─ neutraler Sitzungsplatzhalter (Modul 006 ersetzt diesen)
```

Modul 006 implementiert die Untersuchungsansicht hier.

## Zentrale Konstanten

| Enum | Datei | Inhalt |
|---|---|---|
| `LayoutConstants` | `Support/AppConstants.swift` | Volume-Maße und Layoutabstände |
| `GameplayConstants` | `Support/AppConstants.swift` | Minimum 1, Maximum 12, Standardwert 6 |
| `AssetKeys` | `Support/AppConstants.swift` | Standardszene + Monster-Schlüssel (Modul 005) |

## DebugManager-Stand

- Keine neue Kategorie in Modul 005.
- `spawning`: Asset-ID-Logging in `MonsterAssetProvider` (Ladestart, Erfolg, Fehler).
- `input`: Startschaltfläche.
- `lifecycle`: `StartView.onAppear`.
- `state`: neutraler Sitzungsplatzhalter.

## Build- und Teststand

| Bereich | Stand |
|---|---|
| Build nach Modul 001 | erfolgreich bestätigt |
| Build nach Modulen 002–005 | nicht nachgewiesen |
| Simulatorstart nach Modul 005 | nicht nachgewiesen |
| Testdeklarationen 001–002 | 7 |
| SessionModel-Testdeklarationen 003 | 15 |
| StartViewModel-Testdeklarationen 004 | 5 |
| Monster-Pipeline-Testdeklarationen 005 | 11 |
| **Gesamt im Quellstand** | **38** |
| Tatsächlich ausgeführte Tests | nicht nachgewiesen |
| Gerätetest Apple Vision Pro | Modul 013 |

## F-14 / AK-14-Stand

- F-14 ist auf Asset-, Lade- und Zuordnungsebene implementiert (Platzhalterassets + Provider + Mapping).
- AK-14 Darstellungsanteil: offen (Simulator-Prüfung ausstehend).
- AK-14 Gestenanteil: offen bis Modul 007.

## Konfliktanfällige Dateien

- `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj`
- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift`
- `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

## Für Modul 006 relevant

- `MonsterAssetProvider.loadMonster(assetID:)` ist die Ladeschnittstelle.
- `ticket.monsterAssetId` liefert den Asset-Bezeichner pro Ticket.
- Der neutrale Sitzungsplatzhalter in `RootVolumeView` ist der Startpunkt für die Untersuchungsansicht.
- Vor Modul 006: lokalen Xcode-Build und Simulatorstart durchführen, AK-01 manuell prüfen.
- Blender-Exporte (echte Monster) sobald wie möglich liefern, damit AK-14 Darstellungsanteil verifiziert werden kann.

## Nicht mehr vorhanden oder bewusst ersetzt

- frühere Default-`ContentView` nicht im aktiven App-Einstieg,
- frühere Position von `Ticket_TamerApp.swift` ersetzt durch `App/`,
- keine separate aktive `DebugManager.swift` im Repository-Stamm,
- neutraler Root-Inhalt aus Modul 001 wurde in Modul 004 durch phasenabhängige Darstellung ersetzt.

## Offene technische und fachliche Punkte

- Xcode-Build nach Modulen 002–005 fehlt.
- Simulatorlauf und manuelle AK-01-Prüfung fehlen.
- Ausführung aller 38 Tests fehlt.
- Vier echte Blender-Monster-Modelle und USDZ-Exporte fehlen (Platzhalter vorhanden).
- AK-14 Darstellungsanteil (Simulator-Prüfung) fehlt.
- Tickettexte verwenden teilweise `ae`, `oe`, `ue`.
- Drei `.DS_Store`-Dateien laut Modul-002-Report im Repository vorhanden.
- Vollständige Apple-Vision-Pro-Prüfung bleibt Modul 013 vorbehalten.
