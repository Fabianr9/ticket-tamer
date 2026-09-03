# Projektlogbuch — Ticket Tamer

> Einziger aktueller Logbuch-Stand nach Einarbeitung von Modul 027 für Version 1.3.

**Projektversion:** v1.3 in Arbeit  
**v1.0:** abgeschlossen  
**v1.1:** abgeschlossen  
**v1.2:** abgeschlossen  
**Stand:** nach Modul `027` — Neue Ticketdaten und 16er-Sitzung  
**Eingearbeitet am:** 2026-09-03  
**Branch laut 027-Report:** `v1.3`  
**HEAD vor Modul 027:** `44430b7daeb8c6b53f1266cb9ac781e6c6330dd4` (`feat: Modul 26`)  
**Finaler v1.2-Abschlusscommit:** `44430b7` (`feat: Modul 26`)  
**Modul-027-Commit:** offen  
**Testdeklarationen vor 027:** 365  
**Testdeklarationen nach 027:** **372**  
**Build/Test/Simulator nach 027:** offen

## v1.3-Modulstatus

| Modul | Titel | Anforderungen | Status |
|---|---|---|---|
| 027 | Neue Ticketdaten und 16er-Sitzung | F-01, F-02, F-03, F-04, F-22, F-31 | implementiert; Code/Test-Anteile erfüllt; AK-31 Laufzeit OPEN; Commit offen |
| 028 | Teamlogos v1.3 | F-28, F-39 | als Nächstes |
| 029 | Monster- und Streak-Audio | F-12, F-34, F-35, F-39 | offen |
| 030 | Ticketvideo-System | F-03, F-32, F-33, F-39 | offen |
| 031 | Streak-State und Scoring | F-11, F-16, F-36, F-37 | offen |
| 032 | Streak-Feedback v1.3 | F-18, F-21, F-35, F-38 | offen |
| 033 | Integration und Abnahme v1.3 | F-01 bis F-39, Schwerpunkt F-31 bis F-39 | offen |

## Modul 027 — realer Stand

### Ticketkatalog

Der produktive lokale Katalog enthält jetzt genau:

TT-001 bis TT-016.

Die historischen Tickettexte wurden vollständig durch die Inhalte aus:

`Tickets/Ticket-Tamer_Tickets.md`

ersetzt.

Die Markdown-Datei wird nicht zur Laufzeit geparst.

### Ticketmatrix

| ID | Titel | Priorität | Team | MonsterType | Video |
|---|---|---|---|---|---|
| TT-001 | Das WLAN hat einen Lieblingsplatz | Normal | Netzwerk | monster01 | TT-001.mp4 |
| TT-002 | Die Videokonferenz teleportiert uns | Wichtig | Netzwerk | monster02 | TT-002.mp4 |
| TT-003 | Das Internet ist spontan in den Urlaub gefahren | Kritisch | Netzwerk | monster03 | TT-003.mp4 |
| TT-004 | Mein Passwort kennt mich nicht mehr | Normal | Konto | monster04 | TT-004.mp4 |
| TT-005 | Die Buchhaltung steht vor der digitalen Zugbrücke | Wichtig | Konto | monster01 | TT-005.mp4 |
| TT-006 | Der digitale Türsteher lässt niemanden mehr rein | Kritisch | Konto | monster02 | TT-006.mp4 |
| TT-007 | Meine Tabelle spricht plötzlich Hieroglyphen | Normal | Software | monster03 | TT-007.mp4 |
| TT-008 | Die Präsentation frisst ihre eigenen Folien | Wichtig | Software | monster04 | TT-008.mp4 |
| TT-009 | Das Bestellsystem ist in der Zeit eingefroren | Kritisch | Software | monster01 | TT-009.mp4 |
| TT-010 | Der Drucker übt für seine Traktorprüfung | Normal | Hardware | monster02 | TT-010.mp4 |
| TT-011 | Der Konferenzbildschirm hat Schneetag | Wichtig | Hardware | monster03 | TT-011.mp4 |
| TT-012 | Der Dateiserver veranstaltet eine Lichtshow | Kritisch | Hardware | monster04 | TT-012.mp4 |
| TT-013 | Das Homeoffice steckt im VPN-Labyrinth | Wichtig | Netzwerk | monster01 | TT-013.mp4 |
| TT-014 | Die Zwei-Faktor-Anmeldung lebt in einer Zeitschleife | Normal | Konto | monster02 | TT-014.mp4 |
| TT-015 | Das Ticketsystem züchtet Klone | Wichtig | Software | monster03 | TT-015.mp4 |
| TT-016 | Die Lager-Scanner haben kollektiv Feierabend | Kritisch | Hardware | monster04 | TT-016.mp4 |

