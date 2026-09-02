# Modul-Eingangsprompt — 019 Ladefehler-Recovery

> Vom Projektlogbuch nach Einarbeitung des `018-Report.md` erzeugt. In einen neuen Modul-Chat einfügen.

Du bist Fachentwickler:in für genau dieses eine Modul.

## Modul

**Nummer:** 019  
**Titel:** Ladefehler-Recovery  
**Erfüllt:** F-23 / AK-23

**Ziel:** Ergänze in Untersuchung, Priorisierung und Teamzuordnung bei Monster-Ladefehlern die Aktion `Erneut laden`. Ein Retry lädt ausschließlich das Monster des aktuellen Tickets neu und verändert weder fachlichen Sitzungszustand noch Score, Entscheidungen oder bereits bestehende Zielpanels.

## F-23

> Bei einem Monster-Ladefehler zeigt das System in Untersuchung, Priorisierung und Teamzuordnung die Aktion „Erneut laden“. Ein Wiederholungsversuch lädt ausschließlich das aktuelle Monster neu und verändert weder fachlichen Sitzungszustand noch Score oder bereits aufgebaute Zielpanels.

## AK-23

- Bei Ladefehler in Untersuchung, Priorisierung oder Teamzuordnung ist `Erneut laden` sichtbar.
- Retry setzt den vorherigen Ladefehler zurück und lädt das aktuelle Monster erneut.
- Retry verändert weder aktuelles Ticket noch Ticketindex noch Phase noch Score noch gespeicherte Entscheidungen.
- In Priorisierung/Team entstehen keine zusätzlichen Zielpanels.
- Nach erfolgreichem Retry geht dieselbe Phase normal weiter.
- Mehrere Retries erzeugen weder doppelte Monster noch doppelte Zielpanels.

## Vorab-Check

1. Git: Branch, HEAD, Working Tree, tatsächlicher Modul-018-Commit.
2. Falls 018 noch uncommitted ist: zuerst Build, 278 Tests, Simulatorprüfung und separaten 018-Commit nachholen.
3. Reale Ladepfade vollständig lesen:
   - `Assets/MonsterAssetProvider.swift`
   - `Views/InvestigationView.swift`
   - `Views/PrioritizationView.swift`
   - `Views/TeamAssignmentView.swift`
   - vorhandene Load-State-Hilfstypen
   - `Localizable.xcstrings`
   - Tests
4. Für jede Phase dokumentieren:
   - Monster-State
   - Error-State
   - Loading-State
   - Initial-Load
   - Entity-Einfügelogik
   - Zielpanel-Erzeugung

## Architektur

Retry-State bleibt lokal oder in einer kleinen rein ladebezogenen Hilfsabstraktion.

Nicht in `SessionModel`.

Keine neuen fachlichen Felder wie:

- retryCount
- monsterLoadError
- isRetrying

im SessionModel.

### Zentrale Regel

Monsterloading und Zielpanel-Erzeugung müssen getrennt sein.

Retry darf nur das Monster ersetzen.

Prioritäts- und Team-Panels müssen idempotent genau einmal bestehen bleiben.

## Untersuchung

Bei Fehler:

- verständlicher bestehender Fehlerzustand
- Button exakt `Erneut laden`

Retry:

1. alten Fehler löschen
2. Loading starten
3. `model.currentTicket.monsterAssetId` erneut laden
4. bei Erfolg genau ein Monster anzeigen
5. gleiche Phase
6. gleiches Ticket

Ticketkarte bleibt unverändert.

## Priorisierung

Bei Fehler:

- HUD/Hint bleiben
- `Erneut laden`
- kein Drag ohne Monster

Retry:

- nur Monster neu laden
- drei Prioritätsziele nicht neu erzeugen
- keine Entscheidung speichern

Nach Erfolg:

- genau ein Monster
- exakt drei Ziele
- Drag wieder möglich, sofern fachlicher Lock false

## Teamzuordnung

Analog:

- nur Monster neu
- exakt vier Teamziele
- bereits gespeicherte Priorität bleibt unverändert
- keine Teamentscheidung durch Retry

## Mehrfach-Retry

Testfall:

```text
fail → Retry fail → Retry fail → Retry success
```

Danach:

- genau ein Monster
- keine doppelten Panels
- gleicher Index
- gleiche Phase
- gleicher Score
- gleiche Entscheidungen
- gleicher `isInputLocked`

Kein Retry-Limit.

## Parallel-Task-Schutz

Während ein Retry läuft:

- Button deaktivieren oder ausblenden
- kein zweiter paralleler Load-Task

Ein Tap = ein Loadversuch.

## Erfolgreicher Retry

Nach Erfolg:

- Fehler nil
- Loading aus
- Retry-Button weg
- genau ein Monster
- normale Phase geht weiter

## Erneuter Fehler

Bei erneutem Fehler:

- Fehlerzustand wieder sichtbar
- `Erneut laden` wieder verfügbar

