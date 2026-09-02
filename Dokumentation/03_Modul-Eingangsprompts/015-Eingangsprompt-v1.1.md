# Modul-Eingangsprompt — 015 Session-HUD und Interaktionshinweise

> Vom **Projektlogbuch** für **Ticket Tamer v1.1** erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 015 und muss ohne Kenntnis anderer Chats auskommen.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**. Baue nur, was hier beauftragt ist.

# Modul

**Nummer:** 015  
**Titel:** Session-HUD und Interaktionshinweise

**Ziel:** Ergänze den abgeschlossenen v1.0-Spielkern um ein dauerhaft sichtbares, nicht interaktives Sitzungs-HUD in Untersuchung, Priorisierung und Teamzuordnung sowie um dauerhafte Drag-Hinweise in den beiden Entscheidungsphasen, ohne bestehende Spiellogik, Drag-&-Drop, Scoring, Exactly-once-Semantik oder Phasenwechsel zu verändern.

---

# Versionskontext

Ticket Tamer **v1.0 ist abgeschlossen**.

Die Module 001 bis 014 bilden den abgeschlossenen v1.0-Kern. Version 1.1 ergänzt ausschließlich kleine, risikoarme Usability-Verbesserungen.

Für Modul 015 gilt deshalb ausdrücklich:

- vorhandene v1.0-Spiellogik nicht umbauen,
- `SessionModel` bleibt die einzige fachliche Source of Truth,
- keine zweite Zustandsmaschine,
- keine Änderung an Drop-Regel, DragBounds, Z-Toleranz oder Snapback,
- keine Änderung am Scoring,
- keine Änderung an Exactly-once,
- keine Änderung an Audio,
- keine Änderung am ungefähr 1,5 Sekunden langen Feedbackfenster,
- keine Änderung an Monster-Asset-Pipeline oder Ticketdaten,
- kein neues Fenster, kein zweites Volume, kein Immersive Space.

Die letzte dokumentierte v1.0-Testbasis vor dem finalen Abschluss lag bei 208 Tests. Prüfe zu Beginn den **tatsächlichen aktuellen Stand** im Repository; erfinde keine Testzahl, keinen Commit und keinen Buildstatus.

---

# Zu erfüllende Anforderungen

## F-18 — Session-HUD und Fortschrittsbalken

> Das System zeigt in Untersuchungs-, Priorisierungs- und Teamzuordnungsphase dauerhaft ein kompaktes Sitzungs-HUD mit „Ticket X von Y“, einem zur Phase passenden Titel und einem linearen Fortschrittsbalken. Das HUD enthält keinen Score.

## AK-18 — Session-HUD und Fortschrittsbalken

Alle Punkte müssen erfüllt sein:

1. GEGEBEN eine Sitzung läuft, WENN Untersuchung, Priorisierung oder Teamzuordnung angezeigt wird, DANN ist dauerhaft ein kompaktes HUD sichtbar.
2. GEGEBEN Ticket `x` von insgesamt `y` Tickets ist aktiv, WENN das HUD angezeigt wird, DANN zeigt es exakt `Ticket x von y`.
3. GEGEBEN die aktuelle Phase ist Untersuchung, Priorisierung oder Teamzuordnung, WENN das HUD angezeigt wird, DANN lautet der Phasentitel entsprechend:
   - `Ticket untersuchen`
   - `Priorität zuordnen`
   - `Team zuordnen`
4. GEGEBEN Ticket 3 von 6 ist aktiv, WENN der Fortschrittsbalken angezeigt wird, DANN entspricht sein Fortschritt `3/6 = 50 %`.
5. Der Fortschrittswert bleibt während Untersuchung, Priorisierung und Teamzuordnung desselben Tickets unverändert und erhöht sich erst beim nächsten Ticket.
6. Das HUD zeigt **keinen Score**, keine Zeit, keinen Streak und keine Richtig-/Falsch-Statistik.
7. Das nicht interaktive HUD blockiert keine Blick-, Pinch- oder Drag-Geste der 3D-Szene.

## F-20 — Dauerhafte Interaktionshinweise

