# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `010` — Bewertung und Audiofeedback  
**Eingearbeitet am:** 2026-08-12  
**Branch laut Report:** `main`  
**008-Hauptcommit:** `200093b`  
**008-Fix:** `b716ed1 feat:Modul008`  
**Docs-Commit nach 008:** `7b873b7 feat: update docs module 008`  
**009-Commit:** `0c38caf feat:Modul009`  
**Docs-Commit nach 009:** `2a9b58c feat: update docs module 009`  
**010-Commit:** `0ab0ef7 010: Bewertung und Audiofeedback`  
**Build nach 010:** offen  
**Simulator nach 010:** offen  
**Testdeklarationen:** 140  
**Vollständiger Testlauf:** offen

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- deutsche Startansicht,
- zwölf lokale Tickets,
- zentrales `SessionModel`,
- Monsterzuordnung und lokalen Asset-Provider,
- vier USDA-Platzhalter,
- Untersuchungsphase,
- generische Drag-/Drop-Grundlage,
- Priorisierungsphase,
- Teamzuordnungsphase,
- genau-einmal-Speicherung von Priorität,
- genau-einmal-Speicherung von Team,
- Input-Lock nach gültigen Entscheidungen,
- Bewertungslogik (+100 / +0, keine negativen Punkte),
- genau-einmal-Bewertungssemantik (Flags),
- lokale Richtig-/Falsch-Sounds (Platzhalter),
- automatischer 1,5-Sekunden-Übergang nach Prioritäts- und Teamfeedback,
- automatischer Wechsel zum nächsten Ticket nach Teamfeedback,
- Phase `.ergebnis` nach letztem Ticket.

Noch nicht vorhanden:

- fertige Ergebnisansicht (Modul 011),
- „Erneut spielen" (Modul 011),
- finale Sound-Dateien (Platzhalter aktiv),
- optionale Monsterreaktion (Modul 012),
- finale Blender-Monster.

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
│  │  ├─ correct.wav          ← NEU (Modul 010, Platzhalter)
│  │  └─ incorrect.wav        ← NEU (Modul 010, Platzhalter)
│  ├─ Services/
│  │  ├─ AudioService.swift   ← NEU (Modul 010)
│  │  ├─ DropEvaluator.swift
│  │  └─ MonsterInteractionConfigurator.swift
│  ├─ Support/
│  │  └─ AppConstants.swift   ← ergänzt (FeedbackConstants)
│  ├─ Views/
│  │  ├─ Debug/
│  │  │  └─ DebugInteractionHarnessView.swift
│  │  ├─ InvestigationView.swift
│  │  ├─ PrioritizationView.swift   ← ergänzt (Feedback-Flow)
│  │  ├─ RootVolumeView.swift
│  │  ├─ StartView.swift
│  │  └─ TeamAssignmentView.swift   ← ergänzt (Feedback-Flow)
│  ├─ Assets.xcassets
│  └─ Info.plist
├─ Ticket_TamerTests/
│  └─ Ticket_TamerTests.swift      ← ergänzt (+30 Tests)
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
   └─ derzeit neutraler Platzhalter (Modul 011)
```

## Vollständiger Spielablauf nach Modul 010

```text
StartView
  → startSession() → .untersuchen

InvestigationView
  → beginPrioritizationPhase() → .priorisieren

PrioritizationView
  → savePriority() setzt selectedPriority + sperrt Input
  → evaluatePriority() → ±100
  → audioService.play(.correct / .incorrect)
  → Task.sleep(1.5s)
  → beginTeamAssignmentPhase() → .teamZuordnen

TeamAssignmentView
  → saveTeam() setzt selectedTeam + sperrt Input
  → evaluateTeam() → ±100
  → audioService.play(.correct / .incorrect)
  → Task.sleep(1.5s)
  → completeTicketAfterTeamFeedback()
       ├─ weiteres Ticket → .untersuchen (neues Ticket)
       └─ letztes Ticket → .ergebnis
