# Modul-Report — 013 Integration und Gerätetest

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

---

## Zusammenfassung

Modul 013 hat die finale Monster-Asset-Integration (Phase 3 / F-14) vollständig durchgeführt: Alle vier echten Blender-USDC-Exporte wurden in das RealityKitContent-Bundle eingepflegt und die Kugel-Platzhalter ersetzt.

Anschließend wurde die räumliche Drag-&-Drop-Interaktion (F-08 / F-09 / F-10) in mehreren Schritten überarbeitet. Auslöser waren drei aufeinander aufbauende Befunde aus der Simulator-Abnahme: das Monster wurde an den Volume-Rändern abgeschnitten, die Zielflächen waren flach und ihre Trefferlogik zu großzügig, und die Drop-Erkennung scheiterte anschließend an zwei Geometriefehlern. Gemeinsamer Nenner aller drei Befunde: **die Interaktionsgeometrie beruhte auf angenommenen statt gemessenen Werten.**

Die Lösung ersetzt sämtliche Annahmen durch Laufzeitmessung (tatsächliches Volume, tatsächliche Monster-Bounds je Asset), stellt die Zielflächen als flache 3D-Panels dar, prüft den Drop über die Flächenüberlappung von Monster und Panel plus Z-Nähe, und gibt dem Nutzer während des Ziehens ein dezentes Highlight.

Offene Punkte: AK-06/07 (Untersuchungsansicht / Weiter-Button), Build- und Testlauf nach den letzten Änderungen, Gerätetest.

---

## 1. Vorab-Check

### Git
- Branch: `main`
- Aktueller Commit vor Modul 013: `b94e0ed feat: add docs modul 11`
  *(Stand Modul 011; Modul 012 ohne Codeänderung übersprungen)*
- Modul-011-Commit: `209aff2 feat:Modul011` — vorhanden ✓
- Working Tree: Modul-013-Änderungen staged/committed nach diesem Report

### Xcode / SDK
- Xcode-Version und visionOS-SDK-Version: **manuell prüfen**
- Deployment Target: visionOS 26.5
- Simulator: Apple Vision Pro, visionOS 26.5 (23O470)

### Build
- **PASS** — Build in Xcode erfolgreich (Stand nach Fix 5, bestätigt 2026-08-27).
- **Nach Fix 8 noch nicht erneut gebaut** — siehe Abschnitt 8.

### Tatsächliche Testzahl
- Gezählte `@Test`-Deklarationen im Quellcode: **208** (vorher 155; +53 aus der Interaktionsüberarbeitung)
- Davon in der neuen Suite `Modul 013 — Zielpanels und 50-%-Drop`: **34**
- Testlauf: **nicht ausgeführt** in der Modul-Chat-Umgebung (kein Xcode verfügbar); manuell nachzuholen

---

## 2. Finale Asset-Prüfung

### Monster-Inventar im Monster-Ordner (vor Integration)

| Datei | Format | Größe |
|---|---|---|
| Monster_1_blue.usdc | USDC (USD Crate) | 146 KB |
| Monster_1_green.usdc | USDC | 146 KB |
| Monster_1_pink.usdc | USDC | 146 KB |
| Monster_1_red.usdc | USDC | 146 KB |
| Monster_2_blue.usdc | USDC | 242 KB |
| Monster_2_green.usdc | USDC | 242 KB |
| Monster_2_pink.usdc | USDC | 242 KB |
| Monster_2_red.usdc | USDC | 242 KB |
| Monster_3_blue.usdc | USDC | 437 KB |
| Monster_3_green.usdc | USDC | 437 KB |
| Monster_3_pink.usdc | USDC | 437 KB |
| Monster_3_yellow.usdc | USDC | 437 KB |
| Monster_4_blue.usdc | USDC | 1,1 MB |
| Monster_4_green.usdc | USDC | 1,1 MB |
| Monster_4_pink.usdc | USDC | 1,1 MB |
| Monster_4_red.usdc | USDC | 1,1 MB |

**Fazit:** Vier echte Monster-Typen vorhanden, je 3–4 Farbvarianten. Kein `.blend` im Ordner, aber USDC ist RealityKit-kompatibel und direkt verwendbar.

### Integrationsstatus F-14 — nach Modul 013

| Asset-ID | USDC-Datei (Farbwahl) | Begründung |
|---|---|---|
| monster01 | Monster_1_blue.usdc | visuell eindeutig; neutral |
| monster02 | Monster_2_green.usdc | visuell eindeutig; neutral |
| monster03 | Monster_3_yellow.usdc | einzig verfügbare Nicht-Blau/Grün-Farbe für Monster 3 |
| monster04 | Monster_4_red.usdc | visuell eindeutig; neutral |

Die Farbwahl codiert **keine** Team- oder Prioritätsinformation. Das `monsterAssetId`-Mapping in `LocalTicketCatalog` ist **unverändert**.

