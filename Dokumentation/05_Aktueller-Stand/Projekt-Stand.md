# Projekt-Stand — Ticket Tamer

> Aktuelle Landkarte des bestätigten Codes und der bekannten Projektbestandteile. Nach jedem Modul wird dieses Dokument vollständig neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt. Die Code-Historie liegt ausschließlich in Git.

**Stand:** nach Modul `007` — Räumliche Interaktionsgrundlagen  
**Eingearbeitet am:** 2026-08-09  
**Branch laut Report:** `main`  
**Commit vor Modul 007:** `243c56c feat: add docs`  
**Modul-006-Commit:** `177e2b9 feat: Modul006`  
**Modul-007-Commit:** offen (`.git/index.lock` — manuell committen: `git add -A && git commit -m "007: Räumliche Interaktionsgrundlagen"`)  
**Build nach Modul 007:** nicht nachgewiesen  
**Simulatorstart nach Modul 007:** nicht nachgewiesen  
**Testlauf nach Modul 007:** nicht nachgewiesen  
**Testdeklarationen im Quellstand:** 64

---

## Technischer Gesamtstand

Der gemeldete Quellstand enthält:

- genau ein zentrales volumetrisches Fenster,
- deutsche Startansicht,
- zwölf lokale Tickets,
- zentrales `SessionModel`,
- Auswahl ohne Wiederholung,
- Monsterzuordnung über `monsterAssetId`,
- vier lokale USDA-Platzhalter,
- `MonsterAssetProvider`,
- `InvestigationView`,
- vollständige Ticketkarte der Untersuchungsphase,
- kontrollierten Wechsel `.untersuchen → .priorisieren`,
- wiederverwendbare räumliche Interaktionsgrundlage (Modul 007),
- noch keine Prioritätsziele oder Teamstationen.

F-06 und F-07 sind implementiert. Die tatsächliche Laufzeitabnahme von AK-06 und AK-07 steht aus.  
F-10 ist generisch-interaktionsseitig implementiert; fachlich vollständig erst nach Modul 009.  
F-14/AK-14 bleiben teilweise offen (keine finalen Blender-Monster).

---

## Repository- und Dokumentationsstruktur

