# Modul-Report — 007 Räumliche Interaktionsgrundlagen

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

---

## Zusammenfassung

Modul 007 liefert die wiederverwendbare räumliche Interaktionsgrundlage für das Ticket-Monster: `MonsterInteractionConfigurator` konfiguriert eine Monster-Entity für Blickfokus, Pinch und räumliches Bewegen; `DropEvaluator` bewertet Drops positions­basiert (gültig/ungültig) ohne jede fachliche Entscheidung; `DropTargetComponent` markiert generische Zielbereiche ohne Prioritäts- oder Teambezeichnungen; `SessionModel` erhält `lockInput()` und `unlockInput()` für die genau-einmal-Eingabesperre. Ein DEBUG-only Interaktions-Testharness (`DebugInteractionHarnessView`) aktiviert die Interaktion manuell prüfbar in der `.priorisieren`-Phase — im Release-Build nicht sichtbar.

---

## Vorab-Check

| Punkt | Ergebnis |
|---|---|
| Branch | `main` |
| Commit vor Modul 007 | `243c56c feat: add docs` |
| Modul-006-Commit | `177e2b9 feat: Modul006` |
| `98cd95d fix:import error` enthalten | ✓ ja |
| Build nach Modul 006 | nicht nachgewiesen (Xcode/`xcodebuild` im Ausführungsumfeld nicht verfügbar) |
| Simulatorstart nach Modul 006 | nicht nachgewiesen |
| Testausführung nach Modul 006 | nicht nachgewiesen |
| Testdeklarationen im Quellstand vor 007 | 45 |
| Testdeklarationen nach 007 | 64 |
| AK-01 / AK-06 / AK-07 Laufzeitnachweise | weiterhin offen |
| Monster-Asset-Status | 4 × USDA-Kugel (Platzhalter), keine finalen Blender-Monster |

---

## Technische Interaktionsentscheidung

**Gewählte API:** `DragGesture().targetedToAnyEntity()` (Gesture-basiertes Drag) — **nicht** `ManipulationComponent`.

**Begründung:**
`ManipulationComponent` abstrahiert den Release-Moment zu stark; für die Drop-Semantik (genau ein akzeptierter Drop, ungültig = Rückkehr, Input-Lock) ist ein expliziter `.onEnded`-Callback erforderlich. Das Gesture-Targeting über `InputTargetComponent` und `CollisionComponent` ist in visionOS 26 vollständig unterstützt und gibt volle Kontrolle über Drag-Start, -Verlauf und Loslassen.

**Keine eigene Handtracking-/ARKit-Pipeline:** Ausschließlich indirekte Eingabe (Blick + Pinch) über `allowedInputTypes: .indirect`.

| Komponente | Konfiguration |
|---|---|
| `InputTargetComponent` | `allowedInputTypes: .indirect` |
| `CollisionComponent` | Kugel, `radius = InteractionConstants.monsterCollisionRadius` (0.10 m) |
| `HoverEffectComponent` | natives visionOS Hover-/Fokus-Feedback |
| Erlaubte Manipulation | **nur Translation** (Drag-Gesture bewegt Position); Rotation und Skalierung werden durch die Gesture-Implementierung nicht verändert |

---

## Drop-Grundlage

### Generischer Zieltyp (`DropTargetComponent`)

```swift
struct DropTargetComponent: Component {
    let id: String          // fachlich neutrale ID, z. B. „testTargetA"
    let radius: Float       // Trefferradius in Metern
    let debugName: String?  // nur für Logging
}
```

Enthält keine Prioritäts- oder Teamwerte. Module 008 und 009 erweitern ihre Ziele mit dieser Komponente.

### Koordinaten- und Kollisionsstrategie

Sphärische Proximity-Prüfung im Weltkoordinatensystem:

```
distance(entityWorldPos, targetWorldPos) ≤ target.radius → gültig
```

Kein Bildschirmkoordinaten-Hack. Bei mehreren gleichzeitig getroffenen Zielen gewinnt das räumlich nächste. Überschneidungen werden konstruktiv verhindert: In Modul 008 und 009 sind Zielbereiche mit ausreichend Abstand zu platzieren.

### Ausgangsposition

