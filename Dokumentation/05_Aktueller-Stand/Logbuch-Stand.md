# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `005` — Monster-Asset-Pipeline  
**Eingearbeitet am:** 2026-08-09  
**Branch laut 005-Report:** `main`  
**Commit vor Modul 005:** `356cb06 feat: update docs`  
**Modul-004-Commit enthalten:** `84bb767`  
**Modul-005-Commit:** noch nicht bekannt  
**Build nach Modul 005:** nicht nachgewiesen  
**Simulatorstart nach Modul 005:** nicht nachgewiesen  
**Testlauf nach Modul 005:** nicht nachgewiesen

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine Sitzung mit 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, anhand einer deutschen Ticketkarte untersucht, per Blickfokus, Pinch und Drag priorisiert und anschließend einem Support-Team zugeordnet.

Die Anwendung läuft linear in genau einem zentralen volumetrischen Fenster. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug. Nach einer gültigen Entscheidung erfolgt ausschließlich akustisches Richtig-/Falsch-Feedback; die richtige Lösung wird nicht angezeigt. Am Ende erscheinen nur die Gesamtpunktzahl und „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Feedback-Sounds, ein vollständiger Sitzungsreset und ein stabiler Ablauf ohne Backend, Benutzerkonten, Datenbank, Cloud, persistente Spielhistorie, zweites Fenster beziehungsweise Volume, Immersive Space, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | technisch abgeschlossen | ursprünglicher Hash im Logbuch nicht abschließend rekonstruiert | F-05 strukturell teilweise |
| 002 | Ticketdatenmodell und lokaler Katalog | implementiert | `2775041` | F-02, F-03 |
| 003 | Sitzungsmodell und Zufallsauswahl | implementiert | `dd78700` | F-04 modellseitig; F-16 modellseitig teilweise |
| 004 | Startansicht und Einstellungen | implementiert; Laufzeitabnahme offen | `84bb767` | F-01 implementiert; AK-01 Laufzeitnachweis offen |
| 005 | Monster-Asset-Pipeline | **teilweise abgeschlossen** | Hash offen | Pipeline/Mapping implementiert; F-14/AK-14 noch nicht vollständig erfüllt |
| 006 | Untersuchungsphase | als Nächstes; darf mit Platzhaltern entwickelt werden | – | F-06, F-07 |
| 007 | Räumliche Interaktionsgrundlagen | offen | – | F-10 |
| 008 | Priorisierungsphase | offen | – | F-08 |
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

Modul 004 implementierte die deutsche Startansicht. `Ticket_TamerApp` besitzt genau eine `SessionModel`-Instanz und reicht sie per SwiftUI Environment weiter. Die Startschaltfläche ruft `startSession()` auf und wechselt modellseitig in `.untersuchen`. Laufzeitabnahme, Simulatorstart und vollständiger Testlauf blieben offen.

## Eingearbeiteter Stand Modul 005

### Technisch implementiert

Modul 005 hat die Monster-Pipeline strukturell umgesetzt:

- `monsterAssetId: String` wurde in `Ticket` ergänzt,
- alle zwölf Tickets besitzen eine neutrale Monster-ID,
- die IDs `monster01` bis `monster04` sind zentral in `AssetKeys.Monster` definiert,
- `MonsterAssetProvider.loadMonster(assetID:)` kapselt lokales asynchrones RealityKit-Laden,
- unbekannte IDs führen zu einem typisierten Fehler,
- es gibt keinen Netzwerk-Fallback,
- das Mapping verrät weder Team noch Priorität eindeutig,
- vier lokale USDA-Test-/Platzhalterszenen wurden angelegt,
- `spawning` wird für Asset-Ladeereignisse verwendet.

### Nicht geliefert

Vor Modul 005 lagen laut Report **keine** der geforderten vier eigenen Blender-Quelldateien und **keine** finalen USDZ-Exporte vor.

Stattdessen wurden vier technische USDA-Platzhalter mit Kugelgeometrie erzeugt:

| ID | Datei | Status |
|---|---|---|
| `monster01` | `monster01.usda` | technischer Platzhalter |
| `monster02` | `monster02.usda` | technischer Platzhalter |
| `monster03` | `monster03.usda` | technischer Platzhalter |
| `monster04` | `monster04.usda` | technischer Platzhalter |

Diese Dateien dienen nur zum Aufbau der Ladepipeline.

### Bewertung von F-14 / AK-14

**Nicht als vollständig erfüllt markieren.**

Begründung:

F-14 verlangt vier **eigene Blender-Monster** als lokale RealityKit-kompatible 3D-Assets. Vier generische USDA-Kugeln, die im Modul-Chat erzeugt wurden, erfüllen diese fachliche Muss-Anforderung nicht.

Aktueller Stand:

- [x] neutrale Monster-IDs definiert,
- [x] `monsterAssetId` im Ticketmodell ergänzt,
- [x] alle zwölf Tickets besitzen eine gültige Zuordnung,
- [x] keine feste 1:1-Zuordnung Monster → Team,
- [x] keine feste 1:1-Zuordnung Monster → Priorität,
- [x] lokale Ladepipeline implementiert,
- [x] keine Netzwerkabhängigkeit in der Pipeline,
- [ ] vier eigene Blender-Quelldateien vorhanden,
- [ ] vier finale RealityKit-kompatible Monster-Exporte eingebunden,
- [ ] alle vier finalen Monster im Simulator sichtbar geprüft,
- [ ] Skalierung und Orientierung der finalen Assets geprüft,
- [ ] Blickfokus/Pinch/Drag geprüft — gehört zusätzlich zu Modul 007.

Modul 005 bleibt deshalb im Projektlogbuch **teilweise abgeschlossen**. Die technische Grundlage reicht aus, damit Modul 006 mit Platzhaltern weiterentwickelt werden kann. Die finale F-14/AK-14-Abnahme muss spätestens vor beziehungsweise in Modul 013 nach Einsetzen der echten Monster erfolgen.

## Ticket-Monster-Mapping

| Ticket | Team | Priorität | Monster-ID |
|---|---|---|---|
| TT-001 | netzwerk | normal | monster01 |
| TT-002 | netzwerk | wichtig | monster02 |
| TT-003 | netzwerk | kritisch | monster03 |
| TT-004 | konto | normal | monster04 |
| TT-005 | konto | wichtig | monster01 |
| TT-006 | konto | kritisch | monster02 |
| TT-007 | software | normal | monster03 |
| TT-008 | software | wichtig | monster04 |
| TT-009 | software | kritisch | monster01 |
| TT-010 | hardware | normal | monster02 |
| TT-011 | hardware | wichtig | monster03 |
| TT-012 | hardware | kritisch | monster04 |

Jedes Monster wird bei drei Tickets verwendet und kommt über mehrere Teams und alle drei Prioritätsstufen hinweg vor.

## Schnittstellen-Register

