# Projekt-Stand — Ticket Tamer

> Aktuelle Code-/Planungsbasis nach Modul 022 der Version 1.2.

**Projektversion:** v1.2 in Arbeit  
**Stand:** nach Modul 022  
**Branch laut Report:** `A`  
**HEAD vor 022:** `c11b464`  
**Modul-021-Commits:** `68268cb` bis `c11b464`  
**Modul-022-Commit:** offen  
**Testdeklarationen:** **313**  
**Build/Test/Simulator:** offen

## v1.2-Funktionsstand

### Modul 021

Replay-Layoutfix:

- stabile `GeometryReader3D`-Rootbasis
- feste Slider-Designbreite
- keine kumulative Skalierung
- `.defaultSize` nur Cold Start
- Nutzer-/System-Resize soll erhalten bleiben

AK-25 Laufzeit: OPEN.

### Modul 022

Ergebnis:

`<score> Punkte`

Feedback:

- correct → grüner Haken + `+100 Punkte`
- incorrect → rotes Kreuz + `0 Punkte`

AK-26/27 Laufzeit: OPEN.

## Tests

- vor 022: 306
- +7
- aktuell: 313 Testdeklarationen
- vollständiger Xcode-Lauf offen

## v1.2-Modul-Landkarte

| Modul | Status |
|---|---|
| 021 | implementiert; AK-25 OPEN |
| 022 | implementiert; AK-26/27 OPEN |
| 023 | als Nächstes |
| 024 | offen |
| 025 | offen |
| 026 | offen |

## Für Modul 023 relevant

Bestehende Teamstationen:

- Netzwerk
- Konto
- Software
- Hardware

v1.2 ergänzt je Station zusätzlich ein semantisch passendes Symbol.

Verbindlich:

- Text bleibt sichtbar
- Symbol ergänzt nur
- Farbe ist nicht alleinige Bedeutung
- sichtbare Zielbox unverändert
- Drop-Bounds unverändert
- 50-%-Overlap unverändert
- Z-Toleranz unverändert
- DropEvaluator unverändert

## Erwartete semantische Zuordnung

- Netzwerk → Netzwerk-/Verbindungssymbol
- Konto → Personen-/Schlüsselsymbol
- Software → App-/Fenstersymbol
- Hardware → Computer-/Werkzeugsymbol

SF Symbols sind bevorzugt, sofern sie im realen visionOS-Aufbau sinnvoll funktionieren.

## Relevante Kandidaten für Modul 023

Zu prüfen:

- `Views/TeamAssignmentView.swift`
- `Services/TargetPanelFactory.swift`
- `Services/TargetPanelLayout.swift`
- `Components/DropTargetComponent.swift`
- bestehende Team-Label-/Attachment-Struktur
- `Resources/Localizable.xcstrings`
- `Support/AppConstants.swift`
- Tests

Die Symbolergänzung soll in der Darstellungs-/Labelschicht erfolgen, nicht in der Drop-Geometrie.
