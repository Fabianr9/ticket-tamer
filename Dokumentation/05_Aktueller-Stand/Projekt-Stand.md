# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten beziehungsweise durch Modul-Reports gemeldeten Codes. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `003` — Sitzungsmodell und Zufallsauswahl
**Eingearbeitet am:** 2026-08-05
**Modul-003-Commit:** vorgesehen `003: Sitzungsmodell und Zufallsauswahl`; Hash nach lokalem Commit nachtragen
**Modul-003-Branch:** `main`
**Merge in `main`:** nach lokalem Build und Testlauf

## Verifikationsstatus

### Zuletzt vollständig bestätigter Lauf

Für Modul 001 waren App-Build, visionOS-Simulatorstart und 1 von 1 Tests auf `arm64-apple-xros1.0-simulator` erfolgreich bestätigt.

### Stand nach Modul 002

Der Modul-Report beschreibt zwei neue Swift-Dateien und sechs zusätzliche Testfälle. Ein tatsächlich ausgeführter App-Build und Testlauf nach Modul 002 ist nicht dokumentiert. Deshalb gilt:

- Datenmodell und Katalog: implementiert gemeldet,
- Testcode: implementiert gemeldet,
- Kompilierung und Test-Suite nach Modul 002: offen,
- AK-02 und AK-03: bis zur erfolgreichen Verifikation offen.

### Stand nach Modul 003

Der Modul-Report beschreibt zwei neue Swift-Dateien und zwölf neue Testfälle. Ein tatsächlich ausgeführter App-Build und Testlauf ist in Xcode lokal auszuführen (kein `xcodebuild` im Cowork-Sandbox-Ausführungsumfeld verfügbar). Deshalb gilt:

- `GamePhase`-Enum und `SessionModel`: implementiert gemeldet,
- 12 neue Tests in `SessionModelTests`: implementiert gemeldet,
- Kompilierung des aktuellen Stands: offen,
- Ausführung der gesamten Test-Suite (19 Tests): offen,
- AK-04 (Modellanteil): bis zur erfolgreichen Verifikation offen,
- AK-16 (Modellanteil): bis zur erfolgreichen Verifikation offen; UI-Anteil gezielt auf Modul 004 und 011 verschoben.

## Aktueller Repository- und Dokumentationsbaum

