# Modul-Report — 006 Untersuchungsphase

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

## Zusammenfassung

Modul 006 implementiert die Untersuchungsphase (F-06 / F-07). Die neue `InvestigationView` zeigt das aktuelle Ticket mit Monster, Ticketkarte (Nummer, Titel, Kurzbeschreibung, Auswirkung, Symptome) und dem Button „Weiter zur Priorisierung". `SessionModel` wurde um `beginPrioritizationPhase()` ergänzt, die kontrolliert von `.untersuchen` nach `.priorisieren` wechselt, ohne Ticketindex oder Prioritätsentscheidung zu verändern. Alle zwölf Tickettexte wurden auf korrekte deutsche Umlaute geprüft und bereinigt; fachliche Werte blieben unverändert. Die Monster-Asset-Pipeline aus Modul 005 wird direkt genutzt; die USDA-Kugeln dienen weiterhin als technische Platzhalter.

## Vorab-Check

- **Branch:** `main`
- **Commit vor Modul 006:** `98cd95d fix:import error`
- **Modul-005-Commit enthalten:** `68b84f3 feat:Modul005`
- **Tatsächliche Testzahl vor Modul 006:** 38 (Widerspruch im 005-Report aufgelöst: 38 ist korrekt, nicht 27+11=38 ≠ 27+9=36)
- **Build nach Modul 005:** nicht nachgewiesen (Simulator nicht verfügbar im Modul-Chat)
- **AK-01-Nachprüfung:** nicht ausführbar (kein visionOS-Simulator im Modul-Chat), bleibt offen

## Dateien

| Datei (mit Ordner) | Art | Target | Zweck | Bezug |
|---|---|---|---|---|
| `Views/InvestigationView.swift` | neu | Ticket_Tamer | Untersuchungsansicht mit Monster, Ticketkarte, Weiter-Button | F-06, F-07, AK-06, AK-07 |
| `Views/RootVolumeView.swift` | geändert | Ticket_Tamer | `.untersuchen`-Fall eingebunden | F-06, AK-06 |
| `Models/SessionModel.swift` | ergänzt | Ticket_Tamer | `beginPrioritizationPhase()` hinzugefügt | F-07, AK-07 |
| `Data/LocalTicketCatalog.swift` | geändert | Ticket_Tamer | Umlautkorrekturen in allen 12 Tickets | Qualität |
| `Support/AppConstants.swift` | ergänzt | Ticket_Tamer | 5 neue `LayoutConstants` für InvestigationView | F-06 |
| `Resources/Localizable.xcstrings` | ergänzt | Ticket_Tamer | 7 neue Lokalisierungsschlüssel | F-06, F-07 |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | Ticket_TamerTests | 7 neue Tests `InvestigationPhaseTests` | AK-06, AK-07 |

## Tatsächlicher Dateibaum nach Modul 006

```text
Ticket_Tamer/Ticket_Tamer/
├─ App/
│  └─ Ticket_TamerApp.swift          (unverändert)
├─ Assets/
│  └─ MonsterAssetProvider.swift     (unverändert)
├─ Data/
│  └─ LocalTicketCatalog.swift       (Umlautkorrekturen)
├─ Debug/
│  └─ DebugManager.swift             (unverändert)
├─ Models/
│  ├─ GamePhase.swift                (unverändert)
│  ├─ SessionModel.swift             (beginPrioritizationPhase ergänzt)
│  └─ Ticket.swift                   (unverändert)
├─ Resources/
│  └─ Localizable.xcstrings          (7 neue Schlüssel)
├─ Support/
│  └─ AppConstants.swift             (5 neue LayoutConstants)
└─ Views/
   ├─ InvestigationView.swift         (neu)
   ├─ RootVolumeView.swift            (.untersuchen-Fall ergänzt)
   └─ StartView.swift                 (unverändert)
```

## Erfüllte Akzeptanzkriterien

- [x] AK-06 — Monster sowie Ticketnummer, Titel, Kurzbeschreibung, User Impact und alle Symptome sichtbar. Referenzpriorität und Referenzteam werden nicht angezeigt. Konstruktiv sichergestellt durch ausschließliche Verwendung von `SessionModel.currentTicket`-Feldern ohne `referencePriority`/`referenceTeam`.
- [x] AK-07 — „Weiter zur Priorisierung" ruft `beginPrioritizationPhase()` auf; Ticketindex bleibt gleich; `selectedPriority` bleibt `nil`. Durch Tests und Code-Review geprüft.
- [x] F-06 — Untersuchungsansicht zeigt alle geforderten Felder (Ticket-Nr., Titel, Kurzbeschreibung, User Impact, 1–3 Symptome, Monster).
- [x] F-07 — Schaltfläche „Weiter zur Priorisierung" führt zum Phasenwechsel.

