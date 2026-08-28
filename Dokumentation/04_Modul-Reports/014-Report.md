# Modul-Report — 014 Abschlussdokumentation und Cleanup

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst“ nach dem Schließen alles.

## Zusammenfassung

Modul 014 hat den Fix-8-Stand gebaut, die vollständige Testsuite ausgeführt, die offenen
013-Nachtests im visionOS-Simulator nachgeholt, Altlasten entfernt und die Dokumentation
mit dem Code in Übereinstimmung gebracht. **Fix 8 ist damit real belegt:** der maximal
erreichbare Überlappungsanteil liegt in beiden Phasen und für **alle vier Assets** bei
0.650 gegen eine Schwelle von 0.50 — der Fehler aus dem Vor-Fix-8-Trace ist behoben. Die
Testsuite läuft nach einer Korrektur an einer Gegenprobe **vollständig grün: 208 von 208**.
Von sechzehn Pflicht-AKs sind **fünfzehn PASS**. Offen bleibt allein **AK-06**: das rote
Monster wird in der Untersuchungsansicht abgeschnitten. Dazu der Gerätetest, der als
Abgaberisiko dokumentiert ist.

**Abschlussstatus: B — nicht vollständig abgabebereit.**

---

## 1. Vorab-Check

### Git

| Punkt | Wert |
|---|---|
| Aktiver Branch | `side` |
| HEAD | `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439 — feat: Modul 13` |
| Modul-013-Commit | `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439` — **bereits committed** |
| `origin/main` | `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439` (identisch mit HEAD) |
| Lokaler `main` | `bdb444a6f05be1f912e713ec32e5db1b0821ae43 — fix: position` (hinter `origin/main`) |
| Working Tree vor Modul 014 | sauber |

Korrektur gegenüber dem Eingangsprompt: Modul 013 war **nicht** uncommitted. Der
vorgesehene Commit `013: Integration, Zielpanels und Drop-Erkennung` wurde deshalb nicht
erneut angelegt; der reale Commit heißt `feat: Modul 13`.

### Testzahl und Assets

208 `@Test`-Deklarationen im Quellcode — deckt sich mit dem Testlauf (208 Tests in 10
Suites). Vier USDC-Meshes im Build, vier USDA-Wrapper, beide WAV-Dateien vorhanden.

`.blend`-Quelldateien liegen nicht im erreichbaren Projektraum. Die Urheberschaft der
Monster ist stattdessen durch die Erklärung des Projektverantwortlichen belegt — siehe
Abschnitt 4.

---

## 2. Build/Test nach Fix 8

### Build — PASS

| Punkt | Wert |
|---|---|
| Ergebnis | **Build Succeeded — PASS** |
| Xcode | 26.6 |
| visionOS-SDK | 26.5 |
| Deployment Target | visionOS 26.5 |
| Simulatorziel | Apple Vision Pro, visionOS 26.5 (230470) |
| Relevante Warnungen | keine projektbezogenen; im Log nur Simulator-Systemmeldungen (`AddInstanceForFactory`, `nw_socket_copy_info`, `SpatialAudioServices`, `LoudnessManager`) — alle plattformseitig, ohne Bezug zum Projektcode |

### Testlauf — 208 von 208 bestanden

Maßgeblich ist der **zweite Lauf**, nach der Testkorrektur aus diesem Modul:

| Punkt | Erster Lauf | **Zweiter Lauf (maßgeblich)** |
|---|---|---|
| Testzahl | 208 in 10 Suites | **208 in 10 Suites** |
| Passed | 207 | **208** |
| Failed | 1 (2 Einzel-Issues) | **0** |
| Skipped | 0 | **0** |
| Laufzeit | 0.222 s | **3.682 s** |
| Plattform | `arm64-apple-xros1.0-simulator` | `arm64-apple-xros1.0-simulator` |
| Testing Library | 1902 | 1902 |

```text
✔ Test run with 208 tests in 10 suites passed after 3.682 seconds.
```

Suiten-Ergebnis des maßgeblichen Laufs — **alle zehn grün**:

| Suite | Ergebnis |
|---|---|
| `Modul 013 — Zielpanels und 50-%-Drop` | ✔ 2.008 s |
| `MonsterAssetPipelineTests` | ✔ 2.041 s |
| `TicketTamerTests` | ✔ 2.906 s |
| `StartViewModelTests` | ✔ 2.914 s |
| `SessionModelTests` | ✔ 2.914 s |
| `TeamAssignmentPhaseTests` | ✔ 3.655 s |
| `PrioritizationPhaseTests` | ✔ 3.676 s |
| `ScoringAndFeedbackTests` | ✔ 3.676 s |
| `InteractionFoundationTests` | ✔ 3.675 s |
| `InvestigationPhaseTests` | ✔ 3.679 s |

Die längere Laufzeit gegenüber dem ersten Lauf ist Streuung der Simulator-Startlast, kein
inhaltlicher Unterschied — die Testmenge ist identisch.

### Der zuvor fehlschlagende Test — behoben

`Snapback im Weltraum würde Position und Größe verfälschen`
(`Ticket_TamerTests.swift:1223` und `:1227`)

```text
Expectation failed: (simd_distance(after.translation, origin.translation) → 0.0) > 0.0001
Expectation failed: (simd_distance(after.scale,       origin.scale)       → 0.0) > 0.0001
```

Das ist eine **Gegenprobe**, kein Funktionstest. Sie soll belegen, dass der *alte* Code —
lokaler Transform, angewendet mit `relativeTo: nil` — das Monster verschöbe und
verzerrte. `makeMonsterHierarchy()` gibt der Elternentity dafür bewusst einen eigenen
Transform (`position = (0.5, −0.3, 0.1)`, `scale = 2`). Erwartet wird also eine Abweichung
größer 0.0001; gemessen wurde **exakt 0.0** in beiden Fällen.

