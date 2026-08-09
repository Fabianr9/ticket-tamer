# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `004` — Startansicht und Einstellungen  
**Eingearbeitet am:** 2026-08-09  
**Branch:** `main`  
**Modul-003-Commit:** `dd78700 Feat: addModul3`  
**Commit vor Modul 004:** `f3d4bf3 feat: add doc files`  
**Modul-004-Commit:** `84bb767 004: Startansicht und Einstellungen`  
**Build nach Modul 004:** nicht nachgewiesen  
**Simulatorstart nach Modul 004:** nicht nachgewiesen  
**Tests nach Modul 004:** 27 Testdeklarationen im Quellstand; Ausführung nicht nachgewiesen

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

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
- 27 gemeldete Testdeklarationen.

Der Quellstand wurde im Modul-004-Chat nicht mit Xcode gebaut, im Simulator gestartet oder vollständig getestet. Diese Verifikation ist vor beziehungsweise zu Beginn von Modul 005 nachzuholen.

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
   │  └─ 004-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Hinweise zum Dateibaum

- `StartView.swift` wurde in Modul 004 neu ergänzt.
- `Ticket_TamerApp.swift`, `RootVolumeView.swift`, `Localizable.xcstrings` und `Ticket_TamerTests.swift` wurden in Modul 004 geändert.
- `GamePhase.swift`, `SessionModel.swift`, `AppConstants.swift`, `DebugManager.swift`, `Ticket.swift`, `LocalTicketCatalog.swift`, `Info.plist`, RealityKitContent und `project.pbxproj` wurden laut Report nicht verändert.
- `project.pbxproj` nutzt weiterhin `PBXFileSystemSynchronizedRootGroup`; `StartView.swift` wurde deshalb nicht manuell eingetragen.
- `Products/` ist eine Xcode-Buildproduktgruppe, kein Quellcodeordner.
- Die aus Modul 002 bekannten `.DS_Store`-Dateien bleiben als Repository-Hygieneproblem dokumentiert, sind aber im fachlichen Baum nicht aufgeführt.
- Es sind noch keine eigenen Monster-Assets im bestätigten Dateibaum dokumentiert.

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` | Xcode-Projektstruktur mit synchronisierten Dateigruppen | unverändert in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg, eine volumetrische Scene, Besitz der einzigen `SessionModel`-Instanz | ergänzt | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Root-Switch über `currentPhase`; `.start` → `StartView`, sonst aktuell neutraler Platzhalter | ersetzt/geändert | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | deutsche Startansicht mit Regler und Startschaltfläche | neu | 004 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung | unverändert in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | zentrale Layout-, Ticketanzahl- und Asset-Konstanten | unverändert in 004 | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche Lokalisierungsgrundlage und Startansicht-Schlüssel | ergänzt | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Info.plist` | volumetrische Scene-Rolle | unverändert | 001 |
| `Ticket_Tamer/Ticket_Tamer/Assets.xcassets` | Asset-Katalog des App-Targets | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | `TicketPriority`, `SupportTeam`, `Ticket` | unverändert in 004 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | genau zwölf statische lokale Tickets | unverändert in 004 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf grundlegende Spielphasen | unverändert in 004 | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentraler beobachtbarer Sitzungszustand | unverändert in 004 | 003 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Tests für Fundament, Ticketdaten, SessionModel und Startmodell | ergänzt auf 27 gemeldete Testdeklarationen | 001–004 |
| `Ticket_Tamer/Packages/RealityKitContent/...` | vorhandenes RealityKitContent-Package und Standardszene | unverändert | Ausgangsprojekt |

## Öffentliche beziehungsweise modulinterne Schnittstellen

Die Typen sind innerhalb des App-Moduls verfügbar; explizite `public`-Zugriffsmodifikatoren sind nicht bestätigt.

