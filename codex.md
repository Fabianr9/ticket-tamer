# Ticket Tamer – Projektleitfaden

Diese Datei beschreibt den aus Quellcode und Build-Konfiguration abgeleiteten Ist-Zustand des Projekts. Sie richtet sich an Entwicklerinnen, Entwickler und Coding-Agents, die Änderungen am Repository vornehmen. Historische Modulberichte unter `Dokumentation/` liefern zusätzlichen Kontext, sind aber keine aktuellere technische Wahrheit als der Code.

## 1. Projektüberblick und Tech-Stack

Ticket Tamer ist eine native, vollständig lokale visionOS-App für Apple Vision Pro. In einer Spielsitzung untersucht die spielende Person Support-Tickets und ordnet ein 3D-Monster zunächst einer Priorität und danach einem Support-Team zu. Die App läuft in genau einem volumetrischen Fenster; es gibt kein Backend, keine Datenbank, keine Netzwerk-API und keinen Immersive Space.

### Plattform und Toolchain

- Xcode-Projekt: `Ticket_Tamer/Ticket_Tamer.xcodeproj`
- App-Target und Scheme: `Ticket_Tamer`
- Unit-Test-Target: `Ticket_TamerTests`
- Zielplattformen: `xros` und `xrsimulator`, Gerätefamilie Apple Vision Pro
- Deployment Target: visionOS 26.5
- Projekt erzeugt mit Xcode 26.5; Projektformat `objectVersion = 77`
- Swift-Buildsetting des Xcode-Targets: `SWIFT_VERSION = 5.0`, zusätzlich Approachable Concurrency, Default Actor Isolation `MainActor` und Member Import Visibility
- Lokales Swift Package `RealityKitContent`: `swift-tools-version: 6.2`, Plattformdeklaration visionOS/macOS/iOS/tvOS 26
- Bundle-ID: `de.th-owl.fb2.Ticket-Tamer`, Version 1.0 (Build 1)

Für Build, Tests und Simulatorbetrieb ist macOS mit Xcode 26.5 und installierter visionOS-26.5-Runtime erforderlich. Auf Linux beziehungsweise ohne Xcode können die unten genannten `xcodebuild`-Befehle nicht ausgeführt werden.

### Frameworks und Bibliotheken

Das Projekt verwendet ausschließlich Apple-Frameworks und ein lokales Asset-Package; externe Third-Party-Abhängigkeiten existieren nicht.

- **SwiftUI** für App-Lifecycle, Views, Environment, Layout und Gesten
- **RealityKit** für Entities, Komponenten, `RealityView`, `Model3D`, räumliche Bounds und 3D-Interaktion
- **Observation** mit `@Observable` für den zentralen Sitzungszustand
- **Swift Testing** (`import Testing`, `@Test`, `#expect`) für Unit- und Logiktests; kein XCTest-Stil im vorhandenen Testcode
- **AVFoundation** für die beiden lokalen Feedback-Sounds
- **OSLog** für kategorisiertes Debug-Logging
- **Spatial**, **simd**, **CoreGraphics** und teilweise **UIKit** für räumliche Mathematik, Geometrie und Material-/Farbbrücken
- **Reality Composer Pro** und USD/USDC-Ressourcen über das lokale Package `RealityKitContent`
- **String Catalog** (`Localizable.xcstrings`) für deutsche UI-Texte und Accessibility-Texte

Es gibt weder `package.json` noch `pyproject.toml`, Dockerfile, CocoaPods-Konfiguration oder externe Swift-Package-Abhängigkeiten. Abhängigkeiten werden durch Xcode und das lokale Package aufgelöst.

## 2. Architektur und Ordnerstruktur

### Überblick

```text
.
├── codex.md                         # dieser Entwicklungsleitfaden
├── README.md                        # derzeit nur Projekttitel
├── Dokumentation/                   # Spezifikation, Modulhistorie und Projektstatus
├── Monster/                         # zusätzliche/ursprüngliche USDC-Assetvarianten
└── Ticket_Tamer/
    ├── Ticket_Tamer.xcodeproj/      # Xcode-Projekt und Buildsettings
    ├── Ticket_Tamer/                # App-Target
    │   ├── App/                     # App-Einstieg
    │   ├── Assets/                  # Asset-Lade- und Aufbereitungslogik
    │   ├── Assets.xcassets/         # App-Icon und Accent Color
    │   ├── Components/              # benutzerdefinierte RealityKit-Komponenten
    │   ├── Data/                    # statischer lokaler Ticketkatalog
    │   ├── Debug/                   # Logging und Debug-UI
    │   ├── Models/                  # Domänen- und Sitzungszustand
    │   ├── Resources/               # String Catalog und WAV-Dateien
    │   ├── Services/                # Audio-, Drag-, Drop-, Layout- und Geometrielogik
    │   ├── Support/                 # Konstanten und kleine Extensions
    │   └── Views/                   # phasenbezogene SwiftUI-/RealityKit-Oberflächen
    ├── Ticket_TamerTests/           # Swift-Testing-Tests des App-Targets
    └── Packages/RealityKitContent/  # lokales Swift-Package für RealityKit-Inhalte
```