### Verteilung

Teams:

- Netzwerk 4
- Konto 4
- Software 4
- Hardware 4

Prioritäten:

- Normal 5
- Wichtig 6
- Kritisch 5

TT-001 bis TT-012 bilden weiterhin die vollständige 4×3-Matrix.

Zusätzlich:

- TT-013 Netzwerk/Wichtig
- TT-014 Konto/Normal
- TT-015 Software/Wichtig
- TT-016 Hardware/Kritisch

## Ticketmodell

Neu:

`Ticket.videoAssetName`

Jedes Ticket besitzt exakt die reine Datenreferenz:

`TT-xxx.mp4`

Keine Videoansicht oder Wiedergabelogik wurde vorgezogen.

Die zusätzliche vorhandene Datei `TT-002A.mp4` ist ausdrücklich **keine** produktive Ticketreferenz.

## Ticketanzahlsteuerung

`GameplayConstants.maximumTicketCount = 16`

Startsteuerung und Sessionlogik verwenden zentral:

- Minimum 1
- Maximum 16
- Standard 6

Slider, Plus/Minus und technische Clamp beziehen sich auf dieselbe Grenze.

Reset bleibt 6.

## Monster-Farbvarianten-Regressionsschutz

Die v1.2-Variantenlogik wurde nicht umgebaut.

Eine 16er-Sitzung erzeugt weiterhin genau 16 Ticket→Monster-Variantenzuordnungen.

Reset leert das Mapping.

Die vier neuen Tickets ergänzen jeden Monstertyp einmal.

## Nicht vorgezogen

Keine Arbeit an:

- Teamlogos
- neuen Audioressourcen
- Streak-State
- Streak-Scoring
- Video-UI

Replay-Root, Punktekommunikation, Dropgeometrie, 50-%-Overlap, Z-Toleranz, Snapback und Exactly-once blieben unverändert.

## Teststand

| Kennzahl | Stand |
|---|---:|
| Tests vor 027 | 365 |
| Tests nach 027 | **372** |
| Katalog/IDs/Pflichtfelder | PASS statisch/Testabdeckung |
| Referenzmatrix/Verteilung | PASS statisch/Testabdeckung |
| Video-Mapping | PASS statisch/Testabdeckung |
| Auswahl/Clamp/Reset | PASS statisch/Testabdeckung |
| Scope `git diff --check` | PASS |
| vollständiger Build/Testlauf | OPEN |
| Simulator | OPEN |

## Akzeptanzstatus Modul 027

| AK | Status |
|---|---|
| AK-01 | PASS (Code/Test) |
| AK-02 | PASS (Code/Test) |
| AK-03 | PASS (Code/Test) |
| AK-04 | PASS (Code/Test) |
| AK-22 | PASS (Code/Test) |
| AK-31 | OPEN (Laufzeit) |

Für AK-31 noch manuell zu prüfen:

- TT-001
- TT-007
- TT-013
- TT-016
- HUD bis `Ticket 16 von 16`
- Ticketinfo
- Reset
- Replay-/Punkte-/Monsterfarben-Regression

## Werkzeugstatus

Im Modul-027-Ausführungsumfeld fehlten:

- `xcodebuild`
- `swift`
- visionOS-Simulator

Daher keine erfundenen Laufzeit-PASS-Angaben.

## Nächster Schritt

`028-Eingangsprompt.md` ausführen.

Modul 028 bearbeitet ausschließlich den Teamlogo-Anteil von v1.3:

- vier bereitgestellte JPEG-Teamlogos inventarisieren,
- sauber unter einem gemeinsamen Teamlogo-Ressourcenbereich ablegen,
- zentrale Team→Logo-Zuordnung einführen,
- bisherige SF-Symbole aus Modul 023 in der sichtbaren Teamstation durch Logos ersetzen,
- Teamtext vollständig sichtbar lassen,
- Panel-/Drop-Geometrie vollständig unverändert lassen,
- fehlende Logos robust behandeln,
- Ticket-, Video-, Session-, Monster-, Audio- und Streaklogik nicht verändern.
