# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `007` — Räumliche Interaktionsgrundlagen  
**Eingearbeitet am:** 2026-08-09  
**Branch laut 007-Report:** `main`  
**Commit vor Modul 007:** `243c56c feat: add docs`  
**Modul-006-Commit bestätigt:** `177e2b9 feat: Modul006`  
**Modul-007-Commit:** noch offen  
**Build nach Modul 007:** nicht nachgewiesen  
**Simulatorstart nach Modul 007:** nicht nachgewiesen  
**Testlauf nach Modul 007:** nicht nachgewiesen  
**Testdeklarationen laut Quellstand:** 64

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine Sitzung mit 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, anhand einer deutschen Ticketkarte untersucht, per Blickfokus, Pinch und Drag priorisiert und anschließend einem Support-Team zugeordnet.

Die Anwendung läuft linear in genau einem zentralen volumetrischen Fenster. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug. Nach einer gültigen Entscheidung erfolgt ausschließlich akustisches Richtig-/Falsch-Feedback; die richtige Lösung wird nicht angezeigt. Am Ende erscheinen nur die Gesamtpunktzahl und „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Feedback-Sounds, ein vollständiger Sitzungsreset und ein stabiler Ablauf ohne Backend, Benutzerkonten, Datenbank, Cloud, persistente Spielhistorie, zweites Fenster beziehungsweise Volume, Immersive Space, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | technisch abgeschlossen | ursprünglicher Hash nicht abschließend rekonstruiert | F-05 strukturell teilweise |
| 002 | Ticketdatenmodell und lokaler Katalog | implementiert | `2775041` | F-02, F-03 |
| 003 | Sitzungsmodell und Zufallsauswahl | implementiert | `dd78700` | F-04 modellseitig; F-16 modellseitig teilweise |
| 004 | Startansicht und Einstellungen | implementiert; Laufzeitabnahme offen | `84bb767` | F-01 implementiert; AK-01 Laufzeitnachweis offen |
| 005 | Monster-Asset-Pipeline | teilweise abgeschlossen | `68b84f3` | Pipeline/Mapping implementiert; finale Blender-Assets offen |
| 006 | Untersuchungsphase | implementiert; Laufzeitabnahme offen | `177e2b9` | F-06/F-07 implementiert; AK-06/AK-07 Laufzeitnachweis offen |
| 007 | Räumliche Interaktionsgrundlagen | implementiert; Laufzeitabnahme offen | Hash offen | F-10 generisch implementiert; AK-10 fachlich noch teilweise offen |
| 008 | Priorisierungsphase | als Nächstes | – | F-08 |
| 009 | Teamzuordnungsphase | offen | – | F-09 |
| 010 | Bewertung und Audiofeedback | offen | – | F-11, F-12, F-13 |
| 011 | Ergebnis und Neustart | offen | – | F-15, F-16 |
| 012 | Optionale Monsterreaktion | offen, Kann-Modul | – | F-17 |
| 013 | Integration und Gerätetest | offen | – | F-01 bis F-16 als Integrationstest |
| 014 | Abschlussmodul: Doku & Cleanup | offen | – | Dokumentenkonsistenz und Abgabeprüfung |

## Abschlussstand Modul 001

Modul 001 stellte das visionOS-Grundgerüst mit genau einer volumetrischen `WindowGroup`, `RootVolumeView`, deutscher Lokalisierungsgrundlage, RealityKit-Standardszene, DebugManager, zentralen Constants und einem Swift-Testing-Smoke-Test bereit.

## Abschlussstand Modul 002

Modul 002 ergänzte `TicketPriority`, `SupportTeam`, das fachliche `Ticket`-Modell und `LocalTicketCatalog.allTickets` mit genau zwölf Tickets und vollständiger 4×3-Verteilung.

## Abschlussstand Modul 003

Modul 003 ergänzte `GamePhase` und `SessionModel` als zentrale `@Observable @MainActor`-Zustandsquelle mit Ticketanzahl, zufälliger Auswahl ohne Wiederholung, aktuellem Ticket, Indexfortschaltung und Reset.

## Abschlussstand Modul 004

