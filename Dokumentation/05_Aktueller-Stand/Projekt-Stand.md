# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `009` — Teamzuordnungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**008-Hauptcommit:** `200093b`  
**008-Fix:** `b716ed1 feat:Modul008`  
**Docs-Commit danach:** `7b873b7 feat: update docs module 008`  
**009-Commit:** offen  
**Build nach 009:** offen  
**Simulator nach 009:** offen  
**Testdeklarationen:** 110  
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
- Input-Lock nach gültigen Entscheidungen.

Noch nicht vorhanden:

- Bewertungslogik,
- Punktevergabe,
- lokale Richtig-/Falsch-Sounds,
- automatischer 1,5-Sekunden-Übergang,
- automatischer Wechsel zum nächsten Ticket,
- fertige Ergebnisansicht,
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
│  │  └─ Localizable.xcstrings
│  ├─ Services/
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

## Teamzuordnung

### `TeamAssignmentView`

Enthält:

- aktuelles Monster,
- vier Teamstationen,
- Labels Netzwerk/Konto/Software/Hardware,
- Drag-/Drop-Integration über Modul 007,
- Mapping über `TeamTargetMapping`.

### Ziel-Mapping

| Ziel-ID | SupportTeam |
|---|---|
| `team_netzwerk` | `.netzwerk` |
| `team_konto` | `.konto` |
| `team_software` | `.software` |
| `team_hardware` | `.hardware` |

### Layout

2×2:

- Netzwerk links oben,
- Konto rechts oben,
- Software links unten,
- Hardware rechts unten.

## SessionModel-Schnittstellen nach Modul 009

### `beginTeamAssignmentPhase()`

Vorbedingungen:

- Phase `.priorisieren`,
- `selectedPriority != nil`.

Effekt:

- Phase `.teamZuordnen`,
- Input entsperrt.

Unverändert:

- Score,
- Ticketindex,
- Priorität,
- Team bleibt nil.

Wird in Modul 009 im normalen Release-Flow nicht automatisch aufgerufen.

### `saveTeam(_:)`

Vorbedingungen:

- Phase `.teamZuordnen`,
- `selectedTeam == nil`,
- Input nicht gesperrt.

Effekt:

- Team speichern,
- Input sperren.

Unverändert:

- Priorität,
- Score,
- Index,
- Phase.

## Development-Zugang

Vor Modul 010 existiert in `PrioritizationView` ein `#if DEBUG`-Button:

`🔧 Team [DEV]`

Er erscheint nach gespeicherter Priorität und ruft `beginTeamAssignmentPhase()` auf.

Er ist keine Release-Funktion.

## Build-/Verifikationsstand

| Prüfung | Stand |
|---|---|
| 008-Build | gemeldet bestätigt |
| 008-Simulatorstart | gemeldet bestätigt |
| 008-Fix committed | ja, `b716ed1` |
| 009-Build | offen |
| 009-Simulatorstart | offen |
| vollständige 110 Tests | offen |
| AK-08 Gesten | offen |
| AK-09 Gesten | offen |
| AK-10 komplette Laufzeit | offen |

## Teststand

- 86 Testdeklarationen vor Modul 009,
- 24 neue `TeamAssignmentPhaseTests`,
- 110 Testdeklarationen nach Modul 009,
- kein vollständiger Testlauf nachgewiesen.

## Schnittstellen für Modul 010

| Schnittstelle | Zweck |
|---|---|
| `SessionModel.selectedPriority` | Nutzerpriorität |
| `SessionModel.selectedTeam` | Nutzerteam |
| `Ticket.referencePriority` | Referenzpriorität |
| `Ticket.referenceTeam` | Referenzteam |
| `SessionModel.score` | Punktestand |
| `SessionModel.currentTicket` | Referenzdaten des aktuellen Tickets |
| `SessionModel.currentTicketIndex` | Fortschritt |
| `SessionModel.sessionTickets` | Sitzungslänge |
| `SessionModel.isInputLocked` | Feedback-Lock |
| `SessionModel.beginTeamAssignmentPhase()` | nach Prioritätsfeedback in Teamphase |
| `SessionModel.advanceToNextTicket()` | bestehende Indexfortschaltung; für vollständigen Flow allein wahrscheinlich nicht ausreichend |
| `SessionModel.lockInput()` / `unlockInput()` | Eingabesperre |
| `savePriority(_:)` | speichert Priorität |
| `saveTeam(_:)` | speichert Team |

## Für Modul 010 fehlende Zustandslogik

Wahrscheinlich nötig ist eine kleine, kontrollierte Schnittstelle für den Abschluss eines Tickets nach Teamfeedback.

Sie muss:

- erkennen, ob noch ein weiteres Sitzungsticket existiert,
- bei weiterem Ticket Index erhöhen,
- `selectedPriority` und `selectedTeam` für das neue Ticket löschen,
- `isInputLocked = false`,
- Phase `.untersuchen`,
- Score behalten,
- bei letztem Ticket Phase `.ergebnis` setzen,
- keinen Sitzungsreset durchführen.

Die genaue Methode ist anhand des realen `SessionModel` zu entwerfen.

## Audio-Status

Im aktuellen bestätigten Stand sind noch keine zwei finalen lokalen Feedback-Sounds dokumentiert.

Modul 010 muss real inventarisieren:

- vorhandene WAV/M4A/CAF/MP3-Dateien,
- Rechte/Urheberschaft,
- Bundle-Zugehörigkeit,
- Abspielbarkeit.

Keine externen Downloads ohne klare Herkunft und Freigabe.

## Wichtige Scope-Regel

**Die richtige Lösung darf nicht angezeigt werden.**

Nicht zulässig in Modul 010:

- „Richtig wäre Kritisch“,
- „Richtiges Team: Netzwerk“,
- Lösungs-Overlay,
- Text-Erklärung,
- sichtbares Anzeigen der Referenzwerte.

Feedback besteht aus:

- Punkten intern,
- einem lokalen Richtig- oder Falsch-Sound,
- anschließendem automatischen Übergang.

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| monster01 | USDA-Platzhalter | fehlt |
| monster02 | USDA-Platzhalter | fehlt |
| monster03 | USDA-Platzhalter | fehlt |
| monster04 | USDA-Platzhalter | fehlt |

## Offene Punkte

- Modul-009-Commit/Hash fehlt.
- Build/Test/Simulator nach 009 fehlen.
- AK-08/AK-09/AK-10 Gestenprüfung fehlt.
- zwei lokale Feedback-Sounds sind noch nicht bestätigt.
- finale Blender-Monster fehlen.
- `.DS_Store`-Bereinigung bleibt offen.
