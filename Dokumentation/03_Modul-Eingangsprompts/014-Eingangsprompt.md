# Modul-Eingangsprompt — 014 Abschlussdokumentation und Cleanup

> Vom Projektlogbuch nach Einarbeitung des `013-Report.md` erzeugt. Dies ist das letzte reguläre Modul. Es darf offene Pflichtnachweise nicht durch Dokumentation ersetzen.

---

Du bist Abschluss-, QA- und Dokumentationsverantwortliche:r für Ticket Tamer.

## Modul

**Nummer:** 014  
**Titel:** Abschlussdokumentation und Cleanup

**Ziel:** Projekt, Git-Stand, aktuelle Dokumentation, Assets und Abgabezustand konsistent machen. Alle Pflichtanforderungen F-01 bis F-16 müssen mit realem Nachweis als PASS oder sichtbar als OPEN/FAIL dokumentiert sein.

## Hartes Abschluss-Gate

Modul 014 darf Ticket Tamer nur dann als vollständig abgabebereit markieren, wenn die noch offenen Nachweise aus Modul 013 tatsächlich vorliegen.

Aktuell OPEN:

- AK-05 vollständiger linearer Flow
- AK-06 Untersuchung
- AK-07 Weiter zur Priorisierung
- AK-08 Prioritätsgesten
- AK-09 Teamgesten
- AK-10 Drop/Lock End-to-End
- AK-11 Scoring-Laufzeitfälle
- AK-12 vollständiges Audiofeedback
- AK-14 eigene Blender-Monster vollständig nachgewiesen
- AK-16 Fünffach-Reset/Stabilität
- vollständige 155-Test-Suite
- Apple-Vision-Pro-Gerätetest

Wenn diese Evidenz nicht verfügbar ist:

- nicht erfinden
- nicht als PASS markieren
- sauber als OPEN/Risiko in Abschlussdokumentation führen

## Verbindliche Quellenhierarchie

Bei Widersprüchen gilt:

1. `Projektbeschreibung.md`
2. `SPEC.md`
3. `Akzeptanzkriterien.md`
4. aktueller `Logbuch-Stand.md`
5. aktueller `Projekt-Stand.md`
6. Modul-Reports

Alte/stale Promptformulierungen dürfen keine funktionale Anforderung verändern.

## Wichtige Korrektur zum 013-Report

Die Feature-/AK-Zuordnung im 013-Report ist teilweise falsch.

Verbindlich ist unter anderem:

- F-02/F-03 betreffen Ticketkatalog/-daten
- F-05 betrifft den linearen Ablauf in genau einem zentralen Volume
- F-14 betrifft vier eigene Blender-Monster
- AK-16 verlangt mindestens fünf stabile Neustarts

Übernimm nicht die fehlerhafte Tabellenzuordnung aus dem Report.

## Phase 1 — Git- und Repository-Check

Ermittle:

- Branch
- HEAD
- tatsächlichen Modul-013-Commit
- Working Tree
- untracked files
- staged files
- `.gitignore`

Prüfe:

- `.DS_Store`
- alte Kopien von Standdateien
- Backup-Dateien
- temporäre Dateien
- generierte Artefakte, die nicht ins Repo gehören

Verbindliches Single-Stand-Prinzip:

Unter `Dokumentation/05_Aktueller-Stand/` existieren genau:

- `Projekt-Stand.md`
- `Logbuch-Stand.md`

Keine `alt`, `copy`, `backup`, `final-final`-Varianten.

## Phase 2 — Build/Test-Nachweis übernehmen oder nachholen

Prüfe reale Evidenz für:

- Build
- 155 Tests
- Simulator
- Gerät

Wenn Xcode verfügbar:

- finalen Build ausführen
- vollständige Tests ausführen
- tatsächliche Zahlen dokumentieren

Wenn nicht:

- vorhandene echte Ergebnisse übernehmen
- offene Punkte sichtbar lassen

Keine Test-PASS-Zahlen erfinden.

## Phase 3 — Finale AK-Matrix

Erstelle eine verbindliche Matrix AK-01 bis AK-16.

Für jedes AK:

- Requirement
- Implementiert?
- Code-/Dateinachweis
- Testnachweis
- Simulatornachweis
- Gerätenachweis
- PASS / OPEN / FAIL
- offener Restpunkt

PASS nur bei vollständigem Nachweis.

### Aktueller Ausgangsstand

- AK-01 PASS
- AK-02 PASS
- AK-03 PASS
- AK-04 PASS
- AK-05 OPEN
- AK-06 OPEN
- AK-07 OPEN
- AK-08 OPEN
- AK-09 OPEN
- AK-10 OPEN
- AK-11 OPEN
- AK-12 OPEN
- AK-13 PASS
- AK-14 OPEN
- AK-15 PASS
- AK-16 OPEN

Diese Werte dürfen nur mit realer neuer Evidenz verbessert werden.

## Phase 4 — Monster-Asset-Abschluss

Aktuell integriert:

- `Monster_1_blue.usdc`
- `Monster_2_green.usdc`
- `Monster_3_yellow.usdc`
- `Monster_4_red.usdc`

Prüfe und dokumentiere:

- Herkunft
- Urheber/Eigentum
- Blender-Quelle
- Exportweg
- verwendete Farbvariante
- Skalierung
- Y-up-Korrektur
- lokale Bundle-Pfade
- keine Team-/Prioritätscodierung

