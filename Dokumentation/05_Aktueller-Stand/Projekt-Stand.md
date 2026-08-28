# Projekt-Stand — Ticket Tamer

**Stand:** Modul 014 — Abschlussdokumentation und Cleanup, inkl. Build und Nachtests
**Eingearbeitet am:** 2026-08-28
**Branch:** `side` (aktiv ausgecheckt)
**HEAD:** `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439 — feat: Modul 13`
**Modul-013-Commit:** `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439` (committed, identisch mit `origin/main`)
**Lokaler `main`:** `bdb444a6f05be1f912e713ec32e5db1b0821ae43 — fix: position` (hinter `origin/main`)
**Build nach Fix 8:** **PASS** — Xcode 26.6, visionOS-SDK 26.5, Deployment Target 26.5, Simulator Apple Vision Pro 26.5 (230470)
**Testlauf:** **208 von 208 bestanden**, 0 Failed, 0 Skipped, 3.682 s, `arm64-apple-xros1.0-simulator`

> **Abgabestatus: B — nicht vollständig abgabebereit.**
> **15 von 16 Pflicht-AKs sind PASS.** Offen ist allein **AK-06**: das rote Monster wird in
> der Untersuchungsansicht abgeschnitten. Dazu der Gerätetest als dokumentiertes
> Abgaberisiko.

## Technischer Funktionsstand

Vollständig lauffähig und im Simulator geprüft:

- ein zentrales visionOS-Volume
- Startansicht mit Regler (1–12, Default 6)
- 12 lokale Tickets
- Sitzungsmodell als einzige Zustandsquelle
- Untersuchungsphase
- Priorisierungsphase mit drei 3D-Zielpanels
- Teamzuordnung mit vier 3D-Zielpanels (2×2)
- gemessene Drag-Grenzen, kein Clipping in beiden Zieh-Phasen
- 50-%-Drop-Regel auf der projizierten Monsterfläche
- Z-Nähe-Prüfung (≤ 0.05 m Oberflächenabstand)
- Highlight ausschließlich für „Drop wäre jetzt gültig“
- Scoring 100 + 100 je Ticket
- Audiofeedback, hörbar geprüft
- Auto-Transition
- Ergebnisansicht (nur Score + „Erneut spielen“)
- Reset, fünf Neustarts geprüft
- vier lokale USDC-Monster, alle vier zur Laufzeit belegt

## Gemessene Laufzeitwerte (Lauf vom 27./28.08.2026)

| Größe | Wert |
|---|---|
| Volume (Szenenraum) | `0.282 × 0.236 × 0.235 m` |
| Layoutebene | 384 × 320 pt, 1360 pt/m |
| Panelgröße Priorisierung | `0.067 × 0.089 × 0.020 m` (monster03) · `0.067 × 0.087 × 0.020 m` (monster04) |
| Panelgröße Teamzuordnung | `0.111 × 0.084 × 0.020 m` |
| Max. erreichbarer Overlap | **0.650** für alle sieben Ziele, beide Assets |
| Z-Abstand | `0.000 m` (valid) durchgehend |

Die Default-Konstanten `1.0 × 1.0 × 0.4 m` beschreiben ausschließlich `defaultSize` des
Fensters und dürfen **nicht** als reale Geometriegrundlage verwendet werden.

**Fix 8 ist damit real belegt.** Der maximal erreichbare Anteil liegt bei 0.650 gegen die
Schwelle 0.50 — das entspricht `minimumDropOverlapRatio` 0.50 plus
`targetPanelReachabilityHeadroom` 0.15.

## Gemessene Schwellenkurve (AK-08)

| Overlap ratio | `overlapValid` |
|---:|---|
| 0.302 / 0.345 / 0.402 / 0.416 / 0.440 | false |
| 0.470 / 0.479 / 0.482 | false |
| **0.555 / 0.608 / 0.613 / 0.650** | **true** |

20 vollständige DROP-DEBUG-Traces: 16 × `INVALID -> Snapback`, 4 × `VALID`
(`priority_wichtig` ×2, `team_konto`, `team_software`).

## Dateibaum (Stand nach Cleanup)

