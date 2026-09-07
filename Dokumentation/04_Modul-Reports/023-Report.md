# Modul-Report — 023 Teamstation-Symbole

## 1. Vorab-Check

| Punkt | Ergebnis |
|---|---|
| Branch | `A` |
| HEAD vor Modul 023 | `3c0b2fb feat: Modul 22` |
| tatsächlicher Modul-022-Commit | `3c0b2fb` |
| Working Tree vor 023 | zwei geänderte Stand-Dokumente und ungetrackter `023-Eingangsprompt.md`; als vorbereitete Nutzerdaten unangetastet |
| Testdeklarationen vor 023 | 313 |
| Build/Test/Simulator | Apple-/Xcode-/visionOS-Toolchain in dieser Umgebung nicht vorhanden; Laufzeitprüfung OPEN |

Modul 022 war bereits separat committet. Seine Implementierung wurde nicht mit Modul 023 vermischt.

## 2. Bestehende Teamstationsarchitektur

- `TeamTargetMapping` definiert die vier stabilen IDs, das `SupportTeam`-Mapping und das 2×2-Raster.
- `TargetPanelLayout.resolve` berechnet Panelgröße und Positionen dynamisch aus Volume und Monsterhülle.
- `TargetPanelFactory` erzeugt pro Ziel eine flache RealityKit-Box. Dieselbe Panelgröße setzt die `halfExtents` der `DropTargetComponent`.
- `TeamAssignmentView` hängt die sichtbare SwiftUI-Beschriftung als `ViewAttachmentEntity` vor die Box.
- `DropEvaluator` wertet unabhängig vom Attachment die Bounds der `DropTargetComponent` mit 50 % Mindestüberlappung und bestehender Z-Toleranz aus.

Die Moduländerung liegt ausschließlich in der Präsentation des Attachments. Panelmesh, Layout, Komponenten, IDs und Drop-Auswertung wurden nicht geändert.

## 3. Symbolentscheidung

| Team | Text | Symbol | Begründung |
|---|---|---|---|
| Netzwerk | Netzwerk | `network` | etabliertes Verbindungs-/Netzwerksymbol |
| Konto | Konto | `person.crop.circle` | eindeutig personenbezogene Kontodarstellung |
| Software | Software | `macwindow` | klar erkennbare App-/Fensterdarstellung |
| Hardware | Hardware | `desktopcomputer` | eindeutig physisches Computergerät |

Die vier SF Symbols sind semantisch verschieden und benötigen keine zusätzlichen Bildassets. Alle vier deutschen Texte bleiben sichtbar. Die bestehende Farbe ist nur ergänzend; jede Station ist bereits über Text und Symbol identifizierbar.

## 4. Geometrieschutz

Die Werte bleiben dynamisch von gemessenem Volume und Monster abhängig. Für die in den neuen Tests verwendete Referenzgeometrie (`0,8 × 0,75 × 0,38 m`, Monsterhülle `0,13 m` je Achse) gilt:

| Wert | vorher | nachher |
|---|---:|---:|
| Panelbreite | `0,195 m` | `0,195 m` |
| Panelhöhe | `0,117 m` | `0,117 m` |
| Paneltiefe | `0,020 m` | `0,020 m` |
| Drop-Bounds | `center ± panelSize / 2` | `center ± panelSize / 2` |

Die vier Zentren bleiben bei dieser Referenz:

- Netzwerk: `(-0,1075; 0,1600; -0,0850) m`
- Konto: `(0,1075; 0,1600; -0,0850) m`
- Software: `(-0,1075; 0,0230; -0,0850) m`
- Hardware: `(0,1075; 0,0230; -0,0850) m`

`TargetPanelLayout`, `TargetPanelFactory`, `DropTargetComponent` und `DropEvaluator` sind unverändert. `minimumDropOverlapRatio` bleibt `0.50`, `dropDepthTolerance` bleibt `0.05 m`.

## 5. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Views/TeamAssignmentView.swift` | Code | reine `Presentation` aus deutschem Titel und SF-Symbol; horizontales Symbol/Text-Label; sinnvoller Accessibility-Name | F-28 / AK-28 |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | Tests | 20 Tests für Symbole, Texte, IDs, Geometrie, Bounds und 50-%-Schwelle | AK-28 |
| `Dokumentation/04_Modul-Reports/023-Report.md` | Dokumentation | tatsächlicher Stand, Entscheidungen, Schutzwerte und Abnahmestatus | Modul 023 |

Keine Lokalisierungsänderung war nötig, da die bestehenden `SupportTeam.displayName`-Texte weiterverwendet werden. Das Symbol ist für Accessibility verborgen; das kombinierte Element liest weiterhin den vollständigen Teamnamen vor.

## 6. Tests

| Kennzahl | Ergebnis |
|---|---:|
| vorher | 313 Testdeklarationen |
| neu | 20 Testdeklarationen |
| nachher | 333 Testdeklarationen |
| statische Scope-Prüfung | PASS |
| `git diff --check` für Moduldateien | PASS |
| vollständiger Testlauf | OPEN — Xcode/visionOS SDK fehlt |
| Plattform | Linux-Arbeitsumgebung ohne Apple-Toolchain |

Die neuen Tests prüfen alle vier konkreten Symbolnamen, Nichtleere und Eindeutigkeit, alle vier Texte, alle vier IDs, unveränderte Breite/Höhe/Tiefe und Bounds, die 50-%-Schwelle sowie die fachlich neutrale Präsentationsstruktur.

## 7. Simulator- und Regressionstest

Mangels visionOS-Simulator in dieser Umgebung offen:

- frontale Sicht auf alle vier Symbole und Texte
- Lesbarkeit ohne Clipping oder Überlappung
- Betrachtung leicht links, rechts und oben
- Drag auf alle vier Ziele und Speicherung des jeweiligen Teams
- ungültiger Drop mit Snapback
- sichtbare Panelbox und Dropzone im Laufzeitvergleich
- Replay-Regression aus Modul 021
- Punktekommunikation aus Modul 022

Statisch bestätigt:

- alle vier Attachments rendern Symbol und vollständigen deutschen Text
- Farbe ist nicht der alleinige Bedeutungsträger
- keine Änderung an Panelgröße, Position, IDs oder Drop-Bounds
- `DropEvaluator` und 50-%-Overlap unverändert
- keine Referenzpriorität oder Referenzteam-Lösung in der Präsentation

## 8. AK-28 und Risiken

**AK-28 = OPEN bis zur visuellen Simulatorabnahme.**

Code und automatisierte Schutzabdeckung erfüllen AK-28 statisch. Offen bleibt ausschließlich die Laufzeitbestätigung von SF-Symbol-Darstellung, Lesbarkeit aus den geforderten Winkeln und Drag/Drop-Regression auf einem visionOS-Ziel.

Risiko: Die tatsächliche Attachment-Rasterung und wahrgenommene Textgröße hängen vom visionOS-Renderer und der Betrachtungsdistanz ab. Falls die Simulatorabnahme Clipping zeigt, darf ausschließlich die innere Schrift-/Symbolskalierung angepasst werden; Panel- und Drop-Geometrie bleiben tabu.

## Empfehlung für Modul 024 — Debug-UI-Isolation

Modul 024 soll auf diesem Stand aufsetzen und ausschließlich DEV-/Debug-Oberfläche isolieren. `TeamTargetMapping.Presentation`, die vier Team-Attachments sowie sämtliche Panel- und Drop-Geometrie sind dabei als geschützter Bestand zu behandeln.