> Das System zeigt in den beiden Zuweisungsphasen dauerhaft einen nicht interaktiven Hinweis zur benötigten Drag-Geste: „Monster greifen und auf eine Priorität ziehen.“ beziehungsweise „Monster greifen und dem zuständigen Team zuordnen.“

## AK-20 — Dauerhafte Interaktionshinweise

Alle Punkte müssen erfüllt sein:

1. In der Priorisierungsphase ist dauerhaft sichtbar:

   `Monster greifen und auf eine Priorität ziehen.`

2. In der Teamzuordnungsphase ist dauerhaft sichtbar:

   `Monster greifen und dem zuständigen Team zuordnen.`

3. Die Hinweise bleiben auch nach Beginn einer Drag-Geste sichtbar.
4. Die Hinweise besitzen keine Persistenz über `@AppStorage` oder eine andere globale Tutorialverwaltung.
5. Die Hinweise blockieren keine 3D-Interaktion.

---

# Verbindliche v1.1-Architektur

Die v1.1-Erweiterung bleibt in der bestehenden Architektur.

## SessionModel

`SessionModel` bleibt die einzige Source of Truth für fachlichen Sitzungszustand.

Für Modul 015 werden **keine neuen fachlichen SessionModel-Felder benötigt**.

Vorhandene relevante Werte:

- `model.currentTicketIndex`
- `model.sessionTickets`
- `model.currentPhase`

HUD-Berechnung:

```text
currentTicketNumber = currentTicketIndex + 1
totalTicketCount = sessionTickets.count
progress = currentTicketNumber / totalTicketCount
```

Beispiel:

```text
currentTicketIndex = 2
sessionTickets.count = 6
→ Ticket 3 von 6
→ progress = 3 / 6 = 0.5
```

Der Fortschritt beschreibt **Tickets**, nicht Unterphasen.

Das bedeutet:

```text
Ticket 3 untersuchen     → 3/6
Ticket 3 priorisieren    → 3/6
Ticket 3 Team zuordnen   → 3/6
nächstes Ticket          → 4/6
```

Keine Erhöhung beim Wechsel:

- `.untersuchen → .priorisieren`
- `.priorisieren → .teamZuordnen`

## Neue wiederverwendbare Komponenten

Neue wiederverwendbare SwiftUI-Komponenten gehören unter:

`Ticket_Tamer/Ticket_Tamer/Views/Components/`

Vorgesehene Komponenten:

- `SessionHUDView.swift`
- `InteractionHintView.swift`

Die konkrete kleine interne API darf anhand des realen Codes gewählt werden.

Wichtig:

- Die Komponenten erhalten nur die benötigten Werte.
- Sie besitzen keinen fachlichen Sitzungszustand.
- Sie schreiben nichts in `SessionModel`.
- Sie starten keine Tasks.
- Sie verändern keine Phase.
- Sie verändern keine Entscheidung.
- Sie verändern keinen Score.

---

# Verbindlicher Vorab-Check

Bevor du Code änderst:

## 1. Git

Ermittle real:

- aktuellen Branch,
- aktuellen HEAD,
- Working-Tree-Status,
- letzten v1.0-Abschlusscommit,
- ob uncommitted Änderungen vorhanden sind.

Erfinde keine Hashes.

## 2. Projektstand

Prüfe mindestens die aktuellen Fassungen von:

- `Views/InvestigationView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Models/SessionModel.swift`
- `Models/GamePhase.swift`
- `Resources/Localizable.xcstrings`
- `Support/AppConstants.swift`
- `Debug/DebugManager.swift`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Prüfe außerdem, ob `Views/Components/` bereits existiert.

## 3. v1.0-Baseline

Führe nach Möglichkeit **vor den Änderungen** aus:

- App-Build,
- vollständige Test-Suite.

Dokumentiere:

- tatsächliche Testzahl,
- Passed,
- Failed,
- Skipped,
- Plattform,
- Buildziel.

Falls die tatsächliche Testzahl nicht 208 ist, verwende den realen Wert.

Falls bereits vor Modul 015 ein v1.0-Fehler besteht:

- klar als Vorbefund dokumentieren,
- nicht stillschweigend Modul 015 zuschreiben,
- keine fachfremde Reparatur durchführen, außer sie ist zwingend notwendig, um Modul 015 überhaupt zu testen.