```text
ticket-tamer/
├─ .gitignore                    (ergänzt: .DS_Store, rot-debug.txt)
├─ README.md
├─ rot-debug.txt                 Trace VOR Fix 8 — nicht als Nachweis verwenden
├─ Dokumentation/
│  ├─ 00_Projektsteuerung/       Code-im-Projektraum.md, Repository-Struktur.md
│  ├─ 01_Kontext/                Akzeptanzkriterien.md, Projektbeschreibung.md, SPEC.md
│  ├─ 02_Vorlagen/               DebugManager.swift, Modul-Report-Vorlage.md
│  ├─ 03_Modul-Eingangsprompts/  001…014
│  ├─ 04_Modul-Reports/          001…014
│  └─ 05_Aktueller-Stand/        Projekt-Stand.md, Logbuch-Stand.md
├─ Monster/                      16 USDC-Farbvarianten (Ablage, nicht im Build)
└─ Ticket_Tamer/
   ├─ Packages/RealityKitContent/…
   │  ├─ MonsterAssets/          Monster_1_blue, _2_green, _3_yellow, _4_red (.usdc)
   │  └─ RealityKitContent.rkassets/
   │     ├─ Monster_1_blue.usdc … Monster_4_red.usdc
   │     └─ monster01.usda … monster04.usda (Wrapper)
   ├─ Ticket_Tamer/
   │  ├─ App/Ticket_TamerApp.swift
   │  ├─ Assets/MonsterAssetProvider.swift
   │  ├─ Components/DropTargetComponent.swift
   │  ├─ Data/LocalTicketCatalog.swift
   │  ├─ Debug/DebugManager.swift
   │  ├─ Models/GamePhase.swift, SessionModel.swift, Ticket.swift
   │  ├─ Resources/correct.wav, incorrect.wav, Localizable.xcstrings
   │  ├─ Services/AudioService, DragBounds, DropEvaluator, MonsterDragGeometry,
   │  │           MonsterInteractionConfigurator, PlanarDrag, TargetPanelFactory,
   │  │           TargetPanelLayout, VolumeMetrics
   │  ├─ Support/AppConstants.swift, Entity+DragState.swift
   │  └─ Views/  InvestigationView, PrioritizationView, ResultView, RootVolumeView,
   │             StartView, TeamAssignmentView,
   │             Components/ScaledToFitView, TicketCardView,
   │             Debug/DebugInteractionHarnessView  (#if DEBUG)
   └─ Ticket_TamerTests/Ticket_TamerTests.swift   (208 @Test)
```

Nicht mehr vorhanden (in Modul 014 entfernt):

- `_abgeloest/TargetFrameReporter.swift` — Ordner `_abgeloest/` restlos entfernt
- `.git/index.lock.stale-bitte-loeschen`
- sechs `.DS_Store` (Repowurzel, `Ticket_Tamer/`, `Ticket_Tamer/Ticket_Tamer/`, `Dokumentation/`, `Dokumentation/05_Aktueller-Stand/`, `Monster/`)

## Monster-Mapping

| ID | Datei | zur Laufzeit belegt |
|---|---|---|
| `monster01` | `Monster_1_blue.usdc` | ja |
| `monster02` | `Monster_2_green.usdc` | ja |
| `monster03` | `Monster_3_yellow.usdc` | ja |
| `monster04` | `Monster_4_red.usdc` | ja |

## Gemessene Monstergrößen (nach `fit(toMaxExtent: 0.13)`)

Alle vier Werte sind gemessen, nicht übernommen:

| Asset | B | H | T | gemessen |
|---|---:|---:|---:|---|
| monster01 | 0.0643 | 0.1300 | 0.0709 | 28.08. |
| monster02 | 0.0450 | 0.1300 | 0.0584 | 28.08. |
| monster03 | 0.0708 | 0.1300 | 0.0732 | 27.08. |
| monster04 | 0.0690 | 0.1300 | 0.0880 | 27.08. |

**Die Werte aus Modul 013 waren teilweise falsch:** dort standen `monster01 = 0.070` und
`monster03 = 0.098`. `monster02` und `monster04` passten. Praktisch folgenlos, weil die
Erreichbarkeit für jedes Asset einzeln gemessen wurde und überall bei 0.650 liegt — aber
Zahlen aus 013 nicht ungeprüft weiterverwenden.

## Interaktionsarchitektur

```text
GeometryReader3D + RealityView
        ↓
VolumeMetrics                       (Layoutpunkte ↔ Szenenmeter)
        ↓
MonsterAssetProvider.localVisualBounds
        ↓
MonsterDragGeometry
   ├─ DragBounds          → sicherer Ziehbereich (kein Clipping)
   ├─ TargetPanelLayout   → Panelgröße/-position, Erreichbarkeitsgarantie
   └─ DropEvaluator       → Flächen-Overlap + Z-Nähe
```

**Produktiv ist ausschließlich die flächenbasierte Auswertung**
(`DropEvaluator.bestTarget` / `evaluateTargets`).

