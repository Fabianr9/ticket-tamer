# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `004` — Startansicht und Einstellungen  
**Eingearbeitet am:** 2026-08-09  
**Aktueller Branch laut 004-Report:** `main`  
**Modul-003-Commit:** `dd78700 Feat: addModul3`  
**Commit vor Modul 004:** `f3d4bf3 feat: add doc files`  
**Modul-004-Commit:** `84bb767 004: Startansicht und Einstellungen`  
**Build nach Modul 004:** nicht ausgeführt / nicht nachgewiesen  
**Simulatorstart nach Modul 004:** nicht ausgeführt / nicht nachgewiesen  
**Tests nach Modul 004:** 27 Testdeklarationen laut Codeauszählung, aber kein ausgeführter Testlauf nachgewiesen

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine Sitzung mit 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, anhand einer deutschen Ticketkarte untersucht, per Blickfokus, Pinch und Drag priorisiert und anschließend einem Support-Team zugeordnet.

Die Anwendung läuft linear in genau einem zentralen volumetrischen Fenster. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug. Nach einer gültigen Entscheidung erfolgt ausschließlich akustisches Richtig-/Falsch-Feedback; die richtige Lösung wird nicht angezeigt. Am Ende erscheinen nur die Gesamtpunktzahl und „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Feedback-Sounds, ein vollständiger Sitzungsreset und ein stabiler Ablauf ohne Backend, Benutzerkonten, Datenbank, Cloud, persistente Spielhistorie, zweites Fenster beziehungsweise Volume, Immersive Space, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | technisch abgeschlossen | ursprünglicher Hash im Logbuch nicht abschließend rekonstruiert | F-05 strukturell teilweise; AK-05 teilweise |
| 002 | Ticketdatenmodell und lokaler Katalog | implementiert | `2775041` | F-02, F-03 implementiert; AK-02/AK-03 testseitig abgedeckt |
| 003 | Sitzungsmodell und Zufallsauswahl | implementiert | `dd78700` | F-04 modellseitig implementiert; F-16/AK-16 modellseitig teilweise |
| 004 | Startansicht und Einstellungen | implementiert; Laufzeitabnahme offen | `84bb767` | F-01 implementiert; AK-01 noch lokal zu verifizieren |
| 005 | Monster-Asset-Pipeline | als Nächstes | – | F-14 |
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

Modul 001 stellte das visionOS-Grundgerüst mit genau einer volumetrischen `WindowGroup`, `RootVolumeView`, deutscher Lokalisierungsgrundlage, RealityKit-Standardszene, DebugManager, zentralen Constants und einem Swift-Testing-Smoke-Test bereit. Build, Simulatorstart und 1 von 1 Tests waren für diesen Stand bestätigt. AK-05 bleibt bis zur vollständigen Sitzung und Integration nur strukturell teilweise erfüllt.

## Abschlussstand Modul 002

Modul 002 ergänzte:

- `TicketPriority` mit `.normal`, `.wichtig` und `.kritisch`,
- `SupportTeam` mit `.netzwerk`, `.konto`, `.software` und `.hardware`,
- deutsche Anzeigenamen über `displayName`,
- ein unveränderliches `Ticket`-Modell,
- `LocalTicketCatalog.allTickets` mit genau zwölf statisch definierten Tickets,
- genau eine Ticketkombination je Support-Team und Priorität,
- sechs gemeldete Swift-Testing-Tests für Katalog und Fachmodell.

Der Modul-003-Preflight bestätigte den Modul-002-Stand auf `main` mit Commit `2775041 feat: add modul 2`.

## Abschlussstand Modul 003

Modul 003 ergänzte:

- `GamePhase` mit `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen`, `.ergebnis`,
- `SessionModel` als `@Observable @MainActor`,
- Ticketanzahl 1 bis 12 mit Standardwert 6,
- zufällige Sitzungsauswahl ohne Wiederholung,
- injizierbare Mischfunktion für deterministische Tests,
- sicheren Ticketzugriff und Indexfortschaltung,
- vollständigen Reset der acht Zustandsfelder,
- `state`-Logging für zentrale Modellmutationen.

