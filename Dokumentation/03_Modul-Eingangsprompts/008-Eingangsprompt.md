# Modul-Eingangsprompt — 008 Priorisierungsphase

> Vom Projektlogbuch nach Einarbeitung des `007-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 008 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git-, Xcode-, Test- und RealityKit-Stand. Implementiere ausschließlich die **Priorisierungsphase** auf Basis der vorhandenen generischen Interaktionsgrundlage.

Erfinde keine vorhandenen Dateien, Build-Ergebnisse, Simulatorprüfungen, Testresultate oder Commit-Hashes.

## Modul

**Nummer:** 008  
**Titel:** Priorisierungsphase  
**Ziel:** In `GamePhase.priorisieren` sieht die nutzende Person das aktuelle Ticket-Monster und drei eindeutig deutsch beschriftete räumliche Ziele `Normal`, `Wichtig` und `Kritisch`. Das Monster kann per Blickfokus, Pinch und Drag auf genau eines dieser Ziele abgelegt werden; ein gültiger Drop speichert genau eine `TicketPriority` im `SessionModel` und sperrt weitere Eingaben. Ein ungültiger Drop verändert keine Entscheidung.

## Zu erfüllende Anforderungen

### SPEC F-08

> In der Priorisierungsphase kann die nutzende Person das Monster mit Blickfokus, Pinch und Drag auf genau eines der beschrifteten Ziele Normal, Wichtig oder Kritisch bewegen und dort ablegen.

### AK-08 — Räumliche Priorisierung

- GEGEBEN die Priorisierungsphase ist aktiv, WENN das Monster per Blickfokus, Pinch und Drag auf Normal, Wichtig oder Kritisch gezogen und dort losgelassen wird, DANN wird genau diese Priorität gespeichert.
- Alle drei Prioritätsziele sind eindeutig mit den deutschen Bezeichnungen „Normal“, „Wichtig“ und „Kritisch“ beschriftet.
- Pro Ticket kann höchstens eine Prioritätsentscheidung gewertet werden.

### Relevanter Anteil AK-10

- Loslassen außerhalb eines gültigen Ziels verändert Entscheidung, Punkte und Phase nicht.
- Gültiger Drop speichert die Entscheidung genau einmal und sperrt weitere Eingaben.
- Weitere Gesten während Lock dürfen die gespeicherte Entscheidung nicht verändern.

## Verbindliche Modulgrenze

Modul 008 bearbeitet ausschließlich:

- `PrioritizationView`,
- drei räumliche Prioritätsziele,
- deutsche Labels `Normal`, `Wichtig`, `Kritisch`,
- Monsterladen für das aktuelle Ticket,
- Aktivierung der Modul-007-Drag-/Drop-Grundlage,
- Mapping einer generischen Ziel-ID auf `TicketPriority`,
- kontrolliertes Speichern genau einer Prioritätsentscheidung,
- Input-Lock nach gültigem Drop,
- Rücksetzung des Monsters bei ungültigem Drop,
- Tests und Simulatorprüfung für F-08 / AK-08,
- Entfernung beziehungsweise Ablösung des DEBUG-Harness aus dem normalen `.priorisieren`-Routing.

Modul 008 bearbeitet ausdrücklich nicht:

- Teamstationen,
- `selectedTeam`,
- Punkteberechnung,
- Richtig-/Falsch-Bewertung,
- Erfolgssound oder Fehlersound,
- Anzeige der richtigen Lösung,
- automatische 1,5-Sekunden-Weiterleitung,
- Ergebnisansicht,
- Monsterreaktionen,
- neue Blender-Modellierung.

## Verbindlicher Vorab-Check

### 1. Git und Quellstand

Ermittle:

- aktuellen Branch,
- aktuellen Commit,
- tatsächlichen Modul-007-Commit,
- ob alle Dateien aus Modul 007 vorhanden sind,
- ob `.git/index.lock` noch ein Problem darstellt.

Prüfe insbesondere:

- `Components/DropTargetComponent.swift`
- `Services/MonsterInteractionConfigurator.swift`
- `Services/DropEvaluator.swift`
- `Views/Debug/DebugInteractionHarnessView.swift`
- `Models/SessionModel.swift`
- `Views/RootVolumeView.swift`
- `Assets/MonsterAssetProvider.swift`

### 2. Build, Tests und Simulator

Vor Modul 008 sind noch offen:

- Build nach Modul 007,
- Ausführung der 64 Tests,
- manuelle Gestenprüfung.

Führe nach Möglichkeit vor Änderungen aus:

- App-Build,
- vollständige Test-Suite,
- Simulatorstart,
- DEBUG-Harness-Prüfung.

Dokumentiere echte Ergebnisse.

Wenn Xcode nicht verfügbar ist, markiere alles ehrlich als offen.

### 3. Offene Alt-Abnahmen

Wenn der Simulator verfügbar ist, prüfe ohne unnötige Änderungen:

- AK-01 Startansicht,
- AK-06 Untersuchungsansicht,
- AK-07 Weiter zur Priorisierung,
- Modul-007-Harness: Hover, Pinch, Drag, Invalid-Drop, Valid-Drop, Lock.

## Relevanter bestehender Stand

### `SessionModel`

Relevant:

- `currentPhase`
- `currentTicket`
- `currentTicketIndex`
- `selectedPriority`
- `score`
- `isInputLocked`
- `lockInput()`
- `unlockInput()`

`selectedPriority` ist laut bisherigen Reports `private(set)`. Eine fachliche Methode zum Speichern der Priorität existiert noch nicht.

### `TicketPriority`

Vorhanden:

- `.normal`
- `.wichtig`
- `.kritisch`
- `displayName`

### Monster

Vorhanden:

- `Ticket.monsterAssetId`
- `MonsterAssetProvider.loadMonster(assetID:)`
- `MonsterInteractionConfigurator.configure(_:mode:)`
- Modus `.dragDrop`

### Drop

Vorhanden:

- `DropTargetComponent`
- `DropEvaluator.evaluate(entity:targets:)`
- `DropEvaluator.evaluate(entityPosition:targets:)`
- generische Ziel-ID

## Konkreter Arbeitsauftrag

### 1. Echte `PrioritizationView` erstellen

Erstelle eine klar benannte SwiftUI-/RealityKit-View für `.priorisieren`.

Die View muss enthalten:

- das Monster des aktuellen Tickets,
- drei räumlich klar getrennte Zielbereiche,
- sichtbare deutsche Bezeichnungen:
  - `Normal`
  - `Wichtig`
  - `Kritisch`

Keine Teamstationen.

### 2. Root-Routing ersetzen

`RootVolumeView.case .priorisieren` zeigt aktuell im DEBUG-Build den `DebugInteractionHarnessView`.

Ersetze diesen fachlich durch die echte `PrioritizationView`.

Der DEBUG-Harness darf:

- als separate Development-Datei erhalten bleiben,
- aber nicht mehr den normalen `.priorisieren`-Spielablauf übernehmen.

Im Release- und DEBUG-Spielablauf soll `.priorisieren` jetzt dieselbe fachliche Priorisierungsansicht zeigen.

### 3. Prioritätsziele fachlich aufbauen

Erstelle genau drei Ziel-Entities.

Jedes Ziel erhält:

- eine neutrale technische Ziel-ID,
- `DropTargetComponent`,
- eindeutige sichtbare deutsche Beschriftung,
- ausreichend großen Trefferbereich,
- ausreichenden räumlichen Abstand zu den anderen Zielen.

Beispiel für technische IDs:

- `priority_normal`
- `priority_wichtig`
- `priority_kritisch`

Diese IDs dürfen im Code fachlich gemappt werden; Nutzer sehen ausschließlich die deutschen Labels.

Keine zusätzlichen Prioritätsstufen.

### 4. Mapping Ziel-ID → `TicketPriority`

Definiere eine kleine, eindeutige Zuordnung:

- Normal → `.normal`
- Wichtig → `.wichtig`
- Kritisch → `.kritisch`

Keine String-Streuung in mehreren Views. Bevorzuge eine kleine zentrale lokale Mapping-Struktur beziehungsweise einen klaren Helper innerhalb der Priorisierungsverantwortung.

Keine Bewertung gegen `referencePriority` in diesem Modul.

### 5. Priorität kontrolliert im SessionModel speichern

Da `selectedPriority` `private(set)` ist, ergänze eine schmale fachliche SessionModel-Methode.

Sie muss mindestens garantieren:

- nur in `.priorisieren`,
- nur wenn noch keine Priorität gespeichert ist,
- nur wenn `isInputLocked == false` beziehungsweise im selben atomaren Ablauf,
- speichert genau eine `TicketPriority`,
- setzt danach den Input-Lock,
- ändert `score` nicht,
- ändert `selectedTeam` nicht,
- ändert `currentTicketIndex` nicht,
- ändert `currentPhase` in Modul 008 **nicht automatisch**.

Bevorzuge eine Methode, die Speicherung und Lock fachlich zusammen kapselt, sodass die View nicht erst Priorität setzt und danach separat den Lock setzt.

Die genaue Signatur ist anhand des realen Codes zu wählen.

### 6. Warum keine automatische Phasenweiterleitung

F-13 ordnet den automatischen Übergang nach ungefähr 1,5 Sekunden Modul 010 zu.

Deshalb darf Modul 008 nach gültigem Prioritätsdrop:

- Priorität speichern,
- Input sperren,
- visuell den gültigen Drop stehen lassen oder ein neutrales Feedback ermöglichen,

aber **nicht automatisch** nach 1,5 Sekunden zu `.teamZuordnen` wechseln.

Keinen zusätzlichen Weiter-Button erfinden.

Der vollständige automatische Übergang folgt Modul 010.

### 7. Ungültiger Drop

Nutze die bestehende Modul-007-Semantik.

Bei ungültigem Drop:

- `selectedPriority` bleibt unverändert/nil,
- `isInputLocked` bleibt false,
- `score` bleibt unverändert,
- `currentPhase` bleibt `.priorisieren`,
- `currentTicketIndex` bleibt unverändert,
- Monster kehrt zur Ausgangstransformation zurück.

Keine Sounds.

### 8. Gültiger Drop

Bei gültigem Drop:

1. `DropEvaluator` liefert die Ziel-ID.
2. Ziel-ID wird auf `TicketPriority` gemappt.
3. SessionModel speichert die Priorität genau einmal.
4. Input wird gesperrt.
5. Weitere Gesten werden ignoriert.

Noch nicht:

- gegen Referenzpriorität bewerten,
- Punkte vergeben,
- Sound abspielen,
- richtige Lösung anzeigen,
- Phase automatisch wechseln.

### 9. Startzustand der Priorisierungsphase

Beim Eintritt in `.priorisieren` muss die Eingabe für die neue Prioritätsentscheidung freigegeben sein.

Prüfe den realen Ablauf:

- `startSession()` setzt `isInputLocked = false`,
- `beginPrioritizationPhase()` verändert Lock laut bisherigem Stand nicht.

Falls für einen robusten Phasenaufbau ein kontrolliertes `unlockInput()` beim Eintritt nötig ist, setze es an genau einer nachvollziehbaren Stelle ein.

Wichtig:

- kein wiederholtes unkontrolliertes Unlock während einer bereits gewerteten Priorisierung,
- kein Unlock durch View-Refresh nach gültigem Drop.

Die View darf einen gespeicherten Zustand nicht durch erneutes `onAppear` entsperren.

### 10. Monster laden und konfigurieren

Nutze ausschließlich:

- `MonsterAssetProvider.loadMonster(assetID:)`
- `MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)`

Keine duplizierte Input-/Collision-/Hover-Konfiguration.

Die vier USDA-Kugeln dürfen weiterhin als Platzhalter verwendet werden.

### 11. Zielbeschriftungen und Lokalisierung

Alle drei sichtbaren Labels sind deutsch:

- Normal
- Wichtig
- Kritisch

Verwende den vorhandenen String Catalog, falls die Labels als lokalisierte UI-Texte umgesetzt werden.

Falls `TicketPriority.displayName` bereits exakt diese Texte liefert und technisch sauber im SwiftUI-/Attachment-Kontext verwendbar ist, darf diese bestehende Schnittstelle genutzt werden.

Keine englischen Labels.

### 12. Layout

Die drei Ziele müssen:

- klar unterscheidbar,
- ausreichend weit auseinander,
- gut lesbar,
- ohne feinmotorisch exaktes Ablegen erreichbar sein.

Die Monster-Startposition muss von allen drei Zielen sinnvoll erreichbar sein.

Verwende `InteractionConstants` und `LayoutConstants` dort, wo passend.

Neue Magic Numbers vermeiden; nur tatsächlich benötigte Maße zentral ergänzen.

### 13. Fehlerzustände

Wenn kein `currentTicket` existiert oder das Monster nicht geladen werden kann:

- kein Crash,
- klare lokale Fehlerdarstellung,
- keine Prioritätsentscheidung,
- kein automatischer Phasenwechsel.

Keine externe Fallbackquelle.

### 14. DebugManager

Verwende bestehende Kategorien:

- `.input`: Drag/Release und gültige Zielauswahl,
- `.physics`: DropEvaluator-Ergebnis,
- `.state`: Priorität gespeichert oder Eingabe wegen Lock abgewiesen,
- `.spawning`: Monster-/Ziel-Entity-Erzeugung.

Keine neue Kategorie, wenn bestehende reichen.

Keine Referenzpriorität in Logs ausgeben.

### 15. Automatisierte Tests

Erhalte alle 64 bestehenden Testdeklarationen.

Ergänze mindestens Tests für:

- Priorität kann in `.priorisieren` gespeichert werden,
- `.normal` wird korrekt gespeichert,
- `.wichtig` wird korrekt gespeichert,
- `.kritisch` wird korrekt gespeichert,
- nach erster Speicherung ist `isInputLocked == true`,
- zweiter Speicherversuch wird ignoriert,
- zweite Priorität überschreibt die erste nicht,
- Speicherversuch außerhalb `.priorisieren` wird ignoriert,
- Speicherung verändert `score` nicht,
- Speicherung verändert `selectedTeam` nicht,
- Speicherung verändert `currentTicketIndex` nicht,
- Speicherung verändert `currentPhase` in Modul 008 nicht,
- ungültiger Drop speichert keine Priorität,
- alle drei technischen Ziel-IDs sind eindeutig,
- genau drei Prioritätsziele existieren,
- Mapping deckt genau `.normal`, `.wichtig`, `.kritisch` ab.

RealityKit-Gesten selbst sind zusätzlich manuell im Simulator zu prüfen.

### 16. Simulatorprüfung

Prüfe mindestens drei getrennte Sitzungs-/Resetläufe:

#### Normal

- Priorisierungsphase erscheint,
- Ziel `Normal` sichtbar,
- Monster per Blick + Pinch + Drag auf `Normal`,
- `.normal` gespeichert,
- Lock gesetzt,
- erneutes Ziehen wirkungslos.

#### Wichtig

- neuer sauberer Zustand,
- Drop auf `Wichtig`,
- `.wichtig` gespeichert.

#### Kritisch

- neuer sauberer Zustand,
- Drop auf `Kritisch`,
- `.kritisch` gespeichert.

Zusätzlich:

- ungültiger Drop → Monster zurück,
- keine Entscheidung,
- keine Punkte,
- keine Phase,
- kein Team,
- drei Labels gut lesbar,
- genau ein Volume,
- keine Teamstationen sichtbar.

## Bestehende Dateien schützen

Voraussichtlich relevant:

- `Views/RootVolumeView.swift`
- neue `Views/PrioritizationView.swift`
- `Models/SessionModel.swift`
- `Support/AppConstants.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Wiederverwenden, nicht duplizieren:

- `Components/DropTargetComponent.swift`
- `Services/DropEvaluator.swift`
- `Services/MonsterInteractionConfigurator.swift`
- `Assets/MonsterAssetProvider.swift`

Nach Möglichkeit unverändert:

- `StartView.swift`
- `InvestigationView.swift`
- `Ticket.swift`
- `LocalTicketCatalog.swift`
- `GamePhase.swift`
- `Info.plist`
- Scene-Konfiguration.

### DEBUG-Harness

`Views/Debug/DebugInteractionHarnessView.swift` darf als Development-Hilfe bestehen bleiben, aber aus dem normalen `.priorisieren`-Routing entfernt werden.

## Keine Bewertung in Modul 008

Auch wenn `Ticket.referencePriority` vorhanden ist, darf Modul 008 die Nutzerentscheidung **nicht** mit der Referenz vergleichen.

Nicht implementieren:

- richtig/falsch,
- +100,
- Sound,
- Lösungstext,
- automatischen Übergang.

Das gehört Modul 010.

## Bekannte offene Punkte außerhalb des Moduls

- finale vier Blender-Monster fehlen,
- F-14/AK-14 bleibt teilweise offen,
- Teamzuordnung folgt Modul 009,
- Bewertung/Audio/Auto-Transition folgt Modul 010,
- Ergebnis folgt Modul 011,
- `.DS_Store`-Bereinigung ist nicht Teil von Modul 008.

