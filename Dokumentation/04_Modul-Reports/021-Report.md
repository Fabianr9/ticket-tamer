# Modul-Report — 021 Replay-Layoutstabilisierung

## Zusammenfassung

Der phasenabhaengige Router laeuft nun innerhalb einer dauerhaften `GeometryReader3D`-Root-Huelle. Damit kann die kleine Ergebnisansicht das Layout-Proposal des anschliessenden Replay-Starts nicht mehr verkleinern. Eine zwischenzeitliche Begrenzung dieser Root-Huelle wurde nach der Simulator-Gegenpruefung vollständig entfernt, weil sie die 2D-/3D-Umrechnung verzerrte. Stattdessen wird nur das Zielraster innerhalb der vollständig vermessenen Geometry ergonomisch begrenzt. Der Start-Slider besitzt zudem eine feste Designbreite statt nur einer komprimierbaren Maximalbreite; fachlicher Reset und `.defaultSize`-Semantik bleiben unveraendert.

## 1. Vorab-Check

| Punkt | Reales Ergebnis |
|---|---|
| Branch | `A` |
| HEAD vor Modul 021 | `3536b46 feat: Modul: 20` |
| letzter v1.1-Abschlussstand | `3536b46`; ein separater finaler `020-Report.md` ist nicht vorhanden |
| Working Tree vor Änderung | bereits dirty: verschobene/versionierte Kontextdokumente, geänderte Standdateien sowie neue v1.2-/Prompt-/ToDo-Dateien |
| Staged | keine durch Modul 021 erzeugten staged Dateien |
| Testdeklarationen vorher | 298 `@Test` |
| letzter belegter vollständiger Testlauf | kein vollständiger Lauf für den Stand nach Modul 020 im Repository belegt |
| Xcode lokal | nicht vorhanden (`xcodebuild: command not found`) |
| dokumentierter Projektkontext | Xcode 26.5; letzter konkret belegter Lauf in Modul 014 mit Xcode 26.6 |
| SDK / Deployment Target | visionOS SDK 26.5 dokumentiert; `XROS_DEPLOYMENT_TARGET = 26.5`, `SDKROOT = xros` |
| Baseline Build/Test | OPEN, Apple-Toolchain in dieser Linux-Umgebung nicht verfügbar |

Vorhandene fremde Änderungen wurden nicht bereinigt oder überschrieben.

## 2. Reproduktion

Der gemeldete Ablauf und die statische Codeanalyse reproduzieren die Ursache strukturell: `RootVolumeView` gab vor dem Fix unmittelbar wechselnde Root-Views mit stark unterschiedlichen intrinsischen Größen zurück. `ResultView` ist der kleinste Ast; `StartView` verwendete fuer den Slider nur `maxWidth`, waehrend die Drag-/Drop-Phasen ihre Panels aus der jeweils neu angebotenen Geometry berechnen.

Eine reale Laufzeitmessung ist ohne visionOS-Simulator nicht moeglich und wird nicht als ausgefuehrt behauptet:

| Zyklus | Volume B/H/T | Start Root | Slider | Priority Panels | Team Panels |
|---|---|---|---|---|---|
| Cold Start | OPEN | OPEN | OPEN | OPEN | OPEN |
| Replay 1 | OPEN | OPEN | OPEN | OPEN | OPEN |
| Replay 2 | OPEN | OPEN | OPEN | OPEN | OPEN |
| Replay 3 | OPEN | OPEN | OPEN | OPEN | OPEN |
| Replay 4 | OPEN | OPEN | OPEN | OPEN | OPEN |
| Replay 5 | OPEN | OPEN | OPEN | OPEN | OPEN |

## 3. Ursachenanalyse

- `defaultSize` initialisiert nur das Volume und wird bei `SessionModel.reset()` nicht erneut angewendet.
- Der `switch` in `RootVolumeView` tauschte die Root-View ohne gemeinsame volumenfuellende Layoutbasis aus.
- Inhaltsgroße Start-/Ergebnisansichten und volumenfuellende `GeometryReader3D`-/`RealityView`-Phasen meldeten unterschiedliche Layoutcharakteristiken.
- Der Slider war durch `frame(maxWidth:)` der bevorzugt komprimierbare Teil der Ticketsteuerung.
- `TargetPanelLayout` selbst ist nicht kumulativ: Es berechnet aus der aktuellen realen `BoundingBox`. Ein verkleinertes Proposal fuehrte daher deterministisch zu verkleinerten Panels.
- Replay-/Sessionzaehler, CSS, DOM, Canvas und multiplizierende Scale-Faktoren sind nicht beteiligt.