### Wichtig

Der 013-Report nennt die Dateien Blender-USDC-Exporte, aber im geprüften Monster-Ordner lagen keine `.blend`-Dateien.

Für AK-14 muss der Abschluss klar beantworten:

**Wie ist nachgewiesen, dass dies vier eigene Blender-Monster sind?**

Zulässige Evidenz kann sein:

- `.blend`-Quelldateien
- dokumentierter eigener Blender-Arbeitsordner
- nachvollziehbarer eigener Exportprozess
- andere klare Projektnachweise

USDC-Dateien allein beweisen die Blender-Urheberschaft nicht automatisch.

Wenn der Nachweis fehlt: AK-14 OPEN.

## Phase 5 — Audio-Abschluss

Dokumentiere:

- `correct.wav`
- `incorrect.wav`
- Format
- Herkunft
- Rechte
- Bundle
- Hörtest

Aktuell:

- `correct.wav` im Simulator laut Report hörbar
- `incorrect.wav` noch nicht explizit geprüft

AK-12 erst PASS, wenn beide Fälle real bestätigt sind und genau-einmal-Wiedergabe geprüft ist.

## Phase 6 — DEBUG-/Development-Cleanup

Prüfe:

- `DebugInteractionHarnessView`
- `🔧 Team [DEV]`-Button
- `#if DEBUG`-Blöcke
- DebugManager
- überflüssige Logs

Ziel:

- Release-Build enthält keine sichtbaren Development-Hilfen
- DEBUG-only Hilfen dürfen bleiben, wenn sauber gekapselt
- keine fachliche Nutzerfunktion hängt vom DEBUG-Code ab

Nicht unnötig DebugManager entfernen, wenn er sauber deaktivierbar ist.

## Phase 7 — UI-/Scope-Cleanup

Prüfe final:

### Start

- nur geforderte Startinhalte

### Untersuchung

- keine Referenzlösung

### Priorität

- nur Normal/Wichtig/Kritisch

### Team

- nur Netzwerk/Konto/Software/Hardware

### Feedback

- kein Richtig/Falsch-Text
- keine richtige Lösung
- kein Lösungs-Overlay

### Ergebnis

sichtbar ausschließlich:

- Scorezahl
- „Erneut spielen“

Nicht ergänzen:

- Ticketanzahl
- Statistik
- Highscore
- Badge
- Ranking

## Phase 8 — F-17

F-17 bleibt bewusst ausgelassen.

Dokumentiere:

- optional
- nicht implementiert
- kein Einfluss auf Pflichtabgabe

Nicht nachträglich stillschweigend implementieren.

## Phase 9 — Dokumentationskonsistenz

Aktualisiere mindestens:

- `Projektbeschreibung.md` nur falls technische Realisierungshinweise ergänzt werden müssen, nicht Scope ändern
- `SPEC.md` nur wenn Implementierungsstatus separat dokumentiert wird, Anforderungen nicht umschreiben
- `Akzeptanzkriterien.md` Anforderungen nicht verändern
- `Projekt-Stand.md`
- `Logbuch-Stand.md`
- finale AK-Matrix
- README/Abgabehinweise falls vorhanden

Entferne falsche Altbehauptungen wie:

- F-17 = Highscore/Persistenz
- Ergebnis zeigt Ticketanzahl
- USDA-Kugeln seien finale Monster
- alle AK seien bereits vollständig abgenommen

## Phase 10 — Finale Projektstruktur

Dokumentiere den tatsächlichen Dateibaum.

Keine erfundenen Dateien.

Prüfe insbesondere:

- App
- Models
- Views
- Services
- Assets
- RealityKitContent
- Tests
- Dokumentation

## Phase 11 — Abgabe-Checkliste

Erstelle eine finale Checkliste mit:

### Muss

- Build
- Tests
- Simulator
- Gerät
- F-01 bis F-16
- AK-01 bis AK-16
- vier eigene Monster
- Audio
- Reset
- deutsche UI
- genau ein Volume

### Nicht enthalten

- Accounts
- Cloud
- Datenbank
- Highscore
- Statistik
- Tutorial
- zweites Volume
- Immersive Space
- Lösungserklärungen

### Optional

- F-17 bewusst ausgelassen

## Phase 12 — Abschlussstatus

Am Ende genau eine der folgenden Aussagen treffen:

### A — Abgabebereit

Nur wenn alle Pflicht-AKs PASS sind.

oder

### B — Nicht vollständig abgabebereit

Dann die verbleibenden OPEN/FAIL-Punkte priorisiert auflisten.

Keine beschönigende Mischform.

## Git

Vorgesehener Commit:

`014: Abschlussdokumentation und Cleanup`

Erfinde keinen Hash.

Wenn Modul 013 vorab noch einen echten Integrationscommit benötigt, Commitreihenfolge sauber dokumentieren.

## Ausgabeformat

1. Vorab-Check
2. Git-/Cleanup-Ergebnis
3. Build-/Testnachweis
4. finale Asset-/Audio-Dokumentation
5. AK-01-bis-AK-16-Matrix
6. Scope-/UI-Check
7. Dokumentationsänderungen
8. finaler Dateibaum
9. Abgabe-Checkliste
10. Abschlussstatus A oder B
11. vollständiger `014-Report.md`

Der `014-Report.md` ist die letzte technische Übergabe und muss alle verbliebenen Risiken ehrlich sichtbar machen.
