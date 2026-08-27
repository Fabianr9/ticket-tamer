# Modul-Eingangsprompt — 014 Abschlussdokumentation und Cleanup

> Vom Projektlogbuch nach Einarbeitung des **aktualisierten** `013-Report.md` erzeugt. Dies ist das letzte reguläre Modul. Es darf offene Pflichtnachweise nicht durch Dokumentation ersetzen.

---

Du bist Abschluss-, QA- und Dokumentationsverantwortliche:r für Ticket Tamer.

## Modul

**Nummer:** 014  
**Titel:** Abschlussdokumentation und Cleanup

**Ziel:** Den realen Projektstand konsistent dokumentieren, Altlasten entfernen und den Abgabezustand eindeutig bewerten. Ticket Tamer darf nur als vollständig abgabebereit gelten, wenn alle Pflichtanforderungen F-01 bis F-16 tatsächlich nachgewiesen sind.

## Hartes Abschluss-Gate

Der aktualisierte Modul-013-Stand enthält inzwischen eine stark überarbeitete Interaktionsarchitektur mit gemessenen Laufzeitwerten und 50-%-Drop-Regel.

Nach Fix 8 fehlen aber noch zentrale Nachweise:

- Build nach Fix 8
- vollständige 208-Test-Suite
- AK-06 Untersuchung
- AK-07 Weiter zur Priorisierung
- AK-08 Nachtest aller drei Prioritätsziele
- AK-09 Nachtest aller vier Teamziele
- AK-10 Invalid/Valid/Lock/Exactly-once nach Fix 8
- AK-11 vollständige Scoring-Laufzeitmatrix
- AK-12 `incorrect.wav` + genau-einmal-Audio
- AK-14 eigener Blender-Source-/Ownership-Nachweis + alle vier echten Meshes mit Gesten
- AK-16 mindestens fünf stabile Neustarts
- Apple-Vision-Pro-Gerätetest

Diese Punkte dürfen nur mit realer neuer Evidenz zu PASS werden.

## Aktueller technischer Stand

### Testzahl

Aktuell im Quellcode:

**208 `@Test`-Deklarationen**

Davon:

**34 Tests** in der Suite `Modul 013 — Zielpanels und 50-%-Drop`.

Der vollständige Testlauf wurde noch nicht ausgeführt.

### Tatsächliches Volume

Simulatortrace vom 27.08.2026:

`0.284 × 0.236 × 0.235 m`

Die alten Default-Konstanten:

`1.0 × 1.0 × 0.4 m`

dürfen **nicht** als reale Geometriegrundlage verwendet werden.

### Drop-Regel

Verbindlicher aktueller Stand:

- sichtbare flache 3D-Panels
- mindestens 50 % der projizierten **Monsterfläche** muss über dem Ziel liegen
- Z-Oberflächenabstand höchstens 0.05 m
- Highlight während Drag zeigt ausschließlich „Drop wäre jetzt gültig“
- Speicherung ausschließlich beim Loslassen
- ungültiger Drop → Snapback
- sichtbares Panel und Drop-Geometrie sind dieselbe Box

### Neue Services aus 013

- `VolumeMetrics`
- `DragBounds`
- `MonsterDragGeometry`
- `TargetPanelLayout`
- `TargetPanelFactory`

### Assetstand

Integriert:

- `Monster_1_blue.usdc`
- `Monster_2_green.usdc`
- `Monster_3_yellow.usdc`
- `Monster_4_red.usdc`

Die vier USDA-Wrapper referenzieren diese Dateien.

## Phase 0 — Abschlussnachtests aus Modul 013

Bevor du Dokumentation finalisierst, versuche zuerst die noch offenen 013-Nachtests abzuschließen.

### Build

Führe einen Build des **aktuellen Fix-8-Stands** aus.

Dokumentiere:

- Xcode-Version
- visionOS-SDK
- Deployment Target
- Simulatorziel
- Build PASS/FAIL
- relevante Warnungen

Der frühere Build nach Fix 5 reicht nicht als finaler Buildnachweis.

### Tests

Führe `Product → Test` / vollständige Suite aus.

Erwarteter Deklarationsstand:

208.

Dokumentiere real:

- Testzahl
- Passed
- Failed
- Skipped
- Laufzeit
- Plattform

Keine Zahlen erfinden.

## Phase 1 — AK-06 / AK-07

Prüfe:

- Monster sichtbar
- Ticketnummer
- Titel
- Kurzbeschreibung
- Auswirkung
- alle Symptome
- keine Referenzpriorität sichtbar
- kein Referenzteam sichtbar
- „Weiter zur Priorisierung“
- nach Wechsel bleibt dasselbe Ticket aktiv

