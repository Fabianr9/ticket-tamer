# Modul-Eingangsprompt — 026 Integration und Abnahme v1.2

> Vom **Projektlogbuch** nach Einarbeitung des `025-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Modul 026 ist das finale Integrations- und Abnahmemodul für Ticket Tamer v1.2.

---

Du bist Integrations-, QA- und Abschlussverantwortliche:r für Ticket Tamer v1.2.

# Modul

**Nummer:** 026  
**Titel:** Integration und Abnahme v1.2  
**Erfüllt:** AK-25 bis AK-30 als gemeinsamer v1.2-Integrationstest

**Ziel:** Baue, teste und prüfe den vollständigen aktuellen v1.2-Stand auf macOS/Xcode/visionOS. Nimm AK-25 bis AK-30 real im Zusammenspiel ab und bestätige gleichzeitig, dass der abgeschlossene v1.0-/v1.1-Kern nicht regressiert ist. Modul 026 führt keine neuen Features ein.

---

# Ausgangsstand

## v1.0
abgeschlossen

## v1.1
abgeschlossen

## v1.2 implementiert

### Modul 021 — F-25
Replay-Layoutstabilisierung

### Modul 022 — F-26/F-27
- Ergebnis `X Punkte`
- falsches Feedback `0 Punkte`

### Modul 023 — F-28
Teamstation-Symbole

### Modul 024 — F-29
DEV-Shortcut aus normalem Flow entfernt

### Modul 025 — F-30
16 Monster-Farbvarianten und sitzungsstabile Auswahl

---

# Dokumentierter Git-/Teststand

Laut 025-Report:

- Branch: `A`
- HEAD vor 025: `fd8bf28 feat: Modul 24`
- Modul-024-Commit: `fd8bf28`
- Modul-025-Commit: offen
- Tests vor 025: 333
- neue Tests: 32
- Quellstand nach 025: **365 Testdeklarationen**
- Build/Test/Simulator: offen

---

# Abschlussregel

Ticket Tamer v1.2 darf nur als vollständig abgenommen markiert werden, wenn:

1. aktueller Stand erfolgreich baut,
2. vollständige Testsuite erfolgreich läuft,
3. AK-25 bis AK-30 real geprüft wurden,
4. keine kritische Regression aus v1.0/v1.1 besteht,
5. Git-/Working-Tree-Stand sauber dokumentiert ist.

Statuswerte:

- **PASS** = real nachgewiesen
- **OPEN** = nicht geprüft/nicht belegbar
- **FAIL** = real fehlgeschlagen

Nichts aus statischer Implementierung automatisch auf PASS setzen, wenn ein AK explizite Simulator-/Geräteabnahme verlangt.

---

# Phase 1 — Git und Modul-025-Abschluss

Ermittle real:

- Branch
- HEAD
- Working Tree
- staged/untracked
- tatsächlichen Modul-025-Commit

Wenn 025 noch uncommitted ist:

1. Build durchführen.
2. vollständige Suite durchführen.
3. alle 16 Assetvarianten prüfen.
4. Session-/Retry-/Reset-Konsistenz prüfen.
5. Modul 025 separat committen.

Vorgesehener Commit:

`025: Monster-Farbvarianten`

Keine Hashes erfinden.

---

# Phase 2 — Finaler Build

Führe den vollständigen v1.2-Build aus.

Dokumentiere:

- Xcode-Version
- visionOS SDK
- Deployment Target
- Build Configuration
- Buildziel
- Simulator/Gerät
- PASS/FAIL
- relevante Warnungen

Projektziel weiterhin:

- Apple Vision Pro
- visionOS Deployment Target 26.5

Keine neuen Third-Party-Abhängigkeiten.

---

# Phase 3 — Vollständige Testsuite

Dokumentierter Quellstand:

**365 Testdeklarationen**

Führe die gesamte Suite aus.

Dokumentiere:

- tatsächliche Testzahl
- Suites
- Passed
- Failed
- Skipped
- Laufzeit
- Plattform

Bei abweichender Testzahl:

- Ursache prüfen
- reale Zahl dokumentieren
- nichts künstlich an 365 anpassen

---

# Phase 4 — AK-25 Replay-Layoutstabilität

AK-25 ist seit Modul 021 bewusst noch OPEN.

Diese Abnahme ist verpflichtend.

## Cold-Start-Referenz

Erfasse:

- tatsächliche Volume B/H/T
- Start Root
- Sliderbreite
- Priority-Panel B/H/T
- Team-Panel B/H/T

## Fünf vollständige Replays

Durchläufe:

- Cold Start
- Replay 1
- Replay 2
- Replay 3
- Replay 4
- Replay 5

Tabelle:

| Zyklus | Volume B/H/T | Start Root | Slider | Priority Panels | Team Panels |
|---|---|---|---|---|---|

Prüfe:

- keine sichtbare Größenänderung
- keine kumulative Drift
- gleiche Volume-Größe → gleiche Layoutmaße innerhalb kleiner dokumentierter Toleranz

## Nutzer-/System-Resize

Wenn möglich:

1. Volume zulässig verändern.
2. B/H/T dokumentieren.
3. Sitzung vollständig durchspielen.
4. `Erneut spielen`.
5. bestätigen:
   - aktuelle veränderte Größe bleibt
   - kein Reset auf `0.8 × 0.75 × 0.38 m`
   - Layout berechnet sich aus aktueller Größe

## Fachlicher Reset

Nach jedem Replay:

- Ticketwert 6
- Score 0
- Index 0
- Entscheidungen nil
- Sessiontickets verworfen
- Input frei

---

# Phase 5 — AK-26 Ergebnis `X Punkte`

Prüfe real mindestens:

- `0 Punkte`
- `100 Punkte`
- `600 Punkte`

Optional Maximalwert passend zur Sitzung.

Immer:

- `Erneut spielen`
- keine Maximalpunktzahl
- keine Prozentzahl
- keine Statistik
- kein Rang
- keine Badges

Accessibility prüfen.

---

# Phase 6 — AK-27 `0 Punkte` bei falscher Entscheidung

Vier Fälle:

## Priorität richtig
- grüner Haken
- `+100 Punkte`
- correct-Sound

## Priorität falsch
- rotes Kreuz
- `0 Punkte`
- incorrect-Sound
- Score +0

## Team richtig
- grüner Haken
- `+100 Punkte`
- correct-Sound

## Team falsch
- rotes Kreuz
- `0 Punkte`
- incorrect-Sound
- Score +0

Immer:

- keine richtige Lösung
- keine Begründung
- Input-Lock bleibt
- Exactly-once bleibt
- ca. 1,5 s
- genau ein Sound
- genau eine Bewertung
- genau ein Transition

Schnelle Mehrfacheingabe prüfen.

---

# Phase 7 — AK-28 Teamstation-Symbole

Finale Symbolzuordnung:

| Team | Symbol |
|---|---|
| Netzwerk | `network` |
| Konto | `person.crop.circle` |
| Software | `macwindow` |
| Hardware | `desktopcomputer` |

Prüfe:

- alle vier Symbole sichtbar
- alle vier deutschen Texte vollständig sichtbar
- keine Überlappung
- keine abgeschnittenen Labels
- frontal
- leicht links
- leicht rechts
- leicht oben

Semantik:

- ohne Farbe unterscheidbar

## Geometrieschutz

Referenzwerte aus Modul 023:

- Panelbreite `0.195 m`
- Panelhöhe `0.117 m`
- Paneltiefe `0.020 m`
- minimum overlap `0.50`
- depth tolerance `0.05 m`

bei der dokumentierten Referenzgeometrie.

Prüfe real:

- Symbolergänzung verändert sichtbare Panelbox nicht
- Drop-Bounds identisch
- Drag auf alle vier Ziele
- ungültiger Drop → Snapback
- 50-%-Drop weiterhin korrekt

---

# Phase 8 — AK-29 Debug-UI-Isolation

## Normaler Debug-Build

Kompletter produktiver Flow:

```text
Start
→ Untersuchung
→ Priorisierung
→ Team
→ Ergebnis
```

Nirgends sichtbar:

`🔧 Team [DEV]`

Besonders:

- Priorisierung vor Drop
- Feedbackfenster
- Übergang zur Teamphase

## Release

Build/Run beziehungsweise strukturell und buildseitig prüfen:

- keine DEV-Schaltfläche
- kein produktiver Debugshortcut

## Debug-Harness

`DebugInteractionHarnessView`

darf im expliziten DEBUG-/Development-Kontext bestehen.

Prüfe:

- RootVolumeView routet nicht dorthin
- normaler App-Start öffnet ihn nicht
- Entwicklerfunktion bleibt separat, falls vorgesehen

## Projektweite Suche

Nach Abschluss erneut suchen:

- `🔧 Team [DEV]`
- `Team [DEV]`

Jede verbleibende Fundstelle klassifizieren.

Produktivquellcode: kein Treffer erlaubt.

---

# Phase 9 — AK-30 Alle 16 Monster-Farbvarianten

## Verbindlicher Assetkatalog

### monster01
1. `Monster_1_blue.usdc`
2. `Monster_1_green.usdc`
3. `Monster_1_pink.usdc`
4. `Monster_1_red.usdc`

### monster02
5. `Monster_2_blue.usdc`
6. `Monster_2_green.usdc`
7. `Monster_2_pink.usdc`
8. `Monster_2_red.usdc`

### monster03
9. `Monster_3_blue.usdc`
10. `Monster_3_green.usdc`
11. `Monster_3_pink.usdc`
12. `Monster_3_yellow.usdc`

### monster04
13. `Monster_4_blue.usdc`
14. `Monster_4_green.usdc`
15. `Monster_4_pink.usdc`
16. `Monster_4_red.usdc`

## Jede Variante einzeln erzwingen

Für jede Datei:

| Asset | geladen | sichtbar | Fit | Kollision | Drag | Snapback | Drop |
|---|---|---|---|---|---|---|---|

Alle 16 müssen geprüft werden.

## Dreiphasen-Konsistenz

Mindestens ein Ticket, besser mehrere:

1. konkrete Variantendatei in Untersuchung dokumentieren
2. Priorisierung → exakt gleiche Datei
3. Team → exakt gleiche Datei
4. Ladefehler provozieren
5. `Erneut laden` → exakt gleiche Datei

Keine Neuauswahl während laufender Sitzung.

## Neue Sitzung

Nach:

`Erneut spielen → Spiel starten`

dürfen neue Varianten gewählt werden.

Wichtig:

Zufällig gleiche Variante ist erlaubt.

Nicht verlangen, dass jede neue Sitzung zwingend andere Farben zeigt.

## Reset

Nach Reset:

- altes Variantenmapping leer
- keine alte Ticket→Variante-Zuordnung übernommen

## Neutralität

Prüfe strukturell/Testdaten:

- keine Farbe fest an Team gebunden
- keine Farbe fest an Priorität gebunden
- keine Richtigkeitscodierung

---

# Phase 10 — Assetbundle / Release-Ressourcen

Prüfe:

`Packages/RealityKitContent/Sources/RealityKitContent/MonsterAssets`

und `Package.swift`.

Bestätige:

- alle 16 enthalten
- `.copy("MonsterAssets")` beziehungsweise reale Resource-Regel wirksam
- Release-Build findet dieselben Ressourcen
- keine benötigte Variante nur im Arbeitsordner außerhalb Buildressourcen

Keine doppelten oder verwaisten produktiven Assetpfade.

---

# Phase 11 — v1.0/v1.1 Regression

Mindestens vollständig prüfen:

## Start
- Titel
- Beschreibung
- Minus/Slider/Plus
- Default 6
- Start

## Sitzungsauswahl
- 1, 2, 6, 12 Tickets
- keine Ticketduplikate

## Untersuchung
- Ticketkarte
- Monster
- HUD
- keine Lösung
- Retry

## Priorisierung
- HUD
- Hint
- Ticketinfo
- Drag
- gültiger/ungültiger Drop
- Snapback
- visuelles Feedback
- Sound

## Team
- HUD
- Hint
- Ticketinfo
- Text + Symbol
- Drag auf alle Teams
- Feedback
- Sound

## Exactly-once
- schneller Mehrfach-Pinch
- kein doppelter Score/Sound/Transition

## Scoring
- richtig +100
- falsch +0
- Maximalwert korrekt

## Ergebnis
- `X Punkte`
- `Erneut spielen`
- keine Zusatzstatistik

## Reset
mindestens 5-mal:
- Ticketwert 6
- Score 0
- Index 0
- Entscheidungen nil
- Tickets verworfen
- Variantenmapping verworfen
- kein UI-State-Carryover

---

# Phase 12 — Langzeit-/Stabilitätstest

Mindestens folgende Sitzungen:

- 1 Ticket
- 2 Tickets
- 6 Tickets
- 12 Tickets

Zusätzlich:

- fünf Replay-Zyklen
- mehrere Ticketinfo-Öffnungen
- richtige/falsche Entscheidungen
- ungültige Drops
- mehrere Retries
- verschiedene Monsterfarben

Keine:

- Crashes
- Deadlocks
- doppelte Panels
- doppelte Monster
- hängende Overlays
- hängendes Feedback
- Score-Carryover
- Layoutdrift

---

# Phase 13 — Accessibility / Lesbarkeit

Prüfe:

- Session-HUD
- Interaktionshinweise
- Ticketinfo
- Teamtexte
- Teamsymbole
- `+100 Punkte`
- `0 Punkte`
- Resultat `X Punkte`
- Retry
- Start Minus/Plus

Keine Accessibility-Ausgabe darf:

- Referenzpriorität
- Referenzteam
- Lösung

verraten.

---

# Phase 14 — Gerätetest

Wenn Apple Vision Pro verfügbar:

- Blickfokus
- Pinch
- Drag
- Volume-Resize
- Replay
- Teamsymbole
- alle 16 Assets soweit praktikabel
- Audio
- Ticketinfo
- Feedback
- Retry

Wenn kein Gerät verfügbar:

- Simulatorstatus separat dokumentieren
- Gerätetest als OPEN kennzeichnen
- niemals simulierten Test als Gerätetest ausgeben

---

# Phase 15 — Integrationsfixes

Falls reale Fehler gefunden werden:

Erlaubt sind ausschließlich kleine Fixes, die AK-25 bis AK-30 oder Regressionen reparieren.

Für jeden Fix dokumentieren:

| Datei | Fehler | Ursache | Fix | Regressionstest |
|---|---|---|---|---|

Keine neuen Features.

---

# Phase 16 — Git-/Cleanup

Prüfe:

- Branch
- HEAD
- Modul-025-Commit
- ggf. Modul-026-Fixcommit
- Working Tree
- staged/untracked
- keine `.DS_Store`
- keine stale Git-Locks
- keine Backupkopien
- keine veralteten parallelen Standdokumente

Aktuelle Projektdokumentation sauber halten.

---

# Finale v1.2-AK-Matrix

Erstelle:

| AK | Code | Tests | Simulator | Gerät | Status | Nachweis |
|---|---|---|---|---|---|---|
| AK-25 | | | | | PASS/OPEN/FAIL | |
| AK-26 | | | | | PASS/OPEN/FAIL | |
| AK-27 | | | | | PASS/OPEN/FAIL | |
| AK-28 | | | | | PASS/OPEN/FAIL | |
| AK-29 | | | | | PASS/OPEN/FAIL | |
| AK-30 | | | | | PASS/OPEN/FAIL | |

PASS nur bei tatsächlichem Nachweis.

---

# Regression-Matrix v1.0/v1.1

AK-01 bis AK-24 mindestens mit Status:

- PASS
- OPEN
- FAIL

Alle müssen im Abschlussreport einen Status erhalten.

Bei unverändertem, durch vollständige Tests und gezielte Regression belegtem Bereich darf der Nachweis kompakt sein.

---

# Harte Modulgrenze

Modul 026 ist Integration/Abnahme.

Nicht ergänzen:

- neue Features
- Monsteranimationen
- neue Spielmodi
- Nutzer-Farbauswahl
- Statistiken
- Highscore
- Tutorial
- weiteres Debugmenü
- Immersive Space
- zweites Volume

---

# Git

Nach erfolgreicher Integration:

`026: Integration und Abnahme v1.2`

Falls Modul 025 vorher committed wird, beide echten Hashes dokumentieren.

Keine Hashes erfinden.

---

# Abschlussstatus

Am Ende genau eine der beiden Aussagen:

## A — Ticket Tamer v1.2 abgenommen

Nur wenn:

- Build PASS
- vollständige Tests PASS
- AK-25 bis AK-30 PASS
- keine kritische v1.0/v1.1-Regression

oder

## B — Ticket Tamer v1.2 nicht vollständig abgenommen

Dann:

- alle OPEN/FAIL-Punkte
- Priorität
- konkreter nächster Schritt

Ein fehlender Gerätetest darf separat als dokumentiertes Restrisiko geführt werden, wenn Simulator und alle übrigen Pflichtnachweise ausreichend sind; niemals einen Gerätetest erfinden.

---

# Ausgabeformat

1. Vorab-Check
2. Git-/Build-/Teststand
3. AK-25 Replay-Abnahme
4. AK-26 Ergebnis-Abnahme
5. AK-27 Feedback-Abnahme
6. AK-28 Teamstations-Abnahme
7. AK-29 Debug-Isolation-Abnahme
8. AK-30 16-Asset-Abnahme
9. v1.0/v1.1-Regressionsprüfung AK-01 bis AK-24
10. Stabilitäts-/Replaytests
11. Accessibility/Gerätetest
12. Integrationsfixes
13. finale v1.2-AK-Matrix
14. finale Regression-Matrix
15. finaler Git-/Working-Tree-Stand
16. Abschlussstatus A oder B
17. vollständiger `026-Report.md`

Der `026-Report.md` ist die finale technische Übergabe für Ticket Tamer v1.2.
