# Modul-Eingangsprompt — 032 Streak-Feedback v1.3

> Vom **Projektlogbuch** nach Einarbeitung des `031-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 032.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**.

# Modul

**Nummer:** 032  
**Titel:** Streak-Feedback v1.3  
**Erfüllt:** F-18, F-21, F-35, F-38 / AK-18, AK-21, AK-35, AK-38

**Ziel:** Erweitere ausschließlich den bestehenden Teamabschluss-Feedbackflow: Eine richtige Teamentscheidung zeigt exakt die bei dieser Teamentscheidung tatsächlich gutgeschriebenen Punkte aus `SessionModel.lastTeamAwardedPoints`. Bei vollständig korrektem Ticket mit resultierender Streak ≥ 2 erscheint kurz `x2`, `x3`, `x4` usw.; x2/x3 verwenden die normale Darstellung, x4+ eine sichtbar größere Darstellung mit kurzer Puls-/Scale-Animation. Zusätzlich wird nach dem positiven Monster-Sound leicht zeitversetzt genau ein vorhandener Streak-Sound abgespielt. Score, Streak und Korrektheit werden in der UI niemals neu berechnet.

---

# Ausgangsstand

v1.0, v1.1 und v1.2 sind abgeschlossen.

v1.3:

- 027 Tickets committed
- 028 Teamlogos committed
- 029 Audio committed
- 030 Video committed
- 031 Streak-State und Scoring implementiert

Laut `031-Report.md`:

- Branch `v1.3`
- HEAD vor Modul 031: `8041bf9d8cbe8f2a63c982a2418a32e56a3b3d36`
- tatsächlicher Modul-030-Commit: `8041bf9`
- Modul-031-Commit im Report noch offen
- Tests vor 031: 474
- neue Tests: 48
- Tests nach 031: **522**
- Build/Test/Simulator: OPEN

---

# Vorab-Gate

## 1. Git

Ermittle real:

- Branch
- HEAD
- tatsächlichen Modul-031-Commit
- Working Tree
- staged/untracked

Wenn Modul 031 inzwischen committed ist:

- echten Hash dokumentieren.

Wenn 031 noch uncommitted ist:

- Scoring-Diff klar vom 032-UI-Diff trennen,
- Scoring nicht nebenbei umbauen,
- 031 möglichst separat committen.

Keine Hashes erfinden.

## 2. Reale Testzahl

Dokumentierter Ausgangswert:

**522 `@Test`-Deklarationen**

Real prüfen.

Bei Abweichung:

- reale Zahl verwenden,
- Ursache dokumentieren.

## 3. Bestehenden Feedbackflow vollständig lesen

Mindestens:

- `Models/SessionModel.swift`
- `Views/Components/DecisionFeedbackView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Views/Components/SessionHUDView.swift`
- `Services/AudioService.swift`
- `Support/AudioResourceCatalog.swift`
- `Support/AppConstants.swift`
- `Resources/Localizable.xcstrings`
- relevante Tests aus 018/022/029/031

Dokumentiere real:

- wie `DecisionFeedbackView` aktuell Punkte darstellt,
- wo `decisionFeedback` gesetzt wird,
- wo Monster-Audio ausgelöst wird,
- wo der 1,5-s-Feedbacktask lebt,
- wann `completeTicketAfterTeamFeedback()` aufgerufen wird.

Keine parallele zweite Feedbacktask einführen.

---

# Source of Truth aus Modul 031

Nach der **einzigen** gültigen Team-Auswertung stehen bereit:

```text
lastTeamAwardedPoints
lastCompletedTicketWasFullyCorrect
lastCompletedTicketStreak
```

Diese drei Werte sind für Modul 032 verbindlich.

## Nicht neu berechnen

Die View darf **nicht**:

- `referencePriority` vergleichen,
- `referenceTeam` vergleichen,
- `selectedPriority` gegen Referenz vergleichen,
- `selectedTeam` gegen Referenz vergleichen,
- globale Score-Differenzen vorher/nachher ableiten,
- Streak selbst inkrementieren,
- Multiplikator mathematisch neu berechnen.

Sie liest ausschließlich die bereits fachlich berechneten Abschlussdaten.

---

# F-21 — dynamisches positives Punktefeedback

Die aktuelle Prioritätsdarstellung bleibt:

## Priorität richtig

- grüner Haken
- exakt `+100 Punkte`

## Priorität falsch

- rotes Kreuz
- exakt `0 Punkte`

Team wird dynamisch.

## Team richtig

- grüner Haken
- exakt die Punkte aus `lastTeamAwardedPoints`

Beispiele:

| Fall | Teamfeedback |
|---|---|
| vollständig korrekt, Streak 1 | `+100 Punkte` |
| vollständig korrekt, Streak 2 | `+300 Punkte` |
| vollständig korrekt, Streak 3 | `+500 Punkte` |
| vollständig korrekt, Streak 4 | `+700 Punkte` |
| Priorität falsch, Team richtig | `+100 Punkte` |

## Team falsch

- rotes Kreuz
- `0 Punkte`

Die Darstellung mutiert niemals den Score.

---

# DecisionFeedbackView — Architektur

Bevorzuge eine kleine Darstellungsstruktur, die Resultat und **bereits berechnete Punkte** erhält.

Zum Beispiel sinngemäß:

```swift
struct DecisionFeedbackPresentation {
    let result: DecisionFeedbackResult
    let awardedPoints: Int
}
```

oder:

```swift
DecisionFeedbackView(
    result: ...,
    awardedPoints: ...
)
```

Wichtig:

- Priorität übergibt 100/0 aus der bereits bekannten Entscheidung.
- Team übergibt `model.lastTeamAwardedPoints`.
- `DecisionFeedbackView` berechnet keine Multiplikatoren.
- `DecisionFeedbackView` liest keinen `SessionModel`.
- kein Ticket/Referenzteam/Referenzpriorität in der Komponente.

## Punktetext

Richtig:

`+\(awardedPoints) Punkte`

Falsch:

`0 Punkte`

Wenn `awardedPoints == 0` im incorrect-Fall, kein `+0 Punkte`.

Lokalisierung über String Catalog.

---

# Accessibility F-21

Dynamisch korrekt kommunizieren.

Beispiele:

- Priorität richtig → `Entscheidung richtig, 100 Punkte`
- Team richtig x2 → `Entscheidung richtig, 300 Punkte`
- Team richtig x3 → `Entscheidung richtig, 500 Punkte`
- falsch → `Entscheidung falsch, 0 Punkte`

Keine Lösung nennen.

---

# F-38 — Streak-Overlay

## Sichtbarkeitsbedingung

Nur wenn:

```text
lastCompletedTicketWasFullyCorrect == true
&& lastCompletedTicketStreak >= 2
```

Dann kurz anzeigen:

`xN`

mit N = resultierende Streak.

Beispiele:

- 2 → `x2`
- 3 → `x3`
- 4 → `x4`
- 5 → `x5`
- 16 → `x16`

## Kein Overlay

- Streak 0
- Streak 1
- Priority falsch / Team richtig
- Priority richtig / Team falsch
- beide falsch
- Prioritätsentscheidung

---

# Keine dauerhafte HUD-Anzeige

F-18/AK-18 sind verbindlich:

Der Session-HUD zeigt weiterhin nur:

- Ticket X von Y
- Phasentitel
- Fortschritt

Nicht dauerhaft:

- Score
- Streak
- Multiplikator

Nicht `SessionHUDView` um xN erweitern.

Das Streak-Overlay ist ausschließlich temporäres Teamfeedback.

---

# Streak-Darstellung x2/x3

x2 und x3:

- gleiche normale Darstellung
- gut lesbar
- klar getrennt vom Punktefeedback
- kurz sichtbar
- nicht interaktiv
- `.allowsHitTesting(false)`

Keine zusätzliche starke Pulsanimation für x2/x3.

---

# Stärkere Darstellung ab x4

Ab `x4`:

- sichtbar größer als x2/x3
- zusätzliche kurze Puls-/Scale-Animation

x5, x6 ... x16:

- dieselbe stärkere Darstellungslogik

Nicht für jeden Streakwert eine neue Sonderdarstellung bauen.

Bevorzuge reine Ableitung:

```text
streak < 4 → normal
streak >= 4 → emphasized
```

---

# Mögliche neue Komponente

Bevorzuge:

`StreakFeedbackView`

mit reinem Präsentationsmodell.

Sinngemäß:

```swift
enum StreakFeedbackEmphasis {
    case normal
    case emphasized
}

