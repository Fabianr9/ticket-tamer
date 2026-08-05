# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `003` — Sitzungsmodell und Zufallsauswahl  
**Eingearbeitet am:** 2026-08-05  
**Branch vor Modul 003:** `main`  
**Letzter bestätigter Commit vor Modul 003:** `2775041 feat: add modul 2`  
**Modul-003-Commit:** noch nicht bekannt  
**Build nach Modul 003:** nicht nachgewiesen  
**Testlauf nach Modul 003:** nicht nachgewiesen

## Technischer Gesamtstand

Modul 003 ergänzt das bisherige Grundgerüst um ein zentrales, beobachtbares Sitzungsmodell. Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- keine zweite Scene und keinen Immersive Space,
- deutsche Basistexte und die RealityKit-Standardszene,
- fachliche Tickettypen und genau zwölf lokale Tickets,
- ein `GamePhase`-Enum,
- ein zentrales `SessionModel`,
- Ticketanzahl 1 bis 12 mit Standardwert 6,
- zufällige Ticketwahl ohne Wiederholung,
- sicheren Ticketzugriff und Indexfortschaltung,
- vollständigen Modellreset,
- Swift-Testing-Tests für Grundgerüst, Katalog und Sitzungsmodell.

Der Quellstand wurde im Modul-003-Chat nicht mit Xcode gebaut oder getestet. Aussagen zur erfolgreichen Kompilierung und zur tatsächlichen Testanzahl sind deshalb noch lokal zu bestätigen.

## Repository- und Dokumentationsstruktur

```text
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
   │  └─ 003-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Hinweise zum Dateibaum

- `GamePhase.swift` und `SessionModel.swift` wurden in Modul 003 neu ergänzt.
- Das Projekt verwendet laut Report `PBXFileSystemSynchronizedRootGroup`; für die beiden Dateien war keine manuelle Änderung von `project.pbxproj` erforderlich.
- `Ticket_TamerApp.swift`, `RootVolumeView.swift`, `AppConstants.swift`, `Ticket.swift`, `LocalTicketCatalog.swift`, `DebugManager.swift`, `Info.plist`, `Localizable.xcstrings`, RealityKitContent und `project.pbxproj` wurden in Modul 003 nicht geändert.
- Die frühere Default-`ContentView` ist weiterhin nicht Teil des aktiven Projektbaums beziehungsweise App-Einstiegs.
- Im aktiven App-Code existiert genau eine `DebugManager.swift`.
- Die aus Modul 002 bekannten `.DS_Store`-Dateien bleiben als Repository-Hygieneproblem dokumentiert, sind aber kein fachlicher Bestandteil des Dateibaums.
- `Products/` ist eine Xcode-Buildproduktgruppe und kein Quellcodeordner.

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` | Xcode-Projektstruktur mit synchronisierten Dateigruppen | unverändert in 003 | 001 |
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg mit genau einer volumetrischen `WindowGroup` | unverändert in 003 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | minimale deutsche Root-Oberfläche mit RealityKit-Standardszene | unverändert in 003 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung | unverändert in 003 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | zentrale Layout-, Ticketanzahl- und Asset-Konstanten | unverändert in 003 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche Lokalisierungsgrundlage | unverändert in 003 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Info.plist` | volumetrische Scene-Rolle | unverändert in 003 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Assets.xcassets` | Asset-Katalog des App-Targets | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | `TicketPriority`, `SupportTeam` und `Ticket` | unverändert in 003 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | statischer Katalog mit genau zwölf Tickets | unverändert in 003 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf grundlegende Spielphasen | neu | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentraler beobachtbarer Sitzungszustand | neu | 003 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Tests für Grundgerüst, Ticketkatalog und SessionModel | ergänzt; Ausführung offen | 001–003 |
| `Ticket_Tamer/Packages/RealityKitContent/Package.swift` | Package-Definition für RealityKitContent | unverändert | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Package.realitycomposerpro` | Reality-Composer-Pro-Projekt | unverändert | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.swift` | Package-Schnittstelle | unverändert | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Scene.usda` | RealityKit-Standardszene | unverändert | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Materials/GridMaterial.usda` | Material der Standardszene | unverändert | Ausgangsprojekt |

