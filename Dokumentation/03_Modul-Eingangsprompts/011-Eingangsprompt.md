# Modul-Eingangsprompt — 011 Ergebnis und Neustart

> Vom Projektlogbuch nach Einarbeitung des `010-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 011.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git-, Xcode-, Test- und Gameplay-Stand. Implementiere ausschließlich die Ergebnisansicht und den vollständigen Neustart.

## Modul

**Nummer:** 011  
**Titel:** Ergebnis und Neustart

**Ziel:** Wenn `GamePhase.ergebnis` erreicht ist, zeigt das zentrale Volume ausschließlich die Gesamtpunktzahl als Zahl und die Schaltfläche „Erneut spielen“. Die Schaltfläche ruft den bestehenden vollständigen Reset auf und führt zurück zur Startansicht mit Ticketanzahl 6.

## Verbindliche Anforderungen

### F-15

> Die Ergebnisansicht zeigt ausschließlich die Gesamtpunktzahl als Zahl und die Schaltfläche „Erneut spielen“.

### F-16

> „Erneut spielen“ verwirft den vollständigen Sitzungszustand, kehrt zur Startansicht zurück und setzt die Ticketanzahl auf 6 zurück.

### AK-15 — Ergebnisansicht

- GEGEBEN die letzte Teamentscheidung wurde abgeschlossen, WENN die Ergebnisphase erscheint, DANN ist die Gesamtpunktzahl sichtbar.
- Außer der Gesamtpunktzahl und „Erneut spielen“ werden keine Detailstatistiken, Lösungen, Badges oder Rankings angezeigt.

### AK-16 — Neustart und Reset

- GEGEBEN die Ergebnisansicht ist sichtbar, WENN „Erneut spielen“ ausgelöst wird, DANN erscheint wieder die Startansicht.
- Der Ticketregler steht wieder auf 6.
- Score, Ticketindex, Entscheidungen und vorherige Sitzungstickets sind verworfen.
- Nach mindestens fünf aufeinanderfolgenden Neustarts bleibt die App stabil und übernimmt keine Punkte oder alten Entscheidungen.

## Zwingende Scope-Regel

Die Empfehlung im `010-Report.md`, zusätzlich Ticketanzahl oder Ticket-für-Ticket-Statistik zu zeigen, ist **nicht zulässig**.

Die Ergebnisansicht enthält ausschließlich:

1. Gesamtpunktzahl als Zahl
2. „Erneut spielen“

Nicht anzeigen:

- Ticketanzahl
- „von X Tickets“
- Maximalpunktzahl
- Prozentwert
- Prioritäts-/Teamtreffer
- Ticket-für-Ticket-Statistik
- richtige Lösungen
- Falschentscheidungen
- Rang
- Badge
- Highscore
- Zeit
- Verlauf

## Verbindlicher Vorab-Check

### Git

Ermittle:

- aktuellen Branch
- aktuellen Commit
- ob `0ab0ef7` enthalten ist
- tatsächlichen Modul-010-Stand
- Working-Tree-Status

### Build / Tests / Simulator

Vor Modul 011 sind laut Report offen:

- Build nach Modul 010
- vollständiger Testlauf der 140 Tests
- Audiohörbarkeit
- Prioritäts-/Team-Gesten-End-to-End
- 1,5-Sekunden-Transitions

Führe nach Möglichkeit vor Änderungen aus:

- App-Build
- gesamte Test-Suite
- Simulatorstart

Dokumentiere echte Ergebnisse.

### End-to-End-Vorprüfung

Wenn Simulator verfügbar, prüfe mindestens eine 1-Ticket-Sitzung:

1. Start
2. Untersuchung
3. Priorisierung
4. Sound / 1,5 s
5. Team
6. Sound / 1,5 s
7. `.ergebnis`

Prüfe dabei:

- richtige Lösung wird nie angezeigt
- Score korrekt
- kein zweites Volume
- keine Hänger

## Aktueller technischer Stand

Vorhanden:

- `GamePhase.ergebnis`
- `SessionModel.score`
- `SessionModel.reset()`
- `GameplayConstants.defaultTicketCount == 6`
- `RootVolumeView` zeigt für `.ergebnis` aktuell nur einen neutralen Placeholder

### Reset laut bisherigem Modellstand

`SessionModel.reset()` soll auf folgende Werte zurücksetzen:

- `selectedTicketCount = 6`
- `sessionTickets = []`
- `currentTicketIndex = 0`
- `currentPhase = .start`
- `score = 0`
- `selectedPriority = nil`
- `selectedTeam = nil`
- `isInputLocked = false`

Seit Modul 010 existieren zusätzlich interne Bewertungsflags. Prüfe, dass `reset()` auch diese löscht.

## Verbindliche Modulgrenze

Modul 011 bearbeitet ausschließlich:

- neue Ergebnisansicht
- Root-Routing für `.ergebnis`
- sichtbare Gesamtpunktzahl
- „Erneut spielen“
- Aufruf von `SessionModel.reset()`
- Tests für Ergebnis-/Resetlogik
- Simulatorprüfung

Nicht bearbeiten:

- Scoring-Regeln
- Audio
- Priorisierungslogik
- Teamlogik
- Monster-Assets
- Monsteranimation
- Detailstatistiken
- Persistenz
- Highscores
- Accounts
- Cloud

## Konkreter Arbeitsauftrag

### 1. Ergebnisansicht erstellen

Erstelle eine klar benannte View, beispielsweise `ResultView`.

Sie erhält den Zustand aus dem bestehenden `SessionModel`.

Sichtbar sind genau:

- `score` als Zahl
- „Erneut spielen“

Der Score darf typografisch hervorgehoben werden.

Bevorzuge tatsächlich nur diese beiden sichtbaren Elemente.

### 2. Scoreanzeige

Die sichtbare Gesamtpunktzahl stammt ausschließlich aus:

`SessionModel.score`

Keine Neuberechnung in der View.

Nicht sichtbar:

- „Punkte“
- „Score“
- Maximalwert
- Ticketzahl

Accessibility-Labels sind zulässig, sofern sie keine zusätzliche sichtbare Statistik erzeugen.

### 3. „Erneut spielen“

Buttontext exakt deutsch:

`Erneut spielen`

Aktion:

`model.reset()`

Keine zusätzliche Session-Initialisierung.

Nach Reset muss durch `currentPhase = .start` automatisch wieder `StartView` erscheinen.

### 4. Root-Routing

Erweitere:

`.ergebnis → ResultView`

Entferne dort den bisherigen neutralen Ergebnis-Placeholder.

Andere Phasen nicht umbauen.

### 5. Vollständigen Reset real prüfen

Nach `reset()` müssen sicher sein:

- Ticketanzahl 6
- leere `sessionTickets`
- Index 0
- Phase `.start`
- Score 0
- Priorität nil
- Team nil
- Input nicht gesperrt
- Prioritäts-Bewertungsflag false
- Team-Bewertungsflag false
- keine alten Feedback-Tasks beeinflussen die neue Sitzung

Wenn Modul 010 noch keine Task-Cancellation gegen einen schnellen Reset absichert, prüfe real, ob ein laufender alter Feedback-Task nach Reset später die Phase wieder verändert.

Falls ein solcher Defekt existiert, darf Modul 011 eine **minimale Reset-Sicherheitskorrektur** vornehmen und muss sie klar als Carry-over aus Modul 010 dokumentieren.

Keine allgemeine Task-Architektur neu bauen.

### 6. Fünf Neustarts

Teste mindestens fünf aufeinanderfolgende Zyklen:

- Ergebnis
- Erneut spielen
- Start
- neue Sitzung
- Ergebnis

Nach jedem Reset:

- Score 0
- Ticketanzahl 6
- keine alte Entscheidung
- keine alte Sitzung
- keine Phasenfehler

### 7. Startregler nach Reset

Da die Startansicht direkt an `SessionModel.selectedTicketCount` gebunden ist, muss nach `reset()` sichtbar wieder 6 erscheinen.

Keinen separaten lokalen UI-Wert setzen.

### 8. Keine Persistenz

Nicht ergänzen:

- UserDefaults
- AppStorage
- Datei
- Datenbank
- Cloud
- Highscore

### 9. DebugManager

Bestehende Kategorien reichen.

Geeignet:

- `.lifecycle`: Ergebnisansicht erscheint
- `.input`: „Erneut spielen“
- `.state`: Reset abgeschlossen

Keine neue Kategorie.

## Automatisierte Tests

Erhalte alle bestehenden 140 Testdeklarationen.

Ergänze mindestens:

1. Ergebnisphase behält finalen Score
2. Reset aus Ergebnis → `.start`
3. Reset setzt Ticketanzahl auf 6
4. Reset leert `sessionTickets`
5. Reset setzt Index 0
6. Reset setzt Score 0
7. Reset setzt `selectedPriority = nil`
8. Reset setzt `selectedTeam = nil`
9. Reset setzt `isInputLocked = false`
10. Reset löscht Prioritäts-Bewertungsflag indirekt nachweisbar
11. Reset löscht Team-Bewertungsflag indirekt nachweisbar
12. fünf aufeinanderfolgende Resets bleiben stabil
13. nach Reset kann neue Sitzung korrekt gestartet werden
14. neue Sitzung übernimmt keine alten Punkte
15. neue Sitzung übernimmt keine alten Entscheidungen

Kein neues komplexes UI-Test-Target nur für dieses Modul.

## Simulatorprüfung

### Ergebnisansicht

Prüfe:

- nur Scorezahl sichtbar
- „Erneut spielen“ sichtbar
- keine Ticketanzahl
- keine Statistik
- keine Lösung
- keine Badges
- keine Rangliste

### Reset

Nach Button:

- Startansicht sichtbar
- Regler 6
- Score intern 0
- keine alte Auswahl
- keine alte Sitzung

### Fünf Wiederholungen

Mindestens fünf Neustarts durchführen.

### End-to-End

Mindestens:

- 1 Ticket
- 2 Tickets
- 6 Tickets

Bis Ergebnis spielen und jeweils Reset prüfen.

## Bestehende Dateien schützen

Voraussichtlich relevant:

- neue `Views/ResultView.swift`
- `Views/RootVolumeView.swift`
- `Models/SessionModel.swift` nur bei nachgewiesenem Reset-Defekt
- `Resources/Localizable.xcstrings` nur für `Erneut spielen`, falls noch nicht vorhanden
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Nach Möglichkeit unverändert:

- `PrioritizationView.swift`
- `TeamAssignmentView.swift`
- `InvestigationView.swift`
- `StartView.swift`
- `AudioService.swift`
- Scoringlogik
- Ticketdaten
- Monster-Pipeline
- Interaction-Services

## Audio / Blender außerhalb des Moduls

Nicht als Teil von 011 lösen:

- finale Audioqualität
- finale Blender-Monster

Dokumentiere deren offenen Status nur weiter.

## Git

Vorgesehener Commit:

`011: Ergebnis und Neustart`

Erfinde keinen Hash.

## Ausgabeformat

1. **Vorab-Check**
   - Branch/Commit
   - Build/Test/Simulator
   - 140-Test-Stand
   - End-to-End-Modul-010-Prüfung

2. **Ergebnisansicht**
   - View
   - sichtbare Elemente
   - Scorequelle
   - Accessibility

3. **Reset**
   - tatsächliche `reset()`-Semantik
   - Bewertungsflags
   - Task-Sicherheit
   - fünf Neustarts

4. **Änderungen je Datei**
   - Pfad
   - Art
   - Target
   - Zweck
   - Bezug F-15/F-16/AK-15/AK-16

5. **Tests und Simulatorprüfung**
   - Testzahl vor/nach
   - Testergebnis
   - Ergebnisansicht
   - Reset
   - mehrere Sitzungen

6. **Vollständiger `011-Report.md` nach der Modul-Report-Vorlage**

Der Report muss zusätzlich enthalten:

- tatsächlichen Dateibaum
- alle neuen/geänderten Dateien
- sichtbare Inhalte der Ergebnisansicht
- Bestätigung: **keine Ticketanzahl und keine Detailstatistik**
- `reset()`-Semantik
- eventuelle Carry-over-Korrektur aus Modul 010
- DebugManager-Nutzung
- Build-/Simulator-/Testergebnis
- Status F-15/F-16
- Status AK-15/AK-16
- offene Audio-/Blender-Punkte
- Empfehlung für Modul 012 beziehungsweise direkt 013, falls F-17 ausgelassen wird

Baue nichts außerhalb dieses Moduls um.
