# Modul-Report — 019 Ladefehler-Recovery

> Vom Modul-Chat am 2026-09-02 erstellt. Modul 019 bearbeitet ausschließlich F-23 / AK-23.

## Zusammenfassung

Untersuchung, Priorisierung und Teamzuordnung zeigen nach einem Monster-Ladefehler nun die lokalisierte Aktion `Erneut laden`. Ein Retry verwendet erneut die `monsterAssetId` des aktuellen Tickets und verändert ausschließlich lokalen Lade-/Darstellungszustand. Fachlicher Sitzungszustand, Scoring, Bewertung, Audio, Feedback und Phasenwechsel werden nicht angesprochen.

## Vorab-Check

- Branch: `A`
- HEAD vor Modul 019: `de7e4d6` (`feat: Modul 18`)
- tatsächlicher, separater Modul-018-Commit: `de7e4d6`
- Working Tree vor 019: vorbereitete Änderungen an `Logbuch-Stand.md`, `Projekt-Stand.md` sowie untracked `019-Eingangsprompt.md`; kein offener Modul-018-Code
- Testdeklarationen vor 019: 278
- Xcode-Build, Testlauf und visionOS-Simulatorprüfung: in dieser Linux-Umgebung nicht ausführbar

## Reale Ladearchitektur vor Modul 019

| Phase | Monster-/Fehler-/Loading-State | Initial-Load | Einfügen | Zielpanels |
|---|---|---|---|---|
| Untersuchung | `monsterEntity`, eigener Bool und typisierter Fehler | `onAppear`, erneut bei Ticketindexänderung | `RealityView` fügt genau die geladene Entity ein | keine |
| Priorisierung | `monsterEntity`, Stringfehler; Loading indirekt aus nil/nil | `.task` → `setupScene()` | `RealityView.update` fügt Monster bei fehlender Scene ein | drei, zuvor im selben `setupScene()` erzeugt |
| Team | analog Priorisierung | `.task` → `setupScene()` | analog Priorisierung | vier, zuvor im selben `setupScene()` erzeugt |

Das technische Risiko lag in den beiden Drag-Phasen: Ein erneuter Aufruf des gesamten Szenenaufbaus hätte neue Zielpanels angelegt.

## Retry-Architektur

`MonsterLoadRecovery` ist eine kleine lokale State-Machine mit `idle`, `loading`, `loaded` und `failed`. Sie:

- löscht beim Start eines neuen Versuchs den vorherigen Fehlerstatus,
- merkt die angefragte Asset-ID,
- weist einen zweiten parallelen Start ab,
- bildet nach Erfolg genau ein dargestelltes Monster ab,
- setzt kein Retry-Limit,
- importiert und kennt `SessionModel` nicht.

Die Views behalten die geladene `Entity` lokal. Priorisierung und Team trennen `setupScene()` von `loadCurrentMonster()`: Panels werden nur bei leerer Panel-Liste erzeugt; Retry ruft ausschließlich `loadCurrentMonster()` auf.

## Phase-für-Phase-Verhalten

- Untersuchung: Fehlertext und `Erneut laden`; Retry lädt die aktuelle Asset-ID, Ticketkarte und Phase bleiben stehen.
- Priorisierung: HUD, Hint, Ticketinfo und exakt drei vorhandene Ziele bleiben erhalten. Ohne Monster greift der bestehende Entity-Guard der Drag-Handler. Nach Erfolg wird das neue Monster konfiguriert und Drag ist abhängig allein von Ticketinfo/`isInputLocked` wieder möglich.
- Teamzuordnung: analog mit exakt vier vorhandenen Zielen; die gespeicherte Priorität bleibt unangetastet.
- Mehrfach-Retry: `fail → fail → fail → success` bleibt möglich. Während `loading` ist der Fehler samt Button ausgeblendet; die State-Machine lehnt außerdem parallele Starts ab.

## Fachzustandsschutz

