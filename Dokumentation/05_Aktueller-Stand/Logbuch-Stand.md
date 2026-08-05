# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `003` — Sitzungsmodell und Zufallsauswahl  
**Eingearbeitet am:** 2026-08-05  
**Aktueller, im Report geprüfter Branch vor Modul 003:** `main`  
**Letzter bestätigter Commit vor Modul 003:** `2775041 feat: add modul 2`  
**Modul-003-Commit:** noch nicht bekannt  
**Build nach Modul 003:** nicht ausgeführt beziehungsweise nicht nachgewiesen  
**Testlauf nach Modul 003:** nicht ausgeführt beziehungsweise nicht nachgewiesen

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine Sitzung mit 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, anhand einer deutschen Ticketkarte untersucht, per Blickfokus, Pinch und Drag priorisiert und anschließend einem Support-Team zugeordnet.

Die Anwendung läuft linear in genau einem zentralen volumetrischen Fenster. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug. Nach einer gültigen Entscheidung erfolgt ausschließlich akustisches Richtig-/Falsch-Feedback; die richtige Lösung wird nicht angezeigt. Am Ende erscheinen nur die Gesamtpunktzahl und „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Feedback-Sounds, ein vollständiger Sitzungsreset und ein stabiler Ablauf ohne Backend, Benutzerkonten, Datenbank, Cloud, persistente Spielhistorie, zweites Fenster beziehungsweise Volume, Immersive Space, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | technisch abgeschlossen; ursprünglicher Commit-/Merge-Nachweis weiter offen | `[COMMIT-HASH EINTRAGEN]` | F-05 strukturell teilweise; AK-05 teilweise |
| 002 | Ticketdatenmodell und lokaler Katalog | implementiert; Commit als letzter Stand vor Modul 003 bestätigt; Build/Test weiterhin nicht separat nachgewiesen | `2775041` | F-02, F-03 implementiert; AK-02/AK-03 testseitig abgedeckt |
| 003 | Sitzungsmodell und Zufallsauswahl | implementiert; lokaler Build- und Testnachweis sowie Commit fehlen | nicht bekannt | F-04 modellseitig implementiert; F-16/AK-16 modellseitig teilweise |
| 004 | Startansicht und Einstellungen | als Nächstes; Beginn nur nach lokalem Build-/Test-Preflight | – | F-01 |
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

Modul 001 stellte das visionOS-Grundgerüst mit genau einer volumetrischen `WindowGroup`, `RootVolumeView`, deutscher Lokalisierungsgrundlage, RealityKit-Standardszene, DebugManager, zentralen Constants und einem Swift-Testing-Smoke-Test bereit. Build, Simulatorstart und 1 von 1 Tests waren für diesen Stand bestätigt. AK-05 bleibt bis zur vollständigen Sitzung und Integration nur strukturell teilweise erfüllt.

## Abschlussstand Modul 002

Modul 002 ergänzte:

- `TicketPriority` mit `.normal`, `.wichtig` und `.kritisch`,
- `SupportTeam` mit `.netzwerk`, `.konto`, `.software` und `.hardware`,
- deutsche Anzeigenamen über `displayName`,
- ein unveränderliches `Ticket`-Modell,
- `LocalTicketCatalog.allTickets` mit genau zwölf statisch definierten Tickets,
- genau eine Ticketkombination je Support-Team und Priorität,
- sechs gemeldete Swift-Testing-Testfälle für Katalog und Fachmodell.

Der Modul-003-Report bestätigt als letzten Commit vor Modul 003 `2775041 feat: add modul 2` auf `main`. Ein mit `xcodebuild` ausgeführter Build- und Testnachweis für Modul 002 lag im verwendeten Sandbox-Umfeld weiterhin nicht vor.

## Eingearbeiteter Stand Modul 003

### Ergebnis laut Modul-Report

Modul 003 hat folgende Bestandteile ergänzt:

- `GamePhase` mit den Fällen `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen` und `.ergebnis`,
- `SessionModel` als `@Observable @MainActor`-Klasse,
- eine zentrale Quelle für den aktuellen Sitzungszustand,
- Ticketanzahl 1 bis 12 mit Standardwert 6,
- defensives Klemmen technisch ungültiger Ticketanzahlen,
- Sitzungsauswahl aus `LocalTicketCatalog.allTickets`,
- zufällige Auswahl ohne Wiederholung,
- deterministisch injizierbare Mischfunktion für Tests,
- sicheren Zugriff auf das aktuelle Ticket,
- Ticketindex mit Klemm-Semantik am Listenende,
- vollständigen Reset der acht gemeldeten Zustandsfelder,
- Logging der Zustandsänderungen mit der vorhandenen Kategorie `state`,
- gemeldete automatisierte Tests ohne UI-, RealityKit- oder Audioabhängigkeiten.

### Zustandsfelder

| Feld | Typ | Start-/Resetwert |
|---|---|---|
| `selectedTicketCount` | `Int` | `GameplayConstants.defaultTicketCount` = 6 |
| `sessionTickets` | `[Ticket]` | `[]` |
| `currentTicketIndex` | `Int` | `0` |
| `currentPhase` | `GamePhase` | `.start` |
| `score` | `Int` | `0` |
| `selectedPriority` | `TicketPriority?` | `nil` |
| `selectedTeam` | `SupportTeam?` | `nil` |
| `isInputLocked` | `Bool` | `false` |

Alle Felder sind laut Report `private(set)` und werden über die bereitgestellten Modellmethoden verändert.

### Auswahl- und Indexsemantik

- Datenquelle ist ausschließlich `LocalTicketCatalog.allTickets`.
- `startSession(using:)` mischt den vollständigen lokalen Katalog und übernimmt ein Präfix der geklemmten Ticketanzahl.
- Da der Katalog eindeutige IDs enthält, entstehen innerhalb einer Sitzung keine Duplikate.
- Der Shuffle-Parameter erlaubt deterministische Tests ohne komplexen Random-Service.
- `advanceToNextTicket()` erhöht den Index nur bis zum letzten gültigen Element.
- Am Listenende gibt es kein Wrap-around und keinen Überlauf.
- Der Übergang zur Ergebnisphase wird nicht durch die Indexmethode vorweggenommen.

### Bewertung der Akzeptanzkriterien

| Kriterium | Stand nach Modul 003 | Begründung |
|---|---|---|
| AK-04: Sitzung enthält genau `n` Tickets | implementiert und testseitig beschrieben; Ausführung offen | Tests für 1, 6 und 12 Tickets sind gemeldet. |
| AK-04: keine Ticket-ID doppelt | strukturell implementiert und testseitig beschrieben; Ausführung offen | Auswahl erfolgt aus einem eindeutigen Katalog ohne Wiederholung. |
| AK-04: Auswahl/Reihenfolge kann variieren | implementiert und deterministisch testbar; Ausführung offen | Die Mischfunktion wird bei jedem Sitzungsstart erneut ausgeführt. |
| AK-16: Reset auf Startansicht | UI-Anteil offen | `currentPhase` wird auf `.start` gesetzt; die sichtbare Startansicht folgt in Modul 004/011. |
| AK-16: Ticketwert wieder 6 | Modellanteil implementiert; sichtbarer Regler offen | `selectedTicketCount` wird auf 6 gesetzt. |
| AK-16: Zustand vollständig verworfen | Modellanteil implementiert; Ausführung offen | Acht Zustandsfelder werden zurückgesetzt. |
| AK-16: fünf Neustarts stabil | testseitig beschrieben; Ausführung offen | Ein Test für fünf aufeinanderfolgende Resets ist gemeldet. |

F-04 und AK-04 gelten damit als modellseitig implementiert, jedoch noch nicht durch einen ausgeführten lokalen Build-/Testlauf verifiziert. F-16 und AK-16 sind nur auf Modellebene teilweise umgesetzt.

## Wichtige Report-Inkonsistenz

