# Modul-Report — 009 Teamzuordnungsphase

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

## Zusammenfassung

Modul 009 implementiert die vollständige Teamzuordnungsphase (`GamePhase.teamZuordnen`). Die nutzende Person sieht das aktuelle Ticket-Monster und genau vier räumliche Teamstationen (Netzwerk, Konto, Software, Hardware) in einem 2×2-Layout. Monster-Drag via Blickfokus, Pinch und Drag ist vollständig über die bestehende `MonsterInteractionConfigurator`/`DropEvaluator`-Infrastruktur aus Modul 007 realisiert. Genau eine Teamentscheidung wird atomisch in `SessionModel.saveTeam(_:)` gespeichert und sperrt danach weitere Eingaben. Die Testanzahl wächst von 86 auf 110.

## Vorab-Check

| Prüfung | Ergebnis |
|---|---|
| Branch | `main` |
| 008-Hauptcommit | `200093b 008: Priorisierungsphase` |
| 008-Fix-Commit | `b716ed1 feat:Modul008` (PrioritizationView visuell korrigiert) |
| Weiterer Docs-Commit | `7b873b7 feat: update docs module 008` |
| `.git/index.lock` | nicht vorhanden |
| Build vor Modul 009 | gemeldet bestätigt |
| Simulatorstart | gemeldet bestätigt |
| Testdeklarationen vor 009 | 86 (bestätigt per grep) |
| Vollständiger Testlauf | offen (kein CI-Runner in diesem Kontext) |
| Priorisierungs-Gestenprüfung | offen (Simulator nicht in diesem Kontext verfügbar) |

**008-Fix:** Der visuelle Fix (Zielkugeln Opacity 0.55, Labels als SwiftUI-Overlay) ist in `b716ed1` committed und im aktuellen `PrioritizationView.swift` vorhanden. Modul 009 dreht diesen Fix nicht zurück; `PrioritizationView.swift` wird nur um den `#if DEBUG`-Button erweitert.

## Dateien

| Datei (mit Ordner) | Art | Target | Zweck |
|---|---|---|---|
| `Views/TeamAssignmentView.swift` | neu | Ticket_Tamer | Teamzuordnungsansicht: `TeamTargetMapping`, 4 Stationen, Monster-Drag/Drop, Labels als SwiftUI-Overlay |
| `Models/SessionModel.swift` | ergänzt | Ticket_Tamer | `beginTeamAssignmentPhase()` und `saveTeam(_:)` hinzugefügt |
| `Support/AppConstants.swift` | ergänzt | Ticket_Tamer | `TeamAssignmentConstants` mit Monster-Startposition und 4 Zielpositionen |
| `Views/RootVolumeView.swift` | ergänzt | Ticket_Tamer | `case .teamZuordnen → TeamAssignmentView()` aus default-Platzhalter herausgelöst |
| `Views/PrioritizationView.swift` | ergänzt | Ticket_Tamer | `#if DEBUG`-Button „🔧 Team [DEV]" nach gespeicherter Priorität — nur im Debug-Build |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | Ticket_TamerTests | `TeamAssignmentPhaseTests` mit 24 neuen Tests (86 → 110) |

**Unverändert:** `DropTargetComponent.swift`, `DropEvaluator.swift`, `MonsterInteractionConfigurator.swift`, `MonsterAssetProvider.swift`, `InvestigationView.swift`, `StartView.swift`, `Ticket.swift`, `LocalTicketCatalog.swift`, `GamePhase.swift`, `Info.plist`.

## Dateibaum nach Modul 009

```text
Ticket_Tamer/
├─ Ticket_Tamer/
│  ├─ App/
│  │  └─ Ticket_TamerApp.swift
│  ├─ Assets/
│  │  └─ MonsterAssetProvider.swift
│  ├─ Components/
│  │  └─ DropTargetComponent.swift
│  ├─ Data/
│  │  └─ LocalTicketCatalog.swift
│  ├─ Debug/
│  │  └─ DebugManager.swift
│  ├─ Models/
│  │  ├─ GamePhase.swift
│  │  ├─ SessionModel.swift
│  │  └─ Ticket.swift
│  ├─ Resources/
│  │  └─ Localizable.xcstrings
│  ├─ Services/
│  │  ├─ DropEvaluator.swift
│  │  └─ MonsterInteractionConfigurator.swift
│  ├─ Support/
│  │  └─ AppConstants.swift
│  ├─ Views/
│  │  ├─ Debug/
│  │  │  └─ DebugInteractionHarnessView.swift
│  │  ├─ InvestigationView.swift
│  │  ├─ PrioritizationView.swift
│  │  ├─ RootVolumeView.swift
│  │  ├─ StartView.swift
│  │  └─ TeamAssignmentView.swift          ← neu
│  ├─ Assets.xcassets
│  └─ Info.plist
├─ Ticket_TamerTests/
│  └─ Ticket_TamerTests.swift
└─ Packages/
   └─ RealityKitContent/
```