Modul 004 implementierte die deutsche Startansicht. `Ticket_TamerApp` besitzt genau eine `SessionModel`-Instanz und reicht sie per SwiftUI Environment weiter. Die Startschaltfläche ruft `startSession()` auf und wechselt modellseitig in `.untersuchen`.

## Abschlussstand Modul 005

Modul 005 ergänzte `Ticket.monsterAssetId`, vier neutrale Monster-IDs, das vollständige Ticket-Monster-Mapping und `MonsterAssetProvider`. Die vier aktuellen USDA-Kugeln sind nur technische Platzhalter; die finalen eigenen Blender-Monster fehlen weiterhin.

## Abschlussstand Modul 006

Modul 006 ergänzte `InvestigationView` und `SessionModel.beginPrioritizationPhase()`. Die Untersuchungsansicht zeigt Monster, Ticketnummer, Titel, Kurzbeschreibung, Auswirkung und alle Hinweise, aber keine Referenzlösung. Der Modul-007-Preflight bestätigt den tatsächlichen Modul-006-Commit:

`177e2b9 feat: Modul006`

## Eingearbeiteter Stand Modul 007

### Ergebnis

Modul 007 implementiert eine wiederverwendbare, fachlich neutrale RealityKit-Interaktionsgrundlage für Monster.

Neu beziehungsweise ergänzt wurden:

- `DropTargetComponent`,
- `MonsterInteractionConfigurator`,
- `DropEvaluator`,
- `InteractionConstants`,
- `SessionModel.lockInput()`,
- `SessionModel.unlockInput()`,
- DEBUG-only `DebugInteractionHarnessView`,
- Registrierung von `DropTargetComponent`,
- DEBUG-Routing in `.priorisieren`,
- 19 neue Tests in `InteractionFoundationTests`.

### Gewählte Eingabe-API

Der Report verwendet bewusst:

`DragGesture().targetedToAnyEntity()`

und nicht `ManipulationComponent`.

Gemeldete Begründung:

- der Release-Moment muss explizit kontrollierbar sein,
- `.onEnded` wird für die Drop-Semantik benötigt,
- direkte Kontrolle über gültige/ungültige Ablage und Input-Lock,
- keine eigene Handtracking-/ARKit-Pipeline.

Die Entity-Konfiguration umfasst:

- `InputTargetComponent` mit indirekter Eingabe,
- `CollisionComponent`,
- `HoverEffectComponent`,
- reine Translation über Drag; Rotation und Skalierung werden nicht durch die Gesture-Logik verändert.

### Generischer Drop-Zieltyp

`DropTargetComponent` markiert fachlich neutrale Zielbereiche.

Gemeldete Felder:

- `id: String`
- `radius: Float`
- `debugName: String?`

Der Typ kennt keine Priorität und kein Support-Team.

### Drop-Auswertung

`DropEvaluator` arbeitet positionsbasiert im Weltkoordinatensystem.

Semantik:

- Distanz Monster ↔ Ziel ≤ Zielradius → gültig,
- außerhalb aller Zielbereiche → ungültig,
- bei mehreren Treffern gewinnt das räumlich nächste Ziel,
- keine Bildschirmkoordinaten.

### Ungültiges Ablegen

Bei ungültigem Drop:

- Monster kehrt zur gespeicherten Ausgangstransformation zurück,
- `isInputLocked` bleibt unverändert/false,
- keine Phase wird geändert,
- kein Ticketindex wird geändert,
- kein Score wird geändert,
- keine Priorität wird gespeichert,
- kein Team wird gespeichert.

Die Rückkehr verwendet laut Report eine kurze Animation mit `InteractionConstants.monsterReturnDuration`.

### Gültiges generisches Ablegen

Bei gültigem generischen Drop:

- genau ein Drop wird akzeptiert,
- die neutrale Ziel-ID steht dem aufrufenden Handler zur Verfügung,
- `SessionModel.lockInput()` setzt `isInputLocked = true`,
- weitere Drag-/Release-Ereignisse werden ignoriert,
- keine fachliche Entscheidung wird in Modul 007 gespeichert,
- kein Score wird geändert,
- keine Phase wird geändert.

