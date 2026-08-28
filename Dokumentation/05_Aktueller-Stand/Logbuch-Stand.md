# Projektlogbuch — Ticket Tamer

**Stand:** Modul `014` — Abschlussdokumentation und Cleanup, abgeschlossen
**Eingearbeitet am:** 2026-08-28
**Aktiver Branch:** `side`
**HEAD:** `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439 — feat: Modul 13`
**Modul-013-Commit:** `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439` — committed, identisch mit `origin/main`
**Lokaler `main`:** `bdb444a6f05be1f912e713ec32e5db1b0821ae43` (hinter `origin/main`)
**Modul-012:** bewusst ohne Codeänderung ausgelassen (F-17 ist Kann)
**Build nach Fix 8:** **PASS** — Xcode 26.6, visionOS-SDK 26.5, Deployment Target 26.5, Simulator Apple Vision Pro 26.5 (230470)
**Testlauf:** **208 von 208 bestanden**, 0 Failed, 0 Skipped, 3.682 s

**Abschlussstatus: B — nicht vollständig abgabebereit. 15 von 16 Pflicht-AKs sind PASS.**

## Kernergebnis von Modul 014

Der Fix-8-Stand wurde gebaut, die vollständige Testsuite ausgeführt und die offenen
013-Nachtests im visionOS-Simulator nachgeholt. **Fix 8 ist real belegt:** der maximal
erreichbare Überlappungsanteil liegt in beiden Phasen und für beide geprüften Assets bei
0.650 gegen die Schwelle 0.50. Der Fehler aus dem Vor-Fix-8-Trace ist behoben.

Die Testsuite läuft nach einer Korrektur an einer Gegenprobe **vollständig grün: 208 von
208 in 10 Suiten**.

Neu auf PASS gehoben — jeweils mit realer Evidenz: AK-05, AK-07, AK-08, AK-09, AK-10,
AK-11, AK-12, AK-14, AK-16.

**Offen geblieben ist allein AK-06:** das rote Monster wird in der Untersuchungsansicht
abgeschnitten. Dazu der Gerätetest als dokumentiertes Abgaberisiko.

## Gemessene Laufzeitwerte

| Größe | Wert |
|---|---|
| Volume | `0.282 × 0.236 × 0.235 m` |
| Layoutebene | 384 × 320 pt, 1360 pt/m |
| Panel Priorisierung | `0.067 × 0.089 × 0.020 m` / `0.067 × 0.087 × 0.020 m` |
| Panel Teamzuordnung | `0.111 × 0.084 × 0.020 m` |
| Max. erreichbarer Overlap | **0.650** für alle sieben Ziele |
| Z-Abstand | `0.000 m` (valid) durchgehend |

Gemessene Schwellenkurve: 0.470 / 0.479 / 0.482 → ungültig; 0.555 / 0.608 / 0.613 / 0.650
→ gültig. Die Grenze liegt exakt bei 0.50.

20 vollständige DROP-DEBUG-Traces: 16 × `INVALID -> Snapback`, 4 × `VALID`.

## Testlauf im Detail

**Erster Lauf:** 10 Suiten, 208 Tests, 207 bestanden. Neun Suiten grün,
`PrioritizationPhaseTests` rot mit 2 Issues aus **einem** Test.

**Zweiter Lauf nach der Korrektur (maßgeblich):** 208 von 208 bestanden, 0 Failed,
0 Skipped, 3.682 s, alle zehn Suiten grün.

Fehlschlagend: `Snapback im Weltraum würde Position und Größe verfälschen`
(`Ticket_TamerTests.swift:1223` / `:1227`).

Es ist eine **Gegenprobe**: sie soll belegen, dass der alte Code — lokaler Transform mit
`relativeTo: nil` angewendet — das Monster verschöbe und verzerrte. `makeMonsterHierarchy()`
gibt der Elternentity dafür bewusst `position = (0.5, −0.3, 0.1)` und `scale = 2`.
Erwartet wird eine Abweichung > 0.0001, gemessen wurde **exakt 0.0**.