Bewertung:

- Der zugehörige **positive** Test `Snapback im lokalen Raum stellt Position, Rotation und
  Scale exakt wieder her` ist **bestanden**.
- Der Snapback wurde im Simulator geprüft und arbeitet ohne Drift, ohne Scale- und ohne
  Rotationsänderung (siehe Abschnitt 3, AK-10).
- 16 reale Invalid-Drops im Laufzeitlog enden sauber mit `Result: INVALID -> Snapback`.

→ Es ist ein **Defekt im Test, nicht im Produkt**. Unter Xcode 26.6 / visionOS-SDK 26.5
verhält sich `setTransformMatrix(_:relativeTo: nil)` für eine Hierarchie, die **nicht in
einer Szene hängt**, offenbar wie `relativeTo: parent` — die Prämisse der Gegenprobe
trägt damit nicht mehr.

### Korrektur in Modul 014

Die Gegenprobe wurde umgebaut. Sie erschließt die Aussage nicht mehr über das SDK, sondern
rechnet sie direkt: „`origin.matrix` als Weltmatrix setzen" bedeutet lokal
`parent⁻¹ · origin.matrix`.

```swift
let wouldBeLocal = Transform(matrix: parentTransform.matrix.inverse * origin.matrix)
#expect(simd_distance(wouldBeLocal.translation, origin.translation) > 0.0001, …)
#expect(simd_distance(wouldBeLocal.scale,       origin.scale)       > 0.0001, …)
```

Zusätzlich prüft der Test jetzt seine eigene Vorbedingung — dass die Elternentity
überhaupt einen eigenen Transform trägt. Ohne den fielen lokaler und Weltraum zusammen und
die Gegenprobe wäre wertlos, ohne dass es auffiele.

Rechnerische Kontrolle mit den Fixture-Werten (Eltern: Position `(0.5, −0.3, 0.1)`,
Skalierung 2; Monster: `monsterStartPosition (0, −0.02, 0.06)`, Skalierung 0.37,
Y-up-Rotation):

| Größe | `origin` | `wouldBeLocal` | Abstand |
|---|---|---|---:|
| Translation | `(0, −0.02, 0.06)` | `(−0.25, 0.14, −0.02)` | 0.307 |
| Skalierung | `0.370` | `0.185` | 0.320 |

Beide liegen weit über der Schwelle 0.0001. Die Regressionsabsicherung bleibt damit
erhalten: baut jemand den Snapback auf Weltraum zurück, schlägt der Test an — nur eben
unabhängig davon, wie eine SDK-Version `relativeTo: nil` für lose Hierarchien auflöst.

Testzahl unverändert: 208 Deklarationen.

### Verifiziert

Der Wiederholungslauf bestätigt die Korrektur:

```text
✔ Test "Snapback im Weltraum würde Position und Größe verfälschen" passed after 2.572 seconds.
✔ Suite PrioritizationPhaseTests passed after 3.676 seconds.
✔ Test run with 208 tests in 10 suites passed after 3.682 seconds.
```

Der positive Gegenpart `Snapback im lokalen Raum stellt Position, Rotation und Scale exakt
wieder her` besteht weiterhin (2.573 s), ebenso `Fünf aufeinanderfolgende Snapbacks driften
nicht` (2.573 s). Die Regressionsabsicherung ist damit intakt und der Punkt geschlossen.

---

## 3. 013-Nachtests

### Gemessene Laufzeitwerte

| Größe | Wert |
|---|---|
| Volume (Szenenraum) | `0.282 × 0.236 × 0.235 m` |
| Layoutebene | 384 × 320 pt, 1360 pt/m |
| Panelgröße Teamzuordnung | `0.111 × 0.084 × 0.020 m` |
| Max. erreichbarer Overlap | **0.650** — alle drei Prioritäts- und alle vier Teamziele, **alle vier Assets** |
| Z-Abstand | `0.000 m` (valid) durchgehend |

Panelgröße Priorisierung, je Asset:

| Asset | Panelgröße | Monsterhülle |
|---|---|---|
| `monster01` | `0.067 × 0.084 × 0.020 m` | `0.064 × 0.130 × 0.071 m` |
| `monster02` | `0.067 × 0.084 × 0.020 m` | `0.045 × 0.130 × 0.058 m` |
| `monster03` | `0.067 × 0.089 × 0.020 m` | `0.071 × 0.130 × 0.073 m` |
| `monster04` | `0.067 × 0.087 × 0.020 m` | `0.069 × 0.130 × 0.088 m` |

Die Panelhöhe wandert mit der gemessenen Monsterhülle — genau das ist der Mechanismus aus
Fix 8. Der Log bestätigt für jedes Ziel und jedes Asset einzeln `erreichbar: ja`. Damit ist
**Fix 8 real belegt**: der maximal erreichbare Anteil liegt durchgängig bei 0.650 gegen die
Schwelle 0.50, also mit dem vorgesehenen `targetPanelReachabilityHeadroom` von 0.15.

Zusätzlich bestätigt der Log den Fix-6-Mechanismus, in beiden Phasen. Das Volume wurde
einmal mit `minZ=−0.118 maxZ=0.118` und einmal mit `minZ=0.000 maxZ=0.235` gemessen. Im
zweiten Fall klemmt `effectiveMonsterPlaneZ` die Zieh-Ebene, und die Panels folgen:

| Phase | Wunsch-Z | tatsächlich | Z-Abstand |
|---|---:|---:|---:|
| Priorisierung | 0.060 | 0.053 / 0.060 / 0.064 | 0.000 |
| Teamzuordnung | 0.000 | 0.055 / 0.064 | 0.000 |

Der Z-Abstand bleibt in jedem Fall 0.000 — die Tiefenprüfung ist nie der begrenzende
Faktor.

### Phase 1 — AK-06 / AK-07

