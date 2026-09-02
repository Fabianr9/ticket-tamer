# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 015 für Version 1.1.

**Projektversion:** v1.1 in Arbeit  
**v1.0:** abgeschlossen  
**Stand:** nach Modul `015` — Session-HUD und Interaktionshinweise  
**Eingearbeitet am:** 2026-09-02  
**Branch laut 015-Report:** `main`  
**HEAD vor Modul 015:** `fc39a56939bb9e16f08cd3f352595e8b673d71f6` (`feat: Version 1.1`)  
**Letzter dokumentierter v1.0-Abschlussstand:** Commit `1532953`  
**Modul-015-Commit:** noch nicht erzeugt  
**v1.0-Testbasis laut Report:** 217/217 PASS  
**Testdeklarationen nach Modul 015:** 228  
**Build/Test/Simulator nach Modul 015:** offen

## Versionsentscheidung

Version 1.0 gilt als abgeschlossen und bildet die stabile fachliche Basis.

Version 1.1 ergänzt ausschließlich Usability-Funktionen F-18 bis F-24. Nicht verändert werden:

- Ticketdaten und Ticketpool,
- lineare Phasenlogik,
- DragBounds,
- 50-%-Drop-Regel,
- Z-Toleranz,
- Snapback,
- Exactly-once-Semantik,
- Scoring,
- Audio,
- ungefähr 1,5 Sekunden Feedbackdauer,
- Monster-Asset-Pipeline,
- Ergebnisansicht und Reset.

`SessionModel` bleibt die einzige Source of Truth für fachlichen Sitzungszustand. Neue v1.1-Darstellungszustände bleiben lokal in den betreffenden Views.

## v1.1-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 015 | Session-HUD und Interaktionshinweise | F-18, F-20 | implementiert; Build/Test/Simulator offen; Commit offen |
| 016 | Kompakte Ticketinfo | F-19 | als Nächstes |
| 017 | Startseiten-Usability | F-22, F-24 | offen |
| 018 | Visuelles Entscheidungsfeedback | F-21 | offen |
| 019 | Ladefehler-Recovery | F-23 | offen |
| 020 | Integration und Abnahme v1.1 | F-18 bis F-24 | offen |

## Eingearbeiteter Stand Modul 015

### Neue Komponenten

#### `SessionHUDView`

Pfad:

`Ticket_Tamer/Ticket_Tamer/Views/Components/SessionHUDView.swift`

Schnittstelle:

```text
SessionHUDView(
    currentTicketIndex: Int,
    totalTicketCount: Int,
    phase: GamePhase
)
```

Eigenschaften:

- besitzt keinen fachlichen Zustand,
- hat keinen Zugriff auf `SessionModel`,
- zeigt keinen Score,
- zeigt nur Ticketposition, Phasentitel und linearen Fortschritt,
- nicht interaktiv.

### `SessionHUDContent`

Rein darstellungsbezogene Ableitung.

Semantik:

```text
currentTicketNumber = clamp(currentTicketIndex + 1, 1...totalTicketCount)
progress = clamp(currentTicketNumber / totalTicketCount, 0...1)
```

Bei leerer Sitzung:

- Ticketnummer = 0,
- Fortschritt = 0,
- keine Division durch 0.

Phasentitel:

| Phase | Titel |
|---|---|
| `.untersuchen` | `Ticket untersuchen` |
| `.priorisieren` | `Priorität zuordnen` |
| `.teamZuordnen` | `Team zuordnen` |

Für `.start` und `.ergebnis` kein HUD.

### `InteractionHintView`

Pfad:

`Ticket_Tamer/Ticket_Tamer/Views/Components/InteractionHintView.swift`

Schnittstelle:

```text
InteractionHintView(text: String)
```

Exakte sichtbare Texte:

- Priorisierung: `Monster greifen und auf eine Priorität ziehen.`
- Teamzuordnung: `Monster greifen und dem zuständigen Team zuordnen.`

Keine Persistenz, kein Tutorialstatus, keine Gesten.

## Integration in Views

### InvestigationView

- Session-HUD oberhalb der Szene.

### PrioritizationView

- Session-HUD oberhalb,
- dauerhafter Priorisierungshinweis unterhalb.

### TeamAssignmentView

- Session-HUD oberhalb,
- dauerhafter Teamhinweis unterhalb.

