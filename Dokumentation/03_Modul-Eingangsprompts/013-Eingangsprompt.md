# Modul-Eingangsprompt — 013 Integration und Gerätetest

> Vom Projektlogbuch nach Einarbeitung des `012-Report.md` erzeugt. Dieses Modul ist das zentrale Pflicht-Abnahmemodul für F-01 bis F-16.

---

Du bist Integrations- und Testverantwortliche:r für Ticket Tamer.

## Modul

**Nummer:** 013  
**Titel:** Integration und Gerätetest

**Ziel:** Den vollständigen Pflichtumfang F-01 bis F-16 als zusammenhängenden visionOS-Spielablauf bauen, testen und nachweisen. Dieses Modul soll primär **verifizieren und stabilisieren**, nicht neue Features erfinden.

## Aktueller Stand

Der Codezyklus ist implementiert:

`Start → Untersuchung → Priorisierung → Teamzuordnung → Ergebnis → Neustart`

Modul 012 wurde bewusst ausgelassen. F-17 ist optional.

Aktuell bekannte offene Pflichtpunkte:

- Build nach Modul 011 nicht nachgewiesen
- 155 Tests nicht vollständig ausgeführt
- Gesten-End-to-End offen
- Audiohörbarkeit offen
- 1,5-Sekunden-Transitions offen
- Ergebnis-/Reset-Simulatorabnahme offen
- finale vier Blender-Monster fehlen
- Apple-Vision-Pro-Gerätetest offen

## Verbindliche Modulgrenze

Modul 013 darf:

- Buildfehler beheben
- Testfehler beheben
- Integrationsfehler beheben
- Layout-/Skalierungsprobleme beheben
- Gesture-/Drop-Probleme beheben
- Audio-Wiedergabeprobleme beheben
- Task-/Race-Probleme beheben
- finale Blender-Assets integrieren
- kleine Stabilitätskorrekturen durchführen

Modul 013 darf nicht:

- neue Spielmodi erfinden
- Tutorial ergänzen
- Highscore/Persistenz ergänzen
- Statistiken ergänzen
- richtige Lösungen anzeigen
- zweiten Volume/Immersive Space ergänzen
- F-17 ohne klaren Zeitpuffer nachziehen

## Phase 1 — Git und Build

Ermittle:

- aktuellen Branch
- aktuellen Commit
- Modul-011-Commit `209aff2`
- ob `b94e0ed` aktuell ist
- Working-Tree-Status
- Xcode-Version
- visionOS SDK-Version
- Deployment Target

Führe einen vollständigen App-Build aus.

Dokumentiere:

- Command / Xcode-Aktion
- Ziel
- Simulator/Gerät
- Ergebnis
- Warnungen
- Fehler

Keine Build-Erfolge erfinden.

## Phase 2 — Vollständige Testsuite

Im Quellstand sind 155 `@Test`-Deklarationen dokumentiert.

Führe die vollständige Suite aus.

Dokumentiere:

- tatsächliche Zahl
- Suites
- Passed
- Failed
- Skipped
- Laufzeit
- Plattform

Wenn die tatsächliche Zahl von 155 abweicht:

- Quellcode prüfen
- Ursache dokumentieren
- keine Reportzahl künstlich herstellen

Fehlschlagende Tests nur dann ändern, wenn ein echter Defekt vorliegt.

## Phase 3 — Finale Monster-Assets

F-14 ist weiterhin nicht vollständig erfüllt.

Prüfe real, ob inzwischen vorhanden:

- vier `.blend`
- vier `.usdz` oder andere RealityKit-kompatible Exporte
- Texturen/Materialien

Wenn vorhanden:

- in die bestehenden IDs `monster01`–`monster04` integrieren
- bestehendes `monsterAssetId`-Mapping unverändert lassen
- `MonsterAssetProvider` weiterverwenden
- keine Team-/Prioritätsinformation über das Design verraten
- Skalierung, Y-Up/Ausrichtung, Ursprung und Materialien prüfen

Wenn nicht vorhanden:

- F-14/AK-14 klar als **nicht erfüllt** markieren
- nicht durch Kugel-Platzhalter schönreden
- keine fremden Assets herunterladen
- konkrete Asset-Lücke im Report hervorheben

