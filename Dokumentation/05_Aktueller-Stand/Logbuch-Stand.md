# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 029 für Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Stand:** nach Modul `029` — Monster- und Streak-Audio  
**Eingearbeitet am:** 2026-09-03  
**Branch laut 028-Report:** `v1.3`  
**HEAD vor Modul 028:** `72d3e0470a7a7ba9591733a5ce0c42e6191b6087` (`feat: Modul 27`)  
**Modul-027-Commit:** `72d3e04` (`feat: Modul 27`)  
**Modul-028-Commit:** `120ab6d` (`feat: Modul 28`)  
**Reale Testdeklarationen vor 028:** 372  
**Neue/Netto-Testdeklarationen 028:** +29  
**Reale Testdeklarationen nach 028:** **401**  
**Neue Testdeklarationen 029:** +35  
**Reale Testdeklarationen nach 029:** **436**  
**Build/Test/Simulator nach 029:** offen (Apple-Toolchain nicht vorhanden)

## Reale Teststände

Die Gitstände wurden für Modul 029 erneut direkt gezählt:

- Modul-027-Commit `72d3e04`: 372
- Modul-028-Commit `120ab6d`: 401
- Modul 029: +35
- aktueller Stand: 436

## v1.3-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung | F-01, F-02, F-03, F-04, F-22, F-31 | committed `72d3e04`; Laufzeitteile weiterhin nachzuholen |
| 028 | Teamlogos v1.3 | F-28, F-39 | committed `120ab6d`; Code/Test-Anteil PASS; Bundle-/Simulatorlauf OPEN |
| 029 | Monster- und Streak-Audio | F-12, F-34, F-35, F-39 | implementiert; Ressourcen/Katalog PASS; Laufzeit OPEN |
| 030 | Ticketvideo-System | F-03, F-32, F-33, F-39 | als Nächstes |
| 031 | Streak-State und Scoring | F-11, F-16, F-36, F-37 | offen |
| 032 | Streak-Feedback v1.3 | F-18, F-21, F-35, F-38 | offen |
| 033 | Integration und Abnahme v1.3 | F-01 bis F-39, Schwerpunkt F-31 bis F-39 | offen |

## Modul 028 — Teamlogo-Integration

### Ressourcenstruktur

Die vier bereitgestellten JPEG-Teamlogos liegen produktiv gemeinsam unter:

`Ticket_Tamer/Ticket_Tamer/Resources/TeamLogos`

Dateien:

- Netzwerk: `Network_team_icon_design_202609032139.jpeg`
- Konto: `Team_icon_design_profile_lock_202609032138.jpeg`
- Software: `Software_team_icon_design_202609032138.jpeg`
- Hardware: `Hardware_team_icon_design_202609032138.jpeg`

Alle vier Dateien wurden als valide JFIF-JPEGs mit 1024 × 1024 Pixel bestätigt.

Quell- und Zielkopien besitzen laut Report jeweils identischen SHA-256-Hash.

### Zentrale Zuordnung

Neu:

`Support/TeamLogoCatalog.swift`

`TeamLogoCatalog` ist die einzige Team→Logo-Zuordnung.

Eine Logoressource enthält nur:

- Ressourcenname
- JPEG-Endung

Keine:

- absolute Entwicklerpfade
- Netzwerk-URLs
- Ticketdaten
- Score
- Referenzpriorität
- Dropgeometrie

### Teamstationen

Historischer v1.2-Stand:

- Netzwerk → SF Symbol `network`
- Konto → `person.crop.circle`
- Software → `macwindow`
- Hardware → `desktopcomputer`

v1.3-Stand nach Modul 028:

- lokales JPEG-Logo
- deutscher Teamtext bleibt vollständig sichtbar

Die historischen SF-Symbole werden in der produktiven Teamstation nicht mehr verwendet.

### Darstellung

Logo:

- `scaledToFit`
- maximale Innenbox 34 × 34 pt
- Seitenverhältnis bleibt erhalten
- für VoiceOver verborgen

Accessibility:

- vollständiger deutscher Teamname bleibt Label der Station.

### Fehlendes Logo

Bei fehlender/ungültiger Ressource:

