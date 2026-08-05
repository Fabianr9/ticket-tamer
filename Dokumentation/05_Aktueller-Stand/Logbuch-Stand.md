# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `002` — Ticketdatenmodell und lokaler Katalog  
**Eingearbeitet am:** 2026-08-05  
**Modul-002-Commit:** nicht nachgewiesen  
**Modul-002-Branch:** nicht angegeben  
**Merge in `main`:** nicht angegeben

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine Sitzung mit 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, anhand einer deutschen Ticketkarte untersucht, per Blickfokus, Pinch und Drag priorisiert und anschließend einem Support-Team zugeordnet.

Die Anwendung läuft linear in genau einem zentralen volumetrischen Fenster. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug. Nach einer gültigen Entscheidung erfolgt ausschließlich akustisches Richtig-/Falsch-Feedback; die richtige Lösung wird nicht angezeigt. Am Ende erscheinen nur die Gesamtpunktzahl und „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Feedback-Sounds, ein vollständiger Sitzungsreset und ein stabiler Ablauf ohne Backend, Benutzerkonten, Datenbank, Cloud, persistente Spielhistorie, zweites Fenster beziehungsweise Volume, Immersive Space, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | technisch abgeschlossen; Commit-/Mergeangaben weiter offen | `[COMMIT-HASH EINTRAGEN]` | F-05 strukturell teilweise; AK-05 teilweise |
| 002 | Ticketdatenmodell und lokaler Katalog | implementiert; Build- und Testausführung nach Modul 002 nicht nachgewiesen | nicht bekannt | F-02, F-03 implementiert und testseitig abgedeckt; endgültige Verifikation offen |
| 003 | Sitzungsmodell und Zufallsauswahl | als Nächstes; Start nur nach erfolgreicher Vorprüfung des Stands aus 002 | – | F-04, F-16 auf Modellebene |
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

Modul 001 stellte das buildfähige visionOS-Grundgerüst mit genau einer volumetrischen `WindowGroup`, `RootVolumeView`, deutscher Lokalisierungsgrundlage, RealityKit-Standardszene, DebugManager, zentralen Constants und einem Swift-Testing-Smoke-Test bereit. Build, Simulatorstart und 1 von 1 Tests waren für den damaligen Stand erfolgreich bestätigt. AK-05 bleibt bis zur vollständigen Sitzung und Integration nur strukturell teilweise erfüllt.

## Eingearbeiteter Stand Modul 002

### Ergebnis laut Modul-Report

Modul 002 hat folgende fachliche Bestandteile ergänzt:

- `TicketPriority` mit `.normal`, `.wichtig` und `.kritisch`,
- `SupportTeam` mit `.netzwerk`, `.konto`, `.software` und `.hardware`,
- deutsche Anzeigenamen über `displayName`,
- ein unveränderliches, `Identifiable`- und `Equatable`-konformes `Ticket`-Modell,
- `LocalTicketCatalog.allTickets` mit genau zwölf statisch definierten Tickets,
- genau eine Ticketkombination je Support-Team und Priorität,
- sechs zusätzliche Swift-Testing-Testfälle für Katalog und Fachmodell.

### Bewertung der Akzeptanzkriterien

| Kriterium | Stand nach Report | Begründung |
|---|---|---|
| AK-02: genau zwölf lokale Tickets | implementiert und durch Testcode abgedeckt; Ausführung offen | Der Report beschreibt `LocalTicketCatalog.allTickets`, einen Test auf genau zwölf Einträge und rein statische lokale Daten. Ein ausgeführter Testlauf ist nicht dokumentiert. |
| AK-02: jede 4×3-Kombination genau einmal | implementiert und durch Testcode abgedeckt; Ausführung offen | Der Report beschreibt einen entsprechenden Kombinationstest, aber kein ausgeführtes Ergebnis. |
| AK-02: keine externe Datenquelle | auf Codeebene laut Report erfüllt | Der Katalog besteht statisch im Code und verwendet weder Netzwerk-, Datei- noch API-Zugriff. |
| AK-03: vollständige Pflichtdaten | implementiert und durch Testcode abgedeckt; Ausführung offen | Das gemeldete `Ticket`-Modell enthält alle geforderten Felder; der Testlauf fehlt. |
| AK-03: 1 bis 3 Symptome | durch Testcode abgedeckt; Ausführung offen | Der Report nennt die Vollständigkeitsprüfung, aber kein Testergebnis. |
| AK-03: genau eine Priorität und ein Team | strukturell durch das Modell erfüllt | Beide Werte sind einzelne, nicht optionale Enum-Eigenschaften. |

