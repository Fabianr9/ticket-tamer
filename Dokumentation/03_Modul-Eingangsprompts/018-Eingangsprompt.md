# Modul-Eingangsprompt — 018 Visuelles Entscheidungsfeedback

> Vom **Projektlogbuch** nach Einarbeitung des `017-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 018.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**. Baue nur, was hier beauftragt ist.

# Modul

**Nummer:** 018  
**Titel:** Visuelles Entscheidungsfeedback  
**Erfüllt:** F-21 / AK-21

**Ziel:** Ergänze innerhalb des bereits vorhandenen ca. 1,5 Sekunden langen Feedbackfensters eine rein visuelle Richtig-/Falsch-Rückmeldung: richtige Entscheidung = grüner Haken + `+100 Punkte`, falsche Entscheidung = rotes Kreuz ohne Punktetext. Nutze ausschließlich das bereits vorhandene Bool-Ergebnis der Bewertung und verändere weder Scoring noch Sound noch Exactly-once noch Phasenwechsel.

---

# F-21 — verbindlicher Wortlaut

> Das System zeigt während des bestehenden Feedbackfensters zusätzlich zum Sound bei einer richtigen Entscheidung einen grünen Haken mit `+100 Punkte` und bei einer falschen Entscheidung ein rotes Kreuz ohne Punktetext.

# AK-21 — verbindliche Abnahme

1. GEGEBEN eine richtige Prioritäts- oder Teamentscheidung wurde bewertet, WENN das Feedbackfenster beginnt, DANN erscheinen ein gut sichtbarer grüner Haken und der Text `+100 Punkte`.
2. GEGEBEN eine falsche Prioritäts- oder Teamentscheidung wurde bewertet, WENN das Feedbackfenster beginnt, DANN erscheint ein gut sichtbares rotes Kreuz und **kein** Punktetext.
3. Das visuelle Feedback erscheint parallel zum bereits vorhandenen passenden Erfolgs- beziehungsweise Fehlersound.
4. Das visuelle Feedback bleibt nur während des vorhandenen ungefähr 1,5 Sekunden langen Feedbackfensters sichtbar und ist danach zurückgesetzt.
5. Das Feedback zeigt weder die richtige Priorität noch das richtige Team noch eine textliche Begründung.
6. Während des Feedbackfensters bleibt die vorhandene Eingabesperre aktiv.
7. Eine gültige Entscheidung erzeugt weiterhin genau eine Bewertung, genau einen Sound und genau einen Phasenwechsel.
8. Haken und Kreuz besitzen geeignete Accessibility-Labels, die das Ergebnis verständlich beschreiben.

---

# Verbindlicher v1.1-Kontext

Bereits implementiert:

## Modul 015

- Session-HUD
- Drag-Hinweise

## Modul 016

- CompactTicketInfoView
- Info-Button
- Drag-Sperre bei offenem Overlay

Commits:

- `8d60045 feat: Modul 16`
- `0d25719 fix: Modul 16`

## Modul 017

- Startseiten-Kurzbeschreibung
- Minus-/Plus-Buttons
- Slider bleibt
- Testdeklarationen nach 017: 261

Modul-017-Commit laut Report noch offen.

Build/Test/Simulator nach 017 ebenfalls offen.

---

# Verbindlicher Vorab-Check

## 1. Git

Ermittle real:

- aktuellen Branch,
- HEAD,
- Working Tree,
- tatsächlichen Modul-017-Commit oder uncommitted Stand.

Wenn Modul 017 noch uncommitted ist:

1. Build des aktuellen Stands durchführen,
2. vollständige 261er-Suite durchführen,
3. kurze Simulatorprüfung der Startseite,
4. Modul 017 separat committen,
5. erst danach 018-Code beginnen.

Keine 017-Änderungen mit 018 vermischen.

## 2. Baseline

Prüfe real:

- tatsächliche Testzahl,
- Buildstatus,
- Simulatorstatus,
- HUD 015,
- Ticketinfo 016,
- Startseite 017.

Wenn Xcode nicht verfügbar:

- klar dokumentieren,
- keine PASS-Zahlen erfinden.

## 3. Relevante Dateien lesen

Mindestens:

- `Models/SessionModel.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Services/AudioService.swift`
- `Support/AppConstants.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Zusätzlich reale aktuelle Implementierung der Feedback-Tasks in Priorisierung/Team prüfen.