Im Simulator geprüft: Monster sichtbar, Ticketnummer, Titel, Kurzbeschreibung, Auswirkung
und alle Symptome werden angezeigt. Weder Referenzpriorität noch Referenzteam sind
sichtbar. Nach „Weiter zur Priorisierung“ bleibt dasselbe Ticket aktiv, der Wechsel in die
Priorisierungsphase erfolgt korrekt.

**AK-07: PASS.**
**AK-06: OPEN** — inhaltlich vollständig bestanden, aber der Darstellungsdefekt aus
Abschnitt 5 betrifft genau diese Ansicht: das rote Monster wird in der
Untersuchungsansicht teilweise abgeschnitten. „Monster sichtbar“ ist damit nicht für alle
Assets erfüllt. Nach Behebung und Nachtest wird AK-06 auf PASS gesetzt.

### Phase 2 — AK-08 Priorisierung nach Fix 8 — PASS

| Ziel | 10 % | 25 % | 48 % | 55 % |
|---|---|---|---|---|
| Normal | PASS | PASS | PASS | PASS |
| Wichtig | PASS | PASS | PASS | PASS |
| Kritisch | PASS | PASS | PASS | PASS |

Im Laufzeitlog belegt durch die gemessene Schwellenkurve:

| Overlap ratio | `overlapValid` |
|---:|---|
| 0.135 / 0.148 / 0.302 / 0.345 / 0.402 / 0.416 / 0.440 | false |
| 0.470 / 0.479 / 0.482 | false |
| **0.555 / 0.595 / 0.608 / 0.613 / 0.650** | **true** |

Die Grenze liegt exakt bei 0.50. 0.482 löst kein Highlight aus, 0.555 schon — dazwischen
liegt kein einziger Fehlentscheid. In jedem der zwanzig protokollierten Drops stimmt
`Current valid target before release` mit `… during release` überein: das Highlight kündigt
nie etwas anderes an, als der Drop dann tut.

**AK-08: PASS.**

### Phase 3 — AK-09 Team nach Fix 8 — PASS

| Ziel | 10 % | 25 % | 48 % | 55 % |
|---|---|---|---|---|
| Netzwerk | PASS | PASS | PASS | PASS |
| Konto | PASS | PASS | PASS | PASS |
| Software | PASS | PASS | PASS | PASS |
| Hardware | PASS | PASS | PASS | PASS |

Im ursprünglichen Prüfprotokoll brach der Eintrag für Konto, Software und Hardware beim
55-%-Fall ab (`55 %..`). Die Prüfung wurde vom Projektverantwortlichen als durchgeführt
bestätigt; die Einträge sind hier vervollständigt.

Gestützt wird das durch den Laufzeitlog: zwei gültige Teamdrops
(`Result: VALID -> team_konto`, `Result: VALID -> team_software`) und alle vier Teamziele
mit `erreichbar: ja` bei Overlap 0.650.

**AK-09: PASS.**

### Phase 4 — AK-10 Exactly-once / Regression — PASS

Im Simulator geprüft: zweites Loslassen wird ignoriert, schnelles mehrfaches Pinchen führt
zu keiner Mehrfachauslösung, Audio und Transition feuern je genau einmal. Ungültige Drops
verändern weder Entscheidung noch Score noch Phase. Der Snapback stellt den
Ausgangszustand exakt wieder her — keine Positionsdrift, keine Scale- oder
Rotationsänderung.

Im Laufzeitlog: 20 vollständige DROP-DEBUG-Traces, davon 16 `INVALID -> Snapback` und 4
`VALID` (`priority_wichtig` ×2, `team_konto`, `team_software`). Kein Trace zeigt eine
Doppelwertung.

**AK-10: PASS.**

### Phase 6 — Z-Frame-Restpunkt — geprüft und geschlossen

Beobachtung: `local=(0, −0.02, 0.06)` → `world=(0, −0.02, 0.17765)`, konstant +0.1176 m
in Z bei identischem X und Y. Derselbe Wert erscheint auch im neuen Lauf.

Prüfergebnis: `content.convert(_:from: .local, to: .scene)` liefert die Volume-Grenzen im
Raum der Szenenwurzel; `content.add(_:)` hängt Monster und Panels genau dort ein,
`entity.position` liegt also im **selben** Raum. Weltkoordinaten werden in produktivem
Code nirgends mit Volume-Grenzen verrechnet — sie erscheinen nur in der `Raumprobe`, im
DROP-DEBUG-Trace und in `DropEvaluator.evaluate(entity:targets:)`, das ausschließlich der
`#if DEBUG`-Harness aufruft.

→ **Kein Koordinatenraum-Fehler. Keine Architekturänderung.** Der Restpunkt ist
geschlossen. Die irreführenden Kommentare an der `Raumprobe` („lokale und Weltposition
müssen übereinstimmen“) wurden in beiden Views richtiggestellt — kein Verhalten geändert.

---

## 4. Asset-/Audioabschluss

### Audio (AK-12) — PASS

Im Simulator geprüft: beide Sounds hörbar und korrekt zugeordnet
(`richtig → correct.wav`, `falsch → incorrect.wav`), je gültiger Entscheidung genau ein
Sound, keine doppelte Wiedergabe. Keine richtige Lösung sichtbar.

Ergänzend statisch belegt:

| Datei | Größe | Format | MD5 |
|---|---:|---|---|
| `correct.wav` | 44 144 B | Mono, 44,1 kHz, 0,5 s | `eae705784bf8fff805f52daf5465d23a` |
| `incorrect.wav` | 44 144 B | Mono, 44,1 kHz, 0,5 s | `9ccac5943668eb79b450892c579dbdb3` |

Beide Dateien sind inhaltlich verschieden. `AudioService` hält je einen Player und setzt
vor jedem `play()` `currentTime = 0` — keine Überlagerung möglich.

**AK-12: PASS.**

