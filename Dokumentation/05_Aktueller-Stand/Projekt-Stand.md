# Projekt-Stand — Ticket Tamer

**Stand:** nach Modul 014 — 15/16 Pflicht-AKs PASS  
**Eingearbeitet am:** 2026-08-28  
**Aktiver Branch:** `side`  
**HEAD / origin/main:** `cc5a4a20c4cdfaa42ad33645d72d0f4cbb0a7439`  
**Lokaler main:** hinter `origin/main`  
**Modul-014-Commit:** offen  
**Build:** PASS  
**Tests:** **208/208 PASS**  
**Abschlussstatus:** B — nicht vollständig abgabebereit

## Technischer Funktionsstand

Bestätigt funktionsfähig:

- genau ein zentrales visionOS-Volume
- Startansicht
- 12 lokale Tickets
- Sitzungsauswahl
- Untersuchungsphase fachlich vollständig
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
- 1/2/6/12-Ticket-Stabilität

Offen:

- rotes Monster in `InvestigationView` teilweise abgeschnitten
- Apple Vision Pro Gerätetest

## Teststand

| Kennzahl | Wert |
|---|---:|
| Tests | 208 |
| Suites | 10 |
| Passed | 208 |
| Failed | 0 |
| Skipped | 0 |
| Plattform | arm64-apple-xros1.0-simulator |
| Laufzeit | 3.682 s |

## Finale AK-Matrix

| AK | Status |
|---|---|
| AK-01 | PASS |
| AK-02 | PASS |
| AK-03 | PASS |
| AK-04 | PASS |
| AK-05 | PASS |
| AK-06 | **OPEN** |
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

## AK-06

Inhalt und Navigation sind korrekt.

Fehler:

`monster04` / `Monster_4_red.usdc` wird in der Untersuchungsansicht teilweise abgeschnitten.

Nicht betroffen:

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

Drop gültig bei:

- mindestens 50 % Monsterflächenüberlappung
- Z-Abstand <= 0.05 m

`defaultSize` ist keine reale Geometriegrundlage.

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

`ResultView` zeigt ausschließlich:

- Scorezahl
- `Erneut spielen`

## Cleanup

Entfernt:

- `_abgeloest/`
- stale Git-Lock-Dateien
- `.DS_Store`

`.gitignore` enthält `.DS_Store` und `rot-debug.txt`.

## Git

Vor finaler Abgabe klären:

- aktiver Branch `side`
- `origin/main` = HEAD
- lokaler `main` hinter `origin/main`
- Modul-014-Commit noch offen

## Nächster Schritt

Kurzes Restpunkte-Modul ausschließlich für:

1. AK-06 Clippingfix
2. Nachtest
3. Abschlussstatus A/B aktualisieren
4. Branch/Commit finalisieren
5. optional Vision-Pro-Gerätetest