### Input-Lock

Neue Schnittstellen:

- `SessionModel.lockInput()`
- `SessionModel.unlockInput()`

Beide verändern laut Report weder:

- `score`,
- `currentPhase`,
- `selectedPriority`,
- `selectedTeam`.

`reset()` setzt den Lock weiterhin auf `false`.

### DEBUG-Harness

Datei:

`Views/Debug/DebugInteractionHarnessView.swift`

Eigenschaften:

- nur unter `#if DEBUG`,
- sichtbar in `.priorisieren`,
- neutraler Zielbereich `testTargetA`,
- keine Prioritäts-/Teambezeichnung,
- Release-Build zeigt für `.priorisieren` weiterhin den neutralen Platzhalter.

Das Harness dient ausschließlich der technischen Interaktionsprüfung und ist keine fachliche Priorisierungsansicht.

## Bewertung von F-10 / AK-10

### Implementierungsstand

Generisch implementiert sind:

- Blick-/Hover-Zielbarkeit,
- Pinch-/Drag-Grundlage,
- räumliche Translation,
- generische Drop-Ziele,
- gültige/ungültige Drop-Auswertung,
- Rücksetzung bei ungültigem Drop,
- genau-einmal-Input-Lock.

### Noch nicht fachlich vollständig

AK-10 spricht von einer tatsächlich gespeicherten Entscheidung.

Noch offen:

- Speichern von `selectedPriority` in Modul 008,
- Speichern von `selectedTeam` in Modul 009.

Daher gilt:

- **F-10: generische Interaktionsgrundlage implementiert.**
- **AK-10: generisch vorbereitet, fachlich erst nach Modulen 008/009 vollständig integrierbar.**
- **Laufzeitverifikation der Gesten: offen.**

## Teststand

| Bereich | Stand |
|---|---:|
| Testdeklarationen vor Modul 007 | 45 |
| neue `InteractionFoundationTests` | 19 |
| **Testdeklarationen nach Modul 007** | **64** |
| tatsächlicher Testlauf | nicht nachgewiesen |
| manuelle Gestenprüfung | nicht nachgewiesen |

Gemeldete Testbereiche umfassen:

- Lock-Initialzustand,
- `lockInput()` / `unlockInput()`,
- No-Op bei erneutem Lock,
- keine Veränderung von Score/Phase/Priorität/Team,
- Reset entsperrt,
- Drop innerhalb Radius,
- Drop auf Radiusgrenze,
- Drop außerhalb Radius,
- leere Zielliste,
- mehrere Ziele → nächstes gewinnt,
- neutrale Ziel-IDs,
- unveränderliche Component-Felder,
- Standardradius.

## Schnittstellen-Register

