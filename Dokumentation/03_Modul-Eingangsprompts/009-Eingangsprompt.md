# Modul-Eingangsprompt — 009 Teamzuordnungsphase

> Vom Projektlogbuch nach Einarbeitung des `008-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 009 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git-, Xcode-, Test- und RealityKit-Stand. Implementiere ausschließlich die **Teamzuordnungsphase** gemäß F-09 auf Basis der bestehenden generischen Drag-/Drop-Grundlage und des Prioritätsspeichermusters aus Modul 008.

Erfinde keine vorhandenen Dateien, Commit-Hashes, Build-Ergebnisse, Testresultate oder Simulatorerfolge.

## Modul

**Nummer:** 009  
**Titel:** Teamzuordnungsphase  
**Ziel:** In `GamePhase.teamZuordnen` sieht die nutzende Person das aktuelle Ticket-Monster und genau vier klar beschriftete räumliche Teamstationen `Netzwerk`, `Konto`, `Software` und `Hardware`. Das Monster kann per Blickfokus, Pinch und Drag auf genau eine Station abgelegt werden; ein gültiger Drop speichert genau ein `SupportTeam` im `SessionModel` und sperrt weitere Eingaben. Ein ungültiger Drop verändert keine Entscheidung.

## Verbindliche Anforderungen

### SPEC F-09

> In der Teamzuordnungsphase kann die nutzende Person das Monster mit Blickfokus, Pinch und Drag auf genau eine der beschrifteten Stationen Netzwerk, Konto, Software oder Hardware bewegen und dort ablegen.

### AK-09 — Räumliche Teamzuordnung

- GEGEBEN die Teamzuordnungsphase ist aktiv, WENN das Monster per Blickfokus, Pinch und Drag auf Netzwerk, Konto, Software oder Hardware gezogen und dort losgelassen wird, DANN wird genau dieses Team gespeichert.
- Alle vier Teamstationen sind eindeutig mit den deutschen Bezeichnungen „Netzwerk“, „Konto“, „Software“ und „Hardware“ beschriftet.
- Pro Ticket kann höchstens eine Teamentscheidung gewertet werden.

### Relevanter AK-10-Anteil

- Ungültiger Drop verändert weder Entscheidung noch Punkte noch Phase.
- Gültiger Drop speichert die Entscheidung genau einmal und sperrt weitere Eingaben.
- Weitere Gesten während `isInputLocked == true` dürfen die Entscheidung nicht verändern.

## Verbindliche Modulgrenze

Modul 009 bearbeitet ausschließlich:

- `TeamAssignmentView`,
- vier räumliche Teamstationen,
- deutsche Labels Netzwerk/Konto/Software/Hardware,
- Monsterladen für das aktuelle Ticket,
- Wiederverwendung von `MonsterInteractionConfigurator`,
- Wiederverwendung von `DropEvaluator`,
- Mapping technische Ziel-ID → `SupportTeam`,
- kontrolliertes Speichern genau einer Teamentscheidung,
- Input-Lock nach gültigem Teamdrop,
- ungültige Drops ohne Zustandsänderung,
- kontrollierte Modell-Schnittstelle zum Eintritt in `.teamZuordnen`,
- Tests und Simulatorprüfung für F-09 / AK-09 / Teamanteil AK-10.

Modul 009 bearbeitet ausdrücklich nicht:

- Bewertung gegen `referenceTeam`,
- Bewertung gegen `referencePriority`,
- Punkte,
- Erfolgssound,
- Fehlersound,
- Anzeige der richtigen Lösung,
- automatische 1,5-Sekunden-Weiterleitung,
- automatischer Wechsel zum nächsten Ticket,
- Ergebnisansicht,
- Monsterreaktionen,
- neue Blender-Modellierung.

## Besonders wichtig: Übergang zur Teamphase

Modul 008 speichert die Priorität absichtlich, **ohne** die Phase automatisch zu wechseln. Das entspricht der Modulgrenze, weil F-13 den automatischen Übergang nach ungefähr 1,5 Sekunden Modul 010 zuordnet.

Modul 009 darf deshalb eine kontrollierte `SessionModel.beginTeamAssignmentPhase()`-Methode bereitstellen, aber sie **nicht im normalen Release-Spielablauf automatisch oder zeitgesteuert auslösen**.

Diese Methode ist eine Schnittstelle für:

- Modul 010 nach Abschluss von Bewertung/Audio/Delay,
- Unit-Tests,
- gegebenenfalls eine klar DEBUG-only Simulatorprüfung in Modul 009.

Keinen normalen Nutzer-Button „Weiter zum Team“ einführen.

## Verbindlicher Vorab-Check

### 1. Git

Ermittle:

- aktuellen Branch,
- aktuellen Commit,
- ob `200093b` enthalten ist,
- ob der 008-Fix inzwischen committed wurde,
- Fix-Hash, falls vorhanden,
- ob `.git/index.lock` noch ein Problem darstellt,
- tatsächlichen Modul-007-Commit, falls er inzwischen aus Git eindeutig ermittelbar ist.

Der 008-Fix darf nicht als committed behauptet werden, wenn kein Hash vorliegt.

### 2. Quellstand

Prüfe real:

- `Views/PrioritizationView.swift`
- `Models/SessionModel.swift`
- `Views/RootVolumeView.swift`
- `Components/DropTargetComponent.swift`
- `Services/DropEvaluator.swift`
- `Services/MonsterInteractionConfigurator.swift`
- `Assets/MonsterAssetProvider.swift`
- `Support/AppConstants.swift`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Prüfe außerdem:

- tatsächliche `savePriority(_:)`-Semantik,
- tatsächlichen `isInputLocked`-Lebenszyklus,
- ob `.teamZuordnen` weiterhin nur den neutralen Placeholder zeigt.

### 3. Build und Tests

Vor Modul 009 sind gemeldet:

- Build Modul 008: bestätigt,
- Simulatorstart: bestätigt,
- 86 Testdeklarationen,
- vollständiger Testlauf: offen.

Führe nach Möglichkeit vor Änderungen aus:

- App-Build,
- vollständige 86-Test-Suite,
- Simulatorstart.

Dokumentiere echte Ergebnisse.

### 4. Offene Priorisierungs-Gestenprüfung

Wenn Simulator verfügbar, prüfe vor Teamarbeit:

- Drag auf Normal,
- Drag auf Wichtig,
- Drag auf Kritisch,
- ungültiger Drop,
- Input-Lock,
- erneutes Ziehen während Lock.

Diese Prüfung ist Regression/Abnahme für Modul 008 und soll nicht zu unnötigen Umbauten führen.

## Relevanter bestehender technischer Stand

### `SupportTeam`

Vorhanden:

- `.netzwerk`
- `.konto`
- `.software`
- `.hardware`
- `displayName`

### `SessionModel`

Relevant:

- `currentPhase`
- `currentTicket`
- `currentTicketIndex`
- `selectedPriority`
- `selectedTeam`
- `score`
- `isInputLocked`
- `savePriority(_:)`
- `lockInput()`
- `unlockInput()`

`selectedTeam` ist `private(set)`; eine fachliche Speichermethode existiert laut aktuellem Stand noch nicht.

### Interaktion

Wiederzuverwenden:

- `DropTargetComponent`
- `DropEvaluator`
- `MonsterInteractionConfigurator.configure(_:mode: .dragDrop)`
- `MonsterAssetProvider.loadMonster(assetID:)`

Keine zweite Interaktionsarchitektur bauen.

## Konkreter Arbeitsauftrag

### 1. `beginTeamAssignmentPhase()` ergänzen

Ergänze eine schmale, kontrollierte SessionModel-Methode.

Empfohlene Semantik:

Vorbedingungen:

- `currentPhase == .priorisieren`,
- `selectedPriority != nil`.

Effekte:

- `currentPhase = .teamZuordnen`,
- `selectedTeam = nil` beziehungsweise bleibt `nil`,
- Input wird für die neue Teamentscheidung freigegeben,
- `currentTicketIndex` bleibt unverändert,
- `currentTicket` bleibt dasselbe,
- `score` bleibt unverändert,
- gespeicherte `selectedPriority` bleibt erhalten.

Ungültiger Aufruf:

- No-Op.

### 2. Kein automatischer Aufruf

`beginTeamAssignmentPhase()` darf in Modul 009 **nicht** aus `savePriority(_:)`, `PrioritizationView`, Timer oder `onAppear` automatisch aufgerufen werden.

Der normale Ablauf bleibt bis Modul 010 nach einer Prioritätsentscheidung stehen und gesperrt.

Für die manuelle Entwicklung/Prüfung der Teamphase sind zulässig:

- Unit-Tests, die die Methode direkt aufrufen,
- SwiftUI Preview,
- klarer `#if DEBUG`-Entwicklungsweg.