Modul 002 wird deshalb nicht als vollständig technisch verifiziert geführt. Die Implementierung und Testabdeckung sind gemeldet; vor Beginn der eigentlichen Arbeit an Modul 003 müssen App-Build und gesamte Test-Suite ausgeführt werden.

### Nicht vorweggenommen

Der Report bestätigt keine Sitzungslogik, keine Zufallsauswahl, keinen Ticketindex und keinen Reset. Die Modulgrenze zu Modul 003 wurde damit eingehalten.

## Schnittstellen-Register

| Bereitgestellt von | Typ / Methode | Datei | Zweck |
|---|---|---|---|
| 001 | `Ticket_TamerApp` | `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | App-Einstieg mit genau einer volumetrischen Scene |
| 001 | `RootVolumeView` | `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | minimale Root-Oberfläche im zentralen Volume |
| 001 | `DebugManager` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | zentrale kategorisierte Debug-Steuerung |
| 001 | `DebugManager.Category` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio` |
| 001 | `DebugManager.log(_:_:function:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | kategorisierte Debug-Ausgabe |
| 001 | `DebugManager.toggle(_:)` | `Ticket_Tamer/Ticket_Tamer/Debug/DebugManager.swift` | Umschalten einer Debug-Kategorie |
| 001 | `LayoutConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Layout- und Volume-Maße |
| 001 | `GameplayConstants` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Ticketanzahl-Grenzen und Standardwert |
| 001 | `AssetKeys` | `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` | Schlüssel vorhandener lokaler Ressourcen |
| 002 | `TicketPriority` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | fachliche Priorität `.normal`, `.wichtig`, `.kritisch` |
| 002 | `TicketPriority.displayName: String` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutsche Prioritätsbezeichnung |
| 002 | `SupportTeam` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | fachliches Zielteam `.netzwerk`, `.konto`, `.software`, `.hardware` |
| 002 | `SupportTeam.displayName: String` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | deutsche Teambezeichnung |
| 002 | `Ticket` | `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift` | unveränderliches Ticketmodell mit Pflichtdaten und Referenzwerten |
| 002 | `LocalTicketCatalog.allTickets: [Ticket]` | `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift` | vollständiger statischer Ticketpool für Folgemodule |

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

`BalancingConstants` ist weiterhin bewusst nicht vorhanden.

## DebugManager

- Modul 002 ergänzte keine Kategorie und keine Log-Ausgabe.
- Diese Entscheidung ist angemessen, weil das Modul ausschließlich statische Datentypen und einen statischen Katalog bereitstellt.
- Die bestehenden Kategorien aus Modul 001 bleiben unverändert.
- Verteilte `print()`-Ausgaben wurden nicht gemeldet.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Die Dokumentationsstruktur unter `Dokumentation/00_Projektsteuerung/` bis `Dokumentation/05_Aktueller-Stand/` ist verbindlich. | Eingangsprompts, Reports und aktuelle Stände sollen eindeutig auffindbar sein. |
| 2026-07-15 | `Logbuch-Stand.md` und `Projekt-Stand.md` werden jeweils als eine aktuelle Datei ersetzt. | Historie gehört in Git, nicht in parallele Standkopien. |
| 2026-07-15 | Das Projekt verwendet genau eine volumetrische `WindowGroup`. | Grundlage für F-05 ohne zweites Volume oder Immersive Space. |
| 2026-07-15 | `BalancingConstants` wird erst bei fachlichem Bedarf angelegt. | Künstliche leere Strukturen werden vermieden. |
| 2026-08-05 | Modul 002 gilt als implementiert, aber nicht als vollständig technisch verifiziert. | Der Report enthält Testimplementierungen, jedoch keinen dokumentierten Build- oder Testlauf nach den Änderungen. |
| 2026-08-05 | Modul 003 beginnt mit einem verpflichtenden Build- und Test-Preflight. | Das Sitzungsmodell darf nur auf einem kompilierenden und testbaren Ticketkatalog aufbauen. |
| 2026-08-05 | Die drei gemeldeten `.DS_Store`-Dateien sind keine Projektartefakte und bleiben als zu bereinigendes Repository-Risiko dokumentiert. | Sie besitzen keinen fachlichen Nutzen und sollen nicht Teil der Code-Historie sein. Die Bereinigung wird nicht stillschweigend Modul 003 zugeschlagen. |
| 2026-08-05 | Das in der SPEC-Architekturskizze genannte Feld `monsterAssetId` ist im gemeldeten `Ticket`-Interface nicht enthalten. | Der Report enthält keine Begründung. Modul 003 darf diese Lücke nicht nebenbei schließen; die Entscheidung ist spätestens vor Modul 005 explizit zu treffen. |
| 2026-08-05 | Modul 003 darf Zustandsfelder für spätere Entscheidungen und Score bereitstellen und zurücksetzen, aber keine Bewertungs-, Drop-, Audio- oder UI-Logik implementieren. | F-16 verlangt einen vollständigen Modellreset; die fachliche Verarbeitung gehört dennoch zu späteren Modulen. |

## Offene Punkte / Risiken

### Vor Modul 003 zwingend zu prüfen

- [ ] App-Target mit dem Stand aus Modul 002 erfolgreich bauen.
- [ ] Gesamte Test-Suite ausführen.
- [ ] Bestätigen, dass der bestehende Modul-001-Smoke-Test weiterhin vorhanden und erfolgreich ist.
- [ ] Ergebnis und Anzahl aller Tests dokumentieren.
- [ ] Tatsächlichen Branch und Commit-Hash von Modul 002 dokumentieren.
- [ ] Merge-Status von Modul 001 und Modul 002 in `main` dokumentieren.

### Repository-Hygiene

- [ ] `.DS_Store` im Repository-Stamm entfernen.
- [ ] `Ticket_Tamer/.DS_Store` entfernen.
- [ ] `Ticket_Tamer/Ticket_Tamer/.DS_Store` entfernen.
- [ ] Prüfen, ob `.DS_Store` bereits durch `.gitignore` ausgeschlossen wird; andernfalls bewussten Cleanup-Schritt festlegen.

### Fachliche und technische Risiken

- [ ] Tickettexte enthalten laut Report teilweise `ae`, `oe` und `ue`; vor sichtbarer Verwendung in Modul 006 auf korrektes Deutsch mit Umlauten prüfen.
- [ ] Die zwölf Ticketinhalte und ihre fachliche Eindeutigkeit sind im Report nicht einzeln aufgelistet; vor der UI-Nutzung sollte ein fachliches Review erfolgen.
- [ ] `monsterAssetId` fehlt gegenüber der SPEC-Architekturskizze; explizite Entscheidung spätestens vor Modul 005 dokumentieren.
- [ ] `GameplayConstants.maximumTicketCount` muss mit der Kataloggröße 12 konsistent bleiben.
- [ ] `LocalTicketCatalog.allTickets` bleibt die einzige Datenquelle; spätere Module dürfen keine parallelen Ticketlisten anlegen.
- [ ] Vollständige AK-05-Abnahme bleibt Modul 013 vorbehalten.
- [ ] Zugriff und Zeitfenster für Apple-Vision-Pro-Tests sichern.

## Chronik

### Modul 001 — Projektgrundgerüst und zentrales Volume

Das visionOS-Projekt erhielt genau ein zentrales volumetrisches Fenster, die minimale `RootVolumeView`, deutsche Basistexte, eine sichtbare RealityKit-Standardszene, DebugManager, Constants und einen Swift-Testing-Smoke-Test. Build, Simulatorstart und 1 von 1 Tests waren bestätigt. AK-05 bleibt strukturell teilweise erfüllt.

### Modul 002 — Ticketdatenmodell und lokaler Katalog

`TicketPriority`, `SupportTeam`, `Ticket` und `LocalTicketCatalog.allTickets` wurden als einfache modulinterne Fachschnittstellen gemeldet. Der Katalog enthält laut Report genau zwölf statische Tickets und deckt jede Kombination aus vier Teams und drei Prioritäten genau einmal ab. Sechs zusätzliche Tests wurden implementiert; ein tatsächlicher Build- und Testlauf nach diesen Änderungen ist jedoch nicht dokumentiert. Drei `.DS_Store`-Dateien und die fehlende dokumentierte Entscheidung zu `monsterAssetId` bleiben als offene Punkte erhalten.

## Nächster Schritt

`003-Eingangsprompt.md` in einen neuen Modul-Chat geben. Der Modul-Chat muss zuerst den Stand aus Modul 002 bauen und vollständig testen. Danach darf er ausschließlich das zentrale Sitzungsmodell, begrenzte Ticketanzahl, zufällige Auswahl ohne Wiederholung, sicheren Ticketindex und die Modell-Resetlogik umsetzen. UI, Bewertung, Audio, Monster und räumliche Interaktion bleiben ausgeschlossen.
