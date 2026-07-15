# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `001` — Projektgrundgerüst und zentrales Volume  
**Datum:** 2026-07-15  
**Branch:** `feature/001-project-foundation`  
**Git-Commit:** `[COMMIT-HASH EINTRAGEN]` — noch nicht eingetragen  
**Merge in `main`:** `[JA / NOCH NICHT]` — noch nicht angegeben  
**Build:** erfolgreich  
**Simulatorstart:** erfolgreich  
**Tests:** 1 von 1 bestanden

## Bestätigter Abschlusszustand

- genau ein zentrales volumetrisches Fenster,
- kein zweites Fenster,
- kein zweites Volume,
- kein Immersive Space,
- deutsche Basistexte werden korrekt angezeigt,
- vorhandene RealityKit-Standardszene wird angezeigt,
- Swift-Testing-Suite `TicketTamerTests` erfolgreich,
- Testplattform `arm64-apple-xros1.0-simulator`,
- keine wesentlichen Abweichungen vom Modulauftrag,
- keine offenen technischen Probleme aus Modul 001.

AK-05 ist nur strukturell teilweise erfüllt. Die vollständige lineare Sitzungsfolge wird erst durch spätere Module implementiert und in Modul 013 vollständig abgenommen.

## Repository- und Dokumentationsstruktur

```text
Ticket-Tamer/
├─ Ticket_Tamer/
│  ├─ Ticket_Tamer.xcodeproj/
│  │  └─ project.pbxproj
│  ├─ Ticket_Tamer/
│  │  ├─ App/
│  │  │  └─ Ticket_TamerApp.swift
│  │  ├─ Debug/
│  │  │  └─ DebugManager.swift
│  │  ├─ Resources/
│  │  │  └─ Localizable.xcstrings
│  │  ├─ Support/
│  │  │  └─ AppConstants.swift
│  │  ├─ Views/
│  │  │  └─ RootVolumeView.swift
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
│  └─ Products/                         # Xcode-Buildproduktgruppe, nicht als Quellcode behandeln
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
   │  └─ DebugManager.swift             # nur falls die ursprüngliche Vorlage weiterhin dokumentarisch aufbewahrt wird
   ├─ 03_Modul-Eingangsprompts/
   │  ├─ 001-Eingangsprompt.md
   │  └─ 002-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  └─ 001-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Hinweise zum Dateibaum

- Der Codebaum entspricht dem im `001-Report.md` bestätigten Stand.
- `Products/` ist eine Xcode-Buildproduktgruppe und kein fachlicher Quellcodeordner.
- Die frühere Default-`ContentView` ist im aktuellen Projektbaum nicht mehr vorhanden beziehungsweise nicht mehr Teil des aktiven App-Einstiegs.
- Im aktiven Code existiert genau eine `DebugManager.swift` unter `Ticket_Tamer/Debug/`.
- Eine frühere separate DebugManager-Vorlage existiert laut Modulreport nicht mehr im Repository-Stamm. Falls sie zu Dokumentationszwecken unter `Dokumentation/02_Vorlagen/` aufbewahrt wird, darf sie nicht dem App-Target zugeordnet sein und nicht als zweite aktive Codekopie gelten.
- Es gibt keine parallelen `New`-, `Old`-, `Copy`- oder `Backup`-Dateien.

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` | Xcode-Projektstruktur und Dateieinbindung über synchronisierte Projektgruppen | geändert, buildfähig | 001 |
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App- und Scene-Einstieg mit genau einer volumetrischen `WindowGroup` | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | minimale deutsche Root-Oberfläche im zentralen Volume; zeigt RealityKit-Standardszene | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung und optionales Debug-Panel | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | zentrale Layout-, Ticketanzahl- und Asset-Konstanten | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche Lokalisierungsgrundlage für sichtbare Basistexte | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Info.plist` | Scene-Konfiguration mit volumetrischer Anwendungsrolle | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Assets.xcassets` | Asset-Katalog des App-Targets | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Swift-Testing-Smoke-Test für positive Maße des zentralen Volumes | aktiv; 1 Test bestanden | 001 |
| `Ticket_Tamer/Packages/RealityKitContent/Package.swift` | Package-Definition für RealityKitContent | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Package.realitycomposerpro` | Reality-Composer-Pro-Projekt | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.swift` | Package-Schnittstelle für RealityKit-Inhalte | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Scene.usda` | vorhandene RealityKit-Standardszene | vorhanden und sichtbar | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Materials/GridMaterial.usda` | Material der Standardszene | vorhanden | Ausgangsprojekt |