| Typ oder Methode | Datei | Zweck |
|---|---|---|
| `Ticket_TamerApp` | `App/Ticket_TamerApp.swift` | App-Einstieg und Besitzer des Sitzungsmodells |
| eine `SessionModel`-Instanz als `@State` | `App/Ticket_TamerApp.swift` | zentrale Instanz pro App-Laufzeit |
| `.environment(sessionModel)` | `App/Ticket_TamerApp.swift` | Weitergabe an Kind-Views |
| `RootVolumeView` | `Views/RootVolumeView.swift` | phasenabhängige Root-Darstellung |
| `StartView` | `Views/StartView.swift` | Startansicht F-01/AK-01 |
| `@Environment(SessionModel.self)` | Kind-Views | Zugriff auf dieselbe SessionModel-Instanz |
| `DebugManager` | `Debug/DebugManager.swift` | Debug-Steuerung |
| `DebugManager.Category` | `Debug/DebugManager.swift` | `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| `DebugManager.log(_:_:function:)` | `Debug/DebugManager.swift` | kategorisierte Logs |
| `LayoutConstants` | `Support/AppConstants.swift` | Volume- und Layoutwerte |
| `GameplayConstants` | `Support/AppConstants.swift` | Ticketanzahl 1–12, Standard 6 |
| `AssetKeys` | `Support/AppConstants.swift` | vorhandene Asset-Schlüssel |
| `TicketPriority` | `Models/Ticket.swift` | drei Prioritäten |
| `TicketPriority.displayName` | `Models/Ticket.swift` | deutsche Bezeichnungen |
| `SupportTeam` | `Models/Ticket.swift` | vier Support-Teams |
| `SupportTeam.displayName` | `Models/Ticket.swift` | deutsche Bezeichnungen |
| `Ticket` | `Models/Ticket.swift` | Ticketfachmodell |
| `LocalTicketCatalog.allTickets` | `Data/LocalTicketCatalog.swift` | vollständiger lokaler Ticketpool |
| `GamePhase` | `Models/GamePhase.swift` | `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen`, `.ergebnis` |
| `SessionModel` | `Models/SessionModel.swift` | `@Observable @MainActor`, zentrale Zustandsquelle |
| `SessionModel.selectedTicketCount` | `Models/SessionModel.swift` | ausgewählte Ticketanzahl |
| `SessionModel.setTicketCount(_:)` | `Models/SessionModel.swift` | Ticketanzahl klemmen und setzen |
| `SessionModel.startSession(using:)` | `Models/SessionModel.swift` | Sitzung starten |
| `SessionModel.sessionTickets` | `Models/SessionModel.swift` | ausgewählte Sitzungstickets |
| `SessionModel.currentTicket` | `Models/SessionModel.swift` | aktuelles Ticket |
| `SessionModel.currentTicketIndex` | `Models/SessionModel.swift` | aktueller Index |
| `SessionModel.currentPhase` | `Models/SessionModel.swift` | aktuelle Phase |
| `SessionModel.advanceToNextTicket()` | `Models/SessionModel.swift` | Index sicher vorschalten |
| `SessionModel.reset()` | `Models/SessionModel.swift` | vollständiger Modellreset |

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
            └─ neutraler Sitzungsplatzhalter
```

Nach `startSession()` setzt das Modell laut geprüftem Code die Phase auf `.untersuchen`. Die fachliche Untersuchungsansicht ist noch nicht implementiert.

## Lokalisierungsschlüssel

| Schlüssel | Wert (de) |
|---|---|
| `app.title` | `Ticket Tamer` |
| `start.ticketCount.label` | `Anzahl Tickets` |
| `start.ticketCount.accessibility` | `Regler für Ticketanzahl` |
| `start.button.startGame` | `Spiel starten` |
| `root.sessionPlaceholder` | `Sitzung läuft …` |

## Zentrale Konstanten

| Enum | Datei | Inhalt |
|---|---|---|
| `LayoutConstants` | `Support/AppConstants.swift` | Volume-Maße und Layoutabstände |
| `GameplayConstants` | `Support/AppConstants.swift` | Minimum 1, Maximum 12, Standardwert 6 |
| `AssetKeys` | `Support/AppConstants.swift` | bisher nur vorhandene Standardszene |

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

## DebugManager-Stand

