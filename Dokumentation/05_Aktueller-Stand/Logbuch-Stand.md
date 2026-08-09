# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` unter `Dokumentation/05_Aktueller-Stand/` ersetzt.

**Stand:** nach Modul `009` — Teamzuordnungsphase  
**Eingearbeitet am:** 2026-08-09  
**Branch laut 009-Report:** `main`  
**Modul-008-Hauptcommit:** `200093b 008: Priorisierungsphase`  
**Modul-008-Fix bestätigt:** `b716ed1 feat:Modul008`  
**Dokumentationscommit danach:** `7b873b7 feat: update docs module 008`  
**Modul-009-Commit:** noch nicht bekannt  
**Build nach Modul 009:** nicht nachgewiesen  
**Simulatorstart nach Modul 009:** nicht nachgewiesen  
**Vollständiger Testlauf nach Modul 009:** nicht nachgewiesen  
**Testdeklarationen laut Quellstand:** 110

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine Sitzung mit 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, anhand einer deutschen Ticketkarte untersucht, per Blickfokus, Pinch und Drag priorisiert und anschließend einem Support-Team zugeordnet.

Die Anwendung läuft linear in genau einem zentralen volumetrischen Fenster. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug. Nach einer gültigen Entscheidung erfolgt ausschließlich akustisches Richtig-/Falsch-Feedback; die richtige Lösung wird nicht angezeigt. Nach ungefähr 1,5 Sekunden wird automatisch zum nächsten fachlichen Zustand gewechselt. Am Ende erscheinen nur die Gesamtpunktzahl und „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Feedback-Sounds, ein vollständiger Sitzungsreset und ein stabiler Ablauf ohne Backend, Benutzerkonten, Datenbank, Cloud, persistente Spielhistorie, zweites Fenster beziehungsweise Volume, Immersive Space, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | technisch abgeschlossen | ursprünglicher Hash nicht abschließend rekonstruiert | F-05 strukturell teilweise |
| 002 | Ticketdatenmodell und lokaler Katalog | implementiert | `2775041` | F-02, F-03 |
| 003 | Sitzungsmodell und Zufallsauswahl | implementiert | `dd78700` | F-04 modellseitig; F-16 modellseitig teilweise |
| 004 | Startansicht und Einstellungen | implementiert | `84bb767` | F-01 implementiert |
| 005 | Monster-Asset-Pipeline | teilweise abgeschlossen | `68b84f3` | Pipeline/Mapping implementiert; finale Blender-Assets offen |
| 006 | Untersuchungsphase | implementiert | `177e2b9` | F-06/F-07 implementiert |
| 007 | Räumliche Interaktionsgrundlagen | implementiert; Laufzeitabnahme offen | Hash nicht im 009-Report genannt | F-10 generisch implementiert |
| 008 | Priorisierungsphase | implementiert; Gestenabnahme offen | `200093b` + `b716ed1` | F-08 implementiert; AK-08 Laufzeitnachweis offen |
| 009 | Teamzuordnungsphase | implementiert; Laufzeitabnahme offen | Hash offen | F-09 implementiert; AK-09 Laufzeitnachweis offen |
| 010 | Bewertung und Audiofeedback | als Nächstes | – | F-11, F-12, F-13 |
| 011 | Ergebnis und Neustart | offen | – | F-15, F-16 |
| 012 | Optionale Monsterreaktion | offen, Kann-Modul | – | F-17 |
| 013 | Integration und Gerätetest | offen | – | F-01 bis F-16 als Integrationstest |
| 014 | Abschlussmodul: Doku & Cleanup | offen | – | Dokumentenkonsistenz und Abgabeprüfung |

## Abschlussstand Module 001–008

### Modul 001

Grundgerüst mit genau einem zentralen volumetrischen Fenster, DebugManager, Constants, Lokalisierung und Smoke-Test eingerichtet.

### Modul 002

`TicketPriority`, `SupportTeam`, `Ticket` und genau zwölf lokale Support-Tickets mit vollständiger 4×3-Verteilung eingerichtet.