## Öffentliche Schnittstellen für Folgemodule

| Typ oder Methode | Datei | Zweck |
|---|---|---|
| `Ticket_TamerApp` | `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg mit genau einer volumetrischen Scene |
| `RootVolumeView` | `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Root-Oberfläche innerhalb des zentralen Volumes |
| `DebugManager` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale Debug-Steuerung |
| `DebugManager.Category` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| `DebugManager.log(_:_:function:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisierte Log-Ausgabe |
| `DebugManager.toggle(_:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Laufzeit-Umschaltung einer Kategorie |
| `DebugPanel` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | optionales Debug-Panel; nicht Teil des regulären Nutzerablaufs |
| `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout- und Volume-Maße |
| `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Ticketanzahl-Grenzen und Standardwert |
| `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Schlüssel für vorhandene lokale Ressourcen |

## Zentrale Konstanten-Enums

| Enum | Datei | Inhalt |
|---|---|---|
| `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Volume-Maße und Layoutabstände |
| `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Minimum 1, Maximum 12, Standardwert 6 |
| `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Schlüssel `"Scene"` für die vorhandene RealityKit-Standardszene |

### Bestätigte Werte

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

`BalancingConstants` ist bewusst noch nicht vorhanden.

## DebugManager-Stand

- genau eine aktive Datei unter `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift`,
- Kategorien: `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`,
- Logging beim App-Einstieg und beim Anzeigen des zentralen Volumes,
- keine neue Kategorie in Modul 001,
- `DebugPanel` nicht im regulären Nutzerablauf,
- Autoclosure wird vor der Logger-Interpolation einmalig aufgelöst; öffentliche Signatur unverändert.

## Build- und Teststand

| Bereich | Stand |
|---|---|
| App-Build | erfolgreich |
| visionOS-Simulatorstart | erfolgreich |
| Test-Suite | `TicketTamerTests` |
| Testdatei | `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` |
| Tests | 1 von 1 bestanden |
| Bestandener Test | positive Maße des zentralen Volumes |
| Plattform | `arm64-apple-xros1.0-simulator` |
| Apple Vision Pro | vollständiger Gerätetest bleibt Modul 013 vorbehalten |

## Konfliktanfällige Dateien

Folgende Dateien sollen bei paralleler Arbeit jeweils klar einer Person zugeordnet werden:

- `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj`
- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`

Modul 002 soll diese Dateien nur ändern, wenn dies für die reine Ticketdatenstruktur zwingend erforderlich ist. App-Einstieg und Root-View sollen unverändert bleiben.

## Für Modul 002 vorgesehene neue Verantwortungsbereiche

Noch nicht vorhanden und erst durch Modul 002 auf Basis des tatsächlichen Xcode-Projekts einzurichten:

- ein einfacher Bereich für fachliche Modelle, beispielsweise `Models/`,
- ein einfacher Bereich für den lokalen Ticketkatalog, beispielsweise `Data/` oder `Catalog/`,
- zusätzliche Swift-Testing-Tests innerhalb des vorhandenen Test-Targets.

Die endgültigen Pfade müssen im `002-Report.md` als tatsächlich eingerichtet dokumentiert werden. Es sollen keine leeren Ordner und keine unnötig komplexe Datenzugriffsarchitektur entstehen.

## Nicht vorhanden und nicht vorwegzunehmen

- Sitzungsmodell oder SessionState,
- Zufallsauswahl,
- aktuelle Sitzungstickets,
- Ticketindex,
- Score,
- Eingabesperre,
- Reset-Logik,
- fertige Startansicht,
- Monster-Asset-Pipeline,
- räumliche Drag-and-Drop-Interaktion,
- Priorisierungs- und Teamzuordnungsphase,
- Audiofeedback,
- Ergebnisansicht,
- optionale Monsterreaktion.

## Nicht mehr vorhanden oder bewusst ersetzt

- frühere Default-`ContentView` nicht mehr im aktuellen Baum beziehungsweise nicht mehr im aktiven App-Einstieg,
- frühere Position von `Ticket_TamerApp.swift` im Projektstamm ersetzt durch `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`,
- keine separate aktive `DebugManager.swift` im Repository-Stamm,
- keine parallelen Alt-, Kopie- oder Backup-Dateien.
