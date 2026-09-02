# Projektlogbuch — Ticket Tamer

**Projektversion:** v1.1 in Arbeit
**v1.0:** abgeschlossen
**Stand:** nach Modul `019` — Ladefehler-Recovery
**Eingearbeitet am:** 2026-09-02
**Branch laut 019-Preflight:** `A`
**HEAD vor Modul 019:** `de7e4d6` (`feat: Modul 18`)
**Modul-017-Commit:** `6dbd2ba feat: Modul 17`
**Modul-018-Commit:** `de7e4d6 feat: Modul 18`
**Testdeklarationen vor 019:** 278
**Testdeklarationen nach 019:** 298
**Build/Test/Simulator nach 019:** offen

## v1.1-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 015 | Session-HUD und Interaktionshinweise | F-18, F-20 | implementiert; Laufzeitabnahme offen |
| 016 | Kompakte Ticketinfo | F-19 | implementiert; Laufzeitabnahme offen |
| 017 | Startseiten-Usability | F-22, F-24 | implementiert; Commit `6dbd2ba`; Laufzeitabnahme offen |
| 018 | Visuelles Entscheidungsfeedback | F-21 | implementiert; Commit `de7e4d6`; Laufzeitabnahme offen |
| 019 | Ladefehler-Recovery | F-23 | implementiert; statisch geprüft; Build/Test/Simulator offen; Commit offen |
| 020 | Integration und Abnahme v1.1 | F-18 bis F-24 | offen |

## Stand Modul 018

Neu:

- `Views/Components/DecisionFeedbackView.swift`

Neue Darstellungssemantik:

```text
DecisionFeedbackResult
- correct
- incorrect
- init?(evaluation: Bool?)
```

Richtig:

- grüner Haken
- `+100 Punkte`
- Accessibility: `Entscheidung richtig, 100 Punkte`

Falsch:

- rotes Kreuz
- kein Punktetext
- Accessibility: `Entscheidung falsch`

Das visuelle Feedback verwendet ausschließlich das bestehende Bool-Ergebnis aus:

- `evaluatePriority()`
- `evaluateTeam()`

Es wertet Referenzpriorität oder Referenzteam nicht erneut aus.

## Integration

Beide Entscheidungsviews halten lokalen State:

```text
decisionFeedback: DecisionFeedbackResult?
```

Ablauf:

```text
gültige Entscheidung
→ bestehende Bewertung
→ Bool
→ visueller lokaler State
→ bestehender Sound
→ bestehende 1,5 s
→ visueller State zurücksetzen
→ bestehender Phasenwechsel
```

Keine zweite Task-Kette.

Unverändert:

- Score
- AudioService
- `isInputLocked`
- Exactly-once
- Drop-/Drag-Geometrie
- Startseite
- HUD
- Ticketinfo
- Ergebnisansicht

## Teststand

- vor 018: 261
- neu: 17
- nach 018: 278 Testdeklarationen
- `jq empty`: PASS
- `git diff --check` für Modul-018-Dateien: PASS
- vollständiger Xcode-Testlauf: offen

## Status F-21 / AK-21

Code-/strukturseitig umgesetzt:

- richtiger Fall: grüner Haken + `+100 Punkte`
- falscher Fall: rotes Kreuz ohne Punktetext
- parallel zum vorhandenen Sound
- an dasselbe 1,5-s-Fenster gekoppelt
- keine Lösung
- Lock/Exactly-once unverändert
- Accessibility vorhanden

Noch offen:

- Xcode-Build
- vollständiger 278-Testlauf
- Simulatorprüfung aller vier Fälle
- Sound-Synchronität
- Sichtdauer
- schnelle Mehrfacheingabe
- VoiceOver

**F-21 implementiert; AK-21 Laufzeitabnahme offen.**

## Offene Laufzeitprüfungen aus Modul 018

- [ ] Modul 018 bauen
- [ ] vollständige 278 Tests
- [ ] richtige/falsche Priorität
- [ ] richtiges/falsches Team
- [ ] Sound parallel
- [ ] 1,5-s-Sichtdauer
- [ ] Exactly-once Regression
- [ ] HUD/Ticketinfo/Startseite Regression
- [x] Modul 018 separat committen (`de7e4d6`)

## Stand Modul 019

- `Erneut laden` ist nach Monster-Ladefehlern in Untersuchung, Priorisierung und Team sichtbar.
- Retry lädt ausschließlich `currentTicket.monsterAssetId`.
- `MonsterLoadRecovery` verhindert parallele Loads und erlaubt unbegrenzt neue Versuche.
- Drei Prioritäts- und vier Teamziele werden nicht erneut erzeugt.
- Ticket, Index, Phase, Score, Entscheidungen und Input-Lock bleiben unverändert.
- 20 neue Tests; insgesamt 298 Testdeklarationen.
- Xcode-Build, vollständiger Testlauf und Simulatorprüfung sind offen.

## Nächster Schritt

Modul 019 auf macOS bauen, testen und im Simulator abnehmen; danach separat committen und Modul 020 ausführen.