Der Report nennt an mehreren Stellen **zwölf neue Tests** und erwartet insgesamt **19 Tests**: sieben aus den Modulen 001/002 plus zwölf aus Modul 003.

In der detaillierten Testliste stehen jedoch **15 unterschiedliche neue Testnamen**:

1. `defaultTicketCountIsSix`
2. `validBoundaryValuesAreAccepted`
3. `invalidTicketCountsAreClamped`
4. `sessionWithOneTicketContainsExactlyOneTicket`
5. `sessionWithSixTicketsContainsExactlySixTickets`
6. `sessionWithTwelveTicketsContainsExactlyTwelveTickets`
7. `sessionTicketIdsAreUnique`
8. `sessionTicketsComeFromLocalCatalog`
9. `newSessionsReExecuteShuffleFunction`
10. `deterministicShuffleFunctionProducesDifferentSelections`
11. `ticketIndexStartsAtZeroAfterSessionStart`
12. `currentTicketIsAccessibleAndSafe`
13. `indexAdvancementClampsAtEndOfList`
14. `resetRestoresAllModelFields`
15. `fiveConsecutiveResetsRemainStable`

Daraus ergäbe sich rechnerisch ein erwarteter Gesamtbestand von 22 Tests, sofern alle 15 tatsächlich als einzelne Tests implementiert sind. Das Projektlogbuch entscheidet diese Abweichung nicht selbst. Modul 004 muss vor Änderungen den tatsächlichen Testbestand in Xcode ermitteln und im Report dokumentieren.

## Schnittstellen-Register

