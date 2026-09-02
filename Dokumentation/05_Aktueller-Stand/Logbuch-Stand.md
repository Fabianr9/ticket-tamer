# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 017 für Version 1.1.

**Projektversion:** v1.1 in Arbeit  
**v1.0:** abgeschlossen  
**Stand:** nach Modul `017` — Startseiten-Usability  
**Eingearbeitet am:** 2026-09-02  
**Branch laut 017-Report:** `side`  
**HEAD vor Modul 017:** `0d25719` (`fix: Modul 16`)  
**Modul-016-Commit:** `8d60045 feat: Modul 16`  
**Modul-016-Layoutfix:** `0d25719 fix: Modul 16`  
**Modul-017-Commit:** noch nicht erzeugt  
**Testdeklarationen vor 017:** 246  
**Testdeklarationen nach 017:** 261  
**Build/Test/Simulator nach 017:** offen

## Versionsgrundsatz

Version 1.0 bleibt fachlich abgeschlossen. Version 1.1 ergänzt ausschließlich F-18 bis F-24.

Unverändert geschützt bleiben:

- `SessionModel` als einzige fachliche Source of Truth,
- Scoring,
- Audio,
- Exactly-once,
- 1,5-Sekunden-Feedbackflow,
- Drop-Regeln,
- DragBounds,
- Z-Toleranz,
- Snapback,
- Ticketdaten,
- Monster-Asset-Mapping,
- Ergebnisansicht,
- Resetlogik.

## v1.1-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 015 | Session-HUD und Interaktionshinweise | F-18, F-20 | implementiert; Commit `afe4bce`; Laufzeitabnahme offen |
| 016 | Kompakte Ticketinfo | F-19 | implementiert; Commit `8d60045` + Fix `0d25719`; Laufzeitabnahme offen |
| 017 | Startseiten-Usability | F-22, F-24 | implementiert; statisch geprüft; Build/Test/Simulator offen; Commit offen |
| 018 | Visuelles Entscheidungsfeedback | F-21 | als Nächstes |
| 019 | Ladefehler-Recovery | F-23 | offen |
| 020 | Integration und Abnahme v1.1 | F-18 bis F-24 | offen |

## Eingearbeiteter Stand Modul 017

### Startseitenbeschreibung

Direkt unter `Ticket Tamer` steht exakt:

`Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.`

Es wurde kein Tutorial, Popover oder persistenter Tutorialzustand ergänzt.

### Ticketanzahl-Steuerung

Die Startansicht enthält jetzt:

- Minus-Button,
- bestehenden Slider,
- Plus-Button,
- sichtbare Zahl.

Alle vier Elemente verwenden ausschließlich:

`SessionModel.selectedTicketCount`

Keine lokale Kopie, kein ViewModel, keine Persistenz.

### Minus-Semantik

- aktueller Wert > 1 → genau -1
- bei 1 → Button tatsächlich `disabled`

Accessibility:

`Ein Ticket weniger`

### Plus-Semantik

- aktueller Wert < 12 → genau +1
- bei 12 → Button tatsächlich `disabled`

Accessibility:

`Ein Ticket mehr`

### Slider

Der vorhandene Slider bleibt erhalten und nutzt weiterhin denselben Modellwert.

### Reset

`SessionModel.reset()` bleibt unverändert und setzt:

`selectedTicketCount = 6`

Damit zeigen nach „Erneut spielen“:

- Slider 6,
- Zahl 6,
- Minus enabled,
- Plus enabled.

## Dateien Modul 017

Geändert:

- `Views/StartView.swift`
- `Support/AppConstants.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Neu:

- `017-Report.md`

Nicht geändert:

- `SessionModel`
- `ResultView`
- HUD
- InteractionHint
- Ticketinfo
- Overlay-/Drag-Code
- RealityViews
- Monster-/Volume-Größen
- Scoring
- Audio
- Feedback

## Übernommener Modul-016-Dateistand

Der reale Diff bis `0d25719` bestätigt:

- `Support/AppConstants.swift`
  - Volume `1.2 × 1.15 × 0.45 m`
  - Investigation-Monsterzielgröße `0.20 m`
  - Drag-Phasen-Monsterzielgröße `0.11 m`
  - Ticketinfo-Designfläche `520 × 560 pt`
- `CompactTicketInfoView.swift`
- `PrioritizationView.swift`
- `TeamAssignmentView.swift`
- `Localizable.xcstrings`
- Tests
- Report

Damit ist die zuvor unvollständige 016-Dateidokumentation aufgelöst.

## Teststand

| Kennzahl | Stand |
|---|---:|
| Tests vor 017 | 246 |
| neue Tests | 15 |
| Tests nach 017 | 261 |
| `jq empty Localizable.xcstrings` | PASS |
| `git diff --check` für Modul-017-Dateien | PASS |
| vollständiger Xcode-Lauf | offen |

Die 15 neuen Tests decken ab:

- Plus von 6 → 7,
- Minus von 6 → 5,
- exakte Einerschritte,
- Clamp 1/12,
- Disabled-Ableitungen,
- beide Buttons bei 6 enabled,
- gemeinsame Modellquelle,
- Reset auf 6,
- Enabled-Zustände nach Reset,
- exakten Beschreibungstext,
- beide exakten Accessibility-Texte.

## Dokumentationshygiene

Der globale `git diff --check` meldet laut Report nur bereits vor Modul 017 vorhandene trailing spaces in:

- `Projekt-Stand.md`
- `Logbuch-Stand.md`

Die Modul-017-Codeänderungen selbst sind sauber.

Diese Dokumentations-Whitespace-Probleme sollen spätestens beim nächsten Commit/Cleanup bereinigt werden, ohne inhaltliche Änderungen zu erfinden.

## Status F-22 / AK-22

Code- und testseitig implementiert:

- Plus/Minus,
- Grenzen,
- Slider bleibt,
- Synchronität über eine Source of Truth,
- Reset auf 6,
- Accessibility.

Offen:

- Xcode-Build,
- vollständige 261 Tests,
- Simulatorprüfung.

Daher:

**F-22 implementiert; AK-22 Laufzeitabnahme offen.**

## Status F-24 / AK-24

Code- und testseitig implementiert:

- exakter Beschreibungstext,
- direkt unter Titel,
- kein Tutorial,
- kein Popover,
- keine Persistenz.

Offen:

- visuelle Simulatorabnahme.

Daher:

**F-24 implementiert; AK-24 Laufzeitabnahme offen.**

## Offene Punkte vor Modul 018

- [ ] Modul 017 bauen
- [ ] vollständige 261 Tests ausführen
- [ ] Start bei 6 prüfen
- [ ] Plus/Minus 1...12 prüfen
- [ ] Slider/Zahl/Buttons synchron prüfen
- [ ] Reset auf 6 prüfen
- [ ] Beschreibung visuell prüfen
- [ ] HUD aus 015 regressionsprüfen
- [ ] Ticketinfo aus 016 regressionsprüfen
- [ ] Modul 017 separat committen
- [ ] trailing spaces in aktuellen Standdokumenten bereinigen

## Nächster Schritt

`018-Eingangsprompt.md` ausführen.

Modul 018 ergänzt ausschließlich F-21 / AK-21:

- richtige Entscheidung → grüner Haken + `+100 Punkte`,
- falsche Entscheidung → rotes Kreuz ohne Punktetext,
- parallel zum bestehenden Sound,
- ausschließlich innerhalb des bestehenden ca. 1,5-Sekunden-Feedbackfensters,
- keine richtige Lösung,
- keine Änderung an Bewertung, Score, Exactly-once, Lock oder Transition.
