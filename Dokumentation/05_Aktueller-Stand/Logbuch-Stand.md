# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 016 für Version 1.1.

**Projektversion:** v1.1 in Arbeit  
**v1.0:** abgeschlossen  
**Stand:** nach Modul `016` — Kompakte Ticketinfo  
**Eingearbeitet am:** 2026-09-02  
**Branch laut 016-Report:** `side`  
**HEAD vor Modul 016:** `9fd8706363983cf1ad4ccabbfddab1f5aef08424` (`feat: Eingangsprompt 16`)  
**Modul-015-Commit:** `afe4bce feat: Modul 15`  
**Modul-016-Commit:** noch nicht erzeugt  
**Testdeklarationen vor 016:** 228  
**Testdeklarationen nach 016:** 246  
**Build/Test/Simulator nach 016:** offen

## Versionsgrundsatz

Version 1.0 bleibt fachlich abgeschlossen. Version 1.1 ergänzt ausschließlich die neuen Usability-Anforderungen F-18 bis F-24.

Weiterhin unverändert gelten:

- `SessionModel` ist einzige fachliche Source of Truth,
- keine zweite Zustandsmaschine,
- keine Änderung an Scoring,
- keine Änderung an Audio,
- keine Änderung an Exactly-once,
- keine Änderung an automatischen Phasenwechseln,
- kein zweites Volume,
- kein Immersive Space,
- keine Tutorial-/Persistenzlogik.

## v1.1-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 015 | Session-HUD und Interaktionshinweise | F-18, F-20 | implementiert; Commit `afe4bce`; Laufzeitabnahme offen |
| 016 | Kompakte Ticketinfo | F-19 | implementiert; statisch geprüft; Build/Test/Simulator offen; Commit offen |
| 017 | Startseiten-Usability | F-22, F-24 | als Nächstes |
| 018 | Visuelles Entscheidungsfeedback | F-21 | offen |
| 019 | Ladefehler-Recovery | F-23 | offen |
| 020 | Integration und Abnahme v1.1 | F-18 bis F-24 | offen |

## Eingearbeiteter Stand Modul 016

### `CompactTicketInfoView`

Neu:

`Ticket_Tamer/Ticket_Tamer/Views/Components/CompactTicketInfoView.swift`

Schnittstelle laut Report:

```text
CompactTicketInfoView(ticket:onClose:)
```

Die View leitet intern einen unveränderlichen `CompactTicketInfoContent` ab.

Enthalten:

- `ticketNumber`
- `title`
- `shortDescription`
- `userImpact`
- `symptoms`

Nicht enthalten:

- `referencePriority`
- `referenceTeam`
- `selectedPriority`
- `selectedTeam`
- `score`
- interne Ticket-ID
- `monsterAssetId`
- richtige Lösung oder Bewertungsdaten

`currentTicket == nil` führt defensiv zu keinem Info-Button/Overlay.

### Lokaler Overlay-State

In Priorisierung und Teamzuordnung jeweils lokal:

```text
@State private var isTicketInfoPresented = false
```

Der Report beschreibt den Initialwert über `TicketInfoInteraction.initialPresentation`.

Nicht in `SessionModel`.

### Öffnen und Schließen

Info-Button:

- geschlossen → öffnen
- geöffnet → schließen

Zusätzlich:

- `X` schließt
- `onAppear` schließt
- Änderung von `model.currentPhase` schließt

Damit soll kein Overlay in die nächste Phase übernommen werden.

### Drag-Sperre

Verbindliche Logik laut Report:

```text
dragEnabled = !isTicketInfoPresented && !model.isInputLocked
```

Umgesetzt durch:

- `allowsHitTesting` an der `RealityView`,
- zusätzliche frühe Guards in beiden Drag-Handlern.

Wenn Overlay geöffnet:

- keine Monsterbewegung,
- keine Drop-Auswertung,
- keine Entscheidung,
- kein fachlicher Lock durch Overlay,
- kein Snapback wegen einer nicht gestarteten Geste.

Beim Schließen:

- kein `model.unlockInput()`,
- fachlicher `isInputLocked`-Zustand bleibt unangetastet.

Diese Trennung ist architektonisch korrekt: Overlay-State ist UI-Zustand; `isInputLocked` bleibt Exactly-once-/Feedbackzustand.

## Nachbesserung in Modul 016: Layout und Raumgröße

Nach erster Sichtprüfung wurden zusätzlich zur eigentlichen F-19-Umsetzung folgende Größen geändert:

### Ticketinfo

- feste Designfläche: `520 × 560` Punkte
- `ScaledToFitView` passt diese Fläche proportional in den verfügbaren Bereich ein

### Zentrales Volume

Geändert von:

`1.0 × 1.0 × 0.4 m`

auf:

`1.2 × 1.15 × 0.45 m`