Die USDA-Wrapper verweisen via USD-`references` auf die USDC-Dateien:
```usda
def Xform "Root" (
    references = @Monster_1_blue.usdc@
)
```

F-14 / AK-14: **PASS (Sim)** — Monster in beiden Zieh-Phasen sichtbar, korrekt ausgerichtet und einheitlich eingepasst.

### Gemessene Abmessungen der vier Assets

Nach `MonsterAssetProvider.fit(toMaxExtent: 0.13)`, in Szenen-Metern. Alle vier Exporte sind in der Datei auf 1.0 Einheiten Höhe normiert, deshalb ist die Höhe nach der Einpassung bei allen identisch:

| Asset | Breite | Höhe | Tiefe |
|---|---|---|---|
| monster01 blau | 0.070 | 0.130 | 0.073 |
| monster02 grün | 0.045 | 0.130 | 0.052 |
| monster03 gelb | 0.098 | 0.130 | 0.091 |
| monster04 rot | 0.070 | 0.130 | 0.088 |

Quelle: USDC-Extents; monster04 zusätzlich aus dem Laufzeit-Trace bestätigt (0.070 × 0.130 × 0.088).

---

## 3. AK-Matrix F-01 bis F-16

| Feature | AK | Implementiert | Code-Nachweis | Simulator | Gerät | Status |
|---|---|---|---|---|---|---|
| F-01 Start | AK-01 | ✓ | StartView, SessionModel | PASS | OFFEN | **PASS** (Sim) |
| F-02 Volume | AK-02 | ✓ | Ticket_TamerApp (volumetric) | PASS | OFFEN | **PASS** (Sim) |
| F-03 Tickets | AK-03 | ✓ | LocalTicketCatalog (12 Tickets) | PASS | OFFEN | **PASS** (Sim) |
| F-04 Sitzung | AK-04 | ✓ | SessionModel.startSession | PASS | OFFEN | **PASS** (Sim) |
| F-05 Monster-ID | AK-05 | ✓ | monsterAssetId in jedem Ticket | PASS | OFFEN | **PASS** (Sim) |
| F-06 Untersuchung | AK-06 | ✓ | InvestigationView | OPEN | OFFEN | **OPEN** |
| F-07 Weiter | AK-07 | ✓ | beginPrioritizationPhase() | OPEN | OFFEN | **OPEN** |
| F-08 Priorisierung | AK-08 | ✓ | PrioritizationView, savePriority | PASS* | OFFEN | **PASS** (Sim, Nachtest nach Fix 8 offen) |
| F-09 Team | AK-09 | ✓ | TeamAssignmentView, saveTeam | PASS* | OFFEN | **PASS** (Sim, Nachtest nach Fix 8 offen) |
| F-10 Gesten | AK-10 | ✓ | MonsterInteractionConfigurator, PlanarDrag, DragBounds | PASS | OFFEN | **PASS** (Sim) |
| F-11 Bewertung | AK-11 | ✓ | evaluatePriority/evaluateTeam | PASS | OFFEN | **PASS** (Sim) |
| F-12 Audio | AK-12 | ✓ | AudioService, correct/incorrect.wav | PASS* | OFFEN | **PASS** (correct.wav; incorrect.wav ungeprüft) |
| F-13 Transition | AK-13 | ✓ | feedbackTransitionDelay 1.5s | PASS | OFFEN | **PASS** (Sim) |
| F-14 Monster | AK-14 | ✓ | USDC-Assets integriert | PASS | OFFEN | **PASS** (Sim, Screenshot) |
| F-15 Ergebnis | AK-15 | ✓ | ResultView (Score + Neustart) | PASS | OFFEN | **PASS** (Sim) |
| F-16 Reset | AK-16 | ✓ | SessionModel.reset() | PASS | OFFEN | **PASS** (Sim) |

*AK-08/09: Drag & Drop funktionierte im Simulator zuletzt für Priorisierung und Teamzuordnung. Fix 8 (Panelhöhe) ist danach eingeflossen und noch nicht nachgetestet.
*AK-12: `incorrect.wav` noch nicht explizit verifiziert.

**Noch offen:** AK-06, AK-07, `incorrect.wav` (AK-12), Nachtest AK-08/09 nach Fix 8, Apple Vision Pro Gerätetest.

---

## 4. Vorgenommene Fixes

### Fix 0: Blender Z-up → Y-up Korrektur (MonsterAssetProvider)

| Datei | Art | Wirkung |
|---|---|---|
| `MonsterAssetProvider.swift` | geändert | `applyBlenderCorrection`: -90° um X-Achse nach jedem Laden |

Ursache: Blender exportiert USDC mit `upAxis = Z`, RealityKit verwendet Y-up. Ohne Korrektur lagen Monster flach im XZ-Raum — unsichtbar von vorne.

### Fix 1: RealityView Dependency-Tracking (PrioritizationView + TeamAssignmentView)