Einmalig nach dem Monster-Load gesetzt (`originTransform = entity.transform`). Kein Drift über mehrfache ungültige Drops. Kein Einfluss auf Ticketindex, Phase oder Score.

### Rücksetzverhalten (ungültig)

```swift
entity.move(to: originTransform, relativeTo: nil,
            duration: InteractionConstants.monsterReturnDuration,  // 0.3 s
            timingFunction: .easeInOut)
```

### Valid/Invalid-Semantik

| Szenario | Ergebnis |
|---|---|
| Loslassen außerhalb aller Zielbereiche | Rückkehr zur Ausgangsposition, kein Zustandswechsel |
| Loslassen innerhalb eines Zielbereichs | Drop genau einmal akzeptiert, `isInputLocked = true` |

---

## Input-Lock

### Neue SessionModel-Schnittstellen

```swift
func lockInput()    // No-Op wenn bereits true — verhindert Mehrfachauswertung
func unlockInput()  // für Modul 008/009 beim Aufbau des nächsten Tickets
```

Beide Methoden verändern weder `score` noch `currentPhase` noch `selectedPriority` noch `selectedTeam`.

### Genau-einmal-Semantik

Der Gesture-Handler prüft `model.isInputLocked` am Anfang jedes `.onChanged`- und `.onEnded`-Callbacks:

```swift
guard !model.isInputLocked else { return }
```

Szenarien die abgedeckt sind:
- Mehrfaches Pinchen nach akzeptiertem Drop → ignoriert
- Erneutes Loslassen → ignoriert
- Neue Drag-Geste während Lock → ignoriert
- Zwei schnelle aufeinanderfolgende Release-Ereignisse → zweites ignoriert

### Unlock / Reset

`unlockInput()` setzt `isInputLocked = false` für den nächsten Phasenaufbau in Modul 008/009. `reset()` setzt ebenfalls auf `false` (bestehende Implementierung, unverändert).

**Bestätigung:** Weder Score, noch `selectedPriority`, noch `selectedTeam` werden durch die Interaktionsgrundlage verändert.

---

## DEBUG-/Simulator-Harness

**Datei:** `Ticket_Tamer/Views/Debug/DebugInteractionHarnessView.swift`

