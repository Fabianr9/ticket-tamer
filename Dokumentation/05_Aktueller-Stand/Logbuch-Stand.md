# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `008` — Priorisierungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut 008-Report:** `main`  
**Commit Modul 008:** `200093b 008: Priorisierungsphase`  
**Nachträglicher Fix-Commit:** noch ausstehend  
**Fix-Nachricht:** `008-fix: Kugeln sichtbar (Farbe + Opacity), Labels als ZStack-Overlay`  
**Build nach Modul 008:** bestätigt  
**Simulatorstart:** bestätigt  
**Vollständiger Testlauf:** nicht nachgewiesen  
**Testdeklarationen laut Quellstand:** 86  
**Manuelle Gestenabnahme AK-08/AK-10:** offen

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
| 004 | Startansicht und Einstellungen | implementiert; frühere Laufzeitabnahme teilweise nachgeholt | `84bb767` | F-01 implementiert |
| 005 | Monster-Asset-Pipeline | teilweise abgeschlossen | `68b84f3` | Pipeline/Mapping implementiert; finale Blender-Assets offen |
| 006 | Untersuchungsphase | implementiert; sichtbarer Simulatorstand inzwischen bestätigt | `177e2b9` | F-06/F-07 implementiert |
| 007 | Räumliche Interaktionsgrundlagen | implementiert; Gestenabnahme offen | Hash im 008-Report nicht genannt | F-10 generisch implementiert |
| 008 | Priorisierungsphase | implementiert; Gestenabnahme und Fix-Commit offen | `200093b` + Fix ausstehend | F-08 implementiert; AK-08 Laufzeitnachweis offen |
| 009 | Teamzuordnungsphase | als Nächstes | – | F-09 |
| 010 | Bewertung und Audiofeedback | offen | – | F-11, F-12, F-13 |
| 011 | Ergebnis und Neustart | offen | – | F-15, F-16 |
| 012 | Optionale Monsterreaktion | offen, Kann-Modul | – | F-17 |
| 013 | Integration und Gerätetest | offen | – | F-01 bis F-16 als Integrationstest |
| 014 | Abschlussmodul: Doku & Cleanup | offen | – | Dokumentenkonsistenz und Abgabeprüfung |

## Abschlussstand Module 001–007

### Modul 001

Grundgerüst, genau ein zentrales Volume, DebugManager, Constants, Lokalisierung und Smoke-Test eingerichtet.

### Modul 002

`TicketPriority`, `SupportTeam`, `Ticket` und genau zwölf lokale Support-Tickets mit vollständiger 4×3-Verteilung eingerichtet.

### Modul 003

`GamePhase` und `SessionModel` mit Auswahl ohne Wiederholung, aktuellem Ticket, Index und Reset eingerichtet.

### Modul 004

Deutsche Startansicht mit Ticketregler und „Spiel starten“ implementiert; eine `SessionModel`-Instanz wird über SwiftUI Environment geteilt.

### Modul 005

`monsterAssetId`, vier neutrale Monster-IDs, Ticket-Mapping und `MonsterAssetProvider` implementiert. Vier USDA-Kugeln sind weiterhin technische Platzhalter; finale eigene Blender-Monster fehlen.

### Modul 006

`InvestigationView` und `beginPrioritizationPhase()` implementiert. Tickettexte wurden auf korrekte Umlaute bereinigt.

### Modul 007

Generische räumliche Interaktionsgrundlage mit `DropTargetComponent`, `MonsterInteractionConfigurator`, `DropEvaluator`, Input-Lock und DEBUG-Harness implementiert.

## Eingearbeiteter Stand Modul 008

### Ergebnis

Modul 008 implementiert die echte Priorisierungsphase für `GamePhase.priorisieren`.

Neu beziehungsweise geändert wurden:

- `Views/PrioritizationView.swift`,
- `SessionModel.savePriority(_:)`,
- echtes `.priorisieren`-Routing in `RootVolumeView`,
- `PrioritizationConstants`,
- `PriorityTargetMapping`,
- 22 neue Tests in `PrioritizationPhaseTests`.

