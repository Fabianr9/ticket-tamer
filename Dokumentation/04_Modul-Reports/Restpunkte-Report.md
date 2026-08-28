# Restpunkte-Report — AK-06 und finaler Abgabestand

> Kein neues Fachmodul. Schliesst den letzten offenen Pflichtpunkt aus Modul 014 und
> dokumentiert den finalen Git-/Abgabestand.

**Erstellt am:** 2026-08-28
**Aktualisiert am:** 2026-08-28 — Build und Testsuite nachgetragen
**Abschlussstatus:** **B — nicht vollstaendig abgabebereit** (Simulatornachweis offen)

## Zusammenfassung

Die Ursache des AK-06-Clippings wurde am Code isoliert und ist **messbar**, nicht assetbedingt:
die Untersuchungsansicht berechnete ihren verfuegbaren Raum aus zwei veralteten Annahmen,
waehrend die Drag-Phasen ihn seit Modul 013 messen. Der Fix ersetzt beide Annahmen durch
dieselbe Messmethode (`GeometryReader3D` + `content.convert(_:from:to:)`) und passt das
Monster modellbewusst in den gemessenen Panelquader ein. Der Git-Stand wurde bereinigt:
der lokale `main` steht jetzt auf dem Abgabestand.

**Build PASS. Testsuite 217/217 PASS.** Beides nachtraeglich vom Projektverantwortlichen
in Xcode ausgefuehrt und hier eingetragen. Es fehlt noch der **visuelle Simulatornachweis**
fuer alle vier Assets sowie die Regression durch den Spielfluss. AK-06 bleibt deshalb formal
OPEN. Kein Ergebnis wurde erfunden.

## Git

Der in Modul 014 dokumentierte Git-Stand war **nicht korrekt**. Real ermittelt:

| Angabe | Dokumentiert (Modul 014) | Tatsaechlich |
|---|---|---|
| HEAD | `cc5a4a2` — feat: Modul 13 | `e8b289a` — feat: Modul 14 |
| Modul-014-Commit | offen | **bereits committed** (`235262b`, `21456e7`, `e8b289a`) |
| Working Tree | Aenderungen offen | **sauber** |
| `origin/main` | = HEAD | `e8b289a` — identisch mit `side` |
| lokaler `main` | hinter `origin/main` | war `bdb444a`, 10 Commits zurueck |
| `origin/side` | nicht erwaehnt | `745d45e` — 8 Commits hinter `side` |

Durchgefuehrt:

- geprueft, dass `main` echter Vorfahre von `origin/main` ist (`git merge-base --is-ancestor`)
- `main` per Fast-Forward auf `e8b289a` gesetzt — **keine History-Umschreibung**
- verwaiste `.git/index.lock` entfernt (dieselbe Falle wie in Modul 014)

**Abgabebranch:** `main` = `origin/main` = `e8b289a` (Stand vor diesem Fix).
`side` zeigt auf denselben Commit und traegt die Fix-Aenderungen.

Hinweis: `origin/side` liegt 8 Commits hinter `side`. Falls `side` als Arbeitsbranch
erhalten bleiben soll, muss er noch gepusht werden.

## Ursache AK-06

### Fehlerbild

`monster04` / `Monster_4_red.usdc` wird in `InvestigationView` zusammen mit dem
Ticketinhalt teilweise abgeschnitten.

### Isolierte Ursache

`InvestigationView.fitMonster(_:into:)` bildete den verfuegbaren Quader aus zwei Annahmen:

1. **`LayoutConstants.layoutPointsPerMeter = 417`** — laut eigener Dokumentation am
   Simulator gegen eine Volume-Hoehe von **0.8 m** kalibriert. `centralVolumeHeight`
   betraegt inzwischen **1.0 m**. Der Faktor beschreibt die Layoutebene nicht mehr;
   Panelbreite und -hoehe in Metern waren systematisch zu gross.
2. **`LayoutConstants.monsterPanelDepth = 0.34 m`** — das *angeforderte* Mass der
   `.frame(depth:)`, nicht das gewaehrte.

Beide Annahmen widersprechen einer bereits im Projekt vorhandenen **Messung**. Die
Regressionstests aus Modul 013 halten das tatsaechlich im Simulator gemessene Volume fest:

```
0.284 x 0.236 x 0.235 m
```

statt der deklarierten `1.0 x 1.0 x 0.4 m`.

Daraus folgt unmittelbar:

- Die angenommene Panel-Tiefe (**0.34 m**) ist **groesser als die gemessene Volume-Tiefe
  ueberhaupt** (0.235 m).
- Da Breite und Hoehe ueber den falschen Faktor stark ueberschaetzt wurden, gewann in
  `min(...)` immer der Deckel `monsterTargetSize = 0.24 m`.
- `0.24 m` liegt **ueber jeder Kante des gemessenen Volumes** — im Monster-Panel, das nur
  40 % der Breite belegt, erst recht. Beschneiden war damit konstruktiv unvermeidbar.

### Warum es nur bei einem Asset auffiel

`MonsterAssetProvider.fit(_:toMaxExtent:)` bildet die **groesste** Modellausdehnung auf die
Grenze ab. Welche Achse das ist, unterscheidet sich je Export. Das Asset, dessen groesste
Ausdehnung mit der am staerksten ueberschaetzten Achse zusammenfaellt, schlaegt zuerst an.
Ein Fehler, der nur ein Asset trifft, ist deshalb **kein Assetfehler**.

Zweite, unabhaengige Fehlerquelle an derselben Stelle: die Position wurde hart auf
`(0, 0, forward)` gesetzt. Das trifft die Panelmitte nur, wenn der Szenenursprung der
`RealityView` im Panelzentrum liegt. Das Panel ist aber die **linke Spalte eines `HStack`** —
liegt der Ursprung stattdessen in der Mitte der Layoutebene, sitzt das Monster horizontal
versetzt und laeuft in die Ticketkarte hinein. Das erklaert, warum Monster **und**
Ticketinhalt gemeinsam betroffen sind.

### Was ausgeschlossen wurde

- `ScaledToFitView` skaliert die fertige Design-Canvas mit **einem** Faktor und meldet die
  skalierte Groesse korrekt ans Layout. Kein Beitrag zum Fehler.
- `MonsterAssetProvider.fit(_:toMaxExtent:)` ist idempotent (`relativeTo: entity` schliesst
  die eigene Skalierung aus). Keine Doppelanwendung.
- `wrapAndCenter(_:)` zentriert korrekt ueber `visualBounds`. Kein Asset-Offset.
- Keine festen Frames oder Paddings am Monster-Panel ausserhalb von `investigationPadding`.
- Die Loesung der Drag-Phasen wurde **nicht** uebernommen: `DragBounds`, `TargetPanelLayout`
  und `DropEvaluator` sind unberuehrt. Die Untersuchungsansicht braucht keine Zieh-Grenzen,
  sondern eine Einpassung.

## Fix

`InvestigationFraming` ersetzt beide Annahmen durch die Messung des realen Panelquaders —
dieselbe Methode, die Modul 013 fuer die Drag-Phasen eingefuehrt hat, aber als eigener,
lokaler Typ ohne geteilte Konstante.

1. `GeometryReader3D` liefert den Panelrahmen, `content.convert(_:from: .local, to: .scene)`
   den realen Quader in Metern. Gemessen wird beim Aufbau und bei jedem Update.
2. Das Zielmass wird **modellbewusst** bestimmt: gesucht ist der groesste gemeinsame Faktor,
   mit dem das Modell in allen drei Achsen in den nutzbaren Quader passt. Ohne diesen
   Schritt haette die kleinste Panelkante jede andere Achse unnoetig beschnitten und das
   Monster waere korrekt, aber winzig.
3. Positioniert wird auf die **gemessene Panelmitte**, mit einem Vorschub, der durch die
   gemessene nutzbare Tiefe begrenzt ist — nicht mehr auf `(0, 0, forward)`.
4. Rueckfallebene: solange keine brauchbare Messung vorliegt (erster Layoutdurchlauf),
   greift unveraendert die bisherige Schaetzung. Kein neues Risiko.
5. Keine neue Magic Number. Kein neuer Layoutwert in `AppConstants.swift`.
   `monsterTargetSize` bleibt als Deckel fuer grosse Volumes erhalten.