**Sichtbarkeit:** Nur `#if DEBUG`. Erscheint in der `.priorisieren`-Phase (nach „Weiter zur Priorisierung"). Im Release-Build zeigt die `.priorisieren`-Phase weiterhin den neutralen `sessionPlaceholderView`.

**Neutrales Testziel:**
- ID: `testTargetA`
- Position: x = +0.25 m, y = 0, z = 0
- Radius: 0.15 m (= `InteractionConstants.dropTargetRadius`)
- Keine Prioritäts- oder Teambezeichnung

**Monster-Position (Startposition):** x = −0.15 m, y = 0, z = 0

**Verbleib:** Diese Datei bleibt in Modul 007 erhalten. In Modul 008 wird `RootVolumeView.case .priorisieren` durch die echte Priorisierungsansicht ersetzt; der `#if DEBUG`-Ast entfällt dann.

**Simulatorprüfung:** `xcodebuild` steht im Ausführungsumfeld nicht zur Verfügung. Die manuelle Prüfung der Gesteninteraktion (Hover, Pinch, Drag, Drop) muss nach dem Commit im visionOS-Simulator oder Gerät erfolgen.

Zu prüfende Szenarien:
- [ ] Monster zeigt Focus-/Hover-Reaktion beim Ansehen
- [ ] Pinch greift das Monster
- [ ] Monster lässt sich räumlich bewegen
- [ ] Loslassen außerhalb → Rückkehr zur Ausgangsposition, kein Session-Zustandswechsel
- [ ] Loslassen im blauen Zielbereich → genau ein akzeptiertes Drop-Ereignis
- [ ] `isInputLocked` wird `true` (DEBUG-Kopfzeile zeigt „✓ Drop akzeptiert")
- [ ] Erneutes Greifen/Drag nach Lock → wirkungslos
- [ ] „Lock zurücksetzen"-Button → `isInputLocked` wieder `false`, Monster kehrt zurück
- [ ] Kein Score, keine Phasenänderung, keine Prioritäts-/Teamentscheidung

---

## Änderungen je Datei

| Datei (mit Ordner) | Art | Target | Zweck | Bezug |
|---|---|---|---|---|
| `Components/DropTargetComponent.swift` | neu | Ticket_Tamer | Generischer Drop-Zielbereich ohne Fachlichkeit | F-10 / AK-10 |
| `Services/MonsterInteractionConfigurator.swift` | neu | Ticket_Tamer | Input/Collision/Hover-Konfiguration je Modus | F-10 / AK-10 |
| `Services/DropEvaluator.swift` | neu | Ticket_Tamer | Sphärische Proximity-Prüfung gültig/ungültig | F-10 / AK-10 |
| `Views/Debug/DebugInteractionHarnessView.swift` | neu (#if DEBUG) | Ticket_Tamer | Interaktionstestzone für Modul 007 | F-10 / AK-10 |
| `Models/SessionModel.swift` | ergänzt | Ticket_Tamer | `lockInput()`, `unlockInput()` | F-10 / AK-10 |
| `Support/AppConstants.swift` | ergänzt | Ticket_Tamer | `InteractionConstants` (Radien, Dauer) | F-10 / AK-10 |
| `App/Ticket_TamerApp.swift` | ergänzt | Ticket_Tamer | `DropTargetComponent.registerComponent()` | RealityKit-Registrierung |
| `Views/RootVolumeView.swift` | ergänzt | Ticket_Tamer | `#if DEBUG` Harness für `.priorisieren` | Simulatorprüfung |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | Ticket_TamerTests | `InteractionFoundationTests` (19 neue Tests) | AK-10 |

---

## Tests

| Bereich | Stand |
|---|---|
| Testdeklarationen vor Modul 007 | 45 |
| Neue Tests in `InteractionFoundationTests` | 19 |
| **Testdeklarationen nach Modul 007** | **64** |
| Tatsächlicher Testlauf | nicht nachgewiesen (`xcodebuild` nicht verfügbar) |
| Manuelle Gestenprüfung im Simulator | ausstehend |

### Geprüfte Unit-Bereiche (ohne Simulator)

- Input-Lock startet `false`
- `lockInput()` setzt Lock auf `true`
- Zweites `lockInput()` während Lock ist No-Op
- `lockInput()` verändert weder Score noch Phase noch Priorität noch Team
- `unlockInput()` entsperrt die Eingabe
- `unlockInput()` aus entsperrtem Zustand ist stabil
- `reset()` setzt `isInputLocked` auf `false`
- `DropEvaluator`: Treffer innerhalb Radius → gültig
- `DropEvaluator`: Treffer auf Randpunkt (= radius) → gültig
- `DropEvaluator`: Außerhalb Radius → `nil`
- `DropEvaluator`: Leere Zielliste → `nil`
- `DropEvaluator`: Mehrere Ziele → nächstes gewinnt
- Generische Ziel-IDs enthalten keine verbotenen Fachbegriffe
- `DropTargetComponent` speichert Felder unveränderlich
- `DropTargetComponent`-Standardradius entspricht `InteractionConstants`

---

## Status AK-10 (getrennt nach Schicht)

| Schicht | Status |
|---|---|
| Generische Interaktionssemantik (Drag, Drop, Lock, Rücksetzung) | implementiert |
| Fachliche Prioritätsentscheidung (`selectedPriority`) | **nicht in Modul 007** — folgt Modul 008 |
| Fachliche Teamentscheidung (`selectedTeam`) | **nicht in Modul 007** — folgt Modul 009 |

AK-10 ist generisch-interaktionsseitig implementiert; fachlich vollständig erst nach Modul 009.

**Bestätigung:** Keine Prioritätsziele (`Normal`, `Wichtig`, `Kritisch`) und keine Teamstationen (`Netzwerk`, `Konto`, `Software`, `Hardware`) wurden implementiert.

---

## Bereitgestellte Schnittstellen (für Folgemodule)

| Schnittstelle | Datei | Semantik |
|---|---|---|
| `DropTargetComponent(id:radius:debugName:)` | `Components/` | Entity als generisches Drop-Ziel markieren |
| `MonsterInteractionConfigurator.configure(_:mode:)` | `Services/` | Monster für `.dragDrop` oder `.inspectionOnly` einrichten |
| `DropEvaluator.evaluate(entity:targets:)` | `Services/` | Entity-basierte Drop-Auswertung im Gesture-Handler |
| `DropEvaluator.evaluate(entityPosition:targets:)` | `Services/` | Positions-basierte Drop-Auswertung (testbar ohne Szene) |
| `SessionModel.lockInput()` | `Models/` | Eingabe einmalig sperren |
| `SessionModel.unlockInput()` | `Models/` | Eingabe für nächsten Phasenaufbau freigeben |
| `MonsterInteractionMode` | `Services/` | `.dragDrop` / `.inspectionOnly` |
| `InteractionConstants` | `Support/` | `monsterCollisionRadius`, `dropTargetRadius`, `monsterReturnDuration` |

---

## DebugManager

- Ergänzte Kategorien: keine neuen — vorhandene ausreichend
- `.input`: Drag-Start / Drag-Changed / Release ignoriert wegen Lock / Modus-Konfiguration
- `.physics`: Drop-Auswertung (valid/invalid, Ziel-ID)
- `.state`: Lock gesetzt / ignoriert / freigegeben / Modus-Konfiguration
- `.spawning`: Monster-Load und Ziel-Entity-Erstellung im DEBUG-Harness
- Geloggt werden ausschließlich Entity-/Ziel-ID, valid/invalid und Lock-Zustand — keine vollständigen Tickettexte

---

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | Finales eigenes Blender-Modell |
|---|---|---|
| `monster01` | USDA-Kugel (Platzhalter) | fehlt |
| `monster02` | USDA-Kugel (Platzhalter) | fehlt |
| `monster03` | USDA-Kugel (Platzhalter) | fehlt |
| `monster04` | USDA-Kugel (Platzhalter) | fehlt |

F-14 / AK-14 bleiben teilweise offen. Für die technische Interaktionsprüfung in Modul 007 sind die USDA-Kugeln ausreichend.

---

## Annahmen / offene Punkte / Risiken

- `DragGesture().targetedToAnyEntity()` ist visionOS 26-kompatibel; die exakten `location3D`-Werte und die Treffergenauigkeit sind im Simulator zu validieren.
- `entity.move(to:relativeTo:duration:timingFunction:)` setzt die Rückkehranimation; falls die API in visionOS 26 abweicht, ist ein direktes `entity.position = origin.translation` als Fallback.
- `.git/index.lock` konnte im Sandbox-Umfeld nicht entfernt werden — der Git-Commit muss **manuell** im Mac-Terminal ausgeführt werden: `git add -A && git commit -m "007: Räumliche Interaktionsgrundlagen"`
- Build, Testlauf und Simulatorstart nach Modul 006 sind weiterhin nicht nachgewiesen.
- AK-01 / AK-06 / AK-07 sind noch manuell nachzuprüfen.
- `.DS_Store`-Bereinigung ist kein Teil dieses Moduls.

---

## Git

- Commit-Nachricht: `007: Räumliche Interaktionsgrundlagen`
- Hash: offen (Commit manuell im Mac-Terminal ausführen, siehe Risiken)

## Stand aktualisiert

- [x] `Projekt-Stand.md` neu erzeugt und im Projektraum ersetzt.
- [x] `Logbuch-Stand.md` — Eintrag für Modul 007 hinzuzufügen (Verantwortung: Projektlogbuch).
- [ ] Umbenannte/gelöschte Dateien: keine.

---

## Empfehlung für das nächste Modul

**Modul 008 — Priorisierungsphase** kann direkt auf dieser Grundlage aufbauen:

1. `MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)` aktivieren.
2. Drei Ziel-Entities mit `DropTargetComponent(id: "prio_normal")`, `(id: "prio_wichtig")`, `(id: "prio_kritisch")` platzieren.
3. Im `onEnded`-Handler von Modul 008: `DropEvaluator.evaluate(entity:targets:)` aufrufen, den zurückgegebenen ID-String auf `selectedPriority` mappen, `model.lockInput()` aufrufen.
4. `DebugInteractionHarnessView` und den `#if DEBUG`-Ast in `RootVolumeView.case .priorisieren` durch die echte `PrioritizationView` ersetzen.

Bevor Modul 008 beginnt: Build, vollständigen Testlauf (64 Testdeklarationen) und Simulatorstart durchführen und dokumentieren.