| Verfahren | noch im Code | verwendet von |
|---|---|---|
| `evaluate(entityPosition:targets:)` (Radius) | ja | nur `DebugInteractionHarnessView` (`#if DEBUG`) + Tests |
| `evaluateColumn(...)` (Spalten) | ja | nur Tests |
| `evaluateNearest(...)` (nächster Nachbar) | ja | nur Tests |

Keine der produktiven Views ruft eines dieser Verfahren auf.

## Drop-Regel

Gültig, wenn beides zutrifft:

- Schnittfläche ÷ projizierte **Monsterfläche** ≥ 0.50 (X/Y, achsenparallel)
- Z-Oberflächenabstand ≤ 0.05 m

Weiter gilt: höchstens ein Ziel gewinnt; Highlight nutzt dieselbe Funktion wie der Drop;
Speicherung ausschließlich in `onEnded`; ungültiger Drop → Snapback auf `originTransform`
ohne Zustandsänderung.

## Koordinatenraum (Restpunkt aus Modul 013 — geprüft und geschlossen)

Beobachtung: `local=(0, −0.02, 0.06)` → `world=(0, −0.02, 0.17765)`, konstant +0.1176 m
in Z; X und Y identisch. Derselbe Wert im aktuellen Lauf.

- `content.convert(_:from: .local, to: .scene)` liefert die Volume-Grenzen im Raum der
  Szenenwurzel.
- `content.add(_:)` hängt Monster und Panels genau dort ein, `entity.position` liegt im
  selben Raum.
- Weltkoordinaten werden in produktivem Code **nirgends** mit Volume-Grenzen verrechnet.

→ Der Z-Versatz ist die Platzierung des volumetrischen Fensters und **kein Fehler**.
Keine Architekturänderung. Die irreführenden Kommentare wurden in beiden Views
korrigiert.

Zusätzlich bestätigt der Lauf den Fix-6-Mechanismus: bei einem nicht zentrierten Z-Bereich
(`minZ=0.000 maxZ=0.235`) klemmt `effectiveMonsterPlaneZ` die Zieh-Ebene
(`0.060 → 0.053` bzw. `0.064`), und die Panels folgen — Z-Abstand bleibt 0.000.

## Audio

| Datei | Größe | Format | MD5 |
|---|---:|---|---|
| `correct.wav` | 44 144 B | Mono, 44,1 kHz, 0,5 s | `eae705784bf8fff805f52daf5465d23a` |
| `incorrect.wav` | 44 144 B | Mono, 44,1 kHz, 0,5 s | `9ccac5943668eb79b450892c579dbdb3` |

Beide hörbar geprüft, korrekt zugeordnet, genau ein Sound je gültiger Entscheidung.

## Teststand

- vor Modul 013: 155 Deklarationen
- aktuell: **208 Tests in 10 Suites**
- Ergebnis: **208 Passed, 0 Failed, 0 Skipped**, 3.682 s — alle zehn Suiten grün

```text
✔ Test run with 208 tests in 10 suites passed after 3.682 seconds.
```

Fehlgeschlagen war `Snapback im Weltraum würde Position und Größe verfälschen`
(`Ticket_TamerTests.swift:1223` / `:1227`) — eine **Gegenprobe**, kein Funktionstest. Unter
Xcode 26.6 / visionOS-SDK 26.5 verhält sich `setTransformMatrix(_:relativeTo: nil)` für
eine nicht in einer Szene hängende Hierarchie wie `relativeTo: parent`; gemessene
Abweichung 0.0. Der zugehörige positive Test war grün, der Snapback im Simulator
geprüft — **Defekt im Test, nicht im Produkt.**

**In Modul 014 korrigiert und verifiziert:** Die Gegenprobe rechnet die Aussage jetzt
direkt (`wouldBeLocal = parent⁻¹ · origin.matrix`) statt sie über das SDK zu erschließen,
und prüft zusätzlich ihre eigene Vorbedingung. Rechnerische Kontrolle mit den
Fixture-Werten: Abweichung 0.307 (Translation) und 0.320 (Skalierung) gegen die Schwelle
0.0001. Testzahl unverändert 208.

Der Wiederholungslauf bestätigt die Korrektur — der Test besteht nach 2.572 s, die Suite
`PrioritizationPhaseTests` nach 3.676 s, der Gesamtlauf grün.

## DEBUG-/Release-Prüfung