```text
Ticket-Tamer/
├─ Ticket_Tamer/
│  ├─ Ticket_Tamer.xcodeproj/
│  │  └─ project.pbxproj
│  ├─ Ticket_Tamer/
│  │  ├─ App/
│  │  │  └─ Ticket_TamerApp.swift
│  │  ├─ Assets/
│  │  │  └─ MonsterAssetProvider.swift
│  │  ├─ Components/                          ← NEU Modul 007
│  │  │  └─ DropTargetComponent.swift
│  │  ├─ Data/
│  │  │  └─ LocalTicketCatalog.swift
│  │  ├─ Debug/
│  │  │  └─ DebugManager.swift
│  │  ├─ Models/
│  │  │  ├─ GamePhase.swift
│  │  │  ├─ SessionModel.swift
│  │  │  └─ Ticket.swift
│  │  ├─ Resources/
│  │  │  └─ Localizable.xcstrings
│  │  ├─ Services/                            ← NEU Modul 007
│  │  │  ├─ DropEvaluator.swift
│  │  │  └─ MonsterInteractionConfigurator.swift
│  │  ├─ Support/
│  │  │  └─ AppConstants.swift
│  │  ├─ Views/
│  │  │  ├─ Debug/                            ← NEU Modul 007 (#if DEBUG)
│  │  │  │  └─ DebugInteractionHarnessView.swift
│  │  │  ├─ InvestigationView.swift
│  │  │  ├─ RootVolumeView.swift
│  │  │  └─ StartView.swift
│  │  ├─ Assets.xcassets
│  │  └─ Info.plist
│  ├─ Ticket_TamerTests/
│  │  └─ Ticket_TamerTests.swift
│  ├─ Packages/
│  │  └─ RealityKitContent/
│  │     ├─ README.md
│  │     ├─ Package.swift
│  │     ├─ Package.realitycomposerpro
│  │     └─ Sources/
│  │        └─ RealityKitContent/
│  │           ├─ RealityKitContent.swift
│  │           └─ RealityKitContent.rkassets/
│  │              ├─ Scene.usda
│  │              ├─ monster01.usda
│  │              ├─ monster02.usda
│  │              ├─ monster03.usda
│  │              ├─ monster04.usda
│  │              └─ Materials/
│  │                 └─ GridMaterial.usda
│  └─ Products/
│     ├─ Ticket_Tamer.app
│     └─ Ticket_TamerTests.xctest
│
└─ Dokumentation/
   ├─ 00_Projektsteuerung/
   │  ├─ Start-Prompt-Projektlogbuch.md
   │  └─ Code-im-Projektraum.md
   ├─ 01_Kontext/
   │  ├─ Projektbeschreibung.md
   │  ├─ SPEC.md
   │  └─ Akzeptanzkriterien.md
   ├─ 02_Vorlagen/
   │  ├─ Projektlogbuch-Vorlage.md
   │  ├─ Projekt-Stand-Vorlage.md
   │  ├─ Modul-Eingangsprompt-Vorlage.md
   │  ├─ Modul-Report-Vorlage.md
   │  └─ DebugManager.swift
   ├─ 03_Modul-Eingangsprompts/
   │  ├─ 001-Eingangsprompt.md
   │  ├─ 002-Eingangsprompt.md
   │  ├─ 003-Eingangsprompt.md
   │  ├─ 004-Eingangsprompt.md
   │  ├─ 005-Eingangsprompt.md
   │  ├─ 006-Eingangsprompt.md
   │  └─ 007-Eingangsprompt.md
   ├─ 04_Modul-Reports/
   │  ├─ 001-Report.md
   │  ├─ 002-Report.md
   │  ├─ 003-Report.md
   │  ├─ 004-Report.md
   │  ├─ 005-Report.md
   │  ├─ 006-Report.md
   │  └─ 007-Report.md
   └─ 05_Aktueller-Stand/
      ├─ Logbuch-Stand.md
      └─ Projekt-Stand.md
```

---

## Dateien und Zweck

| Datei | Zweck | Status | Seit Modul |
|---|---|---|---|
| `App/Ticket_TamerApp.swift` | App-Einstieg, volumetrische Scene, SessionModel-Besitz; `DropTargetComponent.registerComponent()` | ergänzt | 001/004/007 |
| `Views/RootVolumeView.swift` | Phasenabhängige Root-Darstellung; `#if DEBUG` Harness für `.priorisieren` | ergänzt | 001/004/006/007 |
| `Views/StartView.swift` | Deutsche Startansicht | unverändert | 004 |
| `Views/InvestigationView.swift` | Ticket-Monster, Ticketkarte, Weiter-Schaltfläche — keine Gameplay-Drag-Interaktion | unverändert | 006 |
| `Views/Debug/DebugInteractionHarnessView.swift` | DEBUG-only Interaktionstest; nur in `.priorisieren` im Debug-Build | neu | 007 |
| `Components/DropTargetComponent.swift` | Generischer Drop-Zielbereich ohne Prioritäts-/Teamwerte | neu | 007 |
| `Services/MonsterInteractionConfigurator.swift` | Konfiguriert Monster für `dragDrop` / `inspectionOnly` | neu | 007 |
| `Services/DropEvaluator.swift` | Sphärische Proximity-Prüfung gültig/ungültig | neu | 007 |
| `Models/SessionModel.swift` | Sitzungszustand; `lockInput()`, `unlockInput()` hinzugefügt | ergänzt | 003/006/007 |
| `Models/GamePhase.swift` | Spielphasen | unverändert | 003 |
| `Models/Ticket.swift` | Ticketmodell inkl. Referenzdaten | unverändert | 002/005 |
| `Data/LocalTicketCatalog.swift` | Zwölf lokale Tickets | unverändert | 002/005/006 |
| `Assets/MonsterAssetProvider.swift` | Lokales asynchrones Monsterladen | unverändert | 005 |
| `Support/AppConstants.swift` | Constants; `InteractionConstants` hinzugefügt | ergänzt | 001/005/006/007 |
| `Debug/DebugManager.swift` | Kategorisiertes Logging | unverändert | 001 |
| `Resources/Localizable.xcstrings` | Deutsche UI-Strings | unverändert | 001/004/006 |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | Tests 001–007; `InteractionFoundationTests` (19 neue) | ergänzt auf 64 | 001–007 |
| `.../monster01.usda` | USDA-Kugel Platzhalter | unverändert | 005 |
| `.../monster02.usda` | USDA-Kugel Platzhalter | unverändert | 005 |
| `.../monster03.usda` | USDA-Kugel Platzhalter | unverändert | 005 |
| `.../monster04.usda` | USDA-Kugel Platzhalter | unverändert | 005 |