---

# Konkreter Arbeitsauftrag

## 1. `SessionHUDView` erstellen

Erstelle eine kleine wiederverwendbare SwiftUI-Komponente unter:

`Views/Components/SessionHUDView.swift`

Sie soll visuell kompakt bleiben und mindestens darstellen:

- `Ticket X von Y`
- Phasentitel
- linearen Fortschrittsbalken

Sie darf **nicht** darstellen:

- Score
- Punkte
- Zeit
- Streak
- Richtig/Falsch
- Referenzpriorität
- Referenzteam
- Ticketlösung

## 2. HUD-Daten ausschließlich aus bestehendem Sitzungsstand ableiten

Keine neue fachliche Zustandsvariable.

Die View oder eine kleine rein darstellungsbezogene Hilfslogik darf aus vorhandenen Werten ableiten:

- aktuelles Ticket = `currentTicketIndex + 1`
- Gesamtzahl = `sessionTickets.count`
- Fortschritt = aktuelles Ticket / Gesamtzahl

Defensiv behandeln:

- keine Division durch 0,
- kein Fortschritt außerhalb `0...1`,
- kein künstlicher Ticketindexwechsel.

In einer aktiven Sitzung mit gültigem Ticket muss die Anzeige exakt den SessionModel-Werten entsprechen.

## 3. Phasentitel exakt abbilden

Verbindliche sichtbare Texte:

| GamePhase | HUD-Titel |
|---|---|
| `.untersuchen` | `Ticket untersuchen` |
| `.priorisieren` | `Priorität zuordnen` |
| `.teamZuordnen` | `Team zuordnen` |

Keine alternativen Formulierungen.

Für `.start` und `.ergebnis` wird das Session-HUD in Modul 015 **nicht** angezeigt.

## 4. HUD in drei Views integrieren

Integriere dasselbe wiederverwendbare HUD in:

- `InvestigationView`
- `PrioritizationView`
- `TeamAssignmentView`

Nicht drei unterschiedliche HUD-Implementierungen bauen.

Das HUD soll in allen drei Phasen konsistent aussehen.

## 5. HUD darf Interaktion nicht blockieren

Das HUD ist rein informativ.

Verbindlich:

- `.allowsHitTesting(false)` oder gleichwertige eindeutig nicht-interaktive Umsetzung,
- keine Gesten am HUD,
- keine Buttons im HUD,
- keine transparenten interaktiven Flächen über der RealityView.

Prüfe insbesondere in Priorisierung und Teamzuordnung, dass Blickfokus, Pinch und Drag weiterhin funktionieren.

## 6. `InteractionHintView` erstellen

Erstelle:

`Views/Components/InteractionHintView.swift`

Die Komponente ist rein informativ.

Sie soll einen übergebenen lokalisierten Hinweis kompakt darstellen.

Keine eigene Persistenz, kein Tutorialstatus, kein „gesehen“-Flag.

## 7. Priorisierungs-Hinweis integrieren

In `PrioritizationView` dauerhaft sichtbar:

`Monster greifen und auf eine Priorität ziehen.`

Der Hinweis bleibt sichtbar:

- vor Drag,
- während Drag,
- bis die View durch den regulären Phasenwechsel verlassen wird.

Nicht nach dem ersten Drag ausblenden.

## 8. Team-Hinweis integrieren

In `TeamAssignmentView` dauerhaft sichtbar:

`Monster greifen und dem zuständigen Team zuordnen.`

Gleiche Regeln wie in Priorisierung.

## 9. Hinweise dürfen Drag nicht blockieren

Auch `InteractionHintView` ist nicht interaktiv:

- `.allowsHitTesting(false)` oder gleichwertig,
- keine Gesture-Modifier,
- keine Buttons,
- keine unsichtbare Hit-Test-Fläche über Monster oder Zielpanels.

## 10. Kein Tutorialsystem

Nicht implementieren:

- `@AppStorage`
- UserDefaults
- „Hinweis nicht mehr anzeigen“
- Tutorial-Popup
- „So funktioniert’s“
- First-Launch-Logik
- Persistenz