### Modul 003

`GamePhase` und `SessionModel` mit Auswahl ohne Wiederholung, aktuellem Ticket, Index und Reset eingerichtet.

### Modul 004

Deutsche Startansicht mit Ticketregler und „Spiel starten“ implementiert; eine `SessionModel`-Instanz wird über SwiftUI Environment geteilt.

### Modul 005

`monsterAssetId`, vier neutrale Monster-IDs, Ticket-Mapping und `MonsterAssetProvider` implementiert. Die vier USDA-Kugeln sind weiterhin technische Platzhalter; finale eigene Blender-Monster fehlen.

### Modul 006

`InvestigationView` und `beginPrioritizationPhase()` implementiert. Tickettexte wurden auf korrekte Umlaute bereinigt.

### Modul 007

Generische räumliche Interaktionsgrundlage mit `DropTargetComponent`, `MonsterInteractionConfigurator`, `DropEvaluator`, Input-Lock und DEBUG-Harness implementiert.

### Modul 008

`PrioritizationView`, drei Prioritätsziele und `SessionModel.savePriority(_:)` implementiert. Der nachträgliche Sichtbarkeits-Fix ist jetzt als Commit `b716ed1 feat:Modul008` bestätigt. Prioritätslabels werden als SwiftUI-Overlay dargestellt; die Zielkugeln sind mit höherer Opacity sichtbar.

## Eingearbeiteter Stand Modul 009

### Ergebnis

Modul 009 implementiert die Teamzuordnungsphase für `GamePhase.teamZuordnen`.

Neu beziehungsweise geändert wurden:

- `Views/TeamAssignmentView.swift`,
- `SessionModel.beginTeamAssignmentPhase()`,
- `SessionModel.saveTeam(_:)`,
- `TeamAssignmentConstants`,
- echtes `.teamZuordnen`-Routing in `RootVolumeView`,
- DEBUG-only Team-Zugang in `PrioritizationView`,
- 24 neue Tests in `TeamAssignmentPhaseTests`.

### Vier Teamstationen

Genau vier technische Zieldefinitionen sind vorhanden:

| technische ID | sichtbare Bezeichnung | gespeicherter Wert | Position |
|---|---|---|---|
| `team_netzwerk` | Netzwerk | `.netzwerk` | (-0.24, +0.16, 0) |
| `team_konto` | Konto | `.konto` | (+0.24, +0.16, 0) |
| `team_software` | Software | `.software` | (-0.24, -0.16, 0) |
| `team_hardware` | Hardware | `.hardware` | (+0.24, -0.16, 0) |

Die Stationen liegen laut Report in einem 2×2-Layout. Der minimale Abstand benachbarter Stationen beträgt 0,32 m und liegt damit knapp über dem doppelten gemeldeten Drop-Radius von 0,15 m.

### TeamTargetMapping

`TeamAssignmentView` kapselt die vier technischen Zieldefinitionen in einem zentralen Mapping.

Die fachliche Zuordnung lautet:

- `team_netzwerk` → `.netzwerk`
- `team_konto` → `.konto`
- `team_software` → `.software`
- `team_hardware` → `.hardware`

Es wurde keine zweite Drag-/Drop-Infrastruktur aufgebaut.

### `beginTeamAssignmentPhase()`

Neue SessionModel-Schnittstelle mit folgender berichteter Semantik:

Vorbedingungen:

- `currentPhase == .priorisieren`,
- `selectedPriority != nil`.

Effekte:

- `currentPhase = .teamZuordnen`,
- `isInputLocked = false`.

Unverändert:

- `score`,
- `currentTicketIndex`,
- `selectedPriority`,
- `selectedTeam` bleibt `nil`.

No-Op:

- falsche Phase,
- keine gespeicherte Priorität.

### Kein automatischer Übergang in Modul 009

`beginTeamAssignmentPhase()` wird im normalen Release-Spielablauf noch nicht automatisch aufgerufen.

Das ist beabsichtigt und hält F-13 bei Modul 010.