---

## Root-Phasenrouting

```text
RootVolumeView
├─ .start
│  └─ StartView
├─ .untersuchen
│  └─ InvestigationView
├─ .priorisieren
│  ├─ #if DEBUG → DebugInteractionHarnessView     ← NEU Modul 007
│  └─ #else     → sessionPlaceholderView
└─ .teamZuordnen / .ergebnis
   └─ sessionPlaceholderView
```

---

## Räumliche Interaktionsgrundlage (Modul 007)

### Gewählte API

`DragGesture().targetedToAnyEntity()` — nicht `ManipulationComponent`. Begründung: expliziter `.onEnded`-Callback für genau-einmal Drop-Auswertung.

### Interaktionskonfiguration

| Komponente | Wert |
|---|---|
| `InputTargetComponent.allowedInputTypes` | `.indirect` (Blick + Pinch) |
| `CollisionComponent` | Kugel, r = 0.10 m |
| `HoverEffectComponent` | natives Hover-Feedback |
| Erlaubte Manipulation | Translation only |

### Drop-Ziel-Abstraktion

`DropTargetComponent` — id, radius, debugName. Keine Fachlichkeit. Registrierung via `registerComponent()` in `App.init()`.

### Lock-Semantik

`lockInput()`: No-Op wenn bereits gesperrt → verhindert Mehrfachauswertung. `unlockInput()`: für Modul 008/009. Beide: kein Einfluss auf Score, Phase, Priorität, Team.

### Ausgangsposition

Einmalig nach Monster-Load gespeichert. Kein Drift über wiederholte Drops. Rückkehr-Animation: 0.3 s `easeInOut`.

### DEBUG-Harness

Datei: `Views/Debug/DebugInteractionHarnessView.swift`  
Testziel: ID `testTargetA`, x = +0.25 m, r = 0.15 m  
Schutz: `#if DEBUG` in `RootVolumeView` — nie im Release-Build sichtbar.

---

## Neue Schnittstellen aus Modul 007

| Schnittstelle | Datei | Semantik |
|---|---|---|
| `DropTargetComponent(id:radius:debugName:)` | `Components/` | Entity als Drop-Ziel markieren |
| `MonsterInteractionConfigurator.configure(_:mode:)` | `Services/` | Interaktionsmodus setzen |
| `DropEvaluator.evaluate(entity:targets:)` | `Services/` | Entity-basierte Auswertung |
| `DropEvaluator.evaluate(entityPosition:targets:)` | `Services/` | Positions-basierte Auswertung (unit-testbar) |
| `DropEvaluator.TargetDescriptor` | `Services/` | Descriptor für Tests ohne RealityKit-Szene |
| `SessionModel.lockInput()` | `Models/` | Input genau einmal sperren |
| `SessionModel.unlockInput()` | `Models/` | Input für nächsten Phasenaufbau freigeben |
| `MonsterInteractionMode` | `Services/` | `.dragDrop` / `.inspectionOnly` |
| `InteractionConstants` | `Support/` | Radien und Animationsdauer |

---