Das DEBUG-Harness aus Modul 007 bleibt als Development-Datei erhalten, ist aber nicht mehr Teil des normalen `.priorisieren`-Routings.

### Drei Prioritätsziele

Genau drei technische Ziele sind definiert:

| Ziel-ID | sichtbare Bezeichnung | gespeicherter Wert |
|---|---|---|
| `priority_normal` | Normal | `.normal` |
| `priority_wichtig` | Wichtig | `.wichtig` |
| `priority_kritisch` | Kritisch | `.kritisch` |

Das Mapping ist zentral in `PriorityTargetMapping` gekapselt.

### Monsterinteraktion

`PrioritizationView` verwendet die vorhandenen Modul-007-Schnittstellen:

- `MonsterAssetProvider.loadMonster(assetID:)`,
- `MonsterInteractionConfigurator.configure(_:mode: .dragDrop)`,
- `DropEvaluator`,
- `DropTargetComponent`.

Es wurde keine zweite Drag-/Drop-Implementierung aufgebaut.

### Prioritätsspeicherung

Neue SessionModel-Methode:

`savePriority(_ priority: TicketPriority)`

Gemeldete Vorbedingungen:

- `currentPhase == .priorisieren`,
- `selectedPriority == nil`,
- `isInputLocked == false`.

Gemeldete Effekte:

- `selectedPriority = priority`,
- `lockInput()`.

Unverändert:

- `score`,
- `selectedTeam`,
- `currentTicketIndex`,
- `currentPhase`.

Die Speicherung und der Lock bilden damit einen atomaren fachlichen Vorgang.

### Ungültiger Drop

Bei ungültigem Drop:

- keine Priorität gespeichert,
- kein Input-Lock,
- kein Score,
- keine Phasenänderung,
- kein Ticketwechsel,
- Monster kehrt zur Ausgangsposition zurück.

### Kein automatischer Übergang

Nach gültiger Prioritätsentscheidung bleibt `currentPhase == .priorisieren`.

Das ist beabsichtigt: F-13 und der automatische Übergang nach ungefähr 1,5 Sekunden gehören verbindlich zu Modul 010.

Es wurde kein zusätzlicher Nutzer-Button erfunden.

## Nachträgliche visuelle Korrektur

Der erste Simulatorlauf deckte zwei reale UI-Probleme auf:

### Problem 1: Zielkugeln praktisch unsichtbar

Ursache laut Report:

- Material-Alpha 0,15 war im Simulator zu transparent.

Korrektur:

- prioritätsspezifische Farben,
- Opacity 0,55.

### Problem 2: Labels fehlten

Ursache laut Report:

- die verwendeten SwiftUI-Attachments erschienen im Simulator nicht zuverlässig.

Korrektur:

- Attachment-Code entfernt,
- Labels als SwiftUI-`ZStack`-/`HStack`-Overlay dargestellt,
- horizontale Zuordnung links / Mitte / rechts zu Normal / Wichtig / Kritisch.

Die fachliche Drop-, Lock- und Mapping-Logik blieb unverändert.

### Git-Status der Korrektur

Der Fix ist im beschriebenen Arbeitsstand implementiert, aber noch nicht als Commit mit Hash bestätigt.

Offener Commit:

`008-fix: Kugeln sichtbar (Farbe + Opacity), Labels als ZStack-Overlay`

Grund laut Report:

- `.git/index.lock` während paralleler Xcode-Git-Aktivität.

Der Projektstand darf daher den Fix nicht als bereits versioniert behandeln, bis der Commit tatsächlich vorliegt.

## Bewertung F-08 / AK-08

### Implementiert

- drei Prioritätsziele,
- drei deutsche Labels,
- Monster in `.dragDrop`,
- Mapping Ziel → `TicketPriority`,
- genau einmalige Speicherung,
- Lock nach gültigem Drop,
- keine zweite Prioritätsentscheidung.

### Laufzeitverifiziert

- App-Build bestätigt,
- Simulatorstart bestätigt,
- Startansicht sichtbar,
- Untersuchungsansicht sichtbar,
- Priorisierungsansicht sichtbar,
- visuelle Probleme im ersten Lauf erkannt.

### Noch offen

