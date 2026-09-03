# Modul 025 — Monster-Farbvarianten

## 1. Vorab-Check

| Punkt | Realer Stand |
|---|---|
| Branch | `A` |
| HEAD vor Modul 025 | `fd8bf28 feat: Modul 24` |
| tatsächlicher Modul-024-Commit | `fd8bf28` |
| Working Tree vor 025 | vorbereitete Änderungen an `Projekt-Stand.md`, `Logbuch-Stand.md` und ungetrackter `025-Eingangsprompt.md`; unangetastet übernommen |
| Testdeklarationen vor 025 | 333 |
| Build/Test/Simulator | OPEN: In der verfügbaren Linux-Umgebung fehlen `xcodebuild`, `swiftc`, visionOS SDK und Simulator |

Modul 024 war bereits separat committed. Es wurde nicht mit Modul 025 vermischt.

## 2. Asset-Inventar

Alle Dateien liegen nun unter
`Packages/RealityKitContent/Sources/RealityKitContent/MonsterAssets`. Dieser Ordner
wird in `Package.swift` explizit über `.copy("MonsterAssets")` als produktive lokale
Ressource eingebunden. `file` erkennt jede Quelle und jede produktive Kopie als
`USD crate, version 0.8.0`; SHA-256-Vergleiche bestätigen identische Kopien.

| Typ | Variante | exakter Dateiname | produktive Ressource | ladbar |
|---|---|---|---|---|
| monster01 | blue | `Monster_1_blue.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster01 | green | `Monster_1_green.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster01 | pink | `Monster_1_pink.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster01 | red | `Monster_1_red.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster02 | blue | `Monster_2_blue.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster02 | green | `Monster_2_green.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster02 | pink | `Monster_2_pink.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster02 | red | `Monster_2_red.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster03 | blue | `Monster_3_blue.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster03 | green | `Monster_3_green.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster03 | pink | `Monster_3_pink.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster03 | yellow | `Monster_3_yellow.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster04 | blue | `Monster_4_blue.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster04 | green | `Monster_4_green.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster04 | pink | `Monster_4_pink.usdc` | ja | strukturell ja; Laufzeit OPEN |
| monster04 | red | `Monster_4_red.usdc` | ja | strukturell ja; Laufzeit OPEN |

Damit sind vier Typen mit jeweils vier explizit katalogisierten Varianten vorhanden.
Typ 3 bildet den realen Sonderfall `yellow` statt `red` korrekt ab.

## 3. Variantenarchitektur

`MonsterAssetVariant` enthält ausschließlich `monsterTypeID`, `variantKey` und den
expliziten `assetFileName`. `MonsterVariantCatalog` bildet die 16 echten Dateinamen
ohne dynamische Namenskonstruktion ab.

`SessionModel.startSession(using:variantSelector:)` wählt nach der Ticketauswahl genau
einmal je Sitzungsticket. Die produktive Vorgabe verwendet `randomElement()`, Tests
injizieren eine deterministische Closure. Das Ergebnis liegt ausschließlich in
`selectedMonsterVariantByTicketID`. Der Lookup
`selectedMonsterVariant(for:)` liest nur dieses Mapping und würfelt nie nach.
`reset()` leert das Mapping vollständig.

```text
startSession
→ Ticket auswählen
→ bestehenden monsterAssetId/Monstertyp beibehalten
→ konkrete Variante aus dem expliziten Typkatalog wählen
→ unter Ticket-ID speichern
→ Untersuchung → Priorisierung → Teamzuordnung → Retry
→ überall dieselbe gespeicherte Assetdatei
```

## 4. Schutz der Gameplaylogik

- Die Auswahl erhält weder Referenzteam noch Referenzpriorität, Score oder Feedback.
- Ticket-Typzuordnung, Scoring, Exactly-once, Audio und Feedback sind unverändert.
- Fit, Blender-Korrektur, Zentrierung, Collision, DragBounds, Snapback und Drop-Auswertung
  bleiben die gemeinsame bestehende Pipeline.
- Alle drei produktiven Views übergeben dieselbe gespeicherte Variante an denselben Loader.
- `MonsterLoadRecovery.requestedAssetID` enthält den konkreten Dateinamen; Retry würfelt nicht neu.
- Replay-Root, Punktekommunikation, Teamstationsgeometrie und Debug-UI-Isolation wurden nicht verändert.

