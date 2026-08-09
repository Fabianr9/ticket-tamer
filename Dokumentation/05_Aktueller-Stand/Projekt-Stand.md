# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `006` — Untersuchungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Commit vor Modul 006:** `98cd95d fix:import error`  
**Modul-005-Commit:** `68b84f3 feat:Modul005`  
**Modul-006-Commit:** offen  
**Build nach Modul 006:** nicht nachgewiesen  
**Simulatorstart nach Modul 006:** nicht nachgewiesen  
**Testlauf nach Modul 006:** nicht nachgewiesen  
**Testdeklarationen im Quellstand:** 45

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- deutsche Startansicht,
- zwölf lokale Tickets,
- zentrales `SessionModel`,
- Auswahl ohne Wiederholung,
- Monsterzuordnung über `monsterAssetId`,
- vier lokale USDA-Platzhalter,
- `MonsterAssetProvider`,
- `InvestigationView`,
- vollständige Ticketkarte der Untersuchungsphase,
- kontrollierten Wechsel `.untersuchen → .priorisieren`,
- noch keine räumliche Drag-/Drop-Interaktion,
- noch keine Prioritätsziele oder Teamstationen.

F-06 und F-07 sind implementiert. Die tatsächliche Laufzeitabnahme von AK-06 und AK-07 steht aus, weil Build, Tests und Simulatorlauf nicht durchgeführt wurden.

F-14/AK-14 bleiben teilweise offen, weil weiterhin keine vier finalen eigenen Blender-Monster vorliegen.

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
   │  ├─ 006-Eingangsprompt.md
   │  └─ 007-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  ├─ 002-Report.md
   │  ├─ 003-Report.md
   │  ├─ 004-Report.md
   │  ├─ 005-Report.md
   │  └─ 006-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg, eine volumetrische Scene, Besitz des `SessionModel` | unverändert in 006 | 001/004 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | phasenabhängige Root-Darstellung; `.untersuchen` eingebunden | geändert | 001/004/006 |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | deutsche Startansicht | unverändert in 006 | 004 |
| `Ticket_Tamer/Ticket_Tamer/Views/InvestigationView.swift` | Ticket-Monster, Ticketkarte und Weiter-Schaltfläche | neu | 006 |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Ticketmodell inkl. Referenzdaten und `monsterAssetId` | unverändert in 006 | 002/005 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | zwölf lokale Tickets; deutsche Umlaute bereinigt | geändert | 002/005/006 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen`, `.ergebnis` | unverändert in 006 | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentraler Sitzungszustand inkl. `beginPrioritizationPhase()` | ergänzt | 003/006 |
| `Ticket_Tamer/Ticket_Tamer/Assets/MonsterAssetProvider.swift` | lokales asynchrones Monsterladen | unverändert in 006 | 005 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Constants; fünf neue Investigation-Layoutwerte | ergänzt | 001/005/006 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisiertes Logging | unverändert | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche UI-Strings; sieben Investigation-Schlüssel ergänzt | ergänzt | 001/004/006 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Tests 001–006 | ergänzt auf 45 gemeldete Testdeklarationen | 001–006 |
| `.../RealityKitContent.rkassets/monster01.usda` | technischer Monster-Platzhalter | unverändert | 005 |
| `.../RealityKitContent.rkassets/monster02.usda` | technischer Monster-Platzhalter | unverändert | 005 |
| `.../RealityKitContent.rkassets/monster03.usda` | technischer Monster-Platzhalter | unverändert | 005 |
| `.../RealityKitContent.rkassets/monster04.usda` | technischer Monster-Platzhalter | unverändert | 005 |

## Root-Phasenrouting

```text
RootVolumeView
├─ .start
│  └─ StartView
├─ .untersuchen
│  └─ InvestigationView
└─ .priorisieren / .teamZuordnen / .ergebnis
   └─ derzeit neutraler Platzhalter