## 4. Fix-Architektur

`RootVolumeView` besitzt jetzt einen dauerhaften `GeometryReader3D` ausserhalb des Phasenrouters und reicht dessen vollständige Breite, Höhe und Tiefe weiter. Dadurch bleiben HUD, Ticketkarte, Monster und SwiftUI-/RealityKit-Konvertierung proportional korrekt. `TargetPanelLayout` begrenzt ausschließlich das zentral angeordnete Zielraster auf 0,45 m Gesamtbreite und die obere Reihe auf höchstens 0,16 m über der Volume-Mitte. Kleine Volumes bleiben anhand ihrer realen Grenzen adaptiv. Es wird keine alte Größe gespeichert, kein Replay-Faktor angewandt und kein Windowzustand in `SessionModel` aufgenommen.

`Ticket_TamerApp.defaultSize(...)` bleibt semantisch ausschließlich die Cold-Start-Vorgabe. Ein Nutzer-/System-Resize wird nicht auf Default zurueckgesetzt, weil Replay ausschließlich den fachlichen Modelzustand aendert. Priority- und Teamziele bleiben adaptiv und werden weiterhin aus den real gemessenen VolumeBounds berechnet.

Nach Simulator-Gegenpruefung wurde die Cold-Start-Vorgabe ergonomisch von 1,2 x 1,15 x 0,45 m auf 0,8 x 0,75 x 0,38 m reduziert. Damit ruecken das an der Oberkante verankerte HUD, die zentrale Spielflaeche und der untere Interaktionshinweis gemeinsam zusammen, ohne einzelne Ornaments mit phasenspezifischen Offsets zu verschieben. Ein bereits vom Nutzer/System veraendertes Volume wird beim Replay weiterhin nicht auf diese Defaultwerte zurueckgesetzt.

In der anschliessenden Feinabstimmung wurde die zwischenzeitliche Änderung des Panelabstands zurückgenommen; die Boxen verwenden wieder 0,02 m Abstand. Das Untersuchungsmonster wurde auf 0,24 m und das Drag-/Drop-Monster auf 0,17 m vergroessert. In der Teamphase startet es nun bei y = -0,18 m vollständig und knapp unterhalb der unteren Panelreihe. Ein erster Versuch, HUD und Hinweis per `offset` zu verschieben, liess beide Ornaments im Simulator verschwinden und wurde vollständig entfernt. Sie verwenden nun explizite normalisierte `UnitPoint3D`-Scene-Anker bei y = 0,10 beziehungsweise y = 0,88. Sichtbare Panelboxen und Drop-Bounds stammen weiterhin aus derselben Geometrie.

Die unstrukturierten Geometry-Tasks in den Spielansichten wurden nicht als gemeinsame Ursache bewertet: Ihr lokaler State verschwindet beim Phasenwechsel, und sie koennen den bereits vorher sichtbaren Start-Slider nicht beeinflussen. In diesem Modul wurde deshalb keine neue Task-Kaskade und kein phasenspezifischer Cancellation-Hack eingefuehrt.

## 5. Änderungen je Datei

| Datei | Art | Grund / Wirkung | F/AK |
|---|---|---|---|
| `Views/RootVolumeView.swift` | geändert | gemeinsame volumenfuellende Root-Huelle fuer alle Phasen | F-25 / AK-25 |
| `Views/StartView.swift` | geändert | Slider nutzt stabile Designbreite statt reiner Maximalbreite | F-25 / AK-25.2 |
| `Support/AppConstants.swift` | geändert | eindeutige zentrale Slider-Designbreite | F-25 / AK-25.2 |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | Replay-/Resize-/Reset-/Panel-Determinismus | AK-25.3–7 |

Keine phasenspezifischen Replay-Hacks wurden eingefuehrt. `SessionModel.reset()` wurde nicht veraendert.

## 6. Tests

| Stand | Deklarationen | Ergebnis | Plattform |
|---|---:|---|---|
| vorher | 298 | nicht ausgefuehrt | Linux ohne Xcode |
| neu | 8 | statisch hinzugefuegt | — |
| nachher | 306 | OPEN | Xcode/visionOS erforderlich |