```text
Ticket-Tamer/
├─ .DS_Store                                  # unerwünschte macOS-Metadatei
├─ Ticket_Tamer/
│  ├─ .DS_Store                               # unerwünschte macOS-Metadatei
│  ├─ Ticket_Tamer.xcodeproj/
│  │  └─ project.pbxproj                      # unverändert seit 001; PBXFileSystemSynchronizedRootGroup
│  ├─ Ticket_Tamer/
│  │  ├─ .DS_Store                            # unerwünschte macOS-Metadatei
│  │  ├─ App/
│  │  │  └─ Ticket_TamerApp.swift             # unverändert
│  │  ├─ Data/
│  │  │  └─ LocalTicketCatalog.swift          # neu in 002; unverändert in 003
│  │  ├─ Debug/
│  │  │  └─ DebugManager.swift                # unverändert
│  │  ├─ Models/
│  │  │  ├─ GamePhase.swift                   # neu in 003
│  │  │  ├─ SessionModel.swift                # neu in 003
│  │  │  └─ Ticket.swift                      # neu in 002; unverändert in 003
│  │  ├─ Resources/
│  │  │  └─ Localizable.xcstrings             # unverändert
│  │  ├─ Support/
│  │  │  └─ AppConstants.swift                # unverändert
│  │  ├─ Views/
│  │  │  └─ RootVolumeView.swift              # unverändert
│  │  ├─ Assets.xcassets
│  │  └─ Info.plist
│  ├─ Ticket_TamerTests/
│  │  └─ Ticket_TamerTests.swift              # in 002 um 6 Tests, in 003 um 12 Tests ergänzt
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
   │  └─ DebugManager.swift
   ├─ 03_Modul-Eingangsprompts/
   │  ├─ 001-Eingangsprompt.md
   │  ├─ 002-Eingangsprompt.md
   │  └─ 003-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  ├─ 002-Report.md
   │  └─ 003-Report.md                        # neu in 003
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md                     # dieses Dokument; ersetzt 002-Stand
```

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` | Xcode-Projektstruktur; `PBXFileSystemSynchronizedRootGroup` — neue Dateien werden automatisch erkannt | unverändert seit 001 | 001 |
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg mit genau einer volumetrischen `WindowGroup` | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | minimale deutsche Root-Oberfläche mit RealityKit-Standardszene | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | `GamePhase`-Enum mit 5 SPEC-Phasen (`start`, `untersuchen`, `priorisieren`, `teamZuordnen`, `ergebnis`), `Equatable` | neu gemeldet | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | Zentrales Sitzungsmodell `@Observable @MainActor`, alle 8 Zustandsfelder, Methoden für Ticketanzahl, Sitzungsstart, Indexfortschaltung, Reset | neu gemeldet | 003 |
| `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | `TicketPriority`, `SupportTeam`, fachliches `Ticket`-Modell | neu gemeldet in 002; unverändert in 003 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | statischer lokaler Katalog mit genau 12 Tickets | neu gemeldet in 002; unverändert in 003 | 002 |
| `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout-, Ticketanzahl- und Asset-Konstanten | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | deutsche Lokalisierungsgrundlage | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Info.plist` | volumetrische Scene-Rolle | aktiv | 001 |
| `Ticket_Tamer/Ticket_Tamer/Assets.xcassets` | Asset-Katalog | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | 7 Tests aus 001/002 + 12 neue Tests aus 003 (Struct `SessionModelTests`, `@MainActor`) | ergänzt; Ausführung nach 003 offen | 001/002/003 |
| `Ticket_Tamer/Packages/RealityKitContent/Package.swift` | Package-Definition | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Package.realitycomposerpro` | Reality-Composer-Pro-Projekt | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.swift` | Package-Schnittstelle | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Scene.usda` | RealityKit-Standardszene | vorhanden | Ausgangsprojekt |
| `Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/Materials/GridMaterial.usda` | Material der Standardszene | vorhanden | Ausgangsprojekt |

## Öffentliche beziehungsweise modulinterne Schnittstellen für Folgemodule

| Typ oder Methode | Datei | Zweck |
|---|---|---|
| `Ticket_TamerApp` | `App/Ticket_TamerApp.swift` | App- und Scene-Einstieg |
| `RootVolumeView` | `Views/RootVolumeView.swift` | Root-Oberfläche im zentralen Volume |
| `DebugManager` | `Debug/DebugManager.swift` | zentrale Debug-Steuerung |
| `DebugManager.Category` | `Debug/DebugManager.swift` | `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| `DebugManager.log(_:_:function:)` | `Debug/DebugManager.swift` | kategorisierte Log-Ausgabe |
| `LayoutConstants` | `Support/AppConstants.swift` | Layout- und Volume-Maße |
| `GameplayConstants` | `Support/AppConstants.swift` | Ticketanzahl-Grenzen 1–12, Standardwert 6 |
| `AssetKeys` | `Support/AppConstants.swift` | vorhandene Asset-Schlüssel |
| `TicketPriority` | `Models/Ticket.swift` | `.normal`, `.wichtig`, `.kritisch` |
| `TicketPriority.displayName: String` | `Models/Ticket.swift` | Anzeigenamen |
| `SupportTeam` | `Models/Ticket.swift` | `.netzwerk`, `.konto`, `.software`, `.hardware` |
| `SupportTeam.displayName: String` | `Models/Ticket.swift` | Anzeigenamen |
| `Ticket` | `Models/Ticket.swift` | `Identifiable`/`Equatable`-Struct mit Pflichtdaten |
| `LocalTicketCatalog.allTickets: [Ticket]` | `Data/LocalTicketCatalog.swift` | vollständiger statischer Ticketpool (12 Tickets) |
| `GamePhase` | `Models/GamePhase.swift` | 5 SPEC-Phasen, `Equatable`; neu in 003 |
| `SessionModel` | `Models/SessionModel.swift` | `@Observable @MainActor`-Sitzungszustand; neu in 003 |
| `SessionModel.selectedTicketCount: Int` | `Models/SessionModel.swift` | aktuelle Ticketanzahl |
| `SessionModel.setTicketCount(_:)` | `Models/SessionModel.swift` | Ticketanzahl setzen (Modul 004) |
| `SessionModel.startSession(using:)` | `Models/SessionModel.swift` | Sitzung starten (Modul 004) |
| `SessionModel.sessionTickets: [Ticket]` | `Models/SessionModel.swift` | aktuelle Sitzungstickets |
| `SessionModel.currentTicket: Ticket?` | `Models/SessionModel.swift` | sicherer Zugriff auf aktuelles Ticket |
| `SessionModel.currentTicketIndex: Int` | `Models/SessionModel.swift` | aktueller Index |
| `SessionModel.advanceToNextTicket()` | `Models/SessionModel.swift` | Index vorschalten (Klemm-Semantik) |
| `SessionModel.currentPhase: GamePhase` | `Models/SessionModel.swift` | aktuelle Phase |
| `SessionModel.score: Int` | `Models/SessionModel.swift` | Punktestand |
| `SessionModel.selectedPriority: TicketPriority?` | `Models/SessionModel.swift` | gewählte Priorität |
| `SessionModel.selectedTeam: SupportTeam?` | `Models/SessionModel.swift` | gewähltes Team |
| `SessionModel.isInputLocked: Bool` | `Models/SessionModel.swift` | Eingabesperre |
| `SessionModel.reset()` | `Models/SessionModel.swift` | vollständiger Reset (Modul 011) |

