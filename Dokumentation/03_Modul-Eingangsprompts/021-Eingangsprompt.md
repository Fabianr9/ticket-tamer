# Modul-Eingangsprompt — 021 Replay-Layoutstabilisierung

> Vom **Projektlogbuch** zum Start von Ticket Tamer v1.2 erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 021.

---

Du bist Fachentwickler:in und Integrationsverantwortliche:r für **genau dieses eine Modul**.

# Modul

**Nummer:** 021  
**Titel:** Replay-Layoutstabilisierung  
**Erfüllt:** F-25 / AK-25

**Ziel:** Reproduziere und behebe den Replay-Layoutfehler zentral, sodass Ergebnis → `Erneut spielen` weder Startansicht, Slider, Texte, Prioritätsziele noch Teamziele verkleinert, vergrößert oder über mehrere Sitzungen kumulativ driften lässt. Die aktuell tatsächlich verwendete Volume-Größe muss beim Replay erhalten bleiben.

---

# Versionskontext

Ticket Tamer:

- v1.0 abgeschlossen
- v1.1 abgeschlossen
- v1.2 beginnt mit Modul 021

F-01 bis F-24 / AK-01 bis AK-24 sind abgeschlossener Basisstand.

Modul 021 verändert ausschließlich Replay-/Root-/Volume-Layoutverhalten.

Nicht fachlich verändern:

- Scoring
- Ticketdaten
- Sessionauswahl
- 50-%-Drop-Regel
- Z-Toleranz
- Snapback
- Exactly-once
- Audio
- Feedback
- 1,5-s-Transition
- Ticketinfo
- HUD
- Retry
- Monster-Variantenauswahl aus Modul 025

---

# F-25 — Replay-Layoutstabilität

Das System hält beim Wechsel Ergebnis → `Erneut spielen` die aktuell verwendete Volume- und Root-Layoutgröße stabil. Startansicht, Slider, Texte, Prioritätsziele und Teamziele dürfen allein durch Replay weder schrumpfen noch wachsen oder über mehrere Durchläufe kumulativ driften.

# AK-25 — verbindliche Abnahme

1. Cold Start: Referenzgröße beziehungsweise relevante Layoutmaße von Startansicht, Slider, Prioritätszielen und Teamzielen dokumentieren.
2. Nach Ergebnis → `Erneut spielen`: Startansicht ohne replaybedingte Verkleinerung/Vergrößerung bei gleicher Volume-Größe.
3. Nach Replay: Prioritätsziele innerhalb kleiner Toleranz gleich groß wie im ersten Durchlauf.
4. Nach Replay: Teamziele innerhalb kleiner Toleranz gleich groß wie im ersten Durchlauf.
5. Fünf vollständige Replay-Zyklen ohne kumulative Größen-/Layoutdrift.
6. Bei zulässig veränderter Volume-Größe bleibt diese aktuelle Größe nach Replay erhalten; kein Rücksprung auf Cold-Start-Defaultgröße.
7. Fachlicher Reset bleibt korrekt:
   - Ticketanzahl 6
   - Score 0
   - Index 0
   - keine Entscheidungen
   - keine alten Sitzungstickets

---

# Verbindlicher Vorab-Check

Ein finaler `020-Report.md` wurde in diesem Projektlogbuch nicht eingearbeitet. v1.1 wurde vom Projektteam als abgeschlossen bestätigt.

Darum zuerst den **realen Repository-Stand** feststellen.

## 1. Git

Ermittle:

- aktuellen Branch
- HEAD
- letzten v1.1-Abschlusscommit
- Working Tree
- staged/untracked Dateien

Keine alten Hashes blind übernehmen.

## 2. Build/Test-Baseline

Ermittle:

- tatsächliche aktuelle `@Test`-Zahl
- letzten belegten vollständigen Testlauf
- Buildstatus
- Xcode-Version
- visionOS SDK
- Deployment Target

Nach Möglichkeit vor Änderung:

- Build
- vollständige Tests

Dokumentiere echte Zahlen.

## 3. Relevante Dateien vollständig lesen

Mindestens:

- `App/Ticket_TamerApp.swift`
- `Views/RootVolumeView.swift`
- `Views/StartView.swift`
- `Views/InvestigationView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Views/ResultView.swift`
- `Views/Components/ScaledToFitView.swift`
- `Services/VolumeMetrics.swift`
- `Services/MonsterDragGeometry.swift`
- `Services/TargetPanelLayout.swift`
- `Support/AppConstants.swift`
- `Models/SessionModel.swift`

Suche zusätzlich nach:

- `.defaultSize`
- Window-/Volume-Resizability
- `GeometryReader3D`
- RealityView-Geometriemessung
- Root-Frames
- `maxWidth`
- `maxHeight`
- `scaledToFit`
- `.frame(...)`
- `.id(...)`
- `.task`
- Geometry-/Layout-State
- Reset-/Replay-bezogenen Zuständen

---

# Zuerst reproduzieren — noch keinen Fix schreiben

## Cold Start messen

Dokumentiere:

### Volume
- tatsächliche Breite
- Höhe
- Tiefe

### StartView
- relevante Rootbreite/-höhe
- Sliderbreite
- gegebenenfalls Scale

### Priorisierung
- Panelbreite/-höhe
- Monstergröße
- gemessene VolumeBounds

### Team
- Panelbreite/-höhe
- gemessene VolumeBounds

## Danach Replay

Komplette Sitzung:

`Start → Untersuchung → Priorisierung → Team → Ergebnis → Erneut spielen`

Danach dieselben Werte erneut messen.

## Fünf Replay-Zyklen

Erstelle:

| Zyklus | Volume B/H/T | Start Root | Sliderbreite | Priority Panel B/H | Team Panel B/H |
|---|---|---|---|---|---|
| Cold Start | | | | | |
| Replay 1 | | | | | |
| Replay 2 | | | | | |
| Replay 3 | | | | | |
| Replay 4 | | | | | |
| Replay 5 | | | | | |

Ursache anhand realer Werte bestimmen, nicht nur visuell raten.

---

# Ursachenanalyse

Prüfe insbesondere:

## Window-/Volume-Größenpolitik

- Wird `.defaultSize` beim Replay erneut wirksam?
- Wird ein Window-/Volume-Modifier phasenabhängig neu aufgebaut?
- Ändert `.id(...)` Scene-/Root-Identität?
- Erzeugt Reset eine neue Root-Geometriebasis?

## SwiftUI Proposal / Skalierung

- Nutzt `StartView` nur `maxWidth` und wird vom jeweils neuen Proposal erneut skaliert?
- Wird `ScaledToFitView` mit bereits skalierten Werten erneut gespeist?
- Wird ein angepasster Wert als neue Basis verwendet?

## GeometryReader3D

- Wird gemessene Größe absolut oder relativ zu früheren Messwerten verwendet?
- Schreiben verspätete asynchrone Messungen alten State zurück?
- Existieren Layouttasks ohne Cancellation?

## TargetPanelLayout

- basiert Panelgröße nur auf aktueller realer Geometrie?
- fließt ein bereits skalierter Zwischenwert erneut ein?
- existiert kumulativer Faktor?

## Reset

- verändert `SessionModel.reset()` indirekt Layoutzustand?
- triggert Reset eine neue Scene-/Window-Konfiguration?

---

# Verbindliche Fix-Architektur

Die Replay-Korrektur gehört **zentral** in:

- `Ticket_TamerApp`
- `RootVolumeView`
- oder eine kleine gemeinsame Root-/Volume-Layoutkomponente

Nicht drei getrennte Sonderfixes in:

- StartView
- PrioritizationView
- TeamAssignmentView

wenn dieselbe Rootursache vorliegt.

## Stabile Rootbasis

Alle Phasen laufen auf derselben stabilen Root-/Volume-Basis.

Die Lösung soll:

- aktuelle tatsächlich gewährte Geometry verwenden
- bei gleicher Geometry dieselben Layoutmaße liefern
- keinen kumulativen Scale-Faktor speichern
- nicht relativ zur vorherigen Darstellung skalieren

## `.defaultSize`

