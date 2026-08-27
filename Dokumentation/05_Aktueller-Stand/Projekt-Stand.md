# Projekt-Stand — Ticket Tamer

**Stand:** aktualisiertes Modul 013; Build/Nachtests nach Fix 8 offen  
**Eingearbeitet am:** 2026-08-27  
**Branch:** `main`  
**Commit vor Modul 013:** `b94e0ed feat: add docs modul 11`  
**Modul-011-Commit:** `209aff2 feat:Modul011`  
**Modul-013-Commit:** offen  
**Testdeklarationen:** 208  
**Vollständiger Testlauf:** offen

## Technischer Funktionsstand

Vorhanden:

- ein zentrales visionOS-Volume
- Startansicht
- 12 lokale Tickets
- Sitzungsmodell
- Untersuchungsphase
- Priorisierungsphase
- Teamzuordnung
- gemessene Drag-Grenzen
- 3D-Zielpanels
- 50-%-Drop-Regel
- Z-Nähe-Prüfung
- Hover-/Highlight-Feedback
- Scoring
- Audiofeedback
- Auto-Transition
- Ergebnisansicht
- Reset
- vier lokale USDC-Monster

## Neue/geänderte Dateien aus Modul 013

```text
Ticket_Tamer/
├─ Ticket_Tamer/
│  ├─ Assets/
│  │  └─ MonsterAssetProvider.swift
│  ├─ Components/
│  │  └─ DropTargetComponent.swift
│  ├─ Services/
│  │  ├─ DragBounds.swift
│  │  ├─ DropEvaluator.swift
│  │  ├─ MonsterDragGeometry.swift
│  │  ├─ PlanarDrag.swift
│  │  ├─ TargetPanelFactory.swift
│  │  ├─ TargetPanelLayout.swift
│  │  └─ VolumeMetrics.swift
│  ├─ Support/
│  │  └─ AppConstants.swift
│  └─ Views/
│     ├─ PrioritizationView.swift
│     └─ TeamAssignmentView.swift
└─ Packages/
   └─ RealityKitContent/
      └─ Sources/RealityKitContent/
         └─ RealityKitContent.rkassets/
            ├─ Monster_1_blue.usdc
            ├─ Monster_2_green.usdc
            ├─ Monster_3_yellow.usdc
            ├─ Monster_4_red.usdc
            ├─ monster01.usda
            ├─ monster02.usda
            ├─ monster03.usda
            └─ monster04.usda
```

Abgelöst/zu löschen:

- `_abgeloest/TargetFrameReporter.swift`
- `.git/index.lock.stale-bitte-loeschen`

## Monster-Mapping

| ID | Datei |
|---|---|
| `monster01` | `Monster_1_blue.usdc` |
| `monster02` | `Monster_2_green.usdc` |
| `monster03` | `Monster_3_yellow.usdc` |
| `monster04` | `Monster_4_red.usdc` |

## Gemessene Monstergrößen

| Asset | B | H | T |
|---|---:|---:|---:|
| monster01 | 0.070 | 0.130 | 0.073 |
| monster02 | 0.045 | 0.130 | 0.052 |
| monster03 | 0.098 | 0.130 | 0.091 |
| monster04 | 0.070 | 0.130 | 0.088 |

## Gemessenes Volume

Simulatortrace:

`0.284 × 0.236 × 0.235 m`

Die bisherigen Default-Konstanten `1.0 × 1.0 × 0.4 m` dürfen nicht als reale Geometrie verwendet werden.

## Interaktionsarchitektur

```text
GeometryReader3D + RealityView
        ↓
VolumeMetrics
        ↓
MonsterAssetProvider.localVisualBounds
        ↓
MonsterDragGeometry
   ├─ DragBounds          → sicherer Ziehbereich
   ├─ TargetPanelLayout   → Panelgröße/-position
   └─ DropEvaluator       → Overlap + Z-Nähe
```

## Drop-Regel

Gültig wenn:

- mindestens 50 % der projizierten Monsterfläche auf dem Panel liegen
- Z-Oberflächenabstand höchstens 0.05 m
- höchstens ein Ziel gewinnt

Während Drag:

- gültiges Ziel wird dezent hervorgehoben
- Speicherung erst bei `onEnded`

## Teststand

- vorher 155
- aktuell 208 Deklarationen
- +53 aus Modul 013
- davon 34 in `Modul 013 — Zielpanels und 50-%-Drop`
- vollständiger Lauf offen

## Strikte AK-Matrix

| AK | Status |
|---|---|
| AK-01 | PASS |
| AK-02 | PASS |
| AK-03 | PASS |
| AK-04 | PASS |
| AK-05 | OPEN |
| AK-06 | OPEN |
| AK-07 | OPEN |
| AK-08 | OPEN |
| AK-09 | OPEN |
| AK-10 | OPEN |
| AK-11 | OPEN |
| AK-12 | OPEN |
| AK-13 | PASS |
| AK-14 | OPEN |
| AK-15 | PASS |
| AK-16 | OPEN |

## Noch offen

- Build nach Fix 8
- 208 Tests
- AK-06/07
- Nachtest Priorität/Team nach Fix 8
- 10/25/<50/≥50-%-Verhalten
- alle vier Assets
- Clipping
- Snapback
- Exactly-once
- Scoringmatrix
- `incorrect.wav`
- fünf Neustarts
- End-to-End 1/2/6/12 Tickets
- Blender-Eigentums-/Source-Nachweis
- Gerätetest

## Bekannter technischer Hinweis

Latenter Z-Frame-Versatz zwischen lokalem und Scene-Raum muss vor Abschluss bewusst geprüft werden.

## Modul 012

F-17 bleibt bewusst ausgelassen.