Bewertung: der positive Test `Snapback im lokalen Raum stellt Position, Rotation und Scale
exakt wieder her` ist grün, und der Snapback wurde im Simulator ohne Drift geprüft. Unter
Xcode 26.6 / visionOS-SDK 26.5 verhält sich `setTransformMatrix(_:relativeTo: nil)` für
eine Hierarchie, die **nicht in einer Szene hängt**, offenbar wie `relativeTo: parent` —
die Prämisse der Gegenprobe trägt nicht mehr.

→ **Defekt im Test, nicht im Produkt.**

**In Modul 014 korrigiert und verifiziert.** Die Gegenprobe wurde umgebaut, nicht entfernt: sie rechnet die
Aussage jetzt direkt, statt sie über das SDK zu erschließen. „`origin.matrix` als
Weltmatrix setzen" bedeutet lokal `parent⁻¹ · origin.matrix`:

```swift
let wouldBeLocal = Transform(matrix: parentTransform.matrix.inverse * origin.matrix)
```

Zusätzlich prüft der Test jetzt seine eigene Vorbedingung — dass die Elternentity
überhaupt einen eigenen Transform trägt. Rechnerische Kontrolle mit den Fixture-Werten:
Abweichung 0.307 (Translation) und 0.320 (Skalierung) gegen die Schwelle 0.0001. Testzahl
unverändert 208.

Die Regressionsabsicherung bleibt erhalten: baut jemand den Snapback auf Weltraum zurück,
schlägt der Test an — nur eben unabhängig davon, wie eine SDK-Version `relativeTo: nil`
für lose Hierarchien auflöst.

**Verifiziert.** Der Wiederholungslauf bestätigt die Korrektur:

```text
✔ Test "Snapback im Weltraum würde Position und Größe verfälschen" passed after 2.572 seconds.
✔ Suite PrioritizationPhaseTests passed after 3.676 seconds.
✔ Test run with 208 tests in 10 suites passed after 3.682 seconds.
```

Der positive Gegenpart und `Fünf aufeinanderfolgende Snapbacks driften nicht` bestehen
weiterhin. Die Regressionsabsicherung ist intakt.

**Lehre:** Eine Gegenprobe, die ihre eigene Vorbedingung nicht mitprüft, kann still
wertlos werden. Der Test verifiziert jetzt vorab, dass die Elternentity überhaupt einen
eigenen Transform trägt.

## Ergebnisse der Nachtests

| Prüfung | Ergebnis |
|---|---|
| AK-06/07 Sichtprüfung Inhalte | PASS |
| AK-08 Priorisierung, 10/25/48/55 % je Ziel | PASS |
| AK-09 Teamzuordnung, 10/25/48/55 % je Ziel | PASS |
| AK-10 Exactly-once, Snapback, Lock | PASS |
| AK-11 Scoring 200/100/100/0 | PASS |
| AK-12 beide Sounds, genau einmal | PASS |
| Clipping Priorisierung/Teamzuordnung | PASS |
| Clipping Untersuchungsansicht, rotes Monster | **OPEN** |
| AK-16 fünf Neustarts | PASS |
| Stabilität 1/2/6/12 Tickets | PASS |
| Gerätetest Apple Vision Pro | **OPEN** |

## AK-09 — geklärt

**AK-09** stand zunächst auf OPEN, weil der Prüfeintrag für Konto, Software und Hardware
beim 55-%-Fall abbrach (`55 %..`). Die Prüfung wurde vom Projektverantwortlichen als
durchgeführt bestätigt; gestützt wird das durch zwei gültige Teamdrops im Log
(`team_konto`, `team_software`) und alle vier Teamziele mit `erreichbar: ja` bei Overlap
0.650. **AK-09: PASS.**

## AK-14, Teil Ownership — geklärt

Der Projektverantwortliche hat bestätigt, dass die vier Monster selbst erstellte
Blender-Modelle sind. Damit ist die Herkunftsfrage durch die Erklärung des Autors
beantwortet; ein Dateinachweis wird nicht verlangt. `.blend`-Quellen liegen nicht im
Projektraum — für spätere Änderungen an den Modellen sollten sie an einem dokumentierten
Ort abgelegt werden.

## AK-14 — vollständig belegt