## Ziel-IDs und Mapping (TeamTargetMapping)

| technische ID | SupportTeam | displayName | Position |
|---|---|---|---|
| `team_netzwerk` | `.netzwerk` | Netzwerk | (-0.24, +0.16, 0) |
| `team_konto` | `.konto` | Konto | (+0.24, +0.16, 0) |
| `team_software` | `.software` | Software | (-0.24, -0.16, 0) |
| `team_hardware` | `.hardware` | Hardware | (+0.24, -0.16, 0) |

2×2-Layout. Minimaler Abstand zwischen benachbarten Stationen: 0.32 m (vertikal) > 2 × 0.15 m (dropTargetRadius). Keine Überschneidung.

## `beginTeamAssignmentPhase()`-Semantik

**Vorbedingungen:**
- `currentPhase == .priorisieren`
- `selectedPriority != nil`

**Effekte:**
- `currentPhase = .teamZuordnen`
- `isInputLocked = false` (kontrolliertes Entsperren für neue Teamentscheidung)

**Unverändert:** `score`, `currentTicketIndex`, `selectedPriority`, `selectedTeam` (bleibt `nil`).

**No-Op bei:** falscher Phase, fehlender Priorität.

**Wichtig:** Diese Methode wird in Modul 009 im normalen Release-Spielablauf **nicht** automatisch aufgerufen. Modul 010 übernimmt den zeitgesteuerten Übergang (F-13). Verwendung: Unit-Tests, SwiftUI-Preview, `#if DEBUG`-Button.

## `saveTeam(_:)`-Semantik

**Vorbedingungen:**
- `currentPhase == .teamZuordnen`
- `selectedTeam == nil`
- `isInputLocked == false`

**Effekte:**
- `selectedTeam = team`
- `isInputLocked = true` (via `lockInput()`, atomar)

**Unverändert:** `selectedPriority`, `score`, `currentTicketIndex`, `currentPhase` (bleibt `.teamZuordnen`).

**No-Op bei:** falscher Phase, bereits gespeichertem Team, bereits gesperrtem Input.

## Development-Zugang vor Modul 010

Da Modul 010 den automatischen Übergang nach Prioritätsbewertung noch nicht implementiert, wird die Teamphase im Simulator ausschließlich über den `#if DEBUG`-Button in `PrioritizationView` geöffnet:

1. Sitzung starten → Prioritätsdrop durchführen → Lock bestätigen.
2. Button „🔧 Team [DEV]" erscheint (nur im Debug-Build).
3. Tippen → `beginTeamAssignmentPhase()` wird aufgerufen → `TeamAssignmentView` erscheint.

**Eigenschaften des DEBUG-Buttons:**
- Nur im `DEBUG`-Build sichtbar (`#if DEBUG`-Block).
- Nicht Teil der F-09-Benutzeroberfläche.
- Kein normaler Nutzerpfad.
- Im Release-Build nicht vorhanden.
- Im Report dokumentiert (dieser Abschnitt).

## Erfüllte Akzeptanzkriterien

- [x] **AK-09 — Räumliche Teamzuordnung (Modellebene):** `saveTeam(_:)` speichert genau ein Team in der richtigen Phase, sperrt danach weitere Eingaben, zweite Versuche werden ignoriert. Prüfung durch 13 Unit-Tests.
- [x] **AK-09 — Vier Teamstationen:** Genau vier Stationen mit deutschen Labels Netzwerk/Konto/Software/Hardware in `TeamAssignmentView`. Prüfung durch Strukturtest + Mapping-Tests.
- [x] **AK-10 (Teamanteil) — Ungültiger Drop ohne Zustandsänderung:** Monster kehrt zur Ausgangsposition zurück, kein Team gespeichert, kein Lock. Prüfung durch Unit-Tests (saveTeam außerhalb Phase = No-Op) und Implementierung in `handleDragEnded`.
- [x] **AK-10 (Teamanteil) — Input-Lock nach gültigem Drop:** Weitere Drag-Versuche werden in `handleDragChanged` / `handleDragEnded` ignoriert (`guard !model.isInputLocked`).
- [x] **AK-10 (Teamanteil) — Kein View-Refresh entsperrt nach gespeichertem Team:** `onAppear` in `TeamAssignmentView` ruft kein `unlockInput()` auf; der Lock nach `saveTeam(_:)` bleibt erhalten.