Neu abgedeckt sind feste positive Slider-Designbreite, identische Priority-/Team-Panelmaße bei identischer Geometry, fünf Wiederholungen ohne kumulative Drift, adaptive Neuberechnung nach Resize sowie die Unabhängigkeit der Layoutberechnung vom fachlichen Reset einschließlich aller Resetwerte. Die bestehenden Rastertests wurden auf das kompakte, zentral angeordnete Zielraster aktualisiert. Bereits vorhandene Tests decken weitere Reset- und `TargetPanelLayout`-Eigenschaften ab.

`git diff --check` fuer die vier Moduldateien: PASS. Der globale Check meldet ausschließlich bereits vorhandene Whitespaces in fremden Änderungen der beiden Standdateien.

## 7. Simulatorabnahme

**Status: OPEN.** Auf macOS mit Xcode und Apple-Vision-Pro-Simulator auszufuehren:

1. Cold Start: Volume B/H/T, Start-Root, Slider und Panel B/H protokollieren.
2. Fuenf vollständige Sitzungen mit `Ergebnis -> Erneut spielen` durchlaufen und dieselben Maße vergleichen.
3. Kleine Toleranz nur fuer Laufzeit-/Float-Messrauschen verwenden; empfohlen maximal 1 Layoutpunkt beziehungsweise 1 mm, nicht fuer sichtbare Abweichungen.
4. Volume zulässig verändern, Sitzung durchspielen und bestätigen, dass Replay die veränderte aktuelle Größe erhält.
5. Fachlichen Reset auf Ticketanzahl 6, Score/Index 0, leere Tickets, `nil`-Entscheidungen und freien Input prüfen.

## 8. Regression

Statisch unverändert: HUD, Ticketinfo, Feedback, Retry, Drag-/Drop-Auswertung, 50-%-Overlap, Z-Toleranz, Snapback, Exactly-once, Audio und Transition. Ihre visuelle/interaktive Regression sowie Startseite, Ergebnis und vollständiger Replay-Ablauf bleiben mangels Simulator OPEN.

## Erfüllte Akzeptanzkriterien

- [x] AK-25 (Codearchitektur) — zentrale Rootbasis, aktuelle Geometry als Quelle, kein Default-Reset und keine kumulative Rechnung.
- [x] AK-25.7 — fachlicher Reset unverändert und zusätzlich regressionsgeprüft.
- [ ] AK-25.1–6 (Laufzeitabnahme) — OPEN, weil Xcode/visionOS-Simulator in dieser Umgebung fehlt.

Gesamtstatus AK-25: **OPEN bis zur verpflichtenden Simulatorabnahme**.

## Bereitgestellte Schnittstellen

- `LayoutConstants.startSliderDesignWidth` — feste Designbreite des Start-Sliders.
- Keine neue fachliche oder persistente Schnittstelle; insbesondere kein Volume-State im `SessionModel`.

## DebugManager

Keine neue Kategorie und kein Renderframe-Logging. Vorhandene Geometry-Logs koennen fuer die Simulator-Messung verwendet werden.

## Git

- Vorgesehener Commit: `021: Replay-Layoutstabilisierung`
- Commit/Hash: nicht erzeugt; Build, Testlauf und Pflicht-Simulatorabnahme sind in dieser Umgebung offen.

## Stand aktualisiert

- [ ] `Projekt-Stand.md` nicht überschrieben, da dort bereits fremde uncommittete Änderungen liegen.
- [ ] `Logbuch-Stand.md` aus demselben Grund nicht überschrieben.
- [x] Vollständiger Modulreport neu angelegt.

## Annahmen / offene Punkte / Risiken

- Die SwiftUI-/visionOS-Kompilierung der neuen `GeometryReader3D`-Huelle muss in Xcode bestätigt werden.
- Die reale Systempolitik eines manuell veränderten volumetrischen Fensters und die visuelle Toleranz können nur im Simulator/Gerät bestätigt werden.
- Erst Laufzeitmessungen können AK-25 endgültig von OPEN auf PASS setzen.

## Empfehlung für Modul 022 — Punktekommunikation v1.2

Vor Modul 022 den vollständigen 304-Test-Lauf und die oben beschriebene Fünf-Replay-/Resize-Abnahme durchführen. Danach Modul 022 ausschließlich auf F-26/F-27 begrenzen und die stabile Rootbasis nicht erneut phasenspezifisch umgehen.
