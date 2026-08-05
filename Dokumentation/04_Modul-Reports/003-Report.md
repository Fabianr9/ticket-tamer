# Modul-Report — 003 Sitzungsmodell und Zufallsauswahl

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

## Zusammenfassung

Für Modul 003 wurde ein zentrales, ausschließlich im Arbeitsspeicher gehaltenes Sitzungsmodell implementiert. `SessionModel` ist eine `@Observable @MainActor`-Klasse und die einzige Quelle der Wahrheit für den gesamten aktuellen Spielzustand. Die Klasse verwaltet Ticketanzahl (1–12, Standardwert 6), zufällige Auswahl ohne Wiederholung aus `LocalTicketCatalog.allTickets`, einen sicheren Ticketindex mit Klemm-Semantik sowie einen vollständigen Reset aller acht Zustandsfelder. Ein begleitendes `GamePhase`-Enum bildet die fünf SPEC-Phasen ab und wird für den eindeutigen Startzustand benötigt. Zwölf neue automatisierte Tests sichern alle Anforderungen auf Modellebene ohne UI-, RealityKit- oder Audio-Abhängigkeiten ab.

## Vorab-Check (Modul-002-Verifikation)

| Prüfpunkt | Ergebnis |
|---|---|
| Branch | `main` |
| Letzter Commit vor Modul 003 | `2775041 feat: add modul 2` |
| `Ticket.swift` vorhanden | ✓ (`Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift`) |
| `LocalTicketCatalog.swift` vorhanden | ✓ (`Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift`) |
| `Ticket_TamerTests.swift` vorhanden | ✓ |
| App-Build nach Modul 002 | Nicht verifiziert (kein `xcodebuild` im Sandbox-Ausführungsumfeld); bestehende Dateien sind syntaktisch korrekt und entsprechen dem gemeldeten Modul-002-Stand |
| Testlauf nach Modul 002 | Nicht verifiziert (gleiche Begründung) |
| Nacharbeit aus Modul 002 erforderlich | Keine — keine Kompilierungsfehler in den vorgefundenen Quellen erkennbar |

> **Hinweis:** `xcodebuild` und `swiftc` sind im Cowork-Sandbox-Ausführungsumfeld nicht verfügbar. Build und Testlauf sind lokal in Xcode durchzuführen (Befehl siehe Abschnitt 4).

## Sitzungsmodell-Entwurf

### Typ und Datei

| Element | Datei | Art |
|---|---|---|
| `GamePhase` | `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | neu |
| `SessionModel` | `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | neu |

### Zustandsfelder

| Feld | Typ | Standardwert | Reset-Ziel |
|---|---|---|---|
| `selectedTicketCount` | `Int` | `GameplayConstants.defaultTicketCount` (6) | 6 |
| `sessionTickets` | `[Ticket]` | `[]` | `[]` |
| `currentTicketIndex` | `Int` | 0 | 0 |
| `currentPhase` | `GamePhase` | `.start` | `.start` |
| `score` | `Int` | 0 | 0 |
| `selectedPriority` | `TicketPriority?` | `nil` | `nil` |
| `selectedTeam` | `SupportTeam?` | `nil` | `nil` |
| `isInputLocked` | `Bool` | `false` | `false` |

Alle Felder sind `private(set)` — Mutationen nur über bereitgestellte Methoden.

### Beobachtbarkeit

`@Observable` (Swift 5.9+, `import Observation`). Keine manuell verwalteten `@Published`-Felder. `@MainActor`, weil das App-Target `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` setzt; explizite Annotation schafft Klarheit für Folgemodule.

### Phasengrundlage

`GamePhase: Equatable` mit fünf Fällen: `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen`, `.ergebnis`. Keine automatischen Übergänge, keine vollständige Phasenmaschine — diese gehören zu Modul 006.

### Schnittstellen

| Methode / Property | Signatur | Zweck |
|---|---|---|
| `setTicketCount(_:)` | `func setTicketCount(_ count: Int)` | Ticketanzahl setzen, Klemmen auf 1–12 |
| `startSession(using:)` | `func startSession(using shuffle: ([Ticket]) -> [Ticket] = { $0.shuffled() })` | Sitzung starten, Auswahl ohne Duplikate |
| `currentTicket` | `var currentTicket: Ticket?` | Sicherer Zugriff auf aktuelle Ticket |
| `advanceToNextTicket()` | `func advanceToNextTicket()` | Index vorschalten (Klemm-Semantik) |
| `reset()` | `func reset()` | Vollständiger Reset aller Felder |