Der Retry ruft keine Methode des `SessionModel` auf. Damit bleiben dasselbe Ticket, derselbe Index, dieselbe Phase, derselbe Score, `selectedPriority`, `selectedTeam` und `isInputLocked` unverändert. Ebenso entstehen keine Bewertung, kein Sound, kein visuelles Entscheidungsfeedback, kein Snapback und kein Phasenwechsel.

## Änderungen je Datei

| Datei | Änderung |
|---|---|
| `Services/MonsterLoadRecovery.swift` | lokale, testbare Lade-/Retry-State-Machine und Parallel-Task-Schutz |
| `Views/InvestigationView.swift` | Retry im bestehenden Fehlerpanel, Laden über lokalen Recovery-State |
| `Views/PrioritizationView.swift` | Panelaufbau idempotent getrennt, monster-only Retry und Fehleraktion |
| `Views/TeamAssignmentView.swift` | analog Priorisierung mit vier Teamzielen |
| `Resources/Localizable.xcstrings` | sichtbarer Quell-/Lokalisierungstext exakt `Erneut laden` |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | 20 neue Tests für Zustände, Mehrfach-/Parallel-Retry, Session-Schutz und Zielanzahlen/-IDs |

`SessionModel`, Asset-Mapping, Scoring, Audio, Feedback, HUD, Ticketinfo, Startseite, DropEvaluator, DragBounds und ResultView blieben unverändert.

## Tests

- vorher: 278 Testdeklarationen
- neu: 20 Testdeklarationen
- nachher: 298 Testdeklarationen
- abgedeckt: Retry-Sichtbarkeit, Fehlerreset, gleiche Asset-ID, paralleler Start, Erfolg/Fehler, unbegrenzte Fehlversuche, maximal ein Monster, Sessionzustandsschutz, keine Bewertung/Transition, drei/vier eindeutige Ziele
- String Catalog: JSON-Syntax erfolgreich geprüft
- `git diff --check`: PASS
- vollständiger Build/Testlauf: nicht ausgeführt, da Xcode und Swift-Toolchain in dieser Linux-Umgebung fehlen
- Passed/Failed/Skipped: nicht ermittelbar; es werden keine erfundenen PASS-Zahlen berichtet

## Simulator-/Regressionstest

Nicht ausgeführt, da kein visionOS-Simulator vorhanden ist. Offen sind die drei manuellen Fehler-/Retry-Abläufe, die Zustandsmatrix vor/nach Retry, Drag nach Erfolg, Panel-/Monsterzählung in der RealityKit-Szene sowie die Regression von HUD, Ticketinfo, Feedback, Sound und Exactly-once.

## Status AK-23

- statisch implementiert: Retry in allen drei Phasen, alter Fehler wird beim Start gelöscht, gleiche aktuelle Asset-ID, Parallel-Task-Schutz
- strukturell bestätigt: Sessionzustand unverändert, keine neuen Zielpanels, maximal ein erfolgreicher Monsterzustand, keine Bewertung, kein Sound und kein Phasenwechsel
- per Unit-Test spezifiziert: Mehrfachfehler bis Erfolg und alle lokalen Zustandsübergänge
- Laufzeitabnahme offen: vollständiger Xcode-Testlauf und visionOS-Simulator-/Gerätetest

## Git

- Modul-018-Commit: `de7e4d6 feat: Modul 18`
- Modul-019-Commit: nicht erzeugt, weil Build, Tests und Simulatorprüfung hier nicht ausführbar sind
- vorgesehene Commit-Nachricht nach erfolgreicher macOS-Abnahme: `019: Ladefehler-Recovery`

## Empfehlung für Modul 020 — Integration und Abnahme v1.1

Auf macOS zuerst Build und alle 298 Tests ausführen. Anschließend in jeder der drei Phasen kontrollierte Ladefehler mit mehreren Retries provozieren und Monster-/Panelanzahl sowie die vollständige Zustandsmatrix prüfen. Danach die offenen Laufzeitabnahmen der Module 015–019 gemeinsam durchführen und Modul 019 separat committen.