| Datei | Art | Wirkung |
|---|---|---|
| `PrioritizationView.swift` | geändert | `update:`-Closure: direkte State-Reads statt Methodenaufruf |
| `TeamAssignmentView.swift` | geändert | identischer Fix |

Ursache: SwiftUI verfolgt nur direkte Lesezugriffe auf `@State` im `update:`-Closure. Indirekter Zugriff via Methode verhinderte Re-Render nach asynchronem Monster-Load.

### Fix 2: Asset-Fix: Monster-Integration (F-14 / AK-14)

| Datei | Art | Wirkung |
|---|---|---|
| `RealityKitContent.rkassets/Monster_1_blue.usdc` | neu (kopiert) | Echtes Blender-Monster 1 im Bundle |
| `RealityKitContent.rkassets/Monster_2_green.usdc` | neu (kopiert) | Echtes Blender-Monster 2 im Bundle |
| `RealityKitContent.rkassets/Monster_3_yellow.usdc` | neu (kopiert) | Echtes Blender-Monster 3 im Bundle |
| `RealityKitContent.rkassets/Monster_4_red.usdc` | neu (kopiert) | Echtes Blender-Monster 4 im Bundle |
| `RealityKitContent.rkassets/monster01.usda` … `monster04.usda` | geändert | Kugel-Platzhalter → USD-Referenz auf die USDC-Datei |

---

### Fix 3: Clipping am Volume-Rand — gemessene statt angenommene Grenzen

**Symptom:** Das Monster ließ sich bis an die Volume-Grenzen ziehen und wurde dabei angeschnitten. Kopf, Beine und Seiten verschwanden, obwohl der Ursprung noch im Volume lag.

**Ursache:** Jede Grenze im System war geraten:

- `LayoutConstants.centralVolumeWidth/Height/Depth` beschreibt nur die `defaultSize` des Fensters, nicht die tatsächliche Größe zur Laufzeit,
- `LayoutConstants.monsterDragDropTargetSize` ist das **Nennmaß** der Einpassung und beschreibt nur die größte Kante, nicht die Ausdehnung je Seite,
- `LayoutConstants.layoutPointsPerMeter` (417) war per Augenmaß gegen eine Volume-Höhe kalibriert, die sich seither geändert hatte.

Zusätzlich waren Zieh-Begrenzung und Drop-Erkennung nicht getrennt: `evaluateColumn` bzw. `evaluateNearest` teilten die gesamte erreichbare Fläche unter den Zielen auf, sodass jede Ablage jenseits einer Mindestbewegung zwangsläufig ein Ziel traf.

**Lösung:** Alle drei Annahmen durch **eine** Messung ersetzt:

```swift
GeometryReader3D { proxy in
    RealityView { content, _ in
        let volume = content.convert(proxy.frame(in: .local), from: .local, to: .scene)
    }
}
```

Daraus und aus den je Asset gemessenen Monster-Bounds folgt der erlaubte Bereich der Root-Position:

```text
safeMin = volumeMin − monsterMin + padding
safeMax = volumeMax − monsterMax − padding
```

Achsenweise, alle vier Ränder, asymmetriefest. Rein mathematisch — keine Entity, keine Geometrie, keine UI.

| Datei | Art | Wirkung |
|---|---|---|
| `Services/VolumeMetrics.swift` | **neu** | Misst Volume und Layoutebene; affine Abbildung Punkte ↔ Meter |
| `Services/DragBounds.swift` | **neu** | Sicherer Root-Bereich aus Volume minus Monsterhülle minus Padding |
| `Services/MonsterDragGeometry.swift` | **neu** | Zentrale Geometriequelle beider Zieh-Phasen |
| `Services/PlanarDrag.swift` | geändert | `requestedPosition(from:translation:)` — Wunschposition ohne Begrenzung |
| `Assets/MonsterAssetProvider.swift` | geändert | `localVisualBounds(of:)` — Bounds relativ zum Root, inkl. Scale und Rotation |
| `Support/AppConstants.swift` | geändert | `dragSafetyPadding` |

`PrioritizationConstants.monsterCeiling(...)` wird von den Views nicht mehr verwendet — sie hielt das Monster unterhalb der Label-Zeile und hätte die Ziele unerreichbar gemacht. Die Konstante bleibt für die bestehenden Tests erhalten.

---

### Fix 4: Flache 3D-Zielpanels, 50-%-Regel, Z-Nähe, Hover-Feedback

**Symptom:** Die Zieloptionen waren SwiftUI-2D-Labels ohne räumliche Wirkung. Ein Drop galt bereits bei rund 10 % sichtbarer Überlappung als gültig.

**Ursache der zu großzügigen Erkennung:** Die Ratio bezog sich auf die **kleinere** der beiden Flächen. Die Label-Pille war mit ≈ 0.08 × 0.03 m viel kleiner als das Monster (0.13 × 0.13 m), also war der Nenner praktisch immer die Zielfläche. Ein schmaler Monsterstreifen, der die Pille überdeckte, ergab bereits eine hohe Ratio.