### Testbarkeit der Zufallsauswahl

`startSession(using:)` nimmt eine `([Ticket]) -> [Ticket]`-Funktion als Parameter. Standard: `{ $0.shuffled() }` (echter Zufall). Tests injizieren deterministische Funktionen (Identität, Reversed). Kein Random-Service, keine Dependency-Injection-Infrastruktur, keine generische Repository-Schicht.

### Auswahl-Semantik (AK-04)

- Quelle: ausschließlich `LocalTicketCatalog.allTickets`.
- Mischung über `shuffle`-Parameter; das Präfix der Länge `selectedTicketCount` wird genommen.
- Da `LocalTicketCatalog.allTickets` keine Duplikate enthält und `prefix` eine zusammenhängende Teilsequenz ohne Wiederholung liefert, ist AK-04 (keine doppelte Ticket-ID) strukturell garantiert.

### Index-Endsemantik

Klemm-Semantik: Am Ende der `sessionTickets`-Liste bleibt `currentTicketIndex` beim letzten gültigen Index stehen. Kein Wrap-around, kein Überlauf. `currentTicket` gibt weiterhin das letzte Ticket zurück. Die aufrufende Schicht (ab Modul 006) entscheidet über den weiteren Phasenwechsel.

## Dateien

| Datei (mit Ordner) | Art | Target | Zweck |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` | neu | `Ticket_Tamer` (App) | `GamePhase`-Enum mit 5 SPEC-Phasen, `Equatable` |
| `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` | neu | `Ticket_Tamer` (App) | Zentrales Sitzungsmodell, alle Zustandsfelder und Methoden |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | `Ticket_TamerTests` | 12 neue Tests in `SessionModelTests`; bestehende Tests unverändert |

Keine Änderungen an: `Ticket_TamerApp.swift`, `RootVolumeView.swift`, `AppConstants.swift`, `Ticket.swift`, `LocalTicketCatalog.swift`, `DebugManager.swift`, `Info.plist`, `Localizable.xcstrings`, RealityKitContent-Dateien, `project.pbxproj`.

> **Hinweis `project.pbxproj`:** Das Projekt verwendet `PBXFileSystemSynchronizedRootGroup` (Xcode 16+ automatische Dateisynchronisation). Neue Swift-Dateien in `Ticket_Tamer/` und `Ticket_TamerTests/` werden automatisch vom jeweiligen Target erkannt — kein manueller Eintrag in `project.pbxproj` notwendig.

## Erfüllte Akzeptanzkriterien

- [x] **AK-04 — Sitzungsauswahl ohne Wiederholung (Modellanteil vollständig).**
  - GEGEBEN Ticketanzahl n gewählt, WENN `startSession()` aufgerufen, DANN `sessionTickets.count == n`: geprüft durch `sessionWithOneTicketContainsExactlyOneTicket`, `sessionWithSixTicketsContainsExactlySixTickets`, `sessionWithTwelveTicketsContainsExactlyTwelveTickets`.
  - GEGEBEN Sitzung läuft, WENN alle IDs verglichen, DANN keine Duplikate: geprüft durch `sessionTicketIdsAreUnique` und strukturell durch Präfix-Semantik garantiert.
  - GEGEBEN mehrere Sitzungen, WENN verglichen, DANN kann Reihenfolge variieren: geprüft durch `deterministicShuffleFunctionProducesDifferentSelections`.

- [ ] **AK-16 — Neustart und Reset (Modellanteil teilweise erfüllt; UI-Anteil offen).**
  - [x] Modellanteil erfüllt: `selectedTicketCount` → 6, `sessionTickets` → leer, `currentTicketIndex` → 0, `currentPhase` → `.start`, `score` → 0, `selectedPriority` → `nil`, `selectedTeam` → `nil`, `isInputLocked` → `false`. Geprüft durch `resetRestoresAllModelFields` und `fiveConsecutiveResetsRemainStable`.
  - [ ] UI-Anteil offen: sichtbarer Wechsel zur Startansicht, Schaltfläche „Erneut spielen", sichtbarer Reglerwert. Diese Anteile werden in Modul 004 (Regler) und Modul 011 (Erneut-spielen-Button) umgesetzt und in Modul 013 integriert geprüft.

## Bereitgestellte Schnittstellen (für Folgemodule)

| Typ / Methode | Datei | Zweck |
|---|---|---|
| `GamePhase` | `Models/GamePhase.swift` | 5 Phasen `.start`, `.untersuchen`, `.priorisieren`, `.teamZuordnen`, `.ergebnis`; `Equatable` |
| `SessionModel` | `Models/SessionModel.swift` | Zentraler Sitzungszustand; `@Observable @MainActor` |
| `SessionModel.selectedTicketCount: Int` | – | Aktuell gewählte Ticketanzahl |
| `SessionModel.setTicketCount(_:)` | – | Modul 004 (Regler-Binding) |
| `SessionModel.startSession(using:)` | – | Modul 004 (Startschaltfläche) |
| `SessionModel.sessionTickets: [Ticket]` | – | Modul 005 ff. (Ticketkarte, Monster) |
| `SessionModel.currentTicket: Ticket?` | – | Modul 005 ff. |
| `SessionModel.currentTicketIndex: Int` | – | Modul 006 ff. (Phasenwechsel, Navigation) |
| `SessionModel.advanceToNextTicket()` | – | Modul 006 ff. |
| `SessionModel.currentPhase: GamePhase` | – | Modul 006 ff. |
| `SessionModel.score: Int` | – | Modul 009/010 (Bewertung) |
| `SessionModel.selectedPriority: TicketPriority?` | – | Modul 008 (Prioritätswahl) |
| `SessionModel.selectedTeam: SupportTeam?` | – | Modul 009 (Teamzuordnung) |
| `SessionModel.isInputLocked: Bool` | – | Modul 006/011 (Übergangssperren) |
| `SessionModel.reset()` | – | Modul 011 (Erneut-spielen-Button) |

## DebugManager

- Ergänzte Kategorie(n): keine — Kategorie `state` war bereits vorhanden.
- Logging-Stellen in `SessionModel`:
  - `setTicketCount(_:)`: Gesetzter (geklemmter) Ticketwert.
  - `startSession(using:)`: Anzahl der ausgewählten Tickets und initiale Phase.
  - `advanceToNextTicket()`: Neuer Index nach Vorschalten oder Hinweis auf Klemm-Position.
  - `reset()`: Bestätigung des vollständigen Resets.
- Die Kategorie `state` ist in `DebugManager.enabled` standardmäßig nicht aktiv; Logging erscheint nur nach explizitem Einschalten über `DebugManager.toggle(.state)` oder `DebugManager.enabled.insert(.state)`.
- Keine vollständigen Tickettexte in Logs, keine unnötigen Datenmengen.

## Test-Anleitung

```
# In Xcode: Scheme „Ticket_Tamer" → Destination „Apple Vision Pro (Simulator)" → ⌘U
# Oder über CLI (Xcode muss installiert sein):
xcodebuild test \
  -scheme Ticket_Tamer \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  -configuration Debug
