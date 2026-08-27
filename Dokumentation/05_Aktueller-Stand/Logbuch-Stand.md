# Projektlogbuch — Ticket Tamer

**Stand:** Modul `013` — Integration, Zielpanels und Drop-Erkennung; Abschlussnachtests offen
**Eingearbeitet am:** 2026-08-27
**Branch laut Report:** `main`
**Commit vor Modul 013:** `b94e0ed feat: add docs modul 11`
**Modul-011-Commit:** `209aff2 feat:Modul011`
**Modul-012:** bewusst ohne Codeänderung ausgelassen
**Modul-013-Commit:** noch offen
**Letzter bestätigter Build:** nach Fix 5 PASS
**Build nach Fix 8:** offen
**Testdeklarationen:** 208
**Vollständiger Testlauf:** offen

## Kernergebnis

Modul 013 ersetzt angenommene Geometriewerte durch Laufzeitmessung. Tatsächliches Volume und tatsächliche Monster-Bounds werden verwendet, Drag-Grenzen werden daraus berechnet, Prioritäts- und Teamziele sind flache 3D-Panels und ein Drop ist nur gültig, wenn mindestens 50 % der projizierten Monsterfläche auf dem Ziel liegen und die Z-Nähe passt.

## Monsterintegration

| Asset-ID | USDC |
|---|---|
| `monster01` | `Monster_1_blue.usdc` |
| `monster02` | `Monster_2_green.usdc` |
| `monster03` | `Monster_3_yellow.usdc` |
| `monster04` | `Monster_4_red.usdc` |

Gemessene Abmessungen nach `fit(toMaxExtent: 0.13)`:

| Asset | Breite | Höhe | Tiefe |
|---|---:|---:|---:|
| monster01 | 0.070 | 0.130 | 0.073 |
| monster02 | 0.045 | 0.130 | 0.052 |
| monster03 | 0.098 | 0.130 | 0.091 |
| monster04 | 0.070 | 0.130 | 0.088 |

Die USDA-Wrapper referenzieren die USDC-Dateien. Das Ticket-Mapping blieb unverändert.

## AK-14

Der Report bezeichnet die Dateien als echte Blender-USDC-Exporte und bestätigt ihre Darstellung im Simulator. `.blend`-Quelldateien liegen im geprüften Ordner nicht vor.

Für den Abschluss muss deshalb weiterhin dokumentiert werden, wodurch „eigene Blender-Monster“ nachgewiesen sind. Außerdem fehlen noch der vollständige Gesten-Nachtest aller vier echten Meshes sowie die finale Skalierungs-/Orientierungsprüfung.

**AK-14 bleibt OPEN.**

## Neue Interaktionsarchitektur

Neue Services:

- `Services/VolumeMetrics.swift`
- `Services/DragBounds.swift`
- `Services/MonsterDragGeometry.swift`
- `Services/TargetPanelLayout.swift`
- `Services/TargetPanelFactory.swift`

Geändert:

- `Services/PlanarDrag.swift`
- `Services/DropEvaluator.swift`
- `Components/DropTargetComponent.swift`
- `Assets/MonsterAssetProvider.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Support/AppConstants.swift`

Abgelöst:

- `Views/Components/TargetFrameReporter.swift` liegt noch in `_abgeloest/` und soll beim Cleanup entfernt werden.

## Geometrische Regeln

### Drag-Grenzen

Sicherer Root-Bereich = gemessenes Volume minus gemessene Monsterhülle minus Sicherheitsrand.

Ziel:

- kein Clipping
- asymmetrische Monster korrekt
- keine Verwendung von `defaultSize` als reale Metergröße

### Drop-Erkennung

Gültig nur wenn:

1. projizierte Überlappung / Monsterfläche >= 0.50
2. Oberflächenabstand in Z <= 0.05 m

Zentrale Konstanten:

| Konstante | Wert |
|---|---:|
| `minimumDropOverlapRatio` | 0.50 |
| `dropDepthTolerance` | 0.05 m |
| `dragSafetyPadding` | 0.02 m |
| `targetPanelDepth` | 0.02 m |
| `targetPanelGap` | 0.02 m |
| `targetPanelHeightFactor` | 0.9 |
| `targetPanelReachabilityHeadroom` | 0.15 |
| `targetPanelMaximumHeightFraction` | 0.28 |
| `targetPanelStandoff` | 0.01 m |
| `targetHighlightScale` | 1.05 |

