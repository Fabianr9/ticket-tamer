# Modul-Eingangsprompt — 031 Streak-State und Scoring

> Vom **Projektlogbuch** nach Einarbeitung des `030-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 031.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**.

# Modul

**Nummer:** 031  
**Titel:** Streak-State und Scoring  
**Erfüllt:** F-11, F-16, F-36, F-37 / AK-11, AK-16, AK-36, AK-37

**Ziel:** Ergänze den zentralen fachlichen `streak`-Zustand und die Exactly-once-sichere Multiplikator-/Differenzberechnung im bestehenden `SessionModel`. Eine richtige Priorität schreibt weiterhin sofort +100. Erst beim Teamabschluss wird entschieden, ob das Ticket vollständig korrekt ist, die Streak erhöht und die noch fehlende Punktedifferenz bis `200 × streak` gutgeschrieben wird. Teilweise richtige Tickets behalten ausschließlich ihre normalen Einzelpunkte und setzen die Streak auf 0. Modul 031 implementiert noch keine Streak-Visualisierung und keinen produktiven Streak-Soundtrigger.

---

# Ausgangsstand

v1.0, v1.1 und v1.2 sind abgeschlossen.

v1.3:

- 027 Tickets: committed
- 028 Teamlogos: committed
- 029 Audio: committed
- 030 Video: implementiert

Laut `030-Report.md`:

- Branch `v1.3`
- HEAD vor Modul 030 `baf8a55495e9605bbc011dbf01de061638f6a11c`
- tatsächlicher Modul-029-Commit `baf8a55` (`feat: Modul 29`)
- Modul-030-Commit im Report noch offen
- Tests vor 030: 436
- neue Tests: 38
- Tests nach 030: **474**
- Build/Test/Simulator: OPEN

---

# Vorab-Gate

## 1. Git

Ermittle real:

- Branch
- HEAD
- tatsächlichen Modul-030-Commit
- Working Tree
- staged/untracked

Wenn Modul 030 inzwischen committed ist:

- echten Hash dokumentieren.

Wenn 030 noch uncommitted ist:

- Video-Diff klar vom Modul-031-Diff trennen,
- Videocode nicht unnötig anfassen,
- 030 möglichst separat committen.

Keine Hashes erfinden.

## 2. Reale Testzahl

Dokumentierter Ausgangswert:

**474 `@Test`-Deklarationen**

Im Repository real prüfen.

Bei Abweichung:

- reale Zahl verwenden,
- Ursache dokumentieren.

## 3. Bestehende Scoringarchitektur vollständig lesen

Mindestens:

- `Models/SessionModel.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Views/Components/DecisionFeedbackView.swift`
- `Services/AudioService.swift`
- `Support/AudioResourceCatalog.swift`
- `Support/AppConstants.swift`
- `Views/ResultView.swift`
- Tests zu:
  - `evaluatePriority()`
  - `evaluateTeam()`
  - Exactly-once
  - Reset
  - Score
  - Phase transitions

Dokumentiere die reale aktuelle Signatur und Semantik von:

- `evaluatePriority()`
- `evaluateTeam()`
- `completeTicketAfterTeamFeedback()`

Nicht historische Annahmen verwenden.

---

# Verbindliche SPEC-Regeln

## F-11 — Basispunkte

- richtige Priorität = 100
- richtiges Team = 100
- falsche Einzelentscheidung = 0
- kein Punktabzug
- Punkte oberhalb der Basispunkte entstehen ausschließlich durch F-37

## F-16 — Reset

`Erneut spielen` verwirft den fachlichen Sitzungszustand einschließlich Streak.

Danach:

- Ticketanzahl 6
- Score 0
- Ticketindex 0
- Sitzungstickets leer
- Entscheidungen leer
- Input-Lock frei
- Streak 0

## F-36 — Streak-State

Neuer zentraler Zustand:

`streak: Int`

Regeln:

- neue Sitzung startet 0
- vollständig korrektes Ticket → `streak += 1`
- sobald mindestens eine der beiden Entscheidungen falsch ist → `streak = 0`
- nach Unterbrechung beginnt nächstes vollständig korrektes Ticket bei 1
- kein künstlicher Cap

## F-37 — Multiplikator-Scoring

Vollständig korrektes Ticket:

`ticketTotal = 200 × aktuelle Streak`

Da die Priorität weiter sofort bewertet wird:

`teamCredit = ticketTotal - bereits für dieses Ticket gutgeschriebene Punkte`

Teilweise richtige Tickets:

nur normale Einzelpunkte, kein Multiplikator.

---

# Verbindlicher fachlicher Zustand

Die SPEC nennt ausdrücklich:

```text
streak: Int
currentPriorityWasCorrect: Bool?
```

Beide gehören in den zentralen fachlichen Zustand.

## `streak`

- `private(set)`
- initial 0
- Start/Reset 0

## `currentPriorityWasCorrect`

Nach Prioritätsauswertung:

- true bei korrekt
- false bei falsch
- nil vor Bewertung / beim nächsten Ticket / nach Reset

Nicht in der Teamphase die Priorität erneut als UI-Hilfslogik rekonstruieren.

Die Team-Auswertung soll den bereits fachlich gespeicherten Prioritätsausgang verwenden.

---

# Prioritätsauswertung

Bestehende Semantik schützen.

## Richtig

- Exactly-once
- `currentPriorityWasCorrect = true`
- Score +100
- bestehender Correct-Monster-Sound
- bestehendes Feedback
- Streak **noch nicht erhöhen**

Warum:

Ein Ticket ist erst nach Teamentscheidung vollständig bewertet.

## Falsch

- `currentPriorityWasCorrect = false`
- Score +0
- bestehender Incorrect-Monster-Sound
- Ticket ist für diese Runde nicht streak-fähig

### Streak-Zeitpunkt bei falscher Priorität

AK-36 erlaubt:

- Streak sofort auf 0 setzen
oder
- verbindlich markieren, dass sie für dieses Ticket nicht fortgesetzt werden kann.

Bevorzuge die klarste zentrale Semantik:

**bei falscher Prioritätsauswertung `streak = 0`**

Damit ist der fachliche Zustand unmittelbar korrekt.

Spätere falsche/richtige Teamentscheidung darf die Streak nicht wiederherstellen.

---

# Team-Auswertung — zentrale Ticketabschlusslogik

Die Teamentscheidung ist der fachliche Abschluss des Tickets.

Ermittle Exactly-once:

- `teamWasCorrect`
- gespeichertes `currentPriorityWasCorrect`

## Fall A — beide korrekt

```text
currentPriorityWasCorrect == true
teamWasCorrect == true
```

Dann:

1. `streak += 1`
2. `ticketTotal = 200 × streak`
3. bereits gutgeschrieben für dieses Ticket = 100 aus Priorität
4. `teamCredit = ticketTotal - 100`
5. `score += teamCredit`

Beispiele:

### Streak 1
- Priorität +100
- Team +100
- Ticket total 200

### Streak 2
- Priorität +100
- Team +300
- Ticket total 400

### Streak 3
- Priorität +100
- Team +500
- Ticket total 600

### Streak 4
- Priorität +100
- Team +700
- Ticket total 800

Allgemein:

`teamCredit = (200 × streak) - 100`

für vollständig korrekte Tickets.

## Fall B — Priorität richtig, Team falsch

- Priorität hatte +100
- Team +0
- Ticket total 100
- `streak = 0`

## Fall C — Priorität falsch, Team richtig

- Priorität +0
- Team +100
- Ticket total 100
- `streak = 0`

## Fall D — beide falsch

- 0
- `streak = 0`

---

# Wichtig: keine Doppelzählung

Nicht:

```text
Priority +100
Team normal +100
plus danach Multiplikator 400
```

Für Streak 2 wären das fälschlich 600.

Richtig:

```text
Priority +100
TeamCredit +300
Ticket total 400
```

Die Team-Auswertung berechnet die **Differenz**, nicht einen zusätzlichen vollständigen Multiplikatorbonus.

---

# Already-credited Punkte zentral halten

UI darf nicht selbst aus dem globalen Score Delta berechnen.

Die Scoringlogik muss zentral wissen:

- Priorität korrekt? → 100 bereits gutgeschrieben
- Priorität falsch? → 0 bereits gutgeschrieben

Da `currentPriorityWasCorrect` zentral gespeichert wird, ist keine zusätzliche historische Ticketpunkteliste erforderlich.

---

# Übergabe an Modul 032

Modul 032 muss nach `evaluateTeam()` anzeigen können:

- tatsächliche mit dieser Teamentscheidung gutgeschriebene Punkte
- resultierende Streak
- ob das Ticket vollständig korrekt abgeschlossen wurde

Stelle dafür eine kleine klare **fachliche Auswertungsinformation** bereit.

Bevorzuge eine Lösung, die bestehende Call-Sites möglichst wenig bricht.

Mögliche Varianten:

## Variante A — Modell-Properties

Sinngemäß:

```text
lastTeamAwardedPoints: Int
lastCompletedTicketWasFullyCorrect: Bool
lastCompletedTicketStreak: Int
```

Diese werden ausschließlich durch Exactly-once-Team-Auswertung gesetzt und beim nächsten Ticket/Reset sauber zurückgesetzt.

## Variante B — strukturierter Rückgabewert

Sinngemäß:

```swift
struct TeamEvaluationOutcome {
    let isCorrect: Bool
    let awardedPoints: Int
    let completedTicketWasFullyCorrect: Bool
    let streak: Int
}
```

Dann aber nur, wenn die bestehende `evaluateTeam()`-API ohne unnötige Regression sauber angepasst werden kann.

### Kompatibilitätsregel

Modul 029 verwendet den Bool-Ausgang zur Auswahl Correct/Incorrect-Monster-Sound.

Modul 018/022 verwenden ihn für DecisionFeedback.

Diese Semantik darf nicht kaputtgehen.

Wenn ein strukturierter Outcome eingeführt wird, muss weiterhin eine eindeutige `isCorrect`-Information für Audio/Feedback verfügbar sein.

Keine parallele zweite Team-Bewertung nur für UI-Metadaten.

---

# Reset der ticketlokalen Auswertungsdaten

Beim Wechsel zum nächsten Ticket sowie Reset:

- `currentPriorityWasCorrect = nil`
- Team-Auswertungsmetadaten zurück auf neutral
- selectedPriority/selectedTeam wie bisher
- Exactly-once-Flags wie bisher

Kein Carry-over.

---

# StartSession

Neue Sitzung muss immer:

`streak = 0`

setzen.

Auch wenn vorheriger Zustand bereits 0 war.

Keine Streak aus alter Sitzung übernehmen.

Die vorhandene Monster-Variantenauswahl bleibt erhalten.

---

# Reset

`reset()` muss explizit:

`streak = 0`

und:

`currentPriorityWasCorrect = nil`

setzen.

Zusätzlich alle bestehenden v1.2/v1.3 Resetregeln unverändert.

---

# Kein künstlicher Cap

Nicht:

`min(streak, 4)`

oder:

`min(streak, 16)`

in der fachlichen Logik.

Die Sitzungsgröße begrenzt praktisch auf maximal 16.

Tests dürfen Streakwerte >16 rein rechnerisch prüfen, um zu bestätigen, dass kein künstlicher Cap existiert.

---

# Exactly-once schützen

Besonders wichtig:

- zweite Prioritätsbewertung → No-Op
- zweite Teambewertung → No-Op
- keine zweite Streakerhöhung
- keine zweite Differenzgutschrift
- keine zweite Resetmutation

Die bestehende `priorityEvaluated`-/`teamEvaluated`-Logik oder reale äquivalente Sperre bleibt maßgeblich.

---

# Score darf nie sinken

Auch bei Streak-Unterbrechung:

- keine Punkte zurückziehen
- keine vorherigen Multiplikatorpunkte rückgängig machen

Streakreset betrifft nur zukünftige Ticketmultiplikatoren.

---

# Ergebnisansicht

`ResultView` bleibt unverändert.

Sie zeigt weiter nur:

`X Punkte`

und:

`Erneut spielen`

Keine:

- aktuelle Streak
- Best Streak
- Statistik
- Breakdown

Die höhere Gesamtpunktzahl kommt automatisch aus `model.score`.

---

# Noch keine UI-Änderung

Modul 031 verändert nicht:

- `DecisionFeedbackView` Darstellung
- Teamfeedback-Punktetext
- x2/x3/x4+-Overlay
- HUD
- Streak-Animation

Die aktuelle Teamfeedbackdarstellung kann während dieses Modulstands noch nicht alle neuen Zusatzpunkte sichtbar kommunizieren.

Das wird bewusst erst in Modul 032 gelöst.

Wichtig:

Im `031-Report.md` diesen temporären Zwischenstand als erwartete Modulgrenze dokumentieren, nicht als Bug verschleiern.

---

# Noch kein produktiver Streak-Soundtrigger

`AudioService.playStreak(for:)` existiert seit Modul 029.

Modul 031 ruft ihn **nicht produktiv** auf.

Warum:

Modul 032 koordiniert:

- Teamfeedback
- Multiplikatoroverlay
- Zusatzpunkte
- zeitversetzten Streaksound

Keine Audio-/UI-Orchestrierung in das SessionModel ziehen.

---

# Schutz Modul 030

Nicht verändern:

- TicketVideoResourceProvider
- TicketVideoView
- Videos
- `Video ansehen`
- AVPlayer-Lifecycle
- Video-Fachzustandsschutz

Video darf den neuen Streak weder lesen noch mutieren.

Bestehende AK-33-Regel muss nach Modul 031 weiterhin gelten:

Video ansehen/Schließen verändert Streak nicht.

Falls Tests nun einen echten `streak` besitzen, ergänze Regression dafür.

---

# Schutz Modul 029

Nicht verändern:

- MonsterFeedbackSoundCatalog
- AudioService-Ressourcenlogik
- 4+4 Auswahl
- StreakSoundCatalog/Mapping
- direkte Wiederholung

---

# Schutz 027/028/v1.2

Nicht verändern:

- 16 Ticketdaten
- 1...16-Auswahl
- Teamlogos
- Dropgeometrie
- Monster-Farbvarianten
- Replay-Root
- Debug-UI-Isolation

---

# Automatisierte Tests

Ausgangswert laut 030-Report:

**474 Testdeklarationen**

Real prüfen.

Ergänze mindestens Tests für:

## Streak-Initialisierung

1. neues SessionModel → streak 0.
2. `startSession()` → streak 0.
3. `reset()` → streak 0.
4. `currentPriorityWasCorrect` initial nil.
5. Reset → `currentPriorityWasCorrect == nil`.

## Priorität

6. richtige Priorität → +100.
7. richtige Priorität → `currentPriorityWasCorrect = true`.
8. falsche Priorität → +0.
9. falsche Priorität → `currentPriorityWasCorrect = false`.
10. falsche Priorität → streak 0.
11. zweite Prioritätsbewertung → keine weitere Score-/Streakmutation.

## Vollständig korrekt

12. erstes vollständig korrektes Ticket → streak 1, Ticket 200.
13. zweites vollständig korrektes → streak 2, Ticket 400.
14. drittes → streak 3, Ticket 600.
15. viertes → streak 4, Ticket 800.
16. Streak 2 TeamCredit exakt 300.
17. Streak 3 TeamCredit exakt 500.
18. Streak 4 TeamCredit exakt 700.
19. Formel für n: `200 × n`.

## Teilweise falsch

20. Priority richtig + Team falsch → Ticket 100, streak 0.
21. Priority falsch + Team richtig → Ticket 100, streak 0.
22. beide falsch → 0, streak 0.
23. teilweise richtig → kein Multiplikator.
24. falsches Ticket nach laufender Streak setzt 0.
25. nächstes vollständig korrektes Ticket danach → streak 1.

## Exactly-once

26. zweite Team-Evaluation → keine zweite Streakerhöhung.
27. zweite Team-Evaluation → keine zweite TeamCredit-Gutschrift.
28. schnelle doppelte semantische Evaluation bleibt No-Op.
29. Score nie negativ.
30. Streakreset zieht keine alten Punkte ab.

## Kein Cap

31. fünf vollständig korrekte Tickets → streak 5.
32. 16 vollständig korrekte Tickets → streak 16.
33. reine Scoringfunktion/Logik unterstützt >16 ohne künstliches Cap, falls testbar.

## Ergebnis-Sequenzen

34. Sequenz:
   - korrekt
   - korrekt
   - korrekt
   ergibt 200 + 400 + 600 = 1200.

35. Sequenz:
   - korrekt
   - Priority korrekt/Team falsch
   - korrekt
   ergibt 200 + 100 + 200 = 500.

36. Sequenz:
   - Priority falsch/Team korrekt
   - korrekt
   ergibt 100 + 200 = 300.

37. Ergebnis-Score entspricht exakt Summe.

## Reset / nächstes Ticket

38. nächstes Ticket → `currentPriorityWasCorrect` nil.
39. nächste Sitzung → streak 0.
40. Replay/reset → streak 0.
41. Video-Präsentation beeinflusst streak nicht.
42. Monster-Retry beeinflusst streak nicht.

## Übergabedaten Modul 032

43. Teamabschluss Streak 1 → awardedPoints 100.
44. Streak 2 → awardedPoints 300.
45. Streak 3 → awardedPoints 500.
46. Priority falsch/Team richtig → awardedPoints 100, fullyCorrect false, streak 0.
47. Team falsch → awardedPoints 0.
48. zweite Evaluation verändert Übergabedaten nicht nochmals fachlich.

Keine Tests nur für Quelltextstrings statt Semantik.

---

# Rechenmatrix im Report

Dokumentiere mindestens:

| vorherige Streak | Priority | Team | neue Streak | Priority Credit | Team Credit | Ticket total |
|---:|---|---|---:|---:|---:|---:|
| 0 | ✓ | ✓ | 1 | 100 | 100 | 200 |
| 1 | ✓ | ✓ | 2 | 100 | 300 | 400 |
| 2 | ✓ | ✓ | 3 | 100 | 500 | 600 |
| 3 | ✓ | ✓ | 4 | 100 | 700 | 800 |
| 3 | ✓ | ✗ | 0 | 100 | 0 | 100 |
| 3 | ✗ | ✓ | 0 | 0 | 100 | 100 |
| 3 | ✗ | ✗ | 0 | 0 | 0 | 0 |

---

# Voraussichtlich relevante Dateien

Primär:

- `Models/SessionModel.swift`
- Tests

Möglicherweise:

- kleine reine Scoringstruktur unter `Models/` oder `Services/`, wenn sie die zentrale Logik klarer und testbarer macht

Nur falls reale API-Anpassung nötig:

- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`

