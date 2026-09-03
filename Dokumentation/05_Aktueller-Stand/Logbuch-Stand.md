# Projektlogbuch — Ticket Tamer

**Projektversion:** v1.2 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**Stand:** nach Modul `022` — Punktekommunikation v1.2  
**Eingearbeitet am:** 2026-09-03  
**Branch laut Report:** `A`  
**HEAD vor 021:** `3536b46 feat: Modul: 20`  
**Modul-021-Commits:** `68268cb` bis `c11b464`  
**Tests:** 306 vorher + 7 neu = **313 Testdeklarationen**  
**Build/Test/Simulator:** offen

## Hinweis zur Testzahl

Der Report nennt in der Testtabelle korrekt 306 Testdeklarationen. Die spätere Empfehlung eines „304-Test-Laufs“ widerspricht dieser Rechnung und wird als Zahlendreher behandelt. Maßgeblich sind **306**.

## v1.2-Modulstatus

| Modul | Titel | Status |
|---|---|---|
| 021 | Replay-Layoutstabilisierung | Architekturfix implementiert; AK-25 Laufzeit OPEN; Commit offen |
| 022 | Punktekommunikation v1.2 | implementiert; AK-26/AK-27 Laufzeit OPEN |
| 023 | Teamstation-Symbole | als Nächstes |
| 024 | Debug-UI-Isolation | offen |
| 025 | Monster-Farbvarianten | offen |
| 026 | Integration und Abnahme v1.2 | offen |

## Modul 021 — Ursache

Vor dem Fix tauschte `RootVolumeView` phasenabhängig Root-Views mit stark unterschiedlichen intrinsischen Größen aus. `ResultView` war der kleinste Ast, StartView inhaltsgetrieben und die Entscheidungsphasen volumenfüllend. Dadurch konnte Replay ein kleineres Layout-Proposal an den nächsten Start weitergeben.

Der Slider war zusätzlich nur über `maxWidth` begrenzt und dadurch besonders komprimierbar.

## Zentraler Fix

- dauerhafte `GeometryReader3D`-Root-Hülle außerhalb des Phasenrouters
- Start-Slider mit fester Designbreite
- `.defaultSize` bleibt Cold-Start-Vorgabe
- kein Window-/Volume-State im `SessionModel`
- kein Replay-Counter
- keine kumulative Gegenskalierung
- keine phasenspezifischen Replay-Hacks

## Feinabstimmung laut Report

Cold-Start-Defaultgröße:

`0.8 × 0.75 × 0.38 m`

Weitere gemeldete Layoutwerte:

- Prioritätsraster max. `0.70 m`
- Teamraster max. `0.45 m`
- Panelabstand `0.02 m`
- Untersuchung-Monster `0.24 m`
- Drag-Monster `0.17 m`
- Team-Monsterstart y = `-0.16 m`
- Untersuchung-HUD eigener Scene-Anker y = `0.06`

Die genaue finale `UnitPoint3D`-Konfiguration ist im Code maßgeblich.

## Dateien

Explizit im Report genannt:

- `Views/RootVolumeView.swift`
- `Views/StartView.swift`
- `Support/AppConstants.swift`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Da die Feinabstimmung zusätzlich Zielraster-, Monster- und HUD-Werte betrifft, muss der nächste Preflight den realen Git-Diff prüfen und alle tatsächlich geänderten Dateien dokumentieren.

## AK-25

Code-/Architektur:

- zentrale Rootbasis: erfüllt
- `.defaultSize` nicht als Replay-Reset: erfüllt
- fachlicher Reset unverändert: erfüllt
- keine kumulative Skalierung: erfüllt

Noch offen:

- Build
- vollständige 313 Tests
- Cold-Start-Messung
- Replay 1–5
- Start-/Slidervergleich
- Priority-/Teamvergleich
- Nutzer-/System-Resize
- v1.0/v1.1-Regression

**AK-25 = OPEN bis Laufzeitabnahme.**

## Nächster Schritt

`023-Eingangsprompt.md`

Modul 022 wurde ausschließlich in diesem Umfang umgesetzt:

- F-26 / AK-26: Ergebnis als `X Punkte`
- F-27 / AK-27: falsche Entscheidung als rotes Kreuz + `0 Punkte`

Scoring, Audio, Exactly-once, Input-Lock und 1,5-s-Transition bleiben unverändert.

Build, vollständiger Testlauf und Simulatorabnahme sind mangels Apple-Toolchain OPEN. Als Nächstes folgt Modul 023 — Teamstation-Symbole.