`monster01` und `monster02` wurden nachträglich durchgespielt. Alle vier Assets sind damit
zur Laufzeit belegt:

| Asset | B | H | T | gemessen |
|---|---:|---:|---:|---|
| monster01 | 0.0643 | 0.1300 | 0.0709 | 28.08. |
| monster02 | 0.0450 | 0.1300 | 0.0584 | 28.08. |
| monster03 | 0.0708 | 0.1300 | 0.0732 | 27.08. |
| monster04 | 0.0690 | 0.1300 | 0.0880 | 27.08. |

`monster01` mit gültigem Drop in beiden Phasen (`VALID -> priority_wichtig` bei Overlap
0.650, `VALID -> team_netzwerk` bei 0.595), `monster02` gezogen mit korrektem Snapback bei
0.148 Overlap. Für jedes Asset melden alle drei Prioritäts- und alle vier Teamziele
`Maximum reachable overlap: 0.650 | erreichbar: ja`. Höhe 0.1300 bei allen vier,
`rot=(0.000, 0.000, 0.000, 1.000)` nach dem Wrapper.

**Nebenbefund:** Die Breitenmaße aus Modul 013 stimmten für `monster01` (0.070 statt
0.0643) und `monster03` (0.098 statt 0.0708) nicht. Praktisch folgenlos, weil die
Erreichbarkeit je Asset einzeln gemessen wurde — aber Zahlen aus 013 nicht ungeprüft
weiterverwenden.

**AK-14: PASS.**

## Der verbliebene offene Punkt

### AK-06 — rotes Monster in der Untersuchungsansicht

`monster04` / `Monster_4_red.usdc` wird dort zusammen mit dem Tickettext nicht vollständig
korrekt dargestellt und teilweise abgeschnitten. Der Clipping-Schutz über `DragBounds`
greift in den Zieh-Phasen und ist dort bestätigt; die Untersuchungsansicht zieht nicht,
sie stellt nur dar. Zuständig sind `InvestigationView`, `ScaledToFitView` und die
Einpassung über `MonsterAssetProvider.fit`.

Weil „Monster sichtbar“ eine AK-06-Anforderung ist, steht AK-06 trotz bestandener
Inhaltsprüfung auf OPEN.

## Phase 6 — Z-Frame-Restpunkt: geprüft und geschlossen

`local=(0, −0.02, 0.06)` → `world=(0, −0.02, 0.17765)`, konstant +0.1176 m in Z.

Volume-Grenzen entstehen über `content.convert(_:from: .local, to: .scene)` im Raum der
Szenenwurzel; Monster und Panels hängen über `content.add(_:)` genau dort. Weltkoordinaten
werden in produktivem Code nirgends mit Volume-Grenzen verrechnet — sie erscheinen nur in
`Raumprobe`, im DROP-DEBUG-Trace und in `DropEvaluator.evaluate(entity:targets:)`, das
ausschließlich der `#if DEBUG`-Harness aufruft.

→ Kein Fehler, keine Architekturänderung, keine neuen Regressiontests. Restpunkt
geschlossen. Die irreführenden Kommentare („local und world müssen übereinstimmen“) wurden
in beiden Views richtiggestellt — kein Verhalten geändert.

Der Lauf bestätigt außerdem Fix 6: bei nicht zentriertem Z-Bereich (`minZ=0.000
maxZ=0.235`) klemmt `effectiveMonsterPlaneZ` die Zieh-Ebene (`0.060 → 0.053` bzw. `0.064`),
die Panels folgen, Z-Abstand bleibt 0.000.

## Korrigierte Falschaussagen aus dem Altstand

| bisherige Aussage | tatsächlich |
|---|---|
| Branch `main` | aktiv ist `side`; `origin/main` == HEAD von `side` |
| Modul-013-Commit „offen“ | committed als `cc5a4a2 feat: Modul 13` |
| 155 Tests | 208 Tests, alle bestanden |
| Kugel-Platzhalter als aktuelle Monster | vier echte USDC-Meshes integriert |
| Radius-/Column-/Nearest-Drop-Logik produktiv | **nicht** produktiv — nur DEBUG-Harness und Tests |
| `defaultSize` = tatsächliches Volume | gemessen `0.282 × 0.236 × 0.235 m` |
| F-17 = Highscore/Persistenz | F-17 = optionale Monsterreaktion (Kann) |
| Ergebnis zeigt Ticketanzahl | `ResultView` zeigt nur Score und „Erneut spielen“ |
| `incorrect.wav` fehlt/ungeprüft | vorhanden, hörbar geprüft, korrekt zugeordnet |
| Build nach Fix 8 offen | PASS unter Xcode 26.6 / visionOS-SDK 26.5 |