## Gemessenes Simulator-Volume

Trace vom 27.08.2026:

- tatsächlich: `0.284 × 0.236 × 0.235 m`
- deklariertes `defaultSize`: `1.0 × 1.0 × 0.4 m`

Entscheidung:

`LayoutConstants.centralVolumeWidth/Height/Depth` dürfen nicht mehr als reale Geometriegrundlage verwendet werden.

## Fix-Historie

1. Blender Z-up → RealityKit Y-up
2. RealityView Dependency Tracking
3. gemessene Drag-Grenzen statt angenommener Volumegrenzen
4. 3D-Zielpanels + 50-%-Regel + Z-Nähe + Highlight
5. Konstanten korrekt nach Layout/Interaction getrennt
6. Paneltiefe aus tatsächlicher geklemmter Zieh-Ebene
7. DROP-DEBUG-Trace
8. Panelhöhe so berechnet, dass die 50-%-Schwelle geometrisch erreichbar bleibt

## Teststand

Vor Interaktionsüberarbeitung: 155 Testdeklarationen.
Aktuell: **208 Testdeklarationen**.

Neu: 53 Tests, davon 34 in der Suite `Modul 013 — Zielpanels und 50-%-Drop`.

Abgedeckt werden u. a.:

- DragBounds für symmetrische/asymmetrische Monster
- Punkt↔Meter-Abbildung
- Panelraster
- 10/25/<50/≥50-%-Kurve
- freie Zwischenräume
- höchstens ein gültiges Ziel
- Z-Prüfung
- Fix-6-Regression
- Fix-8-Regression mit gemessenem Volume und allen vier Assets

**Die 208 Tests wurden noch nicht ausgeführt.**

## Korrigierte Pflicht-Abnahmematrix

| AK | Inhalt | Status |
|---|---|---|
| AK-01 | Startansicht | PASS |
| AK-02 | 12 lokale Tickets / Abdeckung | PASS |
| AK-03 | Ticketdaten | PASS |
| AK-04 | Sitzungsauswahl | PASS |
| AK-05 | vollständiger linearer Ablauf, ein Volume | OPEN |
| AK-06 | Untersuchungsansicht | OPEN |
| AK-07 | Weiter zur Priorisierung | OPEN |
| AK-08 | Priorisierung, alle drei Ziele | OPEN — Nachtest nach Fix 8 |
| AK-09 | Teamzuordnung, alle vier Ziele | OPEN — Nachtest nach Fix 8 |
| AK-10 | Invalid/Valid/Lock/Exactly-once | OPEN — Regression nach Fix 8 |
| AK-11 | Scoring 200/100/100/0, genau einmal | OPEN |
| AK-12 | beide Sounds, genau einmal | OPEN — `incorrect.wav` ungeprüft |
| AK-13 | kein Lösungsfeedback + ~1,5 s | PASS, regressionsprüfen |
| AK-14 | vier eigene Blender-Monster | OPEN |
| AK-15 | nur Scorezahl + „Erneut spielen“ | PASS |
| AK-16 | Reset, mindestens fünf Neustarts | OPEN |

## Noch zwingend vor Modul 014

- Build nach Fix 8
- vollständige 208 Tests
- AK-06/07
- AK-08/09 mit 10 %, 25 %, <50 %, >=50 %
- alle vier Monsterassets
- kein Clipping
- Invalid-Drop Snapback ohne Drift
- Exactly-once
- Scoring 200/100/100/0
- `incorrect.wav`
- mindestens fünf Neustarts
- 1-/2-/6-/12-Ticket-Sitzungen
- Apple Vision Pro oder als offenes Risiko dokumentieren

## Bekannter technischer Restpunkt

Der Report nennt einen latenten Z-Frame-Versatz:

`local=0.06 → world=0.178`

Aktuell hebt er sich in Panel-Z und Clamp auf. Vor Abschluss prüfen, damit lokale und Scene-Koordinaten nicht später vermischt werden.

## Cleanup vor 014

Zu entfernen:

- `_abgeloest/TargetFrameReporter.swift`
- `.git/index.lock.stale-bitte-loeschen`

## Git

Vorgesehener Commit:

`013: Integration, Zielpanels und Drop-Erkennung`

Hash noch offen.

## Nächster Schritt

Erst die offenen 013-Nachtests abschließen. Danach `014-Eingangsprompt.md` ausführen. Modul 014 darf offene Nachweise nicht durch Dokumentation zu PASS erklären.