- Monster real auf `Normal` ziehen und `.normal` bestätigen,
- Monster real auf `Wichtig` ziehen und `.wichtig` bestätigen,
- Monster real auf `Kritisch` ziehen und `.kritisch` bestätigen,
- ungültigen Drop real prüfen,
- Input-Lock nach gültigem Drop real prüfen,
- erneutes Ziehen während Lock real prüfen.

Daher:

- **F-08: implementiert.**
- **AK-08: strukturell und modellseitig implementiert; vollständige manuelle Gestenabnahme offen.**

## Bewertung AK-10 — Prioritätsanteil

Implementiert:

- ungültiger Drop → kein Zustandswechsel,
- ungültiger Drop → Rückkehr,
- gültiger Drop → genau eine Priorität,
- gültiger Drop → Input-Lock,
- Mehrfachversuch → erste Entscheidung bleibt bestehen.

Offen:

- manuelle Laufzeitprüfung der Gesture-Kette.

Der Teamanteil von AK-10 folgt in Modul 009.

## Teststand

| Bereich | Stand |
|---|---:|
| Testdeklarationen vor Modul 008 | 64 |
| neue `PrioritizationPhaseTests` | 22 |
| **Testdeklarationen nach Modul 008** | **86** |
| vollständiger Testlauf | nicht nachgewiesen |

Die Zahl 86 ist als Quellcode-/Deklarationsstand bestätigt, nicht als bestandener Testlauf.

## Schnittstellen-Register

| Modul | Schnittstelle | Zweck |
|---|---|---|
| 003 | `SessionModel` | zentrale Sitzungsquelle |
| 003 | `SessionModel.currentPhase` | aktive Phase |
| 003 | `SessionModel.currentTicket` | aktuelles Ticket |
| 003 | `SessionModel.selectedPriority` | gespeicherte Prioritätsentscheidung |
| 003 | `SessionModel.selectedTeam` | spätere Teamentscheidung |
| 003 | `SessionModel.score` | späterer Punktestand |
| 005 | `Ticket.monsterAssetId` | Monster-ID |
| 005 | `MonsterAssetProvider.loadMonster(assetID:)` | lokales Monsterladen |
| 006 | `SessionModel.beginPrioritizationPhase()` | Wechsel `.untersuchen → .priorisieren` |
| 007 | `DropTargetComponent` | generisches Drop-Ziel |
| 007 | `MonsterInteractionConfigurator.configure(_:mode:)` | Interaktionskonfiguration |
| 007 | `DropEvaluator` | Drop-Auswertung |
| 007 | `SessionModel.lockInput()` | Input sperren |
| 007 | `SessionModel.unlockInput()` | Input freigeben |
| 008 | `SessionModel.savePriority(_:)` | Priorität genau einmal speichern + Lock |
| 008 | `PriorityTargetMapping` | Ziel-ID ↔ Priorität |
| 008 | `PrioritizationConstants` | Positionen der Prioritätsziele und des Monsters |
| 008 | `PrioritizationView` | fachliche Priorisierungsansicht |

## DebugManager nach Modul 008

Keine neue Kategorie.

Verwendet werden:

- `.spawning`: Monster und Ziel-Entities,
- `.input`: Drag-/Release-Ereignisse,
- `.physics`: gültige/ungültige Drop-Auswertung,
- `.state`: Priorität, Lock und Unlock-Entscheidung.

