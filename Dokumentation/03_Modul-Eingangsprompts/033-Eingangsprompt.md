# Modul-Eingangsprompt — 033 Integration und Abnahme v1.3

> Vom **Projektlogbuch** nach Einarbeitung des `032-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Modul 033 ist das finale Integrations- und Abnahmemodul für Ticket Tamer v1.3.

---

Du bist Integrations-, QA- und Abschlussverantwortliche:r für Ticket Tamer v1.3.

# Modul

**Nummer:** 033  
**Titel:** Integration und Abnahme v1.3  
**Erfüllt:** F-01 bis F-39, Schwerpunkt F-31 bis F-39

**Ziel:** Baue und teste den vollständigen v1.3-Stand auf der echten Apple-Toolchain, führe die vollständige visionOS-Simulatorabnahme durch und verifiziere insbesondere die neuen Tickets, Videos, Teamlogos, Audiozufallsauswahl, Streak-Sounds, Streak-State, Multiplikator-Scoring, Zusatzpunkteanzeige, x2/x3/x4+-Feedback, Reset und Ressourcenstruktur. Gleichzeitig müssen die stabilen v1.2-Funktionen ohne Regression erhalten bleiben. Modul 033 führt keine neuen Features ein.

---

# Ausgangsstand

v1.0, v1.1 und v1.2 sind abgeschlossen.

v1.3 Featuremodule:

- 027 — neue Tickets / 16er-Sitzung
- 028 — Teamlogos
- 029 — Monster- und Streak-Audio
- 030 — Ticketvideos
- 031 — Streak-State und Scoring
- 032 — Streak-Feedback

Laut `032-Report.md`:

- Branch `v1.3`
- HEAD vor 032 `df4b6f5e41f134459399b6a4de5354b67c2adabe`
- tatsächlicher Modul-031-Commit `df4b6f5`
- Modul-032-Commit im Report noch offen
- Tests vor 032: 522
- neue Tests: 54
- Tests nach 032: **576**
- Build/Test/Simulator/Audio: OPEN

---

# Abschlussregel

v1.3 darf nur als vollständig abgenommen markiert werden, wenn die real prüfbaren Muss-Kriterien nachgewiesen sind.

Status:

- **PASS** = real nachgewiesen
- **OPEN** = nicht geprüft/nicht belegbar
- **FAIL** = real fehlgeschlagen

Keine statische Codeimplementierung automatisch als vollständigen Runtime-PASS ausgeben.

---

# Phase 1 — Git- und Preflight-Abschluss

Ermittle real:

- Branch
- HEAD
- Working Tree
- staged
- untracked
- tatsächlichen Modul-032-Commit

Wenn 032 noch uncommitted:

1. Build/Test so weit möglich.
2. Modul 032 separat committen.
3. echten Hash dokumentieren.

Vorgesehen:

`032: Streak-Feedback v1.3`

Keine Hashes erfinden.

Prüfe zusätzlich:

- keine stale Git-Locks
- keine `.DS_Store`-Altlasten, sofern versioniert
- keine Backup-/Copy-Dateien
- keine unnötigen alten parallelen Standdateien

---

# Phase 2 — Apple-Toolchain dokumentieren

Dokumentiere real:

- macOS-Version
- Xcode-Version
- visionOS SDK
- Deployment Target
- Build Configuration
- Simulatorname
- Simulator-visionOS-Version
- Architektur

Zielplattform:

Apple Vision Pro / visionOS unter der bestehenden Projektkonfiguration.

---

# Phase 3 — Vollständiger Build

Führe den vollständigen App-Build aus.

Dokumentiere:

- Build PASS/FAIL
- relevante Compilerfehler
- relevante Projektwarnungen
- Resource-Bundle-Warnungen
- AVKit-/AVFoundation-Warnungen
- RealityKit-/Assetwarnungen

Keine plattformseitigen Simulator-Systemlogs als Projektfehler missklassifizieren.

---

# Phase 4 — Vollständige Testsuite

Dokumentierter Quellstand:

**576 `@Test`-Deklarationen**

Real zählen.

Dann vollständigen Testlauf ausführen.

Dokumentiere:

- tatsächliche Deklarationen
- tatsächlich ausgeführte Tests
- Suites
- Passed
- Failed
- Skipped
- Laufzeit
- Plattform

Bei Abweichung von 576:

- reale Zahl verwenden
- Ursache dokumentieren
- nichts künstlich angleichen

Kein PASS bei nur statischer Zählung.

---

# Phase 5 — AK-31 neue v1.3-Ticketinhalte

Verbindlich:

`Tickets/Ticket-Tamer_Tickets.md`

Prüfe produktiven Katalog:

- genau TT-001...TT-016
- keine historischen alten sichtbaren Tickettexte
- Titel/Beschreibung/User Impact/Hinweise entsprechen der Quelle
- TT-001...TT-012 Referenzmatrix unverändert
- TT-013 Netzwerk + Wichtig
- TT-014 Konto + Normal
- TT-015 Software + Wichtig
- TT-016 Hardware + Kritisch
- jedes Team 4
- Normal 5 / Wichtig 6 / Kritisch 5

Simulator:

Stichproben mindestens:

- TT-001
- TT-007
- TT-013
- TT-016

Prüfen:

- Untersuchungstext korrekt
- Ticketinfo korrekt
- ohne Video lösbar
- keine direkte Lösungsausgabe

Sitzung mit 16 Tickets:

- keine Wiederholung
- HUD `Ticket 1 von 16` bis `Ticket 16 von 16`

---

# Phase 6 — Start-/Sitzungsgrenze 1...16

Prüfe:

- App-Start Standard 6
- Slider nur ganze Zahlen
- Minimum 1
- Maximum 16
- Minus bei 1 disabled
- Plus bei 16 disabled
- Slider/Minus/Plus/Zahl synchron
- technische Clamp <1 → 1
- Clamp >16 → 16

Sitzungen:

- 1 Ticket
- 6 Tickets
- 16 Tickets

Kein Crash, keine Duplikate.

---

# Phase 7 — AK-32 Videozuordnung und Start

Produktiv:

- TT-001.mp4 ... TT-016.mp4
- exakt 16 Dateien im Videoressourcenbereich
- 1:1-Ticketmapping

Prüfe:

- `Video ansehen` in Investigation sichtbar
- ohne Tap kein Video
- TT-007 öffnet exakt TT-007.mp4
- analog Bundle-Lookup alle 16

`TT-002A.mp4` bleibt unreferenziert.

---

# Phase 8 — AK-33 Videowiedergabe

Für mehrere Tickets, mindestens TT-001, TT-007, TT-016:

1. `Video ansehen`
2. Video startet automatisch nach Öffnung
3. Pause
4. Fortsetzen
5. sichtbares X
6. manuell schließen
7. gleiches Ticket bleibt aktiv
8. erneut öffnen
9. bis Ende laufen lassen
10. Auto-Close
11. gleiches Ticket bleibt aktiv

Vorher/nachher unverändert:

- currentTicket
- currentTicketIndex
- currentPhase `.untersuchen`
- score
- streak
- selectedPriority
- selectedTeam
- Monster-Variantenmapping

## Fehlerfall

Kontrolliert fehlende/ungültige Ressource über testbare Provider-Injektion simulieren.

Prüfe:

- kein Crash
- verständliche Fehlermeldung
- X schließt
- Ticket weiter spielbar
- keine Score-/Streak-/Indexmutation

---

# Phase 9 — AK-28 Teamlogos / AK-39 Logo-Ressourcen

Alle vier Stationen:

- Netzwerk JPEG + Text
- Konto JPEG + Text
- Software JPEG + Text
- Hardware JPEG + Text

Prüfe:

- korrektes Logo
- Text vollständig
- Seitenverhältnis
- keine Verzerrung
- kein Clipping
- keine historischen SF-Symbole produktiv
- Accessibility über Teamtext

Blickwinkel:

- frontal
- leicht links
- leicht rechts
- leicht oben

Fehlendes-Logo-Fallback:

- kein Crash
- Text bleibt
- Target bleibt
- Teamzuordnung funktioniert

---

# Phase 10 — Teamgeometrie / Drop-Regression

Modul 028 darf Geometrie nicht verändert haben.

Referenzwerte aus v1.2/v1.3:

- Panelbreite `0.195 m`
- Panelhöhe `0.117 m`
- Paneltiefe `0.020 m`
- minimum overlap `0.50`
- Z-Toleranz `0.05 m`

bei dokumentierter Referenzgeometrie.

Prüfe real:

- Targetpositionen
- Drop halfExtents
- 50-%-Overlap
- Z-Toleranz
- Snapback
- alle vier Teamtargets
- alle drei Prioritytargets
- keine Logo-/Overlaybedingte Verschiebung

---

# Phase 11 — AK-34 Monster-Soundvarianten

Ressourcen:

- 4 Correct
- 4 Incorrect

Prüfe Bundle-Ladung aller acht.

Deterministische Auswahl/Test-Hook:

- jede Correct-Variante erreichbar
- jede Incorrect-Variante erreichbar

Laufzeit:

- richtige Priorität → genau 1 Correct-Monster-Sound
- falsche Priorität → genau 1 Incorrect-Monster-Sound
- richtiges Team → genau 1 Correct
- falsches Team → genau 1 Incorrect
- ungültiger Drop → kein Bewertungssound

Direkte Wiederholung derselben Variante zweimal hintereinander:

zulässig.

Keine Anti-Repeat-Logik.

Prüfe soweit hörbar:

Monster-Sounds enthalten keine verständliche Sprache.

Falls nicht sicher hörbar:

OPEN dokumentieren.

---

# Phase 12 — AK-35 Streak-Sounds

Mapping:

- Streak 0/1 → kein Streak-Sound
- x2/x3 → Sound 01
- x4+ → Sound 02

Nur:

vollständig korrekter Teamabschluss.

Nie:

Prioritätsentscheidung.

Audiofolge bei qualifiziertem Teamabschluss:

1. Correct-Monster-Sound
2. ca. 0.2 s
3. Streak-Sound
4. restliches Feedbackfenster

Prüfe:

- nicht exakt unbeabsichtigt gleichzeitig
- höchstens ein Streak-Sound
- Monster-Sound weiterhin genau einmal
- kein Streak-Sound bei Partial-Fall
- kein Streak-Sound bei x1

---

# Phase 13 — AK-36 Streak-State und Reset

Prüfe real:

Neue Sitzung:

`streak = 0`

Vollständig korrektes Ticket:

`streak += 1`

Eine falsche Entscheidung:

`streak = 0`

Nach Unterbrechung:

nächstes vollständig korrektes Ticket beginnt bei 1.

Kein künstlicher Cap.

Prüfe:

- x5
- optional bis x16

Reset:

- `streak = 0`
- `currentPriorityWasCorrect = nil`
- Team-Abschlussmetadaten neutral
- keine Carryover-Werte

Video:

darf Streak nicht verändern.

Retry:

darf Streak nicht verändern.

---

# Phase 14 — AK-37 Multiplikator-Scoring

Verbindliche Matrix:

| vorherige Streak | Priority | Team | neue Streak | Priority Credit | Team Credit | Ticket total |
|---:|---|---|---:|---:|---:|---:|
| 0 | ✓ | ✓ | 1 | 100 | 100 | 200 |
| 1 | ✓ | ✓ | 2 | 100 | 300 | 400 |
| 2 | ✓ | ✓ | 3 | 100 | 500 | 600 |
| 3 | ✓ | ✓ | 4 | 100 | 700 | 800 |
| 3 | ✓ | ✗ | 0 | 100 | 0 | 100 |
| 3 | ✗ | ✓ | 0 | 0 | 100 | 100 |
| 3 | ✗ | ✗ | 0 | 0 | 0 | 0 |

Zusätzlich:

`Ticket total = 200 × streak`

für jedes vollständig korrekte Ticket.

Prüfe:

- keine Doppelzählung
- keine negativen Punkte
- keine Rücknahme alter Multiplikatorpunkte
- Exactly-once

Sequenzen:

1. korrekt, korrekt, korrekt → **1200**
2. korrekt, Priority korrekt/Team falsch, korrekt → **500**
3. Priority falsch/Team korrekt, korrekt → **300**

Ergebnisansicht muss exakt diese Summen zeigen.

---

# Phase 15 — AK-21 dynamische Punktedarstellung

Priorität:

- correct → `+100 Punkte`
- incorrect → `0 Punkte`

Team:

- x1 → `+100 Punkte`
- x2 → `+300 Punkte`
- x3 → `+500 Punkte`
- x4 → `+700 Punkte`
- x5 → `+900 Punkte`
- Team correct nach falscher Priority → `+100 Punkte`
- Team falsch → `0 Punkte`

Prüfe:

- UI liest fachlich berechnete Punkte
- keine zweite Scoremutation
- keine Lösung
- Accessibility mit korrektem Punktwert

---

# Phase 16 — AK-38 Streak-Visualisierung

Prüfe:

## x0 / x1
- kein Multiplikatoroverlay

## x2
- `x2`
- normal

## x3
- `x3`
- normal
- gleichartige Darstellungsstufe wie x2

## x4
- `x4`
- sichtbar größer
- kurze Scale-/Pulse-Animation

## x5+
- `xN`
- gleiche starke Logik wie x4

Prüfe:

- Overlay nur Teamabschluss
- nur vollständig korrekt
- temporär
- verschwindet nach Feedback
- nicht dauerhaft im HUD
- verdeckt Tickettext/Teamziele/Bedienelemente nicht dauerhaft

HUD:

weiterhin nur:

- Ticket X von Y
- Phase
- Fortschritt

Kein Score/Streak.

---

# Phase 17 — Feedbackdauer / Exactly-once

Gesamtes Feedbackfenster:

ca. 1.5 s

Qualifizierter Teamabschluss:

- Monster-Sound sofort
- 0.2 s
- Streak-Sound
- verbleibend ca. 1.3 s
- genau ein Transition

Prüfe schnellen Mehrfach-Pinch bei:

- Priorität
- Team x1
- Team x2+
- falscher Entscheidung

Jeweils:

- eine Bewertung
- eine Scoremutation
- maximal eine Streakmutation
- genau ein Monster-Sound
- höchstens ein Streak-Sound
- ein visuelles Feedback
- ein Phasenwechsel

---

# Phase 18 — AK-39 vollständige Ressourcenstruktur

Prüfe real:

```text
Resources/
├── Audio/
│   ├── MonsterSounds/
│   │   ├── Correct/
│   │   └── Incorrect/
│   └── StreakSounds/
├── TeamLogos/
└── Videos/
```

Oder funktional gleichwertig.

Bestätige:

- 8 Monster-WAVs
- 2 Streak-WAVs
- 4 JPEG-Teamlogos
- 16 MP4s

Zentrale Zuordnung:

- Ticketvideo über Provider
- Teamlogo über Catalog
- Monster-/Streak-Audio über Catalog/Service

Keine:

- Netzwerk-URLs
- absolute Entwicklerpfade
- verstreuten vollständigen Ressourcenpfade in Views

Release-/Simulator-Build:

muss alle Ressourcen ohne Netzwerkzugriff finden.

---

# Phase 19 — Monster-Farbvarianten Regression

Alle 16 Varianten weiterhin ladbar.

Ein Ticket behält Variante durch:

- Untersuchung
- Priorisierung
- Team
- Retry

Video öffnen/schließen:

Variante bleibt gleich.

Neue Sitzung:

darf neu wählen.

Keine Farb-Codierung von:

- Priority
- Team
- Correctness

---

# Phase 20 — Replay-Layoutstabilität

Mindestens:

- Cold Start
- Replay 1
- Replay 2
- Replay 3
- Replay 4
- Replay 5

Prüfe:

- StartView
- Slider
- Texte
- Prioritytargets
- Teamtargets
- Teamlogos
- Videooverlay nach Schließen
- Streakoverlay
- Monstergröße

Keine:

- kumulative Drift
- Shrink/Grow
- Carryover

Wenn Volume-Resize verfügbar:

- zulässig verändern
- Sitzung spielen
- Replay
- aktuelle Größe bleibt
- kein Reset auf Cold-Start-Größe

---

# Phase 21 — Sitzungs-/Resetstabilität

Sitzungen:

- 1 Ticket
- 6 Tickets
- 16 Tickets

Nach jedem `Erneut spielen`:

- Ticketanzahl 6
- Score 0
- Streak 0
- Index 0
- Entscheidungen nil
- `currentPriorityWasCorrect` nil
- Sessiontickets leer
- Monster-Variantenmapping leer
- Abschlussmetadaten neutral
- Video nicht präsentiert
- kein Streakoverlay
- kein Audio-Carryover

---

# Phase 22 — v1.2 Regression

Mindestens prüfen:

## Replay
- stabil

## Ergebnis
- `X Punkte`
- keine Zusatzstatistik

## Falsches Feedback
- `0 Punkte`

## DEV-Isolation
- `🔧 Team [DEV]` nie im normalen Debug-/Release-Flow

## Teamlogos
- v1.3-Logo ersetzt Symbol
- Text bleibt

## Monster
- 16 Varianten
- Retry gleiche Variante

## Drop
- 50 %
- Z-Toleranz
- Snapback

## Ticketinfo
- keine Lösung

## HUD/Hints
- vorhanden
- kein Score
- kein dauerhafter Streak

---

# Phase 23 — v1.0/v1.1 Kernregression

Prüfe den vollständigen Hauptflow:

```text
Start
→ Investigation
→ Priority
→ Team
→ nächstes Ticket
→ Result
→ Erneut spielen
```

Ein zentrales Volume.

Kein Immersive Space.

Keine zweite Produktnavigation.

Ticketdaten lokal.

Keine Benutzerkonten/Cloud.

---

# Phase 24 — Accessibility

Prüfe:

- Start Minus/Plus
- Tickettexte
- Ticketinfo
- Teamtexte
- Teamlogos nicht statt Text
- Video ansehen
- Video schließen
- Video-Fehlertext
- `+100/+300/+500/...`
- `0 Punkte`
- x2/x3/x4-Accessibility
- Retry

Keine Accessibility-Ausgabe darf:

- Referenzpriorität
- Referenzteam
- richtige Lösung

verraten.

---

# Phase 25 — Stabilitäts-/Langzeittest

Mindestens:

- 1-Ticket-Sitzung
- 6-Ticket-Sitzung
- 16-Ticket-Sitzung
- fünf Replay-Zyklen
- mehrere Videos öffnen/schließen
- mindestens ein Video bis Ende
- mehrere Retries
- korrekte/falsche Entscheidungen
- Streak x1 bis x5
- Partial-Fälle
- Invalid Drops
- schnelle Mehrfach-Pinches

Keine:

- Crashes
- Deadlocks
- doppelte Panels
- doppelte Monster
- stale Videooverlays
- stale Streakoverlays
- doppeltes Audio
- Score-Carryover
- Streak-Carryover
- Layoutdrift

---

# Phase 26 — Gerätetest

Wenn echte Apple Vision Pro verfügbar:

Prüfe zusätzlich:

- Blickfokus
- Pinch
- Drag
- Video
- Audio
- Teamlogos
- x4+-Puls
- Volume-Resize
- Replay
- Lesbarkeit

Wenn kein Gerät verfügbar:

- Gerätetest OPEN
- Simulatorstatus separat
- niemals Simulator als Gerätetest ausgeben

---

# Phase 27 — Integrationsfixes

Falls reale Fehler gefunden werden:

Nur kleine notwendige Integrationsfixes.

Für jeden Fix:

| Datei | Fehler | Ursache | Fix | Regressionstest |
|---|---|---|---|---|

Keine neuen Features.

Keine Architektur-Neugestaltung ohne zwingenden Fehlergrund.

---

# Finale AK-Matrix v1.3

Mindestens:

| AK | Code | Tests | Simulator | Gerät | Status | Nachweis |
|---|---|---|---|---|---|---|
| AK-31 | | | | | PASS/OPEN/FAIL | |
| AK-32 | | | | | PASS/OPEN/FAIL | |
| AK-33 | | | | | PASS/OPEN/FAIL | |
| AK-34 | | | | | PASS/OPEN/FAIL | |
| AK-35 | | | | | PASS/OPEN/FAIL | |
| AK-36 | | | | | PASS/OPEN/FAIL | |
| AK-37 | | | | | PASS/OPEN/FAIL | |
| AK-38 | | | | | PASS/OPEN/FAIL | |
| AK-39 | | | | | PASS/OPEN/FAIL | |

Zusätzlich die durch v1.3 geänderten früheren Kriterien:

- AK-01
- AK-02
- AK-03
- AK-04
- AK-11
- AK-12
- AK-16
- AK-18
- AK-21
- AK-22
- AK-28

jeweils mit aktuellem Status.

---

# Vollständige Regression-Matrix

AK-01 bis AK-30 mindestens kompakt klassifizieren:

- PASS
- OPEN
- FAIL

Bei unveränderten Bereichen darf ein kombinierter Nachweis aus vollständigem Testlauf + gezieltem Simulatorcheck verwendet werden.

Keine alte PASS-Angabe übernehmen, wenn v1.3 das betreffende Verhalten bewusst geändert hat.

---

# Ressourcen-Abschlussinventar

Erstelle final:

## Audio

| Gruppe | Soll | Ist | Bundle PASS |
|---|---:|---:|---|
| Correct | 4 | | |
| Incorrect | 4 | | |
| Streak | 2 | | |

## Logos

| Team | Datei | sichtbar | Fallback |
|---|---|---|---|

## Videos

| Ticket | MP4 | Bundle | Playback |
|---|---|---|---|

Alle 16.

## Monster

| Typ/Variante | ladbar | sichtbar | Drag/Drop |
|---|---|---|---|

Alle 16 Varianten soweit praktikabel.

---

# Git-/Cleanup-Abschluss

Prüfe:

- Branch
- finaler Modul-032-Commit
- ggf. 033-Integrationsfixcommit
- Working Tree
- staged/untracked
- alte Platzhalterressourcen
- unreferenzierte historische `correct.wav` / `incorrect.wav`
- `TT-002A.mp4`
- `.DS_Store`
- parallele Standdokumente

Wichtig:

Historische, unreferenzierte Ressourcen nur entfernen, wenn ihre Entfernung zweifelsfrei reine Bereinigung ist und keine Tests/Buildreferenzen bricht.

Dokumentiere jede Bereinigung.

---

# Harte Modulgrenze

Modul 033:

- integriert
- testet
- nimmt ab
- repariert kleine reale Integrationsfehler

Nicht hinzufügen:

- neue Features
- neue Spielmodi
- Highscore
- Statistik
- Tutorial
- User-Farbauswahl
- neue Monsteranimationen
- weitere Sounds/Videos
- zusätzliche Fenster
- Immersive Space

---

# Git

Nach erfolgreicher Abnahme:

`033: Integration und Abnahme v1.3`

Keine Hashes erfinden.

---

# Abschlussstatus

Am Ende genau eine Aussage:

## A — Ticket Tamer v1.3 abgenommen

Nur wenn:

- Build PASS
- vollständige Tests PASS
- AK-31 bis AK-39 ausreichend real abgenommen
- keine kritische v1.2-Regression

oder:

## B — Ticket Tamer v1.3 nicht vollständig abgenommen

Dann:

- alle OPEN/FAIL-Punkte
- Priorität
- konkreter nächster Schritt

Ein fehlender echter Gerätetest darf separat als Restrisiko dokumentiert werden, wenn Simulator und alle übrigen Pflichtnachweise ausreichend sind.

Gerätetest niemals erfinden.

---

# Ausgabeformat

1. Vorab-Check
2. Git-/Toolchain-/Buildstand
3. vollständige Tests
4. AK-31 Ticketabnahme
5. AK-32/33 Videoabnahme
6. AK-28/39 Teamlogoabnahme
7. AK-34 Monster-Audio
8. AK-35 Streak-Audio
9. AK-36 Streak-State
10. AK-37 Scoring
11. AK-21/38 Feedback & Streakvisualisierung
12. AK-39 Ressourcenstruktur
13. Monster-/Drop-/Retry-Regression
14. Replay-/Reset-/1-6-16-Stabilität
15. v1.2-/Kernregression
16. Accessibility
17. Gerätetest
18. Integrationsfixes
19. finale AK-Matrix
20. vollständige Regression-Matrix
21. Ressourcen-Abschlussinventar
22. finaler Git-/Working-Tree-Stand
23. Abschlussstatus A oder B
24. vollständiger `033-Report.md`

Der `033-Report.md` ist die finale technische Übergabe für Ticket Tamer v1.3.
