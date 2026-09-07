# Modul-Eingangsprompt — 022 Punktekommunikation v1.2

> Vom Projektlogbuch nach Einarbeitung des `021-Report.md` erzeugt. In einen neuen Modul-Chat einfügen.

Du bist Fachentwickler:in für genau dieses eine Modul.

## Modul

**Nummer:** 022  
**Titel:** Punktekommunikation v1.2  
**Erfüllt:** F-26, F-27 / AK-26, AK-27

**Ziel:** Kennzeichne die Gesamtpunktzahl in der Ergebnisansicht sichtbar mit `Punkte` und ergänze bei falschen Entscheidungen im bestehenden Feedbackfenster den Text `0 Punkte`. Punkteberechnung, Sounds, Exactly-once, Eingabesperre und 1,5-s-Transition bleiben unverändert.

## Ausgangsstand

v1.0 und v1.1 sind abgeschlossen.

Modul 021 hat den Replay-Layoutfix implementiert, AK-25 ist aber noch laufzeitseitig OPEN.

Laut 021-Report:

- Branch `A`
- HEAD vor 021 `3536b46 feat: Modul: 20`
- Modul-021-Commit offen
- 298 Tests vorher
- 8 neue Tests
- **306 Testdeklarationen nachher**
- Build/Test/Simulator offen

Die spätere Angabe „304-Test-Lauf“ im Report widerspricht der Testtabelle und ist als Zahlendreher zu behandeln. Im Preflight reale Zahl prüfen.

## Vorab-Gate

### Git

Ermittle real:

- Branch
- HEAD
- Working Tree
- tatsächlichen Modul-021-Commit

Falls 021 noch uncommitted:

- realen 021-Diff identifizieren
- nach Möglichkeit Build, vollständige Tests und Replay-Abnahme nachholen
- 021 separat committen
- 022 nicht mit 021 vermischen

### Relevante Dateien lesen

Mindestens:

- `Views/ResultView.swift`
- `Views/Components/DecisionFeedbackView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Models/SessionModel.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Die Replay-Rootarchitektur aus 021 nicht neu gestalten.

## F-26 — Ergebnis als X Punkte

Die Ergebnisansicht muss die Gesamtpunktzahl mit Einheit anzeigen, zum Beispiel:

`600 Punkte`

### AK-26

- Score 600 → exakt `600 Punkte`
- jeder andere gültige Score → exakt `<score> Punkte`
- `Erneut spielen` bleibt vorhanden
- keine Maximalpunktzahl
- keine Prozentzahl
- kein Rang
- keine Statistik
- keine zusätzlichen Ergebniskennzahlen

### Umsetzung

`ResultView` liest weiterhin ausschließlich `model.score`.

Keine neue Ergebnislogik.

Verwende einen String-Catalog-Formatstring, sinngemäß:

`%lld Punkte`

Nicht mehrere lokalisierte Fragmente zusammensetzen.

Beispiele:

- 0 → `0 Punkte`
- 100 → `100 Punkte`
- 600 → `600 Punkte`
- 1200 → `1200 Punkte`

## F-27 — 0 Punkte bei falscher Entscheidung

Falsches Feedback zeigt nun:

- rotes Kreuz
- exakt `0 Punkte`

Richtig bleibt:

- grüner Haken
- exakt `+100 Punkte`

### AK-27

- falsche Priorität → rotes Kreuz + `0 Punkte`
- falsches Team → rotes Kreuz + `0 Punkte`
- richtig → weiterhin Haken + `+100 Punkte`
- `0 Punkte` verändert internen Score nicht
- kein Punktabzug
- keine richtige Lösung
- keine Begründung
- Sound unverändert
- Input-Lock unverändert
- Exactly-once unverändert
- ca. 1,5-s-Transition unverändert

## Architektur

Die vorhandene Darstellung bleibt zentral in:

`DecisionFeedbackView`

Nicht zwei getrennte 0-Punkte-Darstellungen in Priorisierung und Team bauen.

`DecisionFeedbackResult` bleibt:

- correct
- incorrect

Kein neuer fachlicher State.

Die einzige Bewertungsquelle bleibt:

- `evaluatePriority() -> Bool?`
- `evaluateTeam() -> Bool?`

Nicht erneut Referenzpriorität oder Referenzteam vergleichen.

## Falsch-Fall

Für `.incorrect`:

- `xmark`
- rot
- `0 Punkte`

Nicht:

- `+0 Punkte`
- `Keine Punkte`
- `Falsch: 0 Punkte`

## Richtig-Fall

Unverändert:

`+100 Punkte`

Keine neue Formulierung.

## Accessibility

Incorrect künftig sinngemäß:

`Entscheidung falsch, 0 Punkte`

Correct weiterhin sinngemäß:

`Entscheidung richtig, 100 Punkte`

Keine Accessibility-Ausgabe darf richtige Priorität oder richtiges Team nennen.

## Lokalisierung

Im bestehenden String Catalog pflegen:

- Ergebnisformat `<score> Punkte`
- `0 Punkte`
- Accessibility incorrect mit 0 Punkten

Bestehendes `+100 Punkte` wiederverwenden.

Kein vollständiger Lokalisierungsrefactor.

## Geschützte Logik

Nicht ändern:

- `SessionModel.score`
- `evaluatePriority()`
- `evaluateTeam()`
- AudioService
- `feedbackTaskStarted`
- `isInputLocked`
- Exactly-once
- Sleep-Dauer
- Phasenwechsel
- DropEvaluator
- DragBounds
- Snapback
- Retry 019
- Replay-Rootarchitektur 021

`0 Punkte` ist ausschließlich sichtbare Kommunikation des bereits bestehenden +0-Effekts.

## Schutz von Modul 021

Nicht verändern:

- `GeometryReader3D`-Rootbasis
- `.defaultSize`
- Slider-Designbreite
- Priority-/Team-Rasterwerte
- Monstergrößen
- HUD-/Hint-Anker

Wenn 021 im Build einen Fehler zeigt, als separaten 021-Nachfix dokumentieren.

## Tests

Ausgangswert dokumentiert: **306 Testdeklarationen**, real im Preflight prüfen.

Mindestens ergänzen:

1. Score 0 → `0 Punkte`
2. Score 100 → `100 Punkte`
3. Score 600 → `600 Punkte`
4. Score 1200 → `1200 Punkte`
5. Ergebnisformat enthält keine Maximalpunktzahl
6. Ergebnisformat enthält keinen Prozentwert
7. Restart-Semantik unverändert
8. incorrect enthält `0 Punkte`
9. incorrect enthält Kreuz
10. correct enthält weiterhin `+100 Punkte`
11. correct enthält Haken
12. false mappt weiter auf incorrect
13. falsche Bewertung verändert Score um 0
14. zweite Bewertung bleibt No-Op
15. Feedback benötigt keine Referenzpriorität
16. Feedback benötigt kein Referenzteam
17. incorrect Accessibility kommuniziert 0 Punkte
18. correct Accessibility bleibt korrekt
19. keine Lösungstexte

Vollständige Suite ausführen und echte Zahlen dokumentieren.

## Simulatorprüfung

### Ergebnis

Prüfe mindestens:

- `0 Punkte`
- `100 Punkte`
- `600 Punkte`

Immer zusätzlich:

- `Erneut spielen`
- keine Statistik
- keine Prozentzahl
- keine Maximalpunktzahl

### Falsche Priorität

- rotes Kreuz
- `0 Punkte`
- incorrect-Sound
- Score unverändert
- keine Lösung
- nach ca. 1,5 s Team

### Falsches Team

- rotes Kreuz
- `0 Punkte`
- incorrect-Sound
- keine Lösung

### Richtige Entscheidung

- grüner Haken
- `+100 Punkte`
- correct-Sound

### Exactly-once

Schnelles Mehrfach-Pinchen:

- keine doppelte Bewertung
- kein doppelter Sound
- kein doppeltes Feedback
- kein doppelter Phasenwechsel

## Harte Modulgrenze

Nur F-26/F-27.

Nicht implementieren:

- Team-Symbole → 023
- DEV-Isolation → 024
- Monster-Farbvarianten → 025
- Gesamtintegration → 026

## Voraussichtlich relevante Dateien

Primär:

- `Views/ResultView.swift`
- `Views/Components/DecisionFeedbackView.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Nach Möglichkeit unverändert:

- `SessionModel.swift`
- `PrioritizationView.swift`
- `TeamAssignmentView.swift`
- `AudioService.swift`
- `RootVolumeView.swift`
- `StartView.swift`
- `TargetPanelLayout.swift`
- Monster-/Drop-/Retry-Code

## Git

Vor 022 Modul 021 separat committen, sobald seine vorgeschriebene Abnahme möglich ist.

Vorgesehen:

`021: Replay-Layoutstabilisierung`

Für Modul 022:

`022: Punktekommunikation v1.2`

Keine Hashes erfinden.

## Ausgabeformat

1. Vorab-Check
2. Punktekommunikations-Entwurf
3. Schutz von Scoring/Audio/Exactly-once/Transition
4. Änderungen je Datei
5. Tests
6. Simulator-/Regressionstest
7. vollständiger `022-Report.md`

Der Report muss ausdrücklich enthalten:

- realen Gitstand
- tatsächlichen 021-Commit
- reale Testzahl
- Ergebnisformat `X Punkte`
- falsches Feedback `0 Punkte`
- richtiges Feedback weiterhin `+100 Punkte`
- keine neuen Ergebnisstatistiken
- Scoring unverändert
- Sound unverändert
- Lock/Exactly-once unverändert
- 1,5-s-Transition unverändert
- keine Lösung
- Build/Test/Simulatorstatus
- AK-26 PASS/OPEN/FAIL
- AK-27 PASS/OPEN/FAIL
- offene Risiken
- Empfehlung für **Modul 023 — Teamstation-Symbole**

Baue nichts außerhalb dieses Moduls um.
