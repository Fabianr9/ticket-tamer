# Modul-Eingangsprompt — 003 Sitzungsmodell und Zufallsauswahl

> Vom Projektlogbuch nach Eingang des `002-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 003 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den realen Projektstand, verifiziere die noch unbestätigten Änderungen aus Modul 002 und baue anschließend ausschließlich das zentrale Sitzungsmodell mit Ticketanzahl, zufälliger Auswahl ohne Wiederholung, sicherem Ticketindex und Modellreset.

## Modul

**Nummer:** 003  
**Titel:** Sitzungsmodell und Zufallsauswahl  
**Ziel:** Das Projekt erhält eine zentrale, ausschließlich im Arbeitsspeicher gehaltene Sitzung, die 1 bis 12 zufällige Tickets ohne Wiederholung aus dem vorhandenen lokalen Katalog auswählt, den aktuellen Ticketindex sicher verwaltet und den gesamten Modellzustand auf die Startwerte zurücksetzen kann.

## Verbindliche Quellengrundlage

Arbeite auf Basis von:

- `Dokumentation/01_Kontext/Projektbeschreibung.md`
- `Dokumentation/01_Kontext/SPEC.md`
- `Dokumentation/01_Kontext/Akzeptanzkriterien.md`
- aktuellem `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md`
- aktuellem `Dokumentation/05_Aktueller-Stand/Logbuch-Stand.md`
- `Dokumentation/04_Modul-Reports/001-Report.md`
- `Dokumentation/04_Modul-Reports/002-Report.md`
- `Dokumentation/02_Vorlagen/Modul-Report-Vorlage.md`

Verwende ausschließlich tatsächlich vorhandene Dateien und Schnittstellen. Erfinde keinen Branch, Commit, Build- oder Teststatus.

## Verbindlicher Vorab-Check

Der `002-Report.md` beschreibt sechs neue Tests, enthält aber keinen nachgewiesenen Build- oder Testlauf. Bevor du Modul-003-Logik implementierst:

1. Ermittle den tatsächlichen Branch und den aktuellen Commit.
2. Prüfe, ob die Dateien aus Modul 002 vorhanden und dem richtigen Target zugeordnet sind.
3. Baue das App-Target.
4. Führe die gesamte Swift-Testing-Suite aus.
5. Prüfe, ob der Smoke-Test aus Modul 001 und alle Modell-/Katalogtests aus Modul 002 vorhanden sind und bestehen.
6. Dokumentiere Testanzahl, Suite, Plattform und Ergebnis.

Falls der Stand aus Modul 002 nicht kompiliert oder Tests fehlschlagen, behebe nur den kleinsten eindeutig zu Modul 002 gehörenden Defekt, der die Grundlage für Modul 003 blockiert. Weise eine solche Korrektur im `003-Report.md` getrennt als übernommene Modul-002-Nacharbeit aus. Verändere keine Ticketinhalte oder Fachanforderungen ohne ausdrückliche Begründung.

## Zu erfüllende Anforderungen

### SPEC F-04

> Beim Start einer Sitzung wählt das System entsprechend der Reglereinstellung zufällige Tickets ohne Wiederholung aus dem lokalen Ticketpool aus.

### SPEC F-16

> „Erneut spielen“ führt zur Startansicht zurück, verwirft den bisherigen Sitzungszustand und setzt den Regler wieder auf 6 Tickets.

### AK-04 — Sitzungsauswahl ohne Wiederholung

- GEGEBEN auf der Startansicht ist die Ticketanzahl `n` gewählt, WENN „Spiel starten“ aktiviert wird, DANN enthält die Sitzung genau `n` Tickets.
- GEGEBEN eine Sitzung läuft, WENN alle ausgewählten Ticket-IDs verglichen werden, DANN kommt keine Ticket-ID doppelt vor.
- GEGEBEN mehrere Sitzungen werden nacheinander gestartet, WENN ihre Auswahl verglichen wird, DANN darf die Reihenfolge beziehungsweise Auswahl variieren.

### AK-16 — Neustart und Reset

- GEGEBEN die Ergebnisansicht ist geöffnet, WENN „Erneut spielen“ ausgelöst wird, DANN erscheint die Startansicht.
- Nach dem Neustart beträgt der angezeigte Ticketwert wieder 6.
- Punktestand, Ticketindex, gespeicherte Entscheidungen und vorherige Sitzungstickets sind zurückgesetzt.
- Nach mindestens fünf aufeinanderfolgenden Neustarts bleibt die App lauffähig und übernimmt keine Punkte aus früheren Sitzungen.

## Abnahmegrenze dieses Moduls

Modul 003 erfüllt F-04 und AK-04 auf Modellebene vollständig, sofern Build und Tests erfolgreich sind.

F-16 und AK-16 werden in Modul 003 nur auf Modellebene vorbereitet beziehungsweise geprüft:

- Ticketanzahl wird auf 6 zurückgesetzt,
- Sitzungstickets werden geleert,
- Ticketindex wird zurückgesetzt,
- Phase wird auf den Startzustand gesetzt,
- Punktestand wird auf 0 gesetzt,
- gespeicherte Prioritäts- und Teamentscheidung werden entfernt,
- Eingabesperre wird aufgehoben,
- wiederholter Reset hinterlässt keinen Zustand aus früheren Sitzungen.

Noch nicht Bestandteil von Modul 003 sind:

- die Ergebnisansicht,
- die Schaltfläche „Erneut spielen“,
- der sichtbare Wechsel zur Startansicht,
- der sichtbare Reglerwert.

Diese UI-Anteile werden in Modul 004 beziehungsweise Modul 011 umgesetzt und in Modul 013 integriert geprüft. Markiere AK-16 im Report deshalb nicht vollständig als erfüllt.

## Bestehender Kontext aus Modul 001

- `Ticket_TamerApp` — App-Einstieg mit genau einer volumetrischen Scene.
- `RootVolumeView` — minimale Root-Oberfläche.
- `DebugManager` und `DebugManager.log(_:_:function:)`.
- `DebugManager.Category` mit `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`.
- `LayoutConstants`.
- `GameplayConstants` mit:
  - `minimumTicketCount = 1`
  - `maximumTicketCount = 12`
  - `defaultTicketCount = 6`
- `AssetKeys`.

## Bestehender Kontext aus Modul 002

### Fachtypen

- `TicketPriority`
  - `.normal`
  - `.wichtig`
  - `.kritisch`
- `TicketPriority.displayName: String`
- `SupportTeam`
  - `.netzwerk`
  - `.konto`
  - `.software`
  - `.hardware`
- `SupportTeam.displayName: String`
- `Ticket`
  - `id`
  - `ticketNumber`
  - `title`
  - `shortDescription`
  - `userImpact`
  - `symptoms`
  - `referencePriority`
  - `referenceTeam`
- `LocalTicketCatalog.allTickets: [Ticket]`

### Relevante Pfade

- `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift`
- `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