Falls ein DEBUG-Button verwendet wird:

- eindeutig als Development-Hilfe,
- nicht im Release-Build,
- nicht als Teil der F-09-Benutzeroberfläche,
- im Report dokumentieren.

### 3. `TeamAssignmentView` erstellen

Erstelle eine klar benannte View für `.teamZuordnen`.

Sie enthält:

- aktuelles Ticket-Monster,
- genau vier räumliche Stationen,
- sichtbare deutsche Labels:
  - Netzwerk
  - Konto
  - Software
  - Hardware.

Keine Prioritätsziele in dieser View.

### 4. Root-Routing erweitern

`RootVolumeView`:

- `.start` → `StartView`
- `.untersuchen` → `InvestigationView`
- `.priorisieren` → `PrioritizationView`
- `.teamZuordnen` → `TeamAssignmentView`
- `.ergebnis` → weiterhin neutraler Placeholder

Keine Ergebnisansicht vorziehen.

### 5. Vier Teamstationen definieren

Erstelle genau vier technische Zieldefinitionen.

Empfohlene IDs:

- `team_netzwerk`
- `team_konto`
- `team_software`
- `team_hardware`

Die sichtbaren Labels stammen aus `SupportTeam.displayName` oder einer gleichwertigen zentralen deutschen Darstellung.