Vor Modul 010 erfolgt der Development-Zugang ausschließlich über einen `#if DEBUG`-Button in `PrioritizationView`, der nach gespeicherter Priorität erscheint:

`🔧 Team [DEV]`

Dieser Button:

- existiert nur im DEBUG-Build,
- ist keine F-09-Benutzerfunktion,
- ist im Release-Build nicht vorhanden,
- dient nur zur manuellen Prüfung von `TeamAssignmentView`.

### `saveTeam(_:)`

Neue SessionModel-Schnittstelle:

`saveTeam(_ team: SupportTeam)`

Vorbedingungen:

- `currentPhase == .teamZuordnen`,
- `selectedTeam == nil`,
- `isInputLocked == false`.

Effekte:

- `selectedTeam = team`,
- `lockInput()` → `isInputLocked = true`.

Unverändert:

- `selectedPriority`,
- `score`,
- `currentTicketIndex`,
- `currentPhase == .teamZuordnen`.

No-Op:

- falsche Phase,
- Team bereits gesetzt,
- Eingabe bereits gesperrt.

### Ungültiger Drop

Bei ungültigem Teamdrop:

- kein Team wird gespeichert,
- kein Input-Lock,
- Priorität bleibt erhalten,
- Score bleibt unverändert,
- Phase bleibt `.teamZuordnen`,
- Ticketindex bleibt unverändert,
- Monster kehrt zur Ausgangsposition zurück.

### Kein Abschluss nach Teamdrop

Nach gültigem Teamdrop bleibt die Phase in Modul 009 `.teamZuordnen`.

Nicht implementiert wurden:

- Bewertung,
- Punkte,
- Sound,
- Anzeige der richtigen Lösung,
- automatische 1,5-Sekunden-Weiterleitung,
- automatischer Wechsel zum nächsten Ticket,
- Ergebnisansicht.

Der weitere Ablauf wird in Modul 010 aufgebaut.

## Wichtige Scope-Korrektur für Modul 010

Die Empfehlung im 009-Report nennt als möglichen Punkt „Anzeige der richtigen Lösung“.

Das widerspricht dem verbindlichen Projektumfang.

**Verbindlich ist:**

- richtig/falsch wird ausschließlich über einen von zwei lokalen Sounds zurückgemeldet,
- die richtige Priorität beziehungsweise das richtige Team wird nicht angezeigt,
- keine Lösungserklärung,
- kein Text wie „Richtig wäre …“,
- kein visuelles Lösungs-Overlay.

Modul 010 darf daher die richtige Lösung **nicht** anzeigen.

## Bewertung F-09 / AK-09

### Implementiert

- vier räumliche Teamstationen,
- vier deutsche Labels,
- Monster-Drag/-Drop über bestehende Interaktionsgrundlage,
- Mapping Ziel → `SupportTeam`,
- genau einmalige Teamspeicherung,
- Input-Lock nach gültigem Drop,
- zweiter Teamversuch wird ignoriert.

### Noch nicht laufzeitverifiziert

- `TeamAssignmentView` im Simulator sichtbar,
- Netzwerk-Drop,
- Konto-Drop,
- Software-Drop,
- Hardware-Drop,
- Invalid-Drop,
- Lock,
- erneutes Ziehen während Lock,
- Lesbarkeit aller Labels.

Daher:

- **F-09: implementiert.**
- **AK-09: modell- und strukturseitig implementiert; vollständige manuelle Laufzeitabnahme offen.**

## Bewertung AK-10 nach Modul 009

Prioritäts- und Teamanteil sind nun im Code vorhanden:

- ungültiger Drop → keine fachliche Entscheidung,
- gültiger Drop → genau eine Entscheidung,
- Input-Lock nach gültigem Drop,
- weitere Gesten während Lock werden ignoriert.

Offen bleibt die vollständige manuelle Gesture-Kette im Simulator beziehungsweise später auf Gerät.

Damit:

- **AK-10 fachlich implementiert,**
- **AK-10 Laufzeitabnahme offen.**

## Teststand