**Lösung:**

1. **Zielflächen als flache 3D-Panels.** `ModelEntity` mit `generateBox(width:height:depth:cornerRadius:)`, Tiefe 0.02 m, halbtransparentes `SimpleMaterial`. Der Text sitzt als RealityView-Attachment 6 mm vor der Vorderfläche — kein Z-Fighting, kein im Mesh versenkter Text. Die SwiftUI-Label-Zeilen sind entfallen, sonst stünde jedes Ziel zweimal da.
2. **Ratio bezogen auf die Monsterfläche:** `intersectionArea / projizierte Monsterfläche`, Schwelle 0.50. Der Wert bedeutet damit das, was man sieht: *wie viel vom Monster liegt auf dem Ziel?*
3. **Perspektivunabhängig:** beide Boxen liegen achsenparallel in Szenen-Koordinaten, die Projektion ist eine reine X/Y-Projektion in diesem festen Raum. Es gibt keine Kameraprojektion im Rechenweg.
4. **Z-Nähe** als Spaltmaß zwischen den Oberflächen, nicht als Mittelpunktsabstand:
   `gap = max(0, max(aMinZ, bMinZ) − min(aMaxZ, bMaxZ))`, Toleranz 0.05 m.
5. **Hover-Feedback:** Während des Ziehens wird dieselbe Auswertung wie beim Loslassen benutzt; das gültige Panel wird dezent hervorgehoben (Deckkraft 0.55 → 0.9, Scale 1.05, 0.12 s Überblendung). Das Highlight sagt ausschließlich *„wenn du jetzt loslässt, wird dieses Ziel gewählt"* — keine Aussage über richtig oder falsch. Gespeichert wird ausschließlich in `onEnded`.
6. **Deckungsgleichheit:** Mesh und `DropTargetComponent.halfExtents` entstehen aus **derselben** Größe. Eine unsichtbare, nach innen verschobene Trefferfläche kann konstruktiv nicht mehr entstehen.

| Datei | Art | Wirkung |
|---|---|---|
| `Services/TargetPanelLayout.swift` | **neu** | Raster einer Phase gegen das gemessene Volume ausgerechnet |
| `Services/TargetPanelFactory.swift` | **neu** | Aufbau, Bemaßung und Hervorhebung der Panels |
| `Services/DropEvaluator.swift` | geändert | `overlapRatio`, `depthGap`, `evaluateTargets`, `bestTarget` |
| `Components/DropTargetComponent.swift` | geändert | `halfExtents` statt reinem Radius |
| `Views/PrioritizationView.swift` | geändert | Panels + Attachments + Highlight statt Label-Zeile |
| `Views/TeamAssignmentView.swift` | geändert | identisch |
| `Views/Components/TargetFrameReporter.swift` | **entfernt** | wurde durch das Panelraster abgelöst |

Die alten Verfahren `evaluate`, `evaluateColumn` und `evaluateNearest` bleiben in `DropEvaluator` erhalten (Tests), werden von den Views aber nicht mehr benutzt.

**Anordnung unverändert:** `Normal | Wichtig | Kritisch` nebeneinander oben, Team als 2×2 in den Ecken. Die Panel-Außenkanten liegen bündig am Volume-Rand — das Panel wird nach innen größer, kein Ziel wandert zur Mitte.

---

### Fix 5: Konstanten-Verortung (Build-Fehler)

Beim Einfügen waren die Panel-Konstanten in `InteractionConstants` statt in `LayoutConstants` gelandet — fünf Compilerfehler in `TargetPanelFactory`. Verschoben; seither gilt:

- `LayoutConstants`: alle `targetPanel*`, `targetHighlight*`, `targetLabelStandoff`
- `InteractionConstants`: `minimumDropOverlapRatio`, `dropDepthTolerance`, `dragSafetyPadding`

---

### Fix 6: Teamphase — Panel-Tiefe aus der tatsächlichen Zieh-Ebene

**Symptom:** In der Priorisierung funktionierten Drops, in der Teamzuordnung nicht — bei allen vier Zielen, ohne Highlight.

**Ursache:** Die Panel-Tiefe wurde aus der Phasenkonstante `monsterStartPosition.z` abgeleitet (Priorisierung 0.06, Team 0.00). Die tatsächliche Monster-Tiefe beim Ziehen ist aber der von `DragBounds` **geklemmte** Wert — `PlanarDrag` behält zwar `start.z`, der Clamp wirkt jedoch auf alle drei Achsen. Liegt der gemessene Z-Bereich des Volumes nicht symmetrisch um den Wunschwert, driften Panel und Monster in der Tiefe auseinander:

```text
Volume-Z [0, 0.4] · Monster-Z beim Ziehen 0.085

Priorisierung  Panel-Z aus 0.06  →  Z-Spalt 0.035  ≤ 0.05  →  gültig
Team           Panel-Z aus 0.00  →  Z-Spalt 0.095  >  0.05  →  ungültig
```

Die 6 cm Unterschied in der Startposition waren exakt der Unterschied zwischen „gerade noch innerhalb der Toleranz" und „außerhalb". Der Overlap lag in beiden Fällen bei 0.90 — es scheiterte allein an `isDepthValid`.

**Lösung:** `MonsterDragGeometry.effectiveMonsterPlaneZ` führt den Wunschwert durch dieselbe Klemmung wie die Zieh-Bewegung; die Panels werden aus diesem Wert platziert. Das Panel steht dadurch per Konstruktion immer genau `targetPanelStandoff` (0.01 m) hinter der Ebene, die das Monster erreichen kann.

Drei begleitende Härtungen in `TargetPanelLayout`:

- Randabstand explizit `dragSafetyPadding` statt `targetPanelGap` — beide sind 0.02, stimmten also nur zufällig überein. Jetzt fällt die Panelkante per Konstruktion mit der Monsterkante am Anschlag zusammen.
- Mindesthöhe, die die Erreichbarkeit der Schwelle garantiert, auch wenn ein Panel schmaler als das Monster ist.
- Das Panel rutscht nie hinter die Rückwand des Volumes.

| Datei | Art |
|---|---|
| `Services/MonsterDragGeometry.swift` | geändert |
| `Services/TargetPanelLayout.swift` | geändert |
| `Support/AppConstants.swift` | geändert (`targetPanelReachabilityHeadroom`) |

---

### Fix 7: DROP-DEBUG-Trace

Reine Instrumentierung, keine Logikänderung. `MonsterDragGeometry.logDropTrace(...)` liefert Protokoll **und** Entscheidung aus einer Funktion — die Ausgabe kann dadurch nicht von dem abweichen, was tatsächlich entschieden wird.

Ausgabe je Loslassen, Kategorie `.physics`:

```text
=== DROP DEBUG ===
View / Monster world transform / Monster local transform / Monster bounds
Projection plane / axes / Zieh-Ebene Z: gewuenscht … tatsaechlich …
--- Target: <id>
    Target bounds / Monster relevant area / Target area / Intersection area
    Overlap ratio | Required overlap ratio | overlapValid
    Depth distance | Depth tolerance | Depth valid
    Geometry valid
Current valid target before release / during release
Input locked / Decision already committed / Result
=== /DROP DEBUG ===
```

Beim Aufbau zusätzlich je Ziel `Maximum reachable overlap` samt Klartext-Begründung, falls die Schwelle geometrisch nicht erreichbar ist. Genau diese Zeile hat Fix 8 aufgedeckt.

Mitschnitt:

```bash
xcrun simctl spawn booted log stream --level debug \
  --predicate 'subsystem == "de.th-owl.fb2.Ticket-Tamer"' > drop-debug.txt
```

---

### Fix 8: Panelhöhe — Erreichbarkeit schlägt die gestalterische Kappung

**Symptom:** Drops wurden trotz sichtbarer Überlappung nicht angenommen; zuerst nur beim roten Monster bemerkt.

**Ursache — aus dem Trace zurückgerechnet:** Das tatsächlich gemessene Volume ist **0.284 × 0.236 × 0.235 m**, nicht die deklarierten 1.0 × 1.0 × 0.4 m. Das Monster ist mit 0.130 m damit **55 % der Volume-Höhe**. Die gestalterische Kappung `targetPanelMaximumHeightFraction = 0.28` ergab:

```text
0.28 × 0.236 m = 0.066 m Panelhöhe   gegen   0.130 m Monsterhöhe
maximal erreichbar: 0.066/0.130 × xr ≈ 0.49   —   unter der Schwelle 0.50
```

Der Drop konnte nie gültig werden, unabhängig davon, wie weit gezogen wurde. Der Trace zeigte exakt das: `Overlap ratio: 0.494`, `Depth valid: true`, `Geometry valid: false`.

**Es war kein Asset-Problem.** Rechnerisch waren in der Priorisierung alle Assets betroffen; nur das schmalste kam knapp darüber:

| Asset | Breite | max. Overlap vorher | | nachher |
|---|---|---|---|---|
| monster01 blau | 0.070 | 0.492 | ✗ | **0.650** |
| monster02 grün | 0.045 | 0.508 | ✓ knapp | **0.650** |
| monster03 gelb | 0.098 | 0.352 | ✗ | **0.650** |
| monster04 rot | 0.070 | 0.494 | ✗ | **0.650** |

In der Teamphase lagen alle bei 0.508 — gerade eben über der Schwelle, weshalb Team zu funktionieren schien.

**Lösung:** Zwei Obergrenzen mit unterschiedlichem Gewicht statt einer.