Referenzpriorität und richtige Lösung werden nicht geloggt.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Dokumentationsstruktur und Single-Stand-Prinzip verbindlich. | Historie liegt in Git. |
| 2026-07-15 | Genau eine volumetrische `WindowGroup`. | F-05. |
| 2026-08-05 | `SessionModel` ist einzige Quelle des Sitzungszustands. | Konkurrenzzustände vermeiden. |
| 2026-08-09 | Monster-IDs bleiben neutral; USDA-Dateien sind nur Platzhalter. | F-14 darf nicht abgeschwächt werden. |
| 2026-08-09 | Modul 007 stellt generische Drop- und Lock-Grundlage bereit. | Fachliche Ziele bleiben Folge-Modulen vorbehalten. |
| 2026-08-09 | Priorität wird über `savePriority(_:)` atomar mit Input-Lock gespeichert. | Genau-einmal-Semantik und `private(set)` bleiben kontrolliert. |
| 2026-08-09 | Priorisierungsziel-Mapping liegt zentral in `PriorityTargetMapping`. | Keine verteilten ID-Strings. |
| 2026-08-09 | Modul 008 führt keinen automatischen Wechsel zur Teamphase aus. | F-13 gehört Modul 010. |
| 2026-08-09 | Sichtbare Prioritätslabels werden als SwiftUI-Overlay statt RealityView-Attachments dargestellt. | Simulator zeigte die Attachments nicht zuverlässig. |
| 2026-08-09 | Der 008-Fix wird bis zum tatsächlichen Git-Commit als uncommitted Arbeitsstand geführt. | Hash fehlt und `.git/index.lock` blockierte den Commit. |
| 2026-08-09 | Modul 009 darf eine kontrollierte `beginTeamAssignmentPhase()`-Methode bereitstellen, aber sie nicht automatisch auslösen. | Teamphase muss implementier- und testbar sein; der automatische zeitgesteuerte Übergang bleibt Modul 010. |

## Offene Punkte / Risiken

### Vor oder zu Beginn von Modul 009

- [ ] 008-Fix tatsächlich committen und Hash dokumentieren,
- [ ] `.git/index.lock`-Problem prüfen/bereinigen,
- [ ] vollständige Test-Suite mit 86 Tests ausführen,
- [ ] Gestenprüfung AK-08 durchführen,
- [ ] Invalid-Drop und Input-Lock im Simulator prüfen,
- [ ] prüfen, ob die korrigierten Zielkugeln und Labels im aktuellen Commit sichtbar sind.

### Für Modul 009

- [ ] `saveTeam(_:)` nach demselben atomaren Muster wie `savePriority(_:)` ergänzen,
- [ ] vier Teamstationen implementieren,
- [ ] kontrollierten Übergang in `.teamZuordnen` bereitstellen, ohne F-13 vorwegzunehmen,
- [ ] DEBUG-/Development-Weg für manuelle Teamansicht-Prüfung festlegen, solange Modul 010 den normalen automatischen Übergang noch nicht ausführt.

### Modul 005 weiterhin offen

- [ ] vier eigene Blender-Quelldateien,
- [ ] vier finale RealityKit-kompatible Exporte,
- [ ] Export-/Lizenzdokumentation,
- [ ] finale Assetdarstellung.

### Projektweit

- [ ] `.DS_Store`-Bereinigung,
- [ ] zwei lokale Audioassets für Modul 010,
- [ ] Apple-Vision-Pro-Zeitfenster für Modul 013,
- [ ] F-17 erst nach Muss-Funktionen entscheiden.

## Chronik

### Modul 001–007

Grundgerüst, Ticketdaten, Sitzungsmodell, Startansicht, Monster-Pipeline, Untersuchungsphase und generische räumliche Interaktion wurden schrittweise eingerichtet.

### Modul 008 — Priorisierungsphase

`PrioritizationView` mit drei beschrifteten räumlichen Zielen wurde implementiert. `savePriority(_:)` speichert die Priorität genau einmal und sperrt die Eingabe. Build und Simulatorstart sind erstmals in diesem Modul ausdrücklich bestätigt. Der erste Simulatorlauf deckte zwei Darstellungsprobleme auf; Kugeltransparenz und Labeldarstellung wurden anschließend korrigiert. Die Korrektur ist noch nicht mit einem Git-Hash bestätigt. 86 Testdeklarationen sind vorhanden, ein vollständiger Testlauf und die manuelle Gestenabnahme stehen noch aus.

## Nächster Schritt

`009-Eingangsprompt.md` in einen neuen Modul-Chat geben.

Modul 009 implementiert ausschließlich die Teamzuordnungsphase mit vier beschrifteten Stationen `Netzwerk`, `Konto`, `Software`, `Hardware`, Wiederverwendung der Drag-/Drop-Grundlage und genau einmaligem Speichern von `selectedTeam`.

Bewertung, Punkte, Sounds und automatischer 1,5-Sekunden-Übergang bleiben Modul 010 vorbehalten.
