# Modul 027 — Neue Ticketdaten und 16er-Sitzung

## Ergebnis

Der produktive Katalog enthält genau TT-001 bis TT-016 mit den verbindlichen Titeln,
Kurzbeschreibungen, User Impacts und Symptomen aus
`Tickets/Ticket-Tamer_Tickets.md`. Die historischen Tickettexte wurden vollständig ersetzt.
Die Sitzungsauswahl und Startsteuerung verwenden zentral den Bereich 1...16; Standard und Reset
bleiben 6. Jedes Ticket besitzt die reine Datenreferenz `TT-xxx.mp4`.

## Realer Git- und Werkzeugstand

| Punkt | Ergebnis |
|---|---|
| Branch | `v1.3` |
| HEAD vor Modul 027 | `44430b7daeb8c6b53f1266cb9ac781e6c6330dd4` (`feat: Modul 26`) |
| finaler v1.2-Abschlusscommit | `44430b7` (`feat: Modul 26`) |
| Working Tree vor Modul | nicht sauber; bestehende Dokumentationsänderungen, gelöschte ToDos sowie neue v1.3-Asset-/Kontextordner |
| Tests vor Modul | 365 `@Test`-Deklarationen |
| Tests nach Modul | 372 `@Test`-Deklarationen |
| Plattform | `xros xrsimulator`, SDKROOT `xros` |
| Deployment Target | visionOS 26.5 |
| Swift-Sprachmodus | 5.0 |
| lokales Xcode/Swift | nicht vorhanden (`xcodebuild` und `swift` nicht gefunden) |

Fremde, bereits vorhandene Working-Tree-Änderungen wurden nicht bearbeitet. Verbindliche
Inhaltsquelle ist der tatsächliche Pfad `Tickets/Ticket-Tamer_Tickets.md`; zur Laufzeit wird
kein Markdown geparst.

## Ticketmatrix

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

TT-001...TT-012 bilden weiterhin die vollständige 4×3-Referenzmatrix. Die Ergänzungen sind
TT-013 Netzwerk/Wichtig, TT-014 Konto/Normal, TT-015 Software/Wichtig und TT-016
Hardware/Kritisch. Daraus folgen Teams 4/4/4/4 sowie Prioritäten 5/6/5.

## Implementierung und Regression

- `Ticket.videoAssetName` ergänzt; keine Wiedergabelogik und keine Video-UI implementiert.
- `GameplayConstants.maximumTicketCount` auf 16 gesetzt. Slider, technische Clamp und
  Plus-/Minus-Ableitungen beziehen ihre Grenzen weiterhin daraus.
- Sitzungen mit 1, 6 und 16 Tickets sowie eindeutige IDs werden getestet. Eine 16er-Sitzung
  erzeugt weiterhin genau 16 Monster-Variantenzuordnungen; Reset leert das Mapping.
- Monsterzuordnung und v1.2-Farbvariantenauswahl wurden nicht umgebaut. Die vier neuen Tickets
  ergänzen jeden Monstertyp einmal; Farbe codiert weder Team noch Priorität.
- Untersuchung, Ticketinfo und HUD arbeiten bereits datensatz- beziehungsweise
  `sessionTickets.count`-basiert. Es wurde keine weitere Sonderlogik ergänzt und keine
  Referenzlösung sichtbar gemacht.
- Keine Logo-, Audio- oder Streak-Arbeit aus Modul 028/029/031 vorgezogen. Replay-Root,
  Punkte, Dropgeometrie, 50-%-Overlap, Z-Toleranz, Snapback und Exactly-once blieben unverändert.

## Prüfstatus

| Prüfung | Status | Nachweis |
|---|---|---|
| Katalog, IDs, Pflichtfelder, Symptome | PASS (statisch/Testabdeckung) | 16 Einträge, TT-001...TT-016, 1...3 Symptome |
| Referenzmatrix und Verteilungen | PASS (statisch/Testabdeckung) | Matrix- und Verteilungstests |
| Video-Mapping | PASS (statisch/Testabdeckung) | `ticket.videoAssetName == "\(ticket.ticketNumber).mp4"` |
| Auswahl, Grenzen, Reset, Variantenmapping | PASS (statisch/Testabdeckung) | zentraler Bereich 1...16 und Sessiontests |
| Scope-`git diff --check` | PASS | keine Whitespacefehler in Modul-027-Dateien |
| gesamter Working-Tree-`git diff --check` | OPEN | vorbestehende Whitespacefehler in zwei Standdateien |
| Build und vollständige Tests | OPEN | Linux-Umgebung ohne Xcode/visionOS-SDK und ohne Swift |
| Simulatorprüfung | OPEN | kein visionOS-Simulator in dieser Umgebung |

## Akzeptanzkriterien

| Kriterium | Status | Bewertung |
|---|---|---|
| AK-01 | PASS (Code/Test) | Startwert 6, Steuerung 1...16 |
| AK-02 | PASS (Code/Test) | genau 16 lokale Tickets und verbindliche Verteilung |
| AK-03 | PASS (Code/Test) | Pflichtdaten, Referenzen, Symptome und Videos vorhanden |
| AK-04 | PASS (Code/Test) | exakt n eindeutige Tickets für n = 1, 6, 16 |
| AK-22 | PASS (Code/Test) | Plus/Minus/Slider nutzen dieselben zentralen Grenzen |
| AK-31 | OPEN (Laufzeit) | Daten- und Sitzungsanteil umgesetzt; Simulatornachweis ausstehend |

## Offene Risiken und Empfehlung

Der vollständige Xcode-Build, die Testsuite und die geforderte Simulatorprüfung müssen auf einem
macOS-System mit visionOS-26.5-SDK nachgeholt werden. Insbesondere sind TT-001, TT-007, TT-013 und
TT-016, die HUD-Folge bis „Ticket 16 von 16“, Ticketinfo, Reset sowie Replay-/Punkte-/Monsterfarben-
Regression manuell zu prüfen. Die vorhandene zusätzliche Datei `TT-002A.mp4` ist keine produktive
Ticketreferenz.

Empfehlung für **Modul 028 — Teamlogos v1.3**: auf diesem Katalogstand aufsetzen und nur die vier
Teamlogos integrieren; Ticket-, Video-, Sitzungs- und Monsterdaten dabei unverändert lassen.
