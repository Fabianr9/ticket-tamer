# Modul-Eingangsprompt — 020 Integration und Abnahme v1.1

> Vom **Projektlogbuch** nach Einarbeitung des `019-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Modul 020 ist das finale Integrations- und Abnahmemodul für Version 1.1.

---

Du bist Integrations-, QA- und Abschlussverantwortliche:r für Ticket Tamer v1.1.

# Modul

**Nummer:** 020  
**Titel:** Integration und Abnahme v1.1  
**Erfüllt:** AK-18 bis AK-24 als v1.1-Integrationstest

**Ziel:** Baue, teste und prüfe den vollständigen aktuellen v1.1-Stand. Nimm AK-18 bis AK-24 real im Zusammenspiel ab und bestätige gleichzeitig, dass der abgeschlossene v1.0-Kern nicht regressiert ist. Modul 020 erfindet keine neuen Features.

---

# Ausgangsstand

## v1.0

Gilt als abgeschlossen und bildet die Pflichtbasis.

## v1.1 implementiert

### Modul 015
- F-18 Session-HUD und Fortschrittsbalken
- F-20 dauerhafte Interaktionshinweise

### Modul 016
- F-19 kompakte Ticketinfo
- lokaler Overlay-State
- Drag-Sperre

### Modul 017
- F-22 Minus-/Plus-Buttons
- F-24 Startseitenbeschreibung

### Modul 018
- F-21 visuelles Entscheidungsfeedback

### Modul 019
- F-23 Ladefehler-Recovery

## Aktueller Testquellstand

Laut 019-Report:

**298 `@Test`-Deklarationen**

Ein vollständiger Xcode-Lauf dieses Stands ist noch offen.

## Git

Laut 019-Report:

- Branch: `A`
- HEAD vor 019: `de7e4d6 feat: Modul 18`
- Modul-018-Commit: `de7e4d6`
- Modul-019-Commit: noch offen

---

# Hartes Abschluss-Gate

Version 1.1 darf nur als **abgeschlossen / abgabebereit** markiert werden, wenn:

1. aktueller Stand erfolgreich baut,
2. vollständige Testsuite ausgeführt ist,
3. AK-18 bis AK-24 real geprüft sind,
4. der v1.0-Kern nicht regressiert ist,
5. Git-/Working-Tree-Stand eindeutig dokumentiert ist.

Nichts als PASS markieren, was nicht tatsächlich nachgewiesen wurde.

Wenn ein Punkt nicht geprüft werden kann:

**OPEN**

Wenn ein Punkt real fehlschlägt:

**FAIL**

---

# Phase 1 — Git und Baseline

Ermittle real:

- aktuellen Branch
- HEAD
- Working Tree
- untracked/staged files
- tatsächlichen Modul-019-Commit

Falls Modul 019 noch uncommitted ist:

1. aktuellen Stand bauen,
2. vollständige Tests ausführen,
3. 019-Retry-Matrix im Simulator prüfen,
4. 019 separat committen,
5. erst danach 020-Abnahme dokumentieren.

Vorgesehener 019-Commit:

`019: Ladefehler-Recovery`

Hash nicht erfinden.

---

# Phase 2 — Finaler Build

Führe den aktuellen v1.1-Build in Xcode aus.

Dokumentiere:

- Xcode-Version
- visionOS SDK
- Deployment Target
- Buildziel
- Simulator/Gerät
- Build PASS/FAIL
- relevante Warnungen

Wenn Build FAIL:

- nur echte Integrations-/Regressionsfehler beheben
- keine neuen Features

---

# Phase 3 — Vollständige Testsuite

Erwarteter Quellstand:

298 Tests.

Führe die **gesamte** Suite aus.

Dokumentiere:

- tatsächliche Testzahl
- Suites
- Passed
- Failed
- Skipped
- Laufzeit
- Plattform

Wenn tatsächliche Zahl von 298 abweicht:

- Ursache prüfen
- reale Zahl dokumentieren
- nichts künstlich auf 298 bringen

Alle bestehenden Tests erhalten.

---

# Phase 4 — AK-18 Session-HUD

Prüfe in einer Sitzung mit 6 Tickets.

## Untersuchung Ticket 1

Sichtbar:

- `Ticket 1 von 6`
- `Ticket untersuchen`
- Fortschritt = 1/6
- kein Score

## Priorisierung desselben Tickets

Sichtbar:

- `Ticket 1 von 6`
- `Priorität zuordnen`
- gleicher Fortschritt 1/6

## Team desselben Tickets

Sichtbar:

- `Ticket 1 von 6`
- `Team zuordnen`
- gleicher Fortschritt 1/6

## Ticket 3

- exakt `Ticket 3 von 6`
- Fortschritt = 50 %

## Ticket 6

- exakt `Ticket 6 von 6`
- Fortschritt = 100 %

Prüfe außerdem:

- kein Score
- keine Zeit
- kein Streak
- keine Richtig-/Falsch-Statistik
- HUD blockiert keine Blick-/Pinch-/Drag-Geste

Status:

AK-18 PASS nur bei vollständiger Abnahme.

---

# Phase 5 — AK-19 Ticketinfo

In Priorisierung und Team:

1. Info öffnen.
2. Exakt aktuelles `model.currentTicket`.
3. Sichtbar:
   - Ticketnummer
   - Titel
   - Kurzbeschreibung
   - User Impact
   - Symptome/Hinweise
4. Nicht sichtbar:
   - Referenzpriorität
   - Referenzteam
   - richtige Lösung
   - Score
   - Bewertungsdaten
5. Bei offenem Overlay:
   - Monster nicht dragbar
6. X:
   - Overlay schließt
   - Drag wieder möglich, wenn fachlicher Lock frei
7. erneut Info-Tap:
   - schließt ebenfalls
8. Phasenwechsel:
   - Overlay geschlossen
9. Investigation:
   - kein zusätzlicher Info-Button

AK-19 nur PASS, wenn alle Punkte funktionieren.

---

# Phase 6 — AK-20 Interaktionshinweise

Priorisierung:

`Monster greifen und auf eine Priorität ziehen.`

Team:

`Monster greifen und dem zuständigen Team zuordnen.`

Prüfe:

- dauerhaft sichtbar
- auch während begonnener Drag-Geste
- keine Persistenz / kein AppStorage
- blockiert keine 3D-Interaktion

---

# Phase 7 — AK-21 Visuelles Feedback

Vier Fälle real prüfen:

## Priorität richtig

- grüner Haken
- `+100 Punkte`
- correct-Sound
- Lock aktiv
- keine Lösung
- nach ca. 1,5 s Team

## Priorität falsch

- rotes Kreuz
- kein Punktetext
- incorrect-Sound
- keine Lösung
- nach ca. 1,5 s Team

## Team richtig

- grüner Haken
- `+100 Punkte`
- correct-Sound
- danach nächstes Ticket / Ergebnis

## Team falsch

- rotes Kreuz
- kein Punktetext
- incorrect-Sound

Zusätzlich:

- schnelles Mehrfach-Pinchen
- erneutes Release
- kein doppelter Score
- kein doppelter Sound
- kein doppeltes Feedback
- kein doppelter Phasenwechsel

Prüfe Sichtdauer:

- nur während bestehendem ca. 1,5-s-Fenster

VoiceOver/Accessibility:

- richtig verständlich
- falsch verständlich
- keine Lösung genannt

---

# Phase 8 — AK-22 Minus-/Plus-Buttons

Startansicht:

## Startzustand

- Wert 6
- Minus enabled
- Plus enabled
- Slider vorhanden

## Plus

6 → 7

Prüfe:

- Zahl 7
- Slider 7

Bis 12:

- Plus bei 12 disabled

## Minus

12 → 11

Bis 1:

- Minus bei 1 disabled

## Slider-Synchronität

Slider auf 4:

- Zahl 4
- Minus → 3
- Plus → 4

## Reset

Nach `Erneut spielen`:

- 6
- Slider 6
- beide Buttons enabled

Accessibility exakt:

- `Ein Ticket weniger`
- `Ein Ticket mehr`

---

# Phase 9 — AK-23 Ladefehler-Recovery

Fehler kontrolliert in allen drei Monsterphasen auslösen.

## Untersuchung

- Fehlerzustand
- `Erneut laden`
- retry fail
- retry fail
- retry success
- genau ein Monster
- gleiches Ticket
- gleicher Index
- gleiche Phase

## Priorisierung

Vor/nach mehreren Retries:

- exakt 3 Prioritätsziele
- genau 1 Monster
- keine Entscheidung durch Retry
- Score unverändert
- Drag nach Erfolg möglich

## Team

Vor/nach:

- exakt 4 Teamziele
- genau 1 Monster
- gespeicherte Priorität unverändert
- keine Teamentscheidung durch Retry

## Zustandsmatrix

Vor und nach Retry:

| Feld | muss gleich bleiben |
|---|---|
| currentTicket | ja |
| currentTicketIndex | ja |
| currentPhase | ja |
| score | ja |
| selectedPriority | ja |
| selectedTeam | ja |
| isInputLocked | ja |

Prüfe:

- kein Sound
- kein visuelles Feedback
- kein Phasenwechsel
- keine doppelten Panels
- keine doppelten Monster
- kein paralleler doppelter Retry

---

# Phase 10 — AK-24 Startbeschreibung

Unter `Ticket Tamer` exakt:

`Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.`

Prüfe:

- beim App-Start
- nach `Erneut spielen`

Nicht vorhanden:

- So-funktioniert's-Button
- Tutorial-Popover
- AppStorage-Tutorialzustand

Beschreibung darf:

- Ticketsteuerung
- Spiel-starten-Button

nicht blockieren.

---

# Phase 11 — v1.0-Kernregression

Modul 020 muss zusätzlich mindestens die kritischen v1.0-Pfade erneut prüfen.

## Start / Sitzung

- 1 bis 12 Tickets
- gewünschte Zahl übernommen
- keine Ticketduplikate

## Untersuchung

- Monster
- Ticketkarte
- alle Informationen
- keine Lösung
- alle vier Monster vollständig sichtbar

## Priorisierung

- alle 3 Ziele
- Blick/Pinch/Drag
- gültiger/ungültiger Drop
- Snapback

## Team

- alle 4 Ziele
- Blick/Pinch/Drag

## Exactly-once

- Lock
- Mehrfach-Pinch
- kein doppelter Score

## Scoring

- 200
- 100
- 100
- 0

## Audio

- correct
- incorrect
- ungültiger Drop ohne Sound

## Transition

- ca. 1,5 s
- keine Lösung
- keine Extra-Weiter-Schaltfläche

## Ergebnis

Sichtbar ausschließlich:

- Scorezahl
- `Erneut spielen`

## Reset

Mindestens 5 Neustarts:

- Start
- Ticketwert 6
- Score 0
- Index 0
- Entscheidungen zurückgesetzt
- keine alten Tickets
- kein Carryover

## Volume

- genau ein zentrales Volume
- kein zweites Volume
- kein Immersive Space

---

# Phase 12 — Sitzungs-Stabilität

Mindestens real prüfen:

- 1 Ticket
- 2 Tickets
- 6 Tickets
- 12 Tickets

Mit:

- mehreren Ticketinfo-Öffnungen
- Invalid-Drops
- richtigen/falschen Entscheidungen
- mehreren Retries
- mehreren Resets

Keine:

- Crashes
- Deadlocks
- doppelte Panels
- doppelte Monster
- Score-Carryover
- hängen gebliebenen Overlays
- hängen gebliebenes DecisionFeedback

---

# Phase 13 — Layout-/Usabilityprüfung

Prüfe den durch Modul 016 vergrößerten Raum:

- Volume `1.2 × 1.15 × 0.45 m`
- Investigation-Monsterzielgröße `0.20 m`
- Drag-Phasen-Monsterzielgröße `0.11 m`
- Ticketinfo-Designfläche `520 × 560 pt`

Prüfe:

- Startseite vollständig lesbar
- HUD oben nicht abgeschnitten
- Hint unten nicht abgeschnitten
- Ticketinfo vollständig lesbar
- X erreichbar
- DecisionFeedback zentral sichtbar
- Monster nicht abgeschnitten
- Zielpanels vollständig sichtbar

Keine neue Layoutänderung ohne realen Fehler.

---

# Phase 14 — Accessibility

Mindestens prüfen:

- Minus `Ein Ticket weniger`
- Plus `Ein Ticket mehr`
- Ticketinfo Info/X
- HUD Ticketfortschritt
- DecisionFeedback richtig/falsch
- Retry `Erneut laden`

Keine Accessibility-Ausgabe darf Referenzpriorität oder Referenzteam verraten.

---

# Phase 15 — Gerätetest

Wenn Apple Vision Pro verfügbar:

Prüfe real:

- Blickfokus
- Pinch
- Drag
- HUD-Lesbarkeit
- Hint-Lesbarkeit
- Ticketinfo
- DecisionFeedback
- Plus/Minus
- Retry
- Audio

Wenn kein Gerät verfügbar:

- klar als OPEN/Risiko dokumentieren
- Simulator nicht als Gerätetest ausgeben

---

# Phase 16 — Git-/Cleanup-Check

Prüfe:

- Branch
- HEAD
- Working Tree
- Modul-019-Commit
- keine untracked Übergabedateien im Codebereich
- keine `.DS_Store`
- keine stale Lockfiles
- keine Backup-/Copy-Dateien
- keine alten parallelen aktuellen Standdokumente

Unter aktuellem Stand genau:

- `Projekt-Stand.md`
- `Logbuch-Stand.md`

---

# Finale v1.1-AK-Matrix

Erstelle für AK-18 bis AK-24:

| AK | Code | Tests | Simulator | Gerät | Status | Nachweis |
|---|---|---|---|---|---|---|
| AK-18 | | | | | PASS/OPEN/FAIL | |
| AK-19 | | | | | PASS/OPEN/FAIL | |
| AK-20 | | | | | PASS/OPEN/FAIL | |
| AK-21 | | | | | PASS/OPEN/FAIL | |
| AK-22 | | | | | PASS/OPEN/FAIL | |
| AK-23 | | | | | PASS/OPEN/FAIL | |
| AK-24 | | | | | PASS/OPEN/FAIL | |

PASS nur bei vollständigem Nachweis.

---

# Finale v1.0-Regressionsmatrix

Mindestens:

- AK-01 bis AK-16

Status:

- PASS
- OPEN
- FAIL

Nur geänderte/regressionskritische Bereiche müssen ausführlich erklärt werden, aber alle AK-01 bis AK-16 müssen im Abschlussreport einen Status erhalten.

---

# Erlaubte Änderungen in Modul 020

Nur wenn ein realer Fehler bei Integration/Abnahme gefunden wird:

- kleiner Integrationsfix
- Layoutfix
- Accessibilityfix
- Race-/State-Fix
- Retry-Fix
- Overlay-Fix

Jeder Fix im Report mit:

- Datei
- Ursache
- Änderung
- Regressionstest

Keine neuen Features.

---

# Verboten

Nicht ergänzen:

- neue Spielmodi
- Tutorial
- Highscore
- Persistenz
- Statistik
- zweites Volume
- Immersive Space
- F-17 Monsterreaktion
- neue Punkteanzeige außerhalb F-21
- neue Retry-Automatik

---

# Git

Nach erfolgreicher Integration:

`020: Integration und Abnahme v1.1`

Falls vorher noch 019 committed wird, beide echten Hashes dokumentieren.

Keine Hashes erfinden.

---

# Abschlussstatus

Am Ende genau eine Aussage:

## A — Ticket Tamer v1.1 abgenommen

Nur wenn:

- Build PASS
- Tests PASS
- AK-18 bis AK-24 PASS
- keine kritische v1.0-Regression

oder

## B — Ticket Tamer v1.1 nicht vollständig abgenommen

Dann alle OPEN/FAIL-Punkte priorisiert nennen.

Gerätetest darf separat als Restrisiko OPEN sein, wenn die Projektdokumentation dies zulässt; er darf niemals erfunden werden.

---

# Ausgabeformat

1. Vorab-Check
2. Git-/Build-/Teststand
3. AK-18 bis AK-24 Abnahme
4. v1.0-Regressionsprüfung AK-01 bis AK-16
5. Stabilitäts-/Sitzungstests
6. Layout/Accessibility
7. Gerätetest
8. Integrationsfixes
9. finale AK-Matrix v1.1
10. finale Regression-Matrix v1.0
11. finaler Git-/Working-Tree-Stand
12. Abschlussstatus A oder B
13. vollständiger `020-Report.md`

Der `020-Report.md` ist die finale technische Übergabe für Version 1.1.