| Bereitgestellt von | Typ / Methode | Datei | Zweck |
|---|---|---|---|
| 001 | `Ticket_TamerApp` | `App/Ticket_TamerApp.swift` | App-Einstieg |
| 001 | `RootVolumeView` | `Views/RootVolumeView.swift` | Root-Darstellung |
| 001 | `DebugManager` | `Debug/DebugManager.swift` | zentrale Debug-Steuerung |
| 001 | `LayoutConstants` | `Support/AppConstants.swift` | Layout-/Volume-Werte |
| 001 | `GameplayConstants` | `Support/AppConstants.swift` | Ticketanzahl |
| 001 | `AssetKeys` | `Support/AppConstants.swift` | Asset-Schlüssel |
| 002 | `TicketPriority` | `Models/Ticket.swift` | Priorität |
| 002 | `SupportTeam` | `Models/Ticket.swift` | Support-Team |
| 002 | `Ticket` | `Models/Ticket.swift` | Ticketfachmodell |
| 002 | `LocalTicketCatalog.allTickets` | `Data/LocalTicketCatalog.swift` | lokaler Ticketpool |
| 003 | `GamePhase` | `Models/GamePhase.swift` | Spielphasen |
| 003 | `SessionModel` | `Models/SessionModel.swift` | zentrale Sitzungsquelle |
| 003 | `SessionModel.currentTicket` | `Models/SessionModel.swift` | aktuelles Ticket |
| 003 | `SessionModel.currentPhase` | `Models/SessionModel.swift` | aktuelle Phase |
| 004 | `StartView` | `Views/StartView.swift` | Startansicht |
| 004 | `SessionModel` via Environment | App-/View-Baum | gemeinsame Zustandsquelle |
| 005 | `Ticket.monsterAssetId` | `Models/Ticket.swift` | Monsterzuordnung |
| 005 | `MonsterAssetProvider.loadMonster(assetID:)` | `Assets/MonsterAssetProvider.swift` | lokales Monsterladen |
| 006 | `InvestigationView` | `Views/InvestigationView.swift` | Untersuchungsphase |
| 006 | `SessionModel.beginPrioritizationPhase()` | `Models/SessionModel.swift` | `.untersuchen → .priorisieren` |
| 007 | `DropTargetComponent(id:radius:debugName:)` | `Components/DropTargetComponent.swift` | generisches Drop-Ziel |
| 007 | `MonsterInteractionConfigurator.configure(_:mode:)` | `Services/MonsterInteractionConfigurator.swift` | Interaktionskonfiguration |
| 007 | `MonsterInteractionMode` | `Services/MonsterInteractionConfigurator.swift` | `.dragDrop` / `.inspectionOnly` |
| 007 | `DropEvaluator.evaluate(entity:targets:)` | `Services/DropEvaluator.swift` | Entity-basierte Drop-Auswertung |
| 007 | `DropEvaluator.evaluate(entityPosition:targets:)` | `Services/DropEvaluator.swift` | testbare Positionsauswertung |
| 007 | `SessionModel.lockInput()` | `Models/SessionModel.swift` | Eingabe sperren |
| 007 | `SessionModel.unlockInput()` | `Models/SessionModel.swift` | Eingabe freigeben |
| 007 | `InteractionConstants` | `Support/AppConstants.swift` | Collision-/Drop-Radien und Rückkehrdauer |

## DebugManager nach Modul 007

Keine neue Kategorie.

Verwendet werden:

- `.input`: Drag-/Release-Ereignisse und ignorierte Eingaben,
- `.physics`: Drop-Auswertung,
- `.state`: Lock setzen/freigeben,
- `.spawning`: Monster- und DEBUG-Zielerzeugung.

Keine vollständigen Tickettexte werden geloggt.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Dokumentationsstruktur und Single-Stand-Prinzip verbindlich. | Historie liegt in Git. |
| 2026-07-15 | Genau eine volumetrische `WindowGroup`. | F-05 ohne zweites Volume oder Immersive Space. |
| 2026-08-05 | `SessionModel` ist einzige Quelle des aktuellen Spielzustands. | Konkurrenzzustände vermeiden. |
| 2026-08-09 | Genau eine `SessionModel`-Instanz wird per SwiftUI Environment geteilt. | Einfache Zustandsweitergabe. |
| 2026-08-09 | `monsterAssetId` ist Teil von `Ticket`. | Entspricht der SPEC-Architekturskizze. |
| 2026-08-09 | USDA-Kugeln bleiben reine technische Platzhalter. | Finale Blender-Monster fehlen. |
| 2026-08-09 | `beginPrioritizationPhase()` ist eine kleine phasengebundene Mutation. | Kein Bedarf für allgemeine State-Machine. |
| 2026-08-09 | Modul 007 nutzt gezieltes `DragGesture` statt `ManipulationComponent`. | Explizite Release-Auswertung für Drop-Semantik laut Modulreport. |
| 2026-08-09 | Drop-Ziele bleiben in Modul 007 vollständig fachlich neutral. | Prioritäten gehören Modul 008, Teams Modul 009. |
| 2026-08-09 | `SessionModel.lockInput()` / `unlockInput()` kapseln die Eingabesperre. | Genau-einmal-Semantik ohne direkte Property-Manipulation aus Views. |
| 2026-08-09 | Das DEBUG-Harness bleibt nur bis zur echten Priorisierungsphase relevant. | Technische Prüfung ohne Vorziehen von Modul 008. |
| 2026-08-09 | AK-10 wird nicht als vollständig erfüllt markiert. | Fachliche Entscheidungsspeicherung fehlt noch; Gestenlaufzeitprüfung ebenfalls offen. |

