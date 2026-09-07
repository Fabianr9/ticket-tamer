# Modul 028 — Teamlogos v1.3

## Ergebnis

Die vier bereitgestellten JPEG-Teamlogos sind lokal unter `Resources/TeamLogos` gebündelt
und über `TeamLogoCatalog` zentral den vier `SupportTeam`-Werten zugeordnet. Die produktive
Teamstation zeigt nun Logo und deutschen Teamtext; die historischen SF-Symbole wurden dort
vollständig ersetzt. Kann ein JPEG nicht geladen werden, bleibt die Station als Text-Fallback
sichtbar und fachlich unverändert funktionsfähig.

## Vorab-Check

| Punkt | Ergebnis |
|---|---|
| Branch | `v1.3` |
| HEAD vor Modul 028 | `72d3e0470a7a7ba9591733a5ce0c42e6191b6087` (`feat: Modul 27`) |
| tatsächlicher Modul-027-Commit | `72d3e04` (`feat: Modul 27`) |
| Working Tree vor Modul | nicht sauber: zwei geänderte Standdokumente und der neue Eingangsprompt 028; diese Fremdänderungen wurden nicht bearbeitet |
| reale Tests vor Modul | 340 `@Test`-Deklarationen (abweichend von den dokumentierten 372) |
| reale Tests nach Modul | 369 `@Test`-Deklarationen |
| lokales Xcode/Swift | nicht vorhanden (`xcodebuild` und `swift` nicht gefunden) |
| Build/Test/Simulator | OPEN, da Xcode, visionOS-SDK und Simulator fehlen |

Die Abweichung der Testzahl ist bereits im unveränderten Stand von Commit `72d3e04` vorhanden:
Der Report 027 nennt 372, die reale Datei enthält vor Modul 028 jedoch 340 Deklarationen.

## Logo-Inventar und Bundleprüfung

Alle vier Quelldateien sind valide JFIF-JPEGs, 1024 × 1024 Pixel groß und ungleich null Byte.
Quell- und Zielkopien besitzen jeweils denselben SHA-256-Hash.

| Team | Quelldatei | Größe | produktiver Zielpfad | statischer Status |
|---|---|---:|---|---|
| Netzwerk | `Teamlogos/Network_team_icon_design_202609032139.jpeg` | 535457 B | `Ticket_Tamer/Ticket_Tamer/Resources/TeamLogos/Network_team_icon_design_202609032139.jpeg` | JPEG validiert |
| Konto | `Teamlogos/Team_icon_design_profile_lock_202609032138.jpeg` | 364644 B | `Ticket_Tamer/Ticket_Tamer/Resources/TeamLogos/Team_icon_design_profile_lock_202609032138.jpeg` | JPEG validiert |
| Software | `Teamlogos/Software_team_icon_design_202609032138.jpeg` | 354548 B | `Ticket_Tamer/Ticket_Tamer/Resources/TeamLogos/Software_team_icon_design_202609032138.jpeg` | JPEG validiert |
| Hardware | `Teamlogos/Hardware_team_icon_design_202609032138.jpeg` | 297716 B | `Ticket_Tamer/Ticket_Tamer/Resources/TeamLogos/Hardware_team_icon_design_202609032138.jpeg` | JPEG validiert |

Das Xcode-Projekt nutzt eine `PBXFileSystemSynchronizedRootGroup`; neue Dateien unter dem
App-Quellordner werden dadurch automatisch dem App-Target zugeordnet. Der Lookup versucht den
gemeinsamen Bundle-Unterordner `TeamLogos` und unterstützt zusätzlich Xcodes flach kopierte
Ressourcen. Die tatsächliche Bundle-Auffindbarkeit bleibt bis zum Xcode-Build OPEN.

## Teamlogo-Architektur

`TeamLogoCatalog` ist die einzige Team→Logo-Zuordnung. Eine `TeamLogoResource` enthält nur
Ressourcenname und JPEG-Endung, keine absolute URL und keinen Entwicklerpfad. Die
`TeamTargetMapping.Presentation` enthält ausschließlich Teamtext und Logoressource; Ticket,
Referenzpriorität, Score, Position und Dropgeometrie sind nicht Teil der Darstellung.

| Team | vorher | nachher | Text bleibt |
|---|---|---|---|
| Netzwerk | SF Symbol `network` | lokales JPEG | ja, `Netzwerk` |
| Konto | SF Symbol `person.crop.circle` | lokales JPEG | ja, `Konto` |
| Software | SF Symbol `macwindow` | lokales JPEG | ja, `Software` |
| Hardware | SF Symbol `desktopcomputer` | lokales JPEG | ja, `Hardware` |

Die View lädt das JPEG optional, stellt es mit `scaledToFit` in einer maximal 34 × 34 Punkte
großen Innenbox dar und erhält so das quadratische Seitenverhältnis. Das Logo ist für
VoiceOver ausgeblendet; die Station besitzt weiterhin den vollständigen Teamnamen als
Accessibility-Label. Bei fehlender oder ungültiger Datei entfällt nur das Bild. Der Text,
die Ziel-Entity, Target-ID und Drop-Auswertung bleiben erhalten. Der Befund wird einmal beim
Szenenaufbau über die bestehende Debug-Kategorie `.spawning` protokolliert.