```

## SessionModel-Schnittstellen nach Modul 010

### Neu in Modul 010

| Schnittstelle | Zweck |
|---|---|
| `evaluatePriority() -> Bool?` | Bewertet Prioritätsentscheidung genau einmal; true=richtig, false=falsch, nil=No-Op |
| `evaluateTeam() -> Bool?` | Bewertet Teamentscheidung genau einmal; analog |
| `completeTicketAfterTeamFeedback()` | Schließt Ticket ab: nächstes Ticket oder `.ergebnis` |

### Bewertungsflags (intern, private)

| Flag | Zweck |
|---|---|
| `priorityEvaluated` | Verhindert doppelte Prioritätspunkte |
| `teamEvaluated` | Verhindert doppelte Teampunkte |

Beide Flags: `false` in `startSession()`, `reset()` und `completeTicketAfterTeamFeedback()`.

### Bestehende Schnittstellen (unverändert)

| Schnittstelle | Zweck |
|---|---|
| `SessionModel.selectedPriority` | Nutzerpriorität |
| `SessionModel.selectedTeam` | Nutzerteam |
| `Ticket.referencePriority` | Referenzpriorität |
| `Ticket.referenceTeam` | Referenzteam |
| `SessionModel.score` | Punktestand |
| `SessionModel.currentTicket` | Referenzdaten des aktuellen Tickets |
| `SessionModel.currentTicketIndex` | Fortschritt |
| `SessionModel.sessionTickets` | Sitzungslänge und Ticketliste |
| `SessionModel.isInputLocked` | Feedback-Lock |
| `SessionModel.beginTeamAssignmentPhase()` | nach Prioritätsfeedback in Teamphase |
| `SessionModel.lockInput()` / `unlockInput()` | Eingabesperre |
| `savePriority(_:)` | speichert Priorität |
| `saveTeam(_:)` | speichert Team |

## AudioService

| Eigenschaft | Wert |
|---|---|
| API | AVFoundation / `AVAudioPlayer` |
| Richtig-Sound | `correct.wav` (880 Hz Sinus, 0,5 s, Platzhalter) |
| Falsch-Sound | `incorrect.wav` (220 Hz Sinus, 0,5 s, Platzhalter) |
| Fehlerbehandlung | Log via `.audio`, kein Crash |
| Instanzhaltung | `@State` in Views, kein globaler Locator |

## FeedbackConstants

| Konstante | Wert |
|---|---|
| `feedbackTransitionDelay` | `1.5` (Sekunden) |
| `correctSoundName` | `"correct"` |
| `incorrectSoundName` | `"incorrect"` |
| `soundExtension` | `"wav"` |
| `correctDecisionScore` | `100` |

## Scoringsemantik

- Richtige Priorität: +100
- Falsche Priorität: +0 (kein Abzug)
- Richtiges Team: +100
- Falsches Team: +0
- Pro Ticket maximal: 200
- 12 Tickets maximal: 2400
- Score kumuliert über alle Tickets
- Reset auf 0 nur durch vollständigen `reset()`

## Wichtige Scope-Regel

**Die richtige Lösung wird nicht angezeigt.**

Nicht vorhanden in Modul 010 und nicht erlaubt:

- kein „Richtig wäre Kritisch"
- kein „Richtiges Team: Netzwerk"
- kein Lösungs-Overlay
- kein sichtbares Richtig/Falsch-Label
- keine farbliche Markierung des richtigen Ziels

Feedback besteht aus: Score intern, lokalem Sound, automatischem Übergang.

## Development-Zugang

Der `🔧 Team [DEV]`-Button in `PrioritizationView` bleibt als `#if DEBUG`-Hilfsmittel bestehen. Er erscheint nie im Release-Build.

## Build-/Verifikationsstand

| Prüfung | Stand |
|---|---|
| 008-Build | gemeldet bestätigt |
| 008-Simulatorstart | gemeldet bestätigt |
| 008-Fix committed | ja, `b716ed1` |
| 009-Build | offen |
| 009-Simulatorstart | offen |
| 010-Build | offen |
| 010-Simulatorstart | offen |
| vollständige 140 Tests | offen |
| AK-08 Gesten | offen |
| AK-09 Gesten | offen |
| AK-10 komplette Laufzeit | offen |

## Teststand

- 110 Testdeklarationen vor Modul 010
- 30 neue `ScoringAndFeedbackTests`
- **140 Testdeklarationen nach Modul 010**
- kein vollständiger Testlauf nachgewiesen

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| monster01 | USDA-Platzhalter | fehlt |
| monster02 | USDA-Platzhalter | fehlt |
| monster03 | USDA-Platzhalter | fehlt |
| monster04 | USDA-Platzhalter | fehlt |

## Schnittstellen für Modul 011

| Schnittstelle | Zweck |
|---|---|
| `SessionModel.score` | Gesamtpunktestand für Ergebnisansicht |
| `SessionModel.sessionTickets` | Vollständige Ticketliste für Statistik |
| `SessionModel.currentTicketIndex` | Letzter Index (= Anzahl gespielter Tickets - 1) |
| `GamePhase.ergebnis` | Wird nach letztem Teamfeedback gesetzt |
| `SessionModel.reset()` | Für „Erneut spielen" in Modul 011 |

## Offene Punkte

- 010-Commit/Hash fehlt noch.
- Build/Test/Simulator nach 010 fehlen.
- AK-08/AK-09/AK-10 Gestenprüfung fehlt.
- Finale Sound-Dateien fehlen (Platzhalter aktiv).
- Finale Blender-Monster fehlen.
- `.DS_Store`-Bereinigung bleibt offen.
- Ergebnisansicht und „Erneut spielen" folgen Modul 011.
- Optionale Monsterreaktion folgt Modul 012.
- echte Vision-Pro-Gesamtprüfung folgt Modul 013.