## Git

Vorgesehener Commit:

`008: Priorisierungsphase`

Erfinde keinen Hash.

## Ausgabeformat

1. **Vorab-Check**
   - Branch/Commit,
   - tatsächlicher Modul-007-Commit,
   - Build-/Simulator-/Teststatus,
   - tatsächliche Testzahl,
   - Status der offenen AK-Nachprüfungen,
   - DEBUG-Harness-Prüfung.

2. **Priorisierungsentwurf**
   - View-Struktur,
   - drei Ziele,
   - Ziel-IDs,
   - Mapping zu `TicketPriority`,
   - Monster-Startposition und Zielanordnung.

3. **SessionModel-Erweiterung**
   - Methode zum genau-einmal-Speichern,
   - Vorbedingungen,
   - Lock-Semantik,
   - unveränderte Felder.

4. **Drag-/Drop-Integration**
   - Wiederverwendung von Configurator und DropEvaluator,
   - ungültiger Drop,
   - gültiger Drop,
   - Mehrfachinteraktion.

5. **Änderungen je Datei**
   - Pfad,
   - Art,
   - Target,
   - Zweck,
   - Bezug zu F-08/AK-08/AK-10.

6. **Tests und Simulatorprüfung**
   - Testzahl vor/nach,
   - Testergebnis,
   - manuelle Prüfung aller drei Prioritäten,
   - Invalid-Drop,
   - Input-Lock.

7. **Vollständiger `008-Report.md` nach der Modul-Report-Vorlage**

Der Report muss zusätzlich enthalten:

- tatsächlichen Dateibaum,
- alle neuen/geänderten Dateien,
- neue Schnittstellen für Modul 009/010,
- Ziel-IDs und Mapping,
- SessionModel-Speichermethode,
- Lock-Verhalten,
- DebugManager-Nutzung,
- Build-/Simulator-/Testergebnis,
- Status AK-08,
- Status des fachlichen AK-10-Anteils für Priorität,
- klare Bestätigung, dass keine Teamstationen, Bewertung, Punkte, Audio oder automatischen Übergänge implementiert wurden,
- Status der Blender-Monster,
- offene Risiken,
- Empfehlung für Modul 009.

Baue nichts außerhalb dieses Moduls um.