Der 004-Preflight bestätigt den tatsächlichen Modul-003-Commit als `dd78700 Feat: addModul3`.

Die frühere Testinkonsistenz aus dem 003-Report ist aufgelöst: In `SessionModelTests` existieren tatsächlich 15 Tests, nicht zwölf. Zusammen mit sieben Tests aus Modulen 001 und 002 bestand der Quellstand vor Modul 004 aus 22 Testdeklarationen. Dies war ein Dokumentationsfehler im 003-Report, kein gemeldeter Codefehler.

## Eingearbeiteter Stand Modul 004

### Ergebnis

Modul 004 implementiert die deutsche Startansicht und bindet sie an die zentrale `SessionModel`-Instanz an.

`Ticket_TamerApp` besitzt laut Report genau eine Instanz:

- `@State private var sessionModel = SessionModel()`

Die Weitergabe erfolgt über SwiftUI Environment:

- `.environment(sessionModel)`

Kind-Views greifen über `@Environment(SessionModel.self)` auf dieselbe Instanz zu. Es wurde kein Singleton, kein Dependency-Injection-Container und kein zweites Sitzungsmodell eingeführt.

### Startansicht

`StartView` enthält:

- Projekttitel „Ticket Tamer“,
- Beschriftung „Anzahl Tickets“,
- Regler von 1 bis 12,
- sichtbaren aktuellen Ticketwert,
- Standardwert 6,
- Schaltfläche „Spiel starten“.

Der Regler bindet direkt an `SessionModel.selectedTicketCount` und verwendet `SessionModel.setTicketCount(_:)` zum Setzen. Ein separater lokaler UI-Wahrheitsstand wurde nicht eingeführt.

### Ganzzahligkeit und Grenzen

Der Regler verwendet:

- Minimum: `GameplayConstants.minimumTicketCount`,
- Maximum: `GameplayConstants.maximumTicketCount`,
- Schrittweite: 1,
- Standardwert: `GameplayConstants.defaultTicketCount`.

Technisch ungültige Werte werden weiterhin ausschließlich über die vorhandene Klemm-Semantik des `SessionModel` auf 1 bis 12 begrenzt.

### Startaktion

„Spiel starten“ ruft `SessionModel.startSession()` auf.

Der 004-Report hat die reale Methode aus Modul 003 geprüft. Sie:

1. mischt `LocalTicketCatalog.allTickets`,
2. übernimmt defensiv die ausgewählte Anzahl,
3. setzt `currentTicketIndex = 0`,
4. setzt `currentPhase = .untersuchen`,
5. setzt `score = 0`,
6. setzt `selectedPriority = nil`,
7. setzt `selectedTeam = nil`,
8. setzt `isInputLocked = false`.

Nach dem Start zeigt `RootVolumeView` für alle Phasen außerhalb `.start` weiterhin nur einen neutralen Sitzungsplatzhalter. Eine Untersuchungsphase wurde nicht vorweggenommen.

### Geänderte Dateien

| Datei | Änderung |
|---|---|
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | `SessionModel`-Besitz und Environment-Weitergabe ergänzt |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | phasenabhängige Anzeige ergänzt/ersetzt |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | neu |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | vier neue Schlüssel ergänzt |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | fünf Tests in `StartViewModelTests` ergänzt |

Nicht geändert wurden laut Report:

- `GamePhase.swift`,
- `SessionModel.swift`,
- `AppConstants.swift`,
- `DebugManager.swift`,
- `Ticket.swift`,
- `LocalTicketCatalog.swift`,
- `Info.plist`,
- RealityKitContent,
- `project.pbxproj`.

## Lokalisierungsstand nach Modul 004

