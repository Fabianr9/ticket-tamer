# Ticket Tamer

Ticket Tamer ist eine native visionOS-App für Apple Vision Pro, entwickelt mit SwiftUI und RealityKit. In einem volumetrischen Fenster untersucht man Support-Tickets und ordnet ihnen durch das Verschieben eines 3D-Monsters eine Priorität und ein zuständiges Support-Team zu. Die App arbeitet mit lokalen Daten und Assets.

**GitHub-Repository:** [Fabianr9/ticket-tamer](https://github.com/Fabianr9/ticket-tamer)

## Projektstruktur

```text
ticket-tamer/
├── README.md                          # Einstieg und Wegweiser durch das Projekt
├── Dokumentation/                     # Anforderungen, Planung und Entwicklungsberichte
│   ├── 00_Projektsteuerung/           # Organisation und Strukturplanung
│   ├── 01_Kontext/                    # Projektbeschreibung, SPEC und Akzeptanzkriterien
│   │   ├── v1.0/                     # Frühere Fassung
│   │   └── v1.1/                     # Überarbeitete Fassung
│   ├── 02_Vorlagen/                   # Report-Vorlage und DebugManager-Vorlage
│   ├── 03_Modul-Eingangsprompts/       # Aufgabenstellungen für einzelne Module
│   ├── 04_Modul-Reports/              # Umsetzung und Prüfergebnisse der Module
│   └── 05_Aktueller-Stand/            # Dokumentierter Projekt- und Logbuchstand
├── Monster/                           # Zusätzliche 3D-Monster und Farbvarianten (.usdc)
└── Ticket_Tamer/
    ├── Ticket_Tamer.xcodeproj/         # Xcode-Projekt mit Build- und Target-Einstellungen
    ├── Ticket_Tamer/                  # Quellcode und Ressourcen der App
    │   ├── App/                       # App-Einstieg und volumetrisches Fenster
    │   ├── Assets/                    # Laden und Aufbereiten der Monster
    │   ├── Assets.xcassets/            # App-Icon und Akzentfarbe
    │   ├── Components/                # Eigene RealityKit-Komponenten
    │   ├── Data/                      # Lokaler Ticketkatalog
    │   ├── Debug/                     # Logging und Debug-Panel
    │   ├── Models/                    # Tickets, Spielphasen und Sitzungszustand
    │   ├── Resources/                 # UI-Texte und Feedback-Sounds
    │   ├── Services/                  # Drag/Drop, Geometrie, Zielpanels und Audio
    │   ├── Support/                   # Zentrale Konstanten und Erweiterungen
    │   ├── Views/                     # Ansichten der einzelnen Spielphasen
    │   │   ├── Components/            # Wiederverwendbare UI-Bausteine
    │   │   └── Debug/                 # Testansicht für 3D-Interaktionen
    │   └── Info.plist                 # App-Konfiguration
    ├── Ticket_TamerTests/             # Tests mit Swift Testing
    └── Packages/RealityKitContent/    # Lokales Swift-Package mit 3D-Ressourcen
```

Die doppelte Benennung ist beabsichtigt: Der äußere Ordner `Ticket_Tamer/` enthält das Xcode-Projekt, Tests und Packages. Im inneren Ordner `Ticket_Tamer/Ticket_Tamer/` liegt der eigentliche App-Code.

## Wo finde ich was?

| Thema | Datei oder Ordner | Inhalt |
| --- | --- | --- |
| App-Einstieg | [Ticket_TamerApp.swift](Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift) | Erstellt den Sitzungszustand und das volumetrische Fenster. |
| Wechsel zwischen Ansichten | [RootVolumeView.swift](Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift) | Zeigt abhängig von der aktuellen Spielphase die passende Ansicht. |
| Spielablauf und Punkte | [SessionModel.swift](Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift) | Verwaltet Sitzung, Entscheidungen, Bewertung, Eingabesperre und Neustart. |
| Spielphasen | [GamePhase.swift](Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift) | Definiert die Phasen des Spiels. |
| Ticket-Datenmodell | [Ticket.swift](Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift) | Definiert Tickets, Prioritäten und Support-Teams. |
| Ticketinhalte | [LocalTicketCatalog.swift](Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift) | Enthält die zwölf lokalen Tickets mit ihren Zuordnungen. |
| Maße und Einstellungen | [AppConstants.swift](Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift) | Bündelt Layout-, Gameplay-, Interaktions-, Feedback- und Assetkonstanten. |
| Monster laden | [MonsterAssetProvider.swift](Ticket_Tamer/Ticket_Tamer/Assets/MonsterAssetProvider.swift) | Lädt Monster und passt Ausrichtung, Zentrierung und Größe an. |
| Texte und Übersetzungen | [Localizable.xcstrings](Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings) | String Catalog für UI- und Accessibility-Texte. |
| Sounds | [Resources/](Ticket_Tamer/Ticket_Tamer/Resources/) und [AudioService.swift](Ticket_Tamer/Ticket_Tamer/Services/AudioService.swift) | `correct.wav`, `incorrect.wav` und deren Wiedergabe. |
| App-Icon und Farben | [Assets.xcassets/](Ticket_Tamer/Ticket_Tamer/Assets.xcassets/) | Visuelle App-Ressourcen. |
| Debug-Ausgaben | [DebugManager.swift](Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift) | Kategorien für Logging und Debug-Bedienelemente. |
| Tests | [Ticket_TamerTests.swift](Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift) | Tests unter anderem für Sitzungsablauf, Bewertung und räumliche Geometrie. |
| Build-Einstellungen | [project.pbxproj](Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj) | Targets, Plattformversion und Package-Einbindung; vorzugsweise über Xcode bearbeiten. |

## Ansichten und Spielablauf

```text
Start → Ticket untersuchen → Priorität zuweisen → Team zuweisen
                ↑                                      │
                └──────── nächstes Ticket ──────────────┘
                                                       │ letztes Ticket
                                                       ↓
                                                    Ergebnis → Neustart
```

| Ansicht | Zuständige Datei |
| --- | --- |
| Ticketanzahl auswählen und Spiel starten | [StartView.swift](Ticket_Tamer/Ticket_Tamer/Views/StartView.swift) |
| Ticket und Monster untersuchen | [InvestigationView.swift](Ticket_Tamer/Ticket_Tamer/Views/InvestigationView.swift) |
| Priorität per Drag-and-drop zuweisen | [PrioritizationView.swift](Ticket_Tamer/Ticket_Tamer/Views/PrioritizationView.swift) |
| Support-Team per Drag-and-drop zuweisen | [TeamAssignmentView.swift](Ticket_Tamer/Ticket_Tamer/Views/TeamAssignmentView.swift) |
| Gesamtpunktzahl und Neustart | [ResultView.swift](Ticket_Tamer/Ticket_Tamer/Views/ResultView.swift) |
| Wiederverwendbare Ticketkarte | [TicketCardView.swift](Ticket_Tamer/Ticket_Tamer/Views/Components/TicketCardView.swift) |
| Skalierender UI-Container | [ScaledToFitView.swift](Ticket_Tamer/Ticket_Tamer/Views/Components/ScaledToFitView.swift) |

`SessionModel` hält den zentralen Spielzustand. `RootVolumeView` wählt anhand dieses Zustands die Ansicht aus. Die Views greifen über die SwiftUI-Environment auf dasselbe Model zu.

## Drag-and-drop und räumliches Layout

Die zugehörigen Hilfsdateien liegen unter [Services/](Ticket_Tamer/Ticket_Tamer/Services/):

| Datei | Aufgabe |
| --- | --- |
| [PlanarDrag.swift](Ticket_Tamer/Ticket_Tamer/Services/PlanarDrag.swift) | Überträgt Drag-Gesten auf die Bewegungsebene. |
| [DragBounds.swift](Ticket_Tamer/Ticket_Tamer/Services/DragBounds.swift) | Begrenzt den erlaubten Bewegungsbereich. |
| [MonsterDragGeometry.swift](Ticket_Tamer/Ticket_Tamer/Services/MonsterDragGeometry.swift) | Berechnet die räumliche Geometrie für das ziehbare Monster. |
| [VolumeMetrics.swift](Ticket_Tamer/Ticket_Tamer/Services/VolumeMetrics.swift) | Bereitet gemessene Maße des Volumes auf. |
| [DropEvaluator.swift](Ticket_Tamer/Ticket_Tamer/Services/DropEvaluator.swift) | Prüft, ob das Monster ausreichend mit einem Ziel überlappt. |
| [TargetPanelLayout.swift](Ticket_Tamer/Ticket_Tamer/Services/TargetPanelLayout.swift) | Berechnet Anordnung und Größe der Zielpanels. |
| [TargetPanelFactory.swift](Ticket_Tamer/Ticket_Tamer/Services/TargetPanelFactory.swift) | Erstellt die Zielpanels und ihre Drop-Bereiche. |
| [MonsterInteractionConfigurator.swift](Ticket_Tamer/Ticket_Tamer/Services/MonsterInteractionConfigurator.swift) | Konfiguriert Kollisions- und Eingabekomponenten. |
| [InvestigationFraming.swift](Ticket_Tamer/Ticket_Tamer/Services/InvestigationFraming.swift) | Passt das dargestellte Monster in den Untersuchungsbereich ein. |

Ergänzend enthalten [DropTargetComponent.swift](Ticket_Tamer/Ticket_Tamer/Components/DropTargetComponent.swift) die RealityKit-Komponente für Drop-Ziele und [Entity+DragState.swift](Ticket_Tamer/Ticket_Tamer/Support/Entity+DragState.swift) Hilfen für den Drag-Zustand. Die separate [DebugInteractionHarnessView.swift](Ticket_Tamer/Ticket_Tamer/Views/Debug/DebugInteractionHarnessView.swift) dient Entwicklungszwecken und gehört nicht zum normalen Spielablauf.

## 3D-Assets

Die eingebundenen 3D-Ressourcen liegen im Package [RealityKitContent](Ticket_Tamer/Packages/RealityKitContent/). Unter [Sources/RealityKitContent/](Ticket_Tamer/Packages/RealityKitContent/Sources/RealityKitContent/) befinden sich:

- **`RealityKitContent.rkassets/`**: Szenen, Materialien und Monsterdateien für RealityKit beziehungsweise Reality Composer Pro.
- **`MonsterAssets/`**: USDC-Dateien, die als direkt ladbarer Fallback mitgeliefert werden.
- **`RealityKitContent.swift`**: Zugriff auf das Ressourcen-Bundle des Packages.

Die [Package.swift](Ticket_Tamer/Packages/RealityKitContent/Package.swift) legt fest, welche Ressourcen verarbeitet oder kopiert werden. [Package.realitycomposerpro/](Ticket_Tamer/Packages/RealityKitContent/Package.realitycomposerpro/) enthält das Reality-Composer-Pro-Projekt.

Der Ordner [Monster/](Monster/) im Repository-Stamm enthält weitere Monster- und Farbvarianten. Er ist **nicht direkt als Ressourcenquelle der App eingebunden**. Für Änderungen an den verwendeten Monstern sind das Package, der `MonsterAssetProvider` und die Assetkonstanten in `AppConstants.swift` relevant.

## Dokumentation und Anforderungen

| Gesuchte Information | Fundstelle |
| --- | --- |
| Projektidee und Umfang | [Projektbeschreibung v1.1](Dokumentation/01_Kontext/v1.1/Projektbeschreibung.md) |
| Fachliche und technische Vorgaben | [SPEC v1.1](Dokumentation/01_Kontext/v1.1/SPEC.md) |
| Abnahmekriterien | [Akzeptanzkriterien v1.1](Dokumentation/01_Kontext/v1.1/Akzeptanzkriterien.md) |
| Frühere Anforderungen | [Kontext v1.0](Dokumentation/01_Kontext/v1.0/) |
| Organisation und ursprüngliche Strukturplanung | [Projektsteuerung](Dokumentation/00_Projektsteuerung/) |
| Vorlagen für die Entwicklungsdokumentation | [Vorlagen](Dokumentation/02_Vorlagen/) |
| Aufgaben der einzelnen Entwicklungsmodule | [Modul-Eingangsprompts](Dokumentation/03_Modul-Eingangsprompts/) |
| Umsetzung und dokumentierte Prüfungen | [Modul-Reports](Dokumentation/04_Modul-Reports/) |
| Zuletzt dokumentierter Projektstatus | [Projekt-Stand.md](Dokumentation/05_Aktueller-Stand/Projekt-Stand.md) |
| Entwicklungslogbuch | [Logbuch-Stand.md](Dokumentation/05_Aktueller-Stand/Logbuch-Stand.md) |

Eingangsprompts und Reports lassen sich über ihre Modulnummer zuordnen, beispielsweise `008-Eingangsprompt.md` und `008-Report.md`. Historische Strukturvorschläge und Berichte können vom heutigen Code abweichen; die Übersicht dieser README beschreibt die vorhandene Ordnerstruktur.

## Projekt öffnen und ausführen

Das Xcode-Projekt ist mit einem **visionOS Deployment Target von 26.5** konfiguriert und wurde mit Xcode 26.5 erstellt. Das lokale Asset-Package verwendet Swift Tools 6.2. Zum Bauen und Ausführen wird ein Mac mit passendem Xcode und visionOS-SDK beziehungsweise Simulator benötigt.

1. Repository klonen:

   ```bash
   git clone https://github.com/Fabianr9/ticket-tamer.git
   cd ticket-tamer
   ```

2. [Ticket_Tamer.xcodeproj](Ticket_Tamer/Ticket_Tamer.xcodeproj/) in Xcode öffnen:

   ```bash
   open Ticket_Tamer/Ticket_Tamer.xcodeproj
   ```

3. Scheme **Ticket_Tamer** und einen passenden Apple-Vision-Pro-Simulator auswählen.
4. Mit **⌘R** starten, mit **⌘B** bauen oder mit **⌘U** die Tests ausführen.

Das lokale Package `RealityKitContent` ist bereits im Xcode-Projekt eingebunden. Es sind keine externen Package-Abhängigkeiten konfiguriert.