`.defaultSize` ist Cold-Start-/Defaultvorgabe.

Nicht als Replay-Reset verwenden.

Nach Nutzer-/System-Resize bleibt beim Replay die aktuelle Größe.

## SessionModel

Kein neuer Window-/Volume-State im `SessionModel`.

Volume-Größe ist kein fachlicher Sitzungszustand.

`reset()` bleibt fachlich unverändert.

---

# StartView-Stabilität

Die SPEC verlangt ausdrücklich, dass StartView nicht ausschließlich von einer reinen `maxWidth`-Begrenzung des verfügbaren Proposals abhängt.

Prüfe die reale Umsetzung.

Ziel:

- gleiche Volume-Größe → gleiche Sliderbreite
- gleiche Titel-/Beschreibung-/Control-Größe
- keine Replay-Verkleinerung

Erlaubt:

- robuste Designbreite mit einmaliger Fit-Logik
- stabile Root-Constraints
- zentrale Layoutbasis

Nicht erlaubt:

- `if replayCount > 0`
- manuelle Rückskalierung pro Replay
- Magic Number als Gegenskalierung

---

# Prioritäts-/Teamziele

Zielgrößen dürfen weiterhin aus tatsächlichen gemessenen VolumeBounds berechnet werden.

Nicht die adaptive Geometrie durch starre Werte ersetzen.

Prüfe:

- gleiche reale Volumegröße → gleiche Panelgröße
- ReplayCount kein Layoutinput
- SessionIndex kein Layoutinput
- sichtbare Panelbox und Drop-Bounds bleiben deckungsgleich

---

# Nutzer-/System-Resize

Falls SDK/Simulator Resize unterstützt:

1. App starten.
2. Volume verändern.
3. tatsächliche B/H/T messen.
4. Sitzung durchspielen.
5. `Erneut spielen`.
6. prüfen:
   - aktuelle Größe bleibt
   - Layout basiert weiter darauf
   - kein Default-Reset

Wenn nicht zuverlässig testbar:

- Code/API strukturell prüfen
- Gerätetest als OPEN dokumentieren
- nicht als getestet ausgeben

---

# Task-/Cancellation-Prüfung

Falls Replay-Ursache in asynchronen Geometryupdates liegt:

- vorhandene Tasks identifizieren
- stale Tasks canceln
- stale Writes verhindern

Keine neue Task-Kaskade.

---

# Harte Modulgrenze

Nicht implementieren:

- F-26 `X Punkte` → Modul 022
- F-27 `0 Punkte` → Modul 022
- F-28 Team-Symbole → Modul 023
- F-29 DEV-Isolation → Modul 024
- F-30 16 Monster-Varianten → Modul 025

Nicht vorziehen.

---

# Fachlichen Reset schützen

Nach jedem Replay weiterhin:

- `selectedTicketCount = 6`
- `sessionTickets = []`
- `currentTicketIndex = 0`
- `currentPhase = .start`
- `score = 0`
- `selectedPriority = nil`
- `selectedTeam = nil`
- `isInputLocked = false`

Keine Änderung der Resetsemantik zur Lösung des Layoutfehlers.

---

# Automatisierte Tests

Erhalte alle bestehenden Tests.

Aktuelle Testzahl im Preflight real ermitteln.

Ergänze nur sinnvolle Tests, mindestens für:

1. fachlicher Reset verändert keine Root-/Volumegröße.
2. identische gemessene Volumegröße → identische Root-Layoutmaße.
3. identische Volumegröße → identische Priority-Panelmaße.
4. identische Volumegröße → identische Team-Panelmaße.
5. Replay-/Sessionzähler ist kein Layoutinput.
6. keine kumulative Skalierung bei wiederholter gleicher Geometry.
7. StartView-Designbreite bleibt für identisches Proposal identisch.
8. veränderte gültige Geometry erzeugt entsprechend neue Maße statt Default-Rücksprung.
9. Reset auf Ticketanzahl 6 bleibt.
10. fünf wiederholte Layoutberechnungen mit gleicher Geometry liefern dieselben Werte innerhalb Floating-Toleranz.

