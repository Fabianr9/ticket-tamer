# Projekt-Stand — Ticket Tamer

**Projektversion:** v1.2 in Arbeit  
**Stand:** nach Modul 022  
**Branch laut Report:** `A`  
**HEAD vor 021:** `3536b46`  
**Modul-021-Commits:** `68268cb` bis `c11b464`  
**Testdeklarationen:** **313**  
**Build/Test/Simulator:** offen

## Replay-Fix

`RootVolumeView` besitzt nun eine dauerhafte `GeometryReader3D`-Rootbasis außerhalb des Phasenrouters.

Ziel:

- gleiche volumenfüllende Layoutbasis in allen Phasen
- kein Replay-Schrumpfen durch kleine `ResultView`
- keine kumulative Skalierung

## StartView

Der Slider verwendet jetzt eine feste Designbreite:

`LayoutConstants.startSliderDesignWidth`

statt nur einer komprimierbaren Maximalbreite.

## Defaultgröße

Cold-Start-Vorgabe laut Modul 021:

`0.8 × 0.75 × 0.38 m`

Replay darf eine bereits veränderte Volume-Größe nicht auf diese Werte zurücksetzen.

## Feinabstimmung

Gemeldeter Stand:

- Priority-Raster max. `0.70 m`
- Team-Raster max. `0.45 m`
- Panelgap `0.02 m`
- Investigation-Monster `0.24 m`
- Drag-Monster `0.17 m`
- Team-Monsterstart y = `-0.16 m`

## AK-25

Architekturfix implementiert.

Laufzeitabnahme OPEN:

- Build
- 313 Tests
- Cold Start
- Replay 1–5
- Resize-Erhalt
- v1.0/v1.1-Regression

## v1.2-Modul-Landkarte

| Modul | Status |
|---|---|
| 021 | implementiert; AK-25 OPEN |
| 022 | implementiert; AK-26/AK-27 OPEN bis Laufzeitabnahme |
| 023 | als Nächstes |
| 024 | offen |
| 025 | offen |
| 026 | offen |

## Modul 022 — umgesetzt

### ResultView

Umgesetzt:

`<score> Punkte`

Beispiele:

- `0 Punkte`
- `100 Punkte`
- `600 Punkte`

Weiterhin keine:

- Maximalpunktzahl
- Prozentzahl
- Statistik
- Rang
- Badge

`Erneut spielen` bleibt.

### DecisionFeedbackView

Umgesetzt:

Correct:
- grüner Haken
- `+100 Punkte`

Incorrect:
- rotes Kreuz
- `0 Punkte`

Scoring bleibt intern +0.

## Geschützte Logik

Nicht ändern:

- `evaluatePriority()`
- `evaluateTeam()`
- Scoreberechnung
- Audio
- `isInputLocked`
- Exactly-once
- 1,5-s-Transition
- Phasenwechsel
- Replay-Rootarchitektur aus 021
