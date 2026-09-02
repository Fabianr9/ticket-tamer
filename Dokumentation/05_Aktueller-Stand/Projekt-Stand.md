# Projekt-Stand — Ticket Tamer

> Aktuelle Code-Landkarte nach Modul 015 der Version 1.1.

**Projektversion:** v1.1 in Arbeit  
**v1.0:** abgeschlossen  
**Stand:** nach Modul `015` — Session-HUD und Interaktionshinweise  
**Branch laut Report:** `main`  
**HEAD vor Modul 015:** `fc39a56939bb9e16f08cd3f352595e8b673d71f6`  
**Modul-015-Commit:** offen  
**Testdeklarationen:** 228  
**Build/Test/Simulator nach Modul 015:** offen

## Relevanter aktueller Funktionsstand

v1.0-Kern vorhanden und laut Versionierungsbasis abgeschlossen:

- genau ein zentrales Volume,
- Start,
- Untersuchung,
- Priorisierung,
- Teamzuordnung,
- Drop/Lock/Exactly-once,
- Scoring,
- Audio,
- Auto-Transition,
- Ergebnis,
- Reset,
- vier lokale Monster.

v1.1 neu nach Modul 015:

- Session-HUD in drei laufenden Phasen,
- Ticketfortschritt,
- Phasentitel,
- dauerhafte Drag-Hinweise.

## Geänderte Dateibereiche Modul 015

```text
Ticket_Tamer/Ticket_Tamer/
├── Resources/
│   └── Localizable.xcstrings
└── Views/
    ├── InvestigationView.swift
    ├── PrioritizationView.swift
    ├── TeamAssignmentView.swift
    └── Components/
        ├── InteractionHintView.swift
        └── SessionHUDView.swift
```

## Neue Schnittstellen

### `SessionHUDView`

```text
SessionHUDView(
    currentTicketIndex: Int,
    totalTicketCount: Int,
    phase: GamePhase
)
```

Reine Darstellung.

### `SessionHUDContent`

Leitet darstellungsbezogen ab:

```text
currentTicketNumber
totalTicketCount
progress
phaseTitle
```

Kein SessionModel-State.

### `InteractionHintView`

```text
InteractionHintView(text: String)
```

Reine Darstellung.

## HUD-Semantik

```text
Ticket 1 von 6 → 1/6
Ticket 3 von 6 → 0.5
Ticket 6 von 6 → 1.0
```

Fortschritt bleibt während:

```text
untersuchen → priorisieren → teamZuordnen
```

für dasselbe Ticket gleich.

## Phasentitel

- `.untersuchen` → `Ticket untersuchen`
- `.priorisieren` → `Priorität zuordnen`
- `.teamZuordnen` → `Team zuordnen`

## Interaktionshinweise

Priorität:

`Monster greifen und auf eine Priorität ziehen.`

Team:

`Monster greifen und dem zuständigen Team zuordnen.`

## Ornaments

- Session-HUD: Szene oben
- InteractionHint: Szene unten
- beide `.allowsHitTesting(false)`

Die tatsächliche Simulatorprüfung steht aus.

## Lokalisierung

Neu:

- `hud.ticket.position`
- `hud.phase.investigation`
- `hud.phase.prioritization`
- `hud.phase.teamAssignment`
- `hud.progress.accessibility`
- `interactionHint.prioritization`
- `interactionHint.teamAssignment`

## Teststand

- v1.0 dokumentierte Basis: 217 Tests PASS
- +11 Modul-015-Tests
- aktueller Quellstand: 228 Testdeklarationen
- vollständiger Lauf nach 015 offen

## v1.1-Modul-Landkarte

| Modul | Aufgabe | Status |
|---|---|---|
| 015 | HUD + Hinweise | implementiert; Abnahme offen |
| 016 | Kompakte Ticketinfo | als Nächstes |
| 017 | Startseiten-Usability | offen |
| 018 | Visuelles Feedback | offen |
| 019 | Ladefehler-Recovery | offen |
| 020 | v1.1-Integration | offen |

## Für Modul 016 relevante bestehende Daten

`Ticket`:

- ticketNumber
- title
- shortDescription
- userImpact
- symptoms
- referencePriority
- referenceTeam
- monsterAssetId

`model.currentTicket` ist die einzige Quelle für die anzuzeigende Ticketinfo.

In `CompactTicketInfoView` zulässig:

- Ticketnummer
- Titel
- Kurzbeschreibung
- User Impact
- Symptome/Hinweise

Nicht zulässig:

- Referenzpriorität
- Referenzteam
- richtige Lösung
- interne Bewertungsdaten
- Score
- monsterAssetId als Nutztext

## Neuer v1.1-Darstellungszustand für Modul 016

Laut SPEC ausdrücklich view-lokal:

```text
PrioritizationView
- isTicketInfoPresented: Bool

TeamAssignmentView
- isTicketInfoPresented: Bool
```

Nicht in `SessionModel`.

## Modul-016-Interaktionsregel

Wenn Ticketinfo geöffnet:

- verdeckte 3D-Szene nimmt keine Drag-Eingaben an,
- keine Entscheidung wird ausgelöst,
- kein Score ändert sich,
- kein Phasenwechsel entsteht.

Wenn Ticketinfo geschlossen:

- Drag wieder normal möglich.

Schließen:

- `X`,
- erneuter Info-Tap,
- Phasenwechsel.

## Offene Vormodul-Verifikation

Vor 016 möglichst nachholen:

- Build 015,
- 228 Tests,
- Simulator HUD/Hint,
- Drag-Regression,
- Commit 015.