struct StreakFeedbackPresentation {
    let streak: Int

    var isVisible: Bool
    var text: String
    var emphasis: ...
}
```

Nur UI.

Kein `SessionModel`-Mutator.

Keine Audioauslösung in der View.

---

# Layout

Das Overlay muss in der **Teamzuordnungsphase** während des bestehenden Feedbackfensters sichtbar sein.

Es darf Tickettext, Teamziele oder notwendige Bedienelemente nicht dauerhaft verdecken.

Bevorzuge:

- zentriert/leicht oberhalb des bestehenden DecisionFeedback,
- oder klar innerhalb der Feedbackkarte,
- ohne Teamziele dauerhaft zu blockieren.

Da während der gültigen Entscheidung der Input bereits gesperrt ist, darf das Overlay optisch zentral sein; es muss aber nicht die gesamte Szene mit einer riesigen undurchsichtigen Fläche abdecken.

Keine Änderung an:

- Panelpositionen
- Dropgeometrie
- HUD-Ankern

---

# Sichtdauer

Der bestehende Feedbackablauf liegt historisch bei ungefähr 1,5 Sekunden.

Das Streak-Overlay soll **innerhalb dieses bestehenden Feedbackfensters** erscheinen und danach verschwinden.

Nicht:

- zusätzliche 1,5 Sekunden anhängen,
- Spielablauf wegen Streak künstlich verlängern,
- zweiten unabhängigen Transitiontask starten.

Wenn eine Pulsanimation läuft, muss sie innerhalb des vorhandenen Feedbackfensters abgeschlossen werden.

---

# F-35 — produktiver Streak-Soundtrigger

Seit Modul 029 vorhanden:

```text
AudioService.playStreak(for:)
```

Mapping:

- 0/1 → keiner
- 2/3 → Sound 01
- 4+ → Sound 02

Modul 032 verdrahtet ihn jetzt produktiv.

## Triggerbedingung

Nur nach Team-Evaluation und nur wenn:

```text
lastCompletedTicketWasFullyCorrect == true
&& lastCompletedTicketStreak >= 2
```

Nie in der Prioritätsphase.

## Reihenfolge

Bei qualifiziertem Teamabschluss:

1. positiver Monster-Sound genau einmal
2. kurze technische Verzögerung
3. Streak-Sound genau einmal
4. bestehendes Feedbackfenster/Transition endet weiterhin insgesamt ungefähr nach 1,5 s

Die beiden Sounds sollen nicht unbeabsichtigt exakt gleichzeitig gestartet werden.

Wähle eine kleine dokumentierte Verzögerung, die innerhalb des bestehenden Feedbackfensters liegt.

Beispielsweise ist ein Bereich von ca. 0,15–0,25 s technisch plausibel; der tatsächliche Wert ist zu begründen und zentral als Timing-Konstante abzulegen.

Wichtig:

Wenn du vor dem Streak-Sound schläfst, ziehe diese Zeit vom verbleibenden bestehenden Feedbackdelay ab, damit die Gesamtdauer nicht ungewollt wächst.

Keine zweite Transitiontask.

---

# Genau ein Monster-Sound + höchstens ein Streak-Sound

Qualifizierter Teamabschluss:

- 1 Correct-Monster-Sound
- 1 Streak-Sound

Nicht qualifiziert:

- nur 1 Monster-Sound

Falsches Team:

- 1 Incorrect-Monster-Sound
- kein Streak-Sound

Priorität:

- genau 1 Monster-Sound
- niemals Streak-Sound

---

# Exactly-once

Der vorhandene Team-Feedbacktask ist die einzige Orchestrierung.

Schnelle Mehrfacheingabe darf nicht erzeugen:

- zweite Team-Evaluation
- zweite Scoremutation
- zweite Streakerhöhung
- zweites Streak-Overlay
- zweiten Monster-Sound
- zweiten Streak-Sound
- zweiten Phasenwechsel

Verwende die bereits bestehenden Guards:

- `isInputLocked`
- `feedbackTaskStarted`
- `teamEvaluated`
- reale äquivalente Mechanismen

Keine neue konkurrierende Taskkette.

---

# Teamabschluss-Daten lokal snapshotten

Wichtig:

Modul 031 neutralisiert Abschlussmetadaten beim nächsten Ticket.

Deshalb direkt nach der einzigen `evaluateTeam()`-Auswertung die für die aktuelle Feedbackdarstellung benötigten Werte in **lokalen View-Presentation-State** snapshotten:

```text
evaluation Bool
awardedPoints
fullyCorrect
resultingStreak
```

Dieser lokale Snapshot ist reine Darstellung.

Er darf nicht zurück ins `SessionModel` schreiben.

So bleibt das Overlay während des Feedbackfensters stabil, selbst wenn später der fachliche nächste Schritt vorbereitet wird.

---

# Priorisierungsphase minimal halten

PrioritizationView:

- Haken/X
- +100 oder 0
- genau 1 Monster-Sound
- kein Streak-Overlay
- kein Streak-Sound

Nur anpassen, wenn `DecisionFeedbackView` durch die neue `awardedPoints`-Schnittstelle einen Parameter benötigt.

Keine sonstige Prioritätsänderung.

---

# Teamphase

TeamAssignmentView orchestriert nach der einzigen Bewertung:

```text
evaluateTeam()
→ Bool
→ Snapshot:
   - lastTeamAwardedPoints
   - lastCompletedTicketWasFullyCorrect
   - lastCompletedTicketStreak