### Monster-Zielgröße

Untersuchung:

`0.24 m → 0.20 m`

Priorisierung/Team:

`0.13 m → 0.11 m`

`MonsterAssetProvider.fit` skaliert weiterhin einheitlich über alle Achsen.

## Wichtige Dokumentationsabweichung im 016-Report

Die Dateiänderungstabelle nennt nur:

- `CompactTicketInfoView.swift`
- `PrioritizationView.swift`
- `TeamAssignmentView.swift`
- `Localizable.xcstrings`
- Tests
- Report

Gleichzeitig beschreibt der Report Änderungen an:

- zentraler Volume-Größe,
- Monster-Zielgröße in Untersuchung,
- Monster-Zielgröße in Priorisierung/Team.

Diese Werte müssen in realen Projektdateien geändert worden sein, werden in der Änderungsübersicht aber nicht vollständig ausgewiesen.

Daher gilt für Modul 017 zwingend:

- tatsächlichen `git diff` / aktuellen Code prüfen,
- reale Dateien identifizieren,
- diese 016-Nachbesserung im Projektstand korrekt nachtragen,
- Regression der v1.0-Geometrie und Modul-015-Ornaments prüfen,
- nicht so tun, als sei Modul 016 ausschließlich eine Overlayänderung gewesen.

Die Layoutnachbesserung wird als **begründeter 016-Scope-Übergriff zur Lesbarkeit** geführt, bis der reale Diff bestätigt ist.

## Lokalisierung / Accessibility

Neu beziehungsweise ergänzt:

- Accessibility-Text Info-Button
- Accessibility-Text Schließen-X

Bestehende semantisch identische Investigation-Schlüssel für Ticketnummer, Auswirkung und Symptome werden wiederverwendet.

Accessibility laut Report:

- Info: `Ticketinformationen anzeigen oder schließen`
- X: `Ticketinformationen schließen`

## Teststand

| Kennzahl | Stand |
|---|---:|
| Tests vor 016 | 228 |
| neue Tests | 18 |
| Tests nach 016 | 246 |
| `jq empty Localizable.xcstrings` | PASS |
| `git diff --check` | PASS |
| vollständiger Xcode-Lauf | offen |

Neue Tests prüfen:

- fünf sichtbare Ticketfelder,
- alle Symptome,
- keine Referenzpriorität/-team,
- keine interne ID/Monster-ID,
- Overlay initial geschlossen,
- Toggle in beide Richtungen,
- Neustartzustand geschlossen,
- Drag-Freigabe mit Overlay,
- Zusammenspiel mit fachlichem Input-Lock,
- Designfläche,
- vergrößertes Volume,
- reduzierte Monster-Zielgrößen.

## Status F-19 / AK-19

### Code-/Strukturseitig implementiert

- aktuelle Ticketquelle,
- exakt begrenzter Inhalt,
- keine Referenzwerte,
- Drag-Sperre,
- X,
- erneuter Info-Tap,
- Reset bei View-/Phasenwechsel,
- kein Info-Button in Untersuchung.

### Noch offen

- Xcode-Build,
- vollständiger 246-Testlauf,
- Simulator-/Vision-Pro-Sichtprüfung,
- reale Drag-Sperre,
- Drag nach Schließen,
- Overlay-Schließen beim Phasenwechsel,
- Layoutprüfung nach Volume-/Monstergrößenänderung.

Daher:

**F-19 implementiert; AK-19 Laufzeitabnahme offen.**

## Schutz von Modul 015

Laut Report unverändert:

- `SessionHUDView`
- `InteractionHintView`
- `InvestigationView` fachlich

Zu verifizieren:

- HUD-Ornament oben trotz größerem Volume,
- Hint-Ornament unten,
- keine Überdeckung,
- keine Drag-Regression.

## Offene Punkte vor Modul 017

- [ ] tatsächlichen aktuellen Git-Diff lesen
- [ ] reale Dateien der Volume-/Monstergrößenänderung identifizieren
- [ ] Modul 016 Build
- [ ] vollständige 246 Tests
- [ ] Simulator Ticketinfo Priorität
- [ ] Simulator Ticketinfo Team
- [ ] X / erneuter Info-Tap
- [ ] Drag offen/geschlossen
- [ ] Phasenwechsel schließt Overlay
- [ ] HUD/Hint Regression
- [ ] Volume-/Monstergrößen Regression
- [ ] Modul 016 separat committen und echten Hash dokumentieren

## Nächster Schritt

`017-Eingangsprompt.md` ausführen.

Modul 017 bearbeitet ausschließlich:

- F-22 / AK-22 Minus-/Plus-Buttons für Ticketanzahl,
- F-24 / AK-24 kurze Startseitenbeschreibung.

Keine Ticketinfo-, Entscheidungsfeedback- oder Retry-Erweiterung.