```

## Untersuchungsphase

`InvestigationView` nutzt `SessionModel.currentTicket` als einzige Datenquelle.

Sichtbar:

- Monster,
- Ticketnummer,
- Titel,
- Kurzbeschreibung,
- Auswirkung,
- 1 bis 3 Symptome/Hinweise,
- „Weiter zur Priorisierung“.

Nicht sichtbar:

- Referenzpriorität,
- Referenzteam,
- technische Monster-ID.

### Fehler-/Ladezustände

Bestätigte Lokalisierungsschlüssel:

- `investigation.loading.monster`
- `investigation.error.monsterLoad`
- `investigation.error.noTicket`

## Neue Schnittstelle aus Modul 006

| Schnittstelle | Datei | Semantik |
|---|---|---|
| `SessionModel.beginPrioritizationPhase()` | `Models/SessionModel.swift` | nur `.untersuchen → .priorisieren`; Index und Prioritätsentscheidung bleiben unverändert |
| `InvestigationView` | `Views/InvestigationView.swift` | Untersuchungsdarstellung des aktiven Tickets |

## Bestehende Monster-Schnittstellen

| Schnittstelle | Zweck |
|---|---|
| `Ticket.monsterAssetId` | ID des zugeordneten Monsters |
| `AssetKeys.Monster.allIDs` | bekannte Monster-IDs |
| `MonsterAssetProvider.loadMonster(assetID:)` | lokale RealityKit-Entity laden |
| `MonsterAssetProvider.LoadError` | typisierte Fehler |

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | Finales eigenes Blender-Modell |
|---|---|---|
| `monster01` | USDA-Kugel | fehlt |
| `monster02` | USDA-Kugel | fehlt |
| `monster03` | USDA-Kugel | fehlt |
| `monster04` | USDA-Kugel | fehlt |

## Lokalisierungsschlüssel aus Modul 006

| Schlüssel | Wert |
|---|---|
| `investigation.button.nextPhase` | `Weiter zur Priorisierung` |
| `investigation.userImpact.label` | `Auswirkung` |
| `investigation.symptoms.label` | `Symptome und Hinweise` |
| `investigation.ticketNumber.label` | `Ticketnummer ` |
| `investigation.loading.monster` | `Monster wird geladen …` |
| `investigation.error.monsterLoad` | `Monster konnte nicht geladen werden.` |
| `investigation.error.noTicket` | `Kein aktives Ticket.` |

## Tickettext-Stand

Alle zwölf Tickets wurden auf deutsche Umlautdarstellung geprüft und bereinigt. Die fachlichen Werte wurden dabei nicht verändert:

- Referenzprioritäten unverändert,
- Referenzteams unverändert,
- Monster-IDs unverändert,
- 4×3-Kombinationsmatrix unverändert.

Der 006-Report enthält nur eine Auswahl der konkreten Textänderungen; daher wird hier keine vollständige Änderungsliste erfunden.

## Teststand

| Bereich | Stand |
|---|---|
| Testdeklarationen vor 006 | 38 |
| neue `InvestigationPhaseTests` | 7 |
| **gemeldeter Quellstand nach 006** | **45** |
| tatsächlicher Testlauf | nicht nachgewiesen |
| Build | nicht nachgewiesen |
| Simulator | nicht nachgewiesen |

## F-06 / F-07 / AK-06 / AK-07

| Teil | Stand |
|---|---|
| Ticketkarte mit allen Muss-Feldern | implementiert |
| Monster wird über Provider geladen | implementiert |
| Referenzlösung nicht angezeigt | konstruktiv implementiert |
| Button „Weiter zur Priorisierung“ | implementiert |
| Ticketindex bleibt gleich | testseitig beschrieben |
| `selectedPriority` bleibt `nil` | testseitig beschrieben |
| Build-/Testausführung | offen |
| Simulator-Sichtbarkeit und Lesbarkeit | offen |
| tatsächliche Monsterdarstellung | offen |

## DebugManager

- `.lifecycle`: Untersuchungsansicht,
- `.input`: Weiter-Schaltfläche,
- `.state`: Phasenwechsel,
- `.spawning`: Monsterprovider,
- keine neue Kategorie.

## Für Modul 007 relevante Ausgangslage

Vorhanden:

- RealityKit-Entity über `MonsterAssetProvider`,
- `RealityView` in `InvestigationView`,
- flache Entity-Hierarchie laut Report,
- `SessionModel.isInputLocked` als `private(set)`-Zustandsfeld,
- Debug-Kategorien `input`, `physics`, `state`, `spawning`.

Noch nicht vorhanden:

- Blick-/Hover-Interaktionsgrundlage für Gameplay,
- Greifen/Pinch,
- räumliches Dragging,
- generische Drop-Targets,
- Invalid-Drop-Rücksetzung,
- kontrollierte Eingabesperren-Mutation,
- Prioritätsziele,
- Teamstationen.

## Offene Punkte

- Modul-006-Commit/Hash fehlt.
- Build, Simulatorlauf und Testausführung nach 006 fehlen.
- AK-01, AK-06 und AK-07 sind noch manuell zu prüfen.
- finale vier Blender-Monster fehlen.
- Monster-Skalierung ist ungeprüft.
- `.DS_Store`-Bereinigung bleibt offen.