---

# Bestehende Bewertungslogik — NICHT duplizieren

Aus Modul 010 vorhanden:

```text
evaluatePriority() -> Bool?
evaluateTeam() -> Bool?
```

Semantik:

- `true` = richtige Entscheidung, Score wurde genau einmal +100 erhöht
- `false` = falsche Entscheidung, Score bleibt unverändert
- `nil` = ungültig oder bereits bewertet; keine neue Feedbackauslösung

Diese Rückgabe ist die **einzige Quelle** für das neue visuelle Feedback.

Nicht erneut vergleichen:

- `selectedPriority == referencePriority`
- `selectedTeam == referenceTeam`

Nicht erneut Score erhöhen.

---

# Bestehender Feedbackflow

Priorität sinngemäß:

```text
savePriority
→ Input-Lock
→ evaluatePriority()
→ bool richtig/falsch
→ AudioService
→ 1,5 s warten
→ beginTeamAssignmentPhase()
```

Team:

```text
saveTeam
→ Input-Lock
→ evaluateTeam()
→ bool richtig/falsch
→ AudioService
→ 1,5 s warten
→ completeTicketAfterTeamFeedback()
```

Modul 018 ergänzt ausschließlich innerhalb dieses Fensters:

```text
bool richtig/falsch
→ sichtbares Feedback setzen
→ Sound abspielen
→ vorhandene 1,5 s
→ sichtbares Feedback zurücksetzen / View verlässt Phase
→ bestehender Phasenwechsel
```

Keine zweite Task-Kette, wenn die vorhandene sicher erweitert werden kann.

---

# Architekturentscheidung

## Neue wiederverwendbare Komponente

Erstelle bevorzugt:

`Views/Components/DecisionFeedbackView.swift`

Reine SwiftUI-Darstellung.

Sie erhält nur das Darstellungsresultat.

Beispielsweise als kleiner interner Typ:

```text
DecisionFeedbackResult
- correct
- incorrect
```

oder semantisch gleichwertig.

Kein Ticket, keine Referenzwerte, kein Score-Modelzugriff.

## Lokaler Feedback-State

Der sichtbare Feedbackzustand soll view-lokal sein.

Beispielsweise:

```text
@State private var decisionFeedback: DecisionFeedbackResult?
```

in:

- `PrioritizationView`
- `TeamAssignmentView`

Nicht in `SessionModel`.

Warum:

- fachliche Bewertung existiert bereits,
- Feedback ist nur temporäre Darstellung,
- Zustand endet mit Feedbackfenster/Phasenwechsel.

Keine zweite fachliche Source of Truth.

---

# Konkreter Arbeitsauftrag

## 1. `DecisionFeedbackView` bauen

Darstellung richtig:

- gut sichtbarer grüner Haken
- exakt sichtbarer Text:

`+100 Punkte`

Darstellung falsch:

- gut sichtbares rotes Kreuz
- **kein Punktetext**

Keine weiteren sichtbaren Texte.

Insbesondere nicht:

- `Richtig`
- `Falsch`
- `Normal`
- `Wichtig`
- `Kritisch`
- Teamname
- `+0 Punkte`
- Erklärung.

## 2. Symbole

Bevorzuge SF Symbols:

- richtig: `checkmark`
- falsch: `xmark`

oder eine klare kreisförmige Variante, falls sie im realen Layout besser lesbar ist.

Wichtig ist Semantik:

- grün + Haken
- rot + Kreuz

Keine Lösungscodierung über Zielpanel-Farben.

## 3. Accessibility

Richtiges Feedback benötigt ein verständliches Accessibility-Label.

Beispielsweise sinngemäß:

`Entscheidung richtig, 100 Punkte`

Falsches Feedback:

`Entscheidung falsch`

Die exakten Accessibility-Texte müssen in `Localizable.xcstrings` gepflegt werden.

Accessibility darf keine richtige Priorität oder richtiges Team nennen.

## 4. Prioritätsfeedback integrieren

Beim ersten erfolgreichen:

`evaluatePriority()`

mit Rückgabe:

### `true`

- sichtbarer State = correct
- correct-Sound wie bisher
- 1,5-s-Flow wie bisher

### `false`

- sichtbarer State = incorrect
- incorrect-Sound wie bisher
- 1,5-s-Flow wie bisher

### `nil`

- kein neues visuelles Feedback
- kein neuer Sound
- kein neuer Task
- kein neuer Phasenwechsel

## 5. Teamfeedback integrieren

Identische Darstellung auf Basis von:

`evaluateTeam()`

Keine zweite Logikimplementierung für Punkte.

## 6. Dauer exakt an vorhandenes Fenster koppeln

Feedback darf nicht:

- vor der Bewertung erscheinen,
- über den bestehenden Phasenwechsel hinaus sichtbar bleiben,
- eine eigene zusätzliche 1,5-s-Verzögerung erzeugen.

Bevorzugt:

- visuelles State direkt nach erfolgreicher Bewertung setzen,
- bestehendes Sleep weiterverwenden,
- State unmittelbar vor Transition zurücksetzen oder durch View-Lebenszyklus sicher entfernen.

Wichtig:

**Gesamtdauer des Flows darf sich nicht auf ca. 3 Sekunden verdoppeln.**

## 7. Input-Lock nicht verändern

Während Feedback:

`model.isInputLocked == true`

bleibt wie bisher maßgeblich.

Modul 018 darf nicht:

- zusätzlich locken, wenn dies bereits erfolgt,
- `unlockInput()` früher rufen,
- Overlay-State mit Input-Lock vermischen.

## 8. Exactly-once schützen

Eine gültige Entscheidung muss weiterhin erzeugen:

- genau eine Bewertung,
- genau einen Scoreeffekt,
- genau einen Sound,
- genau einen Feedbackzustand,
- genau einen Phasenwechsel.

Keine Feedbackauslösung über:

- `onAppear`,
- Render-Refresh,
- mehrere `.onChange`,
- zweite parallele Task.

Die bestehende `feedbackTaskStarted`-Absicherung aus Modul 010 prüfen und weiterverwenden, sofern noch vorhanden.

## 9. Ticketinfo-Zusammenspiel

Modul 016 kann Ticketinfo in Entscheidungsphasen öffnen.

Prüfe:

- sobald eine gültige Entscheidung erfolgt und Feedback startet, darf kein altes Ticketinfo-Overlay darüber hängen,
- idealerweise ist Ticketinfo zu diesem Zeitpunkt bereits geschlossen, weil Drag nur bei geschlossenem Overlay erlaubt ist.

Nicht Modul-016-Logik umbauen, sofern kein realer Konflikt besteht.

## 10. HUD / InteractionHint

HUD oben und Interaktionshinweis unten bleiben bestehen.

Das visuelle Feedback soll klar sichtbar sein, ohne:

- HUD dauerhaft zu ersetzen,
- Drag-Hinweis permanent umzubauen,
- Zielpanelgeometrie zu verändern.

Da während Feedback Input ohnehin gesperrt ist, darf das Feedback zentral über der Szene liegen.

Bevorzuge ein nicht interaktives SwiftUI-Overlay:

`.allowsHitTesting(false)`

## 11. Kein Score-HUD