## Phase 4 — AK-01 Start

Prüfe:

- Ticket Tamer sichtbar
- Regler sichtbar
- Wertebereich 1–12
- Standardwert 6
- ganzzahlige Schritte
- „Spiel starten“
- genau ein zentrales Volume
- kein zweites Fenster
- kein Immersive Space

## Phase 5 — AK-02/03/04 Daten und Sitzung

Prüfe:

- genau 12 lokale Tickets
- vollständige Pflichtfelder
- 1–3 Symptome je Ticket
- eindeutige IDs
- vollständige 4×3 Team/Prioritätsabdeckung
- gewählte Ticketanzahl exakt
- keine Wiederholung in Sitzung
- mehrere Starts können variieren

## Phase 6 — AK-06/07 Untersuchung

Prüfe:

- korrektes Monster
- Ticketnummer
- Titel
- Kurzbeschreibung
- Auswirkung
- alle Symptome
- keine Referenzpriorität
- kein Referenzteam
- „Weiter zur Priorisierung“
- gleiches Ticket nach Wechsel

## Phase 7 — AK-08 Priorisierung

Für alle drei Ziele prüfen:

- Normal
- Wichtig
- Kritisch

Jeweils:

- Blickfokus
- Pinch
- Drag
- gültiger Drop
- korrekte Speicherung
- Input-Lock
- kein zweiter Drop

Zusätzlich:

- ungültiger Drop
- Monster kehrt zurück
- keine Entscheidung
- kein Score
- keine Phase

## Phase 8 — AK-09 Team

Für alle vier Stationen:

- Netzwerk
- Konto
- Software
- Hardware

Jeweils:

- Blickfokus
- Pinch
- Drag
- gültiger Drop
- korrekte Speicherung
- Input-Lock
- keine zweite Entscheidung

Zusätzlich Invalid-Drop.

## Phase 9 — AK-10 Gesamtinteraktion

Prüfe End-to-End:

- Priorität genau einmal
- Team genau einmal
- Lock während Feedback
- keine doppelten Punkte
- keine Race Conditions
- ungültige Drops neutral

## Phase 10 — AK-11 Bewertung

Testfälle pro Ticket:

- beide richtig → 200
- nur Priorität richtig → 100
- nur Team richtig → 100
- beide falsch → 0

Prüfe:

- kein negativer Score
- kein doppelter Score
- Score akkumuliert über Tickets

## Phase 11 — AK-12 Audio

Prüfe real:

- `correct.wav` hörbar
- `incorrect.wav` hörbar
- genau ein Sound je Entscheidung
- richtige Entscheidung → correct
- falsche → incorrect
- kein Netz
- keine doppelte Wiedergabe

Wenn AVAudioPlayer nichts ausgibt:

- AudioService prüfen
- ggf. minimale visionOS-kompatible Audio-Session-Konfiguration ergänzen
- tatsächlichen Fix dokumentieren

## Phase 12 — AK-13 Feedback/Transition

Prüfe:

- keine richtige Lösung sichtbar
- kein Lösungs-Overlay
- kein Richtig/Falsch-Text
- kein Punkt-Popup
- nach ca. 1,5 s Priorität → Team
- nach ca. 1,5 s Team → nächstes Ticket / Ergebnis
- Input bleibt während Feedback gesperrt

Messe die tatsächliche Verzögerung grob; keine exakte Millisekundenabnahme nötig.

## Phase 13 — AK-14 Monster

Nur als erfüllt markieren, wenn:

- vier eigene Blender-Monster vorliegen
- lokal eingebunden
- alle vier darstellbar
- keine 1:1-Antwortcodierung
- alle vier mit Blick/Pinch/Drag nutzbar
- Skalierung/Orientierung geprüft
- keine Netzwerkabhängigkeit

USDA-Kugeln allein reichen nicht.

## Phase 14 — AK-15 Ergebnis

Prüfe:

Sichtbar ausschließlich:

- Gesamtpunktzahl als Zahl
- „Erneut spielen“

Nicht sichtbar:

- Ticketanzahl
- Statistik
- richtige Lösungen
- Rang
- Badge
- Highscore

