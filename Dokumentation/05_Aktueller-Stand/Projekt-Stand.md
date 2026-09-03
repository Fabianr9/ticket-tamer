# Projekt-Stand — Ticket Tamer

> Aktuelle Code-/Planungsbasis nach Modul 023 der Version 1.2.

**Projektversion:** v1.2 in Arbeit  
**Stand:** nach Modul 023  
**Branch laut Report:** `A`  
**HEAD vor 023:** `3c0b2fb`  
**Modul-022-Commit:** `3c0b2fb`  
**Modul-023-Commit:** offen  
**Testdeklarationen:** **333**  
**Build/Test/Simulator:** offen

## v1.2-Funktionsstand

### Modul 021

Replay-Layoutstabilisierung implementiert.

AK-25 Laufzeit OPEN.

### Modul 022

- Ergebnis: `<score> Punkte`
- correct: grüner Haken + `+100 Punkte`
- incorrect: rotes Kreuz + `0 Punkte`

AK-26/27 Laufzeit OPEN.

### Modul 023

Teamstationen zeigen jetzt Text + SF Symbol:

- Netzwerk → `network`
- Konto → `person.crop.circle`
- Software → `macwindow`
- Hardware → `desktopcomputer`

AK-28 Laufzeit OPEN.

## Teamstations-Geometrie

Unverändert:

- sichtbare Panelbox
- DropTargetComponent
- TargetPanelLayout
- DropEvaluator
- `minimumDropOverlapRatio = 0.50`
- `dropDepthTolerance = 0.05 m`

Referenzwerte:

- Breite `0.195 m`
- Höhe `0.117 m`
- Tiefe `0.020 m`

bei der im Report genutzten Referenzgeometrie.

## Tests

- vor 023: 313
- +20
- aktuell: **333 Testdeklarationen**
- vollständiger Xcode-Lauf offen

## v1.2-Modul-Landkarte

| Modul | Status |
|---|---|
| 021 | implementiert; AK-25 OPEN |
| 022 | implementiert; AK-26/27 OPEN |
| 023 | implementiert; AK-28 OPEN |
| 024 | als Nächstes |
| 025 | offen |
| 026 | offen |

## Für Modul 024 relevant

F-29 verlangt:

`🔧 Team [DEV]`

darf nicht mehr im normalen App-Ablauf erscheinen.

Dies gilt:

- für normalen Debug-Build über `RootVolumeView`
- für Release-Build

Erlaubt bleibt Entwicklerfunktion nur:

- im separaten `DebugInteractionHarnessView`
- oder in einem explizit aktivierten Debug-Kontext

Modul 024 darf Priorisierungs-/Teamlogik nicht verändern.

## Zu Beginn von Modul 024 real suchen

Projektweit nach:

- `🔧 Team [DEV]`
- `Team [DEV]`
- `DebugInteractionHarnessView`
- `#if DEBUG`
- Debug-only Buttons/Navigation
- direkter Einstieg in Teamphase
- DebugManager-Schalter

Ziel ist die genaue Quelle der produktnah sichtbaren DEV-Schaltfläche zu identifizieren, nicht pauschal Debugcode zu löschen.
