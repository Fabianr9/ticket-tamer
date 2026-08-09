# Modul-Eingangsprompt — 010 Bewertung und Audiofeedback

> Vom Projektlogbuch nach Einarbeitung des `009-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 010 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git-, Xcode-, Test-, Audio- und Gameplay-Stand. Implementiere ausschließlich **Bewertung, Punkte, lokales Richtig-/Falsch-Audio und den automatischen Folgeübergang nach ungefähr 1,5 Sekunden**.

## Modul

**Nummer:** 010  
**Titel:** Bewertung und Audiofeedback  
**Ziel:** Nach einer gültigen Prioritäts- beziehungsweise Teamentscheidung wird diese genau einmal gegen den Referenzwert des aktuellen Tickets bewertet. Eine richtige Teilentscheidung gibt +100 Punkte, eine falsche 0 Punkte, ohne Abzug. Es wird genau einer von zwei lokalen Sounds abgespielt: richtig oder falsch. Die richtige Lösung wird nicht angezeigt. Während des Feedbacks bleibt die Eingabe gesperrt. Nach ungefähr 1,5 Sekunden wechselt das Spiel automatisch in die nächste Phase.

## Verbindliche Anforderungen

### F-11 — Bewertung

Die Prioritäts- und Teamentscheidung werden jeweils unabhängig gegen den Referenzwert des aktiven Tickets bewertet.

- richtige Priorität: +100 Punkte,
- falsche Priorität: 0 Punkte,
- richtiges Team: +100 Punkte,
- falsches Team: 0 Punkte,
- keine negativen Punkte,
- pro Ticket maximal 200 Punkte.

### F-12 — Audiofeedback

Nach jeder gültigen Entscheidung wird genau ein lokaler Feedback-Sound abgespielt:

- richtig,
- falsch.

Die richtige Lösung wird **nicht** angezeigt oder erklärt.

### F-13 — Eingabesperre und automatischer Übergang

Nach einer gültigen Entscheidung:

- Eingabe bleibt gesperrt,
- Feedback wird ausgegeben,
- nach ungefähr 1,5 Sekunden erfolgt automatisch der nächste Zustandswechsel.

Für Priorität:

`.priorisieren → .teamZuordnen`

Für Team:

- bei weiterem Ticket → nächstes Ticket in `.untersuchen`,
- nach letztem Ticket → `.ergebnis`.

## Zwingende Scope-Korrektur

Der `009-Report.md` nennt in seiner Empfehlung unter anderem „Anzeige der richtigen Lösung“.

Das ist **nicht erlaubt**.

Verbindlich ist:

- keine Anzeige der richtigen Priorität,
- keine Anzeige des richtigen Teams,
- kein Text „Richtig wäre …“,
- keine Lösungserklärung,
- kein Lösungs-Overlay,
- keine farbliche Markierung des richtigen Zielbereichs nach der Entscheidung.

Feedback besteht ausschließlich aus:

1. internem Punkteergebnis,
2. lokalem Richtig-/Falsch-Sound,
3. automatischem Übergang.

Eine optionale Monsterreaktion gehört erst Modul 012.

## Verbindliche Modulgrenze

Modul 010 bearbeitet ausschließlich:

- Vergleich gespeicherter Priorität mit `referencePriority`,
- Vergleich gespeicherten Teams mit `referenceTeam`,
- +100 / 0 Punkte,
- genau-einmal-Auswertung,
- zwei lokale Feedback-Sounds,
- einfacher AudioService beziehungsweise gleichwertige kleine Abspielkapselung,
- Eingabesperre während Feedback,
- ungefähr 1,5 Sekunden Feedbackdauer,
- automatischer Wechsel von Priorisierung zu Teamphase,
- automatischer Wechsel nach Teamfeedback zum nächsten Ticket oder in `.ergebnis`,
- Tests für Scoring, genau-einmal-Semantik und Zustandsübergänge,
- Simulatorprüfung der vollständigen Sequenz.

Modul 010 bearbeitet ausdrücklich nicht:

- Ergebnisansicht,
- „Erneut spielen“,
- detaillierte Statistik,
- sichtbares Richtig/Falsch-Label,
- sichtbare richtige Lösung,
- Monsteranimation,
- neue Blender-Modellierung,
- Accounts/Cloud/Persistenz.

## Verbindlicher Vorab-Check

### 1. Git

Ermittle:

- aktuellen Branch,
- aktuellen Commit,
- tatsächlichen Modul-009-Commit/Hash,
- ob `200093b`, `b716ed1` und `7b873b7` enthalten sind,
- ob der 009-Stand enthalten ist,
- ob Git sauber arbeitet.

Erfinde keinen Commit.

### 2. Build und Tests

Vor Modul 010 sind laut 009-Report:

- 110 Testdeklarationen vorhanden,
- vollständiger Testlauf offen,
- Build nach Modul 009 offen,
- Simulatorprüfung der Teamphase offen.

Führe nach Möglichkeit vor Änderungen aus:

- App-Build,
- vollständige Test-Suite,
- Simulatorstart.

Dokumentiere:

- Suites,
- tatsächliche Testzahl,
- bestanden/fehlgeschlagen,
- Zielplattform.

### 3. Offene Interaktionsabnahmen

Wenn Simulator verfügbar:

#### Priorität

- Normal,
- Wichtig,
- Kritisch,
- Invalid-Drop,
- Lock nach gültigem Drop.

#### Team

Über den bestehenden DEBUG-Teamzugang:

- Netzwerk,
- Konto,
- Software,
- Hardware,
- Invalid-Drop,
- Lock.

Diese Prüfungen sind Regression/Abnahme der Module 008/009.

### 4. Audioinventar

Suche real im Projekt nach lokalen Audioressourcen:

- `.wav`
- `.caf`
- `.m4a`
- `.aiff`
- `.mp3`

Erstelle eine Tabelle:

| Datei | Format | Zweck | Quelle/Urheber | Target/Bundle | Status |
|---|---|---|---|---|---|

Benötigt werden genau zwei fachliche Feedback-Sounds:

- Richtig,
- Falsch.

Wenn bereits geeignete Dateien vorhanden sind, verwende sie.

Wenn keine Dateien vorhanden sind:

- keine fremden Internet-Sounds stillschweigend herunterladen,
- keine lizenzrechtlich unklare Datei verwenden,
- falls im Ausführungsumfeld technisch möglich, dürfen zwei sehr einfache projekt-eigene lokale Platzhaltertöne erzeugt werden und müssen klar als solche dokumentiert werden,
- andernfalls Audio-Pipeline implementieren und F-12 bis zur Bereitstellung der zwei Dateien als teilweise offen markieren.

## Aktueller technischer Stand

### Entscheidungen

Vorhanden:

- `SessionModel.savePriority(_:)`
- `SessionModel.saveTeam(_:)`
- `SessionModel.selectedPriority`
- `SessionModel.selectedTeam`
- `SessionModel.isInputLocked`

Beide Speichermethoden sperren die Eingabe nach einer gültigen Entscheidung.

### Referenzwerte

Aktuelles Ticket:

- `currentTicket.referencePriority`
- `currentTicket.referenceTeam`

### Ablauf

Vorhanden:

- `.untersuchen`
- `.priorisieren`
- `.teamZuordnen`
- `.ergebnis`
- `beginPrioritizationPhase()`
- `beginTeamAssignmentPhase()`
- `advanceToNextTicket()`
- `reset()`

### Punktestand

- `score` existiert bereits als `private(set)`,
- Start/Reset = 0,
- bisher keine Bewertungslogik.

## Konkreter Arbeitsauftrag

### 1. Bewertungsmodell klein und genau-einmal-sicher halten

Implementiere eine einfache, klar testbare Bewertungssemantik.

Für jede Teilentscheidung muss eindeutig bestimmbar sein:

- wurde sie bereits bewertet,
- war sie richtig,
- wie viele Punkte wurden vergeben.

Verhindere doppelte Punkte durch:

- View-Neuberechnung,
- mehrfachen Task-Start,
- mehrfaches Release-Ereignis,
- erneuten Aufruf der Bewertungsmethode.

Bevorzuge eine kleine SessionModel-interne Zustandsabsicherung.

Mögliche Lösung:

- separate interne Flags für Priorität bewertet / Team bewertet,
- oder ein kleiner interner Evaluationszustand.

Keine komplexe Event-Sourcing- oder Game-Engine-Abstraktion.

### 2. Priorität bewerten

Eine Bewertungsmethode für die gespeicherte Priorität darf nur erfolgreich sein, wenn:

- Phase `.priorisieren`,
- `selectedPriority != nil`,
- `currentTicket != nil`,
- diese Prioritätsentscheidung noch nicht bewertet wurde.

Vergleich:

`selectedPriority == currentTicket.referencePriority`

Wenn richtig:

- +100.

Wenn falsch:

- +0.

Danach als bewertet markieren.

Die Methode soll ein kleines Ergebnis zurückgeben, mit dem die UI beziehungsweise der AudioService entscheiden kann, welchen Sound abzuspielen.

Keine Referenzpriorität im Nutzertext zurückgeben.

### 3. Team bewerten

Analog:

- Phase `.teamZuordnen`,
- `selectedTeam != nil`,
- aktuelles Ticket vorhanden,
- Teamentscheidung noch nicht bewertet.

Vergleich:

`selectedTeam == currentTicket.referenceTeam`

Richtig:

- +100.

Falsch:

- +0.

Genau einmal.

### 4. Punktesemantik

Verbindlich:

- keine negativen Punkte,
- falsche Entscheidung ändert Score nicht,
- richtige Entscheidung erhöht genau um 100,
- max. 200 Punkte je Ticket,
- bei 12 Tickets theoretisch max. 2400 Punkte,
- Score bleibt beim Wechsel zum nächsten Ticket erhalten,
- Score wird erst durch vollständigen Session-Reset wieder 0.

Keine Bonuspunkte, Multiplikatoren, Streaks oder Timerpunkte.

### 5. AudioService

Erstelle eine kleine lokale Audio-Kapselung entsprechend der bestehenden Architektur-Skizze.

Beispielverantwortung:

- zwei lokale Ressourcen kennen,
- Richtig-Sound abspielen,
- Falsch-Sound abspielen,
- Fehler beim Laden/Abspielen über `DebugManager.audio` loggen.

Keine Netzwerkquelle.

Kein globaler unnötiger Service-Locator.

Wähle die für das reale visionOS-26-/Xcode-26.5-Projekt passende lokale Audio-API anhand des tatsächlich verfügbaren SDKs.

Dokumentiere die gewählte API und warum sie geeignet ist.

### 6. Genau ein Sound pro Entscheidung

Nach erfolgreicher erstmaliger Bewertung:

- richtig → genau ein Richtig-Sound,
- falsch → genau ein Falsch-Sound.

Bei:

- erneutem View-Render,
- erneutem Bewertungsaufruf,
- Lock-Ereignis,
- Phasenwechsel,

darf derselbe Sound nicht erneut ausgelöst werden.

Audioausfall darf nicht zu doppelten Punkten oder hängenbleibendem Flow führen.

### 7. Feedbackdauer

Zentrale Dauer:

ungefähr 1,5 Sekunden.

Lege dafür eine zentrale Konstante an, falls noch keine existiert, z. B. sinngemäß:

`feedbackTransitionDelay = 1.5`

Keine verstreuten Magic Numbers.

Die Zeit ist Feedback-/Übergangsdauer, kein Spieltimer.

### 8. Prioritätsflow integrieren

Aktueller Zustand nach gültigem Prioritätsdrop:

- `selectedPriority` gesetzt,
- `isInputLocked = true`,
- Phase bleibt `.priorisieren`.

Modul 010 soll danach:

1. Prioritätsentscheidung genau einmal bewerten.
2. Score ggf. +100.
3. Genau einen Sound abspielen.
4. Eingabe gesperrt lassen.
5. ungefähr 1,5 Sekunden warten.
6. `beginTeamAssignmentPhase()` aufrufen.
7. Teamphase startet mit entsperrtem Input.

Der bestehende DEBUG-Teambutton darf als Development-Hilfe erhalten bleiben, ist aber nicht mehr für den normalen Ablauf erforderlich.

### 9. Teamflow integrieren

Aktueller Zustand nach gültigem Teamdrop:

- `selectedTeam` gesetzt,
- `isInputLocked = true`,
- Phase bleibt `.teamZuordnen`.

Modul 010 soll danach:

1. Teamentscheidung genau einmal bewerten.
2. Score ggf. +100.
3. Genau einen Sound abspielen.
4. Eingabe gesperrt lassen.
5. ungefähr 1,5 Sekunden warten.
6. entscheiden:
   - weiteres Ticket vorhanden,
   - oder letztes Ticket abgeschlossen.

### 10. Abschluss eines Tickets

Ergänze eine kleine, kontrollierte SessionModel-Methode für den Übergang nach Teamfeedback.

Sie soll den Sitzungsfortschritt kapseln.

Bei weiterem Ticket:

- `currentTicketIndex += 1`,
- `selectedPriority = nil`,
- `selectedTeam = nil`,
- Bewertungsflags für neues Ticket zurücksetzen,
- `isInputLocked = false`,
- `currentPhase = .untersuchen`,
- `score` erhalten.

Beim letzten Ticket:

- kein Indexüberlauf,
- `currentPhase = .ergebnis`,
- `isInputLocked = false`,
- Score erhalten,
- Sitzungsdaten für die Ergebnisansicht in Modul 011 erhalten.

Kein vollständiger Reset.

### 11. Genau-einmal-Task-Semantik

SwiftUI-Views können mehrfach erscheinen oder aktualisiert werden.

Verhindere, dass mehrere parallele 1,5-Sekunden-Tasks für dieselbe Entscheidung starten.

Bevorzuge:

- einen klaren einmaligen Trigger nach erfolgreich erstmaliger Bewertung,
- oder einen View-/Modelzustand, der eindeutig sagt „Feedback läuft bereits“.

Nach Wechsel der Phase darf ein alter Task keine zweite Transition mehr auslösen.

### 12. Fehlerfälle

Wenn:

- kein aktuelles Ticket,
- keine gespeicherte Entscheidung,
- falsche Phase,
- Entscheidung schon bewertet,

dann:

- kein Score,
- kein Sound,
- kein Transition-Task.

Fehler über DebugManager dokumentieren, aber kein Crash.

### 13. Sichtbares Feedback bewusst minimal halten

Während der 1,5 Sekunden darf die aktuelle Szene stehen bleiben.

Nicht hinzufügen:

- „Richtig!“
- „Falsch!“
- Punkt-Popup,
- Lösungstext,
- grüne Markierung des richtigen Ziels,
- rote Markierung der falschen Nutzerwahl als Bewertungssignal,
- Erklärung.

Der Sound ist das Feedback.

### 14. DebugManager

Nutze vorhandene Kategorien:

- `.state`: Bewertung, Scoreänderung, Zustandsübergang,
- `.audio`: Sound laden/abspielen/Fehler,
- `.input`: ignorierte erneute Entscheidung wegen Lock,
- `.lifecycle`: nur falls für Serviceinitialisierung nötig.

Keine neue Kategorie.

In Logs dürfen für Debugzwecke interne boolesche Ergebnisse auftauchen, aber keine unnötigen vollständigen Tickettexte.

Vermeide Logs, die im normalen UI sichtbar wären.

## Automatisierte Tests

Erhalte die bestehenden 110 Testdeklarationen.

Ergänze mindestens Tests für Prioritätsbewertung:

1. richtige Priorität → +100,
2. falsche Priorität → +0,
3. zweite Bewertung → keine weiteren Punkte,
4. Bewertung ohne Prioritätswahl → No-Op,
5. Bewertung in falscher Phase → No-Op.

Teambewertung:

6. richtiges Team → +100,
7. falsches Team → +0,
8. zweite Bewertung → keine weiteren Punkte,
9. Bewertung ohne Teamwahl → No-Op,
10. Bewertung in falscher Phase → No-Op.

Kombination:

11. beide richtig → 200 pro Ticket,
12. Priorität richtig / Team falsch → 100,
13. Priorität falsch / Team richtig → 100,
14. beide falsch → 0,
15. keine negativen Punkte.

Flow:

16. Prioritätsfeedback → anschließend `.teamZuordnen`,
17. Priorität bleibt nach Wechsel gespeichert,
18. Teamphase ist entsperrt,
19. Teamfeedback mit weiterem Ticket → Index +1,
20. neues Ticket → `.untersuchen`,
21. neue Ticketentscheidungen sind nil,
22. Score bleibt erhalten,
23. letztes Ticket → `.ergebnis`,
24. kein Indexüberlauf am Ende,
25. Reset löscht Bewertungsflags/Score.

Genau-einmal:

26. mehrfacher Auswertungsaufruf gibt keine doppelten Punkte,
27. mehrfacher Transition-Trigger verändert den Ablauf nicht doppelt.

Audio-Service:

28. Mapping richtig → correct-Sound-Ressource,
29. Mapping falsch → incorrect-Sound-Ressource,
30. Ressourcen-IDs eindeutig und lokal.

Audio-Playback selbst zusätzlich im Simulator prüfen.

## Simulatorprüfung

Prüfe mindestens:

### Priorität richtig

- gültiger Prioritätsdrop,
- richtiger Sound,
- +100,
- Lock bleibt während Feedback,
- nach ungefähr 1,5 s Teamphase.

### Priorität falsch

- falscher Sound,
- +0,
- keine Lösung sichtbar,
- automatischer Wechsel.

### Team richtig

- richtiger Sound,
- +100,
- nach ungefähr 1,5 s nächstes Ticket oder Ergebnis.

### Team falsch

- falscher Sound,
- +0,
- keine Lösung sichtbar,
- automatischer Wechsel.

### Kombinationsprüfung

Ein Ticket mit:

- beide richtig → +200,
- eine richtig → +100,
- beide falsch → +0.

### Mehrere Tickets

- Score wird aufsummiert,
- neues Ticket beginnt wieder in `.untersuchen`,
- Prioritäts-/Teamwahl sind für neues Ticket leer,
- nach letztem Ticket Phase `.ergebnis`,
- genau ein zentrales Volume.

## Audio-Dateien und Rechte

Im `010-Report.md` dokumentieren:

| Sound | Datei | Format | Quelle/Urheber | Lizenz/Rechte | Bundle-Pfad |
|---|---|---|---|---|---|

Wenn Sounds selbst erzeugte Projektdateien sind, so kennzeichnen.

Keine fremden Dateien ohne klare Rechte.

## Bestehende Dateien schützen

Voraussichtlich relevant:

- `Models/SessionModel.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- neue `Services/AudioService.swift` oder gleichwertig
- `Support/AppConstants.swift`
- Audioressourcen
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Möglichst unverändert:

- `StartView.swift`
- `InvestigationView.swift`
- `Ticket.swift`
- `LocalTicketCatalog.swift`
- `DropTargetComponent.swift`
- `DropEvaluator.swift`
- `MonsterInteractionConfigurator.swift`
- `MonsterAssetProvider.swift`
- `Info.plist`.

`RootVolumeView` nur ändern, wenn für den resultierenden Phasenflow technisch notwendig.

## Ergebnisphase

Modul 010 darf nach dem letzten Teamfeedback:

`currentPhase = .ergebnis`

setzen.

Aber Modul 010 darf **keine fertige Ergebnisansicht** bauen.

Der aktuelle neutrale Placeholder für `.ergebnis` darf bis Modul 011 bestehen bleiben.

## DEBUG-Teambutton

Der `🔧 Team [DEV]`-Button darf nach Integration des automatischen Übergangs:

- als DEBUG-only Development-Hilfe bestehen bleiben,
- oder sauber entfernt werden.

Er darf niemals im Release-Build erscheinen.

Dokumentiere die Entscheidung.

## Bekannte offene Punkte außerhalb von Modul 010

- finale vier Blender-Monster fehlen,
- Ergebnisansicht und „Erneut spielen“ folgen Modul 011,
- optionale Monsterreaktion folgt höchstens Modul 012,
- echte Vision-Pro-Gesamtprüfung folgt Modul 013,
- `.DS_Store`-Bereinigung ist kein Teil von Modul 010.

