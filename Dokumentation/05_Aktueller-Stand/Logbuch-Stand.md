# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `006` — Untersuchungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut 006-Report:** `main`  
**Commit vor Modul 006:** `98cd95d fix:import error`  
**Modul-005-Commit bestätigt:** `68b84f3 feat:Modul005`  
**Modul-006-Commit:** noch nicht bekannt  
**Build nach Modul 006:** nicht nachgewiesen  
**Simulatorstart nach Modul 006:** nicht nachgewiesen  
**Testlauf nach Modul 006:** nicht nachgewiesen  
**Testdeklarationen laut Quellstand:** 45

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
| 006 | Untersuchungsphase | implementiert; Laufzeitabnahme offen | Hash offen | F-06/F-07 implementiert; AK-06/AK-07 Laufzeitnachweis offen |
| 007 | Räumliche Interaktionsgrundlagen | als Nächstes | – | F-10 |
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

## Abschlussstand Modul 005

### Technische Pipeline

Modul 005 ergänzte:

- `Ticket.monsterAssetId`,
- vier neutrale IDs `monster01` bis `monster04`,
- vollständiges Ticket-Monster-Mapping,
- `MonsterAssetProvider.loadMonster(assetID:)`,
- typisierte Ladefehler,
- lokale USDA-Platzhalter,
- `spawning`-Logging.

Der Modul-006-Preflight bestätigt den tatsächlichen Modul-005-Commit als:

`68b84f3 feat:Modul005`

### Weiterhin offene Muss-Anforderung

Die vier USDA-Kugeln sind technische Platzhalter und keine finalen eigenen Blender-Monster. F-14/AK-14 bleiben deshalb teilweise offen.

## Eingearbeiteter Stand Modul 006

### Ergebnis

Modul 006 implementiert die Untersuchungsphase auf Basis von `SessionModel.currentTicket`.

Neu beziehungsweise geändert wurden:

- `InvestigationView`,
- `.untersuchen`-Routing in `RootVolumeView`,
- `SessionModel.beginPrioritizationPhase()`,
- sieben neue deutsche Lokalisierungsschlüssel,
- fünf neue Layoutwerte,
- kontrollierte Umlautkorrekturen in den Tickettexten,
- sieben neue Tests in `InvestigationPhaseTests`.

### Untersuchungsansicht

Die neue `InvestigationView` zeigt laut Report:

- Monster des aktiven Tickets,
- Ticketnummer,
- Titel,
- Kurzbeschreibung,
- Auswirkung,
- alle 1 bis 3 Symptome beziehungsweise Hinweise,
- Schaltfläche „Weiter zur Priorisierung“.

Die Daten stammen ausschließlich aus `SessionModel.currentTicket`.

Nicht angezeigt werden:

- `referencePriority`,
- `referenceTeam`,
- `monsterAssetId` als sichtbarer Nutzertext.

Bei fehlendem aktuellen Ticket beziehungsweise fehlgeschlagenem Monsterladen existieren lokale Fehler-/Fallbacktexte.

### Monsterdarstellung

Die View nutzt direkt die bestehende Modul-005-Schnittstelle:

`MonsterAssetProvider.loadMonster(assetID:)`

Der aktuelle Stand verwendet weiterhin die vier USDA-Kugel-Platzhalter. Es wurden keine neuen Blender-Modelle erzeugt und keine Gesteninteraktion ergänzt.

Die berichtete Monster-Skalierung ist ohne Simulator noch ungeprüft.

### Phasenwechsel

`SessionModel` wurde um `beginPrioritizationPhase()` ergänzt.

Gemeldete Semantik:

- gültig nur aus `.untersuchen`,
- setzt die Phase auf `.priorisieren`,
- verändert `currentTicketIndex` nicht,
- verändert `currentTicket` nicht,
- speichert keine Prioritätsentscheidung,
- `selectedPriority` bleibt `nil`,
- ungültiger Aufruf aus einer anderen Phase wird ignoriert.

Nach dem Wechsel zeigt `RootVolumeView` weiterhin nur den neutralen Platzhalter für die noch nicht implementierte Priorisierungsphase.

### Tickettextqualität

Alle zwölf Tickets wurden auf technische Umschreibungen wie `ae`, `oe`, `ue` geprüft und kontrolliert bereinigt.

Der Report nennt unter anderem Korrekturen wie:

- `koennen` → `können`,
- `oeffnen` → `öffnen`,
- `Buero-Netz` → `Büro-Netz`,
- `regelmaessig` → `regelmäßig`,
- `Arbeitsplaetze` → `Arbeitsplätze`,
- `laesst` → `lässt`,
- `Auftraege` → `Aufträge`,
- `stuerzt` → `stürzt`,
- `Verkaeufe` → `Verkäufe`,
- `zuverlaessig` → `zuverlässig`,
- `eingeschraenkt` → `eingeschränkt`.