Zusätzlich zu bereits vorhandenen Schlüsseln sind bestätigt:

| Schlüssel | Deutscher Wert | Zweck |
|---|---|---|
| `app.title` | `Ticket Tamer` | Projekttitel |
| `start.ticketCount.label` | `Anzahl Tickets` | Reglerbeschriftung |
| `start.ticketCount.accessibility` | `Regler für Ticketanzahl` | Accessibility-Label |
| `start.button.startGame` | `Spiel starten` | Schaltflächentext |
| `root.sessionPlaceholder` | `Sitzung läuft …` | neutraler Platzhalter nach Sitzungsstart |

## Bewertung von F-01 und AK-01

### Implementierungsstand

Die berichtete Implementierung deckt alle drei Teile von AK-01 ab:

- Startansicht enthält Titel, Regler, sichtbaren Wert 6 und „Spiel starten“.
- Der Regler ist auf Ganzzahlschritte 1 bis 12 begrenzt.
- Das Modell klemmt technisch angeforderte Werte auf 1 bis 12.

### Verifikationsstand

AK-01 wird im Projektlogbuch **noch nicht als vollständig ausgeführt abgenommen**.

Begründung:

- Der Report markiert AK-01 zwar mit `[x]`.
- Gleichzeitig sagt er, dass `xcodebuild` nicht verfügbar war.
- Simulatorstart und manuelle Simulatorprüfung werden ausdrücklich als „lokal durchzuführen“ beschrieben.
- Ein tatsächlich ausgeführter Testlauf nach Modul 004 ist nicht dokumentiert.

Daher gilt:

- **F-01: implementiert.**
- **AK-01: code- und testseitig vorbereitet, Laufzeitverifikation offen.**

Diese Einordnung ändert das Kriterium nicht, sondern trennt Implementierung und tatsächlichen Nachweis.

## Teststand

Der 004-Report löst die Testanzahl-Inkonsistenz aus Modul 003 auf:

| Testbereich | Testdeklarationen |
|---|---:|
| `TicketTamerTests` aus 001–002 | 7 |
| `SessionModelTests` aus 003 | 15 |
| Stand vor 004 | 22 |
| `StartViewModelTests` aus 004 | 5 |
| **Quellstand nach 004** | **27** |

Wichtig: **27 ist die Zahl der gemeldeten beziehungsweise ausgezählten Testdeklarationen, nicht ein nachgewiesener erfolgreicher Testlauf.**

## Schnittstellen-Register

