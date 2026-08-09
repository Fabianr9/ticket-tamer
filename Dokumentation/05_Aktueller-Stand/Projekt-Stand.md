# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `006` — Untersuchungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Commit vor Modul 006:** `98cd95d fix:import error`  
**Modul-005-Commit enthalten:** `68b84f3 feat:Modul005`  
**Modul-006-Commit:** offen  
**Build nach Modul 006:** nicht nachgewiesen  
**Simulatorstart nach Modul 006:** nicht nachgewiesen  
**Testlauf nach Modul 006:** nicht nachgewiesen (45 Tests deklariert)

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- deutsche Startansicht,
- genau eine `SessionModel`-Instanz im App-Baum,
- zwölf lokale Tickets mit korrekten deutschen Umlauten,
- vollständige Team-/Prioritätsverteilung,
- `monsterAssetId` pro Ticket,
- vier neutrale Monster-IDs,
- lokales Monster-Ladeinterface,
- vier technische USDA-Platzhalter,
- phasenabhängige Root-Darstellung,
- **Untersuchungsansicht mit Monster, Ticketkarte und Weiter-Button** (neu Modul 006),
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
│  │  │  ├─ InvestigationView.swift     ← neu (Modul 006)
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
   │  ├─ 005-Report.md
   │  └─ 006-Report.md                  ← neu
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg, volumetrische Scene, Besitz des `SessionModel` | unverändert in 006 | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | phasenabhängige Root-Darstellung | `.untersuchen`-Fall ergänzt | 001/004/006 |
| `Ticket_Tamer/Ticket_Tamer/Views/InvestigationView.swift` | Untersuchungsansicht (Monster, Ticketkarte, Weiter-Button) | **neu** | 006 |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | deutsche Startansicht | unverändert in 006 | 004 |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Ticketmodell inkl. `monsterAssetId` | unverändert in 006 | 002/005 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | zwölf Tickets mit korrekten Umlauten | Umlautkorrekturen | 002/005/006 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf grundlegende Spielphasen | unverändert | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentrale Sitzungsquelle; `beginPrioritizationPhase()` neu | ergänzt | 003/006 |
| `Ticket_Tamer/Ticket_Tamer/Assets/MonsterAssetProvider.swift` | lokales asynchrones Monster-Laden | unverändert in 006 | 005 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Constants inkl. `AssetKeys.Monster` und Modul-006-Layout | ergänzt | 001/005/006 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisiertes Logging | unverändert; `.lifecycle`, `.input`, `.state`, `.spawning` genutzt | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche UI-Strings | 7 neue Schlüssel (Modul 006) | 001/004/006 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Tests 001–006; 45 Deklarationen | ergänzt | 001–006 |
| `.../RealityKitContent.rkassets/monster01–04.usda` | technische Kugel-Platzhalter | unverändert in 006 | 005 |

## Monster-Asset-Status

| Monster-ID | aktuelles lokales Asset | Finales Blender-Modell |
|---|---|---|
| `monster01` | `monster01.usda` Kugel | fehlt |
| `monster02` | `monster02.usda` Kugel | fehlt |
| `monster03` | `monster03.usda` Kugel | fehlt |
| `monster04` | `monster04.usda` Kugel | fehlt |