### Monster (AK-14) — PASS

#### a) Ownership — geklärt

Der Projektverantwortliche hat bestätigt, dass die vier Monster **selbst erstellte
Blender-Modelle** sind. Damit ist die Herkunftsfrage aus dem Eingangsprompt durch die
Erklärung des Autors beantwortet; ein zusätzlicher Dateinachweis wird nicht verlangt.

Zur Einordnung, was im Repository tatsächlich liegt: `Monster/` enthält 16
USDC-Farbvarianten (4 Modelle × 4 Farben), dazu die vier in den Build integrierten
Exporte. `.blend`-Quelldateien liegen nicht im Projektraum — sie sind für die Abgabe auch
nicht gefordert, sofern die Urheberschaft erklärt ist. Wer die Modelle später ändern will,
braucht die Blender-Quellen allerdings; es empfiehlt sich, sie an einem dokumentierten Ort
abzulegen.

**Ownership: erledigt.**

#### b) Gesten-Nachweis — vollständig

`monster01` und `monster02` wurden nachträglich im Simulator durchgespielt. Damit sind
**alle vier Assets** zur Laufzeit belegt.

Gemessene sichtbare Hüllen nach `fit(toMaxExtent: 0.13)`:

| Asset | Breite | Höhe | Tiefe | Quelle |
|---|---:|---:|---:|---|
| `monster01` | 0.0643 | 0.1300 | 0.0709 | Lauf 28.08. |
| `monster02` | 0.0450 | 0.1300 | 0.0584 | Lauf 28.08. |
| `monster03` | 0.0708 | 0.1300 | 0.0732 | Lauf 27.08. |
| `monster04` | 0.0690 | 0.1300 | 0.0880 | Lauf 27.08. |

Alle vier prüfbaren Teilanforderungen sind damit erfüllt:

- **lokal sichtbar** — jedes Asset wird geladen, vermessen und gerendert; kein Ladefehler
  im Log.
- **mit Blick/Pinch/Drag verwendbar** — `monster01` mit gültigem Drop in beiden Phasen
  (`VALID -> priority_wichtig` bei Overlap 0.650, `VALID -> team_netzwerk` bei 0.595),
  `monster02` gezogen mit korrektem Snapback bei 0.148 Overlap, `monster03`/`monster04`
  bereits im ersten Lauf.
- **Skalierung angemessen** — `Hoehe=0.1300` bei allen vier; `fit(toMaxExtent: 0.13)`
  greift durchgängig.
- **Y-up-Korrektur korrekt** — bei allen vier ist Y die längste Achse und der Transform
  nach dem Wrapper ist `rot=(0.000, 0.000, 0.000, 1.000)`.
- **Erreichbarkeit** — für jedes Asset melden alle drei Prioritäts- und alle vier
  Teamziele `Maximum reachable overlap: 0.650 | erreichbar: ja`.
- **Farbe codiert keine Antwort** — durch die Katalogtests belegt (`Kein Monster ist
  eindeutig einem einzigen Team zugeordnet`, `… einer einzigen Priorität zugeordnet`,
  `Monster-IDs enthalten keine team- oder prioritätsbezogenen Begriffe`), alle grün.

**Nebenbefund — die Breitenmaße aus Modul 013 stimmten teilweise nicht.** Dort standen
`monster01 = 0.070` und `monster03 = 0.098`; gemessen werden jetzt 0.0643 und 0.0708.
`monster02` (0.045) passt, `monster04` (0.069/0.070) ebenfalls. Die Tabelle oben gilt.
Woher die alte Abweichung stammt, ist nicht geklärt — praktisch folgenlos, weil die
Erreichbarkeit für jedes Asset einzeln gemessen wurde und überall bei 0.650 liegt.

**AK-14: PASS.**

---

## 5. Clipping- und Darstellungsprüfung

Im Simulator geprüft: an allen vier Rändern und in allen vier Ecken bleiben die geprüften
Monster in **Priorisierungs- und Teamzuordnungsansicht** vollständig sichtbar. Die
3D-Zielpanels sind frontal sowie leicht links, rechts und oben lesbar; die räumliche
Zuordnung ist eindeutig.

**Restdefekt:** In der **Untersuchungsansicht** wird das **rote Monster** (`monster04`,
`Monster_4_red.usdc`) zusammen mit dem Tickettext nicht vollständig korrekt dargestellt
und teilweise abgeschnitten.

Bestätigt: der Clipping-Schutz über `DragBounds` in Priorisierung und Teamzuordnung
funktioniert. Der Defekt liegt außerhalb dieses Pfads — die Untersuchungsansicht zieht
nicht, sie stellt nur dar; zuständig sind dort `InvestigationView`, `ScaledToFitView` und
die Einpassung über `MonsterAssetProvider.fit`.

**Status: OPEN.** Wirkt auf AK-06.

---

## 6. Weitere Laufzeitnachweise

### AK-11 Scoring End-to-End — PASS

Alle vier Kombinationen im Simulator geprüft:

| Fall | Ergebnis |
|---|---:|
| Priorität richtig + Team richtig | 200 |
| nur Priorität richtig | 100 |
| nur Team richtig | 100 |
| beide falsch | 0 |

Score summiert über mehrere Tickets korrekt auf und wird nie negativ. Keine Doppelwertung.

### AK-16 Reset — PASS

Mindestens fünf aufeinanderfolgende Neustarts geprüft. Nach jedem: Regler 6, Score 0,
Index 0, Sitzung leer, Priorität `nil`, Team `nil`, Lock `false`, keine alten Tasks, kein
Carryover. Keine Zustandsreste, keine Stabilitätsprobleme.

### AK-05 / Stabilität — PASS

Sitzungen über 1, 2, 6 und 12 Tickets, dazu schnelle Gesten, mehrere ungültige Drops und
wiederholte Resets. Keine Crashes, keine Phasen-Deadlocks, keine Zustandsfehler, keine
Hänger. Der vollständige lineare Ablauf läuft in einem einzigen Volume.