| Bereitgestellt von | Typ / Methode | Datei | Zweck |
|---|---|---|---|
| 001 | `Ticket_TamerApp` | `App/Ticket_TamerApp.swift` | App-Einstieg |
| 001 | `RootVolumeView` | `Views/RootVolumeView.swift` | Root-Darstellung |
| 001 | `DebugManager` | `Debug/DebugManager.swift` | zentrale Debug-Steuerung |
| 001 | `LayoutConstants` | `Support/AppConstants.swift` | Layout-/Volume-Werte |
| 001 | `GameplayConstants` | `Support/AppConstants.swift` | Ticketanzahl 1–12, Standard 6 |
| 001 | `AssetKeys` | `Support/AppConstants.swift` | zentrale Asset-Schlüssel |
| 002 | `TicketPriority` | `Models/Ticket.swift` | Priorität |
| 002 | `SupportTeam` | `Models/Ticket.swift` | Support-Team |
| 002 | `Ticket` | `Models/Ticket.swift` | Ticketfachmodell |
| 002 | `LocalTicketCatalog.allTickets` | `Data/LocalTicketCatalog.swift` | lokaler Ticketpool |
| 003 | `GamePhase` | `Models/GamePhase.swift` | fünf Spielphasen |
| 003 | `SessionModel` | `Models/SessionModel.swift` | zentrale Sitzungsquelle |
| 003 | `SessionModel.startSession(using:)` | `Models/SessionModel.swift` | Sitzung starten |
| 003 | `SessionModel.currentTicket` | `Models/SessionModel.swift` | aktuelles Ticket |
| 003 | `SessionModel.currentPhase` | `Models/SessionModel.swift` | aktuelle Phase |
| 004 | `StartView` | `Views/StartView.swift` | Startansicht |
| 004 | `SessionModel` per Environment | App-/View-Baum | einheitlicher Zustand für Kind-Views |
| 005 | `Ticket.monsterAssetId: String` | `Models/Ticket.swift` | neutrale Monsterzuordnung |
| 005 | `AssetKeys.Monster.monster01...monster04` | `Support/AppConstants.swift` | vier stabile Monster-IDs |
| 005 | `AssetKeys.Monster.allIDs` | `Support/AppConstants.swift` | Liste aller Monster-IDs |
| 005 | `MonsterAssetProvider.loadMonster(assetID:)` | `Assets/MonsterAssetProvider.swift` | lokales asynchrones Laden |
| 005 | `MonsterAssetProvider.LoadError` | `Assets/MonsterAssetProvider.swift` | typisierte Ladefehler |

## DebugManager nach Modul 005

- keine neue Kategorie,
- `spawning` wird im `MonsterAssetProvider` für Ladestart, Ladeerfolg und Ladefehler genutzt,
- keine `print()`-Aufrufe,
- keine vollständigen Tickettexte in Logs.

## Teststand

Vor Modul 005 waren 27 Testdeklarationen dokumentiert.

Der 005-Report ist bei der Anzahl neuer Tests widersprüchlich:

- in der Dateitabelle steht „9 neue Modul-005-Tests“,
- die detaillierte Liste enthält **11** nummerierte Tests,
- die Gesamtzahl wird als `27 + 11 = 38` angegeben.

Daher gilt bis zur realen Prüfung:

- **gemeldete Testdeklarationen nach Modul 005: wahrscheinlich 38,**
- **tatsächliche Zahl: in Xcode beziehungsweise im Quellcode zu bestätigen,**
- **erfolgreicher Testlauf: nicht nachgewiesen.**

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Dokumentationsstruktur und Single-Stand-Prinzip verbindlich. | Historie liegt in Git. |
| 2026-07-15 | Genau eine volumetrische `WindowGroup`. | F-05 ohne zweites Volume oder Immersive Space. |
| 2026-08-05 | `SessionModel` ist einzige Quelle des aktuellen Spielzustands. | Konkurrenzzustände vermeiden. |
| 2026-08-09 | `Ticket_TamerApp` besitzt genau eine `SessionModel`-Instanz und reicht sie per Environment weiter. | Einfache SwiftUI-Observation-Lösung. |
| 2026-08-09 | Die SPEC-Lücke `monsterAssetId` wird durch ein Feld direkt in `Ticket` aufgelöst. | Entspricht der Architektur-Skizze und hält die Zuordnung einfach. |
| 2026-08-09 | Monster-IDs bleiben neutral (`monster01`–`monster04`). | Keine visuelle oder semantische Lösungshilfe. |
| 2026-08-09 | `MonsterAssetProvider` kapselt lokales Laden und gibt Fehler explizit weiter. | Wiederverwendbare, kleine Schnittstelle ohne Netzwerk oder DI-Komplexität. |
| 2026-08-09 | Die USDA-Kugeln gelten ausschließlich als technische Platzhalter, nicht als Erfüllung der Blender-Mussanforderung. | F-14/AK-14 verlangen vier eigene Blender-Monster; die Anforderung wird nicht stillschweigend abgeschwächt. |
| 2026-08-09 | Modul 006 darf auf der Pipeline mit Platzhaltern weiterarbeiten. | Untersuchungsansicht kann unabhängig vom finalen visuellen Asset erstellt werden; finale Asset-Abnahme bleibt offen. |
| 2026-08-09 | Vollständige Gesteninteraktion bleibt Modul 007. | Verbindliche Modul-Landkarte. |
| 2026-08-09 | Die Testzahl nach Modul 005 wird nicht als sicherer Wert übernommen. | Report nennt sowohl 9 als auch 11 neue Tests. |

