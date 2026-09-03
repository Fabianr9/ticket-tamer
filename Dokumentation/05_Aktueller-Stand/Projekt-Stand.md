# Projekt-Stand — Ticket Tamer

> Aktuelle technische Landkarte nach Modul 027 der Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**Stand:** nach Modul 027  
**Branch laut Report:** `v1.3`  
**v1.2-Abschlusscommit:** `44430b7`  
**Modul-027-Commit:** offen  
**Testdeklarationen:** **372**  
**Build/Test/Simulator:** offen

## v1.3-Funktionsstand

### 027 — Neue Ticketdaten und 16er-Sitzung

Implementiert:

- genau TT-001 bis TT-016
- neue Quelltexte aus `Tickets/Ticket-Tamer_Tickets.md`
- Auswahlbereich 1...16
- Standard/Reset 6
- Video-Datenreferenz `TT-xxx.mp4`
- bestätigte Teamverteilung 4/4/4/4
- bestätigte Prioritätsverteilung 5/6/5

## Ticketmodell

Relevante Felder:

```text
Ticket
- id
- ticketNumber
- title
- shortDescription
- userImpact
- symptoms
- referencePriority
- referenceTeam
- monsterAssetId
- videoAssetName
```

## Ticketmatrix-Erweiterung

TT-001...TT-012:

vollständige 4×3-Matrix.

Neu:

- TT-013 → Netzwerk / Wichtig / monster01 / TT-013.mp4
- TT-014 → Konto / Normal / monster02 / TT-014.mp4
- TT-015 → Software / Wichtig / monster03 / TT-015.mp4
- TT-016 → Hardware / Kritisch / monster04 / TT-016.mp4

## Session

Grenzen:

```text
minimumTicketCount = 1
maximumTicketCount = 16
defaultTicketCount = 6
```

Eine 16er-Sitzung erzeugt weiterhin 16 eindeutige Monster-Variantenzuordnungen.

## Tests

Aktuell:

**372 Testdeklarationen**

Vollständiger Apple-Toolchain-Lauf noch offen.

## v1.3-Modul-Landkarte

| Modul | Status |
|---|---|
| 027 | implementiert; AK-31 Laufzeit OPEN |
| 028 | als Nächstes |
| 029 | offen |
| 030 | offen |
| 031 | offen |
| 032 | offen |
| 033 | offen |

## Für Modul 028 relevant

Bestehende Teamstationen:

- Netzwerk
- Konto
- Software
- Hardware

Modul 023 hatte SF Symbols ergänzt:

- Netzwerk → `network`
- Konto → `person.crop.circle`
- Software → `macwindow`
- Hardware → `desktopcomputer`

v1.3-F-28 konkretisiert den aktuellen Zielstand:

**Die bereitgestellten JPEG-Teamlogos ersetzen diese Symbole.**

Die deutschen Texte bleiben sichtbar.

## Geometrie-Schutz

Aus Modul 023:

Bei Referenzgeometrie:

- Panelbreite `0.195 m`
- Panelhöhe `0.117 m`
- Paneltiefe `0.020 m`
- `minimumDropOverlapRatio = 0.50`
- `dropDepthTolerance = 0.05 m`

Diese Werte beziehungsweise die dynamisch daraus abgeleitete reale Geometrie dürfen durch Logos nicht verändert werden.

## Ressourcenarchitektur v1.3

Ziel für Modul 028:

```text
Resources/
└── TeamLogos/
    ├── <Netzwerk-JPEG>
    ├── <Konto-JPEG>
    ├── <Software-JPEG>
    └── <Hardware-JPEG>
```

Exakte Dateinamen nicht erfinden.

Im Repository zunächst die bereitgestellten JPEG-Dateien inventarisieren.

Zentrale Zuordnung statt Dateipfade in `TeamAssignmentView`.

Geeignet ist eine kleine Präsentations-/Assetstruktur, sinngemäß:

```text
SupportTeam
→ TeamLogoCatalog
→ logoResourceName
```

oder eine Erweiterung der vorhandenen `TeamTargetMapping.Presentation`.

Fachliche Teamlogik und Dropgeometrie dürfen keine Ressourcenpfade kennen.

## Geschützt

Nicht ändern:

- Ticketdaten Modul 027
- `videoAssetName`
- Sessionauswahl 1...16
- Monster-Variantenauswahl
- Scoring
- Audio
- Streak noch nicht einführen
- `TargetPanelLayout`
- `DropTargetComponent`
- `DropEvaluator`
- 50-%-Overlap
- Z-Toleranz
- Replay-Root
- Punktefeedback
- Debug-UI-Isolation