- **gestalterisch** (`0.28 × Volume-Höhe`) — darf überschritten werden, wenn die Erreichbarkeit es verlangt
- **geometrisch** (Reihen dürfen sich nicht überlappen, nichts ragt aus dem Volume) — schlägt alles

```swift
panelHeight = min( max(styledHeight, requiredHeight), hardMaxHeight )
```

Kein geänderter Schwellenwert, keine vergrößerte unsichtbare Trefferfläche, keine verschobenen Ziele, kein verkleinertes Monster, Sicherheitsrand unangetastet. Sichtbares Panel und DropTarget wachsen gemeinsam — es ist dieselbe Box. Die Panels werden dadurch rund 30 % höher (bei monster03 mehr, weil die Höhe die schmalere Spalte ausgleicht).

Die erreichten 0.650 sind kein Zufall: `minimumDropOverlapRatio + targetPanelReachabilityHeadroom`. Die Schwelle wird damit spürbar **vor** dem Anschlag der Zieh-Begrenzung erreicht.

| Datei | Art |
|---|---|
| `Services/TargetPanelLayout.swift` | geändert (eine Berechnung) |

---

## 5. Interaktionsarchitektur nach Modul 013

### Datenfluss

```text
GeometryReader3D + RealityView  →  VolumeMetrics       →  tatsächliches Volume in Metern
MonsterAssetProvider.fit(...)   →  localVisualBounds   →  Monster-Bounds je Asset
        ↓ beides vorhanden
                                   DragBounds          →  sicherer Root-Bereich   (Ziehen)
                                   TargetPanelLayout   →  Panelgröße + Positionen (Darstellung)
                                   DropEvaluator       →  Overlap + Z-Nähe        (Entscheidung)
```

### Drei strikt getrennte Aufgaben

| Aufgabe | Zuständig | Frage |
|---|---|---|
| Zieh-Grenzen | `DragBounds` | Wo darf sich das Monster bewegen, ohne abgeschnitten zu werden? |
| Darstellung | `TargetPanelLayout` + `TargetPanelFactory` | Wo stehen die sichtbaren Panels und wie groß sind sie? |
| Drop-Erkennung | `DropEvaluator` | Liegt das Monster zu ≥ 50 % auf einem Panel und ist es in Z nah genug? |

Darstellung und Drop-Erkennung teilen sich dieselbe Box. Die Zieh-Grenzen sind davon unabhängig: der sichere Bereich darf ein Panelzentrum unerreichbar machen, weil die Drop-Erkennung nicht nach Zentren, sondern nach Flächen fragt.

`MonsterDragGeometry` ist die einzige Stelle, an der die drei zusammenlaufen. Beide Views unterscheiden sich nur noch in Raster, Ziel-IDs, Farben und fachlichem Mapping — es gibt keine zweite, abweichende Rechnung.

### Zentrale Konstanten

| Konstante | Wert | Bedeutung |
|---|---|---|
| `InteractionConstants.minimumDropOverlapRatio` | 0.50 | Mindestanteil der Monsterfläche auf der Zielzone |
| `InteractionConstants.dropDepthTolerance` | 0.05 m | größter erlaubter Z-Spalt zwischen Oberflächen |
| `InteractionConstants.dragSafetyPadding` | 0.02 m | unsichtbarer Rand zur Volume-Kante |
| `LayoutConstants.targetPanelDepth` | 0.02 m | Paneltiefe |
| `LayoutConstants.targetPanelGap` | 0.02 m | Abstand zwischen Panels |
| `LayoutConstants.targetPanelHeightFactor` | 0.9 | Panelhöhe als Vielfaches der Monsterhöhe |
| `LayoutConstants.targetPanelReachabilityHeadroom` | 0.15 | Reserve über der Schwelle bei der Bemaßung |
| `LayoutConstants.targetPanelMaximumHeightFraction` | 0.28 | gestalterische Obergrenze (nachrangig) |
| `LayoutConstants.targetPanelStandoff` | 0.01 m | freier Abstand Monsterrückseite ↔ Panelvorderseite |
| `LayoutConstants.targetHighlightScale` | 1.05 | Hervorhebung |

---

## 6. Gemessene Werte aus dem Simulator

Aus dem Trace vom 27.08.2026, Apple Vision Pro Simulator, visionOS 26.5:

| Größe | Wert |
|---|---|
| Volume (gemessen) | 0.284 × 0.236 × 0.235 m |
| Volume (deklariert in `defaultSize`) | 1.0 × 1.0 × 0.4 m |
| Monster monster04 | 0.070 × 0.130 × 0.088 m |
| Sicherer Zieh-Bereich | X ±0.087, Y ±0.033, Z 0.064 … 0.171 |
| Zieh-Ebene Z | gewünscht 0.060, tatsächlich 0.064 |
| Panelhöhe vor Fix 8 | 0.066 m |
| Z-Spalt Monster ↔ Panel | 0.000 m |