- kein Crash
- Teamtext bleibt sichtbar
- Ziel-Entity bleibt vorhanden
- Target-ID bleibt vorhanden
- Dropgeometrie bleibt vorhanden
- fachliche Teamzuordnung funktioniert weiter
- Ressourcenfehler wird einmal über `.spawning` protokolliert

## Geometrieschutz

Unverändert:

- `TargetPanelLayout`
- `TargetPanelFactory`
- `DropTargetComponent`
- `DropEvaluator`

Referenzgeometrie:

| Wert | vorher | nachher |
|---|---:|---:|
| Panelbreite | 0.195 m | 0.195 m |
| Panelhöhe | 0.117 m | 0.117 m |
| Paneltiefe | 0.020 m | 0.020 m |
| Targetzentren | x ±0.1075; y 0.160/0.023; z -0.085 m | identisch |
| Drop halfExtents | (0.0975; 0.0585; 0.0100) m | identisch |
| Overlap | 0.50 | 0.50 |
| Z-Toleranz | 0.05 m | 0.05 m |

Das SwiftUI-Attachment mit Logo und Text beeinflusst weder Panelmesh noch Drop-Bounds.

## Dateien Modul 028

Neu:

- `Support/TeamLogoCatalog.swift`
- `Resources/TeamLogos/Network_team_icon_design_202609032139.jpeg`
- `Resources/TeamLogos/Team_icon_design_profile_lock_202609032138.jpeg`
- `Resources/TeamLogos/Software_team_icon_design_202609032138.jpeg`
- `Resources/TeamLogos/Hardware_team_icon_design_202609032138.jpeg`

Geändert:

- `Views/TeamAssignmentView.swift`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

## Test-/Prüfstand

| Prüfung | Status |
|---|---|
| reale Tests vor 028 | 372 |
| reale Tests nach 028 | **401** |
| JPEG-Signatur/Abmessungen | PASS |
| Quell-/Zielintegrität | PASS |
| historische SF-Symbole produktiv entfernt | PASS statisch |
| Modul-028 `git diff --check` | PASS |
| vollständiger Testlauf | OPEN |
| Xcode-Build | OPEN |
| Simulator | OPEN |
| tatsächliche Bundle-Auffindbarkeit | OPEN |

## Akzeptanzstatus

### AK-28

Code-/Testebene:

PASS.

Laufzeit weiterhin OPEN für:

- vier Logos sichtbar
- Textlesbarkeit
- Blickwinkel
- Drag auf alle vier Ziele
- Invalid Drop/Snapback
- kontrollierter Fallback

### AK-39 — Teamlogo-Anteil

Code-/Testebene:

PASS.

Bundle-/Release-/Simulatorlauf:

OPEN.

Der Videoanteil von AK-39 ist noch nicht bearbeitet.

## Modul 029 — Monster- und Streak-Audio

- zehn valide lokale WAVs unter `Resources/Audio` integriert
- Correct und Incorrect als getrennte 4er-Kataloge
- zufällige Auswahl mit injizierbarem Selector
- direkte Wiederholung ausdrücklich möglich; keine Anti-Repeat-Logik
- bestehende Exactly-once-Feedbacktasks verwenden je genau einen Monster-Sound
- Streak 2/3 → Sound 01, Streak 4+ → Sound 02, ≤1 → kein Sound
- separater Streak-Player für die spätere zeitversetzte Integration
- historische `correct.wav`/`incorrect.wav` unreferenziert
- kein Streak-State, Multiplikator oder produktiver Streak-Trigger vorgezogen

Details: `Dokumentation/04_Modul-Reports/029-Report.md`.

## Geschützter Bestand für Modul 030

Nicht verändern:

- `TeamLogoCatalog`
- Teamlogos
- Teamstation-Text
- Teamgeometrie
- Drop-Bounds
- 50-%-Overlap
- Z-Toleranz
- 16 Ticketdaten
- 1...16-Auswahl
- Video-Referenzen
- Monster-Farbvarianten
- Replay-Root
- Punktefeedback
- Debug-UI-Isolation

## Nächster Schritt

Modul 030 — Ticketvideo-System umsetzen.