## Sitzungsmodell-Semantik (neu in 003)

### Auswahl-Semantik

- Quelle: ausschließlich `LocalTicketCatalog.allTickets`.
- Mischung über `shuffle`-Parameter von `startSession(using:)`.
- Kein Duplikat möglich, da Präfix einer bereits duplikatfreien Quelle.
- Gültiger Bereich: 1–12 Tickets; Standardwert 6.
- Defensives Klemmen bei `setTicketCount(_:)`.

### Index-Endsemantik

Klemm-Semantik: Index bleibt am Ende der Liste. Kein Wrap-around, kein Überlauf. `currentTicket` liefert weiterhin das letzte Ticket. Phasenwechsel auf `.ergebnis` gehört zu Modul 006.

### Reset-Semantik

Alle 8 Felder werden auf Startwerte gesetzt: `selectedTicketCount` = 6, `sessionTickets` = `[]`, `currentTicketIndex` = 0, `currentPhase` = `.start`, `score` = 0, `selectedPriority` = `nil`, `selectedTeam` = `nil`, `isInputLocked` = `false`. Funktioniert unabhängig vom Vorzustand; beliebig viele aufeinanderfolgende Resets möglich.

## Teststand

### Bereits in 001 bestätigte Tests

- positive Maße des zentralen Volumes — bestanden auf `arm64-apple-xros1.0-simulator`.

### In 002 gemeldete, noch nicht verifikationsgeprüfte Tests (7 Tests)

- Katalog enthält genau 12 Tickets,
- jede Team-/Prioritätskombination genau einmal,
- Pflichtdaten und Symptomanzahl,
- eindeutige IDs und Ticketnummern,
- lokale Verfügbarkeit ohne externe Quelle,
- ausschließlich erlaubte Enum-Fälle.
- *Hinzu: der Smoke-Test aus 001 (1 Test).*

### In 003 gemeldete neue Tests (12 Tests, `@MainActor SessionModelTests`)

- Standardticketanzahl ist 6,
- Grenzwerte 1 und 12,
- defensives Klemmen bei ungültigen Werten,
- Sitzung mit 1 Ticket,
- Sitzung mit 6 Tickets,
- Sitzung mit 12 Tickets,
- keine doppelte Ticket-ID,
- alle Tickets aus Katalog,
- Auswahlfunktion wird bei neuer Sitzung erneut ausgeführt,
- deterministische Testnaht für unterschiedliche Auswahlen,
- Index startet bei 0,
- sicherer Zugriff auf `currentTicket`,
- Klemm-Semantik am Indexende,
- Reset aller 8 Felder,
- 5 aufeinanderfolgende Resets ohne Altzustand.

### Erwartete Gesamtanzahl nach lokalem Testlauf

19 Tests (7 aus 001/002 + 12 aus 003), alle bestanden. Plattform: `arm64-apple-xros-simulator`.

## Konfliktanfällige Dateien

- `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj` (in 003 unverändert)
- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift`
- `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` (neu; ab 004 konfliktanfällig)

## Für Modul 004 vorgesehene neue Verantwortungsbereiche

Modul 004 soll `SessionModel` in `RootVolumeView` (oder einer neuen Startansicht) einbinden, `setTicketCount(_:)` an einen visionOS-Regler binden und `startSession()` an die Startschaltfläche koppeln. Zu entscheiden: ob `SessionModel` als `@State`-Eigenschaft oder über `@Environment` bereitgestellt wird.

## Noch nicht vorhanden und nicht vorwegzunehmen

- fertige Startansicht und Regler,
- sichtbarer Wechsel zur Startansicht (Modul 004/011),
- Schaltfläche „Erneut spielen" (Modul 011),
- Ticketkarte (Modul 005),
- Monster-Asset-Pipeline (Modul 005),
- RealityKit-Interaktionen,
- Drop-Ziele,
- Bewertungslogik (Modul 006/009),
- Punktevergabe,
- Audiofeedback,
- automatischer 1,5-Sekunden-Übergang,
- Ergebnisansicht,
- Phasenübergänge (Modul 006).

## Nicht mehr vorhanden oder bewusst ersetzt

- frühere Default-`ContentView` nicht mehr aktiv,
- keine zweite aktive `DebugManager.swift` im Repository-Stamm,
- keine gemeldeten parallelen `New`-, `Old`-, `Copy`- oder `Backup`-Dateien.

## Unerwünschte Dateien

Vorhanden und nicht durch Modul 003 entfernt:

- `.DS_Store`
- `Ticket_Tamer/.DS_Store`
- `Ticket_Tamer/Ticket_Tamer/.DS_Store`

Bereinigung und `.gitignore`-Eintrag sind als separater Auftrag vorzusehen.