→ DecisionFeedback setzen
→ optional StreakFeedback setzen
→ Monster-Sound
→ optional verzögert Streak-Sound
→ restliches bestehendes Feedbackdelay
→ lokalen Feedbackstate löschen
→ completeTicketAfterTeamFeedback()
```

Keine erneute Bewertung.

---

# Streak 1

Vollständig korrektes erstes Ticket:

- Teamfeedback +100
- kein x1-Overlay
- kein Streak-Sound

Das ist explizit AK-35/AK-38.

---

# Streak 2

Vollständig korrektes zweites Ticket:

- Teamfeedback +300
- `x2`
- normale Streakdarstellung
- Streak-Sound 01
- positiver Monster-Sound bleibt ebenfalls

---

# Streak 3

- Teamfeedback +500
- `x3`
- normale Darstellung
- Streak-Sound 01

---

# Streak 4

- Teamfeedback +700
- `x4`
- größer
- Puls-/Scale-Animation
- Streak-Sound 02

---

# Streak 5+

Beispiel x5:

- Teamfeedback +900
- `x5`
- gleiche emphasized-Darstellung wie x4+
- Streak-Sound 02

Kein Cap.

---

# Teilweise richtige Fälle

## Priority korrekt, Team falsch

- Teamfeedback `0 Punkte`
- kein Multiplikator
- kein Streak-Sound
- Streak 0

## Priority falsch, Team korrekt

- Teamfeedback `+100 Punkte`
- kein Multiplikator
- kein Streak-Sound
- Streak 0

Wichtig:

Team correct allein reicht **nicht** für Streakfeedback.

---

# Keine zusätzliche Scoremutation

`DecisionFeedbackView`, `StreakFeedbackView` und Audioorchestrierung:

dürfen niemals:

- `model.score +=`
- `model.streak +=`
- `evaluateTeam()` erneut
- `evaluatePriority()` erneut

aufrufen.

Modul 031 ist fachliche Source of Truth.

---

# Lokalisierung

String Catalog für:

- dynamischen positiven Punktetext
- Accessibility mit dynamischen Punkten
- ggf. Accessibility des Multiplikators

`x2`, `x3`, `x4` sind kompakte Spielnotation und können als formatierter Multiplikator dargestellt werden.

Accessibility dafür sinngemäß:

- `Multiplikator x2`
- oder verständlich `Streak-Multiplikator 2`

Wähle eine verständliche deutsche Ausgabe.

Keine Lösungsausgabe.

---

# Animation

Für x4+:

kurze Scale-/Pulse-Animation.

Beispielhaft:

- Start kleiner/normal
- kurzer Scale-Up-Puls
- zurück auf Zielgröße

Nicht:

- Endlosschleife
- dauerhafter Bounce
- Animation über den Phasenwechsel hinaus

Animation muss mit View-Abbau sauber enden.

---

# Schutz Audio 029

Nicht verändern:

- 4+4-Katalog
- Random-Selector
- direkte Wiederholung
- `StreakSoundCatalog`
- Ressourcenpfade

Nur bestehenden `playStreak(for:)` produktiv aufrufen.

---

# Schutz Scoring 031

Nicht verändern:

- `streak`
- `currentPriorityWasCorrect`
- `lastTeamAwardedPoints`
- `lastCompletedTicketWasFullyCorrect`
- `lastCompletedTicketStreak`
- Scoringformel
- Exactly-once-Evaluation

Wenn ein Buildfehler in 031 auftaucht:

- separat als 031-Nachfix dokumentieren,
- nicht still die Scoringarchitektur in 032 umbauen.

---

# Schutz Video 030

Nicht verändern:

- TicketVideoView
- TicketVideoResourceProvider
- 16 MP4s
- Videozustand

Video beeinflusst Streak weiterhin nicht.

---

# Schutz Teamlogos / Drop

Nicht verändern:

- TeamLogoCatalog
- JPEGs
- Teamtext
- TargetPanelLayout
- DropTargetComponent
- DropEvaluator
- 50-%-Overlap
- Z-Toleranz
- Snapback

---

# Schutz HUD

Nicht verändern:

`SessionHUDView` soll keinen Streak bekommen.

AK-18:

- Ticket X von Y
- Phase
- Fortschritt
- kein Score
- kein dauerhafter Multiplikator

---

# Tests

Ausgangswert laut 031-Report:

**522 Testdeklarationen**

Real im Preflight prüfen.

Ergänze mindestens Tests für:

## DecisionFeedback

1. Priorität correct → +100.
2. Priorität incorrect → 0.
3. Team correct awarded 100 → +100.
4. Team correct awarded 300 → +300.
5. Team correct awarded 500 → +500.
6. Team correct awarded 700 → +700.
7. Team correct awarded 900 → +900.
8. Team incorrect → 0.
9. Anzeige mutiert keinen Score.
10. Anzeige benötigt keine Referenzwerte.

## StreakPresentation

11. streak 0 → nicht sichtbar.
12. streak 1 → nicht sichtbar.
13. streak 2 → `x2`, normal.
14. streak 3 → `x3`, normal.
15. streak 4 → `x4`, emphasized.
16. streak 5 → `x5`, emphasized.
17. streak 16 → `x16`, emphasized.
18. kein künstlicher Cap.
19. fullyCorrect false + streak >=2 → nicht sichtbar.
20. nur Teamabschluss kann sichtbare Präsentation erzeugen.

## Streak-Audio

21. streak 0 → kein Streak-Sound.
22. streak 1 → keiner.
23. streak 2 fullyCorrect → Sound 01.
24. streak 3 fullyCorrect → Sound 01.
25. streak 4 fullyCorrect → Sound 02.
26. streak 5 fullyCorrect → Sound 02.
27. fullyCorrect false → kein Streak-Sound.
28. Prioritätsentscheidung → kein Streak-Sound.
29. pro qualifiziertem Teamabschluss höchstens ein Streak-Sound.

## Timing/Exactly-once

30. Monster-Sound bleibt genau einmal.
31. Streak-Sound folgt nur qualifiziert.
32. zweite Team-Evaluation erzeugt keinen zweiten Streak-Trigger.
33. Feedbacktransition bleibt insgesamt bei bestehender Zielzeit ungefähr 1,5 s.
34. Streak-Sounddelay ist kleiner als Gesamtfeedbackdelay.
35. restliches Delay wird defensiv nicht negativ.

## Abschlussdaten

36. UI-Presentation verwendet `lastTeamAwardedPoints`.
37. x2-Presentation verwendet `lastCompletedTicketStreak = 2`.
38. fullyCorrect ist Gate.
39. Team correct nach falscher Priority → +100, kein xN.
40. Team falsch nach richtiger Priority → 0, kein xN.

## HUD

41. SessionHUD hat weiterhin keinen Streak.
42. SessionHUD hat weiterhin keinen Score.
43. StreakPresentation ist temporär und separat vom HUD.

## Accessibility

44. +300 Accessibility kommuniziert 300 Punkte.
45. +500 Accessibility kommuniziert 500 Punkte.
46. x2 Accessibility verständlich.
47. x4 Accessibility verständlich.
48. keine Referenzlösung in Accessibility.

## Regression

49. ResultView bleibt X Punkte.
50. Video beeinflusst Feedback nicht.
51. Teamlogos unverändert.
52. Dropgeometrie unverändert.
53. Monster-Soundgruppen unverändert.
54. Scoringsequenz 1200 bleibt unverändert.

Keine Tests, die die Punktelogik in der UI duplizieren.

---

# Simulatorprüfung

## Priorität

Richtig:

- Haken
- +100
- Correct-Monster-Sound
- kein xN
- kein Streak-Sound

Falsch:

- X
- 0 Punkte
- Incorrect-Monster-Sound
- kein xN

## Team — Streak 1

- Haken
- +100
- Correct-Monster-Sound
- kein x1
- kein Streak-Sound

## Team — Streak 2

- Haken
- +300
- x2
- normale Streakdarstellung
- Correct-Monster-Sound
- leicht danach Streak-Sound 01

## Team — Streak 3

- Haken
- +500
- x3
- normal
- Sound 01

## Team — Streak 4

- Haken
- +700
- x4
- sichtbar größer
- Pulse/Scale
- Sound 02

## Team — Streak 5

- Haken
- +900
- x5
- gleiche starke Logik
- Sound 02

## Partial

Priority falsch + Team richtig:

- +100
- kein xN
- kein Streak-Sound

Priority richtig + Team falsch:

- 0 Punkte
- kein xN
- kein Streak-Sound

## Exactly-once

Schnelles Mehrfach-Pinchen:

- ein Monster-Sound
- höchstens ein Streak-Sound
- ein Feedback
- eine Scoringmutation
- ein Transition

## Layout

Prüfe:

- xN verdeckt Teamziele nicht dauerhaft
- HUD bleibt unverändert
- Ticketinfo bleibt erreichbar vor Entscheidung
- kein Layoutdrift durch Overlay

---

# Voraussichtlich relevante Dateien

Primär:

- `Views/Components/DecisionFeedbackView.swift`
- neue `Views/Components/StreakFeedbackView.swift`
- `Views/PrioritizationView.swift` nur für neue Punkteparameter
- `Views/TeamAssignmentView.swift`
- `Support/AppConstants.swift` für kleine Feedback-Timing-/Layoutwerte
- `Resources/Localizable.xcstrings`
- Tests

Nach Möglichkeit unverändert:

- `Models/SessionModel.swift`
- `Services/AudioService.swift` außer zwingender nicht-fachlicher API-Ergänzung
- `Support/AudioResourceCatalog.swift`
- `SessionHUDView.swift`
- Video-Code
- TeamLogoCatalog
- Dropgeometrie
- Ticketdaten
- ResultView
- RootVolumeView

---

# Git

Vor Modul 032:

Modul 031 separat committen, falls noch offen.

Vorgesehen:

`031: Streak-State und Scoring`

Modul 032:

`032: Streak-Feedback v1.3`

Vor Commit:

- Build falls möglich
- vollständige Tests
- x2/x3/x4/x5-Simulatorprüfung
- Team-Punktetexte 100/300/500/700
- Audiofolge
- Exactly-once
- HUD-Regression
- `git diff --check`
- Scope-Diff

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 031-Commit
- Working Tree
- reale Testzahl
- Build/Test/Simulatorstatus
- bestehender Feedback-/Audioflow

## 2. Dynamisches Punktefeedback

| Fall | Awarded Points | Anzeige |
|---|---:|---|
| Priority correct | 100 | +100 |
| Team x1 | 100 | +100 |
| Team x2 | 300 | +300 |
| Team x3 | 500 | +500 |
| Team x4 | 700 | +700 |
| Incorrect | 0 | 0 Punkte |

## 3. Streak-Presentation

| Streak | sichtbar | Stil |
|---:|---|---|
| 0 | nein | – |
| 1 | nein | – |
| 2 | x2 | normal |
| 3 | x3 | normal |
| 4+ | xN | emphasized + pulse |

## 4. Audioorchestrierung

- Monster-Sound
- Delay
- Streak-Sound
- restliches Feedbackdelay
- Exactly-once

## 5. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 6. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 7. Simulator-/Regressionstest

- Priorität correct/incorrect
- Team x1/x2/x3/x4/x5
- Partial-Fälle
- Audiofolge
- HUD
- Exactly-once
- Layout
- Video/Logo/Drop-Regression

## 8. Vollständiger `032-Report.md`

Der Report muss ausdrücklich enthalten:

- realen Gitstand
- tatsächlichen 031-Commit
- reale Testzahl
- finale DecisionFeedback-Schnittstelle
- Bestätigung: Teamfeedback liest `lastTeamAwardedPoints`
- Bestätigung: kein UI-Scoring
- x2/x3 normale Darstellung
- x4+ größere Darstellung + Pulse/Scale
- kein x1
- kein dauerhafter Streak im HUD
- finalen Streak-Sounddelay
- Sound 01 für x2/x3
- Sound 02 für x4+
- Bestätigung: kein Streak-Sound bei Priorität
- Bestätigung: höchstens ein Streak-Sound je Teamabschluss
- Bestätigung: Monster-Sound weiterhin genau einmal
- Bestätigung: Gesamtfeedbackdauer nicht ungewollt verlängert
- AK-18 PASS/OPEN/FAIL
- AK-21 PASS/OPEN/FAIL
- AK-35 PASS/OPEN/FAIL
- AK-38 PASS/OPEN/FAIL
- Build/Test/Simulatorstatus
- offene Risiken
- Empfehlung für **Modul 033 — Integration und Abnahme v1.3**

Baue nichts außerhalb dieses Moduls um.
