# Modul-Eingangsprompt — 004 Startansicht und Einstellungen

> Vom Projektlogbuch nach Einarbeitung des `003-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 004 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git- und Xcode-Stand. Implementiere ausschließlich die deutsche Startansicht mit Projekttitel, ganzzahligem Ticketregler, sichtbarem Ticketwert und der Schaltfläche „Spiel starten“ sowie die minimal notwendige Anbindung an das vorhandene `SessionModel`.

Erfinde keine vorhandenen Dateien, Gruppen, Targets, Commit-Hashes, Build-Ergebnisse oder Schnittstellen.

## Modul

**Nummer:** 004  
**Titel:** Startansicht und Einstellungen  
**Ziel:** Im einzigen zentralen Volume erscheint beim App-Start eine verständliche deutsche Startansicht mit dem Projekttitel, einem ganzzahligen Regler von 1 bis 12 Tickets, dem sichtbaren Standardwert 6 und der Schaltfläche „Spiel starten“. Die Eingaben verwenden das zentrale `SessionModel`, ohne die Untersuchungsphase oder andere spätere Module vorwegzunehmen.

## Git- und Ausgangsstand

Laut `003-Report.md`:

- Der Vorab-Check für Modul 003 lief auf Branch `main`.
- Letzter bestätigter Commit vor Modul 003: `2775041 feat: add modul 2`.
- Der tatsächliche Commit für Modul 003 ist noch nicht bekannt.
- Ein Xcode-Build und Testlauf nach Modul 003 wurden im Modul-Chat nicht ausgeführt.
- Grund: `xcodebuild` und `swiftc` waren im damaligen Sandbox-Umfeld nicht verfügbar.

Vor jeder Änderung musst du deshalb:

1. den tatsächlichen Branch und Commit ermitteln,
2. prüfen, ob `GamePhase.swift` und `SessionModel.swift` wirklich vorhanden sind,
3. das App-Target lokal bauen,
4. die gesamte Test-Suite lokal ausführen,
5. den tatsächlichen Testbestand und alle Test-Suites dokumentieren.

Arbeite nicht auf einem Stand, in dem die bestätigten Dateien aus den Modulen 001 bis 003 fehlen.

## Verbindliche Quellen

- `Dokumentation/01_Kontext/Projektbeschreibung.md`
- `Dokumentation/01_Kontext/SPEC.md`
- `Dokumentation/01_Kontext/Akzeptanzkriterien.md`
- `Dokumentation/05_Aktueller-Stand/Logbuch-Stand.md`
- `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md`
- `Dokumentation/04_Modul-Reports/001-Report.md`
- `Dokumentation/04_Modul-Reports/002-Report.md`
- `Dokumentation/04_Modul-Reports/003-Report.md`
- `Dokumentation/02_Vorlagen/Modul-Report-Vorlage.md`

Verwende die tatsächlich vorhandenen Dateien als Code-Wahrheitsstand.

## Verbindlicher Vorab-Check

### Build und Tests

Führe vor der Implementierung aus beziehungsweise prüfe in Xcode:

- App-Build,
- Simulatorstart,
- vollständige Swift-Testing-Suite,
- Anzahl der Test-Suites,
- Anzahl aller Tests,
- Anzahl bestandener und fehlgeschlagener Tests,
- Zielplattform.

### Aufzulösende Testinkonsistenz

Der `003-Report.md` nennt zwölf neue Tests und insgesamt 19 Tests, listet jedoch 15 neue Testnamen auf. Ermittle den tatsächlichen Stand in `Ticket_TamerTests.swift` und durch den realen Testlauf.

Dokumentiere im `004-Report.md`:

- wie viele Modul-003-Tests tatsächlich vorhanden sind,
- wie viele Tests insgesamt ausgeführt wurden,
- ob die Abweichung nur ein Dokumentationsfehler oder auch ein Codeproblem war.

Ändere keine Tests nur, um eine bestimmte Zahl zu erreichen. Korrigiere ausschließlich echte Fehler oder eindeutig falsche Testdokumentation.

### SessionModel-Verhalten prüfen

Lies die reale Implementierung von `SessionModel.startSession(using:)` und dokumentiere:

- welche Felder beim Start zurückgesetzt werden,
- welche `GamePhase` nach dem Start gesetzt wird,
- ob die Methode bei ausgewählter Ticketanzahl 1 bis 12 korrekt arbeitet,
- ob sie ohne zusätzliche UI-Logik verwendet werden kann.

Erfinde dieses Verhalten nicht anhand des Reports.

## Zu erfüllende Anforderungen

### SPEC F-01

> Das System zeigt beim App-Start eine deutsche Startansicht mit Projekttitel, einem ganzzahligen Regler von 1 bis 12 Tickets, dem Standardwert 6 und der Schaltfläche „Spiel starten“.

### AK-01 — Startansicht und Ticketanzahl

- GEGEBEN die App wird neu gestartet, WENN die Startansicht erscheint, DANN sind der Projekttitel, ein Regler, der Wert `6` und die Schaltfläche „Spiel starten“ sichtbar.
- GEGEBEN die Startansicht ist geöffnet, WENN der Regler bewegt wird, DANN kann ausschließlich ein ganzzahliger Wert von 1 bis 12 eingestellt werden.
- GEGEBEN ein Wert außerhalb von 1 bis 12 wird technisch angefordert, WENN die Einstellung übernommen wird, DANN startet keine Sitzung mit weniger als 1 oder mehr als 12 Tickets.

## Abnahmegrenze dieses Moduls

Modul 004 erfüllt F-01 und AK-01 auf UI- und Modellanbindungsebene.

Das Modul darf minimal sicherstellen, dass ein Auslösen von „Spiel starten“ die vorhandene `SessionModel.startSession()`-Schnittstelle verwendet. Es darf jedoch keine fachliche Untersuchungsphase bauen.

Nach dem Start darf deshalb höchstens:

- die im vorhandenen Modell vorgesehene Phasenänderung ausgelöst werden,
- eine bereits vorhandene neutrale Root-/Platzhalterdarstellung sichtbar bleiben,
- oder ein sehr einfacher nicht-fachlicher Platzhalter für einen noch nicht implementierten Folgeschritt erscheinen.

Nicht zulässig sind in Modul 004:

- Ticketkarte,
- Ticketnummer, Titel, Kurzbeschreibung, User Impact oder Symptome als fertige Untersuchungsansicht,
- Monsterdarstellung oder Monsterzuordnung,
- „Weiter zur Priorisierung“,
- Prioritätsziele,
- Teamstationen,
- Drag-and-Drop,
- Bewertung, Scoreanzeige oder Audiofeedback,
- Ergebnisansicht oder „Erneut spielen“.

## Bestehender technischer Kontext

### App- und UI-Grundlage

- `Ticket_TamerApp`
- `RootVolumeView`
- genau eine volumetrische `WindowGroup`
- kein zweites Fenster oder Volume
- kein Immersive Space
- `Localizable.xcstrings`
- `LayoutConstants`
- `GameplayConstants`
- `AssetKeys`
- vorhandene RealityKit-Standardszene

### Ticketdaten

- `TicketPriority`
- `SupportTeam`
- `Ticket`
- `LocalTicketCatalog.allTickets`

### Sitzungsmodell

- `GamePhase`
  - `.start`
  - `.untersuchen`
  - `.priorisieren`
  - `.teamZuordnen`
  - `.ergebnis`
- `SessionModel`
- `SessionModel.selectedTicketCount`
- `SessionModel.setTicketCount(_:)`
- `SessionModel.startSession(using:)`
- `SessionModel.sessionTickets`
- `SessionModel.currentTicket`
- `SessionModel.currentTicketIndex`
- `SessionModel.currentPhase`
- `SessionModel.reset()`

Weitere Felder sind vorhanden, aber für Modul 004 nicht fachlich zu verwenden:

- `score`
- `selectedPriority`
- `selectedTeam`
- `isInputLocked`

## Relevante Pfade

- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Die Pfade sind anhand des realen Projekts zu prüfen.

## Verbindliche Modulgrenze

Modul 004 bearbeitet ausschließlich:

- den Besitz beziehungsweise die Bereitstellung genau einer `SessionModel`-Instanz für die aktuelle App-Sitzung,
- eine deutsche Startansicht,
- sichtbaren Projekttitel,
- ganzzahligen Regler von 1 bis 12,
- sichtbare Anzeige des aktuell gewählten Werts,
- Standardwert 6,
- Schaltfläche „Spiel starten“,
- Weitergabe des Reglerwerts an `SessionModel.setTicketCount(_:)`,
- Aufruf von `SessionModel.startSession()` durch die Startschaltfläche,
- notwendige deutsche String-Catalog-Einträge,
- angemessene SwiftUI- und Modelltests beziehungsweise nachvollziehbare Simulatorprüfung,
- Aktualisierung des tatsächlichen Dateibaums und Modulreports.

Modul 004 bearbeitet ausdrücklich nicht:

- Ticketdaten oder Ticketkatalog,
- Zufallsauswahl-Algorithmus,
- Reset-Implementierung,
- vollständige Navigation oder Phasenmaschine,
- Untersuchungsphase,
- Monster-Assets,
- RealityKit-Interaktionen,
- Priorisierung,
- Teamzuordnung,
- Bewertung,
- Audio,
- automatische Übergänge,
- Ergebnisansicht,
- optionale Monsterreaktion.

## Konkreter Arbeitsauftrag

### 1. Tatsächlichen Projektstand analysieren

Dokumentiere vor Änderungen:

- aktuellen Branch und Commit,
- tatsächlichen Dateibaum,
- vorhandene App-/View-Struktur,
- reale `SessionModel`-Implementierung,
- reale Testzahl und Test-Suites,
- Build- und Simulatorstand,
- vorhandene Lokalisierungsschlüssel,
- ob bereits eine Startansicht oder vergleichbare UI existiert.

Lege keine parallele zweite Startansicht an, wenn eine vorhandene Datei kontrolliert angepasst oder ersetzt werden kann.

### 2. Genau eine SessionModel-Instanz besitzen

Wähle die einfachste nachvollziehbare SwiftUI-Lösung für genau eine Instanz während der App-Laufzeit.

Mögliche einfache Varianten sind:

- Besitz in `RootVolumeView` mit Swift Observation,
- Besitz am App-Einstieg und Weitergabe über die Environment.

Entscheide anhand des realen Codes. Führe keinen Dependency-Injection-Container, kein globales Singleton und keine zusätzliche ViewModel-Schicht ein.

Anforderungen:

- keine zweite konkurrierende `SessionModel`-Instanz für die Startansicht,
- spätere Views müssen denselben Zustand verwenden können,
- Actor-Isolation von `@MainActor` beachten,
- Eigentümer und Weitergabe im Report klar dokumentieren.

### 3. Deutsche Startansicht erstellen

Die Startansicht muss beim App-Start sichtbar sein und mindestens enthalten:

- Projekttitel `Ticket Tamer`,
- verständliche deutsche Beschriftung für die Ticketanzahl,
- Regler,
- sichtbaren aktuellen Zahlenwert,
- Schaltfläche `Spiel starten`.

Keine Spielanleitung, kein Tutorial und keine zusätzlichen Modi ergänzen.

### 4. Ganzzahligen Regler umsetzen

Der Regler muss:

- Minimum aus `GameplayConstants.minimumTicketCount` verwenden,
- Maximum aus `GameplayConstants.maximumTicketCount` verwenden,
- Standardwert aus `GameplayConstants.defaultTicketCount` verwenden,
- ausschließlich ganzzahlige Werte erzeugen,
- den sichtbaren Zahlenwert unmittelbar aktualisieren,
- Werte an `SessionModel.setTicketCount(_:)` weitergeben,
- keine separaten, widersprüchlichen lokalen und modellseitigen Wahrheitsstände erzeugen.

Bevorzuge eine direkte, verständliche Binding-Lösung. Vermeide unnötige Konvertierungs- oder Synchronisationsschichten.

### 5. Technisch ungültige Werte absichern

Das Modell klemmt technisch ungültige Werte laut Modul 003 auf 1 bis 12. Modul 004 muss diese vorhandene Sicherung verwenden und darf sie nicht durch eine zweite konkurrierende Regel ersetzen.

Prüfe mindestens:

- Regler kann nur 1 bis 12 wählen,
- technisch gesetzter Wert unter 1 führt nicht zu einer Sitzung mit weniger als 1 Ticket,
- technisch gesetzter Wert über 12 führt nicht zu einer Sitzung mit mehr als 12 Tickets,
- sichtbarer Startwert ist 6.

### 6. „Spiel starten“ anbinden

Beim Auslösen der Schaltfläche:

- verwende die vorhandene `SessionModel.startSession()`-Schnittstelle,
- starte genau eine Sitzung,
- verwende keine eigene Ticketkopie und keine eigene Zufallsauswahl,
- verhindere keine gültige Auswahl von 1 oder 12 Tickets,
- erfinde keine Bewertung, Navigation oder Untersuchungslogik,
- dokumentiere das reale Verhalten der Phase nach dem Aufruf.

Falls eine minimale Phasenumschaltung für die Darstellung nötig ist, verwende ausschließlich `SessionModel.currentPhase` und die reale bestehende Modellsemantik. Ändere `SessionModel` nur, wenn ein klarer Defekt die Erfüllung von F-01 blockiert; eine solche Änderung ist als Nacharbeit aus Modul 003 getrennt auszuweisen.

### 7. Bestehende RealityKit-Grundlage schützen

- Genau ein volumetrisches Fenster bleibt erhalten.
- Kein zweites Fenster, Volume oder Immersive Space.
- Die vorhandene RealityKit-Standardszene darf als Platzhalter erhalten bleiben.
- Keine Monster-Assets oder MonsterProvider-Logik einführen.
- Keine räumlichen Interaktionen implementieren.

### 8. Lokalisierung fortführen

- Alle sichtbaren Texte sind Deutsch.
- Verwende den vorhandenen String Catalog.
- Ergänze nur tatsächlich benötigte Schlüssel.
- Verstreue keine mehrfach verwendeten sichtbaren Strings unnötig im Code.
- Keine englische sichtbare UI einführen.

### 9. Barrierefreiheit und Bedienbarkeit

Die Startansicht muss im vorgesehenen Volume gut lesbar sein.

Prüfe:

- eindeutige Labels,
- ausreichend große Schaltfläche,
- klar sichtbarer Zahlenwert,
- Regler ohne feinmotorisch unnötig präzise Schritte,
- sinnvolle Accessibility-Bezeichnungen für Regler und Schaltfläche,
- verständliche Bedienung ohne separate Anleitung.

Keine umfassende Designsystem- oder Branding-Arbeit vorwegnehmen.

### 10. DebugManager nutzen

- Verwende vorhandene Kategorien.
- Für Startschaltfläche und sichtbare UI-Aktionen ist `input` geeignet.
- Für relevante Modell-/Phasenbeobachtung ist `state` geeignet, sofern nötig.
- Ergänze keine neue Kategorie, wenn bestehende ausreichen.
- Keine `print()`-Aufrufe.
- Logge keine vollständigen Tickettexte.
- Dokumentiere alle neuen Logging-Stellen im Report.

### 11. Tests und Simulatorprüfung

Erhalte alle bisherigen Tests.

Prüfe automatisiert oder durch kleine, fachlich sinnvolle Ergänzungen mindestens:

- Standardwert des Modells bleibt 6,
- Grenzwerte 1 und 12 bleiben gültig,
- ungültige technische Werte bleiben geklemmt,
- Startaktion erzeugt die ausgewählte Anzahl Sitzungstickets.

Baue keine komplexe UI-Testinfrastruktur nur für dieses Modul auf, falls noch kein UI-Test-Target existiert. Die sichtbaren Bestandteile von AK-01 sind zusätzlich im visionOS-Simulator manuell zu prüfen.

Manuelle AK-01-Prüfung:

1. App neu starten.
2. Projekttitel, Regler, Wert 6 und „Spiel starten“ prüfen.
3. Regler schrittweise von 1 bis 12 bewegen.
4. Sicherstellen, dass keine Zwischenwerte sichtbar oder übernehmbar sind.
5. Sitzung mit 1 Ticket starten und Modellzustand prüfen.
6. App beziehungsweise Modell zurücksetzen und Sitzung mit 12 Tickets starten.
7. Technisch ungültige Werte unter 1 und über 12 über einen Test prüfen.
8. Bestätigen, dass kein zweites Fenster/Volume und kein Immersive Space erscheint.

### 12. Build und Abschlussprüfung

Am Ende müssen dokumentiert sein:

- App-Build erfolgreich oder ehrlich als nicht ausführbar markiert,
- visionOS-Simulatorstart erfolgreich oder ehrlich als nicht ausführbar markiert,
- tatsächliche Testzahl,
- alle Tests bestanden oder konkrete Fehler,
- Startansicht sichtbar,
- Standardwert 6,
- Regler nur 1 bis 12 in Ganzzahlschritten,
- Startschaltfläche sichtbar und funktionsfähig,
- `SessionModel` als einzige Zustandsquelle,
- keine Untersuchungsphase oder spätere Funktion vorweggenommen,
- genau ein zentrales Volume,
- kein zweites Fenster/Volume,
- kein Immersive Space.

## Bestehende Dateien schützen

Ändere nur, was für F-01 und AK-01 notwendig ist.

Besonders konfliktanfällig:

- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Nicht ändern, sofern kein klarer Defekt vorliegt:

- Ticketinhalte,
- `TicketPriority`,
- `SupportTeam`,
- `LocalTicketCatalog`,
- RealityKitContent-Dateien,
- `Info.plist`,
- Volume-Rolle.

## Bekannte offene Punkte, die nicht zu Modul 004 gehören

- `monsterAssetId` fehlt gegenüber der SPEC-Architekturskizze.
- Tickettexte verwenden teilweise `ae`, `oe`, `ue`.
- `.DS_Store`-Dateien müssen später kontrolliert bereinigt werden.
- Ergebnis-Reset-UI gehört zu Modul 011.
- Vollständige Geräteprüfung gehört zu Modul 013.

Bearbeite diese Punkte nicht stillschweigend.

## Dokumentationspflicht

- `///`-Doc-Kommentare an jedem neuen Typ und jeder für Folgemodule nutzbaren Methode,
- `// MARK: -` zur Gliederung,
- Warum-Kommentare an nicht offensichtlichen Binding- oder Observation-Stellen,
- keine Kommentare, die nur den Code wiederholen,
- exakte Pfade und Target-Zugehörigkeiten im Report.