| Element | Zustand |
|---|---|
| `DebugInteractionHarnessView` | vollständig in `#if DEBUG`, nicht im Phasen-Routing |
| Button `🔧 Team [DEV]` | in `PrioritizationView` innerhalb `#if DEBUG` |
| `.input` / `.physics`-Kategorien | nur im `#if DEBUG`-Zweig von `Ticket_TamerApp.init()` |
| DROP-DEBUG-Trace | reines OSLog, keine UI-Einblendung |
| `DebugManager` im Release | aktiv nur mit `.lifecycle`, `Logger.debug` |

Nichts davon ist im Release sichtbar. Keine Debugstruktur aus kosmetischen Gründen
entfernt.

## Strikte AK-Matrix

| AK | Inhalt | Status | Begründung |
|---|---|---|---|
| AK-01 | Startansicht | PASS | Log bestätigt Startwert 6 |
| AK-02 | 12 lokale Tickets | PASS | Katalogtests grün |
| AK-03 | Ticketdaten | PASS | Pflichtdatentests grün |
| AK-04 | Sitzungsauswahl | PASS | `StartViewModelTests` grün |
| AK-05 | linearer Ablauf, ein Volume | PASS | Sitzungen über 1/2/6/12 Tickets |
| AK-06 | Untersuchungsansicht | OPEN | Inhalt PASS, rotes Monster abgeschnitten |
| AK-07 | Weiter zur Priorisierung | PASS | Sichtprüfung, gleiches Ticket bleibt aktiv |
| AK-08 | Priorisierung, drei Ziele | PASS | 10/25/48/55 % je Ziel, Schwellenkurve im Log |
| AK-09 | Teamzuordnung, vier Ziele | PASS | 10/25/48/55 % je Ziel; zwei gültige Teamdrops im Log |
| AK-10 | Invalid/Valid/Lock/Exactly-once | PASS | Simulatorprüfung + 20 Drop-Traces |
| AK-11 | Scoring 200/100/100/0 | PASS | alle vier Kombinationen End-to-End |
| AK-12 | beide Sounds, genau einmal | PASS | Hörprüfung + Dateinachweis |
| AK-13 | kein Lösungsfeedback + ~1,5 s | PASS | Modul 010, über AK-10 bestätigt |
| AK-14 | vier eigene Blender-Monster | PASS | Ownership erklärt; alle vier Assets zur Laufzeit belegt |
| AK-15 | nur Score + „Erneut spielen“ | PASS | `ResultView` rendert genau zwei Elemente |
| AK-16 | Reset, fünf Neustarts | PASS | fünf Neustarts, kein Carryover |

**15 PASS, 1 OPEN.**

## Noch offen

1. **AK-06:** Darstellung/Clipping des roten Monsters (`monster04`) in der
   Untersuchungsansicht korrigieren, dann Nachtest. Zuständig sind `InvestigationView`,
   `ScaledToFitView` und die Einpassung über `MonsterAssetProvider.fit` — der
   `DragBounds`-Clipping-Schutz greift dort nicht, die Ansicht zieht nicht.
2. **Gerätetest** auf Apple Vision Pro — oder als dokumentiertes Abgaberisiko belassen.

Nach Punkt 1 stehen alle 16 Pflicht-AKs auf PASS. Der Abstand zur Abgabebereitschaft ist
**ein Darstellungsfehler**.

## Bekanntes Restrisiko

Die Reserve der Panelhöhe in der Teamphase beträgt rund 4 mm (gemessen 0.084 m bei einer
geometrischen Obergrenze von 0.088 m). Bei Änderungen an Volumegröße, `targetPanelGap`
oder `dragSafetyPadding` erneut prüfen — die Log-Zeile
`Maximum reachable overlap … erreichbar: ja` beantwortet das ohne Ausprobieren.

## Hinweis zu `rot-debug.txt`

Trace von 18:42/18:44 Uhr, `TargetPanelLayout.swift` zuletzt geändert um 18:59 Uhr
(`745d45e`). Er zeigt den Zustand **vor Fix 8** (erreichbarer Anteil 0.462/0.494 unter der
Schwelle 0.50, jeder Drop im Snapback). Der neue Lauf zeigt an derselben Stelle 0.650.
Der alte Trace ist Ursachen-Evidenz, **kein** Nachweis über den aktuellen Stand.

## F-17

F-17 ist laut SPEC eine **Kann**-Anforderung: „optional einen fröhlichen oder traurigen
Gesichtsausdruck beziehungsweise eine kurze Monsteranimation“ (Modul 012).
F-17 ist **nicht** Highscore oder Persistenz — diese frühere Aussage war falsch.

Die Anforderung bleibt bewusst ausgelassen; die Abgabe ist laut SPEC auch ohne sie
vollständig. In Modul 014 wurde keine Monsterreaktion ergänzt.