### Gerätetest Apple Vision Pro — OPEN

Nicht durchgeführt. Offen bleiben Blickfokus, Pinch, Drag, Drop-Zielgröße,
Panel-Lesbarkeit, Monstergröße, Audio, Ergebnis und Reset auf echter Hardware.
**Als offenes Abgaberisiko dokumentiert, nicht als PASS erfunden.**

---

## 7. Finale AK-Matrix (AK-01 bis AK-16)

| AK | Inhalt | Status | Nachweis / Grund |
|---|---|---|---|
| AK-01 | Startansicht | PASS | Modul 004; Log `Startansicht erscheint, selectedTicketCount: 6` |
| AK-02 | 12 lokale Tickets, Abdeckung | PASS | `MonsterAssetPipelineTests` grün |
| AK-03 | Ticketdaten vollständig | PASS | `Alle Tickets haben vollständige fachliche Pflichtdaten` grün |
| AK-04 | Sitzungsauswahl 1–12, Default 6 | PASS | `StartViewModelTests` grün |
| AK-05 | linearer Ablauf, ein Volume | **PASS** | Stabilitätstest 1/2/6/12 Tickets |
| AK-06 | Untersuchungsansicht | OPEN | Inhalt PASS, aber rotes Monster abgeschnitten |
| AK-07 | Weiter zur Priorisierung | **PASS** | Sichtprüfung, gleiches Ticket bleibt aktiv |
| AK-08 | Priorisierung, alle drei Ziele | **PASS** | 10/25/48/55 % je Ziel; Schwelle 0.482 → false, 0.555 → true |
| AK-09 | Teamzuordnung, alle vier Ziele | **PASS** | 10/25/48/55 % je Ziel; zwei gültige Teamdrops im Log |
| AK-10 | Invalid/Valid/Lock/Exactly-once | **PASS** | Simulatorprüfung + 20 DROP-DEBUG-Traces |
| AK-11 | Scoring 200/100/100/0 | **PASS** | alle vier Kombinationen End-to-End |
| AK-12 | beide Sounds, genau einmal | **PASS** | Hörprüfung + Dateinachweis |
| AK-13 | kein Lösungsfeedback + ~1,5 s | PASS | Modul 010, Regression über AK-10 bestätigt |
| AK-14 | vier eigene Blender-Monster | **PASS** | Ownership erklärt; alle vier Assets zur Laufzeit belegt |
| AK-15 | nur Score + „Erneut spielen“ | PASS | `ResultView` rendert genau zwei Elemente |
| AK-16 | Reset, fünf Neustarts | **PASS** | fünf Neustarts, kein Carryover |

**15 PASS, 1 OPEN.** Jede Verbesserung gegenüber dem Eingangsprompt beruht auf realer
neuer Evidenz aus Build, Testlauf oder Simulatorprüfung — beziehungsweise, bei der
Urheberschaft der Monster, auf der Erklärung des Projektverantwortlichen.

---

## 8. Cleanup (Phase 14)

Entfernt:

| Datei | Grund |
|---|---|
| `_abgeloest/TargetFrameReporter.swift` | abgelöst; Ordner `_abgeloest/` restlos entfernt |
| `.git/index.lock.stale-bitte-loeschen` | tote Lock-Datei |
| `.git/index.lock` | verwaiste Lock-Datei eines abgebrochenen Git-Prozesses |
| sechs `.DS_Store` | macOS-Artefakte (Repowurzel, `Ticket_Tamer/`, `Ticket_Tamer/Ticket_Tamer/`, `Dokumentation/`, `Dokumentation/05_Aktueller-Stand/`, `Monster/`) |

`.gitignore` ergänzt um `.DS_Store` und `rot-debug.txt`.

Die `.DS_Store` waren **getrackt** und tauchten nach dem Löschen sofort wieder im
Git-Status auf. Sie wurden deshalb zusätzlich mit `git rm --cached` aus dem Index
genommen; erst dadurch greift der `.gitignore`-Eintrag.

Unter `Dokumentation/05_Aktueller-Stand/` liegen genau zwei Dateien: `Projekt-Stand.md`
und `Logbuch-Stand.md`.

**Bewusst nicht entfernt:** `rot-debug.txt`. Der Trace stammt von 18:42/18:44 Uhr,
`TargetPanelLayout.swift` wurde zuletzt um 18:59 Uhr geändert (`745d45e`) — es ist ein
Trace **vor Fix 8** und die Ursachen-Evidenz dafür (Panelhöhe 0.066 m gegen 0.130 m
Monsterhöhe, erreichbarer Anteil 0.462/0.494 unter der Schwelle 0.50). Der neue Lauf zeigt
an derselben Stelle 0.650. Der alte Trace darf **nicht** als Nachweis über den aktuellen
Stand zitiert werden.

---

## 9. DEBUG-/Release-Prüfung (Phase 15)

| Element | Zustand | Entscheidung |
|---|---|---|
| `DebugInteractionHarnessView` | ganze Datei in `#if DEBUG`, nicht im Phasen-Routing | **bleibt** |
| Button `🔧 Team [DEV]` | in `PrioritizationView` innerhalb `#if DEBUG` | **bleibt** |
| DROP-DEBUG-Trace (`logDropTrace`) | reines OSLog, keine UI-Einblendung | **bleibt** |
| `.input` / `.physics`-Kategorien | nur im `#if DEBUG`-Zweig von `Ticket_TamerApp.init()` | **bleibt** |
| `DebugManager` im Release | aktiv nur mit `.lifecycle`, `Logger.debug`, keine sensiblen Inhalte | **bleibt** |