## Git

Vorgesehener Commit:

`004: Startansicht und Einstellungen`

Erfinde keinen Hash. Dokumentiere den tatsächlichen Branch, die Commit-Nachricht und den Hash nur, wenn sie wirklich vorliegen.

## Ausgabeformat

Gib die Ergebnisse in dieser Reihenfolge aus:

1. **Vorab-Check**
   - Branch und Commit,
   - realer Dateibaum,
   - Build- und Simulatorstatus,
   - tatsächliche Test-Suites und Testzahl,
   - Auflösung der Testanzahl-Inkonsistenz aus Modul 003,
   - reales Verhalten von `SessionModel.startSession()`.

2. **UI- und Zustandsentwurf**
   - Eigentümer der einzigen `SessionModel`-Instanz,
   - Weitergabe an Views,
   - Startansicht und Verantwortungsgrenzen,
   - Binding des Reglers,
   - Verhalten der Startschaltfläche,
   - begründete Abgrenzung zur Untersuchungsphase.

3. **Änderungen einzeln ausgewiesen**
   Zu jeder Datei:
   - exakter Pfad,
   - neu, ergänzt, ersetzt, verschoben oder entfernt,
   - Target-Mitgliedschaft,
   - genauer Einbauort,
   - Begründung mit Bezug zu F-01 und AK-01.

4. **Test- und Simulatoranleitung**
   - automatisierte Tests,
   - manuelle AK-01-Prüfung,
   - tatsächliche Ergebnisse,
   - Bestätigung des einzigen Volumes.

5. **Vollständiger `004-Report.md` nach der Modul-Report-Vorlage**
   Der Report muss zusätzlich enthalten:
   - tatsächlichen Dateibaum nach Modul 004,
   - alle neuen, geänderten, verschobenen und entfernten Dateien,
   - Eigentümer und Bereitstellung von `SessionModel`,
   - verwendete Lokalisierungsschlüssel,
   - Reglerbereich, Schrittweite und Binding,
   - Verhalten von „Spiel starten“,
   - tatsächliche Testanzahl und Auflösung der Report-Inkonsistenz aus Modul 003,
   - Build-, Simulator- und Testergebnis,
   - DebugManager-Nutzung,
   - klare Bestätigung, dass keine Untersuchungsphase oder spätere Funktion umgesetzt wurde,
   - offene Risiken,
   - Empfehlung für Modul 005.

Baue nichts außerhalb dieses Moduls um. Wenn eine Schnittstelle aus Modul 005 oder später benötigt zu werden scheint, dokumentiere sie als offenen Punkt, statt sie vorwegzunehmen.