Keine fünfte Station.

### 6. Mapping Ziel-ID → `SupportTeam`

Kapsle das Mapping in einer kleinen Struktur analog zu `PriorityTargetMapping`.

Beispiel:

`TeamTargetMapping`

Verantwortung:

- alle vier Zieldefinitionen,
- `team(for:)`.

Keine verstreuten Switches oder Stringvergleiche in mehreren Views.

### 7. `saveTeam(_:)` im SessionModel

Ergänze eine fachliche atomare Speichermethode.

Vorbedingungen:

- `currentPhase == .teamZuordnen`,
- `selectedTeam == nil`,
- `isInputLocked == false`.

Effekte:

- `selectedTeam = team`,
- Input wird gesperrt.

Unverändert:

- `selectedPriority`,
- `score`,
- `currentTicketIndex`,
- `currentPhase`.

No-Op bei:

- falscher Phase,
- bereits gespeichertem Team,
- bereits gesperrter Eingabe.

### 8. Teamphase betritt einen entsperrten Zustand

`beginTeamAssignmentPhase()` soll die Eingabe kontrolliert für die neue Entscheidung freigeben.

Vermeide einen generischen `onAppear { unlockInput() }`, der bei View-Refresh nach einer bereits gespeicherten Teamentscheidung den Lock wieder öffnen könnte.

Nach `saveTeam(_:)` darf kein View-Refresh die Eingabe entsperren.

### 9. Monster laden und Drag aktivieren

Nutze:

- `MonsterAssetProvider.loadMonster(assetID:)`,
- `MonsterInteractionConfigurator.configure(_:mode: .dragDrop)`.

Keine Duplikation der Collision-/Hover-/Gesture-Grundlage.

### 10. Ungültiger Drop

Bei ungültigem Drop:

- `selectedTeam` bleibt `nil` beziehungsweise unverändert,
- `selectedPriority` bleibt erhalten,
- `score` unverändert,
- `currentPhase` bleibt `.teamZuordnen`,
- `currentTicketIndex` unverändert,
- `isInputLocked` bleibt false,
- Monster kehrt zur Ausgangsposition zurück.

### 11. Gültiger Drop

Ablauf:

1. `DropEvaluator` liefert die Team-Ziel-ID.
2. `TeamTargetMapping` mappt auf `SupportTeam`.
3. `saveTeam(_:)` speichert genau einmal.
4. Input wird gesperrt.
5. Weitere Drag-/Release-Versuche werden ignoriert.

Noch nicht:

- gegen `referenceTeam` vergleichen,
- Punkte vergeben,
- Sound,
- Lösung anzeigen,
- automatisch nächstes Ticket öffnen.

### 12. Kein Übergang nach dem Teamdrop

Nach gültiger Teamentscheidung bleibt die Phase in Modul 009 `.teamZuordnen`.

Der automatische Übergang zum nächsten Ticket beziehungsweise Ergebnis wird erst in Modul 010/011 zusammen mit Bewertung und F-13 sauber gesteuert.

Keinen „Weiter“-Button einführen.

### 13. Teamstations-Layout

Vier Ziele müssen:

- klar voneinander getrennt,
- gut lesbar,
- ohne feinmotorisch präzises Ablegen erreichbar,
- innerhalb des zentralen Volumes angeordnet sein.

Bevorzuge ein einfaches 2×2-Layout oder eine ähnlich klare räumliche Anordnung.

Wichtig:

- Label und Station müssen eindeutig zusammengehören,
- kein Label darf verdeckt sein,
- die Priorisierungsprobleme aus Modul 008 mit unsichtbaren Attachments sollen nicht wiederholt werden.

Wenn SwiftUI-Overlay-Labels die stabilere Lösung sind, darf dasselbe Muster wie nach dem 008-Fix verwendet werden.

### 14. Farben

Farben dürfen die vier Teamstationen visuell unterscheidbar machen, sind aber keine fachliche Lösungshilfe.

Keine Farbe darf suggerieren:

- richtig/falsch,
- besser/schlechter,
- kritisch/normal.

Die Teamentscheidung basiert auf Label und Ticketinhalt, nicht auf einem Bewertungssignal.

### 15. Fehlerzustände

Bei fehlendem Ticket oder Monsterladefehler:

- kein Crash,
- keine Teamentscheidung,
- keine Punkte,
- keine automatische Phase.

Bestehende lokale Fehlerdarstellungsmuster wiederverwenden, wenn sinnvoll.

### 16. DebugManager

Bestehende Kategorien:

- `.spawning`: Monster/Stationen,
- `.input`: Drag/Release,
- `.physics`: Drop-Auswertung,
- `.state`: Team gespeichert / Phase gewechselt / Lock.

Keine neue Kategorie.

Nicht loggen:

- `referenceTeam`,
- ob die Teamwahl richtig oder falsch ist.

Bewertung gehört Modul 010.

## Automatisierte Tests

Erhalte alle bestehenden 86 Testdeklarationen.

Ergänze mindestens Tests für `beginTeamAssignmentPhase()`:

1. gültiger Wechsel `.priorisieren → .teamZuordnen`,
2. gespeicherte Priorität bleibt erhalten,
3. Ticketindex bleibt gleich,
4. Score bleibt gleich,
5. Input ist für Teamphase entsperrt,
6. Wechsel ohne gespeicherte Priorität wird ignoriert,
7. Wechsel aus falscher Phase wird ignoriert.

Tests für `saveTeam(_:)`:

8. Netzwerk speicherbar,
9. Konto speicherbar,
10. Software speicherbar,
11. Hardware speicherbar,
12. Teamdrop setzt Input-Lock,
13. zweiter Team-Speicherversuch wird ignoriert,
14. erstes Team wird nicht überschrieben,
15. Speichern außerhalb `.teamZuordnen` wird ignoriert,
16. Score bleibt unverändert,
17. Priorität bleibt unverändert,
18. Ticketindex bleibt unverändert,
19. Phase bleibt nach Speicherung `.teamZuordnen`.

Mapping:

20. genau vier Teamziele,
21. Ziel-IDs eindeutig,
22. Mapping deckt genau alle vier `SupportTeam`-Werte ab,
23. unbekannte Ziel-ID liefert kein Team.

Zusätzlich bestehende AK-10-Regressionssemantik beibehalten.

## Simulatorprüfung

Wenn möglich:

### Vorprüfung Priorität

- einen Prioritätsdrop erfolgreich durchführen,
- Lock bestätigen.

### DEBUG-Teamphase öffnen

Da Modul 010 den automatischen Übergang noch nicht implementiert, Teamphase nur über den dokumentierten Development-Weg öffnen.

Dann vier getrennte Testläufe:

#### Netzwerk

- Label sichtbar,
- Drop speichert `.netzwerk`,
- Lock gesetzt.

#### Konto

- `.konto`.

#### Software

- `.software`.

#### Hardware

- `.hardware`.

Zusätzlich:

- ungültiger Drop → kein Team,
- Priorität bleibt erhalten,
- Score bleibt 0/unverändert,
- Phase bleibt `.teamZuordnen`,
- erneutes Ziehen während Lock wirkungslos,
- alle vier Labels gut lesbar,
- genau ein zentrales Volume.

## Bestehende Dateien schützen

Voraussichtlich relevant:

- neue `Views/TeamAssignmentView.swift`,
- `Views/RootVolumeView.swift`,
- `Models/SessionModel.swift`,
- `Support/AppConstants.swift`,
- ggf. `Resources/Localizable.xcstrings`,
- `Ticket_TamerTests/Ticket_TamerTests.swift`.