Die App- und Testordner sind `PBXFileSystemSynchronizedRootGroup`s. Neue Dateien unter `Ticket_Tamer/Ticket_Tamer/` beziehungsweise `Ticket_Tamer/Ticket_TamerTests/` werden daher grundsätzlich automatisch vom passenden Target erkannt. `Info.plist` ist explizit von der normalen Target-Mitgliedschaft ausgenommen. Die `project.pbxproj` sollte für gewöhnliche neue Swift-Dateien nicht manuell editiert werden.

### App-Lifecycle und Navigation

`App/Ticket_TamerApp.swift` ist der einzige Einstiegspunkt. Er registriert `DropTargetComponent`, erzeugt genau eine `SessionModel`-Instanz und reicht sie über die SwiftUI-Environment weiter. Der `WindowGroup` verwendet `.windowStyle(.volumetric)` und seine Standardmaße kommen aus `LayoutConstants`.

`Views/RootVolumeView.swift` ist der Router des zentralen Volumes. Er schaltet anhand von `SessionModel.currentPhase` zwischen diesen Schritten:

```text
StartView
  → InvestigationView
  → PrioritizationView
  → TeamAssignmentView
  → ResultView
  → Reset / StartView
```

Die fachlichen Phasen stehen in `Models/GamePhase.swift`. Es sollen keine zusätzlichen Fenster, Volumes oder parallelen Navigationszustände eingeführt werden, sofern die Produktspezifikation nicht geändert wird.

### Zustand und Domänenmodell

- `Models/SessionModel.swift` ist die einzige Source of Truth der laufenden Sitzung. Die `@Observable @MainActor final class` besitzt `private(set)`-Zustand und kontrollierte Mutationsmethoden für Phasenwechsel, Entscheidungen, Exactly-once-Bewertung, Score, Input-Lock und Reset.
- `Models/Ticket.swift` definiert `Ticket`, `TicketPriority` und `SupportTeam` als kleine, stark typisierte Werttypen/Enums.
- `Data/LocalTicketCatalog.swift` enthält alle zwölf statischen Tickets. Daten werden nicht extern geladen.
- `Support/AppConstants.swift` bündelt Layout-, Gameplay-, Interaktions-, Phasen-, Feedback- und Assetkonstanten. Keine verstreuten Magic Numbers einführen, wenn ein Wert dort fachlich hingehört.

### Views und räumliche Interaktion

- `Views/StartView.swift`: Auswahl von 1 bis 12 Tickets und Sitzungsstart
- `Views/InvestigationView.swift`: Ticketkarte, nicht ziehbares Monster und Wechsel zur Priorisierung
- `Views/PrioritizationView.swift`: dreidimensionale Prioritätsziele, Drag/Drop, Feedback und Phasenwechsel
- `Views/TeamAssignmentView.swift`: 2×2-Teamziele, Drag/Drop, Bewertung und Abschluss eines Tickets
- `Views/ResultView.swift`: Endpunktzahl und vollständiger Neustart
- `Views/Components/`: wiederverwendbare Ticketkarte und skalierendes Layout
- `Views/Debug/DebugInteractionHarnessView.swift`: Entwicklungs-Harness, nicht Teil des normalen Routings

Die produktive räumliche Verarbeitung folgt im Wesentlichen dieser Kette:

```text
GeometryReader3D / RealityView
  → VolumeMetrics
  → MonsterDragGeometry
      ├── DragBounds
      ├── TargetPanelLayout
      └── DropEvaluator
```