**Wichtig für Folgemodule:** `LayoutConstants.centralVolumeWidth/Height/Depth` beschreibt **nicht**, was zur Laufzeit gemessen wird. Die Konstanten steuern nur `defaultSize` und dürfen nicht mehr als Rechengrundlage für Geometrie verwendet werden.

---

## 7. Testabdeckung der Interaktion

Neue Suite `Modul 013 — Zielpanels und 50-%-Drop`, 34 Tests, ohne SwiftUI und ohne laufenden RealityKit-Render-Loop — `VolumeMetrics`, `DragBounds`, `TargetPanelLayout` und `DropEvaluator` arbeiten mit reinen Werten.

Abgedeckt:

- sicherer Bereich hält symmetrische und asymmetrische Monster im Volume, alle vier Ränder und Ecken
- entartete Fälle (Monster größer als Volume, unbrauchbare Messung)
- Punkt-↔-Meter-Abbildung inklusive Y-Spiegelung
- Panelraster: Reihenfolge, Randbündigkeit, Flachheit, Höhenableitung, zwei Reihen ohne Überlappung
- 50-%-Kurve: 10 % / 25 % / knapp darunter → ungültig; knapp darüber / Anschlag → gültig
- Schwelle liegt dort, wo das Monster halb auf dem Panel liegt
- Ablage zwischen zwei Panels und im Freiraum → ungültig
- höchstens ein Ziel gleichzeitig gültig (Rasterabtastung der gesamten erreichbaren Fläche)
- Z-Prüfung: Oberflächenabstand statt Mittelpunktsabstand; zu weit vorne → ungültig trotz perfekter Fläche
- Regression Fix 6: nicht zentrierter Z-Bereich, Panel aus Konstante scheitert, Panel aus geklemmter Ebene gelingt
- Regression Fix 8: **gemessenes Volume 0.284 × 0.236 m mit allen vier Assets in beiden Phasen** — jedes Ziel erreichbar, kein Clipping
- Erreichbarkeit schlägt die gestalterische Höhenbegrenzung

Nicht durch Unit-Tests abgedeckt und nur im Simulator prüfbar: Attachment-Darstellung, Highlight-Animation, Snapback-Animation, Exactly-once-Kette, Audio, Transition.

---

## 8. Was manuell noch zu tun ist

### Priorität 1 — Build und Test nach Fix 8

- [ ] Xcode: Build für visionOS-Simulator
- [ ] Product → Test (⌘U), Ziel: Ticket_TamerTests
- [ ] Erwartung: **208** Tests, alle PASS
- [ ] Ergebnis in Abschnitt 9 nachtragen

### Priorität 2 — Nachtest Drag & Drop (AK-08 / AK-09)

Je Ziel schrittweise hineinziehen:

**Priorisierung** — Normal / Wichtig / Kritisch:
- [ ] ca. 10 % Überlappung → kein Highlight, Loslassen → Snapback
- [ ] ca. 25 % → kein Highlight, Snapback
- [ ] knapp unter 50 % → kein Highlight, Snapback
- [ ] ≥ 50 % → Panel wird dezent hervorgehoben
- [ ] Loslassen → korrektes Ziel gespeichert

**Teamzuordnung** — Netzwerk / Konto / Software / Hardware: gleiche Prüfung.

**Alle vier Assets:** monster01, monster02, monster03, monster04 — insbesondere, ob der erreichte Overlap zwischen den Assets stark schwankt. Sollwert laut Rechnung: 0.650 bei jedem Asset und jedem Ziel.

### Priorität 3 — Regressionen

- [ ] **Clipping:** maximal ziehen nach links, rechts, oben, unten und in alle vier Ecken — Monster bleibt jederzeit vollständig sichtbar
- [ ] **Snapback:** ungültiger Drop → exakt ursprünglicher Transform, keine Scale-Änderung, keine Rotation, kein Drift
- [ ] **Exactly-once:** gültiger Drop → Auswahl, Lock, Bewertung und Audio je genau einmal, Transition ca. 1,5 s
- [ ] **Blickwinkel:** Panels frontal, leicht links, leicht rechts, leicht von oben betrachten — Darstellung räumlich verständlich, Text lesbar, Drop-Auswertung identisch

### Priorität 4 — Offene AK

- [ ] **AK-06/07:** Ticketkarte vollständig, kein Team/Priorität sichtbar, „Weiter"-Button
- [ ] **AK-12:** `incorrect.wav` hörbar, genau einmal
- [ ] **Stabilität (Phase 17):** 12-Ticket-Sitzung, schnelle Gesten, keine Crashes

### Priorität 5 — Apple Vision Pro Gerätetest (Phase 16)

- [ ] Falls Gerät verfügbar: Build für Gerät, alle AK wiederholen
- [ ] Falls kein Gerät: als offenes Abgabe-Risiko vermerken

### Priorität 6 — Aufräumen

