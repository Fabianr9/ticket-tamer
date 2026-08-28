# Restpunkte-Report — AK-06 und finaler Abgabestand

> Kein neues Fachmodul. Schliesst den letzten offenen Pflichtpunkt aus Modul 014 und
> dokumentiert den finalen Git-/Abgabestand.

**Erstellt am:** 2026-08-28
**Abschlussstatus:** **B — nicht vollstaendig abgabebereit** (Verifikation offen, siehe „Offene Verifikation")

## Zusammenfassung

Die Ursache des AK-06-Clippings wurde am Code isoliert und ist **messbar**, nicht assetbedingt:
die Untersuchungsansicht berechnete ihren verfuegbaren Raum aus zwei veralteten Annahmen,
waehrend die Drag-Phasen ihn seit Modul 013 messen. Der Fix ersetzt beide Annahmen durch
dieselbe Messmethode (`GeometryReader3D` + `content.convert(_:from:to:)`) und passt das
Monster modellbewusst in den gemessenen Panelquader ein. Der Git-Stand wurde bereinigt:
der lokale `main` steht jetzt auf dem Abgabestand.

**Build, Testsuite und Simulatornachweis stehen aus** — sie erfordern Xcode und den
visionOS-Simulator und konnten in dieser Sitzung nicht ausgefuehrt werden. AK-06 bleibt
deshalb formal OPEN, bis der Nachtest vorliegt. Kein Ergebnis wurde erfunden.

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

## Offene Verifikation

Diese Sitzung hatte **keinen Zugriff auf Xcode oder den visionOS-Simulator**. Folgende
Punkte des Restpunkte-Prompts sind daher **nicht** erledigt und duerfen nicht als bestanden
gewertet werden:

| Schritt | Status | Wer |
|---|---|---|
| 2 — Fehler im Simulator reproduzieren | **offen** | Projektverantwortlicher |
| 5 — alle vier Assets nachtesten | **offen** | Projektverantwortlicher |
| 6 — AK-06 vollstaendig nachtesten | **offen** | Projektverantwortlicher |
| 7 — Regression Start → Untersuchung → Priorisierung → Team → Ergebnis → Reset | **offen** | Projektverantwortlicher |
| 8 — vollstaendige Testsuite | **offen** | Projektverantwortlicher |
| 9 — finaler Build | **offen** | Projektverantwortlicher |

## Build

**Nicht ausgefuehrt.** Kein Xcode in dieser Sitzung. Letzter belegter Build: Modul 014, PASS
(Xcode 26.6, visionOS SDK 26.5, Simulator Apple Vision Pro visionOS 26.5).

## Tests

**Nicht ausgefuehrt.**

- Letzter belegter Lauf: **208/208 PASS**, 10 Suites, 0 Failed, 0 Skipped, 3.682 s
- Neu ergaenzt: 9 Tests in einer neuen Suite
- **Erwartung: 217 Tests / 11 Suites.** Die tatsaechliche Zahl ist nach dem Lauf einzutragen.

Die neuen Tests pruefen:

- dass `monsterTargetSize` (0.24 m) in keinem realen Panelquader Platz hatte — Ursachenbeleg
- dass `monsterPanelDepth` (0.34 m) groesser ist als die gemessene Volume-Tiefe (0.235 m)
- dass alle vier Assets in jedem plausiblen Panelquader vollstaendig innerhalb bleiben
- dass die Huelle inklusive Vorschub das Panel in keiner Achse verlaesst
- dass horizontal und vertikal auf die Panelmitte positioniert wird
- dass ein einziger Skalierungsfaktor fuer alle Achsen gilt (keine Verzerrung)
- dass der Deckel in grossen Volumes greift
- dass leere Messungen und unbrauchbare Modellmasse sauber zurueckfallen
- dass gleiche Messungen gleich vergleichen (verhindert die Update-Schleife)

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

Begruendung: AK-06 ist am Code behoben, aber **nicht nachgetestet**. Ohne Build,
Testsuite und Simulatornachweis waere ein Wechsel auf Status A eine unbelegte Behauptung.

Zusaetzlich offen als separates Restrisiko: **Apple-Vision-Pro-Geraetetest**.

Status A ist erreicht, sobald:

1. Build PASS,
2. vollstaendige Suite PASS (erwartet 217/217),
3. alle vier Monster in der Untersuchungsansicht vollstaendig sichtbar,
4. Ticketinhalt vollstaendig sichtbar, keine Referenzwerte,
5. Regression Start → Untersuchung → Priorisierung → Team → Ergebnis → Reset unauffaellig.

## Empfehlung fuer den naechsten Schritt

1. In Xcode bauen und die Suite laufen lassen; die reale Testzahl in diesen Report eintragen.
2. Untersuchungsansicht mit allen vier Tickets/Assets im Simulator pruefen und die
   `spawning`-Logzeile mitschneiden — sie belegt die Ursache mit echten Zahlen.
3. Bei PASS: AK-Matrix auf 16/16, Abschlussstatus A, Fix nach `main` uebernehmen und pushen.
4. `origin/side` nachziehen, falls `side` erhalten bleiben soll.
5. Optional: `LayoutConstants.layoutPointsPerMeter` und `monsterPanelDepth` als „nur noch
   Rueckfallebene" kennzeichnen — sie beschreiben die Laufzeit nachweislich nicht.