```

### Erwartetes Ergebnis

| Suite | Anzahl Tests | Neu in Modul |
|---|---|---|
| `TicketTamerTests` | 7 | 0 (aus Modul 001/002) |
| `SessionModelTests` | 12 | 12 (Modul 003) |
| **Gesamt** | **19** | **12** |

Plattform: `arm64-apple-xros-simulator` (Apple Vision Pro Simulator).

### Neue Tests und Nachweis

| Test | Nachweis |
|---|---|
| `defaultTicketCountIsSix` | Standardticketanzahl = 6 |
| `validBoundaryValuesAreAccepted` | Grenzwerte 1 und 12 akzeptiert |
| `invalidTicketCountsAreClamped` | 0, −99 → 1; 13, 1000 → 12 |
| `sessionWithOneTicketContainsExactlyOneTicket` | count == 1 |
| `sessionWithSixTicketsContainsExactlySixTickets` | count == 6 |
| `sessionWithTwelveTicketsContainsExactlyTwelveTickets` | count == 12 |
| `sessionTicketIdsAreUnique` | `Set(ids).count == ids.count` bei 12 Tickets |
| `sessionTicketsComeFromLocalCatalog` | Alle IDs im Katalog-Set enthalten |
| `newSessionsReExecuteShuffleFunction` | `callCount` steigt bei jedem `startSession`-Aufruf |
| `deterministicShuffleFunctionProducesDifferentSelections` | Identity ≠ Reversed bei 6 aus 12 Tickets |
| `ticketIndexStartsAtZeroAfterSessionStart` | `currentTicketIndex == 0` nach Start |
| `currentTicketIsAccessibleAndSafe` | `nil` vor Start, erstes Ticket nach Start |
| `indexAdvancementClampsAtEndOfList` | Klemm bei Index 2 nach dreimaligem Vorschalten in 3-Ticket-Sitzung |
| `resetRestoresAllModelFields` | Alle 8 Felder auf Startwerte nach Sitzung + Indexbewegung + Reset |
| `fiveConsecutiveResetsRemainStable` | 5 Iterations-Resets ohne Altzustand |

### Bestätigung Modulgrenze

- Keine UI-Klassen (SwiftUI View, ViewModifier) implementiert.
- Keine Bewertungslogik, keine Punktevergabe.
- Keine RealityKit-Typen.
- Keine Audiologik.
- Keine automatischen Phasenübergänge.
- `Ticket`, `TicketPriority`, `SupportTeam`, `LocalTicketCatalog` unverändert.
- `Ticket_TamerApp.swift`, `RootVolumeView.swift`, `Info.plist`, `Localizable.xcstrings` unverändert.

## Annahmen / offene Punkte / Risiken

- `@MainActor`-Annotation auf `SessionModel` ist konsistent mit `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` im App-Target. Tests in `SessionModelTests` sind daher ebenfalls `@MainActor` — das wird von Swift Testing unterstützt.
- `SessionModel` besitzt noch keinen Setter für `selectedPriority`, `selectedTeam` und `isInputLocked`. Diese Felder sind als `private(set)` deklariert; Mutationsmethoden folgen in den Modulen, die sie fachlich einführen (Modul 006, 008, 009).
- `monsterAssetId` fehlt im `Ticket`-Modell (Abweichung zur SPEC-Architekturskizze). Laut Modulgrenze darf `Ticket` in Modul 003 nicht geändert werden. Entscheidung muss spätestens vor Modul 005 im Projektlogbuch festgehalten werden.
- `.DS_Store`-Dateien sind im Repository vorhanden (aus Modul-002-Report bekannt). Bereinigung ist keine Aufgabe von Modul 003.
- Ein nachgewiesener Build- und Testlauf nach Modul 002 lag nicht vor. Modul 003 setzt voraus, dass die Modul-002-Dateien korrekt kompilieren. Falls beim ersten Xcode-Build nach Modul 003 ein Modul-002-Fehler auftritt, ist dieser als übernommene Modul-002-Nacharbeit separat zu dokumentieren.
- `DebugManager.enabled` enthält standardmäßig nur `.lifecycle`. Zur Laufzeitprüfung der `state`-Logs muss die Kategorie manuell aktiviert werden.

## Git

- Vorgesehener Commit: `003: Sitzungsmodell und Zufallsauswahl`
- Tatsächlicher Hash: noch nicht bekannt (Commit erfolgt nach lokalem Build- und Testlauf).

## Stand aktualisiert

- [ ] `Projekt-Stand.md` neu erzeugt und im Projektraum **ersetzt** (kein Altstand mit gleichem Namen daneben).
- [ ] `Logbuch-Stand.md` aktualisiert.
- [ ] Umbenannte/gelöschte Dateien im Projekt-Stand unter „nicht mehr vorhanden" vermerkt.

## Empfehlung für das nächste Modul

Als Nächstes sollte Modul 004 „Startansicht und Regler" umgesetzt werden. Es kann `SessionModel` per `@Environment` oder über einen `@State`-Einstiegspunkt in `RootVolumeView` einbinden, `setTicketCount(_:)` an einen Regler (1–12, Standardwert 6) binden und `startSession()` an die Startschaltfläche koppeln. Dabei sollte geprüft werden, ob `SessionModel` als `@State`-Eigenschaft in `RootVolumeView` oder über eine separate `@Environment`-Einbindung bereitgestellt wird — die einfachere Lösung ist vorzuziehen.
