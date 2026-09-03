# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 031 für Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Stand:** nach Modul `031` — Streak-State und Scoring  
**Eingearbeitet am:** 2026-09-04  
**Branch laut 030-Report:** `v1.3`  
**HEAD vor Modul 030:** `baf8a55495e9605bbc011dbf01de061638f6a11c`  
**Modul-029-Commit:** `baf8a55` (`feat: Modul 29`)  
**Modul-030-Commit:** `8041bf9` (`feat: Modul 30`)  
**Modul-031-Commit:** offen  
**Testdeklarationen vor 031:** 474  
**Neue Tests:** 48  
**Testdeklarationen nach 031:** **522**  
**Build/Test/Simulator/Playback:** offen

## v1.3-Modulstatus

| Modul | Titel | Status |
|---|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung | committed |
| 028 | Teamlogos v1.3 | committed; Laufzeitanteile OPEN |
| 029 | Monster- und Streak-Audio | committed `baf8a55`; Hör-/Bundlelauf OPEN |
| 030 | Ticketvideo-System | committed `8041bf9`; Playback-/Bundlelauf OPEN |
| 031 | Streak-State und Scoring | implementiert; Code-/Testebene PASS; Toolchainlauf/Commit OPEN |
| 032 | Streak-Feedback v1.3 | offen |
| 033 | Integration und Abnahme v1.3 | offen |

## Modul 030 — Videoressourcen

Produktiver Zielordner:

`Resources/Videos/`

Genau folgende 16 produktiv referenzierten Dateien:

- `TT-001.mp4`
- `TT-002.mp4`
- `TT-003.mp4`
- `TT-004.mp4`
- `TT-005.mp4`
- `TT-006.mp4`
- `TT-007.mp4`
- `TT-008.mp4`
- `TT-009.mp4`
- `TT-010.mp4`
- `TT-011.mp4`
- `TT-012.mp4`
- `TT-013.mp4`
- `TT-014.mp4`
- `TT-015.mp4`
- `TT-016.mp4`

Alle Quellen/Ziele wurden statisch als ISO-MP4 erkannt; Quell- und Zielkopien besitzen laut Report jeweils identische SHA-256-Hashes.

Die historische Zusatzdatei:

`Tickets/TT-002A.mp4`

ist **keine** produktive Ticketreferenz und wurde nicht übernommen.

## Videoarchitektur

### `Ticket.videoAssetName`

Bleibt die einzige fachliche Videoreferenz.

Keine zweite Video-ID.

### `TicketVideoResourceProvider`

Neu unter:

`Services/TicketVideoResourceProvider.swift`

Verantwortung:

- validiert reinen MP4-Dateinamen
- lokaler Bundle-Lookup zuerst unter `Videos`
- defensiver Fallback auf flach kopiertes Bundle
- lehnt Netzwerk-URLs, absolute Pfade, Traversal und fremde Endungen ab

### `TicketVideoPresentationState`

Kapselt ausschließlich lokalen Präsentationszustand.

Kein Videozustand im `SessionModel`.

### `TicketVideoView`

Neu unter:

`Views/Components/TicketVideoView.swift`

Verhalten:

- pro Öffnung genau ein `AVPlayer`
- startet erst nach explizitem Nutzer-Tap
- Auto-Play beim Erscheinen der Videoansicht
- Pause/Fortsetzen über `VideoPlayer`
- sichtbares X
- Auto-Close bei regulärem Ende
- Fehlerbeobachtung
- Observer werden beim Schließen/Disappear entfernt
- Fehlertext: `Video konnte nicht geladen werden.`

## Nutzerflow

```text
Investigation
→ Tap „Video ansehen“
→ lokale Bundle-URL
→ Overlay + Auto-Play
→ Pause/Fortsetzen
→ X oder reguläres Ende
→ gleiche Investigation / gleiches Ticket
```

Ohne Tap:

- kein Player
- kein Videooverlay
- kein Autostart

## Fachzustandsschutz

Video verändert nicht:

- `currentTicket`
- `currentTicketIndex`
- `currentPhase`
- `score`
- `selectedPriority`
- `selectedTeam`
- `isInputLocked`
- Monster-Variantenmapping

Streak war in Modul 030 noch nicht eingeführt.

## Fehlerfall

Fehlende/ungültige/nicht lesbare Videoressource:

- kein Force-Unwrap
- kein Crash
- lokalisierter Fehlertext
- X bleibt nutzbar
- Ticket bleibt normal spielbar
- keine Netzwerksuche
- keine fachliche Mutation

## Dateien Modul 030

Neu:

- `Services/TicketVideoResourceProvider.swift`
- `Views/Components/TicketVideoView.swift`
- `Resources/Videos/TT-001.mp4` bis `TT-016.mp4`
- `TicketVideoSystemTests.swift`

Geändert:

- `Views/Components/TicketCardView.swift`
- `Views/InvestigationView.swift`
- `Resources/Localizable.xcstrings`

Nicht verändert:

- `SessionModel`
- Audioarchitektur
- Teamlogos
- Monsterlogik
- Drag/Drop
- Scoring

## Test-/Prüfstand

| Prüfung | Status |
|---|---|
| Tests vor 030 | 436 |
| neue Tests | 38 |
| Tests nach 030 | **474** |
| String Catalog JSON | PASS |
| MP4-Anzahl/Dateityp/Hash | PASS |
| genau TT-001...TT-016 produktiv | PASS |
| keine Netzwerk-/absoluten Video-Pfade | PASS statisch |
| kein Force-Unwrap im Video-Code | PASS statisch |
| Modul-030 `git diff --check` | PASS |
| automatischer Testlauf | OPEN |
| Build | OPEN |
| Simulator/Playback | OPEN |
| TT-007 Runtime | OPEN |

## Akzeptanzstatus

### AK-03

Video-Referenzen und Ressourcen statisch PASS.

### AK-32

Code-/Testebene PASS:

- explizite Aktion
- 1:1-Ticketmapping
- kein View-Autostart

Simulator OPEN.

### AK-33

Codeebene PASS:

- Auto-Play nach Tap
- Pause/Fortsetzen
- X
- Auto-Close
- Fehlerzustand

Reale Wiedergabe OPEN.

### AK-39 Video-Anteil

Ressourcen-/Providerstruktur PASS.

Bundle-Lauf OPEN.

## Geschützter Bestand nach Modul 031

Nicht verändern:

- Video-Provider
- Video-UI
- 16 MP4-Dateien
- Audio-Katalog und AudioService
- TeamLogoCatalog
- Ticketdaten
- 1...16-Auswahl
- Monster-Farbvarianten
- Drop/Drag
- Replay-Root
- Debug-Isolation

## Modul 031 — Ergebnis

Implementiert:

- zentralen `streak`-Zustand im `SessionModel`
- `currentPriorityWasCorrect`
- Reset-/Startregeln für Streak
- zentrale Multiplikator-/Differenzberechnung
- vollständig korrektes Ticket: `200 × streak`
- Teilpunkte ohne Multiplikator
- Exactly-once-sichere Scoremutation
- testbare Übergabedaten für Modul 032

Noch **keine** Streak-Visualisierung und noch **kein produktiver Streak-Soundtrigger**.

## Nächster Schritt

Modul 032 — Streak-Feedback v1.3: zentrale Abschlussdaten anzeigen und den bereits vorhandenen Streak-Sound zeitversetzt orchestrieren.
