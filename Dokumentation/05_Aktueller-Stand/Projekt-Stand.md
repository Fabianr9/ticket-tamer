# Projekt-Stand — Ticket Tamer

**Stand:** Modul 013 technisch integriert, Abnahme teilweise offen  
**Eingearbeitet am:** 2026-08-12  
**Branch:** `main`  
**Commit vor 013:** `b94e0ed feat: add docs modul 11`  
**Modul-011-Commit:** `209aff2 feat:Modul011`  
**Modul-013-Commit:** offen  
**Testdeklarationen:** 155  
**Vollständiger Testlauf:** offen

## Technischer Funktionsstand

Vorhanden:

- zentraler visionOS-Volume-Flow
- Startansicht
- 12 lokale Tickets
- Sitzungsmodell
- Untersuchungsphase
- Priorisierungsphase
- Teamzuordnung
- Drag-/Drop-Grundlage
- Scoring
- Audiofeedback
- Auto-Transition
- Ergebnisansicht
- Reset
- vier echte USDC-Monster im RealityKitContent-Bundle

## Relevante neue/geänderte Dateien aus Modul 013

```text
Ticket_Tamer/
├─ Ticket_Tamer/
│  ├─ Assets/
│  │  └─ MonsterAssetProvider.swift
│  ├─ Views/
│  │  ├─ PrioritizationView.swift
│  │  └─ TeamAssignmentView.swift
│  └─ ...
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

## Monster-Mapping

| ID | Datei |
|---|---|
| `monster01` | `Monster_1_blue.usdc` |
| `monster02` | `Monster_2_green.usdc` |
| `monster03` | `Monster_3_yellow.usdc` |
| `monster04` | `Monster_4_red.usdc` |

Ticket-Mapping unverändert.

## Assetstatus

Technisch bestätigt:

- vier unterschiedliche lokale USDC-Monster
- USDA-Wrapper referenzieren USDC
- Priorisierung/Team zeigen echte Monster laut Simulatorbericht

Noch offen:

- `.blend`-Quelldateien nicht im geprüften Ordner
- eindeutiger eigener Blender-Source-/Ownership-Nachweis
- alle vier Modelle mit Gesten testen
- finale Skalierung/Orientierung aller vier testen

Deshalb AK-14 noch OPEN.

## Integrationsfixes

### MonsterAssetProvider

- Blender-Z-up wird nach dem Laden für RealityKit-Y-up korrigiert.

### PrioritizationView / TeamAssignmentView

- direkte State-Lesezugriffe im RealityView-Update
- asynchron geladene Monster erscheinen dadurch zuverlässig
- ProgressView während Ladezustand

## Build-/Simulatorstand

Berichtet:

- Xcode-Build PASS
- visionOS 26.5 Simulator
- Monster in Priorisierung und Team sichtbar
- `correct.wav` hörbar
- 1,5-s-Transition und Ergebnis teilweise bestätigt

Nicht abgeschlossen:

- vollständige Tests
- Untersuchung AK-06/07
- Gesten-End-to-End
- `incorrect.wav`
- fünf Neustarts
- Gerätetest

## Strikte AK-Matrix

| AK | Stand |
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

## Teststand

- 155 Testdeklarationen
- Testlauf nicht ausgeführt

## Modul 012

F-17 weiterhin bewusst ausgelassen.

## Für Modul 014

Modul 014 muss:

- alle Dokumente auf diese tatsächliche Matrix synchronisieren
- keine offenen AKs als PASS deklarieren
- Git-/Dateibaum bereinigen
- Debug-only Hilfen prüfen
- `.DS_Store` entfernen
- Asset-/Audioquellen dokumentieren
- finale Abgabe-Checkliste erstellen
- noch fehlende Evidenz sichtbar als Blocker/Risiko führen