Aber:

Keine UI-Neugestaltung.

Nach Möglichkeit unverändert:

- DecisionFeedbackView
- AudioService
- AudioResourceCatalog
- TicketVideoView
- TicketVideoResourceProvider
- TeamLogoCatalog
- LocalTicketCatalog
- Ticket
- TargetPanelLayout
- DropEvaluator
- RootVolumeView
- ResultView

---

# DebugManager

Bestehende `.state` verwenden.

Sinnvoll loggen:

- Streak 0→1
- 1→2
- Reset auf 0
- TeamCredit

Keine Referenzlösung im Log.

Keine neue Kategorie nötig.

---

# Git

Vor Modul 031:

Modul 030 separat committen, falls noch offen.

Vorgesehen:

`030: Ticketvideo-System`

Modul 031:

`031: Streak-State und Scoring`

Vor Commit:

- Scoring-Matrix prüfen
- vollständige Tests
- Build falls möglich
- Exactly-once Regression
- Reset
- 16er-Streak
- `git diff --check`
- Scope-Diff

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 030-Commit
- Working Tree
- reale Testzahl
- Build/Teststatus
- aktuelle evaluatePriority/evaluateTeam-Signaturen

## 2. Streak-State

- neue Properties
- Initialwert
- StartSession
- nächstes Ticket
- Reset