Die USDA-Dateien sind nur Pipeline-Platzhalter. Modul 006 zeigt sie in `InvestigationView` via `RealityView`.

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
| `SessionModel.beginPrioritizationPhase()` | `Models/SessionModel.swift` | Phasenwechsel `.untersuchen → .priorisieren` (für Modul 008) |
| `SessionModel.currentTicket` | `Models/SessionModel.swift` | aktuelles Ticket für View-Darstellung |
| `SessionModel.currentPhase` | `Models/SessionModel.swift` | phasenabhängiges Routing in `RootVolumeView` |
| `SessionModel` via Environment | App-/View-Baum | gemeinsame Zustandsquelle |
| `Ticket.monsterAssetId` | `Models/Ticket.swift` | logischer Monster-Bezeichner |
| `AssetKeys.Monster.monster01...monster04` | `Support/AppConstants.swift` | vier stabile neutrale IDs |
| `AssetKeys.Monster.allIDs` | `Support/AppConstants.swift` | vollständige ID-Liste |
| `MonsterAssetProvider.loadMonster(assetID:) async throws -> Entity` | `Assets/MonsterAssetProvider.swift` | lokale Entity laden (für Modul 007: Monster-Interaktion) |
| `MonsterAssetProvider.LoadError` | `Assets/MonsterAssetProvider.swift` | typisierte Ladefehler |
| `InvestigationView` — `RealityView`-Anker | `Views/InvestigationView.swift` | Modul 007 kann hier Collision/InputTarget-Komponenten ergänzen |
| `LayoutConstants.monsterScale: Float` | `Support/AppConstants.swift` | Skalierungsfaktor für Monster-Entity (ggf. in Modul 007 angepasst) |

## Lokalisierungsschlüssel (kumulativ)

| Schlüssel | Wert |
|---|---|
| `app.title` | „Ticket Tamer" |
| `app.modulePlaceholder` | „Grundgerüst für das zentrale Ticket-Tamer-Volume" |
| `root.sessionPlaceholder` | „Sitzung läuft …" |
| `start.ticketCount.label` | „Anzahl Tickets" |
| `start.ticketCount.accessibility` | „Regler für Ticketanzahl" |
| `start.button.startGame` | „Spiel starten" |
| `investigation.button.nextPhase` | „Weiter zur Priorisierung" |
| `investigation.userImpact.label` | „Auswirkung" |
| `investigation.symptoms.label` | „Symptome und Hinweise" |
| `investigation.ticketNumber.label` | „Ticketnummer " |
| `investigation.loading.monster` | „Monster wird geladen …" |
| `investigation.error.monsterLoad` | „Monster konnte nicht geladen werden." |
| `investigation.error.noTicket` | „Kein aktives Ticket." |

## Teststand

- **Testzahl nach Modul 006:** 45 Deklarationen (38 aus Modul 001–005, +7 neu)
- **Tatsächlicher Testlauf:** nicht nachgewiesen

## F-14 / AK-14

| Teil | Stand |
|---|---|
| vier neutrale Asset-IDs | implementiert |
| Ticketzuordnung | implementiert |
| keine 1:1-Zuordnung zu Team/Priorität | implementiert |
| lokale Ladepipeline | implementiert |
| kein Netzwerk | konstruktiv erfüllt |
| Monster-Darstellung in `InvestigationView` | **neu Modul 006** (Platzhalter) |
| vier eigene Blender-Monster | **offen** |
| vier finale Exporte | **offen** |
| Simulator-Darstellung aller vier finalen Modelle | **offen** |
| Blickfokus/Pinch/Drag | **offen bis Modul 007** |

Modul 005 ist deshalb **teilweise abgeschlossen**; Modul 006 ergänzt die sichtbare Darstellung mit Platzhaltern.

## Offene Punkte

- Modul-006-Commit/Hash fehlt.
- Build nach Modul 006 fehlt.
- Simulatorprüfung nach Modul 006 fehlt.
- Testausführung fehlt.
- AK-01-Nachprüfung aus Modul 004 fehlt.
- Monster-Skalierung (`monsterScale = 0.2`) muss im Simulator validiert werden.
- Vier eigene Blender-Modelle fehlen.
- Blender-Exportpipeline und Lizenzstatus fehlen.
- Finale Monstergröße und -orientierung ungeprüft.
- `.DS_Store`-Bereinigung bleibt offen.
- `Logbuch-Stand.md` ist zu aktualisieren.

## Nicht vorhanden beziehungsweise nicht vorweggenommen

- Priorisierungsansicht (Modul 008),
- Gesteninteraktion (Modul 007),
- Drop-Ziele,
- Teamstationen,
- Bewertung,
- Audio,
- Ergebnisansicht,
- Monsterreaktion.
