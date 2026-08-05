# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten beziehungsweise durch Modul-Reports gemeldeten Codes. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `002` — Ticketdatenmodell und lokaler Katalog  
**Eingearbeitet am:** 2026-08-05  
**Modul-002-Commit:** nicht bekannt  
**Modul-002-Branch:** nicht angegeben  
**Merge in `main`:** nicht angegeben

## Verifikationsstatus

### Zuletzt vollständig bestätigter Lauf

Für Modul 001 waren App-Build, visionOS-Simulatorstart und 1 von 1 Tests auf `arm64-apple-xros1.0-simulator` erfolgreich bestätigt.

### Stand nach Modul 002

Der Modul-Report beschreibt zwei neue Swift-Dateien und sechs zusätzliche Testfälle. Ein tatsächlich ausgeführter App-Build und Testlauf nach diesen Änderungen ist nicht dokumentiert. Deshalb gilt:

- Datenmodell und Katalog: implementiert gemeldet,
- Testcode: implementiert gemeldet,
- Kompilierung des aktuellen Stands: offen,
- Ausführung der gesamten Test-Suite: offen,
- endgültige Erfüllung von AK-02 und AK-03: bis zur erfolgreichen Verifikation offen.

## Aktueller Repository- und Dokumentationsbaum

```text
Ticket-Tamer/
├─ .DS_Store                                  # unerwünschte macOS-Metadatei; laut Report geändert
├─ Ticket_Tamer/
│  ├─ .DS_Store                               # unerwünschte macOS-Metadatei; laut Report neu
│  ├─ Ticket_Tamer.xcodeproj/
│  │  └─ project.pbxproj
│  ├─ Ticket_Tamer/
│  │  ├─ .DS_Store                            # unerwünschte macOS-Metadatei; laut Report neu
│  │  ├─ App/
│  │  │  └─ Ticket_TamerApp.swift
│  │  ├─ Data/
│  │  │  └─ LocalTicketCatalog.swift          # neu in 002
│  │  ├─ Debug/
│  │  │  └─ DebugManager.swift
│  │  ├─ Models/
│  │  │  └─ Ticket.swift                      # neu in 002
│  │  ├─ Resources/
│  │  │  └─ Localizable.xcstrings
│  │  ├─ Support/
│  │  │  └─ AppConstants.swift
│  │  ├─ Views/
│  │  │  └─ RootVolumeView.swift
│  │  ├─ Assets.xcassets
│  │  └─ Info.plist
│  ├─ Ticket_TamerTests/
│  │  └─ Ticket_TamerTests.swift              # in 002 um sechs Tests ergänzt
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
│  └─ Products/                               # Xcode-Buildproduktgruppe
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
   │  └─ DebugManager.swift                   # nur Dokumentationsvorlage, falls dort bewusst aufbewahrt
   ├─ 03_Modul-Eingangsprompts/
   │  ├─ 001-Eingangsprompt.md
   │  ├─ 002-Eingangsprompt.md
   │  └─ 003-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  └─ 002-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` | Xcode-Projektstruktur und Dateieinbindung | zuletzt in 001 geändert; Änderung in 002 nicht gemeldet | 001 |
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg mit genau einer volumetrischen `WindowGroup` | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | minimale deutsche Root-Oberfläche mit RealityKit-Standardszene | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | `TicketPriority`, `SupportTeam` und fachliches `Ticket`-Modell | neu gemeldet | 002 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | statischer lokaler Katalog mit genau zwölf Tickets | neu gemeldet | 002 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout-, Ticketanzahl- und Asset-Konstanten | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche Lokalisierungsgrundlage | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Info.plist` | volumetrische Scene-Rolle | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Assets.xcassets` | Asset-Katalog | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | Smoke-Test aus 001 und laut Report sechs zusätzliche Modell-/Katalogtests | ergänzt; Ausführung nach 002 offen | 001/002 |
| `Ticket_Tamer/Packages/RealityKitContent/Package.swift` | Package-Definition | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Package.realitycomposerpro` | Reality-Composer-Pro-Projekt | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.swift` | Package-Schnittstelle | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Scene.usda` | RealityKit-Standardszene | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Materials/GridMaterial.usda` | Material der Standardszene | vorhanden | Ausgangsprojekt |

## Öffentliche beziehungsweise modulinterne Schnittstellen für Folgemodule

Die Typen aus Modul 002 besitzen laut Report keinen expliziten `public`-Zugriffsmodifikator. Sie sind innerhalb desselben App-Moduls verwendbar und über `@testable import` testbar.