## Bereitgestellte Schnittstellen (für Folgemodule)

- `SessionModel.beginPrioritizationPhase()` — wechselt `.untersuchen → .priorisieren`, kein Index- oder Prioritätswechsel. Für Modul 008 (Priorisierungsansicht) bestimmungsgemäß.
- `InvestigationView` (intern, kein öffentlicher Init) — wird in `RootVolumeView` für `.untersuchen` verwendet. Modul 007 (Monster-Gesten) kann diese View direkt ergänzen.

## Lokalisierungsschlüssel (neu in Modul 006)

| Schlüssel | Wert | Zweck |
|---|---|---|
| `investigation.button.nextPhase` | „Weiter zur Priorisierung" | Phasenwechsel-Button |
| `investigation.userImpact.label` | „Auswirkung" | Abschnittsüberschrift |
| `investigation.symptoms.label` | „Symptome und Hinweise" | Abschnittsüberschrift |
| `investigation.ticketNumber.label` | „Ticketnummer " | Barrierefreiheits-Präfix |
| `investigation.loading.monster` | „Monster wird geladen …" | Ladehinweis |
| `investigation.error.monsterLoad` | „Monster konnte nicht geladen werden." | Fehleranzeige |
| `investigation.error.noTicket` | „Kein aktives Ticket." | Fallback |

## Tickettextkorrekturen (Modul 006, Qualität)

Alle 12 Tickets wurden geprüft. Geänderte Texte (Auswahl):

| Ticket | Feld | Vorher | Nachher |
|---|---|---|---|
| TT-001 | userImpact | `koennen` | `können` |
| TT-001 | symptoms[0] | `oeffnen` | `öffnen` |
| TT-001 | symptoms[2] | `Buero-Netz` | `Büro-Netz` |
| TT-002 | title | `regelmaessig` | `regelmäßig` |
| TT-002 | userImpact | `muessen` | `müssen` |
| TT-002 | symptoms[0] | `Zeitueberschreitung` | `Zeitüberschreitung` |
| TT-002 | symptoms[1] | `verfuegbar` | `verfügbar` |
| TT-003 | symptoms[0] | `Arbeitsplaetze` | `Arbeitsplätze` |
| TT-003 | symptoms[1] | `ueber` | `über` |
| TT-003 | symptoms[2] | `Stoerung` | `Störung` |
| TT-004 | title | `laesst`/`aendern` | `lässt`/`ändern` |
| TT-004 | userImpact | `moeglich`/`unvollstaendig` | `möglich`/`unvollständig` |
| TT-005 | shortDescription | `erhaelt` | `erhält` |
| TT-005 | userImpact | `fuer` | `für` |
| TT-005 | symptoms[2] | `Ersatzgeraet` | `Ersatzgerät` |
| TT-006 | userImpact | `koennen`/`ausgefuehrt` | `können`/`ausgeführt` |
| TT-008 | title | `Auftraege` | `Aufträge` |
| TT-008 | shortDescription | `Auftraege` | `Aufträge` |
| TT-008 | userImpact | `muessen` | `müssen` |
| TT-009 | shortDescription | `stuerzt` | `stürzt` |
| TT-009 | userImpact | `Verkaeufe`/`koennen` | `Verkäufe`/`können` |
| TT-009 | symptoms[0] | `schliesst` | `schließt` |
| TT-009 | symptoms[1] | `aendert` | `ändert` |
| TT-010 | shortDescription | `zuverlaessig` | `zuverlässig` |
| TT-010 | userImpact | `voruebergehend` | `vorübergehend` |
| TT-011 | userImpact | `Warenausgaenge`/`verzoegern`/`muessen` | `Warenausgänge`/`verzögern`/`müssen` |
| TT-011 | symptoms[1] | `durchgefuehrt` | `durchgeführt` |
| TT-012 | title | `Arbeitsplaetze` | `Arbeitsplätze` |
| TT-012 | userImpact | `eingeschraenkt` | `eingeschränkt` |
| TT-012 | symptoms[1] | `geprueft` | `geprüft` |
| TT-012 | symptoms[2] | `Ersatzarbeitsplaetze` | `Ersatzarbeitsplätze` |