### Wichtige Grenze

Die SPEC-Architekturskizze nennt `monsterAssetId`, das gemeldete Ticketmodell aus Modul 002 jedoch nicht. Ändere `Ticket` in Modul 003 nicht zur Behebung dieser Abweichung. Die Entscheidung gehört spätestens vor Modul 005 in das Projektlogbuch.

## Verbindliche Modulgrenze

Modul 003 bearbeitet ausschließlich:

- einen zentralen Sitzungszustand als einzige Quelle für den aktuellen Modellzustand,
- ausgewählte Ticketanzahl mit gültigem Bereich 1 bis 12 und Standardwert 6,
- Start einer Sitzung aus `LocalTicketCatalog.allTickets`,
- zufällige Auswahl ohne Wiederholung,
- aktuelle Sitzungstickets,
- aktuellen Ticketindex,
- sicheren Zugriff auf das aktuelle Ticket,
- minimale, sichere Indexfortschaltung ohne UI-Navigation,
- grundlegenden Phasenzustand nach der SPEC,
- Zustandsfelder, die für vollständigen Reset benötigt werden,
- Modellreset,
- automatisierte Tests dieser Logik.

Modul 003 bearbeitet ausdrücklich nicht:

- Startansicht, Regler oder Schaltfläche „Spiel starten“,
- SwiftUI-Navigation zwischen Phasen,
- Ticketkarte,
- Monster-Assets oder Monsterzuordnung,
- Blickfokus, Pinch, Drag oder Drop-Ziele,
- Bewertung einer Prioritäts- oder Teamentscheidung,
- Punktevergabe,
- Audiofeedback,
- automatische 1,5-Sekunden-Übergänge,
- Ergebnisansicht,
- Schaltfläche „Erneut spielen“,
- optionale Monsterreaktion,
- Änderung der zwölf Tickettexte.

