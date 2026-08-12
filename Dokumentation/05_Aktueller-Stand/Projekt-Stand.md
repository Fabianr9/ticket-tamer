# Projekt-Stand — Ticket Tamer

> Aktueller technischer Stand nach Modul 013.

**Stand:** Code Stand Modul `011`; Modul `012` ohne Codeänderung übersprungen; Modul `013` Asset-Fix  
**Eingearbeitet am:** 2026-08-12  
**Branch laut Report:** `main`  
**Letzter Commit vor 013:** `b94e0ed feat: add docs modul 11`  
**Modul-013-Commit:** offen (nach manuellem Build + Test vergeben)  
**Testdeklarationen:** 155 (vollständiger Lauf manuell offen)

## Technischer Funktionsstand

Auf Codeebene vorhanden:

- genau ein zentrales volumetrisches Fenster
- deutsche Startansicht
- Ticketanzahl 1–12, Standard 6
- zwölf lokale Tickets
- zentrales `SessionModel`
- Untersuchungsphase
- Priorisierungsphase
- Teamzuordnungsphase
- Drag-/Drop-Grundlage
- Prioritäts- und Teamspeicherung
- +100/0-Bewertung
- zwei lokale Audio-Platzhalter
- 1,5-Sekunden-Auto-Transition
- nächstes Ticket / Ergebnisphase
- Ergebnisansicht
- vollständiger Reset

## Modul 012

Nicht implementiert.

Grund:

- keine finalen Blender-Monster (zum Zeitpunkt von Modul 012)
- nur USDA-Kugel-Platzhalter
- optionale Reaktion technisch nicht sinnvoll
- Muss-Abnahmen haben Vorrang

## Modul 013 — Asset-Fix + RealityView-Fix

Durchgeführt:

- `Monster_1_blue.usdc` → `monster01.usda` (Platzhalter ersetzt)
- `Monster_2_green.usdc` → `monster02.usda` (Platzhalter ersetzt)
- `Monster_3_yellow.usdc` → `monster03.usda` (Platzhalter ersetzt)
- `Monster_4_red.usdc` → `monster04.usda` (Platzhalter ersetzt)
- Blender Z-up → Y-up Korrektur (`applyBlenderCorrection`) in `MonsterAssetProvider`
- RealityView `update:`-Closure in `PrioritizationView` und `TeamAssignmentView` auf direkte State-Reads umgestellt (SwiftUI Dependency-Tracking Fix)
- `addEntitiesIfNeeded` aus beiden Views entfernt (war indirekte Lesebremse)
- `ProgressView`-Ladeindikator in beiden Views ergänzt (erzwingt Body-Read auf `monsterEntity`)

Noch offen (manuell):

- Build-Verifikation in Xcode
- Vollständige Testsuite (155 Tests)
- Simulator-Abnahme aller AK-01 bis AK-16
- Apple Vision Pro Gerätetest

## Root-Phasenrouting

```text
RootVolumeView
├─ .start
│  └─ StartView
├─ .untersuchen
│  └─ InvestigationView
├─ .priorisieren
│  └─ PrioritizationView
├─ .teamZuordnen
│  └─ TeamAssignmentView
└─ .ergebnis
   └─ ResultView
```

## Teststand

- 155 Testdeklarationen vorhanden
- vollständiger Testlauf manuell offen (kein Xcode in Ausführungsumgebung)

## Audio-Status

- `correct.wav` vorhanden
- `incorrect.wav` vorhanden
- beide projekt-eigene Platzhalter
- tatsächliche Hörbarkeit manuell zu prüfen

## Monster-Status

- `monster01.usda` — referenziert `Monster_1_blue.usdc` (Blender-Export) ✓
- `monster02.usda` — referenziert `Monster_2_green.usdc` (Blender-Export) ✓
- `monster03.usda` — referenziert `Monster_3_yellow.usdc` (Blender-Export) ✓
- `monster04.usda` — referenziert `Monster_4_red.usdc` (Blender-Export) ✓
- Darstellung im Simulator noch nicht verifiziert

## Pflichtabnahme noch offen

- Build in Xcode
- vollständige Tests (155)
- Gesten End-to-End
- Audio-Hörbarkeit
- Auto-Transition 1,5 s
- Ergebnis / Reset Simulator
- Monster-Darstellung (USDC) im Simulator
- Apple Vision Pro Gerätetest

## Nächster technischer Schritt

Manuelle Abnahme aller AK im visionOS-Simulator. Dann Commit `013: Integration und Gerätetest`.  
Danach: Modul 014 — Abschlussdokumentation und Cleanup.