## Fachzustand schützen

Retry darf nicht aufrufen:

- `startSession()`
- `advanceToNextTicket()`
- `savePriority()`
- `saveTeam()`
- `evaluatePriority()`
- `evaluateTeam()`
- `lockInput()`
- `unlockInput()`
- `reset()`

Nur wegen Retry.

Unverändert bleiben:

- currentTicket
- currentTicketIndex
- currentPhase
- score
- selectedPriority
- selectedTeam
- isInputLocked

## Keine Nebenwirkungen

Retry erzeugt nicht:

- Bewertung
- Sound
- visuelles Entscheidungsfeedback
- Phasenwechsel
- Snapback
- neues HUD
- neue Ticketinfo
- neue Panels

## Lokalisierung

Sichtbar exakt:

`Erneut laden`

in `Localizable.xcstrings`.

## DebugManager

Bestehende Kategorie `.spawning` nutzen für:

- Retry gestartet
- Retry erfolgreich
- Retry fehlgeschlagen

Keine neue Kategorie.

## Tests

Ausgangswert laut 018-Report: 278 Testdeklarationen.

Mindestens ergänzen:

1. Fehlerzustand bietet Retry.
2. Retry löscht alten Fehler.
3. Retry lädt dieselbe monsterAssetId.
4. Index unverändert.
5. Phase unverändert.
6. Score unverändert.
7. selectedPriority unverändert.
8. selectedTeam unverändert.
9. isInputLocked unverändert.
10. kein paralleler zweiter Retry.
11. Erfolg beendet Fehlerzustand.
12. erneuter Fehler bietet Retry erneut.
13. mehrere Fail-Retries + Success → genau ein Monster.
14. Prioritäts-Retry erzeugt keine neuen Ziele.
15. Team-Retry erzeugt keine neuen Ziele.
16. keine Bewertung.
17. kein Sound.
18. kein Phasenwechsel.
19. keine Referenzwerte nötig.
20. Retry-State nicht im SessionModel.

Keine überkomplexen RealityKit-Mocks. Kleine idempotente Hilfslogik darf testbar gekapselt werden.

## Testbarkeit von Fehlern

Produktive Tickets behalten gültige IDs.

Für Tests minimalen kontrollierten Fehlerpfad ermöglichen, z. B.:

- injizierbare interne Load-Closure
- kleine loaderbezogene Funktion
- unbekannte Asset-ID nur im Test

Keine absichtlich kaputte produktive Ticket-ID.

## Simulatorprüfung

### Untersuchung
- Fehler → Retry sichtbar
- fail → fail → success
- genau ein Monster
- gleiches Ticket/gleiche Phase

### Priorisierung
- vor/nach Retry exakt drei Ziele
- genau ein Monster
- Drag nach Erfolg möglich
- keine Entscheidung durch Retry

### Team
- exakt vier Ziele
- genau ein Monster
- Prioritätsentscheidung unverändert

### Zustandsmatrix
Vor/nach Retry dokumentieren:

| Feld | vor | nach |
|---|---|---|
| Ticket | | |
| Index | | |
| Phase | | |
| Score | | |
| Priority | | |
| Team | | |
| Lock | | |

## Harte Modulgrenze

Nur F-23/AK-23.

Nicht ändern:

- HUD 015
- Ticketinfo 016
- Startseite 017
- Feedback 018
- Scoring
- Audio
- Exactly-once
- 1,5-s-Transition
- DropEvaluator
- DragBounds
- 50-%-Overlap
- Z-Toleranz
- Snapback
- Asset-Mapping
- ResultView

## Voraussichtliche Dateien

Wahrscheinlich geändert:

- `Views/InvestigationView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Optional minimal:

- `Assets/MonsterAssetProvider.swift`
- kleine loaderbezogene Hilfsstruktur unter `Services/`

## Git

Vor 019 Modul 018 separat committen.

Vorgesehen:

`018: Visuelles Entscheidungsfeedback`

Modul 019:

`019: Ladefehler-Recovery`

Keine Hashes erfinden.

## Ausgabeformat

1. Vorab-Check
2. reale Ladearchitektur aller drei Phasen
3. Retry-Architektur
4. Phase-für-Phase-Verhalten
5. Fachzustandsschutz
6. Änderungen je Datei
7. Tests
8. Simulator-/Regressionstest
9. vollständiger `019-Report.md`

Der Report muss ausdrücklich bestätigen:

- Retry lädt nur aktuelles Monster
- gleiches Ticket/Index/Phase
- gleicher Score
- Entscheidungen und Lock unverändert
- keine neuen Zielpanels
- keine doppelten Monster
- keine Bewertung
- kein Sound
- kein Phasenwechsel
- Verhalten bei mehrfachen Fehlversuchen
- Build/Test/Simulatorstatus
- Status AK-23
- Empfehlung für Modul 020 — Integration und Abnahme v1.1

Baue nichts außerhalb dieses Moduls um.