## Phase 15 — AK-16 Reset

Prüfe mindestens fünf aufeinanderfolgende Neustarts.

Nach jedem Reset:

- Startansicht
- Regler 6
- Score 0
- Index 0
- leere Sitzung
- Priorität nil
- Team nil
- Input false
- keine alten Tasks
- keine alten Punkte

End-to-End mindestens:

- 1 Ticket
- 2 Tickets
- 6 Tickets

## Phase 16 — Apple Vision Pro Gerätetest

Wenn Gerät verfügbar:

Prüfe auf echtem Gerät:

- Lesbarkeit
- Volume-Größe
- Blickfokus
- Pinch-Zuverlässigkeit
- Drag-Reichweite
- Drop-Zielgröße
- Audio-Lautstärke
- Monstergröße
- Ergonomie

Simulator-Erfolg ersetzt den Gerätetest nicht vollständig.

Wenn kein Gerät verfügbar:

- klar dokumentieren
- Gerätetest als offene Abgabe-Risiko markieren

## Phase 17 — Stabilitätsprüfung

Mindestens:

- 5 Neustarts
- mehrere unterschiedliche Ticketanzahlen
- 12-Ticket-Sitzung
- mehrfach ungültige Drops
- schnelle Gesten
- schneller Wechsel / mehrfaches Pinchen
- keine Crashes
- kein Score-Carryover
- kein Phasen-Deadlock

## Modul-012-Regel

F-17 bleibt ausgelassen.

Nur wenn nach erfolgreicher Muss-Abnahme eindeutig Zeitpuffer besteht und finale Monster bereits vorhanden sind, darf F-17 als separate Nacharbeit vorgeschlagen werden.

Nicht innerhalb von Modul 013 stillschweigend implementieren.

## DebugManager

Für Integrationsdiagnose vorhandene Kategorien verwenden.

Keine neue Logging-Infrastruktur bauen.

Nach erfolgreicher Abnahme prüfen, ob Debug-Ausgaben im Release-Build angemessen deaktiviert sind.

## Dateien

Ändere nur, was für echte Integrationsfehler oder finale Assetintegration notwendig ist.

Jede Änderung im Report begründen als:

- Build-Fix
- Test-Fix
- Integrations-Fix
- Asset-Fix
- Audio-Fix
- Layout-Fix
- Gesture-Fix
- Race-/State-Fix

Keine Feature-Erweiterungen.

## Git

Vorgesehener Commit:

`013: Integration und Gerätetest`

Falls mehrere reale Fixes sinnvoll getrennt committed werden, alle Hashes dokumentieren.

Keine Hashes erfinden.

## Ausgabeformat

1. **Vorab-Check**
   - Git
   - Xcode/SDK
   - Build
   - tatsächliche Testzahl

2. **Finale Assetprüfung**
   - Blender-/USDZ-Inventar
   - Integrationsstatus F-14

3. **AK-Matrix F-01 bis F-16**
   Für jedes AK:
   - implementiert
   - getestet
   - Simulator
   - Gerät
   - bestanden/offen/fehlgeschlagen
   - Nachweis

4. **End-to-End-Ergebnisse**
   - 1 Ticket
   - 2 Tickets
   - 6 Tickets
   - 12 Tickets

5. **Gesten**
   - Priorität
   - Team
   - Invalid-Drop
   - Lock

6. **Audio**
   - correct
   - incorrect
   - Lautstärke
   - genau-einmal

7. **Reset/Stabilität**
   - fünf Neustarts
   - Carryover
   - Crash-/Deadlock-Status

8. **Gerätetest**
   - falls möglich
   - sonst klares offenes Risiko

9. **Alle vorgenommenen Fixes**
   - Datei
   - Grund
   - Wirkung

10. **Vollständiger `013-Report.md`**

Der Report muss am Ende eine klare Pflicht-Abnahmematrix enthalten:

- F-01 bis F-16
- AK-01 bis AK-16
- PASS / FAIL / OPEN

Nichts als PASS markieren, was nicht tatsächlich nachgewiesen wurde.

Empfehlung danach: Modul 014 Abschlussdokumentation/Cleanup.