`+100 Punkte` darf ausschließlich innerhalb des Feedbackfensters bei richtiger Entscheidung erscheinen.

Nicht:

- dauerhaft im Session-HUD,
- nach dem Feedback,
- bei falscher Entscheidung,
- als laufender Gesamtpunktestand.

Die SPEC verlangt weiterhin, dass der Score während der Sitzung außerhalb des Feedback-Overlays verborgen bleibt.

## 12. Falsch-Fall

Bei falscher Entscheidung:

- rotes Kreuz,
- **kein `+0 Punkte`**,
- kein anderer Punktetext.

Das ist ausdrücklich verbindlich.

## 13. Lokalisierung

Neue sichtbare/accessibility Texte in:

`Localizable.xcstrings`

Mindestens:

- `+100 Punkte`
- richtiges Accessibility-Label
- falsches Accessibility-Label

Keine Text-Literale verstreuen, wenn bestehende Projektstruktur String Catalog nutzt.

---

# Harte Modulgrenze

Modul 018 bearbeitet ausschließlich F-21 / AK-21.

Nicht implementieren:

## Modul 019

- kein `Erneut laden`
- keine Retry-Pipeline
- keine Ladefehleränderung

## Modul 020

- keine finale v1.1-Abnahme vorziehen

Nicht verändern:

- StartView aus 017
- Ticketinfo aus 016
- HUD/Hint aus 015
- Scoringregeln
- Audiofiles
- AudioService-Verhalten, außer minimal nötige Aufrufintegration
- DropEvaluator
- DragBounds
- 50-%-Overlap
- Z-Toleranz
- Snapback
- Monstergrößen
- Volume-Größe
- Ticketdaten
- Ergebnisansicht.

---

# Automatisierte Tests

Erhalte alle vorhandenen Tests.

Ausgangswert laut 017-Report:

261 Testdeklarationen.

Ergänze mindestens Tests für:

1. correct → sichtbarer Zustand `correct`.
2. incorrect → sichtbarer Zustand `incorrect`.
3. correct-Darstellung enthält `+100 Punkte`.
4. incorrect-Darstellung enthält keinen Punktetext.
5. correct-Darstellung verwendet Haken.
6. incorrect-Darstellung verwendet Kreuz.
7. richtiges Accessibility-Label.
8. falsches Accessibility-Label.
9. `nil`-Bewertung erzeugt keinen Feedbackzustand.
10. Feedbackresultat benötigt keine Referenzpriorität.
11. Feedbackresultat benötigt kein Referenzteam.
12. Feedbackresultat enthält keinen Score-Gesamtwert.
13. bestehende Bewertung erhöht bei richtig weiterhin nur einmal +100.
14. falsche Bewertung weiterhin +0.
15. zweiter Bewertungsaufruf erzeugt keinen neuen Feedbacktrigger.
16. visuelles Feedback verändert `isInputLocked` nicht selbst.
17. Reset/Phasenwechsel hinterlässt keinen persistenten sichtbaren Feedbackzustand.

Wenn eine kleine reine Darstellungs-/Mappingstruktur die Tests stabil macht, ist sie zulässig.

Keine neuen fachlichen SessionModel-Felder.

Nach Änderungen vollständige Suite ausführen.

Dokumentiere:

- vorher
- neue Tests
- nachher
- Passed/Failed/Skipped
- Plattform

---

# Simulatorprüfung

## Richtige Priorität

1. Priorität korrekt ablegen.
2. Sofort:
   - grüner Haken,
   - `+100 Punkte`,
   - correct-Sound.
3. Input bleibt gesperrt.
4. Keine Lösung sichtbar.
5. Nach ca. 1,5 s:
   - Teamphase,
   - Feedback verschwunden.

## Falsche Priorität

1. falsch ablegen.
2. Sofort:
   - rotes Kreuz,
   - incorrect-Sound,
   - kein Punktetext.
3. Keine Lösung.
4. nach ca. 1,5 s Teamphase.