| Typ oder Methode | Datei | Zweck |
|---|---|---|
| `Ticket_TamerApp` | `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App- und Scene-Einstieg |
| `RootVolumeView` | `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Root-Oberfläche im zentralen Volume |
| `DebugManager` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale Debug-Steuerung |
| `DebugManager.Category` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| `DebugManager.log(_:_:function:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisierte Log-Ausgabe |
| `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout- und Volume-Maße |
| `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Ticketanzahl-Grenzen 1 bis 12, Standardwert 6 |
| `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | vorhandene Asset-Schlüssel |
| `TicketPriority` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Prioritäten `.normal`, `.wichtig`, `.kritisch` |
| `TicketPriority.displayName: String` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Anzeigenamen `Normal`, `Wichtig`, `Kritisch` |
| `SupportTeam` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Teams `.netzwerk`, `.konto`, `.software`, `.hardware` |
| `SupportTeam.displayName: String` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Anzeigenamen `Netzwerk`, `Konto`, `Software`, `Hardware` |
| `Ticket` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | `Identifiable`- und `Equatable`-Ticket mit Pflichtdaten und Referenzwerten |
| `LocalTicketCatalog.allTickets: [Ticket]` | `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | vollständiger statischer Ticketpool |

## Gemeldetes Ticketmodell

`Ticket` enthält laut Report:

- `id`,
- `ticketNumber`,
- `title`,
- `shortDescription`,
- `userImpact`,
- `symptoms`,
- `referencePriority`,
- `referenceTeam`.

Die SPEC-Architekturskizze nennt zusätzlich `monsterAssetId`. Dieses Feld ist im gemeldeten Interface nicht enthalten; der Report dokumentiert dazu keine bewusste Entscheidung. Modul 003 darf das Ticketmodell nicht nebenbei erweitern. Die Abgrenzung muss spätestens vor Modul 005 entschieden und im Projektlogbuch festgehalten werden.

## Gemeldeter lokaler Katalog

- Schnittstelle: `LocalTicketCatalog.allTickets: [Ticket]`
- Anzahl: genau 12 laut Report
- Datenquelle: statisch im Code
- externe Netzwerk-, Datei- oder API-Zugriffe: keine laut Report
- Verteilung: jede Kombination aus 4 Teams und 3 Prioritäten genau einmal laut Report
- einzelne Ticketnummern, Titel und Kombinationen: im Report nicht aufgelistet

## Zentrale Konstanten-Enums

| Enum | Datei | Inhalt |
|---|---|---|
| `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Volume-Maße und Layoutabstände |
| `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Minimum 1, Maximum 12, Standardwert 6 |
| `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Schlüssel `"Scene"` |

### Bestätigte Werte aus Modul 001

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

`BalancingConstants` ist weiterhin nicht vorhanden.

## DebugManager-Stand

- genau eine aktive Datei unter `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift`,
- Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`,
- Modul 002 ergänzte keine Kategorie und kein Logging,
- `DebugPanel` bleibt außerhalb des regulären Nutzerablaufs.

## Teststand

### Bereits bestätigter Test aus Modul 001

- positive Maße des zentralen Volumes,
- auf `arm64-apple-xros1.0-simulator` bestanden.

### In Modul 002 gemeldete neue Tests

- Katalog enthält genau zwölf Tickets,
- jede Team-/Prioritätskombination genau einmal,
- Pflichtdaten und Symptomanzahl,
- eindeutige IDs und Ticketnummern,
- lokale Verfügbarkeit ohne externe Quelle,
- ausschließlich erlaubte Enum-Fälle.

Die Ausführung dieser Tests und der gesamten Suite nach Modul 002 ist nicht dokumentiert.

## Konfliktanfällige Dateien

- `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj`
- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift`
- `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift`

Modul 003 soll App-Einstieg, Root-View, Volume-Konfiguration, Tickettexte und Katalog nicht ändern, sofern kein nachgewiesener Buildfehler aus Modul 002 dies zwingend erfordert.

## Für Modul 003 vorgesehene neue Verantwortungsbereiche

Nach Analyse des echten Projektstands darf Modul 003 einen einfachen Bereich für den zentralen Sitzungszustand einrichten, vorzugsweise unter `Models/` oder einem ebenso nachvollziehbaren bestehenden Verantwortungsbereich. Benötigt werden:

- zentrale, im Arbeitsspeicher gehaltene Sitzung,
- Ticketanzahl 1 bis 12 mit Standardwert 6,
- zufällige Auswahl aus `LocalTicketCatalog.allTickets` ohne Wiederholung,
- sicherer aktueller Ticketindex und Zugriff auf das aktuelle Ticket,
- Modellreset für Ticketanzahl, Sitzungstickets, Index, Phase, Punkte, Entscheidungen und Eingabesperre,
- Tests ohne UI-Abhängigkeit.

## Nicht vorhanden und nicht vorwegzunehmen

- fertige Startansicht und Regler,
- Anzeige oder Navigation der Sitzungsphasen,
- Ticketkarte,
- Monster-Asset-Pipeline,
- RealityKit-Interaktionen,
- Drop-Ziele,
- Punktebewertung,
- Audiofeedback,
- automatischer 1,5-Sekunden-Übergang,
- Ergebnisansicht,
- UI-Aktion „Erneut spielen“,
- optionale Monsterreaktion.

## Nicht mehr vorhanden oder bewusst ersetzt

- frühere Default-`ContentView` nicht mehr im aktiven Projektbaum beziehungsweise App-Einstieg,
- frühere Position von `Ticket_TamerApp.swift` ersetzt durch `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`,
- keine zweite aktive `DebugManager.swift` im Repository-Stamm,
- keine gemeldeten parallelen `New`-, `Old`-, `Copy`- oder `Backup`-Dateien.

## Unerwünschte Dateien

Laut Modul-002-Report vorhanden beziehungsweise geändert:

- `.DS_Store`
- `Ticket_Tamer/.DS_Store`
- `Ticket_Tamer/Ticket_Tamer/.DS_Store`

Sie sind kein fachlicher Projektbestandteil und müssen in einem bewussten Cleanup entfernt und künftig ignoriert werden. Sie werden nicht als erforderliche Aufgabe von Modul 003 behandelt.