| Bereitgestellt von | Typ / Methode | Datei | Zweck |
|---|---|---|---|
| 001 | `Ticket_TamerApp` | `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg mit genau einer volumetrischen Scene |
| 001 | `RootVolumeView` | `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Root-Oberfläche im zentralen Volume |
| 001 | `DebugManager` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale Debug-Steuerung |
| 001 | `DebugManager.Category` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| 001 | `DebugManager.log(_:_:function:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisierte Debug-Ausgabe |
| 001 | `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout- und Volume-Maße |
| 001 | `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Ticketanzahl-Grenzen und Standardwert |
| 001 | `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | vorhandene Asset-Schlüssel |
| 002 | `TicketPriority` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | fachliche Priorität |
| 002 | `TicketPriority.displayName` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutscher Prioritätsname |
| 002 | `SupportTeam` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | fachliches Zielteam |
| 002 | `SupportTeam.displayName` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutscher Teamname |
| 002 | `Ticket` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | Ticketfachmodell |
| 002 | `LocalTicketCatalog.allTickets` | `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | vollständiger lokaler Ticketpool |
| 003 | `GamePhase` | `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf grundlegende Spielphasen |
| 003 | `SessionModel` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentrale beobachtbare Sitzungsquelle |
| 003 | `SessionModel.setTicketCount(_:)` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | Ticketanzahl setzen und klemmen |
| 003 | `SessionModel.startSession(using:)` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | Sitzung starten |
| 003 | `SessionModel.currentTicket` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | aktuelles Ticket |
| 003 | `SessionModel.advanceToNextTicket()` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | sicheren Index fortschalten |
| 003 | `SessionModel.reset()` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | vollständiger Modellreset |
| 004 | zentrale `SessionModel`-Instanz im SwiftUI-Baum | `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | genau ein Sitzungsmodell pro App-Laufzeit |
| 004 | `SessionModel` über SwiftUI Environment | App/Views | Zugriff für Kind-Views mit `@Environment(SessionModel.self)` |
| 004 | `StartView` | `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | Startansicht für F-01/AK-01 |
| 004 | phasenabhängige Root-Anzeige | `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | `.start` zeigt `StartView`, andere Phasen derzeit neutralen Platzhalter |

## DebugManager nach Modul 004

Keine neue Kategorie.

Neue beziehungsweise bestätigte Logging-Stellen:

- `input`: Auslösen von „Spiel starten“ inklusive gewählter Ticketanzahl,
- `lifecycle`: Erscheinen von `StartView`,
- `state`: Anzeigen des neutralen Sitzungsplatzhalters,
- `lifecycle`: bestehendes Logging beim App-Einstieg.

Keine vollständigen Tickettexte werden geloggt.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Dokumentationsstruktur und Single-Stand-Prinzip verbindlich festgelegt. | Historie liegt in Git; im Projektraum bleibt nur der aktuelle Stand. |
| 2026-07-15 | Genau eine volumetrische `WindowGroup` als zentrale Scene. | F-05 ohne zweites Volume oder Immersive Space. |
| 2026-08-05 | `SessionModel` ist einzige Quelle des aktuellen Spielzustands. | Konkurrenzzustände vermeiden. |
| 2026-08-05 | `SessionModel` verwendet `@Observable @MainActor` und `private(set)`. | Beobachtbarkeit und kontrollierte Mutationen. |
| 2026-08-05 | Zufallsauswahl ist über eine kleine Mischfunktion testbar. | Deterministische Tests ohne unnötige Infrastruktur. |
| 2026-08-09 | Testinkonsistenz aus Modul 003 ist als Dokumentationsfehler aufgelöst. | Der 004-Preflight zählt 15 tatsächliche `SessionModelTests`; damit 22 Tests vor Modul 004. |
| 2026-08-09 | `Ticket_TamerApp` besitzt genau eine `SessionModel`-Instanz; Weitergabe über SwiftUI Environment. | Direkte und einfache SwiftUI-Observation-Lösung ohne Singleton oder DI-Container. |
| 2026-08-09 | `RootVolumeView` entscheidet anhand von `currentPhase`, welche Root-Darstellung sichtbar ist. | Folgemodule können Phasenansichten ergänzen, ohne ein zweites Zustandsmodell einzuführen. |
| 2026-08-09 | AK-01 wird trotz `[x]` im 004-Report noch nicht als laufzeitverifiziert geführt. | Build, Simulatorlauf und Testausführung wurden im Report ausdrücklich nicht durchgeführt. |
| 2026-08-09 | Der Empfehlung des 004-Reports, als Modul 005 die Untersuchungsansicht zu bauen, wird nicht gefolgt. | Die verbindliche SPEC-Modul-Landkarte definiert Modul 005 als Monster-Asset-Pipeline und Modul 006 als Untersuchungsphase. Keine Moduländerung ohne bewusste SPEC-Änderung. |
| 2026-08-09 | Die fehlende `monsterAssetId`-Entscheidung wird in Modul 005 verbindlich aufgelöst. | Die SPEC-Architekturskizze enthält `monsterAssetId`; Modul 005 ist der fachlich passende Zeitpunkt für Asset-Zuordnung. |

## Offene Punkte / Risiken

### Vor oder zu Beginn von Modul 005

- [ ] App lokal in Xcode bauen.
- [ ] visionOS-Simulator starten.
- [ ] alle 27 gemeldeten Testdeklarationen ausführen und tatsächliches Ergebnis dokumentieren.
- [ ] AK-01 manuell im Simulator prüfen.
- [ ] bestätigen, dass nach „Spiel starten“ genau die gewählte Ticketanzahl im `SessionModel` liegt.
- [ ] prüfen, ob bereits vier eigene Blender-/USDZ-Monster im Repository oder Arbeitsordner vorhanden sind.
- [ ] Dateiformate, Namen, Größen und tatsächliche Importierbarkeit der Monster erfassen.
- [ ] `monsterAssetId` beziehungsweise eine gleichwertige, SPEC-konforme Zuordnung bewusst entscheiden und dokumentieren.

### Projektweite offene Punkte

- [ ] Drei bekannte `.DS_Store`-Dateien aus Git entfernen und über `.gitignore` ausschließen; nicht stillschweigend als Teil eines fachfremden Moduls erledigen.
- [ ] Tickettexte mit `ae`, `oe`, `ue` vor sichtbarer Verwendung in Modul 006 auf echte deutsche Umlaute prüfen.
- [ ] Erfolgssound, Fehlersound, Rechte und Lautstärke später festlegen.
- [ ] Apple-Vision-Pro-Zeitfenster für Modul 013 sichern.
- [ ] Entscheidung über F-17 erst nach Absicherung der Muss-Funktionen treffen.
- [ ] Vollständige AK-05- und AK-16-Abnahme erst in Modul 013.

## Chronik

### Modul 001 — Projektgrundgerüst und zentrales Volume

Das visionOS-Grundgerüst wurde mit genau einer volumetrischen Scene, deutscher Grundansicht, RealityKit-Standardszene, DebugManager, Constants und Smoke-Test aufgebaut. Build und Simulatorstart waren für diesen Stand erfolgreich.

### Modul 002 — Ticketdatenmodell und lokaler Katalog

Das Projekt erhielt Prioritäts- und Team-Enums, ein Ticketmodell sowie genau zwölf lokale Tickets mit vollständiger 4×3-Verteilung.

### Modul 003 — Sitzungsmodell und Zufallsauswahl

`GamePhase` und `SessionModel` wurden ergänzt. Das Modell verwaltet Ticketanzahl, zufällige Auswahl ohne Wiederholung, aktuellen Index, sicheren Ticketzugriff und vollständigen Reset. Der 004-Preflight bestätigt 15 tatsächliche SessionModel-Tests und den Commit `dd78700`.

### Modul 004 — Startansicht und Einstellungen

Die deutsche Startansicht wurde mit Titel, Ticketregler, sichtbarem Wert und „Spiel starten“ implementiert. `Ticket_TamerApp` besitzt die einzige `SessionModel`-Instanz und stellt sie per Environment bereit. Nach dem Start wechselt das Modell in `.untersuchen`, während `RootVolumeView` bis Modul 006 nur einen neutralen Platzhalter zeigt.

Der Quellstand enthält laut Report nun 27 Testdeklarationen. Ein tatsächlicher Xcode-Build, Simulatorlauf und Testlauf nach Modul 004 wurden jedoch nicht nachgewiesen. F-01 gilt als implementiert; die Laufzeitabnahme von AK-01 bleibt offen.

## Nächster Schritt

`005-Eingangsprompt.md` in einen neuen Modul-Chat geben.

Modul 005 bearbeitet entsprechend der verbindlichen SPEC ausschließlich die Monster-Asset-Pipeline: vier eigene lokale Blender-Monster, RealityKit-kompatible Exporte, lokale Einbindung, robuste Asset-Schlüssel beziehungsweise Ladegrundlage und eine Zuordnung, aus der weder Referenzteam noch Referenzpriorität eindeutig ableitbar sind.

Die Untersuchungsansicht mit Ticketkarte und „Weiter zur Priorisierung“ bleibt ausdrücklich Modul 006.