Nur bei vollständigem Nachweis PASS.

## Phase 2 — AK-08 Priorisierung nach Fix 8

Für:

- Normal
- Wichtig
- Kritisch

und nach Möglichkeit für alle vier Monsterassets:

Prüfe jeweils schrittweise:

- ca. 10 % Überlappung → kein Highlight, Snapback
- ca. 25 % → kein Highlight, Snapback
- knapp unter 50 % → kein Highlight, Snapback
- ab mindestens 50 % → Highlight
- Loslassen → genau dieses Ziel gespeichert

Zusätzlich:

- kein Clipping an Volume-Rändern
- Input-Lock nach gültigem Drop
- kein zweiter Entscheidungswechsel

## Phase 3 — AK-09 Team nach Fix 8

Für:

- Netzwerk
- Konto
- Software
- Hardware

dieselbe Prüfung:

- 10 %
- 25 %
- knapp unter 50 %
- mindestens 50 %
- Highlight
- korrekte Speicherung
- Lock
- Snapback bei ungültigem Drop

## Phase 4 — AK-10 Exactly-once / Regression

Prüfe:

- gültiger Drop genau einmal
- zweiter Release ignoriert
- schnelles mehrfaches Pinchen ignoriert
- keine Doppelwertung
- kein doppelter Sound
- kein doppelter Transition-Task
- ungültiger Drop verändert Entscheidung/Score/Phase nicht
- Snapback exakt ohne Drift
- keine Scale-/Rotationsänderung

## Phase 5 — Clipping / Geometrie

Mit jedem Monster:

- links maximal
- rechts maximal
- oben maximal
- unten maximal
- vier Ecken

Monster muss vollständig sichtbar bleiben.

Prüfe außerdem Panels aus:

- frontal
- leicht links
- leicht rechts
- leicht oben

Zieltext muss lesbar und räumliche Zuordnung eindeutig bleiben.

## Phase 6 — Z-Frame-Restpunkt

Der 013-Report dokumentiert:

`local=0.06 → world=0.178`

also einen Z-Versatz zwischen lokalem und Scene-Raum.

Prüfe, ob im aktuellen System irgendwo:

- Scene-Volumegrenzen
- lokale Entity-Positionen

direkt miteinander verrechnet werden.

Wenn ja:

- minimalen Koordinatenraum-Fix durchführen
- Regressiontests ergänzen
- dokumentieren

Wenn nein und das System nachweislich konsistent ist:

- Restpunkt als geprüft schließen
- keine unnötige Architekturänderung

## Phase 7 — Scoring AK-11

End-to-End mindestens:

- Priorität richtig + Team richtig → +200
- Priorität richtig + Team falsch → +100
- Priorität falsch + Team richtig → +100
- beide falsch → +0

Prüfe:

- kein negativer Score
- keine Doppelwertung
- Score akkumuliert über mehrere Tickets

## Phase 8 — Audio AK-12

Prüfe:

- `correct.wav` hörbar
- `incorrect.wav` hörbar
- richtiges Mapping
- genau ein Sound je gültiger Entscheidung
- keine doppelte Wiedergabe

Keine richtige Lösung sichtbar.

## Phase 9 — AK-13

Regressionsprüfung:

- Input während Feedback gesperrt
- keine Lösung
- kein Richtig/Falsch-Text
- ca. 1,5 s Priorität → Team
- ca. 1,5 s Team → nächstes Ticket/Ergebnis

## Phase 10 — AK-14 Monsterabschluss

Prüfe:

- alle vier unterschiedlichen Monster lokal sichtbar
- alle vier mit Blick/Pinch/Drag verwendbar
- Skalierung aller vier angemessen
- Y-up-Korrektur aller vier korrekt
- Farbwahl codiert keine Antwort

Zusätzlich zwingend dokumentieren:

**Wie ist nachgewiesen, dass die Monster eigene Blender-Modelle sind?**

Der Report nennt echte Blender-USDC-Exporte, aber im geprüften Ordner liegen keine `.blend`-Quelldateien.

Mögliche Evidenz:

- `.blend`-Quelldateien an anderem dokumentierten Projektort
- Blender-Arbeitsordner
- Exportdokumentation
- nachvollziehbarer eigener Erstellungsnachweis

Wenn kein solcher Nachweis vorhanden ist:

**AK-14 bleibt OPEN.**

## Phase 11 — AK-15 / AK-16

### Ergebnis

Sichtbar ausschließlich:

- Scorezahl
- `Erneut spielen`

Keine Ticketanzahl, Statistik, Lösung, Rangliste oder Badge.

### Reset

Mindestens fünf aufeinanderfolgende Neustarts.