## Geometrieschutz

`TargetPanelLayout`, `TargetPanelFactory`, `DropTargetComponent` und `DropEvaluator` wurden
nicht geändert. Für die bereits verwendete Referenzgeometrie (Volume 0,8 × 0,75 × 0,38 m,
Monster 0,13 m je Achse) ergibt die unveränderte Berechnung vor und nach Modul 028:

| Wert | vorher | nachher |
|---|---:|---:|
| Panelbreite | 0,195 m | 0,195 m |
| Panelhöhe | 0,117 m | 0,117 m |
| Paneltiefe | 0,020 m | 0,020 m |
| Targetzentren | x ±0,1075 m; y 0,160/0,023 m; z −0,085 m | identisch |
| Drop halfExtents | (0,0975; 0,0585; 0,0100) m | identisch |
| Overlap-Schwelle | 0,50 | 0,50 |
| Z-Toleranz | 0,05 m | 0,05 m |

Die sichtbaren Panelaußenmaße stammen weiterhin ausschließlich aus `TargetPanelLayout`; das
SwiftUI-Attachment mit Logo und Text ändert weder Mesh noch `DropTargetComponent.halfExtents`.

## Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Support/TeamLogoCatalog.swift` | neu | zentraler lokaler Katalog und Bundle-Lookup | F-28, F-39 / AK-28, AK-39 |
| `Views/TeamAssignmentView.swift` | geändert | JPEG + Text, textbasierter Fallback, einmaliges Ressourcenlog | F-28 / AK-28 |
| `Resources/TeamLogos/*.jpeg` | neu | vier gebündelte Originalressourcen | F-28, F-39 / AK-28, AK-39 |
| `Ticket_TamerTests.swift` | geändert | Symboltests ersetzt und 29 Netto-Tests für Katalog, Darstellung, Fallback und Geometrie ergänzt | AK-28, AK-39 |

## Tests und Prüfstatus

| Prüfung | Status | Ergebnis |
|---|---|---|
| Testdeklarationen | PASS | 340 vorher, 369 nachher, netto +29 |
| JPEG-Signatur und Abmessungen | PASS | viermal JFIF-JPEG, 1024 × 1024 |
| Quell-/Zielintegrität | PASS | SHA-256 je Datei identisch |
| historische SF-Symbole in produktiver Teamstation | PASS (statisch) | keine vier alten Symbolnamen mehr im App-Code |
| Modul-028-`git diff --check` | PASS | keine Whitespacefehler in Moduldateien |
| gesamter Working-Tree-`git diff --check` | OPEN | vorbestehende Whitespacefehler in zwei fremden Standdateien |
| vollständiger Testlauf | OPEN | kein Swift/Xcode verfügbar |
| Build | OPEN | kein Xcode/visionOS-SDK verfügbar |
| Simulator | OPEN | kein visionOS-Simulator verfügbar |

Die Tests decken insbesondere vier eindeutige lokale JPEG-Referenzen, deutsche Texte,
unveränderte IDs, Panelmaße, Zielzentren, Drop-Bounds, 50-%-Overlap, Z-Toleranz sowie den
fehlenden-Ressource-Fallback ab. TT-001 bis TT-016, `videoAssetName`, Sitzungsgrenzen,
Replay, Punkte, Monsterfarben, Snapback und Exactly-once wurden nicht geändert.

## Simulator-/Regressionstest

Folgende Laufzeitprüfungen bleiben OPEN: sichtbare Logos und Texte aus allen geforderten
Blickwinkeln, Drag auf alle vier Ziele, Invalid Drop/Snapback, Exactly-once, kontrollierter
Logo-Fallback sowie die Modul-027-Regression im visionOS-Simulator. Statisch ist bestätigt,
dass die Logos keine Ziel- oder Dropgeometrie erreichen und der Fallback die fachliche
Zuordnung nicht beeinflusst.

## Akzeptanzkriterien und Risiken

| Kriterium | Status | Bewertung |
|---|---|---|
| AK-28 | PASS (Code/Test), Laufzeit OPEN | vier korrekte lokale JPEG-Mappings, Text bleibt, alte SF-Symbole ersetzt, Fallback und Geometrieschutz vorhanden |
| AK-39 Teamlogo-Anteil | PASS (Code/Test), Bundle-Laufzeit OPEN | gemeinsamer Ressourcenbereich, zentrale Zuordnung, keine Netzwerk- oder absoluten Pfade |

Offenes Risiko ist ausschließlich die nicht mögliche Xcode-/Simulatorvalidierung der
tatsächlichen Bundlekopie und visuellen Lesbarkeit. Diese ist auf einem macOS-System mit
visionOS-26.5-SDK nachzuholen.

Empfehlung für **Modul 029 — Monster- und Streak-Audio**: auf der zentralen lokalen
Ressourcenstruktur aufbauen, dabei `TeamLogoCatalog`, Teamstationsdarstellung sowie sämtliche
Drop- und Teamlogik unverändert lassen.