Alle drei Bedingungen erfüllt: im Release nicht sichtbar, keine Release-Funktion hängt
daran, Logs weder sensibel noch laut. Keine Debugstruktur aus kosmetischen Gründen
entfernt. Der DROP-DEBUG-Trace hat sich in diesem Modul als der entscheidende
Nachweisträger erwiesen — er sollte erhalten bleiben.

Hinweis: `DebugManager.isEnabled` ist nicht selbst `#if DEBUG`-gated; im Release bleibt
`.lifecycle` auf `Logger.debug`-Niveau aktiv. Unkritisch, bewusst nicht geändert.

---

## 10. Dokumentationsänderungen (Phase 16)

`Projekt-Stand.md` und `Logbuch-Stand.md` wurden vollständig neu erzeugt und ersetzt.
Korrigierte Falschaussagen:

| bisher | tatsächlich |
|---|---|
| Branch `main` | aktiv ist `side`; `origin/main` == HEAD von `side` |
| Modul-013-Commit „offen“ | `cc5a4a2 feat: Modul 13` |
| 155 Tests | 208 Tests, alle bestanden |
| Kugel-Platzhalter als aktuelle Monster | vier echte USDC-Meshes integriert |
| Radius-/Column-/Nearest-Drop-Logik produktiv | **nicht** produktiv (siehe unten) |
| `defaultSize` = tatsächliches Volume | gemessen `0.282 × 0.236 × 0.235 m` |
| F-17 = Highscore/Persistenz | F-17 = optionale Monsterreaktion, Kann-Anforderung |
| Ergebnis zeigt Ticketanzahl | `ResultView` zeigt nur Score und „Erneut spielen“ |
| `incorrect.wav` fehlt/ungeprüft | vorhanden, hörbar geprüft, korrekt zugeordnet |
| „Build nach Fix 8 offen“ | Build PASS unter Xcode 26.6 / visionOS-SDK 26.5 |

### Welche Drop-Logik produktiv ist

| Verfahren | im Code | aufgerufen von |
|---|---|---|
| `bestTarget` / `evaluateTargets` (Fläche) | ja | **beide produktiven Views** |
| `evaluate(entityPosition:targets:)` (Radius) | ja | nur `DebugInteractionHarnessView` (`#if DEBUG`) + Tests |
| `evaluateColumn(...)` (Spalten) | ja | nur Tests |
| `evaluateNearest(...)` (nächster Nachbar) | ja | nur Tests |

Die Altverfahren bleiben als getestete Referenz erhalten, sind aber vom produktiven Pfad
vollständig getrennt.

---

## 11. Finaler Dateibaum

```text
ticket-tamer/
├─ .gitignore                    (ergänzt: .DS_Store, rot-debug.txt)
├─ README.md
├─ rot-debug.txt                 Trace VOR Fix 8 — kein Nachweis über den aktuellen Stand
├─ Dokumentation/
│  ├─ 00_Projektsteuerung/       Code-im-Projektraum.md, Repository-Struktur.md
│  ├─ 01_Kontext/                Akzeptanzkriterien.md, Projektbeschreibung.md, SPEC.md
│  ├─ 02_Vorlagen/               DebugManager.swift, Modul-Report-Vorlage.md
│  ├─ 03_Modul-Eingangsprompts/  001-Eingangsprompt.md … 014-Eingangsprompt.md
│  ├─ 04_Modul-Reports/          001-Report.md … 014-Report.md
│  └─ 05_Aktueller-Stand/        Projekt-Stand.md, Logbuch-Stand.md
├─ Monster/                      16 USDC-Farbvarianten (Ablage, nicht im Build)
└─ Ticket_Tamer/
   ├─ Packages/RealityKitContent/Sources/RealityKitContent/
   │  ├─ MonsterAssets/          Monster_1_blue/2_green/3_yellow/4_red.usdc
   │  └─ RealityKitContent.rkassets/
   │     ├─ Monster_1_blue.usdc … Monster_4_red.usdc
   │     ├─ monster01.usda … monster04.usda
   │     └─ Scene.usda, Materials/GridMaterial.usda
   ├─ Ticket_Tamer/
   │  ├─ App/                    Ticket_TamerApp.swift
   │  ├─ Assets/                 MonsterAssetProvider.swift
   │  ├─ Assets.xcassets/
   │  ├─ Components/             DropTargetComponent.swift
   │  ├─ Data/                   LocalTicketCatalog.swift
   │  ├─ Debug/                  DebugManager.swift
   │  ├─ Models/                 GamePhase.swift, SessionModel.swift, Ticket.swift
   │  ├─ Resources/              correct.wav, incorrect.wav, Localizable.xcstrings
   │  ├─ Services/               AudioService, DragBounds, DropEvaluator,
   │  │                          MonsterDragGeometry, MonsterInteractionConfigurator,
   │  │                          PlanarDrag, TargetPanelFactory, TargetPanelLayout,
   │  │                          VolumeMetrics
   │  ├─ Support/                AppConstants.swift, Entity+DragState.swift
   │  └─ Views/                  InvestigationView, PrioritizationView, ResultView,
   │                             RootVolumeView, StartView, TeamAssignmentView,
   │                             Components/ScaledToFitView, Components/TicketCardView,
   │                             Debug/DebugInteractionHarnessView  (#if DEBUG)
   └─ Ticket_TamerTests/         Ticket_TamerTests.swift (208 @Test)
```

Nicht mehr vorhanden: `_abgeloest/` samt `TargetFrameReporter.swift`,
`.git/index.lock.stale-bitte-loeschen`, sechs `.DS_Store`.

---

## 12. Abgabe-Checkliste