## Konkreter Arbeitsauftrag

### 1. Aktuellen Ist-Zustand analysieren

Dokumentiere:

- aktuellen Branch und Commit,
- tatsächlichen Dateibaum,
- App- und Test-Targets,
- vorhandene Modell- und Katalogdateien,
- Build- und Testergebnis vor den Modul-003-Änderungen,
- vorhandene `.DS_Store`-Dateien nur als Repository-Hinweis.

Die `.DS_Store`-Bereinigung ist keine stillschweigende Aufgabe von Modul 003. Nimm keine fachfremde Repository-Bereinigung vor, sofern sie nicht separat beauftragt wurde.

### 2. Einen einfachen zentralen Sitzungszustand entwerfen

Richte genau eine verständliche Modellverantwortung für den aktuellen Spielzustand ein. Verwende eine zu SwiftUI passende Beobachtbarkeit, ohne unnötige Architektur einzuführen.

Der Sitzungszustand muss mindestens fachlich abbilden:

- `selectedTicketCount: Int`
- `sessionTickets: [Ticket]`
- `currentTicketIndex: Int`
- `currentPhase`
- `score: Int`
- `selectedPriority: TicketPriority?`
- `selectedTeam: SupportTeam?`
- `isInputLocked: Bool`

Die Benennung darf dem vorhandenen Projektstil angepasst werden, muss aber im Report vollständig dokumentiert werden. Verwende keine zweite konkurrierende Quelle für denselben Zustand.

### 3. Phasengrundlage definieren

Die SPEC nennt die Phasen:

- Start,
- Untersuchen,
- Priorisieren,
- Team zuordnen,
- Ergebnis.

Eine einfache `GamePhase`- oder gleichwertige Enum-Grundlage darf in diesem Modul entstehen, weil der Reset einen eindeutigen Startzustand benötigt. Implementiere jedoch noch keine vollständige Phasenmaschine und keine automatischen Übergänge zwischen diesen Phasen.

### 4. Ticketanzahl defensiv verwalten

- Standardwert: `GameplayConstants.defaultTicketCount` beziehungsweise 6.
- Gültiger Bereich: `GameplayConstants.minimumTicketCount` bis `GameplayConstants.maximumTicketCount` beziehungsweise 1 bis 12.
- Ein technisch übergebener ungültiger Wert darf keine Sitzung mit weniger als 1 oder mehr als 12 Tickets erzeugen.
- Verwende die vorhandenen Constants statt neuer Magic Numbers.
- Die sichtbare Reglerbindung gehört erst zu Modul 004.

### 5. Sitzung starten

Beim Modellstart einer Sitzung:

- verwende ausschließlich `LocalTicketCatalog.allTickets`,
- wähle genau die gültige ausgewählte Ticketanzahl,
- wähle ohne doppelte Ticket-ID,
- erzeuge keine zweite Ticketliste im Projekt,
- setze den Index auf das erste Ticket,
- setze die Phase auf den fachlich korrekten ersten Sitzungszustand,
- entferne alten Score, alte Entscheidungen und Eingabesperren,
- halte alle Daten ausschließlich im Arbeitsspeicher.

### 6. Zufallsauswahl testbar gestalten

Die Auswahl muss bei neuen Sitzungen neu gemischt beziehungsweise neu gezogen werden können. Vermeide dabei instabile Tests.

- Ein Test darf nicht einfach verlangen, dass zwei echte Zufallsläufe zwingend verschieden sind; dasselbe Ergebnis wäre theoretisch erlaubt.
- Schaffe eine kleine, nachvollziehbare Testmöglichkeit, mit der unterschiedliche gültige Reihenfolgen oder Auswahlen deterministisch nachgewiesen werden können.
- Bevorzuge eine kleine injizierbare Auswahl-/Mischfunktion oder eine ebenso einfache Lösung.
- Führe keinen komplexen Random-Service, keine Dependency-Injection-Infrastruktur und keine generische Repository-Schicht ein.

### 7. Ticketindex sicher verwalten

