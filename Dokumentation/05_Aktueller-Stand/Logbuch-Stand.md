# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` ersetzt.

**Stand:** nach Modul `001` — Projektgrundgerüst und zentrales Volume  
**Datum:** 2026-07-15  
**Branch:** `feature/001-project-foundation`  
**Git-Commit:** `[COMMIT-HASH EINTRAGEN]` — noch nicht eingetragen  
**Merge in `main`:** `[JA / NOCH NICHT]` — noch nicht angegeben

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine kurze Sitzung aus 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, zunächst anhand einer deutschen Ticketkarte untersucht, anschließend per Blickfokus, Pinch und Drag einer Priorität und danach einem Support-Team zugeordnet.

Die Anwendung läuft als linearer Ablauf in genau einem zentralen volumetrischen Fenster. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug. Nach einer gültigen Entscheidung erfolgt ausschließlich akustisches Richtig-/Falsch-Feedback; die richtige Lösung wird nicht angezeigt. Am Ende erscheinen nur die Gesamtpunktzahl und „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Feedback-Sounds, ein vollständiger Sitzungsreset und ein stabiler Ablauf ohne Backend, Benutzerkonten, Datenbank, Cloud, persistente Spielhistorie, zweites Fenster beziehungsweise Volume, Immersive Space, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die beiden Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | fertig auf Branch; Merge-Status offen | `[COMMIT-HASH EINTRAGEN]` | F-05 strukturell teilweise; AK-05 teilweise |
| 002 | Ticketdatenmodell und lokaler Katalog | als Nächstes | – | F-02, F-03 |
| 003 | Sitzungsmodell und Zufallsauswahl | offen | – | F-04, F-16 |
| 004 | Startansicht und Einstellungen | offen | – | F-01 |
| 005 | Monster-Asset-Pipeline | offen | – | F-14 |
| 006 | Untersuchungsphase | offen | – | F-06, F-07 |
| 007 | Räumliche Interaktionsgrundlagen | offen | – | F-10 |
| 008 | Priorisierungsphase | offen | – | F-08 |
| 009 | Teamzuordnungsphase | offen | – | F-09 |
| 010 | Bewertung und Audiofeedback | offen | – | F-11, F-12, F-13 |
| 011 | Ergebnis und Neustart | offen | – | F-15, F-16 |
| 012 | Optionale Monsterreaktion | offen, Kann-Modul | – | F-17 |
| 013 | Integration und Gerätetest | offen | – | F-01 bis F-16 als Integrationstest |
| 014 | Abschlussmodul: Doku & Cleanup | offen | – | Dokumentenkonsistenz und Abgabeprüfung |

## Abschlussstand Modul 001

### Ergebnis

Modul 001 ist technisch erfolgreich abgeschlossen. Das vorhandene visionOS-Projekt wurde in ein kleines, buildfähiges Grundgerüst mit genau einem zentralen volumetrischen Fenster überführt. Der App-Einstieg verwendet `RootVolumeView` in einer volumetrischen `WindowGroup`. Ein zweites Fenster, ein zweites Volume und ein Immersive Space sind nicht vorhanden.

### Bestätigte Prüfungen

| Prüfung | Ergebnis |
|---|---|
| Build | erfolgreich |
| visionOS-Simulatorstart | erfolgreich |
| Swift-Testing-Suite | `TicketTamerTests` |
| Tests | 1 von 1 bestanden |
| Testplattform | `arm64-apple-xros1.0-simulator` |
| Zentrales volumetrisches Fenster | genau eines bestätigt |
| Zweites Fenster beziehungsweise Volume | keines |
| Immersive Space | keiner |
| Deutsche Basistexte | korrekt |
| RealityKit-Standardszene | wird angezeigt |
| Wesentliche Abweichungen vom Auftrag | keine |
| Offene technische Probleme aus Modul 001 | keine |

### Abnahmegrenze AK-05

AK-05 ist nach Modul 001 noch nicht vollständig erfüllt.

Erfüllt beziehungsweise bestätigt sind:

- genau ein zentrales volumetrisches Fenster,
- kein zweites Fenster oder Volume,
- kein Immersive Space,
- eine stabile strukturelle Grundlage für den späteren linearen Ablauf.