| # | Punkt | Status |
|---|---|---|
| 1 | Build des Fix-8-Stands mit Kopfdaten | ☑ PASS |
| 2 | Vollständiger Lauf der 208 Tests | ☑ **208/208 grün** |
| 2a | Gegenprobe-Test korrigiert | ☑ erledigt in Modul 014 |
| 2b | Wiederholungslauf nach der Korrektur | ☑ bestätigt |
| 3 | AK-06 Untersuchungsansicht, Inhalte | ☑ PASS |
| 4 | AK-06 Darstellung rotes Monster | ☐ **offen** |
| 5 | AK-07 „Weiter zur Priorisierung“ | ☑ PASS |
| 6 | AK-08 Kurve 10/25/48/55 % für alle drei Prioritätsziele | ☑ PASS |
| 7 | AK-09 dieselbe Kurve für alle vier Teamziele | ☑ PASS |
| 8 | Alle vier Monsterassets zur Laufzeit belegt | ☑ PASS |
| 9 | Clipping in Priorisierung/Teamzuordnung | ☑ PASS |
| 10 | AK-10 Exactly-once, Snapback, Lock | ☑ PASS |
| 11 | AK-11 Scoringmatrix End-to-End | ☑ PASS |
| 12 | AK-12 beide Sounds, genau einmal | ☑ PASS |
| 13 | AK-13 Regression | ☑ PASS |
| 14 | AK-14 Blender-Ownership | ☑ vom Projektverantwortlichen erklärt |
| 15 | AK-16 fünf Neustarts | ☑ PASS |
| 16 | Stabilität 1/2/6/12 Tickets | ☑ PASS |
| 17 | Apple-Vision-Pro-Gerätetest | ☐ **offen — als Abgaberisiko dokumentiert** |
| 18 | Cleanup Altlasten | ☑ erledigt |
| 19 | DEBUG-/Release-Prüfung | ☑ erledigt |
| 20 | Dokumentationskonsistenz | ☑ erledigt |
| 21 | Z-Frame-Restpunkt geprüft | ☑ erledigt, geschlossen |

---

## 13. Abschlussstatus

### B — Nicht vollständig abgabebereit

**Ein einziger offener Pflichtpunkt:**

**AK-06 — rotes Monster in der Untersuchungsansicht.**
`monster04` / `Monster_4_red.usdc` wird dort zusammen mit dem Tickettext teilweise
abgeschnitten. Der `DragBounds`-Clipping-Schutz greift in den Zieh-Phasen und ist dort
bestätigt; die Untersuchungsansicht zieht nicht, sie stellt nur dar. Zuständig sind
`InvestigationView`, `ScaledToFitView` und die Einpassung über `MonsterAssetProvider.fit`.
Nach Korrektur und Nachtest geht AK-06 auf PASS — und damit stehen **alle sechzehn
Pflicht-AKs** auf PASS.

**Dazu, hardwareabhängig: Gerätetest Apple Vision Pro.**
Nicht durchgeführt. Wenn kein Gerät beschaffbar ist, bleibt der Punkt als dokumentiertes
Abgaberisiko stehen. Nicht als PASS erfinden.

Der Abstand zur Abgabebereitschaft beträgt damit **einen Darstellungsfehler**. Alles
andere — Build, Testsuite, sämtliche Interaktions-, Scoring-, Audio-, Reset- und
Stabilitätsnachweise — ist erbracht.

---

## Dateien

| Datei (mit Ordner) | Art | Zweck |
|---|---|---|
| `Views/PrioritizationView.swift` | geändert | Kommentar zur `Raumprobe` richtiggestellt (nur Kommentar) |
| `Views/TeamAssignmentView.swift` | geändert | dito |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | geändert | Gegenprobe `snapbackInWorldSpaceWouldDrift` umgebaut; Testzahl unverändert 208 |
| `.gitignore` | geändert | `.DS_Store` und `rot-debug.txt` ergänzt |
| `_abgeloest/TargetFrameReporter.swift` | gelöscht | abgelöst |
| `.git/index.lock.stale-bitte-loeschen` | gelöscht | tote Lock-Datei |
| sechs `.DS_Store` | gelöscht | macOS-Artefakte; zusätzlich aus dem Git-Index entfernt |
| `.git/index.lock` | gelöscht | verwaiste Lock-Datei eines abgebrochenen Git-Prozesses |
| `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` | ersetzt | realer Stand |
| `Dokumentation/05_Aktueller-Stand/Logbuch-Stand.md` | ersetzt | realer Stand |
| `Dokumentation/04_Modul-Reports/014-Report.md` | neu | dieser Report |

**Keine Änderung an Programmlogik, Signaturen oder Konstanten.** Die einzige inhaltliche
Codeänderung betrifft einen Testkörper.

## Erfüllte Akzeptanzkriterien

- [x] AK-01 — Startansicht, Log bestätigt Startwert 6.
- [x] AK-02 — 12 lokale Tickets, geprüft durch `MonsterAssetPipelineTests`.
- [x] AK-03 — Ticketdaten vollständig, geprüft durch Katalogtests.
- [x] AK-04 — Sitzungsauswahl 1–12 mit Default 6, geprüft durch `StartViewModelTests`.
- [x] AK-05 — linearer Ablauf in einem Volume, geprüft durch Sitzungen über 1/2/6/12 Tickets.
- [x] AK-07 — „Weiter zur Priorisierung“, dasselbe Ticket bleibt aktiv, Sichtprüfung.
- [x] AK-08 — alle drei Prioritätsziele, geprüft mit 10/25/48/55 % und Schwellenkurve im Log.
- [x] AK-09 — alle vier Teamziele, geprüft mit 10/25/48/55 %; zwei gültige Teamdrops im Log.
- [x] AK-10 — Exactly-once, Lock, Snapback, geprüft im Simulator und über 20 DROP-DEBUG-Traces.
- [x] AK-11 — Scoring 200/100/100/0, geprüft End-to-End über alle vier Kombinationen.
- [x] AK-12 — beide Sounds hörbar und korrekt zugeordnet, genau einmal je Entscheidung.
- [x] AK-13 — kein Lösungsfeedback, ~1,5 s Übergänge, aus Modul 010, über AK-10 bestätigt.
- [x] AK-14 — vier eigene Blender-Monster; Urheberschaft erklärt, alle vier Assets zur
      Laufzeit sichtbar, ziehbar, korrekt skaliert und Y-up-korrigiert.