- keine neue Kategorie in Modul 004,
- `input`: Startschaltfläche,
- `lifecycle`: `StartView.onAppear`,
- `state`: neutraler Sitzungsplatzhalter,
- bestehendes Lifecycle-Logging beim App-Einstieg,
- keine vollständigen Tickettexte in Logs.

## Build- und Teststand

| Bereich | Stand |
|---|---|
| Build nach Modul 001 | erfolgreich bestätigt |
| Build nach Modul 002 | nicht separat nachgewiesen |
| Build nach Modul 003 | nicht nachgewiesen |
| Build nach Modul 004 | nicht nachgewiesen |
| Simulatorstart nach Modul 004 | nicht nachgewiesen |
| Testdeklarationen 001–002 | 7 |
| Tatsächliche SessionModel-Testdeklarationen aus 003 | 15 |
| StartViewModel-Testdeklarationen aus 004 | 5 |
| **Gesamt im Quellstand** | **27** |
| Tatsächlich ausgeführte Tests nach 004 | nicht nachgewiesen |
| Gerätetest Apple Vision Pro | Modul 013 |

## F-01 / AK-01

- F-01 ist laut Quellimplementierung umgesetzt.
- AK-01 ist noch nicht abschließend laufzeitverifiziert.
- Die Kennzeichnung `[x]` im 004-Report wird nicht als ausgeführte Simulatorabnahme interpretiert, weil derselbe Report Build und Simulatorprüfung als lokal noch durchzuführen beschreibt.

## Konfliktanfällige Dateien

- `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj`
- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift`
- `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Modul 005 soll Startansicht und SessionModel nicht verändern, sofern keine zwingende Asset-Schnittstelle dies erfordert.

## Für Modul 005 relevant

Noch nicht im bestätigten Baum vorhanden:

- vier eigene Blender-Quelldateien,
- vier RealityKit-kompatible Monster-Exporte,
- eindeutige Asset-Schlüssel für die vier Monster,
- bestätigte Monster-Lade-/Bereitstellungsschnittstelle,
- dokumentierte modellunabhängige Monsterzuordnung zu Tickets.

Die SPEC-Architekturskizze enthält in `Ticket` ein Feld `monsterAssetId`. Dieses Feld fehlt bisher im implementierten Ticketmodell. Modul 005 muss diese dokumentierte Abweichung bewusst auflösen und darf sie nicht stillschweigend ignorieren.

## Nicht vorhanden beziehungsweise nicht vorwegzunehmen

- fertige Untersuchungsphase,
- Ticketkarte,
- „Weiter zur Priorisierung“,
- vollständige Monster-Gesteninteraktion,
- Prioritätsziele,
- Teamstationen,
- Bewertungsmethoden,
- Punktevergabe,
- Audiofeedback,
- automatische 1,5-Sekunden-Übergänge,
- Ergebnisansicht,
- optionale Monsterreaktion.

## Offene technische und fachliche Punkte

- Xcode-Build nach Modul 004 fehlt.
- Simulatorlauf und manuelle AK-01-Prüfung fehlen.
- Ausführung aller 27 Tests fehlt.
- `monsterAssetId` beziehungsweise eine gleichwertige SPEC-konforme Asset-Zuordnung ist offen.
- Existenz und Qualität der vier eigenen Blender-Modelle müssen in Modul 005 real geprüft werden.
- Tickettexte verwenden teilweise `ae`, `oe`, `ue`.
- Drei `.DS_Store`-Dateien sind laut Modul-002-Report im Repository vorhanden.
- Vollständige Apple-Vision-Pro-Prüfung bleibt Modul 013 vorbehalten.

## Nicht mehr vorhanden oder bewusst ersetzt

- frühere Default-`ContentView` nicht im aktiven App-Einstieg,
- frühere Position von `Ticket_TamerApp.swift` ersetzt durch `App/`,
- keine separate aktive `DebugManager.swift` im Repository-Stamm,
- neutraler Root-Inhalt aus Modul 001 wurde in Modul 004 durch phasenabhängige Darstellung ersetzt,
- keine parallelen Alt-, Kopie- oder Backup-Dateien gemeldet.