| Bereitgestellt von | Typ / Methode | Datei | Zweck |
|---|---|---|---|
| 001 | `Ticket_TamerApp` | `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg mit genau einer volumetrischen Scene |
| 001 | `RootVolumeView` | `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | Root-Oberfläche im zentralen Volume |
| 001 | `DebugManager` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung |
| 001 | `DebugManager.Category` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| 001 | `DebugManager.log(_:_:function:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisierte Debug-Ausgabe |
| 001 | `DebugManager.toggle(_:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Umschalten einer Debug-Kategorie |
| 001 | `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout- und Volume-Maße |
| 001 | `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Ticketanzahl-Grenzen und Standardwert |
| 001 | `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Schlüssel vorhandener lokaler Ressourcen |
| 002 | `TicketPriority` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | fachliche Priorität |
| 002 | `TicketPriority.displayName: String` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutsche Prioritätsbezeichnung |
| 002 | `SupportTeam` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | fachliches Zielteam |
| 002 | `SupportTeam.displayName: String` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutsche Teambezeichnung |
| 002 | `Ticket` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | unveränderliches Ticketmodell |
| 002 | `LocalTicketCatalog.allTickets: [Ticket]` | `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | vollständiger statischer Ticketpool |
| 003 | `GamePhase` | `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | fünf grundlegende Spielphasen |
| 003 | `SessionModel` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | zentrale, beobachtbare Quelle des Sitzungszustands |
| 003 | `SessionModel.selectedTicketCount: Int` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | aktuell gewählte Ticketanzahl |
| 003 | `SessionModel.setTicketCount(_:)` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | setzt und klemmt die Ticketanzahl |
| 003 | `SessionModel.startSession(using:)` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | startet eine Sitzung mit testbarer Zufallsauswahl |
| 003 | `SessionModel.sessionTickets: [Ticket]` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | ausgewählte Tickets der aktiven Sitzung |
| 003 | `SessionModel.currentTicket: Ticket?` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | sicherer Zugriff auf das aktuelle Ticket |
| 003 | `SessionModel.currentTicketIndex: Int` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | aktueller Index |
| 003 | `SessionModel.advanceToNextTicket()` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | sichere Indexfortschaltung mit Klemm-Semantik |
| 003 | `SessionModel.currentPhase: GamePhase` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | aktuelle Spielphase |
| 003 | `SessionModel.score: Int` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | interner Punktestand für spätere Module |
| 003 | `SessionModel.selectedPriority: TicketPriority?` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | gespeicherte Prioritätsentscheidung für spätere Module |
| 003 | `SessionModel.selectedTeam: SupportTeam?` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | gespeicherte Teamentscheidung für spätere Module |
| 003 | `SessionModel.isInputLocked: Bool` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | Eingabesperre für spätere Module |
| 003 | `SessionModel.reset()` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | vollständiger Modellreset |

## DebugManager

- Modul 003 ergänzte keine neue Kategorie.
- Die vorhandene Kategorie `state` wird verwendet.
- Gemeldete Logging-Stellen:
  - geklemmter Wert in `setTicketCount(_:)`,
  - ausgewählte Ticketanzahl und Startphase in `startSession(using:)`,
  - neuer beziehungsweise geklemmter Index in `advanceToNextTicket()`,
  - vollständiger Reset in `reset()`.
- Vollständige Tickettexte werden nicht protokolliert.
- Laut Report ist standardmäßig nur `.lifecycle` aktiviert; `state` muss für Laufzeitprüfung ausdrücklich eingeschaltet werden.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Die Dokumentationsstruktur unter `Dokumentation/00_Projektsteuerung/` bis `Dokumentation/05_Aktueller-Stand/` ist verbindlich. | Eingangsprompts, Reports und aktuelle Stände sollen eindeutig auffindbar sein. |
| 2026-07-15 | `Logbuch-Stand.md` und `Projekt-Stand.md` werden jeweils als eine aktuelle Datei ersetzt. | Historie gehört in Git, nicht in parallele Standkopien. |
| 2026-07-15 | Das Projekt verwendet genau eine volumetrische `WindowGroup`. | Grundlage für F-05 ohne zweites Volume oder Immersive Space. |
| 2026-07-15 | `BalancingConstants` wird erst bei fachlichem Bedarf angelegt. | Künstliche leere Strukturen werden vermieden. |
| 2026-08-05 | Modul 002 wird dem Commit `2775041 feat: add modul 2` zugeordnet. | Der Modul-003-Preflight nennt diesen als letzten Commit auf `main` vor Modul 003. |
| 2026-08-05 | `SessionModel` ist die einzige Quelle der Wahrheit für den aktuellen Sitzungszustand. | Die SPEC verlangt einen zentralen Zustand; konkurrierende Modelle sollen vermieden werden. |
| 2026-08-05 | `SessionModel` ist `@Observable @MainActor`; Zustandsfelder sind `private(set)`. | SwiftUI-Beobachtbarkeit, klare Actor-Isolation und kontrollierte Mutationen für Folgemodule. |
| 2026-08-05 | Zufallsauswahl wird über eine kleine injizierbare Mischfunktion testbar gemacht. | Deterministische Tests ohne Random-Service oder unnötige DI-Architektur. |
| 2026-08-05 | Der Ticketindex klemmt am letzten gültigen Ticket und läuft nicht über beziehungsweise zurück. | Einfache, sichere Semantik; Ergebniswechsel bleibt einem späteren Modul vorbehalten. |
| 2026-08-05 | AK-04 gilt vorerst nur als modellseitig implementiert, nicht als ausgeführt verifiziert. | Im Report fehlt ein lokaler `xcodebuild`-/Xcode-Testnachweis. |
| 2026-08-05 | AK-16 bleibt teilweise offen. | Modellreset existiert, sichtbare Startansicht und „Erneut spielen“ folgen in Modulen 004 und 011. |
| 2026-08-05 | Die gemeldete Testanzahl wird nicht aus der widersprüchlichen Reportdarstellung abgeleitet. | Der Report nennt zwölf neue Tests, listet aber 15 Testnamen. Der reale Bestand muss lokal ermittelt werden. |
| 2026-08-05 | `monsterAssetId` wird nicht nachträglich in Modul 003 ergänzt. | Das Feld fehlt weiterhin gegenüber der SPEC-Architekturskizze; eine bewusste Entscheidung ist spätestens vor Modul 005 nötig. |

## Offene Punkte / Risiken

### Vor Beginn von Modul 004

- [ ] Aktuellen Branch und Commit prüfen.
- [ ] App-Target lokal mit Xcode bauen.
- [ ] Gesamte Test-Suite lokal ausführen.
- [ ] Tatsächliche Zahl der Tests und Test-Suites ermitteln.
- [ ] Diskrepanz „12 neue Tests“ versus 15 aufgelistete Testnamen auflösen.
- [ ] Bestätigen, dass `SessionModel.startSession(using:)` die erwartete erste Sitzungsphase setzt.
- [ ] Modul-003-Commit und Hash dokumentieren.

### Projektweite offene Punkte

- [ ] Die drei gemeldeten `.DS_Store`-Dateien aus Git entfernen und dauerhaft über `.gitignore` ausschließen; nicht stillschweigend innerhalb eines fachlichen Moduls erledigen.
- [ ] Entscheidung zu `monsterAssetId` spätestens vor Modul 005 treffen und dokumentieren.
- [ ] Tickettexte mit Umschreibungen wie `ae`, `oe` und `ue` vor sichtbarer Verwendung auf echte deutsche Umlaute prüfen.
- [ ] Namen, Stil, Polygonbudget und Exportparameter der vier Monster festlegen.
- [ ] Erfolgssound, Fehlersound, Rechte und Lautstärke festlegen.
- [ ] Zugriff und Zeitfenster für echte Apple-Vision-Pro-Tests sichern.
- [ ] Entscheidung über F-17 erst nach Absicherung aller Muss-Funktionen treffen.
- [ ] Vollständige AK-05- und AK-16-Abnahme erst in Modul 013 durchführen.

### Konfliktanfällige Dateien

- `Ticket_Tamer/Ticket_Tamer.xcodeproj/project.pbxproj`
- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

## Chronik

### Modul 001 — Projektgrundgerüst und zentrales Volume

Das visionOS-Grundgerüst wurde mit genau einer volumetrischen Scene, deutscher Grundansicht, RealityKit-Standardszene, DebugManager, Constants und einem Smoke-Test aufgebaut. Build und Simulatorstart waren erfolgreich. AK-05 blieb strukturell teilweise erfüllt.

### Modul 002 — Ticketdatenmodell und lokaler Katalog

Das Projekt erhielt fachliche Prioritäts- und Team-Enums, ein vollständiges Ticketmodell sowie genau zwölf lokale Tickets mit vollständiger 4×3-Verteilung. Der letzte Commit vor Modul 003 wurde als `2775041 feat: add modul 2` auf `main` bestätigt. Ein ausgeführter Build-/Testnachweis für diesen Stand war im Sandbox-Umfeld nicht verfügbar.

### Modul 003 — Sitzungsmodell und Zufallsauswahl

`GamePhase` und das zentrale `SessionModel` wurden ergänzt. Das Modell verwaltet Ticketanzahl, zufällige Sitzungsauswahl ohne Wiederholung, aktuellen Index, sicheren Ticketzugriff und vollständigen Reset aller gemeldeten Zustandsfelder. Die Implementierung hält die Modulgrenze ein und enthält keine UI-, RealityKit-, Audio- oder Bewertungslogik.

Build und Tests wurden im Modul-Chat nicht ausgeführt, weil `xcodebuild` und `swiftc` im dortigen Sandbox-Umfeld nicht verfügbar waren. Zusätzlich ist die Zahl der gemeldeten neuen Tests widersprüchlich und muss vor Modul 004 lokal geprüft werden.

## Nächster Schritt

`004-Eingangsprompt.md` in einen neuen Modul-Chat geben. Modul 004 darf ausschließlich die deutsche Startansicht mit Projekttitel, ganzzahligem Regler von 1 bis 12, sichtbarem Standardwert 6 und der Schaltfläche „Spiel starten“ umsetzen sowie diese UI minimal an das vorhandene `SessionModel` anbinden. Ticketkarte, Untersuchungsphase, Monster, räumliche Interaktion, Bewertung und Ergebnisansicht bleiben ausgeschlossen.