## Öffentliche beziehungsweise modulinterne Schnittstellen

Die Typen sind laut bisherigen Reports innerhalb des App-Moduls verfügbar; explizite `public`-Zugriffsmodifikatoren sind nicht bestätigt.

| Typ oder Methode | Datei | Zweck |
|---|---|---|
| `Ticket_TamerApp` | `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg |
| `RootVolumeView` | `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Root-Oberfläche im Volume |
| `DebugManager` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Debug-Steuerung |
| `DebugManager.Category` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Log-Kategorien |
| `DebugManager.log(_:_:function:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisierte Logs |
| `DebugManager.toggle(_:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Kategorie umschalten |
| `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Volume- und Layoutwerte |
| `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Ticketanzahl 1–12, Standard 6 |
| `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | vorhandene Asset-Schlüssel |
| `TicketPriority` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | `.normal`, `.wichtig`, `.kritisch` |
| `TicketPriority.displayName` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutsche Anzeigenamen |
| `SupportTeam` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | vier Support-Teams |
| `SupportTeam.displayName` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutsche Anzeigenamen |
| `Ticket` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Ticketfachmodell |
| `LocalTicketCatalog.allTickets` | `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | vollständiger lokaler Ticketpool |
| `GamePhase` | `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen`, `.ergebnis` |
| `SessionModel` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | `@Observable @MainActor`, zentrale Zustandsquelle |
| `SessionModel.selectedTicketCount` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | gewählte Ticketanzahl |
| `SessionModel.setTicketCount(_:)` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | Ticketanzahl auf 1–12 klemmen |
| `SessionModel.startSession(using:)` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | Sitzung mit testbarer Mischung starten |
| `SessionModel.sessionTickets` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | ausgewählte Tickets |
| `SessionModel.currentTicket` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | sicherer Zugriff auf aktuelles Ticket |
| `SessionModel.currentTicketIndex` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | aktueller Ticketindex |
| `SessionModel.advanceToNextTicket()` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | Index sicher vorschalten |
| `SessionModel.currentPhase` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | aktuelle Spielphase |
| `SessionModel.score` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | interner Punktestand |
| `SessionModel.selectedPriority` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | spätere Prioritätsentscheidung |
| `SessionModel.selectedTeam` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | spätere Teamentscheidung |
| `SessionModel.isInputLocked` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | spätere Eingabesperre |
| `SessionModel.reset()` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | vollständiger Modellreset |

## SessionModel-Zustand

| Feld | Typ | Zugriff laut Report | Resetwert |
|---|---|---|---|
| `selectedTicketCount` | `Int` | `private(set)` | 6 |
| `sessionTickets` | `[Ticket]` | `private(set)` | `[]` |
| `currentTicketIndex` | `Int` | `private(set)` | 0 |
| `currentPhase` | `GamePhase` | `private(set)` | `.start` |
| `score` | `Int` | `private(set)` | 0 |
| `selectedPriority` | `TicketPriority?` | `private(set)` | `nil` |
| `selectedTeam` | `SupportTeam?` | `private(set)` | `nil` |
| `isInputLocked` | `Bool` | `private(set)` | `false` |

## Zentrale Konstanten

| Enum | Datei | Inhalt |
|---|---|---|
| `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Volume-Maße und Layoutabstände |
| `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Minimum 1, Maximum 12, Standardwert 6 |
| `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | `"Scene"` für die RealityKit-Standardszene |

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

`BalancingConstants` ist weiterhin bewusst nicht vorhanden.

## Auswahl- und Resetsemantik

### Sitzung starten

- Quelle: ausschließlich `LocalTicketCatalog.allTickets`.
- Standardmischung: `shuffled()`.
- Testbare Alternative: injizierbare Funktion `([Ticket]) -> [Ticket]`.
- Übernahme eines Präfixes mit der ausgewählten Ticketanzahl.
- Keine Duplikate innerhalb einer Sitzung.
- Index startet bei 0.
- Alte Sitzungswerte werden nach Report beim Start bereinigt.

### Index

- sicherer optionaler Zugriff über `currentTicket`,
- Fortschaltung nur bis zum letzten gültigen Index,
- kein Wrap-around,
- kein Ergebnisphasenwechsel in Modul 003.

### Reset

Folgende Werte werden auf den Startzustand gesetzt:

- Ticketanzahl 6,
- leere Sitzungsliste,
- Index 0,
- Phase `.start`,
- Score 0,
- Prioritätsentscheidung `nil`,
- Teamentscheidung `nil`,
- Eingabesperre `false`.

## DebugManager-Stand

- keine neue Kategorie,
- `state` wird in `SessionModel` verwendet,
- Logs bei Ticketanzahl, Sitzungsstart, Indexfortschaltung und Reset,
- keine vollständigen Tickettexte in Logs,
- `state` ist laut Report nicht standardmäßig aktiv.

## Build- und Teststand

| Bereich | Stand |
|---|---|
| App-Build nach Modul 001 | erfolgreich bestätigt |
| Build nach Modul 002 | nicht mit Xcode ausgeführt/nachgewiesen |
| Build nach Modul 003 | nicht mit Xcode ausgeführt/nachgewiesen |
| Tests nach Modul 001 | 1 von 1 bestanden |
| Gemeldete Tests nach Modul 002 | sechs neue Tests, Ausführung offen |
| Gemeldete Tests nach Modul 003 | widersprüchlich: zwölf neue Tests genannt, 15 Testnamen aufgelistet |
| Erwartete Gesamtzahl laut Report | 19 |
| Rechnerische Gesamtzahl bei 15 neuen Tests | 22 |
| Tatsächliche Gesamtzahl | lokal in Xcode zu ermitteln |
| Zielplattform | Apple Vision Pro Simulator / visionOS |
| Gerätetest | Modul 013 |

## Noch nicht vorhanden beziehungsweise nicht vorwegzunehmen

- fertige Startansicht mit Regler und Startschaltfläche,
- sichtbare Untersuchungsphase,
- Ticketkarte,
- Monster-Asset-Pipeline,
- Monsterzuordnung,
- Blickfokus, Pinch, Drag und Drop-Ziele,
- Methoden zum Speichern von Prioritäts- oder Teamentscheidungen,
- Punktebewertung,
- Audiofeedback,
- automatische Übergänge nach 1,5 Sekunden,
- Ergebnisansicht,
- „Erneut spielen“-Schaltfläche,
- optionale Monsterreaktion.

## Offene technische und fachliche Punkte

- Modul-003-Commit und Hash fehlen.
- Lokaler Build und Testlauf nach Modul 003 fehlen.
- Tatsächliche Anzahl der SessionModel-Tests ist wegen widersprüchlicher Reportangaben offen.
- `monsterAssetId` fehlt weiterhin gegenüber der SPEC-Architekturskizze.
- Die Tickettexte verwenden teilweise Umschreibungen wie `ae`, `oe` und `ue`.
- Drei `.DS_Store`-Dateien sind laut Modul-002-Report im Repository vorhanden.
- `SessionModel` besitzt noch keine fachlichen Mutationsmethoden für `selectedPriority`, `selectedTeam` und `isInputLocked`; diese folgen erst in den zuständigen Modulen.
- Die vollständige Prüfung auf Apple Vision Pro bleibt Modul 013 vorbehalten.

## Nicht mehr vorhanden oder bewusst ersetzt

- frühere Default-`ContentView` nicht mehr im aktiven App-Einstieg,
- frühere Position von `Ticket_TamerApp.swift` ersetzt durch den App-Unterordner,
- keine separate aktive `DebugManager.swift` im Repository-Stamm,
- keine parallelen Alt-, Kopie- oder Backup-Dateien gemeldet.