- `currentTicketIndex` beginnt für eine aktive, nicht leere Sitzung beim ersten Ticket.
- Ein sicherer Zugriff auf das aktuelle Ticket darf außerhalb gültiger Grenzen nicht abstürzen.
- Eine minimale Indexfortschaltung darf bereitgestellt werden, weil Modul 003 laut Modul-Landkarte den Index verwaltet.
- Die Indexfortschaltung darf keine UI-Navigation, Punktewertung oder vollständige Phasenfolge implementieren.
- Das Verhalten am Ende der Liste muss eindeutig und getestet sein; dokumentiere die gewählte einfache Semantik.

### 8. Vollständigen Modellreset implementieren

Der Reset muss unabhängig davon funktionieren, in welchem Modellzustand sich die Sitzung befindet:

- `selectedTicketCount` auf 6,
- `sessionTickets` leeren,
- `currentTicketIndex` auf den definierten Startwert,
- Phase auf Start,
- `score` auf 0,
- `selectedPriority` auf `nil`,
- `selectedTeam` auf `nil`,
- `isInputLocked` auf `false`.

Führe mindestens fünf aufeinanderfolgende Resets im Test aus und prüfe, dass kein Zustand aus vorherigen Sitzungen übernommen wird.

Modul 003 baut keine Ergebnisansicht und keine „Erneut spielen“-Schaltfläche. Es stellt nur die später aufzurufende Reset-Schnittstelle bereit.

### 9. DebugManager verwenden

- Verwende die bestehende Kategorie `state` für tatsächlich relevante Sitzungsereignisse.
- Sinnvolle Ereignisse sind beispielsweise Sitzungsstart, gültige Ticketanzahl, Indexänderung und Reset.
- Logge keine vollständigen Tickettexte und keine unnötigen Datenmengen.
- Ergänze keine neue Kategorie, wenn `state` ausreicht.
- Verwende keine verteilten `print()`-Aufrufe.
- Nenne die Logging-Stellen im Report.

### 10. Automatisierte Tests ergänzen

Erhalte alle vorhandenen Tests und ergänze mindestens Prüfungen für:

- Standardticketanzahl ist 6,
- zulässige Werte 1 und 12,
- defensive Behandlung technisch ungültiger Werte,
- Sitzung mit 1 Ticket enthält genau 1 Ticket,
- Sitzung mit 6 Tickets enthält genau 6 Tickets,
- Sitzung mit 12 Tickets enthält genau 12 Tickets,
- keine doppelte Ticket-ID in einer Sitzung,
- alle Sitzungstickets stammen aus `LocalTicketCatalog.allTickets`,
- neue Sitzungen führen die Auswahl erneut aus,
- unterschiedliche gültige Auswahlen oder Reihenfolgen sind über eine deterministische Testnaht möglich,
- Index startet korrekt,
- sicherer Zugriff auf das aktuelle Ticket,
- eindeutiges Verhalten beim Indexende,
- Reset stellt alle Modellfelder zurück,
- fünf aufeinanderfolgende Resets bleiben stabil,
- App-Build und alle Tests aus 001, 002 und 003 sind erfolgreich.

Tests dürfen nicht von SwiftUI, RealityKit, Audio oder einem laufenden Simulatorfenster abhängen.

### 11. Bestehende Dateien schützen

Ändere nach Möglichkeit nicht:

- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`,
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift`,
- `Ticket_Tamer/Ticket_Tamer/Info.plist`,
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings`,
- RealityKitContent-Dateien,
- die zwölf Tickettexte,
- `TicketPriority`, `SupportTeam` und `Ticket`, sofern kein nachgewiesener Kompilierungsfehler dies zwingend erfordert.

`AppConstants.swift` darf nur ergänzt werden, wenn der Wert wirklich modulübergreifend ist. Verwende bestehende Ticketanzahl-Constants; dupliziere sie nicht.

### 12. Build und Abschlussprüfung

Am Ende müssen bestätigt sein:

- App-Target baut erfolgreich,
- visionOS-Simulatorstart bleibt möglich,
- gesamte Swift-Testing-Suite besteht,
- tatsächliche Testanzahl, Suite und Plattform sind dokumentiert,
- Sitzung mit 1, 6 und 12 Tickets funktioniert auf Modellebene,
- keine Ticket-ID kommt innerhalb einer Sitzung doppelt vor,
- Katalog bleibt die einzige Ticketdatenquelle,
- Reset ist vollständig und wiederholbar,
- keine UI-, Bewertungs-, Audio- oder RealityKit-Logik wurde vorweggenommen,
- keine doppelten aktiven Dateien oder Typdefinitionen wurden angelegt.

## Querschnitts-Anforderungen

### Ordnerstruktur

- Lege neue Dateien in einen passenden bestehenden Verantwortungsbereich, vorzugsweise `Models/` für den Sitzungszustand.
- Erzeuge nur weitere Dateien, wenn eine klare Verantwortungsgrenze besteht.
- Halte physische Ordner und Xcode-Gruppen konsistent.
- Nenne Pfad und Target-Mitgliedschaft jeder Datei im Report.

### Dokumentation im Code

- `///`-Doc-Kommentare an jedem neuen Typ und jeder für Folgemodule verwendbaren Methode,
- `// MARK: -` zur Gliederung,
- Warum-Kommentare an nicht offensichtlichen Auswahl-, Bounds- oder Resetentscheidungen,
- keine Kommentare, die nur Code wiederholen.