Keine Tests nur gegen Implementierungsdetails ohne fachliche Aussage.

---

# Simulatorabnahme — Pflicht

AK-25 benötigt reale Layoutmessung oder visuelle Gegenprüfung.

## Cold Start

Erfasse:

- Volume B/H/T
- StartView
- Slider
- Prioritätsziele
- Teamziele

## Fünf Replays

Jeweils:

`Ergebnis → Erneut spielen → neuer Durchlauf`

Vergleiche gegen Cold Start.

Keine kumulative Drift.

## Toleranz

Wähle eine kleine technisch begründete Toleranz und dokumentiere sie.

Nicht eine große Toleranz wählen, um einen verbleibenden Fehler als PASS zu deklarieren.

---

# v1.0/v1.1-Regression

Nach Fix mindestens prüfen:

- Startseite v1.1
- HUD
- Ticketinfo
- Interaktionshinweise
- visuelles Feedback
- Retry
- Prioritätsdrag
- Teamdrag
- Drop-Bounds
- Snapback
- Ergebnis
- Reset

Besonders:

- HUD-Ornaments nicht verschoben
- Ticketinfo vollständig sichtbar
- Ziele erreichbar
- keine Änderung an 50-%-Overlap

---

# Voraussichtlich relevante Dateien

Primär:

- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/Components/ScaledToFitView.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Nur wenn Ursache dort liegt:

- `Views/StartView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Services/VolumeMetrics.swift`
- `Services/TargetPanelLayout.swift`
- `Services/MonsterDragGeometry.swift`

Nicht vorsorglich alle ändern.

---

# DebugManager

Bestehende Kategorien verwenden:

- `.lifecycle`
- `.state`

Nur gezielte Messlogs, z. B.:

```text
COLD volume=...
REPLAY1 volume=...
phase=start rootSize=...
phase=priority panelSize=...
phase=team panelSize=...
```

Kein Renderframe-Spam.

---

# Git

Vorgesehener Commit:

`021: Replay-Layoutstabilisierung`

Vor Commit:

- Build
- vollständige Tests
- fünf Replay-Zyklen
- `git diff --check`
- Scope-Diff
- fachlichen Reset regressionsprüfen

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- v1.1-Abschlusscommit
- Working Tree
- Xcode/SDK
- tatsächliche Testzahl
- Baseline Build/Test

## 2. Reproduktion

| Zyklus | Volume | Start Root | Slider | Priority Panels | Team Panels |
|---|---|---|---|---|---|

Cold Start + Replay 1–5.

## 3. Ursachenanalyse

- konkrete Ursache
- betroffene Dateien
- warum Replay Größen verändert
- warum Fix zentral erfolgt

## 4. Fix-Architektur

- Root-/Volume-Basis
- aktuelle Geometry
- `.defaultSize`
- Nutzer-Resize
- Task/Cancellation falls relevant

## 5. Änderungen je Datei

| Datei | Art | Grund | Wirkung | F/AK |
|---|---|---|---|---|

## 6. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 7. Simulatorabnahme

- Cold Start
- Replay 1–5
- Start
- Slider
- Priorität
- Team
- Nutzer-Resize
- fachlicher Reset

## 8. Regression

- v1.0/v1.1-Kern
- HUD
- Ticketinfo
- Feedback
- Retry
- Drag/Drop

## 9. Vollständiger `021-Report.md`

Der Report muss ausdrücklich enthalten:

- tatsächlichen finalen v1.1-Gitstand
- reproduzierten Fehler vor Fix
- Messwerte vor/nach
- Root-/Volume-Ursache
- zentrale Fixentscheidung
- keine phasenspezifischen Replay-Hacks
- aktuelle Volume-Größe bleibt erhalten
- `.defaultSize` nicht als Replay-Reset
- fünf Replay-Zyklen
- StartView-/Slider-Stabilität
- Priority-/Teamziel-Stabilität
- fachlicher Reset unverändert
- Build/Teststatus
- AK-25 PASS/OPEN/FAIL
- offene Risiken
- Empfehlung für **Modul 022 — Punktekommunikation v1.2**

Baue nichts außerhalb dieses Moduls um.