## Richtiges Team

- grüner Haken
- `+100 Punkte`
- correct-Sound
- danach nächstes Ticket / Ergebnis

## Falsches Team

- rotes Kreuz
- kein Punktetext
- incorrect-Sound

## Exactly-once

Schnell mehrfach pinchen / erneutes Release:

- kein zweiter Haken/Kreuz-Task
- kein doppelter Sound
- kein doppelter Score
- kein doppelter Phasenwechsel.

## Regression v1.1

Prüfe kurz:

- HUD noch sichtbar,
- Hint noch sichtbar,
- Ticketinfo weiterhin öffnet/schließt,
- Startseite aus 017 unverändert.

---

# Voraussichtlich relevante Dateien

## Neu

- `Ticket_Tamer/Ticket_Tamer/Views/Components/DecisionFeedbackView.swift`

## Geändert

- `Ticket_Tamer/Ticket_Tamer/Views/PrioritizationView.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/TeamAssignmentView.swift`
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Nur falls echte zentrale visuelle Konstanten benötigt werden:

- `Support/AppConstants.swift`

Nach Möglichkeit unverändert:

- `SessionModel.swift`
- `StartView.swift`
- `CompactTicketInfoView.swift`
- `SessionHUDView.swift`
- `InteractionHintView.swift`
- `AudioService.swift`
- Drop-/Geometry-Services
- MonsterAssetProvider
- ResultView
- RealityKitContent.

---

# DebugManager

Keine neue Kategorie.

Optional `.state` für:

- Feedback correct/incorrect gestartet
- Feedback beendet

Aber kein Log auf Render-Ebene.

Keine Referenzwerte loggen.

---

# Git

## Vor 018

Modul 017 sauber separat committen.

Vorgesehen:

`017: Startseiten-Usability`

Tatsächlichen Hash dokumentieren.

## Modul 018

Vorgesehen:

`018: Visuelles Entscheidungsfeedback`

Vor Commit:

- Build
- vollständige Tests
- Simulatorprüfung
- `git diff --check`
- Scope-Diff prüfen

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch/HEAD
- Modul-017-Commit
- Working Tree
- Build/Test/Simulator 017
- tatsächliche Testzahl

## 2. Feedback-Entwurf

- DecisionFeedbackView
- correct/incorrect
- Haken/Kreuz
- `+100 Punkte`
- Accessibility
- Layout
- Hit-Testing

## 3. Integration in vorhandenen Feedbackflow

- evaluatePriority/evaluateTeam
- Bool als einzige Quelle
- Sound parallel
- 1,5 s unverändert
- Reset des visuellen States
- Input-Lock
- Exactly-once

## 4. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 5. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 6. Simulator-/Regressionstest

- richtige/falsche Priorität
- richtiges/falsches Team
- genau ein Sound/Score/Feedback/Transition
- HUD/Ticketinfo/Startseite Regression

## 7. Vollständiger `018-Report.md`

Der Report muss zusätzlich ausdrücklich enthalten:

- tatsächlichen Git-Stand
- tatsächlichen 017-Commit
- tatsächliche Testzahl
- neue Feedback-Komponente und Schnittstelle
- richtige Darstellung: grüner Haken + `+100 Punkte`
- falsche Darstellung: rotes Kreuz, kein Punktetext
- exakte Accessibility-Texte
- Bestätigung: keine Lösung
- Bestätigung: keine erneute Referenzwertauswertung
- Bestätigung: keine neue Punktevergabe
- Bestätigung: 1,5-s-Fenster nicht verlängert
- Bestätigung: Input-Lock unverändert
- Bestätigung: Exactly-once unverändert
- Bestätigung: Sound parallel
- Build/Test/Simulatorergebnis
- Status AK-21
- offene Risiken
- Empfehlung für **Modul 019 — Ladefehler-Recovery**.

Baue nichts außerhalb dieses Moduls um.
