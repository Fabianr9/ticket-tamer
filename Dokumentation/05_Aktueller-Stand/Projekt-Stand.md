# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `005` — Monster-Asset-Pipeline  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Commit vor Modul 005:** `356cb06 feat: update docs`  
**Modul-004-Commit enthalten:** `84bb767`  
**Modul-005-Commit:** offen  
**Build nach Modul 005:** nicht nachgewiesen  
**Simulatorstart nach Modul 005:** nicht nachgewiesen  
**Testlauf nach Modul 005:** nicht nachgewiesen

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- deutsche Startansicht,
- genau eine `SessionModel`-Instanz im App-Baum,
- zwölf lokale Tickets,
- vollständige Team-/Prioritätsverteilung,
- `monsterAssetId` pro Ticket,
- vier neutrale Monster-IDs,
- lokales Monster-Ladeinterface,
- vier technische USDA-Platzhalter,
- phasenabhängige Root-Darstellung,
- keine Untersuchungsansicht,
- keine Gesteninteraktion.

**Wichtig:** Die vier USDA-Kugeln sind keine finalen eigenen Blender-Monster. F-14/AK-14 sind deshalb noch nicht vollständig erfüllt.

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
   │  ├─ 005-Eingangsprompt.md
   │  └─ 006-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  ├─ 002-Report.md
   │  ├─ 003-Report.md
   │  ├─ 004-Report.md
   │  └─ 005-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg, volumetrische Scene, Besitz des `SessionModel` | unverändert in 005 | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | phasenabhängige Root-Darstellung | unverändert in 005 | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | deutsche Startansicht | unverändert in 005 | 004 |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Ticketmodell inkl. `monsterAssetId` | ergänzt | 002/005 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | zwölf Tickets inkl. Monsterzuordnung | ergänzt | 002/005 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf grundlegende Spielphasen | unverändert | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentrale Sitzungsquelle | unverändert | 003 |
| `Ticket_Tamer/Ticket_Tamer/Assets/MonsterAssetProvider.swift` | lokales asynchrones Monster-Laden | neu | 005 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Constants inkl. `AssetKeys.Monster` | ergänzt | 001/005 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisiertes Logging | unverändert; `spawning` genutzt | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche UI-Strings | unverändert in 005 | 001/004 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Tests 001–005 | ergänzt; tatsächliche Zahl zu prüfen | 001–005 |
| `.../RealityKitContent.rkassets/monster01.usda` | technischer Kugel-Platzhalter | neu | 005 |
| `.../RealityKitContent.rkassets/monster02.usda` | technischer Kugel-Platzhalter | neu | 005 |
| `.../RealityKitContent.rkassets/monster03.usda` | technischer Kugel-Platzhalter | neu | 005 |
| `.../RealityKitContent.rkassets/monster04.usda` | technischer Kugel-Platzhalter | neu | 005 |

## Monster-Asset-Status

| Monster-ID | aktuelles lokales Asset | Finales Blender-Modell |
|---|---|---|
| `monster01` | `monster01.usda` Kugel | fehlt |
| `monster02` | `monster02.usda` Kugel | fehlt |
| `monster03` | `monster03.usda` Kugel | fehlt |
| `monster04` | `monster04.usda` Kugel | fehlt |

Die USDA-Dateien sind nur Pipeline-Platzhalter.

## Ticket-Monster-Mapping

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

## Schnittstellen für Folgemodule

| Schnittstelle | Datei | Zweck |
|---|---|---|
| `Ticket.monsterAssetId` | `Models/Ticket.swift` | logischer Monster-Bezeichner |
| `AssetKeys.Monster.monster01...monster04` | `Support/AppConstants.swift` | vier stabile neutrale IDs |
| `AssetKeys.Monster.allIDs` | `Support/AppConstants.swift` | vollständige ID-Liste |
| `MonsterAssetProvider.loadMonster(assetID:) async throws -> Entity` | `Assets/MonsterAssetProvider.swift` | lokale Entity laden |
| `MonsterAssetProvider.LoadError` | `Assets/MonsterAssetProvider.swift` | unbekannte/nicht ladbare Assets |
| `SessionModel.currentTicket` | `Models/SessionModel.swift` | aktuelles Ticket für Modul 006 |
| `SessionModel.currentPhase` | `Models/SessionModel.swift` | `.untersuchen` nach Start |
| `SessionModel` via Environment | App-/View-Baum | gemeinsame Zustandsquelle |

## MonsterAssetProvider-Verhalten

1. Asset-ID gegen `AssetKeys.Monster.allIDs` prüfen.
2. Unbekannte ID → typisierter `LoadError`.
3. Lokales `Entity(named:in:)` mit `realityKitContentBundle`.
4. Erfolg oder Ladefehler via `DebugManager.log(.spawning, ...)`.
5. Kein Netzwerkzugriff.
6. Kein stiller Fallback auf ein fremdes Asset.

## Teststand

- Vor Modul 005: 27 Testdeklarationen.
- 005-Report nennt an einer Stelle 9 neue Tests.
- Detaillierte Liste enthält 11 neue Tests.
- Report berechnet 38 gesamt.

**Verbindlicher Stand:** tatsächliche Zahl und Ausführung vor Modul 006 lokal prüfen.

## F-14 / AK-14

| Teil | Stand |
|---|---|
| vier neutrale Asset-IDs | implementiert |
| Ticketzuordnung | implementiert |
| keine 1:1-Zuordnung zu Team/Priorität | implementiert |
| lokale Ladepipeline | implementiert |
| kein Netzwerk | konstruktiv erfüllt |
| vier eigene Blender-Monster | **offen** |
| vier finale Exporte | **offen** |
| Simulator-Darstellung aller vier finalen Modelle | **offen** |
| Blickfokus/Pinch/Drag | **offen bis Modul 007** |

Modul 005 ist deshalb **teilweise abgeschlossen**.

## Offene Punkte

- Modul-005-Commit/Hash fehlt.
- Build nach Modul 005 fehlt.
- Simulatorprüfung nach Modul 005 fehlt.
- Testausführung und tatsächliche Testzahl fehlen.
- AK-01-Nachprüfung aus Modul 004 fehlt.
- Vier eigene Blender-Modelle fehlen.
- Blender-Exportpipeline und Lizenzstatus fehlen.
- Finale Monstergröße und -orientierung ungeprüft.
- Tickettexte mit `ae`, `oe`, `ue` sind vor Modul-006-Anzeige zu prüfen.
- `.DS_Store`-Bereinigung bleibt offen.

## Nicht vorhanden beziehungsweise nicht vorweggenommen

- Untersuchungsansicht,
- Ticketkarte,
- „Weiter zur Priorisierung“,
- Gesteninteraktion,
- Drop-Ziele,
- Prioritätsziele,
- Teamstationen,
- Bewertung,
- Audio,
- Ergebnisansicht,
- Monsterreaktion.
