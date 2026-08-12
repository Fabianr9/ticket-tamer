# Projekt-Stand — Ticket Tamer

> Aktueller technischer Stand nach Modul 010.

**Stand:** nach Modul `010` — Bewertung und Audiofeedback  
**Eingearbeitet am:** 2026-08-12  
**Branch laut Report:** `main`  
**009-Commit:** `0c38caf feat:Modul009`  
**010-Commit:** `0ab0ef7 010: Bewertung und Audiofeedback`  
**Build nach 010:** offen  
**Simulator nach 010:** offen  
**Testdeklarationen:** 140  
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

Noch nicht vorhanden:

- finale Ergebnisansicht
- „Erneut spielen“-UI
- finale eigene Blender-Monster

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
└─ .ergebnis
   └─ derzeit neutraler Platzhalter
```

## Modul-010-Schnittstellen

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

Sie verhindern doppelte Punkte und werden beim Ticketwechsel, Sitzungsstart und Reset zurückgesetzt.

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

`Services/AudioService.swift`

Verwendet laut Report:

- AVFoundation
- `AVAudioPlayer`

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
```

## Scope-Regel

Die richtige Lösung wird nie angezeigt.

Nicht vorhanden:

- Lösungs-Overlay
- „Richtig wäre …“
- sichtbares richtiges Team
- Richtig-/Falsch-Text
- Punkt-Popup

## Teststand

| Bereich | Stand |
|---|---|
| Tests vor 010 | 110 |
| neue Tests | 30 |
| Tests nach 010 | 140 |
| vollständiger Lauf | offen |

## Für Modul 011 relevant

Vorhanden:

- `GamePhase.ergebnis`
- `SessionModel.score`
- `SessionModel.reset()`
- `GameplayConstants.defaultTicketCount == 6`

Ergebnisansicht darf sichtbar ausschließlich enthalten:

- Scorezahl
- „Erneut spielen“

Nicht sichtbar verwenden:

- `sessionTickets.count`
- `currentTicketIndex`
- Maximalpunktzahl
- Detailstatistik
- richtige Lösungen

## Monster-Status

Vier USDA-Platzhalter vorhanden. Finale Blender-Monster fehlen.

## Offene Punkte

- Build nach 010
- vollständiger 140-Testlauf
- Audiohörbarkeit
- Gesten-End-to-End
- finale Sounds optional ersetzen
- finale Blender-Monster
- `.DS_Store`-Bereinigung
