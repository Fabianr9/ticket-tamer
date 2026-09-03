# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 023 für Version 1.2.

**Projektversion:** v1.2 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**Stand:** nach Modul `023` — Teamstation-Symbole  
**Eingearbeitet am:** 2026-09-03  
**Branch laut 023-Report:** `A`  
**HEAD vor Modul 023:** `3c0b2fb feat: Modul 22`  
**Modul-022-Commit:** `3c0b2fb`  
**Modul-023-Commit:** offen  
**Testdeklarationen vor 023:** 313  
**Neue Tests:** 20  
**Testdeklarationen nach 023:** **333**  
**Build/Test/Simulator nach 023:** offen

## v1.2-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 021 | Replay-Layoutstabilisierung | F-25 / AK-25 | implementiert; Laufzeitabnahme OPEN |
| 022 | Punktekommunikation v1.2 | F-26, F-27 / AK-26, AK-27 | implementiert; Commit `3c0b2fb`; Laufzeitabnahme OPEN |
| 023 | Teamstation-Symbole | F-28 / AK-28 | implementiert; statisch geprüft; Laufzeitabnahme OPEN; Commit offen |
| 024 | Debug-UI-Isolation | F-29 / AK-29 | als Nächstes |
| 025 | Monster-Farbvarianten | F-30 / AK-30 | offen |
| 026 | Integration und Abnahme v1.2 | AK-25 bis AK-30 | offen |

## Eingearbeiteter Stand Modul 023

### Bestehende Teamstationsarchitektur

- `TeamTargetMapping` definiert stabile IDs, `SupportTeam`-Mapping und 2×2-Raster.
- `TargetPanelLayout.resolve` berechnet Größe und Position aus realer Volume-/Monster-Geometrie.
- `TargetPanelFactory` erzeugt die RealityKit-Panelbox.
- Dieselbe Panelgröße bildet die `halfExtents` der `DropTargetComponent`.
- `TeamAssignmentView` hängt die sichtbare SwiftUI-Beschriftung als `ViewAttachmentEntity` vor die Box.
- `DropEvaluator` wertet davon unabhängig die `DropTargetComponent` aus.

Modul 023 verändert ausschließlich die sichtbare Attachment-Präsentation.

## Finale Symbolzuordnung

| Team | Text | SF Symbol |
|---|---|---|
| Netzwerk | `Netzwerk` | `network` |
| Konto | `Konto` | `person.crop.circle` |
| Software | `Software` | `macwindow` |
| Hardware | `Hardware` | `desktopcomputer` |

Die deutschen Teamtexte bleiben vollständig sichtbar.

Die Farbe ist nur ergänzend; jede Station kann über Text plus Symbol erkannt werden.

## Accessibility

Das Symbol wird für Accessibility verborgen.

Das kombinierte Teamziel liest weiterhin den vollständigen Teamnamen vor.

Keine zusätzliche Lokalisierung war erforderlich, weil bestehende `SupportTeam.displayName`-Texte wiederverwendet werden.

## Geometrieschutz

Für die im Report verwendete Referenzgeometrie:

- Volume: `0.8 × 0.75 × 0.38 m`
- Monsterhülle: `0.13 m` je Achse

bleiben vor/nach Modul 023:

| Wert | Vorher | Nachher |
|---|---:|---:|
| Panelbreite | `0.195 m` | `0.195 m` |
| Panelhöhe | `0.117 m` | `0.117 m` |
| Paneltiefe | `0.020 m` | `0.020 m` |
| Drop-Bounds | `center ± panelSize / 2` | identisch |

Referenzzentren:

- Netzwerk: `(-0.1075, 0.1600, -0.0850) m`
- Konto: `(0.1075, 0.1600, -0.0850) m`
- Software: `(-0.1075, 0.0230, -0.0850) m`
- Hardware: `(0.1075, 0.0230, -0.0850) m`

Unverändert:

- `TargetPanelLayout`
- `TargetPanelFactory`
- `DropTargetComponent`
- `DropEvaluator`
- `minimumDropOverlapRatio = 0.50`
- `dropDepthTolerance = 0.05 m`

## Dateien Modul 023

Geändert:

- `Views/TeamAssignmentView.swift`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Neu/aktualisiert:

- `Dokumentation/04_Modul-Reports/023-Report.md`

Keine Änderung am String Catalog erforderlich.

## Teststand

| Kennzahl | Stand |
|---|---:|
| Tests vor 023 | 313 |
| neue Tests | 20 |
| Tests nach 023 | **333** |
| statische Scope-Prüfung | PASS |
| `git diff --check` Moduldateien | PASS |
| vollständiger Xcode-Lauf | OPEN |

Neue Tests sichern:

- vier konkrete Symbolnamen,
- Nichtleere/Eindeutigkeit,
- vier deutsche Texte,
- vier stabilen Target-IDs,
- unveränderte Panelmaße,
- unveränderte Drop-Bounds,
- unveränderte 50-%-Schwelle,
- fachlich neutrale Präsentation.

## AK-28

Code-/statisch erfüllt:

- vier Symbole vorhanden,
- vier Texte bleiben,
- Farbe nicht alleinige Bedeutung,
- Panel-/Drop-Geometrie unverändert,
- 50-%-Overlap unverändert.

Noch offen:

- Xcode-Build,
- vollständige 333 Tests,
- Sichtbarkeit/Lesbarkeit im Simulator,
- Betrachtungswinkel frontal/links/rechts/oben,
- Drag auf alle vier Teams,
- ungültiger Drop/Snapback,
- Replay-/Punktekommunikations-Regression.

**AK-28 = OPEN bis visueller/gestischer Laufzeitabnahme.**

## Geschützter Bestand für Modul 024

Nicht verändern:

- `TeamTargetMapping.Presentation`
- Symbolnamen
- Team-Attachments
- Panelgrößen
- Drop-Bounds
- `TargetPanelLayout`
- `DropEvaluator`
- 50-%-Overlap

## Offene Punkte vor Modul 024

- [ ] Modul 023 bauen
- [ ] vollständige 333 Tests
- [ ] alle vier Symbole visuell prüfen
- [ ] Text-Clipping prüfen
- [ ] Drag auf alle vier Teamziele
- [ ] Snapback prüfen
- [ ] Replay-Regression 021
- [ ] Punktekommunikation 022
- [ ] Modul 023 separat committen

## Nächster Schritt

`024-Eingangsprompt.md` ausführen.

Modul 024 bearbeitet ausschließlich F-29 / AK-29:

- `🔧 Team [DEV]` aus dem normalen App-Flow entfernen,
- auch im regulären Debug-Build nicht anzeigen,
- Release ebenfalls ohne DEV-Schaltfläche,
- Entwicklerfunktion ausschließlich im separaten `DebugInteractionHarnessView` oder explizit aktiviertem Debug-Kontext erhalten,
- Priorisierungs- und Teamlogik unverändert lassen.
