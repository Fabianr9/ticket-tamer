# Projekt-Stand — Ticket Tamer

> Aktueller technischer Stand nach Modul 011.

**Stand:** nach Modul `011` — Ergebnis und Neustart  
**Eingearbeitet am:** 2026-08-12  
**Branch laut Report:** `main`  
**010-Commit:** `0ab0ef7 010: Bewertung und Audiofeedback`  
**011-Commit:** `011: Ergebnis und Neustart` (Hash nach manuellem Commit eintragen)  
**Build nach 011:** offen  
**Simulator nach 011:** offen  
**Testdeklarationen:** 155  
**Vollständiger Testlauf:** offen

## Aktueller Funktionsstand

Vorhanden:

- genau ein zentrales volumetrisches Fenster
- deutsche Startansicht
- 1–12 Tickets, Standard 6
- zwölf lokale Tickets
- zentrales `SessionModel`
- Untersuchungsphase
- Priorisierungsphase
- Teamzuordnungsphase
- Drag-/Drop-Grundlage
- genau-einmal-Speicherung von Priorität und Team
- genau-einmal-Bewertung
- +100/0-Punktelogik
- zwei lokale Audio-Platzhalter
- 1,5-Sekunden-Auto-Transition
- Wechsel zum nächsten Ticket
- Wechsel nach letztem Ticket in `.ergebnis`
- **Ergebnisansicht mit Score und „Erneut spielen"**
- **vollständiger Reset-Zyklus**

Noch nicht vorhanden:

- finale eigene Blender-Monster
- finale Sounddateien (nur Sinuston-Platzhalter)

## Relevanter Dateibaum

```text
Ticket_Tamer/
├─ Ticket_Tamer/
│  ├─ App/
│  │  └─ Ticket_TamerApp.swift
│  ├─ Assets/
│  │  └─ MonsterAssetProvider.swift
│  ├─ Components/
│  │  └─ DropTargetComponent.swift
│  ├─ Data/
│  │  └─ LocalTicketCatalog.swift
│  ├─ Debug/
│  │  └─ DebugManager.swift
│  ├─ Models/
│  │  ├─ GamePhase.swift
│  │  ├─ SessionModel.swift
│  │  └─ Ticket.swift
│  ├─ Resources/
│  │  ├─ Localizable.xcstrings
│  │  ├─ correct.wav
│  │  └─ incorrect.wav
│  ├─ Services/
│  │  ├─ AudioService.swift
│  │  ├─ DropEvaluator.swift
│  │  └─ MonsterInteractionConfigurator.swift
│  ├─ Support/
│  │  └─ AppConstants.swift
│  ├─ Views/
│  │  ├─ Debug/
│  │  │  └─ DebugInteractionHarnessView.swift
│  │  ├─ InvestigationView.swift
│  │  ├─ PrioritizationView.swift
│  │  ├─ ResultView.swift          ← neu seit Modul 011
│  │  ├─ RootVolumeView.swift
│  │  ├─ StartView.swift
│  │  └─ TeamAssignmentView.swift
│  ├─ Assets.xcassets
│  └─ Info.plist
├─ Ticket_TamerTests/
│  └─ Ticket_TamerTests.swift
└─ Packages/
   └─ RealityKitContent/
      └─ Sources/RealityKitContent/RealityKitContent.rkassets/
         ├─ Scene.usda
         ├─ monster01.usda
         ├─ monster02.usda
         ├─ monster03.usda
         ├─ monster04.usda
         └─ Materials/
            └─ GridMaterial.usda
```

## Root-Phasenrouting

```text
RootVolumeView
├─ .start
│  └─ StartView
├─ .untersuchen
│  └─ InvestigationView
├─ .priorisieren
│  └─ PrioritizationView
├─ .teamZuordnen
│  └─ TeamAssignmentView
├─ .ergebnis
│  └─ ResultView          ← seit Modul 011 aktiv
└─ default
   └─ sessionPlaceholderView
```

## Ergebnisansicht (Modul 011)

Sichtbar ausschließlich:
- `SessionModel.score` als Zahl
- Schaltfläche „Erneut spielen" → `model.reset()`

Nicht sichtbar: Ticketanzahl, Maximalpunktzahl, Detailstatistik, Lösungen, Badges, Rangliste.

## `reset()`-Semantik (vollständig)

| Feld | Wert nach Reset |
|---|---|
| `selectedTicketCount` | `6` |
| `sessionTickets` | `[]` |
| `currentTicketIndex` | `0` |
| `currentPhase` | `.start` |
| `score` | `0` |
| `selectedPriority` | `nil` |
| `selectedTeam` | `nil` |
| `isInputLocked` | `false` |
| `priorityEvaluated` | `false` |
| `teamEvaluated` | `false` |

## Modul-010-Schnittstellen (weiterhin aktiv)

### `SessionModel.evaluatePriority() -> Bool?`

- richtig → +100 / `true`
- falsch → +0 / `false`
- bereits bewertet/ungültig → `nil`

### `SessionModel.evaluateTeam() -> Bool?`

Analog für Team.

### `SessionModel.completeTicketAfterTeamFeedback()`

Weiteres Ticket:

- Index +1
- `selectedPriority = nil`
- `selectedTeam = nil`
- Bewertungsflags zurück
- Input entsperrt
- Phase `.untersuchen`
- Score bleibt

Letztes Ticket:

- Phase `.ergebnis`
- Score bleibt
- Input entsperrt
- kein Indexüberlauf

## Bewertungsflags

Intern:

- `priorityEvaluated`
- `teamEvaluated`

Werden beim Ticketwechsel, Sitzungsstart und Reset zurückgesetzt.

## Punkte

- richtige Priorität: +100
- falsche Priorität: 0
- richtiges Team: +100
- falsches Team: 0
- keine negativen Punkte
- maximal 200 pro Ticket

## Audio

### Dateien

- `Resources/correct.wav`
- `Resources/incorrect.wav`

Status:

- lokal
- WAV
- projekt-eigene Sinuston-Platzhalter
- keine Fremdrechte

### Service

`Services/AudioService.swift` — AVFoundation / `AVAudioPlayer`

## Feedback-Flow

Priorität:

```text
savePriority
→ evaluatePriority
→ Sound
→ 1.5 s
→ beginTeamAssignmentPhase
```

Team:

```text
saveTeam
→ evaluateTeam
→ Sound
→ 1.5 s
→ completeTicketAfterTeamFeedback
→ .ergebnis (letztes Ticket) oder .untersuchen (nächstes Ticket)
```

## Scope-Regel

Die richtige Lösung wird nie angezeigt.

Nicht vorhanden:

- Lösungs-Overlay
- „Richtig wäre …"
- sichtbares richtiges Team
- Richtig-/Falsch-Text
- Punkt-Popup

## Teststand

| Bereich | Stand |
|---|---|
| Tests vor 010 | 110 |
| neue Tests Modul 010 | 30 |
| neue Tests Modul 011 | 15 |
| Tests nach 011 | **155** |
| vollständiger Lauf | offen |

## Monster-Status

Vier USDA-Platzhalter vorhanden. Finale Blender-Monster fehlen.

## Offene Punkte

- Build nach 011
- vollständiger 155-Testlauf
- Audiohörbarkeit
- Gesten-End-to-End im Simulator
- finale Sounds optional ersetzen
- finale Blender-Monster
- `.DS_Store`-Bereinigung