- [ ] `_abgeloest/TargetFrameReporter.swift` löschen (durch das Panelraster abgelöst)
- [ ] `.git/index.lock.stale-bitte-loeschen` löschen (Überbleibsel eines abgebrochenen Git-Aufrufs)

### Priorität 7 — Git-Commit

```
git add .
git commit -m "013: Integration, Zielpanels und Drop-Erkennung"
```

---

## 9. Teststand-Nachweis (nachzutragen nach manuellem Lauf)

| Kennzahl | Soll | Ist |
|---|---|---|
| Testdeklarationen | 208 | — |
| davon Suite „Modul 013 — Zielpanels und 50-%-Drop" | 34 | — |
| Passed | 208 | — |
| Failed | 0 | — |
| Skipped | 0 | — |
| Laufzeit | — | — |
| Plattform | visionOS Simulator | — |

---

## 10. Pflicht-Abnahmematrix

| Feature | AK | PASS / FAIL / OPEN |
|---|---|---|
| F-01 Startansicht | AK-01 | **PASS** (Sim) |
| F-02 Zentrales Volume | AK-02 | **PASS** (Sim) |
| F-03 12 lokale Tickets | AK-03 | **PASS** (Sim) |
| F-04 Sitzungsauswahl | AK-04 | **PASS** (Sim) |
| F-05 Monster-Asset-ID | AK-05 | **PASS** (Sim) |
| F-06 Untersuchungsansicht | AK-06 | **OPEN** |
| F-07 Weiter zur Priorisierung | AK-07 | **OPEN** |
| F-08 Priorisierungsphase | AK-08 | **PASS** (Sim; Nachtest nach Fix 8 offen) |
| F-09 Teamzuordnungsphase | AK-09 | **PASS** (Sim; Nachtest nach Fix 8 offen) |
| F-10 Gesten-Interaktion | AK-10 | **PASS** (Sim) |
| F-11 Bewertung | AK-11 | **PASS** (Sim) |
| F-12 Audiofeedback | AK-12 | **PASS** (correct.wav; incorrect.wav ungeprüft) |
| F-13 1,5-s-Transition | AK-13 | **PASS** (Sim) |
| F-14 Monster-Assets (Blender) | AK-14 | **PASS** (Sim, Screenshot bestätigt) |
| F-15 Ergebnisansicht | AK-15 | **PASS** (Sim) |
| F-16 Reset / Neustart | AK-16 | **PASS** (Sim) |

---

## 11. Verbleibende offene Punkte

1. **Build und Testlauf nach Fix 8** stehen aus. Die Geometrie ist numerisch gegen die Logwerte verifiziert, ein Compiler hat den letzten Stand aber nicht gesehen.
2. **Latenter Frame-Versatz in Z.** Die Debugzeile `Raumprobe` zeigt `local=0.06 → world=0.178`, also 0.118 m Versatz zwischen lokalem und Weltraum. Volume-Grenzen kommen aus `.scene`, Entity-Positionen sind lokal. In X/Y stimmen beide überein (Versatz 0), in Z nicht. Aktuell hebt es sich auf, weil Panel-Z und Clamp aus derselben Quelle stammen (`Depth distance: 0.000`), ist aber eine Falle für spätere Änderungen. Eigener, kleiner Fix.
3. **Monstergröße relativ zum Volume.** `monsterDragDropTargetSize = 0.13` wurde für ein 1-m-Volume gewählt. Im tatsächlichen Volume (0.236 m Höhe) sind das 55 % — der eigentliche Auslöser der engen Verhältnisse. Falls mehr Spielraum gewünscht ist, ist das der Hebel, nicht die Schwelle.
4. **AK-06 / AK-07** unverändert offen.
5. **`incorrect.wav`** nicht explizit verifiziert.
6. **Gerätetest** auf Apple Vision Pro offen.

---

## Git

- Commit vorgesehen: `013: Integration, Zielpanels und Drop-Erkennung`
- Hash: nach manuellem Build und Commit nachtragen

---

## Stand aktualisiert

- [ ] `Projekt-Stand.md` neu erzeugt und ersetzt
- [ ] `Logbuch-Stand.md` aktualisiert
- [ ] Neue Swift-Dateien: `VolumeMetrics`, `DragBounds`, `MonsterDragGeometry`, `TargetPanelLayout`, `TargetPanelFactory`
- [ ] Entfernte Swift-Datei: `Views/Components/TargetFrameReporter.swift` (liegt in `_abgeloest/`)

---

## Empfehlung für das nächste Modul

Nach Build, Testlauf und dem Nachtest von AK-08/AK-09: **Modul 014 — Abschlussdokumentation und Cleanup**.

Vorher innerhalb 013 zu erledigen: die offenen AK-06/AK-07, `incorrect.wav` und — falls im Nachtest auffällig — der Z-Frame-Versatz aus Abschnitt 11.
