# Projekt-Stand — Ticket Tamer

**Stand:** nach Restpunkte-Bearbeitung AK-06 — Fix implementiert, Nachtest ausstehend
**Eingearbeitet am:** 2026-08-28
**Aktiver Branch:** `side`
**HEAD / `origin/main` / `main`:** `e8b289a` — feat: Modul 14
**Lokaler `main`:** auf `origin/main` angeglichen (Fast-Forward, keine History-Umschreibung)
**`origin/side`:** `745d45e` — 8 Commits hinter `side`
**Modul-014-Commit:** erledigt (`235262b`, `21456e7`, `e8b289a`)
**Build:** PASS (Stand Modul 014; nach dem AK-06-Fix noch nicht erneut gebaut)
**Tests:** 208/208 PASS (Stand Modul 014); 9 Tests ergaenzt, **erwartet 217**, Lauf ausstehend
**Abschlussstatus:** **B — nicht vollstaendig abgabebereit**

## Korrektur des dokumentierten Git-Stands

Der bis Modul 014 dokumentierte Git-Stand war falsch. Real ermittelt:

| Angabe | Dokumentiert | Tatsaechlich |
|---|---|---|
| HEAD | `cc5a4a2` — Modul 13 | `e8b289a` — Modul 14 |
| Modul-014-Commit | offen | bereits committed |
| Working Tree | Aenderungen offen | sauber |
| lokaler `main` | hinter `origin/main` | jetzt angeglichen |

## Technischer Funktionsstand

Bestaetigt funktionsfaehig:

- genau ein zentrales visionOS-Volume
- Startansicht
- 12 lokale Tickets
- Sitzungsauswahl
- Untersuchungsphase fachlich vollstaendig
- Priorisierung
- Teamzuordnung
- gemessene Drag-Grenzen
- 3D-Zielpanels
- 50-%-Drop-Regel
- Snapback
- Exactly-once
- Scoring
- beide Sounds
- 1,5-s-Transitions
- vier echte Monster
- Ergebnisansicht
- Reset
- 1/2/6/12-Ticket-Stabilitaet

Offen:

- AK-06: Fix implementiert, **Nachtest im Simulator ausstehend**
- Apple Vision Pro Geraetetest (hardwareabhaengiges Restrisiko)

## Teststand

| Kennzahl | Wert |
|---|---:|
| Tests (letzter belegter Lauf) | 208 |
| Suites | 10 |
| Passed | 208 |
| Failed | 0 |
| Skipped | 0 |
| Plattform | arm64-apple-xros1.0-simulator |
| Laufzeit | 3.682 s |
| Neu ergaenzt | 9 |
| Erwartet nach dem Fix | 217 / 11 Suites — **noch nicht gelaufen** |

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

**Pflichtstatus: 15/16 PASS.**

## AK-06

Inhalt und Navigation sind korrekt.

Fehler: `monster04` / `Monster_4_red.usdc` wird in der Untersuchungsansicht zusammen mit dem
Ticketinhalt teilweise abgeschnitten.

### Ursache (isoliert, messbar)

`InvestigationView` berechnete seinen verfuegbaren Quader aus zwei Annahmen, waehrend die
Drag-Phasen ihn seit Modul 013 messen:

- `layoutPointsPerMeter = 417` — gegen eine Volume-Hoehe von 0.8 m kalibriert, heute 1.0 m
- `monsterPanelDepth = 0.34 m` — das angeforderte, nicht das gewaehrte Tiefenmass

Das im Simulator gemessene Volume betraegt **0.284 x 0.236 x 0.235 m** statt der deklarierten
1.0 x 1.0 x 0.4 m (belegt durch die Regressionstests aus Modul 013). Daraus folgt:

- die angenommene Panel-Tiefe ist groesser als die gemessene Volume-Tiefe ueberhaupt
- das Zielmass fiel damit stets auf den Deckel `monsterTargetSize = 0.24 m`
- 0.24 m liegt ueber jeder Kante des gemessenen Volumes — Beschneiden war unvermeidbar

Da `fit(_:toMaxExtent:)` die **groesste** Modellausdehnung auf die Grenze abbildet und diese
Achse je Export verschieden ist, schlug zuerst nur ein Asset sichtbar an. Kein Assetfehler.

Zweite Fehlerquelle: die Position war hart `(0, 0, forward)` — das trifft die Panelmitte nur,
wenn der Szenenursprung im Panelzentrum liegt. Das Panel ist die linke Spalte eines `HStack`.

### Fix

`Services/InvestigationFraming.swift` (neu) misst den realen Panelquader und passt das
Monster modellbewusst ein; `InvestigationView` nutzt `GeometryReader3D` +
`content.convert(_:from: .local, to: .scene)`. Die bisherige Schaetzung bleibt als
Rueckfallebene fuer den ersten Layoutdurchlauf.

Nicht betroffen und unveraendert:

- Priorisierung
- Teamzuordnung
- DragBounds
- 3D-Zielpanels
- DropEvaluator
- Scoring
- Audio
- Reset

## Interaktionsarchitektur

Produktiv:

```text
VolumeMetrics
  ↓
MonsterDragGeometry
  ├─ DragBounds
  ├─ TargetPanelLayout
  └─ DropEvaluator
```

Getrennt davon, ohne geteilte Konstante:

```text
InvestigationFraming   (nur Untersuchungsansicht)
```

Drop gueltig bei:

- mindestens 50 % Monsterflaechenueberlappung
- Z-Abstand <= 0.05 m

`defaultSize` ist keine reale Geometriegrundlage. `layoutPointsPerMeter` und
`monsterPanelDepth` ebenfalls nicht — sie dienen nur noch als Rueckfallebene.

## Monster

Build-Assets:

- Monster_1_blue.usdc
- Monster_2_green.usdc
- Monster_3_yellow.usdc
- Monster_4_red.usdc

Alle vier im Simulator belegt.

## Audio

- correct.wav PASS
- incorrect.wav PASS
- genau einmal PASS

## Ergebnis

`ResultView` zeigt ausschliesslich:

- Scorezahl
- `Erneut spielen`

## Cleanup

Entfernt:

- `_abgeloest/`
- stale Git-Lock-Dateien (erneut eine verwaiste `.git/index.lock` in dieser Sitzung)
- `.DS_Store`

`.gitignore` enthaelt `.DS_Store` und `rot-debug.txt`.

## Git

- Abgabebranch: `main` = `origin/main` = `e8b289a`
- Arbeitsbranch `side` zeigt auf denselben Commit und traegt die Fix-Aenderungen
- lokaler `main` per Fast-Forward angeglichen
- offen: `origin/side` nachziehen, falls `side` erhalten bleiben soll
- offen: Fix nach erfolgreichem Nachtest nach `main` uebernehmen und pushen

## Naechster Schritt

1. Xcode-Build und vollstaendige Testsuite ausfuehren, reale Zahlen eintragen
2. Untersuchungsansicht mit allen vier Assets im Simulator pruefen, `spawning`-Log mitschneiden
3. Regression Start → Untersuchung → Priorisierung → Team → Ergebnis → Reset
4. Bei PASS: AK-Matrix auf 16/16, Abschlussstatus A, Fix nach `main`
5. Optional: Apple-Vision-Pro-Geraetetest

Details: `Dokumentation/04_Modul-Reports/Restpunkte-Report.md`