### Wartbarkeit

- eine zentrale Quelle für den Sitzungszustand,
- keine komplexe Architektur,
- keine unnötigen Protokolle außer einer kleinen Testnaht für die Zufallsauswahl, falls erforderlich,
- verständliche Schnittstellen für Modul 004, 006, 008, 009, 010 und 011,
- möglichst geringe Änderungen an konfliktanfälligen Dateien.

### Git

Vorgesehener Commit:

`003: Sitzungsmodell und Zufallsauswahl`

Erfinde keinen Commit-Hash.

## Ausgabeformat

Gib die Ergebnisse in dieser Reihenfolge aus:

1. **Analyse und Vorab-Verifikation**
   - Branch und Commit,
   - tatsächlicher Dateibaum,
   - Build vor Modul 003,
   - Test-Suite, Testanzahl, Plattform und Ergebnis vor Modul 003,
   - gegebenenfalls notwendige, getrennt ausgewiesene Nacharbeit aus Modul 002.

2. **Sitzungsmodell-Entwurf**
   - Typname und Datei,
   - Zustandsfelder,
   - Phasengrundlage,
   - Start-, Auswahl-, Index- und Reset-Schnittstellen,
   - Testbarkeit der Zufallsauswahl,
   - klare Abgrenzung zu späteren Modulen.

3. **Code-Teile einzeln ausgewiesen**
   Zu jedem Teil:
   - exakter Dateipfad,
   - neu, ergänzt, ersetzt, verschoben oder entfernt,
   - Target-Mitgliedschaft,
   - genauer Einbauort,
   - Begründung mit Bezug zu F-04, F-16, AK-04 oder dem Modellanteil von AK-16.

4. **Test-Anleitung und tatsächliche Testergebnisse**
   - Build- und Testschritte,
   - alle ausgeführten Tests,
   - Ergebnis der bestehenden und neuen Tests,
   - Nachweis für 1, 6 und 12 Tickets,
   - Nachweis ohne Duplikate,
   - Nachweis für fünf Resets,
   - Bestätigung, dass keine spätere UI-, Bewertungs- oder Interaktionslogik enthalten ist.

5. **Vollständiger `003-Report.md` nach der Modul-Report-Vorlage**
   Der Report muss zusätzlich enthalten:
   - tatsächlichen Dateibaum nach Modul 003,
   - alle neuen, geänderten, verschobenen und entfernten Dateien,
   - öffentliche beziehungsweise modulinterne Schnittstellen für Folgemodule,
   - genaue Auswahl- und Bounds-Semantik,
   - genaue Index-Endsemantik,
   - vollständige Reset-Semantik,
   - DebugManager-Nutzung,
   - Test-Suite, Testanzahl, Plattform und Ergebnis,
   - Status von AK-04,
   - klar aufgeteilten Status von AK-16: Modellanteil erfüllt oder offen; UI-Anteil offen,
   - Bestätigung, dass keine Bewertungs-, Audio-, UI- oder RealityKit-Logik umgesetzt wurde,
   - Status der aus Modul 002 übernommenen offenen Punkte,
   - Empfehlung für Modul 004.

Baue nichts außerhalb dieses Moduls um. Wenn eine benötigte Schnittstelle erst zu Modul 004 oder später gehört, dokumentiere sie als offenen Punkt, statt sie vorwegzunehmen.