## 3. Scoringarchitektur

- Priority Credit
- Team Credit
- vollständig korrekt
- teilweise korrekt
- Exactly-once

## 4. Rechenmatrix

| vorherige Streak | Priority | Team | neue Streak | Priority | Team | Ticket |
|---:|---|---|---:|---:|---:|---:|

## 5. Übergabedaten für Modul 032

- awarded team points
- resulting streak
- fully-correct flag
- Schnittstelle

## 6. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 7. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 8. Regression

- Audio 029
- Video 030
- Exactly-once
- Reset
- ResultView
- Monster Retry
- Replay

## 9. Vollständiger `031-Report.md`

Der Report muss ausdrücklich enthalten:

- realen Gitstand
- tatsächlichen 030-Commit
- reale Testzahl
- `streak`-Property
- `currentPriorityWasCorrect`
- Initial-/Start-/Resetwerte
- exakte zentrale Scoringformel
- TeamCredit für Streak 1/2/3/4
- teilweise richtige Fälle
- kein künstlicher Cap
- Exactly-once-Nachweis
- Ergebnis-Sequenztests
- finale Übergabeschnittstelle für Modul 032
- Bestätigung: noch kein Streak-Overlay
- Bestätigung: noch kein produktiver Streak-Soundtrigger
- Bestätigung: Video verändert Streak nicht
- AK-11 PASS/OPEN/FAIL
- AK-16 PASS/OPEN/FAIL
- AK-36 PASS/OPEN/FAIL
- AK-37 PASS/OPEN/FAIL
- Build/Teststatus
- offene Risiken
- Empfehlung für **Modul 032 — Streak-Feedback v1.3**

Baue nichts außerhalb dieses Moduls um.