## Offene Punkte / Risiken

### Vor oder zu Beginn von Modul 008

- [ ] aktuellen Branch und Commit prüfen,
- [ ] tatsächlichen Modul-007-Commit/Hash eintragen,
- [ ] App lokal in Xcode bauen,
- [ ] visionOS-Simulator starten,
- [ ] alle 64 Testdeklarationen ausführen,
- [ ] AK-01 nachprüfen,
- [ ] AK-06/AK-07 nachprüfen,
- [ ] DEBUG-Harness manuell prüfen: Hover, Pinch, Drag, gültiger/ungültiger Drop, Lock,
- [ ] tatsächliche visionOS-26-Kompatibilität der Gesture-/RealityKit-Aufrufe verifizieren,
- [ ] prüfen, ob `.git/index.lock` noch besteht und Git normal arbeitet.

### Modul 005 weiterhin offen

- [ ] vier eigene Blender-Quelldateien,
- [ ] vier finale RealityKit-kompatible Exporte,
- [ ] Export-/Lizenzdokumentation,
- [ ] Skalierung/Orientierung finaler Assets,
- [ ] Darstellung finaler Monster.

### Projektweite offene Punkte

- [ ] `.DS_Store`-Bereinigung,
- [ ] Audioassets/Rechte für Modul 010,
- [ ] Apple-Vision-Pro-Zeitfenster für Modul 013,
- [ ] F-17 erst nach Muss-Funktionen entscheiden.

## Chronik

### Modul 001 — Projektgrundgerüst und zentrales Volume

Grundgerüst, zentrales Volume, DebugManager, Constants, Lokalisierung und Smoke-Test eingerichtet.

### Modul 002 — Ticketdatenmodell und lokaler Katalog

Ticketmodell, Prioritäten, Teams und zwölf lokale Tickets mit vollständiger 4×3-Verteilung eingerichtet.

### Modul 003 — Sitzungsmodell und Zufallsauswahl

`GamePhase` und `SessionModel` mit Auswahl ohne Wiederholung, Index und Reset eingerichtet.

### Modul 004 — Startansicht und Einstellungen

Deutsche Startansicht, Ticketregler und Startaktion implementiert; zentrale `SessionModel`-Instanz per Environment bereitgestellt.

### Modul 005 — Monster-Asset-Pipeline

Monster-ID-Mapping und lokaler Provider implementiert; finale Blender-Monster fehlen weiterhin.

### Modul 006 — Untersuchungsphase

`InvestigationView` zeigt das aktive Ticket und Monster. `beginPrioritizationPhase()` wechselt kontrolliert zum selben Ticket in `.priorisieren`.

### Modul 007 — Räumliche Interaktionsgrundlagen

Generische Drag-/Drop-Grundlage, Drop-Ziel-Component, DropEvaluator und Input-Lock wurden implementiert. Ein DEBUG-only Harness erlaubt die technische Prüfung in `.priorisieren`, ohne echte Prioritätsziele vorwegzunehmen. Der Quellstand enthält 64 Testdeklarationen, aber noch keinen ausgeführten Build-, Test- oder Simulatornachweis.

## Nächster Schritt

`008-Eingangsprompt.md` in einen neuen Modul-Chat geben.

Modul 008 implementiert ausschließlich die Priorisierungsphase:

- drei beschriftete Ziele `Normal`, `Wichtig`, `Kritisch`,
- Monster laden und mit `.dragDrop` konfigurieren,
- generische Drop-Auswertung aus Modul 007 wiederverwenden,
- gültige Ziel-ID auf `TicketPriority` mappen,
- Prioritätsentscheidung genau einmal im `SessionModel` speichern,
- ungültiger Drop verändert keine Entscheidung,
- Eingabe nach gültigem Drop sperren.

Teamstationen, Bewertung, Audio und automatischer Übergang bleiben ausgeschlossen.