## Bestehende Monster-Schnittstellen

| Schnittstelle | Zweck |
|---|---|
| `Ticket.monsterAssetId` | ID des zugeordneten Monsters |
| `AssetKeys.Monster.allIDs` | bekannte Monster-IDs |
| `MonsterAssetProvider.loadMonster(assetID:)` | lokale RealityKit-Entity laden |
| `MonsterAssetProvider.LoadError` | typisierte Fehler |

---

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | Finales eigenes Blender-Modell |
|---|---|---|
| `monster01` | USDA-Kugel | fehlt |
| `monster02` | USDA-Kugel | fehlt |
| `monster03` | USDA-Kugel | fehlt |
| `monster04` | USDA-Kugel | fehlt |

---

## Teststand

| Bereich | Stand |
|---|---|
| Testdeklarationen vor 007 | 45 |
| neue `InteractionFoundationTests` | 19 |
| **Quellstand nach 007** | **64** |
| Tatsächlicher Testlauf | nicht nachgewiesen |
| Build | nicht nachgewiesen |
| Simulator | nicht nachgewiesen |

---

## F-10 / AK-10 — Interaktionsstatus

| Teil | Stand |
|---|---|
| Monster fokussierbar (Hover/Blick) | konfiguriert, Simulator-Nachweis offen |
| Pinch greift Monster | konfiguriert, Simulator-Nachweis offen |
| Räumliche Translation | konfiguriert, Simulator-Nachweis offen |
| Ungültiger Drop → kein Zustandswechsel | implementiert |
| Ungültiger Drop → Rückkehr zur Ausgangsposition | implementiert |
| Gültiger Drop → genau einmal akzeptiert | implementiert |
| Gültiger Drop → `isInputLocked = true` | implementiert |
| Weitere Eingaben nach Lock ignoriert | implementiert |
| Score unverändert durch Interaktionsgrundlage | implementiert |
| Phase unverändert durch Interaktionsgrundlage | implementiert |
| `selectedPriority` unverändert | implementiert |
| `selectedTeam` unverändert | implementiert |
| Fachliche Prioritätsentscheidung | **folgt Modul 008** |
| Fachliche Teamentscheidung | **folgt Modul 009** |

---

## DebugManager

- `.lifecycle`: Untersuchungsansicht, App-Init
- `.input`: Weiter-Schaltfläche, Drag-Start/-Ende, Lock-Ignorierung, Konfigurationsmodus
- `.physics`: Drop-Auswertung valid/invalid, Ziel-ID
- `.state`: Phasenwechsel, Lock gesetzt/ignoriert/freigegeben
- `.spawning`: Monsterprovider, DEBUG-Harness Ziel-Entity
- keine neue Kategorie

---

## Für Modul 008 relevante Ausgangslage

Vorhanden:

- `MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)` — sofort verwendbar
- `DropTargetComponent` — für konkrete Prioritätsziele nutzen
- `DropEvaluator.evaluate(entity:targets:)` — im `onEnded`-Handler aufrufen
- `SessionModel.lockInput()` / `unlockInput()` — nach akzeptiertem Drop / beim Phasenaufbau
- `DragGesture().targetedToAnyEntity()` — in `PrioritizationView`-`RealityView` einbinden
- DEBUG-Harness zeigt, wie das Gesture-Wiring aufgebaut ist

Noch nicht vorhanden:

- `selectedPriority` speichern,
- konkrete beschriftete Prioritätsziele,
- Punkte,
- 1,5-Sekunden-Übergang,
- Ergebnisansicht.

---

## Offene Punkte

- Modul-007-Commit/Hash fehlt (manuell committen).
- Build, Simulatorlauf und Testausführung nach 007 fehlen.
- AK-01, AK-06 und AK-07 sind noch manuell nachzuprüfen.
- AK-10 ist generisch implementiert; fachliche Prüfung nach Modul 008/009.
- Finale vier Blender-Monster fehlen.
- `.DS_Store`-Bereinigung bleibt offen.
