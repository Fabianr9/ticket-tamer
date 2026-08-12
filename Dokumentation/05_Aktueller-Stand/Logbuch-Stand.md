# Projektlogbuch — Ticket Tamer

**Stand:** Modul `013` — Integration und Gerätetest **teilweise abgeschlossen; Pflichtabnahmen offen**  
**Eingearbeitet am:** 2026-08-12  
**Branch laut 013-Report:** `main`  
**Commit vor Modul 013:** `b94e0ed feat: add docs modul 11`  
**Modul-011-Commit:** `209aff2 feat:Modul011`  
**Modul-012:** bewusst ohne Codeänderung ausgelassen  
**Modul-013-Commit:** noch offen  
**Testdeklarationen:** 155  
**Vollständiger Testlauf:** nicht ausgeführt

## Modulstatus

| Modul | Titel | Status |
|---|---|---|
| 001–011 | Pflicht-Featuremodule | implementiert |
| 005 | Monster-Asset-Pipeline | durch 013 technisch auf echte USDC-Monster aktualisiert |
| 012 | Optionale Monsterreaktion | bewusst ausgelassen |
| 013 | Integration und Gerätetest | **teilweise abgeschlossen** |
| 014 | Abschlussdokumentation und Cleanup | als Nächstes, mit hartem Abnahme-Gate |

## Eingearbeiteter Stand Modul 013

### Finale Monsterintegration

Vier echte USDC-Monster wurden lokal in RealityKitContent integriert:

| Asset-ID | integrierte Datei |
|---|---|
| `monster01` | `Monster_1_blue.usdc` |
| `monster02` | `Monster_2_green.usdc` |
| `monster03` | `Monster_3_yellow.usdc` |
| `monster04` | `Monster_4_red.usdc` |

Die Wrapper `monster01.usda` bis `monster04.usda` referenzieren nun diese Dateien. Das Ticket-Mapping blieb unverändert. Die Farbwahl codiert laut Report weder Team noch Priorität.

### F-14 / AK-14

Der Report bezeichnet die Dateien als Blender-USDC-Exporte. Im geprüften Monster-Ordner liegen jedoch keine `.blend`-Quelldateien.

Belegt:
- vier unterschiedliche RealityKit-kompatible Monsterassets integriert
- Kugel-Platzhalter technisch ersetzt
- lokale Darstellung in Priorisierung und Team laut Simulatorbericht bestätigt

Noch offen:
- eindeutiger Nachweis „eigene Blender-Monster“
- `.blend`-Quelldateien oder gleichwertiger Eigentums-/Source-Nachweis
- Blick/Pinch/Drag mit allen vier echten Meshes
- vollständige Skalierungs-/Orientierungsprüfung aller vier

**F-14 / AK-14 bleibt deshalb OPEN.**

### Integrationsfix 1 — Z-up → Y-up

`MonsterAssetProvider` wurde laut Report so angepasst, dass die Blender-USDC-Orientierung nach dem Laden für RealityKit korrigiert wird. Gemeldete Wirkung: Monster liegen nicht mehr flach.

### Integrationsfix 2 — RealityView Dependency Tracking

Geändert:
- `PrioritizationView.swift`
- `TeamAssignmentView.swift`

Gemeldete Wirkung:
- direkte State-Reads im RealityView-Update
- zuverlässiger Re-Render nach asynchronem Monsterload
- ProgressView während Ladezustand
- echte Monster erscheinen in Priorisierungs- und Teamansicht

## Build / Simulator / Tests

Laut Report:
- Build in Xcode erfolgreich
- visionOS-26.5-Simulator verwendet
- echte Monster in Priorisierung und Team sichtbar
- `correct.wav` hörbar

Offen:
- vollständiger 155-Test-Lauf
- Untersuchung AK-06/07
- Gesten-End-to-End
- `incorrect.wav`
- fünf Neustarts
- Apple-Vision-Pro-Gerätetest

Die Zahl 155 ist ein Deklarationsstand, kein bestandener Testnachweis.

## Korrigierte Pflicht-Abnahmematrix

Die Feature-/AK-Zuordnung des 013-Reports enthält Abweichungen von SPEC/Akzeptanzkriterien. Maßgeblich bleibt die ursprüngliche Projektzuordnung.

| AK | Verbindlicher Inhalt | Stand |
|---|---|---|
| AK-01 | Startansicht / Regler / Start | PASS (Simulator berichtet) |
| AK-02 | genau 12 lokale Tickets / 4×3-Abdeckung | PASS (Quellstand) |
| AK-03 | vollständige Ticketdaten | PASS (Quellstand) |
| AK-04 | Sitzungsauswahl ohne Wiederholung | PASS (Modell/Simulator berichtet) |
| AK-05 | vollständiger linearer Ablauf in genau einem Volume | **OPEN** |
| AK-06 | Untersuchungsansicht | **OPEN** |
| AK-07 | Weiter zur Priorisierung | **OPEN** |
| AK-08 | Prioritäts-Drag auf alle drei Ziele | **OPEN** |
| AK-09 | Team-Drag auf alle vier Stationen | **OPEN** |
| AK-10 | gültig/ungültig, Lock, genau-einmal | **OPEN** |
| AK-11 | Scoring +100/0 | **OPEN** |
| AK-12 | beide Sounds korrekt und genau einmal | **OPEN** |
| AK-13 | keine Lösung + ca. 1,5-s-Übergang | PASS (Simulator berichtet) |
| AK-14 | vier eigene Blender-Monster, lokal, bewegbar, neutral | **OPEN** |
| AK-15 | nur Scorezahl + „Erneut spielen“ | PASS (Simulator berichtet) |
| AK-16 | vollständiger Reset, mindestens 5 Neustarts stabil | **OPEN** |

## Noch offene Pflichtprüfungen

- vollständige 155 Tests
- AK-06/07
- alle Prioritäts- und Teamgesten
- Invalid-Drop / Lock / Mehrfach-Pinch
- Scoringfälle 200/100/100/0
- `incorrect.wav` und genau-einmal-Audio
- 5 Neustarts
- 1-/2-/6-/12-Ticket-End-to-End
- eigener Blender-Source-/Ownership-Nachweis
- alle vier echten Monster mit Gesten
- Apple Vision Pro

## Modul-013-Commit

Vorgesehene Nachricht:

`013: Integration und Gerätetest`

Hash noch nicht bekannt. Nicht als committed behandeln, bis ein echter Hash vorliegt.

## Entscheidungslog — neu

- Echte USDC-Monster ersetzen technisch die Kugel-Platzhalter.
- Z-up/Y-up-Korrektur und RealityView-State-Fix werden als Integrationsfixes übernommen.
- Ein AK wird nur PASS, wenn alle geforderten Teilaspekte nachgewiesen sind.
- Unvollständige Gesten-/Audio-/Reset-/Assetnachweise bleiben OPEN.
- Modul 014 darf offene AKs nicht durch Dokumentation „schließen“.
- F-17 bleibt ausgelassen.

## Nächster Schritt

`014-Eingangsprompt.md` ausführen. Modul 014 erstellt die konsistente Abschlussdokumentation und bereinigt das Projekt. Vor einem finalen „abgabebereit“ müssen offene Nachweise entweder mit realer Evidenz geschlossen oder sichtbar als OPEN/Risiko stehen bleiben.