Eine neue Debug-Zeile (`spawning`) gibt den gemessenen Quader und die bisher angenommene
Tiefe aus — damit ist die Abweichung im Simulatorlog direkt ablesbar.

## Dateien

| Datei (mit Ordner) | Art | Zweck |
|---|---|---|
| `Services/InvestigationFraming.swift` | neu | Einpassung aus gemessenem Panelquader; ohne SwiftUI-Abhaengigkeit, unit-testbar |
| `Views/InvestigationView.swift` | geaendert | `GeometryReader3D` + `measurePanel(proxy:content:)`; `fitMonster(_:fallback:)` nutzt die Messung, Rueckfallebene bleibt |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergaenzt | Suite „Restpunkt AK-06 — Einpassung im gemessenen Monster-Panel" (9 Tests) |

Nicht angefasst: `ScaledToFitView.swift`, `MonsterAssetProvider.swift`, `AppConstants.swift`,
`DragBounds.swift`, `TargetPanelLayout.swift`, `DropEvaluator.swift`, `AudioService.swift`,
`SessionModel.swift`.

Das Projekt nutzt `PBXFileSystemSynchronizedRootGroup` (objectVersion 77) — die neue Datei
wird von Xcode automatisch in das Target aufgenommen, keine `project.pbxproj`-Aenderung noetig.

## Verifikationsstand

| Schritt | Status |
|---|---|
| 2 — Fehler im Simulator reproduzieren | offen |
| 5 — alle vier Assets nachtesten | **offen** |
| 6 — AK-06 vollstaendig nachtesten | **offen** |
| 7 — Regression Start → Untersuchung → Priorisierung → Team → Ergebnis → Reset | **offen** |
| 8 — vollstaendige Testsuite | **PASS — 217/217** |
| 9 — finaler Build | **PASS** |

Ein Zwischenfehler wurde dabei behoben: `#expect` erwartet als zweiten Parameter ein
`Comment?`. Ein `String`-Property konvertiert nicht implizit — nur String-Literale (auch
mit Interpolation) tun das. Betraf `theCapLimitsTheLargestEdgeInLargePanels()`.
Zusaetzlich `@MainActor` auf der neuen Suite, weil die `Equatable`-Konformanz von
`InvestigationFraming` unter der Default-MainActor-Isolation des Projekts main-actor-isoliert
ist. Commit `1222cd3`.

## Build

**PASS.** Xcode, Ziel Apple Vision Pro (visionOS-Simulator). Der Testlauf setzt einen
erfolgreichen Build voraus.

Verbleibende Warnungen sind Bestand aus frueheren Modulen und wurden bewusst nicht in
diesem Restpunkt angefasst:

- `MonsterAssetProvider` — main-actor-isolierte statische Property `allIDs` aus nonisolated Kontext
- `MonsterAssetProvider` — `Entity.load` in asynchronem Kontext nicht verfuegbar
- `TicketCardView` — `+` fuer `Text` ab iOS 26.0 deprecated
- `RootVolumeView` — `default` wird nie erreicht
- `Ticket` — main-actor-isolierte `Equatable`-Konformanz

## Tests

**PASS.**

| Kennzahl | Wert |
|---|---:|
| Tests | **217** |
| Suites | **11** |
| Passed | **217** |
| Failed | 0 |
| Skipped | 0 |
| Laufzeit | 0.418 s |
| Plattform | `arm64-apple-xros1.0-simulator` |
| Testing Library | 1902 |

Vorher: 208 Tests / 10 Suites. Neu: Suite „Restpunkt AK-06 — Einpassung im gemessenen
Monster-Panel" mit 9 Tests, alle gruen:

- `Das bisherige Zielmass 0.24 m passt in keinen realen Panelquader` — Ursachenbeleg
- `Die alte Schaetzung ueberschaetzt den verfuegbaren Raum deutlich` — Ursachenbeleg
- `Jedes Asset bleibt in jedem Panelquader vollstaendig innerhalb`
- `Das Monster sitzt horizontal und vertikal in der Panelmitte`
- `Die modellbewusste Einpassung nutzt mehr Raum als die konservative Variante`
- `Der Deckel begrenzt die groesste Kante auch in grossen Panels`
- `Eine leere Messung gilt nicht als brauchbar`
- `Unbrauchbare Modellmasse fallen auf die konservative Variante zurueck`
- `Gleiche Messung ist gleich — verhindert die Update-Schleife`