## Offene Punkte / Risiken

### Vor oder zu Beginn von Modul 006

- [ ] Aktuellen Branch und Commit prüfen.
- [ ] Modul-005-Commit/Hash dokumentieren.
- [ ] App lokal in Xcode bauen.
- [ ] visionOS-Simulator starten.
- [ ] tatsächliche Testzahl ermitteln und alle Tests ausführen.
- [ ] AK-01 aus Modul 004 im Simulator nachholen.
- [ ] prüfen, ob `MonsterAssetProvider` die vier USDA-Platzhalter tatsächlich laden kann.
- [ ] mindestens ein Monster beziehungsweise idealerweise alle vier im zentralen Volume sichtbar prüfen.

### Vor finaler Abnahme von F-14 / AK-14

- [ ] vier echte Blender-Quelldateien liefern,
- [ ] Blender-Exportpipeline dokumentieren,
- [ ] vier finale RealityKit-kompatible Exporte einbinden,
- [ ] Urheberschaft/Lizenz dokumentieren,
- [ ] Skalierung, Orientierung und Transform-Ursprung prüfen,
- [ ] alle vier finalen Modelle im Simulator/Gerät darstellen,
- [ ] Interaktion in Modul 007 prüfen.

### Weitere Projektpunkte

- [ ] Tickettexte mit `ae`, `oe`, `ue` vor sichtbarer Darstellung in Modul 006 prüfen und nur fachlich nötige Textkorrekturen kontrolliert durchführen.
- [ ] Drei bekannte `.DS_Store`-Dateien später aus Git entfernen und über `.gitignore` ausschließen.
- [ ] Audiodateien und Rechte für Modul 010 vorbereiten.
- [ ] Apple-Vision-Pro-Zeitfenster für Modul 013 sichern.
- [ ] F-17 erst nach Absicherung der Muss-Funktionen entscheiden.

## Chronik

### Modul 001 — Projektgrundgerüst und zentrales Volume

Grundgerüst, zentrales Volume, DebugManager, Constants, Lokalisierung und Smoke-Test eingerichtet.

### Modul 002 — Ticketdatenmodell und lokaler Katalog

Ticketmodell, Prioritäten, Teams und zwölf lokale Tickets mit vollständiger 4×3-Verteilung eingerichtet.

### Modul 003 — Sitzungsmodell und Zufallsauswahl

`GamePhase` und `SessionModel` mit Auswahl ohne Wiederholung, Index und Reset eingerichtet.

### Modul 004 — Startansicht und Einstellungen

Deutsche Startansicht, Ticketregler und Startaktion implementiert; zentrale `SessionModel`-Instanz über SwiftUI Environment bereitgestellt.

### Modul 005 — Monster-Asset-Pipeline

`monsterAssetId`, vier neutrale Asset-IDs, Katalogzuordnung und `MonsterAssetProvider` wurden implementiert. Vier USDA-Kugeln bilden die Pipeline technisch ab. Die Mussanforderung nach vier eigenen Blender-Monstern ist jedoch noch offen; deshalb bleibt Modul 005 fachlich teilweise abgeschlossen.

## Nächster Schritt

`006-Eingangsprompt.md` in einen neuen Modul-Chat geben.

Modul 006 implementiert ausschließlich die Untersuchungsphase: aktuelles Monster laden und anzeigen, Ticketkarte mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und 1–3 Hinweisen darstellen sowie „Weiter zur Priorisierung“ anbinden.

Prioritätsziele, Drag-and-Drop, Teamstationen, Bewertung und Audio bleiben ausgeschlossen.