| Bereich | Stand |
|---|---:|
| Testdeklarationen vor Modul 009 | 86 |
| neue `TeamAssignmentPhaseTests` | 24 |
| **Testdeklarationen nach Modul 009** | **110** |
| vollständiger Testlauf | nicht nachgewiesen |

Die Zahl 110 ist als Quellcode-/Deklarationsstand berichtet, nicht als bestandener Testlauf.

## Schnittstellen-Register

| Modul | Schnittstelle | Zweck |
|---|---|---|
| 003 | `SessionModel.currentPhase` | aktive Phase |
| 003 | `SessionModel.currentTicket` | aktuelles Ticket |
| 003 | `SessionModel.currentTicketIndex` | Ticketindex |
| 003 | `SessionModel.score` | Punktestand |
| 003 | `SessionModel.selectedPriority` | Prioritätsentscheidung |
| 003 | `SessionModel.selectedTeam` | Teamentscheidung |
| 005 | `Ticket.monsterAssetId` | Monster-ID |
| 005 | `MonsterAssetProvider.loadMonster(assetID:)` | lokales Monsterladen |
| 006 | `SessionModel.beginPrioritizationPhase()` | `.untersuchen → .priorisieren` |
| 007 | `DropTargetComponent` | generisches Drop-Ziel |
| 007 | `MonsterInteractionConfigurator` | Interaktionskonfiguration |
| 007 | `DropEvaluator` | Drop-Auswertung |
| 007 | `SessionModel.lockInput()` | Input sperren |
| 007 | `SessionModel.unlockInput()` | Input freigeben |
| 008 | `SessionModel.savePriority(_:)` | Priorität genau einmal speichern |
| 008 | `PriorityTargetMapping` | Prioritätsziel-Mapping |
| 008 | `PrioritizationView` | Priorisierungsansicht |
| 009 | `SessionModel.beginTeamAssignmentPhase()` | kontrollierter Wechsel zur Teamphase |
| 009 | `SessionModel.saveTeam(_:)` | Team genau einmal speichern |
| 009 | `TeamTargetMapping` | Teamziel-Mapping |
| 009 | `TeamAssignmentView` | Teamzuordnungsansicht |
| 009 | `TeamAssignmentConstants` | Teamstationspositionen |

## DebugManager nach Modul 009

Keine neue Kategorie.

Verwendet werden:

- `.spawning`: Teamstationen und Monster,
- `.input`: Drag-/Release-Ereignisse beziehungsweise Lock-Abweisung,
- `.physics`: gültiger/ungültiger Drop und Ziel-ID,
- `.state`: Phasenwechsel, Team gespeichert, Lock und DEBUG-Zugang.

Nicht geloggt werden:

- `referenceTeam`,
- ob eine Entscheidung richtig oder falsch war.

Diese Bewertung folgt Modul 010.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Dokumentationsstruktur und Single-Stand-Prinzip verbindlich. | Historie liegt in Git. |
| 2026-07-15 | Genau eine volumetrische `WindowGroup`. | F-05. |
| 2026-08-05 | `SessionModel` ist einzige Quelle des Sitzungszustands. | Konkurrenzzustände vermeiden. |
| 2026-08-09 | USDA-Kugeln bleiben reine technische Platzhalter. | Finale Blender-Monster fehlen. |
| 2026-08-09 | Generische Drag-/Drop-Logik wird aus Modul 007 wiederverwendet. | Keine zweite Interaktionsarchitektur. |
| 2026-08-09 | `savePriority(_:)` speichert atomar und sperrt Input. | Genau-einmal-Semantik. |
| 2026-08-09 | 008-Sichtbarkeits-Fix ist mit `b716ed1` bestätigt. | Der zuvor offene Fix ist nun versioniert. |
| 2026-08-09 | `saveTeam(_:)` spiegelt das atomare Speichermuster der Priorität. | Einheitliche Entscheidungssemantik. |
| 2026-08-09 | `beginTeamAssignmentPhase()` wird in Modul 009 nicht automatisch ausgelöst. | F-13 gehört Modul 010. |
| 2026-08-09 | DEBUG-Teamzugang ist zulässig, aber keine Release-Nutzerfunktion. | Teamphase kann vor Modul 010 manuell geprüft werden. |
| 2026-08-09 | Nach gültigem Teamdrop bleibt die Phase `.teamZuordnen`. | Bewertung und automatischer Folgeübergang fehlen noch. |
| 2026-08-09 | Modul 010 darf die richtige Lösung nicht anzeigen. | Projektumfang schreibt ausschließlich Soundfeedback ohne Lösung/Erklärung vor. |