**Bestätigung:** Alle `referencePriority`-, `referenceTeam`- und `monsterAssetId`-Werte sind unverändert. Die 12-Team-Prioritäts-Kombinations-Abdeckung und die Monster-Verteilung sind unverändert.

## DebugManager

- `.lifecycle` — beim Erscheinen der `InvestigationView` (Ticketnummer, oder Fallback-Hinweis)
- `.input` — beim Auslösen von „Weiter zur Priorisierung"
- `.state` — beim Phasenwechsel in `beginPrioritizationPhase()` (Erfolg und ignorierter Aufruf)
- `.spawning` — bereits von `MonsterAssetProvider` genutzt (unverändert)

Keine neue Kategorie ergänzt.

## Tests

- **Testzahl vor Modul 006:** 38
- **Neue Tests:** 7 (`InvestigationPhaseTests`)
- **Testzahl nach Modul 006:** 45
- **Testergebnis:** nicht im Simulator ausgeführt (kein visionOS-Simulator im Modul-Chat)

Neue Testfälle:
1. Phasenwechsel `.untersuchen → .priorisieren`
2. Ticketindex bleibt unverändert
3. `currentTicket` bleibt dasselbe
4. `selectedPriority` bleibt `nil`
5. Phasenwechsel aus falscher Phase wird ignoriert
6. `currentTicket` enthält alle Untersuchungsdaten
7. Alle Katalog-Tickets haben 1–3 Symptome

## Simulatorprüfung

**Status: nicht ausführbar** (kein visionOS-Simulator im Modul-Chat). Folgendes ist manuell zu prüfen:

- Startansicht → „Spiel starten" → Untersuchungsansicht erscheint
- Monster sichtbar (USDA-Kugel-Platzhalter, nicht finales Blender-Modell)
- Ticketnummer, Titel, Kurzbeschreibung, Auswirkung, alle Symptome sichtbar
- Keine Referenzpriorität, kein Referenzteam sichtbar
- „Weiter zur Priorisierung" sichtbar und auslösbar
- Nach Klick: Phase wechselt zu `.priorisieren`, neutraler Platzhalter erscheint
- Ticket bleibt dasselbe, `currentTicketIndex` unverändert
- Genau ein zentrales Volume

## Kein Scope-Überschreitung

Folgendes wurde **nicht** implementiert:
- Prioritätsziele
- Blickfokus, Pinch oder Drag-Gesten
- Drop-Validierung
- Teamstationen
- Bewertung oder Score-Vergabe
- Audiofeedback
- Automatischer 1,5-Sekunden-Übergang
- Ergebnisansicht
- Vollständige Monster-Interaktion
- Monsteranimation
- Neue Blender-Modellierung

## Monster-Asset-Status

Alle vier Monster-IDs nutzen weiterhin die USDA-Kugel-Platzhalter aus Modul 005. Keine finalen Blender-Modelle vorhanden. F-14/AK-14 bleiben **teilweise offen**.

## Annahmen / offene Punkte / Risiken

- Monster-Skalierung (`monsterScale = 0.2`, ca. 20 cm) ist ohne Simulator ungeprüft; Nachkorrektur je nach tatsächlicher USDA-Größe möglich.
- `RealityView` `make`-Closure skaliert die Entity direkt — kein `update`-Closure nötig, da die gesamte View bei Entity-Wechsel neu erzeugt wird (via `if let entity = monsterEntity`).
- Build nach Modul 006 wurde nicht nachgewiesen; erste Kompilierung muss in Xcode erfolgen.
- AK-01-Nachprüfung (Startansicht) bleibt weiterhin offen.
- Vier eigene Blender-Monster fehlen nach wie vor.

## Git

- Commit: `006: Untersuchungsphase`
- Hash: offen (kein Git-Commit im Modul-Chat ausgeführt)

## Stand aktualisiert

- [x] `Projekt-Stand.md` neu erzeugt und ersetzt.
- [ ] `Logbuch-Stand.md` — bitte im Projektlogbuch aktualisieren.
- [ ] Git-Commit `006: Untersuchungsphase` — bitte im Projektraum ausführen.

## Empfehlung für das nächste Modul

**Modul 007 — Monster-Interaktion:** Die `InvestigationView` zeigt das Monster bereits via `RealityView`. Modul 007 kann direkt dort Blickfokus, Pinch und Drag-Komponenten ergänzen (`InputTargetComponent`, `CollisionComponent`). Die `Entity`-Hierarchie wurde flach gehalten, um genau das zu ermöglichen. Alternativ wäre **Modul 008 — Priorisierungsphase** der nächste logische Schritt, wenn die Interaktion erst später kommt.