Noch offen ist die vollständige Zustandsfolge:

`Start → Untersuchen → Priorisieren → Team zuordnen → nächstes Ticket → Ergebnis`

Diese Phasen werden in den Folgemodulen implementiert und in Modul 013 vollständig als Integration geprüft.

## Schnittstellen-Register

| Bereitgestellt von | Typ / Methode | Datei | Zweck |
|---|---|---|---|
| 001 | `Ticket_TamerApp` | `Ticket_Tamer/App/Ticket_TamerApp.swift` | App- und Scene-Einstieg mit genau einer volumetrischen Scene |
| 001 | `RootVolumeView` | `Ticket_Tamer/Views/RootVolumeView.swift` | minimale SwiftUI-Root-Oberfläche im zentralen Volume |
| 001 | `DebugManager` | `Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung |
| 001 | `DebugManager.Category` | `Ticket_Tamer/Debug/DebugManager.swift` | Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| 001 | `DebugManager.log(_:_:function:)` | `Ticket_Tamer/Debug/DebugManager.swift` | kategorisierte Debug-Ausgabe |
| 001 | `DebugManager.toggle(_:)` | `Ticket_Tamer/Debug/DebugManager.swift` | Laufzeit-Umschaltung einer Debug-Kategorie |
| 001 | `DebugPanel` | `Ticket_Tamer/Debug/DebugManager.swift` | optionales Debug-Panel; nicht Teil des regulären Nutzerablaufs |
| 001 | `LayoutConstants` | `Ticket_Tamer/Support/AppConstants.swift` | zentrale Layout- und Volume-Maße |
| 001 | `GameplayConstants` | `Ticket_Tamer/Support/AppConstants.swift` | Ticketanzahl-Grenzen und Standardwert |
| 001 | `AssetKeys` | `Ticket_Tamer/Support/AppConstants.swift` | Schlüssel für vorhandene lokale Ressourcen |

## Zentrale Konstanten

### `LayoutConstants`

- `centralVolumeWidth = 0.8`
- `centralVolumeHeight = 0.6`
- `centralVolumeDepth = 0.4`
- `rootPadding = 32.0`
- `rootSpacing = 24.0`
- `textSpacing = 8.0`
- `modelBottomPadding = 24.0`

### `GameplayConstants`

- `minimumTicketCount = 1`
- `maximumTicketCount = 12`
- `defaultTicketCount = 6`

### `AssetKeys`

- `defaultRealityKitScene = "Scene"`

`BalancingConstants` wurde bewusst noch nicht angelegt, weil Modul 001 keine Bewertungs-, Audio- oder automatische Übergangslogik enthält.

## DebugManager

- Aktive Datei: `Ticket_Tamer/Debug/DebugManager.swift`
- Aktive Kategorien: `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`
- Neue Kategorie in Modul 001: keine
- Logging in Modul 001:
  - App-Einstieg in `Ticket_TamerApp.init()`
  - Anzeigen des zentralen Volumes in `RootVolumeView.onAppear`
- Das optionale `DebugPanel` ist nicht Teil des regulären Nutzerablaufs.
- Gegenüber der Vorlage wurde die Nachricht innerhalb von `DebugManager.log` einmalig aufgelöst, bevor sie an `logger.debug` übergeben wird. Dadurch wurde der Buildfehler zur nicht-escaping Autoclosure behoben, ohne die öffentliche Signatur zu ändern.
- Im Projekt existiert genau eine aktive `DebugManager.swift`.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Die Dokumentationsstruktur unter `Dokumentation/00_Projektsteuerung/` bis `Dokumentation/05_Aktueller-Stand/` ist der aktuelle verbindliche Ablageort. | Die Unterlagen wurden in diese Struktur verschoben und sollen dort eindeutig fortgeführt werden. |
| 2026-07-15 | `Logbuch-Stand.md` und `Projekt-Stand.md` existieren jeweils genau einmal unter `Dokumentation/05_Aktueller-Stand/` und werden nach jedem Modul ersetzt. | Der Projektraum soll nur einen aktuellen Wahrheitsstand enthalten; Historie liegt in Git. |
| 2026-07-15 | Das Projekt verwendet genau eine volumetrische `WindowGroup` als zentrale App-Szene. | Dies erfüllt die technische Grundvoraussetzung für F-05 und vermeidet ein zweites Fenster, zweites Volume oder einen Immersive Space. |
| 2026-07-15 | Die frühere Default-`ContentView` ist nicht mehr Bestandteil des aktiven Projektbaums beziehungsweise App-Einstiegs. | `RootVolumeView` übernimmt die minimale Root-Oberfläche des zentralen Volumes. |
| 2026-07-15 | Die Scene-Rolle in `Info.plist` ist `UIWindowSceneSessionRoleVolumetricApplication`. | Diese Konfiguration ist für den bestätigten volumetrischen Simulatorstart erforderlich. |
| 2026-07-15 | `BalancingConstants` wird erst in einem fachlich passenden Folgemodul angelegt. | Leere oder künstliche Strukturen ohne aktuell benötigte Werte werden vermieden. |
| 2026-07-15 | Modul 002 bearbeitet ausschließlich Ticketdatentypen und den lokalen Katalog. | Sitzungszustand, Zufallsauswahl, Index und Reset gehören verbindlich zu Modul 003. |
| 2026-07-15 | Der Test-Target und die bestehende Suite bleiben Grundlage für weitere Swift-Testing-Tests. | Modul 001 hat einen erfolgreichen Smoke-Test auf `arm64-apple-xros1.0-simulator` bestätigt. |

## Offene Punkte / Risiken

### Unmittelbar zu ergänzen

- [ ] Tatsächlichen Commit-Hash für Modul 001 eintragen.
- [ ] Merge-Status des Branches `feature/001-project-foundation` in `main` eintragen.

### Projektweite offene Punkte

- [ ] Die zwölf konkreten Ticketinhalte in Modul 002 erstellen und fachlich auf eindeutige Priorität und Teamzuordnung prüfen.
- [ ] Namen, Stil, Polygonbudget und Exportparameter der vier Monster festlegen.
- [ ] Erfolgssound, Fehlersound, Rechte und Lautstärke festlegen und später auf Apple Vision Pro prüfen.
- [ ] Zugriff und Zeitfenster für echte Apple-Vision-Pro-Tests sichern.
- [ ] Entscheidung über F-17 erst nach Absicherung aller Muss-Funktionen treffen.
- [ ] Konfliktanfällige Dateien koordiniert bearbeiten: `Ticket_Tamer.xcodeproj/project.pbxproj`, `Ticket_Tamer/App/Ticket_TamerApp.swift` und `Ticket_Tamer/Support/AppConstants.swift`.
- [ ] Vollständige AK-05-Abnahme erst in Modul 013 durchführen.

### Technischer Stand aus Modul 001

Es bestehen keine offenen technischen Probleme aus Modul 001. Die Prüfung auf echter Apple Vision Pro ist weiterhin eine spätere Integrations- und Abnahmeaufgabe, aber kein Fehler des abgeschlossenen Moduls.

## Chronik

### Modul 001 — Projektgrundgerüst und zentrales Volume

Das visionOS-Default-Projekt wurde in ein kleines, buildfähiges Grundgerüst mit genau einem zentralen volumetrischen Fenster überführt. `Ticket_TamerApp` startet `RootVolumeView`; die deutsche Grundansicht zeigt die vorhandene RealityKit-Standardszene. DebugManager, zentrale Layout-/Gameplay-/Asset-Konstanten, String Catalog und ein Swift-Testing-Smoke-Test wurden eingerichtet.

Build und Simulatorstart waren erfolgreich. Die Suite `TicketTamerTests` bestand auf `arm64-apple-xros1.0-simulator` mit 1 von 1 Tests. AK-05 ist strukturell teilweise erfüllt; die vollständige lineare Sitzung bleibt bis zu den Folgemodulen und Modul 013 offen.

## Nächster Schritt

`002-Eingangsprompt.md` in einen neuen Modul-Chat geben. Modul 002 darf ausschließlich das Ticketdatenmodell, die benötigten Enumerationen und genau zwölf lokale Ticketdatensätze umsetzen. Sitzungszustand, Zufallsauswahl, Ticketindex, Punkte, Reset und Views bleiben ausgeschlossen.