Die Liste im 006-Report ist ausdrücklich nur eine Auswahl. Fachliche Referenzwerte und Monsterzuordnung blieben unverändert:

- `referencePriority` unverändert,
- `referenceTeam` unverändert,
- `monsterAssetId` unverändert,
- vollständige 4×3-Team-Prioritäts-Verteilung unverändert.

## Bewertung von F-06 / F-07 / AK-06 / AK-07

### Implementierungsstand

Laut Code-Review und Report sind umgesetzt:

- F-06: Untersuchungsansicht mit Monster und allen geforderten Ticketinformationen,
- F-07: „Weiter zur Priorisierung“,
- AK-06: Daten stammen aus `currentTicket`; Referenzlösung wird nicht angezeigt,
- AK-07: kontrollierter Phasenwechsel, gleicher Ticketindex, keine Prioritätsentscheidung.

### Verifikationsstand

Diese Kriterien werden im Projektlogbuch noch nicht als vollständig laufzeitverifiziert geführt.

Begründung:

- kein Xcode-Build nach Modul 006 nachgewiesen,
- kein Testlauf nach Modul 006 ausgeführt,
- kein Simulatorlauf nach Modul 006 ausgeführt,
- Monster-Sichtbarkeit und Layout wurden nicht real geprüft.

Daher gilt:

- **F-06/F-07: implementiert.**
- **AK-06/AK-07: code- und testseitig vorbereitet, Laufzeitverifikation offen.**

## Teststand

Der 006-Report löst die Testzahl aus Modul 005 auf:

- tatsächlicher Stand vor Modul 006: 38 Testdeklarationen,
- neue Tests in Modul 006: 7,
- gemeldeter Quellstand nach Modul 006: 45 Testdeklarationen.

Neue Tests:

1. Phasenwechsel `.untersuchen → .priorisieren`
2. Ticketindex bleibt unverändert
3. `currentTicket` bleibt gleich
4. `selectedPriority` bleibt `nil`
5. ungültiger Phasenaufruf wird ignoriert
6. `currentTicket` enthält vollständige Untersuchungsdaten
7. alle Katalogtickets enthalten 1 bis 3 Symptome

**Wichtig:** Die 45 Tests wurden im Modul-Chat nicht ausgeführt.

## Neue Lokalisierungsschlüssel

| Schlüssel | Deutscher Wert |
|---|---|
| `investigation.button.nextPhase` | `Weiter zur Priorisierung` |
| `investigation.userImpact.label` | `Auswirkung` |
| `investigation.symptoms.label` | `Symptome und Hinweise` |
| `investigation.ticketNumber.label` | `Ticketnummer ` |
| `investigation.loading.monster` | `Monster wird geladen …` |
| `investigation.error.monsterLoad` | `Monster konnte nicht geladen werden.` |
| `investigation.error.noTicket` | `Kein aktives Ticket.` |

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
| 003 | `GamePhase` | `Models/GamePhase.swift` | Spielphasen |
| 003 | `SessionModel` | `Models/SessionModel.swift` | zentrale Sitzungsquelle |
| 003 | `SessionModel.startSession(using:)` | `Models/SessionModel.swift` | Sitzung starten |
| 003 | `SessionModel.currentTicket` | `Models/SessionModel.swift` | aktuelles Ticket |
| 003 | `SessionModel.currentPhase` | `Models/SessionModel.swift` | aktuelle Phase |
| 004 | `StartView` | `Views/StartView.swift` | Startansicht |
| 004 | `SessionModel` via Environment | App-/View-Baum | gemeinsame Zustandsquelle |
| 005 | `Ticket.monsterAssetId` | `Models/Ticket.swift` | Monsterzuordnung |
| 005 | `AssetKeys.Monster.allIDs` | `Support/AppConstants.swift` | Monster-ID-Liste |
| 005 | `MonsterAssetProvider.loadMonster(assetID:)` | `Assets/MonsterAssetProvider.swift` | lokales Monsterladen |
| 005 | `MonsterAssetProvider.LoadError` | `Assets/MonsterAssetProvider.swift` | typisierte Ladefehler |
| 006 | `InvestigationView` | `Views/InvestigationView.swift` | Untersuchungsphase |
| 006 | `SessionModel.beginPrioritizationPhase()` | `Models/SessionModel.swift` | kontrollierter Wechsel `.untersuchen → .priorisieren` |

## DebugManager nach Modul 006

Keine neue Kategorie.

Verwendet werden:

- `.lifecycle`: Erscheinen der Untersuchungsansicht,
- `.input`: „Weiter zur Priorisierung“,
- `.state`: erfolgreicher beziehungsweise ignorierter Phasenwechsel,
- `.spawning`: bestehendes Monster-Laden.

Keine vollständigen Tickettexte werden geloggt.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Dokumentationsstruktur und Single-Stand-Prinzip verbindlich. | Historie liegt in Git. |
| 2026-07-15 | Genau eine volumetrische `WindowGroup`. | F-05 ohne zweites Volume oder Immersive Space. |
| 2026-08-05 | `SessionModel` ist einzige Quelle des aktuellen Spielzustands. | Konkurrenzzustände vermeiden. |
| 2026-08-09 | Genau eine `SessionModel`-Instanz wird über SwiftUI Environment geteilt. | Einfache SwiftUI-Observation-Lösung. |
| 2026-08-09 | `monsterAssetId` ist direkt Teil von `Ticket`. | Entspricht der SPEC-Architekturskizze. |
| 2026-08-09 | USDA-Kugeln bleiben reine technische Platzhalter. | Vier eigene Blender-Monster fehlen weiterhin. |
| 2026-08-09 | `beginPrioritizationPhase()` wird als kleine, phasengebundene Modellmutation ergänzt. | Modul 006 benötigt nur den Übergang zur nächsten Phase; keine allgemeine State-Machine nötig. |
| 2026-08-09 | Tickettexte werden vor ihrer ersten sichtbaren Nutzung auf korrekte deutsche Umlaute bereinigt. | UI-Sprache ist verbindlich Deutsch; Referenzwerte bleiben unangetastet. |
| 2026-08-09 | F-06/F-07 werden als implementiert, AK-06/AK-07 aber noch nicht als laufzeitverifiziert geführt. | Build, Tests und Simulator wurden nicht ausgeführt. |
| 2026-08-09 | Modul 007 bleibt der nächste Schritt. | Die verbindliche Modul-Landkarte ordnet räumliche Interaktionsgrundlagen Modul 007 zu; Modul 008 folgt erst danach. |

## Offene Punkte / Risiken

### Vor oder zu Beginn von Modul 007

- [ ] aktuellen Branch und Commit prüfen,
- [ ] Modul-006-Commit/Hash eintragen,
- [ ] App lokal in Xcode bauen,
- [ ] visionOS-Simulator starten,
- [ ] alle 45 Testdeklarationen ausführen,
- [ ] AK-01 aus Modul 004 nachprüfen,
- [ ] AK-06/AK-07 im Simulator prüfen,
- [ ] Monsterladen der vier USDA-Platzhalter real prüfen,
- [ ] Monstergröße und Position in `InvestigationView` prüfen.

### Modul 005 weiterhin offen

- [ ] vier eigene Blender-Quelldateien,
- [ ] vier finale RealityKit-kompatible Exporte,
- [ ] Export-/Lizenzdokumentation,
- [ ] Skalierung/Orientierung finaler Assets,
- [ ] Darstellung aller vier finalen Monster,
- [ ] vollständige Gestenprüfung ab Modul 007.

### Projektweite offene Punkte

- [ ] drei bekannte `.DS_Store`-Dateien später kontrolliert bereinigen,
- [ ] Audiodateien und Rechte für Modul 010 vorbereiten,
- [ ] Apple-Vision-Pro-Zeitfenster für Modul 013 sichern,
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

`monsterAssetId`, neutrale Asset-IDs, Katalogzuordnung und `MonsterAssetProvider` implementiert. Vier USDA-Kugeln bilden die Pipeline technisch ab; finale Blender-Monster fehlen.

### Modul 006 — Untersuchungsphase

`InvestigationView` zeigt das aktive Ticket und lädt das zugeordnete Monster über `MonsterAssetProvider`. `beginPrioritizationPhase()` wechselt kontrolliert zum selben Ticket in `.priorisieren`. Die Tickettexte wurden sprachlich bereinigt, ohne Referenzwerte oder Monsterzuordnung zu verändern. Der Quellstand enthält laut Report 45 Testdeklarationen, aber noch keinen ausgeführten Build-, Test- oder Simulatornachweis.

## Nächster Schritt

`007-Eingangsprompt.md` in einen neuen Modul-Chat geben.

Modul 007 implementiert ausschließlich die wiederverwendbaren räumlichen Interaktionsgrundlagen für das Monster: Blickfokus, Pinch/Greifen, räumliches Bewegen, generische Zielbereiche, ungültiges Ablegen und Eingabesperre.

Prioritätswerte und konkrete Prioritätsziele gehören weiterhin Modul 008; Teamstationen gehören Modul 009.