Damit ist die Ursachenanalyse **numerisch belegt**, nicht nur hergeleitet: die beiden
Ursachentests wuerden fehlschlagen, wenn 0.24 m in den realen Panelquader passte oder die
angenommene Paneltiefe die gemessene Volume-Tiefe nicht ueberschritte.

Keine Regression: alle 208 vorbestehenden Tests weiterhin gruen, insbesondere die
Drag-/Drop-Suiten aus Modul 013.

## Simulatornachweis alle vier Monster

**Offen.** Nachzutragen je Asset (`monster01`–`monster04`): vollstaendig sichtbar, sinnvoll
skaliert, Ticketkarte unveraendert vollstaendig, keine Referenzwerte sichtbar.

Zur Pruefung hilfreich: die neue `spawning`-Logzeile
`Monster-Panel gemessen: panel … | center … | angenommene Tiefe 0.340 m`.
Die Differenz zwischen gemessener und angenommener Tiefe ist der direkte Ursachenbeleg.

Erwartete sichtbare Aenderung: das Monster wird in der Untersuchungsansicht **kleiner** als
bisher, weil es jetzt in den real verfuegbaren Raum eingepasst wird statt in einen
angenommenen. Wirkt es zu klein, ist der richtige Stellhebel
`LayoutConstants.investigationCardWidthFraction` (aktuell 0.60) — nicht das Zielmass.

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

**Pflichtstatus: 15/16 PASS.** Wechselt auf 16/16, sobald der AK-06-Nachtest vorliegt.

## Geraeteteststatus

**Apple Vision Pro Geraetetest: nicht durchgefuehrt.** Hardware in dieser Sitzung nicht
verfuegbar. Bleibt als hardwareabhaengiges Abgaberisiko dokumentiert und wird **nicht** als
PASS gewertet.

## Finaler Branch/Commit

- **Abgabebranch:** `main`
- **Stand vor diesem Fix:** `e8b289a` — feat: Modul 14 (identisch mit `origin/main` und `side`)
- **Fix-Commit:** `b56179b` auf `side` — Restpunkte: AK-06 Clippingfix (Nachtest ausstehend)
- Nach erfolgreichem Nachtest nach `main` uebernehmen und pushen
- Working Tree vor dem Fix: sauber

## Abschlussstatus

### B — Nicht vollstaendig abgabebereit

Begruendung: AK-06 ist am Code behoben, Build und Testsuite sind gruen — aber der
**visuelle Nachweis in der Untersuchungsansicht fehlt**. Die Tests belegen die Rechnung,
nicht das Bild. Ohne Sichtpruefung aller vier Assets waere ein Wechsel auf Status A eine
unbelegte Behauptung.

Zusaetzlich offen als separates Restrisiko: **Apple-Vision-Pro-Geraetetest**.

Status A ist erreicht, sobald:

1. ~~Build PASS~~ — **erledigt**
2. ~~vollstaendige Suite PASS~~ — **erledigt, 217/217**
3. alle vier Monster in der Untersuchungsansicht vollstaendig sichtbar — **offen**
4. Ticketinhalt vollstaendig sichtbar, keine Referenzwerte — **offen**
5. Regression Start → Untersuchung → Priorisierung → Team → Ergebnis → Reset — **offen**

## Empfehlung fuer den naechsten Schritt

1. Untersuchungsansicht mit allen vier Tickets/Assets im Simulator pruefen und die
   `spawning`-Logzeile mitschneiden — sie belegt die Ursache mit echten Laufzeitzahlen.
2. Regression durch den Spielfluss: Start → Untersuchung → Priorisierung → Team → Ergebnis → Reset.
3. Bei PASS: AK-Matrix auf 16/16, Abschlussstatus A, Fix nach `main` uebernehmen und pushen.
4. `origin/side` nachziehen — liegt derzeit hinter `side`.
5. Optional: `LayoutConstants.layoutPointsPerMeter` und `monsterPanelDepth` als „nur noch
   Rueckfallebene" kennzeichnen — sie beschreiben die Laufzeit nachweislich nicht.