`InvestigationFraming` ist davon bewusst getrennt und passt das nur dargestellte Monster in den tatsächlich gemessenen Panelquader ein. `PlanarDrag` konvertiert Gesten robust in die gewünschte Bewegungsebene. `MonsterInteractionConfigurator` versieht Entities abhängig vom Modus mit Kollisions- und Input-Komponenten. `TargetPanelFactory` hält sichtbare Panelgeometrie und Drop-Bounds konsistent.

Geometrische Regeln sollen aus den real gemessenen RealityKit-/Volume-Bounds abgeleitet werden, nicht aus Bildschirmkoordinaten oder der angeforderten `defaultSize`. Die Drop-Auswertung arbeitet in Szenenkoordinaten und enthält eine flächenbasierte 50-%-Überlappungsregel mit Z-Toleranz.

### Assets, Audio und Lokalisierung

- `Assets/MonsterAssetProvider.swift` validiert neutrale Monster-IDs, lädt USDC-Dateien aus `RealityKitContent`, korrigiert die Blender-Z-up-Ausrichtung, zentriert und skaliert Entities.
- `Packages/RealityKitContent/` ist ein lokales Library-Package. `RealityKitContent.rkassets` wird verarbeitet; `MonsterAssets/` wird als URL-ladbarer Fallback kopiert. Das Package enthält keine externen Dependencies.
- `Monster/` auf Repository-Ebene enthält zusätzliche Farbvarianten, ist aber nicht direkt die Build-Ressourcenquelle. Produktive Assets liegen im lokalen Package.
- `Resources/correct.wav` und `Resources/incorrect.wav` werden von `Services/AudioService.swift` abgespielt.
- `Resources/Localizable.xcstrings` ist der String Catalog mit Deutsch als Quellsprache. Wiederverwendbare sichtbare Texte und Accessibility-Texte als Lokalisierungsschlüssel pflegen.

### Dokumentation

`Dokumentation/01_Kontext/` enthält Projektbeschreibung, Spezifikation und Akzeptanzkriterien. `03_Modul-Eingangsprompts/` und `04_Modul-Reports/` sind historische Übergaben. `05_Aktueller-Stand/` beschreibt den zuletzt dokumentierten Prüfstand. Bei Widersprüchen gelten aktuelle Quellen und Buildsettings; Statusangaben aus Berichten nicht ungeprüft als gegenwärtiges Testergebnis übernehmen.

## 3. Zentrale Befehle und Workflows

Alle folgenden Befehle werden vom Repository-Stamm ausgeführt.

### Projekt öffnen

```bash
open Ticket_Tamer/Ticket_Tamer.xcodeproj
```

In Xcode Scheme `Ticket_Tamer` und als Destination einen Apple-Vision-Pro-Simulator mit visionOS 26.5 auswählen. Danach:

- Build: `⌘B`
- Ausführen: `⌘R`
- Alle Tests: `⌘U`

### Schemes und verfügbare Simulatoren prüfen

Simulatornamen und IDs können je Rechner abweichen. Vor CLI-Befehlen deshalb prüfen:

```bash
xcodebuild -list -project Ticket_Tamer/Ticket_Tamer.xcodeproj
xcrun simctl list devices available
```

### CLI-Build für den Simulator

```bash
xcodebuild build \
  -project Ticket_Tamer/Ticket_Tamer.xcodeproj \
  -scheme Ticket_Tamer \
  -configuration Debug \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro'
```

Falls mehrere gleichnamige Simulatoren existieren oder die Runtime-Auswahl mehrdeutig ist, bevorzugt eine konkrete UDID verwenden:

```bash
xcodebuild build \
  -project Ticket_Tamer/Ticket_Tamer.xcodeproj \
  -scheme Ticket_Tamer \
  -destination 'platform=visionOS Simulator,id=<SIMULATOR-UDID>'
```

### Komplette Testsuite

```bash
xcodebuild test \
  -project Ticket_Tamer/Ticket_Tamer.xcodeproj \
  -scheme Ticket_Tamer \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro'
```

Auch hier ist `id=<SIMULATOR-UDID>` die robustere Variante. Ein erfolgreicher historischer Testbericht ist kein Ersatz für einen erneuten Lauf nach Änderungen.

### Einzelne Tests oder Suites

Xcode unterstützt das Starten über die Test-Navigator-Schaltflächen. Per CLI lässt sich das Test-Target einschränken:

```bash
xcodebuild test \
  -project Ticket_Tamer/Ticket_Tamer.xcodeproj \
  -scheme Ticket_Tamer \
  -destination 'platform=visionOS Simulator,id=<SIMULATOR-UDID>' \
  -only-testing:Ticket_TamerTests
```

