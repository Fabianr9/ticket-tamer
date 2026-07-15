# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und im Projektraum ersetzt. Historie liegt in Git, nicht in zusätzlichen Standdateien.

**Stand:** vor Modul `001` — Initialzustand  
**Git-Commit:** nicht dokumentiert  
**Datum:** 2026-07-15

## Verlässlichkeit dieses Stands

Dieser Initialstand basiert ausschließlich auf dem beschriebenen Ausgangszustand im Projektlogbuch-Start-Prompt und auf den bereitgestellten Dateien. Das Xcode-Projekt selbst wurde in diesem Projektlogbuch nicht geöffnet. Exakte Projektdateinamen, Gruppen, physische Ordner, Build Settings und Target-Mitgliedschaften sind deshalb in Modul 001 zu prüfen.

## Dateibaum — bestätigter beziehungsweise beschriebener Ist-Zustand

```text
009 Projektumsetzung/
└─ Code/
   └─ Ticket Tamer/                      # vorhandenes visionOS-Default-Projekt
      ├─ Ticket_TamerApp.swift           # laut Start-Prompt vorhandene App-Datei
      ├─ [ContentView-Typ]               # von Ticket_TamerApp.swift referenziert; Dateipfad nicht bestätigt
      ├─ RealityKitContent/               # vorhandenes Reality-Composer-Pro-Package
      └─ [Swift-Testing-Target]           # vorhanden; Name und Dateien nicht bestätigt

Bereitgestellte Vorlage außerhalb des bestätigten App-Codes:
└─ DebugManager.swift                    # noch nicht in das Xcode-Projekt integriert
```

## Dateien und Bestandteile

| Datei oder Bestandteil | Zweck | Status | Seit Modul |
|---|---|---|---|
| `Ticket_TamerApp.swift` | App-Einstieg; laut Ausgangsbeschreibung aktuell mit `WindowGroup { ContentView() }` | vorhanden laut Start-Prompt, in Modul 001 zu prüfen | Ausgangsprojekt |
| `ContentView` | aktuell vom App-Einstieg referenzierter SwiftUI-Typ | Typreferenz bestätigt, genauer Dateipfad nicht bestätigt | Ausgangsprojekt |
| `RealityKitContent/` | vorhandenes Package für Reality Composer Pro beziehungsweise RealityKit-Inhalte | vorhanden laut Start-Prompt, Struktur in Modul 001 zu prüfen | Ausgangsprojekt |
| Swift-Testing-Target | Ziel für Tests der Kernlogik | vorhanden laut Start-Prompt, Name und Inhalt in Modul 001 zu prüfen | Ausgangsprojekt |
| bereitgestelltes `DebugManager.swift` | zentrale, kategorisierte Debug-Steuerung und optionales Debug-Panel | Vorlage vorhanden, noch kein bestätigter Bestandteil des App-Targets | vor 001 |

## Öffentliche Schnittstellen für Folgemodule

Noch keine öffentlichen Projektschnittstellen aus einem abgeschlossenen Modul bestätigt.

| Typ oder Methode | Datei | Zweck | Status |
|---|---|---|---|
| – | – | – | Vor Modul 001 leer |

## Bekannte Schnittstelle der externen Debug-Vorlage

Die folgenden Namen stammen aus der bereitgestellten Vorlage, gelten aber erst nach kontrollierter Integration und erfolgreichem Build als Projektschnittstellen:

| Typ oder Methode | Vorgesehener Ort | Zweck |
|---|---|---|
| `DebugManager` | `Debug/DebugManager.swift` | zentrale Debug-Steuerung |
| `DebugManager.Category` | `Debug/DebugManager.swift` | Kategorien für Lifecycle, Eingabe, Physik, Spawning, Zustand und Audio |
| `DebugManager.log(_:_:)` | `Debug/DebugManager.swift` | kategorisierte Log-Ausgabe |
| `DebugManager.toggle(_:)` | `Debug/DebugManager.swift` | Laufzeit-Umschaltung einer Kategorie |
| `DebugPanel` | `Debug/DebugManager.swift` oder nach Prüfung getrennte Debug-Datei | optionales SwiftUI-Bedienfeld; nicht Teil des Nutzer-Kernablaufs |

## Zentrale Konstanten-Enums

Noch keine Konstanten-Dateien im Xcode-Projekt bestätigt.

| Enum | Datei | Inhalt | Status |
|---|---|---|---|
| `LayoutConstants` | in Modul 001 festzulegen | Maße und Layoutwerte, die Modul 001 tatsächlich benötigt | noch nicht vorhanden bestätigt |
| `GameplayConstants` | in Modul 001 festzulegen | zentrale Spielwerte; nur bereits verbindlich bekannte Werte verwenden | noch nicht vorhanden bestätigt |
| `BalancingConstants` | in Modul 001 festzulegen | zeitliche und bewertungsbezogene Werte; keine vorgezogene Implementierung späterer Module | noch nicht vorhanden bestätigt |
| `AssetKeys` | in Modul 001 festzulegen | zentrale Schlüssel für Ressourcen, soweit in Modul 001 benötigt | noch nicht vorhanden bestätigt |

## In Modul 001 zu prüfen und einzurichten

- tatsächliche Lage und Inhalte aller vorhandenen Swift-Dateien,
- physische Ordner im Dateisystem und Xcode-Gruppen,
- App-Target und Swift-Testing-Target einschließlich Target-Mitgliedschaften,
- aktuelle Scene-Konfiguration,
- Umstellung auf genau ein zentrales Volume ohne zweiten Volume und ohne Immersive Space,
- einfache Trennung von SwiftUI-, RealityKit- und visionOS-spezifischen Verantwortungsbereichen,
- kontrollierte Verschiebung bestehender Dateien ohne doppelte Referenzen,
- Integration der DebugManager-Vorlage in einen passenden Debug-Bereich,
- minimale Constants-Foundation ohne unnötige Vorwegnahme späterer Module,
- String-Catalog-/Lokalisierungsgrundlage mit sichtbaren deutschen Texten,
- Build des App-Targets und des bestehenden Swift-Testing-Targets,
- Struktur, die drei Entwickler verstehen und mit möglichst wenigen Konflikten bearbeiten können.

## Nicht als vorhanden bestätigt

- ein eingerichtetes zentrales Volume,
- eine endgültige App-/Views-/Models-/Services-/Entities-Ordnerstruktur,
- ein SessionModel oder GameState,
- Ticketdaten oder lokaler Ticketkatalog,
- Monster-Assets im App-Bundle,
- Interaktions-, Punkte- oder Audioimplementierung,
- Ergebnisansicht und Reset-UI,
- integrierte Constants-Dateien,
- integrierter DebugManager.

## Nicht mehr vorhanden oder bewusst entfernt

Noch keine Dateien entfernt oder umbenannt. Änderungen dürfen erst nach der Bestandsanalyse in Modul 001 dokumentiert werden.