## 5. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Assets/MonsterAssetVariant.swift` | neu | Variantenwert und expliziter 4×4-Katalog | F-30 / AK-30.1–2,7,9 |
| `Assets/MonsterAssetProvider.swift` | erweitert | konkrete katalogisierte USDC-Datei laden, gemeinsame Korrekturpipeline | AK-30.2,8 |
| `Models/SessionModel.swift` | erweitert | Auswahl, Mapping, Lookup und Reset | AK-30.3–4,6,9–10 |
| `Views/InvestigationView.swift` | geändert | gespeicherte Variante und identischer Retry | AK-30.4–5 |
| `Views/PrioritizationView.swift` | geändert | gespeicherte Variante in bestehender Drag-Pipeline | AK-30.4–5,8 |
| `Views/TeamAssignmentView.swift` | geändert | gespeicherte Variante in bestehender Drag-Pipeline | AK-30.4–5,8 |
| `Ticket_TamerTests/MonsterVariantTests.swift` | neu | 32 Katalog-, Sitzungs-, Neutralitäts-, Reset- und Retrytests | AK-30 |
| `RealityKitContent/.../MonsterAssets/*.usdc` | 12 ergänzt | alle 16 Quelldateien produktiv bündeln | AK-30.1–2 |

## 6. Tests und Prüfungen

| Prüfung | Ergebnis |
|---|---|
| Testdeklarationen vorher | 333 |
| neue Testdeklarationen | 32 |
| Testdeklarationen nachher | 365 |
| 4 Typen / 4 je Typ / 16 gesamt / eindeutige Namen | automatisiert abgedeckt |
| deterministische Auswahl / Sessionstabilität / neue Sitzung | automatisiert abgedeckt |
| Neutralität / unbekannter Typ / keine stille Neuauswahl | automatisiert abgedeckt |
| Retry / mehrfacher Retry / Reset | automatisiert abgedeckt |
| USDC-Format und Quellgleichheit | 16/16 strukturell bestätigt |
| `git diff --check` für Modul-025-Dateien | PASS |
| Xcode-Build und vollständige Tests | OPEN, Werkzeug/SDK nicht vorhanden |

Die bereits vorgefundenen Stand-Dokumente enthalten eigene nachgestellte Leerzeichen;
deshalb meldet ein repositoryweiter `git diff --check` diese fremden Vorabänderungen.
Der Modul-025-Diff selbst ist whitespace-fehlerfrei.

## 7. Simulator-/Assetabnahme

| Abnahmepunkt | Status |
|---|---|
| alle 16 laden und sichtbar | OPEN – visionOS-Simulator erforderlich |
| Fit, Kollision und Drag für alle 16 | OPEN – Simulator erforderlich; gemeinsame Codepipeline bestätigt |
| drei Phasen zeigen dieselbe konkrete Variante | OPEN – Laufzeitsichtprüfung; gemeinsamer Mapping-Lookup automatisiert bestätigt |
| Retry zeigt dieselbe Variante | OPEN – Laufzeitsichtprüfung; konkrete Recovery-ID automatisiert bestätigt |
| neue Sitzung darf neu wählen | PASS auf Modellebene |
| Reset leert Mapping | PASS auf Modellebene |
| Snapback und 50-%-Drop mit allen Varianten | OPEN – Simulator erforderlich; Logik unverändert |

## 8. AK-30 und offene Risiken

AK-30 ist insgesamt **OPEN**, nicht FAIL: Implementierung, produktive Ressourcen und
automatisierte Abdeckung sind vollständig angelegt, die verbindliche Xcode-/visionOS-
Laufzeitabnahme konnte in dieser Umgebung aber nicht ausgeführt werden.

Offen bleiben ausschließlich die reale Bundle-Ladung und Darstellung aller 16 Assets,
ihre sichtbaren Rohbounds sowie die manuelle Drag-/Drop-/Retry-Prüfung im Simulator
beziehungsweise auf Apple Vision Pro. Ohne Xcode-Lauf kann außerdem die endgültige
Swift-Typprüfung nicht behauptet werden.

## 9. Empfehlung für Modul 026 — Integration und Abnahme v1.2

Zuerst Build und vollständige Tests unter Xcode ausführen. Danach alle 16 Varianten
kontrolliert im visionOS-Simulator erzwingen und pro Datei Sichtbarkeit, Fit, Kollision,
DragBounds, Snapback und Drop prüfen. Abschließend ein Ticket durch Untersuchung,
Priorisierung, Teamzuordnung und provozierten Lade-Retry verfolgen sowie Reset und eine
neue Sitzung prüfen. Erst bei vollständigem Laufzeitnachweis AK-30 auf PASS setzen.