Wiederverwenden:

- `DropTargetComponent.swift`,
- `DropEvaluator.swift`,
- `MonsterInteractionConfigurator.swift`,
- `MonsterAssetProvider.swift`.

Nach Möglichkeit unverändert:

- `PrioritizationView.swift`,
- `InvestigationView.swift`,
- `StartView.swift`,
- `Ticket.swift`,
- `LocalTicketCatalog.swift`,
- `GamePhase.swift`,
- `Info.plist`.

Wenn für einen DEBUG-Teamphase-Einstieg eine kleine Development-Datei nötig ist, halte sie unter `Views/Debug/` und dokumentiere sie.

## 008-Fix schützen

Prüfe, ob der visuelle 008-Fix tatsächlich im aktuellen Code und Git enthalten ist:

- sichtbare Prioritätskugeln,
- Labels als Overlay.

Modul 009 darf diesen Fix nicht versehentlich zurückdrehen.

## Keine Bewertung in Modul 009

Auch wenn `Ticket.referenceTeam` vorhanden ist:

**nicht vergleichen.**

Nicht implementieren:

- richtig/falsch,
- +100,
- 0 Punkte,
- Audio,
- Lösungsausgabe,
- zeitgesteuerten Übergang.

Alles gehört Modul 010.

## Bekannte offene Punkte außerhalb des Moduls

- vier finale Blender-Monster fehlen,
- vollständige F-14/AK-14-Abnahme offen,
- Bewertung/Audio/Auto-Transition folgt Modul 010,
- Ergebnis/Reset folgt Modul 011,
- `.DS_Store`-Bereinigung nicht Teil dieses Moduls.

## Git

Vorgesehener Commit:

`009: Teamzuordnungsphase`

Erfinde keinen Hash.

Wenn der 008-Fix vor Modul 009 noch uncommitted ist, committe beziehungsweise dokumentiere ihn getrennt; vermische ihn nicht stillschweigend mit dem 009-Commit.

## Ausgabeformat

1. **Vorab-Check**
   - Branch/Commit,
   - 008-Hauptcommit und Fix-Commit,
   - `.git/index.lock`,
   - Build-/Simulator-/Teststatus,
   - tatsächliche Testzahl,
   - Gestenprüfung Modul 008.

2. **Teamphasen-Entwurf**
   - `TeamAssignmentView`,
   - vier Stationen,
   - Ziel-IDs,
   - Layout,
   - Labels,
   - Mapping.

3. **SessionModel-Erweiterung**
   - `beginTeamAssignmentPhase()`,
   - `saveTeam(_:)`,
   - Vorbedingungen,
   - Lock-/Unlock-Semantik,
   - garantierte unveränderte Felder.

4. **Development-Zugang**
   - wie `.teamZuordnen` vor Modul 010 manuell geprüft wird,
   - DEBUG-only oder Preview,
   - keine Release-Nutzerfunktion.

5. **Drag-/Drop-Integration**
   - Wiederverwendung der Modul-007-Schnittstellen,
   - gültiger Drop,
   - ungültiger Drop,
   - Mehrfachinteraktion.

6. **Änderungen je Datei**
   - Pfad,
   - Art,
   - Target,
   - Zweck,
   - Bezug zu F-09/AK-09/AK-10.

7. **Tests und Simulatorprüfung**
   - Testzahl vor/nach,
   - Testergebnis,
   - alle vier Teams,
   - Invalid-Drop,
   - Lock,
   - Erhalt der Prioritätsentscheidung.

8. **Vollständiger `009-Report.md` nach der Modul-Report-Vorlage**

Der Report muss zusätzlich enthalten:

- tatsächlichen Dateibaum,
- alle neuen/geänderten Dateien,
- Ziel-IDs und Mapping,
- `beginTeamAssignmentPhase()`-Semantik,
- `saveTeam(_:)`-Semantik,
- Development-Zugang vor Modul 010,
- DebugManager-Nutzung,
- Build-/Simulator-/Testergebnis,
- Status AK-09,
- Status AK-10 nach Prioritäts- und Teamanteil,
- klare Bestätigung, dass keine Bewertung, Punkte, Audio oder automatische Übergänge implementiert wurden,
- Status der Blender-Monster,
- Git-Status des 008-Fixes,
- offene Risiken,
- Empfehlung für Modul 010.

Baue nichts außerhalb dieses Moduls um.