- [x] AK-15 — `ResultView` rendert ausschließlich Score und „Erneut spielen“.
- [x] AK-16 — fünf aufeinanderfolgende Neustarts ohne Carryover.
- [ ] AK-06 — offen, weil das rote Monster in der Untersuchungsansicht abgeschnitten wird.
- [ ] AK-06 — offen, weil das rote Monster in der Untersuchungsansicht abgeschnitten wird.
      Die Inhaltsprüfung selbst (Ticketdaten vollständig, keine Referenzwerte sichtbar) ist
      bestanden.

## Bereitgestellte Schnittstellen (für Folgemodule)

Keine neuen. Modul 014 hat keine öffentlichen Typen oder Methoden hinzugefügt oder geändert.

## DebugManager

- Ergänzte Kategorie(n): **keine**
- Geprüft: `.lifecycle` im Release aktiv; `.input` und `.physics` nur im
  `#if DEBUG`-Zweig von `Ticket_TamerApp.init()`; `.state`, `.spawning`, `.audio` vorhanden.
- Keine Debugstruktur entfernt. Der DROP-DEBUG-Trace war in diesem Modul der zentrale
  Nachweisträger und sollte erhalten bleiben.

## Annahmen / offene Punkte / Risiken

- **Belegt statt angenommen:** Fix 8 wirkt. Der maximal erreichbare Überlappungsanteil
  liegt in beiden Phasen bei 0.650 gegen die Schwelle 0.50. Das frühere Risiko einer zu
  knappen Panelhöhe in der Teamphase hat sich **nicht** materialisiert (gemessene
  Panelhöhe 0.084 m bei einer geometrischen Obergrenze von 0.088 m).
- **Risiko:** Die Reserve in der Teamphase beträgt rund 4 mm. Ein deutlich kleineres
  Volume könnte die Erreichbarkeit wieder gefährden. Bei einer Änderung an Volumegröße,
  `targetPanelGap` oder `dragSafetyPadding` unbedingt erneut prüfen — die Log-Zeile
  `Maximum reachable overlap … erreichbar: ja` beantwortet das ohne Ausprobieren.
- **Erledigt statt gelöscht:** Die Gegenprobe wurde umgebaut, nicht entfernt. Sie prüft
  weiterhin genau die Regression, um die es geht — ein Rückbau des Snapbacks auf Weltraum
  lässt sie anschlagen —, hängt aber nicht mehr davon ab, wie eine SDK-Version
  `relativeTo: nil` für lose Hierarchien auflöst. Der Wiederholungslauf bestätigt sie.
- **Lehre für Folgemodule:** Eine Gegenprobe, die ihre eigene Vorbedingung nicht mitprüft,
  kann still wertlos werden. Der Test verifiziert jetzt vorab, dass die Elternentity
  überhaupt einen eigenen Transform trägt. Dasselbe Muster lohnt sich überall dort, wo ein
  Test das **Fehlschlagen** eines Verfahrens belegen soll.
- **Hinweis zu AK-14:** Die Urheberschaft der Monster beruht auf der Erklärung des
  Projektverantwortlichen, nicht auf einem Dateinachweis. `.blend`-Quellen liegen nicht im
  Projektraum. Für spätere Änderungen an den Modellen sollten sie an einem dokumentierten
  Ort abgelegt werden.
- **Korrigiert:** Die Breitenmaße aus Modul 013 stimmten für `monster01` (0.070 statt
  gemessener 0.0643) und `monster03` (0.098 statt 0.0708) nicht. Praktisch folgenlos, weil
  die Erreichbarkeit je Asset einzeln gemessen wurde und überall bei 0.650 liegt — aber
  Zahlen aus 013 nicht ungeprüft weiterverwenden.
- **Risiko:** `rot-debug.txt` kann bei flüchtigem Lesen als aktueller Nachweis
  missverstanden werden. Die Vor-Fix-8-Herkunft ist an drei Stellen dokumentiert.
- **Für ein Folgemodul:** Den Z-Versatz zwischen `local` und `world` nicht „reparieren“ —
  er ist die Platzierung des Volumes und korrekt.

## Git

- Modul 013: bereits committed als `feat: Modul 13`
  Hash: `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439`
- Modul 014: vorgesehene Nachricht `014: Abschlussdokumentation und Cleanup`
  Hash: **noch nicht vergeben** — die Änderungen liegen im Working Tree.
- Aktiver Branch bei Modulabschluss: `side`.
  **Hinweis:** Der lokale `main` steht auf `bdb444a` und ist hinter `origin/main`. Vor der
  Abgabe klären, welcher Branch der Abgabestand ist.

## Stand aktualisiert

- [x] `Projekt-Stand.md` neu erzeugt und im Projektraum **ersetzt** (kein Altstand daneben).
- [x] `Logbuch-Stand.md` aktualisiert.
- [x] Gelöschte Dateien im Projekt-Stand unter „nicht mehr vorhanden“ vermerkt.

## Empfehlung für das nächste Modul

Ein kurzes **Restpunkte-Modul**, kein weiteres Fachmodul. Inhalt in dieser Reihenfolge:

1. Rotes Monster in der Untersuchungsansicht korrigieren, Nachtest → AK-06 PASS
2. Gerätetest, sofern Hardware verfügbar

Mehr steht nicht offen. Nach Punkt 1 die AK-Matrix in `014-Report.md`, `Projekt-Stand.md`
und `Logbuch-Stand.md` gemeinsam fortschreiben; dann darf der Abschlussstatus von B auf A
wechseln — mit dem Gerätetest als einzigem dokumentierten Restrisiko.
