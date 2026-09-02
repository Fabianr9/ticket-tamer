# Projekt-Stand — Ticket Tamer

**Projektversion:** v1.1 in Arbeit
**Stand:** nach Modul `019`
**Branch:** `A`
**HEAD vor 019:** `de7e4d6`
**Modul-018-Commit:** `de7e4d6`
**Modul-019-Commit:** offen
**Testdeklarationen:** 298
**Build/Test/Simulator:** offen

## v1.1-Funktionsstand

- 015: Session-HUD + Hinweise
- 016: Kompakte Ticketinfo + Drag-Sperre
- 017: Startseitenbeschreibung + Minus/Plus
- 018: Visuelles Entscheidungsfeedback
- 019: Ladefehler-Recovery

## Neue Feedback-Komponente

`Views/Components/DecisionFeedbackView.swift`

Correct:

- grüner Haken
- `+100 Punkte`

Incorrect:

- rotes Kreuz
- kein Punktetext

Quelle:

```text
evaluatePriority()/evaluateTeam() → Bool?
```

Kein erneuter Referenzvergleich und keine neue Punktevergabe.

## Tests

- vor 018: 261
- +17
- nach 018: 278
- Modul 019: +20
- aktuell 298 Deklarationen
- vollständiger Xcode-Lauf offen

## Modul 019

F-23 verlangt bei Monster-Ladefehler in:

- Untersuchung
- Priorisierung
- Teamzuordnung

sichtbar:

`Erneut laden`

Retry muss:

- ausschließlich aktuelles Monster neu laden
- Ladefehler zurücksetzen
- Ticket/Index/Phase/Score/Entscheidungen unverändert lassen
- `isInputLocked` nicht verändern
- keine Prioritäts-/Team-Zielpanels erneut erzeugen
- keine doppelten Monster erzeugen
- nach erneutem Fehler wieder Retry ermöglichen

Bestehende Schnittstelle historisch:

```text
MonsterAssetProvider.loadMonster(assetID:) async throws -> Entity
```

Umgesetzt über lokalen `MonsterLoadRecovery`-State und getrennte Monster-Ladefunktionen. Retry verändert das `SessionModel` nicht und erzeugt keine Zielpanels neu. Build, vollständiger Testlauf und visionOS-Simulatorprüfung sind offen.

## Für Modul 020

Integration und Laufzeitabnahme von F-18 bis F-24 auf macOS/visionOS durchführen. Für F-23 insbesondere Mehrfach-Retry, genau ein Monster, exakt drei/vier Panels und die unveränderte Sitzungszustandsmatrix prüfen.