Die Hinweise sind absichtlich dauerhaft.

## 11. Layout risikoarm halten

Das vorhandene v1.0-Layout ist stabil.

Deshalb:

- RealityView-Geometrie nicht verändern,
- Monster-Startposition nicht verändern,
- Zielpanelpositionen/-größen nicht verändern,
- DragBounds nicht verändern,
- 50-%-Drop-Regel nicht verändern,
- Z-Toleranz nicht verändern.

HUD und Hinweise sollen als SwiftUI-Darstellung ergänzt werden, ohne die funktionierende räumliche Geometrie neu zu layouten.

Prüfe im Simulator:

- keine Überdeckung wichtiger Tickettexte,
- keine Überdeckung der Zielbeschriftungen,
- Monster bleibt sichtbar,
- Zielpanels bleiben sichtbar,
- HUD und Hinweis sind lesbar.

## 12. Lokalisierung

Alle neuen sichtbaren Texte in:

`Resources/Localizable.xcstrings`

pflegen.

Mindestens benötigt werden sinngemäß Schlüssel für:

- `Ticket %lld von %lld`
- `Ticket untersuchen`
- `Priorität zuordnen`
- `Team zuordnen`
- `Monster greifen und auf eine Priorität ziehen.`
- `Monster greifen und dem zuständigen Team zuordnen.`

Verwende die im realen Projekt etablierte String-Catalog-Struktur.

Keine sichtbaren deutschen String-Literale verstreut im Code, wenn das Projekt für entsprechende Texte den String Catalog nutzt.

## 13. Accessibility

HUD und Hinweise müssen in der vorgesehenen Betrachtungsdistanz lesbar sein.

Für das HUD soll VoiceOver beziehungsweise Accessibility die wesentlichen Informationen verständlich erfassen können:

- Ticket X von Y
- Phasentitel
- Fortschritt

Der ProgressView muss nicht mit redundanten sichtbaren Prozentzahlen ergänzt werden.

Keine sichtbare Prozentanzeige erforderlich.

## 14. DebugManager

Für Modul 015 ist **keine neue Debug-Kategorie** vorgesehen.

Wenn Logging fachlich sinnvoll ist, verwende bestehend:

- `.lifecycle` für View-/HUD-Erscheinen,
- `.state` höchstens für abgeleitete Anzeigeinformationen.

Vermeide Frame-/Render-Spam.

Keine Logs pro SwiftUI-Renderdurchlauf.

---

# Harte Modulgrenze

Modul 015 bearbeitet **nur F-18 und F-20**.

Folgendes gehört ausdrücklich **nicht** in dieses Modul:

## Noch nicht Modul 016

- kein Info-Button,
- kein `CompactTicketInfoView`,
- kein Ticketinfo-Overlay,
- keine Drag-Sperre wegen geöffnetem Info-Overlay.

## Noch nicht Modul 017

- keine Startseiten-Kurzbeschreibung,
- keine Minus-/Plus-Buttons,
- keine Änderung des Ticketanzahl-Sliders.

## Noch nicht Modul 018

- kein grüner Haken,
- kein rotes Kreuz,
- kein `+100 Punkte`,
- kein visuelles Entscheidungsfeedback.

## Noch nicht Modul 019

- kein „Erneut laden“,
- keine Retry-Logik,
- keine Änderung der Monster-Ladepipeline.

## Nicht Teil von v1.1

- keine neue Drop-Regel,
- keine Änderung an 50-%-Overlap,
- keine Änderung an Snapback,
- keine neue Punkteberechnung,
- kein sichtbarer Score während der Sitzung,
- kein Tutorial,
- keine Persistenz,
- kein zweites Volume,
- kein Immersive Space,
- keine zusätzliche Monsterreaktion aus F-17.

---

# Bestehende v1.0-Funktionen schützen

Nach Modul 015 müssen weiterhin unverändert funktionieren:

- Start einer Sitzung,
- Untersuchung,
- „Weiter zur Priorisierung“,
- Prioritäts-Drag,
- Team-Drag,
- Invalid-Drop,
- Snapback,
- Input-Lock,
- Exactly-once,
- +100/0-Scoring,
- correct/incorrect-Sound,
- ungefähr 1,5 Sekunden Übergang,
- Ergebnisansicht,
- Reset,
- vier Monsterassets.