Für feingranulare `-only-testing`-Selektoren zuerst die tatsächlich von Xcode erkannten Test-Identifier prüfen; Swift-Testing-Namen und parametrisierte Tests entsprechen nicht immer direkt einem XCTest-artigen Methodennamen.

### Release-Build

```bash
xcodebuild build \
  -project Ticket_Tamer/Ticket_Tamer.xcodeproj \
  -scheme Ticket_Tamer \
  -configuration Release \
  -destination 'generic/platform=visionOS Simulator'
```

Für ein echtes Gerät müssen Team/Signing in Xcode gültig sein und eine konkrete visionOS-Geräte-Destination verwendet werden. Gesten, räumliche Ergonomie und Hardwareverhalten zusätzlich auf Apple Vision Pro prüfen; Unit-Tests ersetzen diesen Abnahmeschritt nicht.

### Abhängigkeiten und RealityKit-Inhalte

Es gibt keinen separaten Installationsschritt. Beim Öffnen beziehungsweise Bauen des Xcode-Projekts bindet Xcode das lokale Package `Ticket_Tamer/Packages/RealityKitContent` ein. Änderungen an `.rkassets` am besten über Reality Composer Pro/Xcode vornehmen. Die Build-Ressourcen nicht durch Dateien im Root-Ordner `Monster/` ersetzen, ohne `Package.swift` und `MonsterAssetProvider` bewusst anzupassen.

## 4. Coding-Richtlinien aus dem Bestand

### Swift-Stil und Benennung

- Typen, Views und Enums verwenden `UpperCamelCase`; Funktionen, Variablen und Enum-Cases `lowerCamelCase`.
- Pro fachlichem Haupttyp in der Regel eine gleichnamige Swift-Datei; Extensions dürfen beim verantwortlichen Typ bleiben.
- Views enden auf `View`, zustandslose Fabriken/Konfiguratoren sind häufig `enum`s mit statischen Methoden, Mess-/Geometriewerte meist `struct`s.
- Konstanten nach Verantwortungsbereich in `AppConstants.swift` gruppieren (`LayoutConstants`, `GameplayConstants`, `InteractionConstants`, `PrioritizationConstants`, `TeamAssignmentConstants`, `FeedbackConstants`, `AssetKeys`).
- Fachbegriffe sind teilweise deutsch (`untersuchen`, `wichtig`, `teamZuordnen`), technische API-Namen und Methodennamen überwiegend Englisch. Vorhandenes Vokabular konsistent fortführen, statt Synonyme einzuführen.
- Der Code verwendet vier Leerzeichen, öffnende Klammern am Zeilenende, sprechende Namen und `// MARK: - ...` zur Gliederung größerer Dateien.
- Öffentliche beziehungsweise nicht offensichtliche Typen, Properties und Algorithmen werden mit `///` dokumentiert. Kommentare erklären Invarianten und Gründe, nicht nur die nächste Codezeile.

### Typisierung, Zustand und Concurrency

- Fachliche Zustände als Enums und Value Types modellieren, nicht als frei interpretierte Strings. Strings sind für stabile externe IDs beziehungsweise sichtbare Daten reserviert.
- `SessionModel` bleibt die einzige Sitzungszustandsquelle. Keine lokalen `@State`-Spiegel für fachliche Modelwerte und keine zweite Session-Instanz im produktiven View-Baum anlegen.
- Modelzustand von außen nur lesen; Mutationen über Methoden mit validierten Vorbedingungen. Ungültige Phasenaufrufe sind defensiv als No-Op implementiert.
- UI-, Audio- und RealityKit-nahe veränderliche Typen explizit mit `@MainActor` kennzeichnen, sofern nicht bereits eindeutig isoliert. Das App-Target verwendet außerdem Default MainActor Isolation.
- Asynchrone Asset-Ladevorgänge mit `Task` und `async/await` umsetzen. Vor verzögerten Zustandswechseln Phase und Exactly-once-Zustand erneut prüfen.
- Optionals sicher mit `guard`/`if let` behandeln. Force-Unwrapping nur, wenn eine unmittelbar zuvor bewiesene Invariante es rechtfertigt; neue Force-Unwraps möglichst vermeiden.
- Änderbare Properties nach Möglichkeit `private(set)` oder `private` halten. Kleine Testnähte als injizierte Closures bevorzugen, etwa die Shuffle-Funktion in `SessionModel`.