## Offene Punkte / Risiken

### Vor oder zu Beginn von Modul 010

- [ ] aktuellen Branch und Commit prüfen,
- [ ] Modul-009-Commit/Hash dokumentieren,
- [ ] App nach Modul 009 bauen,
- [ ] Simulator starten,
- [ ] vollständige Suite mit 110 Tests ausführen,
- [ ] AK-08-Gesten nachprüfen,
- [ ] AK-09-Gesten prüfen,
- [ ] AK-10 vollständig in der Prioritäts- und Teamphase prüfen,
- [ ] DEBUG-Teamzugang prüfen,
- [ ] sicherstellen, dass der 008-Fix weiterhin sichtbar ist.

### Audio für Modul 010

- [ ] vorhandene lokale Audiodateien inventarisieren,
- [ ] genau einen Richtig-Sound und einen Falsch-Sound bereitstellen,
- [ ] Dateiformat, Rechte/Urheberschaft und Bundle-Zugehörigkeit dokumentieren,
- [ ] Lautstärke und Abspielbarkeit im visionOS-Simulator prüfen.

Wenn noch keine Dateien vorhanden sind, darf Modul 010 keine fremden Internet-Audios stillschweigend herunterladen oder lizenzrechtlich unklare Sounds einbinden.

### Modul 005 weiterhin offen

- [ ] vier eigene Blender-Quelldateien,
- [ ] vier finale RealityKit-kompatible Exporte,
- [ ] Export-/Lizenzdokumentation,
- [ ] finale Assetdarstellung.

### Projektweit

- [ ] `.DS_Store`-Bereinigung,
- [ ] Apple-Vision-Pro-Zeitfenster für Modul 013,
- [ ] F-17 erst nach Muss-Funktionen entscheiden.

## Chronik

### Module 001–008

Grundgerüst, Ticketdaten, Sitzung, Startansicht, Monster-Pipeline, Untersuchungsphase, generische Interaktion und Priorisierung wurden schrittweise implementiert.

### Modul 009 — Teamzuordnungsphase

`TeamAssignmentView` ergänzt vier räumliche Teamstationen in einem 2×2-Layout. `beginTeamAssignmentPhase()` erlaubt kontrollierten Eintritt in die Teamphase; `saveTeam(_:)` speichert genau eine Teamentscheidung und sperrt den Input. Ein DEBUG-only Button ermöglicht die manuelle Teamphasenprüfung, solange Modul 010 den automatischen Übergang noch nicht implementiert. Der Quellstand enthält 110 Testdeklarationen, aber Build, Testlauf und Simulatorabnahme nach Modul 009 sind noch offen.

## Nächster Schritt

`010-Eingangsprompt.md` in einen neuen Modul-Chat geben.

Modul 010 implementiert ausschließlich:

- Bewertung der gespeicherten Prioritätsentscheidung,
- Bewertung der gespeicherten Teamentscheidung,
- +100 Punkte je richtiger Teilentscheidung, 0 bei falsch, kein Abzug,
- zwei lokale Sounds: richtig / falsch,
- keine Anzeige der richtigen Lösung,
- Input bleibt während Feedback gesperrt,
- automatischer Übergang nach ungefähr 1,5 Sekunden:
  - nach Prioritätsfeedback → `.teamZuordnen`,
  - nach Teamfeedback → nächstes Ticket in `.untersuchen` oder nach letztem Ticket `.ergebnis`.

Die Ergebnisansicht selbst und „Erneut spielen“ bleiben Modul 011.