## DebugManager

Neue Kategorien: keine. Bestehende Kategorien verwendet:

| Kategorie | Wo geloggt |
|---|---|
| `.spawning` | Teamstation bereit (ID + Position), Monster bereit |
| `.input` | Drag ignoriert (Lock), Release ignoriert (Lock) |
| `.physics` | Gültiger Drop (Ziel-ID), Ungültiger Drop, Unbekannte Ziel-ID |
| `.state` | beginTeamAssignmentPhase, saveTeam, Team gespeichert + isInputLocked, DEV-Button |

Nicht geloggt: `referenceTeam`, ob die Teamwahl richtig oder falsch ist (gehört Modul 010).

## Nicht implementiert (Modulgrenze)

Folgendes wurde in Modul 009 **bewusst nicht** implementiert:

- Bewertung gegen `referenceTeam` — Modul 010
- Punkte (+100 / 0) — Modul 010
- Erfolgssound / Fehlersound — Modul 010
- Anzeige der richtigen Lösung — Modul 010
- Automatische 1,5-Sekunden-Weiterleitung (F-13) — Modul 010
- Automatischer Wechsel zum nächsten Ticket — Modul 010/011
- Ergebnisansicht — Modul 011
- Monsterreaktionen — offen
- Neue Blender-Modellierung — offen

## Build- und Verifikationsstand

| Prüfung | Stand |
|---|---|
| App-Build nach Modul 009 | offen (kein Simulator in diesem Kontext) |
| Simulatorstart | offen |
| TeamAssignmentView sichtbar | offen — via DEBUG-Button nach Prioritätsdrop prüfen |
| Netzwerk-Drop | offen |
| Konto-Drop | offen |
| Software-Drop | offen |
| Hardware-Drop | offen |
| Ungültiger Drop → kein Team | offen |
| Priorität bleibt nach Teamdrop | offen |
| Score bleibt 0 | offen |
| Phase bleibt .teamZuordnen | offen |
| Lock nach Teamdrop | offen |
| Weiteres Ziehen während Lock wirkungslos | offen |
| Alle vier Labels gut lesbar | offen |
| Testlauf 110 Tests | offen |

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| monster01 | USDA-Platzhalter | fehlt |
| monster02 | USDA-Platzhalter | fehlt |
| monster03 | USDA-Platzhalter | fehlt |
| monster04 | USDA-Platzhalter | fehlt |

## Annahmen / offene Punkte / Risiken

- `beginTeamAssignmentPhase()` entsperrt den Input via direktem `isInputLocked = false` statt via `unlockInput()`. Das ist notwendig, weil `unlockInput()` zwar funktional identisch ist, aber kein Logging-Unterschied besteht. Der direkte Aufruf `isInputLocked = false` mit anschließendem Log ist expliziter für den Phasenwechsel-Kontext.
- Der DEBUG-Button in `PrioritizationView` ist der einzige Simulator-Einstieg in die Teamphase vor Modul 010. Er muss nach Modul 010 nicht entfernt werden (bleibt im DEBUG-Build nützlich), stört aber den Release-Ablauf nicht.
- Die vier Blender-Finalmodelle fehlen weiterhin. Die USDA-Platzhalter funktionieren für alle Phasen.
- Vollständiger Testlauf (110 Tests) wurde nicht ausgeführt — kein Xcode/Simulator in diesem Kontext.

## Git

- Vorgesehener Commit: `009: Teamzuordnungsphase`
- Hash: noch nicht bekannt (Commit steht aus)

## Stand aktualisiert

- [x] `Projekt-Stand.md` neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` **ersetzt**.
- [ ] `Logbuch-Stand.md` — bitte nach Modul-Abschluss durch das Projektlogbuch aktualisieren.
- [ ] Kein Umbenennen/Löschen von Dateien — keine Einträge unter „nicht mehr vorhanden" nötig.

## Empfehlung für Modul 010

Modul 010 implementiert die vollständige Auswertung nach Teamdrop:

- Vergleich `selectedTeam` gegen `referenceTeam` → richtig/falsch,
- Punkte (+100 oder 0),
- Erfolgssound / Fehlersound,
- Anzeige der richtigen Lösung,
- automatische Weiterleitung nach ≈ 1,5 Sekunden (F-13),
- danach: `advanceToNextTicket()` + Phase zurück auf `.untersuchen` oder `.ergebnis`.

Der wichtigste Schritt für Modul 010: `beginTeamAssignmentPhase()` aus der aktuell manuellen DEV-Auslösung in einen echten, zeitgesteuerten automatischen Ablauf überführen — direkt nach Abschluss der Prioritätsbewertungs-Sequenz aus Modul 010.