Nach jedem:

- Start
- Regler 6
- Score 0
- Index 0
- leere Sitzung
- Priorität nil
- Team nil
- Lock false
- keine alten Tasks
- kein Carryover

## Phase 12 — Stabilität

Mindestens:

- 1-Ticket-Sitzung
- 2-Ticket-Sitzung
- 6-Ticket-Sitzung
- 12-Ticket-Sitzung
- schnelle Gesten
- mehrere Invalid-Drops
- mehrere Resets

Keine Crashes oder Phasen-Deadlocks.

## Phase 13 — Gerätetest

Wenn Apple Vision Pro verfügbar:

- Build auf Gerät
- Blickfokus
- Pinch
- Drag
- Drop-Zielgröße
- Panel-Lesbarkeit
- Monstergröße
- Audio
- Ergebnis/Reset

Wenn kein Gerät verfügbar:

- offen dokumentieren
- nicht als PASS erfinden

## Phase 14 — Cleanup

Entferne, falls tatsächlich vorhanden und nicht mehr benötigt:

- `_abgeloest/TargetFrameReporter.swift`
- `.git/index.lock.stale-bitte-loeschen`
- `.DS_Store`
- Backup-/Copy-Dateien
- veraltete Standdokumente

Unter `Dokumentation/05_Aktueller-Stand/` genau:

- `Projekt-Stand.md`
- `Logbuch-Stand.md`

## Phase 15 — DEBUG-Cleanup

Prüfe:

- `DebugInteractionHarnessView`
- `🔧 Team [DEV]`
- DROP-DEBUG-Trace
- DebugManager-Ausgaben

DEBUG-only Hilfen dürfen bleiben, wenn:

- sie im Release nicht sichtbar sind
- keine Release-Funktion davon abhängt
- Logs nicht unnötig sensibel/laut sind

Entferne keine hilfreiche Debugstruktur nur aus kosmetischen Gründen.

## Phase 16 — Dokumentationskonsistenz

Synchronisiere:

- `Projekt-Stand.md`
- `Logbuch-Stand.md`
- finale AK-Matrix
- README/Abgabehinweise, falls vorhanden

Anforderungen selbst nicht umschreiben.

Korrigiere alte Aussagen wie:

- 155 Tests statt aktuell 208
- Kugel-Platzhalter seien noch aktuelle Monster
- alte Radius-/Column-/Nearest-Drop-Logik sei noch produktiv
- `defaultSize` sei tatsächliches Volume
- F-17 = Highscore/Persistenz
- Ergebnis zeige Ticketanzahl

## Finale AK-Matrix

Verwende als Ausgangspunkt:

| AK | Startstatus vor Abschlussnachtest |
|---|---|
| AK-01 | PASS |
| AK-02 | PASS |
| AK-03 | PASS |
| AK-04 | PASS |
| AK-05 | OPEN |
| AK-06 | OPEN |
| AK-07 | OPEN |
| AK-08 | OPEN |
| AK-09 | OPEN |
| AK-10 | OPEN |
| AK-11 | OPEN |
| AK-12 | OPEN |
| AK-13 | PASS |
| AK-14 | OPEN |
| AK-15 | PASS |
| AK-16 | OPEN |

Verbessere einen Status nur mit neuem realem Nachweis.

## F-17

Bleibt bewusst ausgelassen.

Keine Monsterreaktion in Modul 014 ergänzen.

## Git

Vor Abschluss:

- aktuellen Branch
- aktuellen HEAD
- tatsächlichen Modul-013-Commit
- Working Tree

prüfen.

Falls Modul 013 noch nicht committed ist:

Vorgesehene Nachricht:

`013: Integration, Zielpanels und Drop-Erkennung`

Danach Modul 014:

`014: Abschlussdokumentation und Cleanup`

Alle echten Hashes dokumentieren. Keine erfinden.

## Abschlussstatus

Am Ende genau eine Aussage:

### A — Abgabebereit

Nur wenn alle Pflicht-AKs tatsächlich PASS sind.

oder

### B — Nicht vollständig abgabebereit

Dann offene/fehlgeschlagene Punkte priorisiert nennen.

## Ausgabeformat

1. Vorab-Check
2. Build/Test nach Fix 8
3. 013-Nachtests
4. Asset-/Audioabschluss
5. finale AK-01-bis-AK-16-Matrix
6. Cleanup
7. DEBUG-/Release-Prüfung
8. Dokumentationsänderungen
9. finaler Dateibaum
10. Abgabe-Checkliste
11. Abschlussstatus A oder B
12. vollständiger `014-Report.md`

Nichts als PASS markieren, was nicht tatsächlich nachgewiesen wurde.