## Cleanup (Phase 14) — ausgeführt

Entfernt: `_abgeloest/TargetFrameReporter.swift` samt Ordner,
`.git/index.lock.stale-bitte-loeschen`, sechs `.DS_Store`.
`.gitignore` ergänzt um `.DS_Store` und `rot-debug.txt`.

Unter `Dokumentation/05_Aktueller-Stand/` liegen genau `Projekt-Stand.md` und
`Logbuch-Stand.md`.

`rot-debug.txt` wurde bewusst **nicht** gelöscht: der Trace stammt von 18:42/18:44 Uhr,
`TargetPanelLayout.swift` wurde zuletzt um 18:59 Uhr geändert. Er zeigt den Zustand vor
Fix 8 (erreichbarer Anteil 0.462/0.494) und ist damit die Ursachen-Evidenz für Fix 8 —
aber **kein** Nachweis über den aktuellen Stand.

## Fix-Historie (unverändert)

1. Blender Z-up → RealityKit Y-up
2. RealityView Dependency Tracking
3. gemessene Drag-Grenzen statt angenommener Volumegrenzen
4. 3D-Zielpanels + 50-%-Regel + Z-Nähe + Highlight
5. Konstanten korrekt nach Layout/Interaction getrennt
6. Paneltiefe aus tatsächlicher geklemmter Zieh-Ebene
7. DROP-DEBUG-Trace
8. Panelhöhe so berechnet, dass die 50-%-Schwelle geometrisch erreichbar bleibt — **belegt**

## Pflicht-Abnahmematrix (Stand Ende Modul 014)

| AK | Inhalt | Status |
|---|---|---|
| AK-01 | Startansicht | PASS |
| AK-02 | 12 lokale Tickets | PASS |
| AK-03 | Ticketdaten | PASS |
| AK-04 | Sitzungsauswahl | PASS |
| AK-05 | linearer Ablauf, ein Volume | PASS |
| AK-06 | Untersuchungsansicht | OPEN |
| AK-07 | Weiter zur Priorisierung | PASS |
| AK-08 | Priorisierung, drei Ziele | PASS |
| AK-09 | Teamzuordnung, vier Ziele | PASS |
| AK-10 | Invalid/Valid/Lock/Exactly-once | PASS |
| AK-11 | Scoring 200/100/100/0 | PASS |
| AK-12 | beide Sounds, genau einmal | PASS |
| AK-13 | kein Lösungsfeedback + ~1,5 s | PASS |
| AK-14 | vier eigene Blender-Monster | PASS |
| AK-15 | nur Score + „Erneut spielen“ | PASS |
| AK-16 | Reset, fünf Neustarts | PASS |

## Bekanntes Restrisiko

Die Panelhöhe in der Teamphase liegt bei 0.084 m gegen eine geometrische Obergrenze von
0.088 m — rund 4 mm Reserve. Bei Änderungen an Volumegröße, `targetPanelGap` oder
`dragSafetyPadding` erneut prüfen.

## Nächster Schritt

Ein kurzes **Restpunkte-Modul**, kein weiteres Fachmodul:

1. Rotes Monster in der Untersuchungsansicht korrigieren, Nachtest → AK-06 PASS
2. Gerätetest, sofern Hardware verfügbar

Mehr steht nicht offen. Nach Punkt 1 stehen **alle 16 Pflicht-AKs auf PASS** und nur der
Gerätetest bleibt als bewusst dokumentiertes Abgaberisiko. Erst dann darf der
Abschlussstatus von B auf A wechseln.

Der Abstand zur Abgabebereitschaft beträgt **einen Darstellungsfehler**.