## Git

Vorgesehener Commit:

`010: Bewertung und Audiofeedback`

Erfinde keinen Hash.

Wenn separate Audioassets oder ein kleiner Nachfix einen zweiten Commit erfordern, dokumentiere beide echten Hashes.

## Ausgabeformat

1. **Vorab-Check**
   - Branch/Commit,
   - Modul-009-Commit,
   - Build/Test/Simulator,
   - Interaktionsabnahmen,
   - Audioinventar.

2. **Bewertungsentwurf**
   - genau-einmal-Mechanismus,
   - Prioritätsbewertung,
   - Teambewertung,
   - Punkteregeln,
   - interne Rückgabewerte.

3. **Audio**
   - API,
   - AudioService,
   - zwei Ressourcen,
   - Rechte,
   - Fehlerbehandlung.

4. **Automatischer Flow**
   - Priorität → 1,5 s → Team,
   - Team → 1,5 s → nächstes Ticket/Ergebnis,
   - Input-Lock,
   - Task-/Mehrfachschutz.

5. **SessionModel-Erweiterungen**
   - neue Bewertungsmethoden,
   - Abschluss-/Next-Ticket-Methode,
   - Bewertungsflags,
   - Resetverhalten.

6. **Änderungen je Datei**
   - Pfad,
   - Art,
   - Target,
   - Zweck,
   - Bezug zu F-11/F-12/F-13.

7. **Tests und Simulatorprüfung**
   - Testzahl vor/nach,
   - tatsächliches Testergebnis,
   - Punktefälle,
   - Soundfälle,
   - automatische Übergänge,
   - letzte-Ticket-Logik.

8. **Vollständiger `010-Report.md` nach der Modul-Report-Vorlage**

Der Report muss zusätzlich enthalten:

- tatsächlichen Dateibaum,
- alle neuen/geänderten Dateien,
- alle neuen SessionModel-Schnittstellen,
- Punkte- und genau-einmal-Semantik,
- Audioressourcen und Rechte,
- Feedbackdauer,
- Ablauf nach Priorität und Team,
- Verhalten am letzten Ticket,
- DebugManager-Nutzung,
- Build-/Simulator-/Testergebnis,
- Status F-11/F-12/F-13,
- klare Bestätigung: **keine richtige Lösung angezeigt**,
- Status AK-08/AK-09/AK-10 nach Simulatorprüfung,
- Status der Blender-Monster,
- offene Risiken,
- Empfehlung für Modul 011.

Baue nichts außerhalb dieses Moduls um.
