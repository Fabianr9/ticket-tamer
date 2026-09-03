# Projekt-Stand — Ticket Tamer

> Aktuelle Code-/Planungsbasis nach Modul 024 der Version 1.2.

**Projektversion:** v1.2 in Arbeit  
**Stand:** nach Modul 024  
**Branch laut Report:** `A`  
**HEAD vor 024:** `4ced478`  
**Modul-023-Commit:** `4ced478`  
**Modul-024-Commit:** offen  
**Testdeklarationen:** **333**  
**Build/Test/Simulator:** offen

## v1.2-Funktionsstand

### 021 — Replay
Zentrale Root-/Volume-Stabilisierung implementiert. AK-25 Laufzeit OPEN.

### 022 — Punkte
- Ergebnis `<score> Punkte`
- correct `+100 Punkte`
- incorrect `0 Punkte`

AK-26/27 Laufzeit OPEN.

### 023 — Teamsymbole
- Netzwerk → `network`
- Konto → `person.crop.circle`
- Software → `macwindow`
- Hardware → `desktopcomputer`

AK-28 Laufzeit OPEN.

### 024 — Debug-Isolation
Produktiver `🔧 Team [DEV]`-Shortcut aus `PrioritizationView` entfernt.

Debug-Harness bleibt separat und DEBUG-only.

AK-29 Laufzeit OPEN.

## Tests

Aktuell:

**333 Testdeklarationen**

Vollständiger Apple-Toolchain-Lauf offen.

## v1.2-Modul-Landkarte

| Modul | Status |
|---|---|
| 021 | implementiert; AK-25 OPEN |
| 022 | implementiert; AK-26/27 OPEN |
| 023 | implementiert; AK-28 OPEN |
| 024 | implementiert; AK-29 OPEN |
| 025 | als Nächstes |
| 026 | offen |

## Für Modul 025 verbindlich

Vier Monstertypen.

Je Typ vier vorhandene Farbvarianten.

Gesamt:

**16 lokale Monsterassets**

SPEC-Hinweis:

- Monstertyp 3 besitzt laut Bestandsanalyse Varianten `blue`, `green`, `pink`, `yellow`
- die übrigen Typen besitzen `blue`, `green`, `pink`, `red`

Konkrete Dateinamen müssen im Repository/RealityKitContent real ermittelt und explizit gemappt werden.

Keine Dateinamen algorithmisch aus angenommenen Farbnamen erzeugen.

## Sitzungsspezifische Auswahl

Pro ausgewähltem Ticket:

```text
Ticket-ID → konkrete MonsterAssetVariant
```

Auswahl genau einmal beim Sitzungsaufbau.

Danach dieselbe Variante in:

- Untersuchung
- Priorisierung
- Teamzuordnung
- Retry

Neue Sitzung darf neu auswählen.

`reset()` verwirft das Variantenmapping.

## Architektur

`SessionModel` bleibt fachliche Source of Truth.

Sitzungsbezogenes Variantenmapping darf dort oder in einer eindeutig sitzungsbezogenen Struktur geführt werden.

Die Auswahlfunktion muss injizierbar/deterministisch testbar sein.

Keine Persistenz.

Keine Cloud.

Keine neue Monsterlogik außerhalb der Assetwahl.
