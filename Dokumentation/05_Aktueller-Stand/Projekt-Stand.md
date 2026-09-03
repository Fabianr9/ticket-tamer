# Projekt-Stand — Ticket Tamer

> Aktuelle Code-/Planungsbasis nach Modul 026 und Abschluss von Version 1.2.

**Projektversion:** v1.2 abgeschlossen
**Stand:** nach Modul 026 — Integration und Abnahme
**Branch:** `A`
**HEAD vor 026:** `b2f345a feat: Modul 25`
**Modul-025-Commit:** `b2f345a`
**Testdeklarationen:** **365**
**Build/Test/Simulator:** PASS, vom Auftraggeber bestätigt
**Akzeptanzkriterien:** AK-01 bis AK-30 PASS

## Versionsstand

| Version | Umfang | Status |
|---|---|---|
| v1.0 | Kernspiel AK-01 bis AK-17 | abgeschlossen |
| v1.1 | HUD, Ticketinfo, Hinweise, Feedback, Steuerung und Retry AK-18 bis AK-24 | abgeschlossen |
| v1.2 | Replay, Punktekommunikation, Teamsymbole, Debug-Isolation und Farbvarianten AK-25 bis AK-30 | abgeschlossen |

## v1.2-Funktionsstand

- Replay erhält Root- und Volume-Geometrie ohne kumulative Layoutdrift.
- Ergebnis zeigt ausschließlich `<score> Punkte` und „Erneut spielen“.
- Feedback zeigt bei richtig `+100 Punkte`, bei falsch `0 Punkte`.
- Teamstationen verwenden `network`, `person.crop.circle`, `macwindow` und
  `desktopcomputer` zusätzlich zu den deutschen Labels.
- Der produktive Flow enthält keinen `🔧 Team [DEV]`-Shortcut; der Debug-Harness bleibt
  separat und DEBUG-only.
- Vier Monstertypen besitzen je vier, insgesamt 16 produktiv gebündelte Farbvarianten.
- Eine Variante wird einmal pro Sitzungsticket gewählt und bleibt über Untersuchung,
  Priorisierung, Team und Retry stabil; Reset verwirft das Mapping.

## Zentrale Schnittstellen

- `SessionModel` — fachliche Source of Truth für Sitzung, Entscheidungen, Score und Reset.
- `RootVolumeView` — einzige produktive Phasenwurzel im zentralen Volume.
- `MonsterAssetVariant` / `MonsterVariantCatalog` — expliziter 4×4-Assetkatalog.
- `SessionModel.startSession(using:variantSelector:)` — testbar injizierbare Variantenwahl.
- `selectedMonsterVariantByTicketID` / `selectedMonsterVariant(for:)` — sitzungsstabile Zuordnung.
- `MonsterAssetProvider` / `MonsterLoadRecovery` — gemeinsames Laden und identischer Retry.
- `DropEvaluator`, `DragBounds`, `PlanarDrag` — gemeinsame Drag-/Drop-Pipeline.

## Abnahmenachweis

- 365 Testdeklarationen; vollständige Suite erfolgreich bestätigt.
- Build und visionOS-Laufzeitprüfung erfolgreich bestätigt.
- AK-25 bis AK-30 im Zusammenspiel erfolgreich geprüft.
- AK-01 bis AK-24 ohne kritische Regression.
- Sitzungen mit 1, 2, 6 und 12 Tickets sowie fünf Replay-Zyklen stabil.
- Alle 16 USDC-Assets geladen, sichtbar und interaktiv geprüft.
- Kein physischer Gerätetest separat ausgewiesen; dokumentiertes Restrisiko.

Der vollständige Nachweis steht in `Dokumentation/04_Modul-Reports/026-Report.md`.