Insbesondere:

**HUD und Hinweise dürfen keine zusätzliche Bewertung, keinen zusätzlichen Sound und keinen zusätzlichen Phasenwechsel auslösen.**

---

# Automatisierte Tests

Erhalte sämtliche bestehenden Tests.

Ergänze neue Tests nur dort, wo sie sinnvoll und stabil sind.

Mindestens sollte testbar abgesichert werden:

1. Ticket 1 von 6 → Fortschritt `1/6`.
2. Ticket 3 von 6 → Fortschritt `0.5`.
3. Ticket 6 von 6 → Fortschritt `1.0`.
4. Fortschritt bleibt für `.untersuchen`, `.priorisieren` und `.teamZuordnen` desselben Index identisch.
5. nächster Ticketindex erhöht den Fortschritt.
6. Phasentitel `.untersuchen` → `Ticket untersuchen`.
7. Phasentitel `.priorisieren` → `Priorität zuordnen`.
8. Phasentitel `.teamZuordnen` → `Team zuordnen`.
9. HUD-Berechnung erzeugt bei leerer Sitzung keinen ungültigen Float-/Division-durch-0-Wert.
10. HUD benötigt keinen Scorewert.
11. Interaktionshinweis Priorisierung entspricht exakt dem vorgegebenen Text.
12. Interaktionshinweis Team entspricht exakt dem vorgegebenen Text.

Falls dafür eine kleine **rein darstellungsbezogene**, interne Hilfsstruktur sinnvoll ist, ist sie zulässig.

Nicht zulässig:

- neue fachliche Felder in `SessionModel`,
- ein neuer ViewModel-Layer nur für zwei Textzeilen,
- ein komplexes UI-Test-Target nur für dieses Modul.

Nach Änderungen vollständige Testsuite ausführen.

Im Report dokumentieren:

- Testzahl vorher,
- neue Tests,
- Testzahl nachher,
- Passed/Failed/Skipped,
- Plattform.

---

# Simulatorprüfung

Prüfe mindestens mit einer Sitzung über 6 Tickets.

## Untersuchung — Ticket 1

Sichtbar:

- `Ticket 1 von 6`
- `Ticket untersuchen`
- Fortschritt ≈ 1/6
- kein Score
- kein Drag-Hinweis erforderlich

## Priorisierung — dasselbe Ticket

Sichtbar:

- `Ticket 1 von 6`
- `Priorität zuordnen`
- derselbe Fortschritt ≈ 1/6
- `Monster greifen und auf eine Priorität ziehen.`

Prüfe:

- Monster lässt sich weiterhin fokussieren,
- Pinch funktioniert,
- Drag funktioniert,
- HUD blockiert nichts,
- Hinweis blockiert nichts.

## Teamzuordnung — dasselbe Ticket

Sichtbar:

- `Ticket 1 von 6`
- `Team zuordnen`
- derselbe Fortschritt ≈ 1/6
- `Monster greifen und dem zuständigen Team zuordnen.`

Prüfe erneut Drag.

## Nächstes Ticket

Nach Teamfeedback:

- `Ticket 2 von 6`
- Fortschritt ≈ 2/6

## Gezielter Fortschrittstest

Bei Ticket 3 von 6:

- Anzeige exakt `Ticket 3 von 6`
- ProgressView = 50 %

## Letztes Ticket

Bei Ticket 6 von 6:

- Anzeige `Ticket 6 von 6`
- ProgressView = 100 %

## Regression

Mindestens einen vollständigen Ticketzyklus prüfen:

`Untersuchung → Priorität → Team → nächstes Ticket`

Dabei:

- Scoring unverändert,
- Audio unverändert,
- 1,5-s-Transition unverändert,
- Exactly-once unverändert.

---

# Dateien

Voraussichtlich:

## Neu

- `Ticket_Tamer/Ticket_Tamer/Views/Components/SessionHUDView.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/Components/InteractionHintView.swift`

## Geändert

- `Ticket_Tamer/Ticket_Tamer/Views/InvestigationView.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/PrioritizationView.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/TeamAssignmentView.swift`
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Nur wenn anhand des realen Codes notwendig:

- `Support/AppConstants.swift` für rein visuelle, zentrale Layoutwerte.

Nach Möglichkeit **nicht ändern**:

- `Models/SessionModel.swift`
- `Models/Ticket.swift`
- `Models/GamePhase.swift`
- `Services/DropEvaluator.swift`
- `Services/DragBounds.swift`
- `Services/MonsterDragGeometry.swift`
- `Services/TargetPanelLayout.swift`
- `Services/TargetPanelFactory.swift`
- `Services/AudioService.swift`
- `Assets/MonsterAssetProvider.swift`
- `Views/ResultView.swift`
- `Views/StartView.swift`
- RealityKitContent-Assets

Wenn der reale aktuelle Projektstand von dieser Liste abweicht, arbeite mit dem tatsächlichen Dateibaum und dokumentiere die Abweichung.

---

# Querschnitts-Anforderungen

## Ordnerstruktur

Neue wiederverwendbare SwiftUI-Komponenten unter:

`Views/Components/`

Keine parallelen `New`, `Old`, `Copy`, `Backup`-Dateien.

## Dokumentation im Code

- `///`-Doc-Kommentar an neuen Typen,
- `// MARK: -` sinnvoll einsetzen,
- Warum-Kommentare nur an nicht offensichtlichen Stellen,
- keine Kommentarwände für triviale SwiftUI-Struktur.

## Keine unnötige Architektur

Nicht einführen:

- neues Repository,
- Coordinator,
- DI-Container,
- HUD-Service,
- Tutorial-Service,
- globale UI-State-Machine.

Modul 015 ist eine kleine View-Erweiterung.

---

# Git

Vorgesehener Commit:

`015: Session-HUD und Interaktionshinweise`

Erfinde keinen Hash.

Vor Commit:

- Build,
- vollständige Tests,
- Simulatorprüfung,
- `git diff` auf Scope prüfen.

Keine v1.0-unabhängigen Änderungen in diesen Commit mischen.

---

# Ausgabeformat des Modul-Chats

Gib am Ende vollständig aus:

## 1. Vorab-Check

- Branch
- HEAD
- Working Tree
- aktueller Teststand
- Baseline-Build/Test
- relevante vorhandene Views/Schnittstellen

## 2. UI-Entwurf

- `SessionHUDView`
- `InteractionHintView`
- Layoutentscheidung
- Hit-Testing-Entscheidung
- Accessibility
- Lokalisierung

## 3. HUD-Berechnung

- currentTicketNumber
- totalTicketCount
- progress
- Phasentitel
- Verhalten bei leerer Sitzung

## 4. Änderungen je Datei

Tabelle:

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 5. Tests

- Tests vorher
- neue Tests
- Tests nachher
- Passed/Failed/Skipped
- Plattform

## 6. Simulator-/Regressionsprüfung

- Untersuchung
- Priorisierung
- Team
- Ticket 3 von 6 = 50 %
- Drag weiterhin möglich
- v1.0-Flow unverändert

## 7. Vollständiger `015-Report.md`

Der Report muss nach der vorhandenen Modul-Report-Vorlage aufgebaut sein und zusätzlich ausdrücklich enthalten:

- tatsächlichen Git-Stand,
- tatsächlichen Dateibaum der geänderten Bereiche,
- neue Komponenten und ihre Schnittstellen,
- genaue HUD-Berechnung,
- genaue Phasentitel,
- beide exakten Interaktionshinweise,
- Bestätigung: HUD zeigt keinen Score,
- Bestätigung: HUD/Hint blockieren keine 3D-Interaktion,
- Bestätigung: kein neuer SessionModel-Zustand,
- Bestätigung: keine Änderung an Drop/Scoring/Exactly-once/Audio/Transition,
- Lokalisierungsschlüssel,
- Accessibility,
- Build-/Test-/Simulatorergebnis,
- Status AK-18,
- Status AK-20,
- Regression des v1.0-Kerns,
- offene Risiken,
- Empfehlung für **Modul 016 — Kompakte Ticketinfo**.

Baue nichts außerhalb dieses Moduls um.