## Layoutentscheidung

Verwendet werden visionOS-Ornaments:

- HUD: `.ornament(attachmentAnchor: .scene(.top))`
- Hinweis: `.ornament(attachmentAnchor: .scene(.bottom))`

Beide Komponenten setzen `.allowsHitTesting(false)`.

Ziel:

- keine Änderung an RealityView-Geometrie,
- keine Änderung an Monster- oder Panelpositionen,
- keine Blockierung von Blick/Pinch/Drag.

Die tatsächliche Simulatorprüfung steht noch aus.

## Lokalisierung

Neu in `Localizable.xcstrings`:

- `hud.ticket.position`
- `hud.phase.investigation`
- `hud.phase.prioritization`
- `hud.phase.teamAssignment`
- `hud.progress.accessibility`
- `interactionHint.prioritization`
- `interactionHint.teamAssignment`

## Accessibility

Der Fortschrittsbalken besitzt:

- Accessibility-Label `Ticketfortschritt`,
- Accessibility-Wert als Prozentwert.

Keine sichtbare Prozentanzeige erforderlich.

## Teststand Modul 015

| Kennzahl | Stand |
|---|---:|
| Testdeklarationen vor 015 | 217 |
| neue Tests | 11 |
| Testdeklarationen nach 015 | 228 |
| `jq empty` String Catalog | PASS |
| `git diff --check` | PASS |
| vollständiger Xcode-Testlauf nach 015 | offen |

Neue Tests decken ab:

- 1/6,
- 3/6 = 0,5,
- 6/6 = 1,
- gleichen Fortschritt in drei Unterphasen,
- Fortschritt beim nächsten Ticket,
- leere Sitzung,
- defensive Indexbegrenzung,
- alle drei Phasentitel,
- ausgeblendete Phasen,
- beide exakten Interaktionshinweise.

## Status F-18 / AK-18

### Implementiert

- HUD in Untersuchung, Priorisierung und Teamzuordnung,
- `Ticket X von Y`,
- exakte Phasentitel,
- lineare Ticketprogression,
- kein Score,
- `.allowsHitTesting(false)`.

### Offen

- Xcode-Build,
- vollständiger 228-Testlauf,
- Simulator-Sichtprüfung,
- tatsächlicher Nachweis, dass HUD Drag nicht blockiert.

Daher:

**F-18 implementiert; AK-18 Laufzeitabnahme offen.**

## Status F-20 / AK-20

### Implementiert

- beide exakten Hinweise,
- dauerhaft,
- ohne Persistenz,
- ohne Drag-State,
- `.allowsHitTesting(false)`.

### Offen

- tatsächliche Simulator-/Drag-Abnahme.

Daher:

**F-20 implementiert; AK-20 Laufzeitabnahme offen.**

## Schutz des v1.0-Kerns

Laut Report unverändert:

- `SessionModel`,
- Drop-Regel,
- DragBounds,
- Z-Toleranz,
- Snapback,
- Zielpanelgeometrie,
- Scoring,
- Exactly-once,
- Audio,
- Feedback-Transition.

Keine neuen Tasks und keine neuen DebugManager-Kategorien.

## Offene Punkte vor Modul 016

- [ ] Modul-015-Stand in Xcode bauen
- [ ] vollständige 228-Test-Suite ausführen
- [ ] 6-Ticket-Sitzung im Simulator prüfen
- [ ] Ticket 1/6, 3/6 = 50 %, 6/6 = 100 % prüfen
- [ ] Prioritätsdrag mit HUD/Hint prüfen
- [ ] Teamdrag mit HUD/Hint prüfen
- [ ] vollständigen Ticketzyklus regressionsprüfen
- [ ] Modul 015 mit echtem Hash committen

## Nächster Schritt

`016-Eingangsprompt.md` ausführen.

Modul 016 ergänzt ausschließlich:

- einen Info-Button in Priorisierung und Teamzuordnung,
- `CompactTicketInfoView`,
- ausschließlich sichere Ticketinformationen aus `model.currentTicket`,
- Schließen über `X` oder erneuten Info-Tap,
- lokale Overlay-State-Variablen,
- deaktivierte Drag-Interaktion solange das Overlay geöffnet ist,
- automatisches Schließen beim Phasenwechsel.

HUD und Interaktionshinweise aus Modul 015 bleiben bestehen.