### SwiftUI und RealityKit

- Views beziehen `SessionModel` über `@Environment(SessionModel.self)`; Preview-Code injiziert eine eigene Preview-Instanz.
- View-lokale Render-/Interaktionsobjekte liegen in `@State`; fachlicher Zustand gehört ins Model.
- 3D-Interaktion nutzt `RealityView`, `GeometryReader3D`, RealityKit-Entities und gezielte Entity-Gesten (`targetedToAnyEntity`). Keine screen-space-basierten Drag-Hacks einführen.
- Koordinatenräume bei jeder Geometrieberechnung explizit beachten. Gemessene Scene-/Entity-Bounds und Transformationen verwenden; angeforderte Fenstermaße sind nur Fallbacks.
- Sichtbare Zielpanels und deren Drop-Bounds müssen aus derselben Geometrie stammen. Änderungen an Drag-, Panel- oder Monstermaßen immer gegen Clipping, Snapback, 50-%-Overlap und Z-Toleranz testen.
- Wiederverwendbare UI in `Views/Components`, wiederverwendbare Logik in `Services`; umfangreiche Geometrie nicht direkt in View-Closures duplizieren.
- Debug-only-Bedienelemente und Diagnostik mit `#if DEBUG` kapseln. Produktives Routing darf nicht vom Debug-Harness abhängen.

### Logging und Fehlerbehandlung

- Für Diagnostik `DebugManager.log(<Kategorie>, ...)` statt `print` verwenden. Vorhandene Kategorien wie `.lifecycle`, `.state`, `.input`, `.physics`, `.spawning` und `.audio` passend weiterverwenden.
- Fehler bei Assets und Audio dürfen nicht zum Absturz führen: typisierte Ladefehler, sichtbare Fallbacks oder klar geloggte No-Ops verwenden.
- Logs dürfen keine parallele Zustandsmaschine bilden. Die fachliche Entscheidung bleibt im `SessionModel` beziehungsweise in den Geometrie-Services.

### Tests

- Neue Tests mit Swift Testing schreiben: `import Testing`, `@Test("lesbare deutsche Beschreibung")` und `#expect(...)`.
- Tests stehen im Target `Ticket_TamerTests`; Zugriff auf interne App-Symbole erfolgt über `@testable import Ticket_Tamer`.
- Tests nach Feature/Verantwortung in benannten `struct`-Suites und mit `// MARK:` gliedern. Testfunktionsnamen sind beschreibendes Englisch, die angezeigte `@Test`-Beschreibung ist überwiegend Deutsch.
- Main-Actor-isolierte App-Typen in entsprechend `@MainActor` markierten Test-Suites testen.
- Kernlogik ohne laufenden Render-Loop testbar halten: SIMD-Werte, Bounds und Deskriptoren direkt an Services übergeben. Keine SwiftUI-, Audio- oder Simulatorabhängigkeit in reinen Unit-Tests einführen.
- Zufall und Zeit durch deterministische Testnähte kontrollierbar machen. Grenzfälle, ungültige Eingaben, No-Ops und Exactly-once-Semantik explizit prüfen.
- Bei Änderungen an Geometrie oder Gameplay nicht nur neue Tests ausführen, sondern die vollständige Suite und einen Simulator-End-to-End-Lauf von Start bis Reset.

### Änderungen an Projekt und Ressourcen

- Neue App-/Test-Swift-Dateien in den bestehenden synchronisierten Ordnern ablegen; die Xcode-Projektdatei nur ändern, wenn Target-, Buildsetting- oder Package-Metadaten tatsächlich betroffen sind.
- Keine externen Dependencies hinzufügen, solange Standardframeworks oder die bestehende Architektur ausreichen. Jede neue Dependency müsste in diesem Leitfaden und in der Xcode-/Package-Konfiguration nachvollziehbar dokumentiert werden.
- Lokalisierbare UI-Texte in `Localizable.xcstrings` pflegen und Accessibility-Beschriftungen berücksichtigen.
- Produktive Monsterassets gehören in `RealityKitContent`; Audioressourcen in `Ticket_Tamer/Resources`. Dateinamen und `AssetKeys`/Provider-Mappings gemeinsam aktualisieren.
- Vor Abschluss einer Änderung mindestens Diff, Build und relevante Tests prüfen. RealityKit-/Gestenänderungen zusätzlich visuell im visionOS-Simulator und bei abnahmerelevanten Hardwarefragen auf Apple Vision Pro testen.
