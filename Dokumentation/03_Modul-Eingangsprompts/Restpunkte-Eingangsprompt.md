# Restpunkte-Eingangsprompt — AK-06 und finaler Abgabestand

> Kein neues Fachmodul. Dieser Prompt dient ausschließlich dazu, den letzten offenen Pflichtpunkt aus Modul 014 zu schließen und den finalen Git-/Abgabestand sauber zu dokumentieren.

---

Du bist für den letzten Restpunkt von Ticket Tamer verantwortlich.

## Ziel

Aktueller Stand:

- Build PASS
- 208/208 Tests PASS
- 15/16 Pflicht-AKs PASS
- einzig offenes Pflicht-AK: **AK-06**
- Gerätetest Apple Vision Pro offen als Restrisiko
- Modul-014-Änderungen noch nicht committed
- aktiver Branch `side`
- `origin/main` zeigt auf denselben Stand wie `side`
- lokaler `main` ist älter

Du darfst ausschließlich:

1. den Clippingfehler des roten Monsters in der Untersuchungsansicht beheben,
2. AK-06 nachtesten,
3. Regressionen prüfen,
4. Dokumentation synchronisieren,
5. Git-/Branch-/Commit-Stand finalisieren.

Keine neuen Features.

## Fehlerbild

Betroffen:

`monster04` / `Monster_4_red.usdc`

Ort:

`InvestigationView`

Symptom:

Das rote Monster wird zusammen mit dem Ticketinhalt teilweise abgeschnitten.

Nicht betroffen:

- Priorisierung
- Teamzuordnung
- DragBounds
- 3D-Zielpanels
- DropEvaluator
- Scoring
- Audio
- Ergebnis
- Reset

## Relevante Kandidaten

Prüfe real:

- `Views/InvestigationView.swift`
- `Views/Components/ScaledToFitView.swift`
- `Assets/MonsterAssetProvider.swift`
- vorhandene Investigation-Layoutconstants

Nicht ungeprüft dieselbe Lösung wie in den Drag-Phasen übernehmen.

Die Untersuchungsansicht hat andere Anforderungen:

- Monster nur darstellen
- keine Drag-Grenzen
- Tickettext vollständig sichtbar
- Monster vollständig sichtbar
- alle vier Assets konsistent

## Vorgehen

### 1. Git-/Preflight

Ermittle:

- Branch
- HEAD
- Working Tree
- tatsächlichen Modul-014-Stand
- ob Modul 014 bereits committed wurde
- Status von lokalem `main` und `origin/main`

Keine Hashes erfinden.

### 2. Fehler reproduzieren

Im Simulator mit `monster04`:

- Untersuchungsansicht öffnen
- Screenshot/visuelle Prüfung
- feststellen, an welcher Kante abgeschnitten wird
- aktuelle Bounds/Scale/Frame-Verhältnisse dokumentieren

### 3. Ursache isolieren

Prüfe insbesondere:

- wird `fit(toMaxExtent:)` doppelt oder falsch angewandt?
- skaliert `ScaledToFitView` den Root oder ein Kind?
- gibt es feste Frames/Paddings?
- konkurriert Monsterhöhe mit TicketCard?
- unterscheiden sich Bounds des roten Assets deutlich?
- wird tatsächlicher verfügbarer Raum gemessen oder angenommen?

Keine Magic-Number-Lösung, wenn die Ursache messbar ist.

### 4. Minimalen Fix implementieren

Ziel:

- alle vier Monster vollständig sichtbar
- Tickettext vollständig sichtbar
- keine Überlappung
- keine Änderung der Drag-/Drop-Geometrie in Priorisierung/Team
- keine Änderung am Scoring/Audio/Flow

Bevorzuge eine lokale Investigation-Lösung.

### 5. Alle vier Assets nachtesten

Prüfe:

- monster01
- monster02
- monster03
- monster04

Jeweils:

- vollständig sichtbar
- sinnvoll skaliert
- Ticketkarte unverändert vollständig
- keine Referenzwerte sichtbar

### 6. AK-06 vollständig nachtesten

PASS nur wenn:

- Monster vollständig sichtbar
- Ticketnummer
- Titel
- Kurzbeschreibung
- Auswirkung
- alle Symptome
- keine Referenzpriorität
- kein Referenzteam

### 7. Regression

Mindestens:

- Start → Untersuchung
- Weiter → Priorisierung
- Prioritätsdrop
- Teamdrop
- Ergebnis
- Reset

Prüfe, dass der AK-06-Fix nichts anderes beeinflusst.

### 8. Tests

Führe erneut die vollständige Suite aus.

Soll:

- 208 Tests
- 208 Passed
- 0 Failed
- 0 Skipped

Wenn neue Tests für die Investigation-Skalierung sinnvoll sind, darf die Zahl steigen. Dann echte neue Zahl dokumentieren.

### 9. Build

Finaler Build nach dem Fix:

- Xcode
- visionOS Simulator
- PASS/FAIL
- relevante Warnungen

### 10. Abschlussmatrix

Wenn AK-06 bestanden:

- AK-01 bis AK-16 = PASS
- Pflichtstatus = 16/16 PASS

Gerätetest separat:

- falls durchgeführt → Ergebnis dokumentieren
- falls nicht verfügbar → als Restrisiko offen lassen

Der fehlende Gerätetest darf nicht als PASS erfunden werden.

### 11. Git finalisieren

Kläre den Abgabebranch.

Aktueller gemeldeter Zustand:

- Branch `side`
- HEAD = origin/main
- lokaler main älter

Vor Abgabe soll eindeutig sein:

- welcher Branch abgegeben wird
- welcher Commit der finale Stand ist
- Working Tree sauber

Wenn passend, lokalen `main` sauber an den tatsächlichen Abgabestand angleichen. Keine History-Umschreibung ohne Not.

### 12. Dokumentation

Gemeinsam aktualisieren:

- `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md`
- `Dokumentation/05_Aktueller-Stand/Logbuch-Stand.md`
- Abschlussmatrix
- ggf. 014-Report als Nachtrag oder separaten Restpunkte-Report

Keine alten widersprüchlichen aktuellen Standdateien danebenlegen.

## Abschlussstatus

Am Ende genau:

### A — Abgabebereit

wenn AK-06 PASS und alle Pflicht-AKs PASS sind,

oder

### B — Nicht vollständig abgabebereit

wenn AK-06 weiterhin offen/fehlgeschlagen ist.

Gerätetest als separates Restrisiko angeben.

## Ausgabe

Erzeuge einen kurzen `Restpunkte-Report.md` mit:

- Git
- Ursache AK-06
- Fix
- geänderte Dateien
- Build
- Tests
- Simulatornachweis alle vier Monster
- finale AK-Matrix
- Geräteteststatus
- finaler Branch/Commit
- Abschlussstatus A/B
