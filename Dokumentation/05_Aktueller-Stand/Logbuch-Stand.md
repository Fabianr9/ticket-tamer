# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung der Restpunkte-Bearbeitung.

**Stand:** Restpunkte — AK-06-Fix implementiert, Nachtest ausstehend, **Abschlussstatus B**  
**Eingearbeitet am:** 2026-08-28  
**Aktiver Branch:** `side`  
**HEAD (`side`):** `b56179b` — Restpunkte: AK-06 Clippingfix (Nachtest ausstehend)  
**`origin/main` / `main`:** `e8b289a — feat: Modul 14`  
**`origin/side`:** `745d45e` — 8 Commits hinter `side`  
**Lokaler main:** auf `origin/main` angeglichen (Fast-Forward)  
**Modul-014-Commit:** erledigt  
**Letzter belegter Build:** PASS (Modul 014)  
**Letzter belegter Testlauf:** **208/208 bestanden**, 10 Suites, 0 Failed, 0 Skipped  
**Nach dem Fix erwartet:** 217 Tests / 11 Suites — **noch nicht gelaufen**  
**Pflicht-AKs:** **15 PASS / 1 OPEN**  
**Offenes Pflicht-AK:** AK-06

## Restpunkte-Bearbeitung (2026-08-28)

### Git-Korrektur

Der bis Modul 014 dokumentierte Git-Stand war **falsch**. Real: Modul 014 ist bereits
committed, HEAD steht auf `e8b289a`, der Working Tree war sauber. Der lokale `main`
(`bdb444a`) lag 10 Commits zurueck und wurde per Fast-Forward auf `origin/main`
angeglichen — keine History-Umschreibung. Erneut eine verwaiste `.git/index.lock`
entfernt.

**Abgabebranch: `main`.**

### AK-06 — Ursache isoliert

Nicht assetbedingt, sondern eine Annahme gegen eine vorhandene Messung:
`InvestigationView` berechnete den verfuegbaren Quader aus `layoutPointsPerMeter` (417,
gegen 0.8 m Volume-Hoehe kalibriert; heute 1.0 m) und `monsterPanelDepth` (0.34 m, das
angeforderte statt des gewaehrten Masses). Das gemessene Volume betraegt jedoch
**0.284 x 0.236 x 0.235 m** — die angenommene Panel-Tiefe ist groesser als die gemessene
Volume-Tiefe ueberhaupt. Das Zielmass fiel damit stets auf den Deckel 0.24 m, der ueber
jeder Kante des realen Volumes liegt. Beschneiden war unvermeidbar.

Sichtbar wurde es zuerst bei `monster04`, weil `fit(_:toMaxExtent:)` die **groesste**
Modellausdehnung auf die Grenze abbildet und diese Achse je Export verschieden ist.

Zweite Fehlerquelle an derselben Stelle: die Position war hart `(0, 0, forward)` und traf
die Mitte der linken `HStack`-Spalte nicht.

### AK-06 — Fix

Neu: `Services/InvestigationFraming.swift` — misst den realen Panelquader
(`GeometryReader3D` + `content.convert(_:from: .local, to: .scene)`) und passt das Monster
modellbewusst ein: groesster gemeinsamer Faktor ueber alle drei Achsen, positioniert auf
die gemessene Panelmitte. Die bisherige Schaetzung bleibt Rueckfallebene. Keine neue
Magic Number, keine Aenderung an Drag-/Drop-Geometrie, Scoring, Audio oder Flow.

Ergaenzt: 9 Tests in der Suite „Restpunkt AK-06 — Einpassung im gemessenen Monster-Panel".

### Nicht erledigt

Build, Testsuite, Simulatornachweis und Regression **wurden nicht ausgefuehrt** — Xcode und
visionOS-Simulator standen in dieser Sitzung nicht zur Verfuegung. AK-06 bleibt deshalb
OPEN. Kein Ergebnis wurde erfunden.

Details: `Dokumentation/04_Modul-Reports/Restpunkte-Report.md`

## Abschlussstatus

### B — Nicht vollständig abgabebereit

Es bleibt genau ein offener Pflichtpunkt:

**AK-06 — Untersuchungsansicht:**  
Der fachliche Inhalt der Ansicht ist vollständig und korrekt. Der Clippingfehler bei
`monster04` / `Monster_4_red.usdc` ist am Code behoben, der Nachtest im Simulator steht
jedoch aus. Ohne Build-, Test- und Simulatornachweis bleibt AK-06 OPEN.

Zusätzlich ist der Apple-Vision-Pro-Gerätetest nicht durchgeführt. Er wird als hardwareabhängiges Abgaberisiko dokumentiert und nicht als PASS erfunden.

## Modul 014 — bestätigte Ergebnisse

### Build

- Xcode 26.6
- visionOS SDK 26.5
- Deployment Target visionOS 26.5
- Simulator Apple Vision Pro, visionOS 26.5
- **Build Succeeded**

### Tests

Maßgeblicher zweiter Lauf:

- 208 Tests
- 10 Suites
- 208 Passed
- 0 Failed
- 0 Skipped
- 3.682 s
- `arm64-apple-xros1.0-simulator`

Der erste Lauf hatte einen fehlerhaften Gegenprobe-Test. Dieser Test wurde korrigiert, ohne Produktcode oder Testanzahl zu verändern. Der zweite vollständige Lauf ist grün.

### Interaktionsnachweis

Fix 8 ist real belegt:

- Mindestüberlappung: 0.50
- maximal erreichbarer Overlap: 0.650
- beide Phasen
- alle vier Monsterassets

Priorität:

- Normal PASS
- Wichtig PASS
- Kritisch PASS
- 10/25/48 % ungültig
- 55 % gültig
- Highlight und Dropentscheidung konsistent

Team:

- Netzwerk PASS
- Konto PASS
- Software PASS
- Hardware PASS
- 10/25/48 % ungültig
- 55 % gültig

AK-08, AK-09 und AK-10 sind damit PASS.

### Snapback / Exactly-once

Bestätigt:

- ungültiger Drop → Snapback
- keine Positionsdrift
- keine Scale-Änderung
- keine Rotationsänderung
- zweites Loslassen ignoriert
- Mehrfach-Pinch erzeugt keine Mehrfachauslösung
- Audio und Transition je genau einmal
- keine Doppelwertung

### Scoring

End-to-End bestätigt:

| Fall | Punkte |
|---|---:|
| Priorität richtig + Team richtig | 200 |
| nur Priorität richtig | 100 |
| nur Team richtig | 100 |
| beide falsch | 0 |

AK-11 = PASS.

### Audio

Bestätigt:

- `correct.wav` hörbar
- `incorrect.wav` hörbar
- korrekt zugeordnet
- genau ein Sound je gültiger Entscheidung
- keine Lösung sichtbar

AK-12 = PASS.

### Monster

Integriert:

- `monster01` → `Monster_1_blue.usdc`
- `monster02` → `Monster_2_green.usdc`
- `monster03` → `Monster_3_yellow.usdc`
- `monster04` → `Monster_4_red.usdc`

Projektverantwortlicher hat bestätigt, dass es selbst erstellte Blender-Modelle sind.

Alle vier Assets sind zur Laufzeit belegt, lokal sichtbar, korrekt eingepasst, Y-up-korrigiert und interaktiv verwendbar.

AK-14 = PASS.

Hinweis: `.blend`-Quelldateien liegen nicht im Projektraum. Für spätere Bearbeitung sollten sie an dokumentierter Stelle archiviert werden.

### Reset / Stabilität

Bestätigt:

- mindestens fünf Neustarts
- Regler nach Reset wieder 6
- Score 0
- Index 0
- Sitzung leer
- Priorität nil
- Team nil
- Input-Lock false
- keine alten Tasks
- kein Carryover

Zusätzlich Sitzungen mit 1, 2, 6 und 12 Tickets stabil.

AK-05 und AK-16 = PASS.

## Finale AK-Matrix

| AK | Status |
|---|---|
| AK-01 | PASS |
| AK-02 | PASS |
| AK-03 | PASS |
| AK-04 | PASS |
| AK-05 | PASS |
| AK-06 | **OPEN — Fix implementiert, Nachtest ausstehend** |
| AK-07 | PASS |
| AK-08 | PASS |
| AK-09 | PASS |
| AK-10 | PASS |
| AK-11 | PASS |
| AK-12 | PASS |
| AK-13 | PASS |
| AK-14 | PASS |
| AK-15 | PASS |
| AK-16 | PASS |

## AK-06 Detail

Bestanden:

- Monster grundsätzlich sichtbar
- Ticketnummer
- Titel
- Kurzbeschreibung
- Auswirkung
- Symptome
- keine Referenzpriorität
- kein Referenzteam
- Weiter-Button
- gleiches Ticket bleibt aktiv

Offen:

- `monster04` wird in der Untersuchungsansicht teilweise abgeschnitten

Der Defekt betrifft nicht Priorisierung oder Teamzuordnung. Dort ist der Clipping-Schutz bestätigt.

Wahrscheinlich relevante Dateien:

- `InvestigationView.swift`
- `ScaledToFitView.swift`
- `MonsterAssetProvider.fit(...)`

## Cleanup aus Modul 014

Entfernt:

- `_abgeloest/TargetFrameReporter.swift`
- Ordner `_abgeloest/`
- `.git/index.lock.stale-bitte-loeschen`
- verwaiste `.git/index.lock`
- sechs `.DS_Store`

`.gitignore` ergänzt um:

- `.DS_Store`
- `rot-debug.txt`

Unter `Dokumentation/05_Aktueller-Stand/` existieren genau:

- `Projekt-Stand.md`
- `Logbuch-Stand.md`

## DEBUG-/Release-Stand

Bleiben bewusst erhalten:

- `DebugInteractionHarnessView` vollständig `#if DEBUG`
- `🔧 Team [DEV]` nur `#if DEBUG`
- DROP-DEBUG-Trace
- DebugManager

Keine Release-Funktion hängt von DEBUG-only Code ab.

## Git-Risiko vor Abgabe

Aktiver Branch ist `side`.

`origin/main` zeigt auf denselben Commit wie `side`, aber der lokale `main` ist älter.

Vor Abgabe zwingend klären:

- welcher Branch ist der Abgabestand,
- lokalen `main` bei Bedarf sauber an `origin/main` angleichen,
- Modul-014-Änderungen committen,
- finalen Working Tree prüfen.

## Restpunkt vor finalem Status A

1. ~~roten Monster-Clippingfehler in der Untersuchungsansicht beheben~~ — **erledigt am Code**
2. AK-06 nachtesten — **offen** (Xcode-Build, Testsuite, alle vier Assets im Simulator)
3. Regression Start → Untersuchung → Priorisierung → Team → Ergebnis → Reset — **offen**
4. AK-Matrix, Projekt-Stand und Logbuch nach dem Nachtest final setzen
5. Fix nach `main` übernehmen und pushen; `origin/side` nachziehen
6. optional Vision-Pro-Gerätetest, falls Hardware verfügbar

Nach erfolgreichem Punkt 2–3 kann der Pflichtstatus auf **16/16 PASS** und der
Abschlussstatus auf **A** wechseln.
