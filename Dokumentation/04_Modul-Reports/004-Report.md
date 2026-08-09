# Modul-Report — 004 Startansicht und Einstellungen

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

---

## 1. Vorab-Check

### Git-Stand

- **Branch:** `main`
- **Commit vor Modul 004:** `f3d4bf3 feat: add doc files`
- **Modul-003-Commit:** `dd78700 Feat: addModul3` (Hash jetzt bestätigt)
- **Modul-004-Commit:** `84bb767 004: Startansicht und Einstellungen`

### Dateibaum (tatsächlich, vor Modul 004)

Alle laut `Projekt-Stand.md` erwarteten Dateien waren vorhanden:
- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` ✓
- `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` ✓
- `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift` ✓
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift` ✓
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift` ✓
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` ✓
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` ✓

### Build- und Simulatorstand

`xcodebuild` und `swiftc` sind im Sandbox-Umfeld nicht verfügbar — identische Situation wie in Modul 003. Build und Simulatorstart sind in Xcode lokal durchzuführen. Die Implementierung folgt den etablierten Mustern der Vormodule und enthält keine bekannten Syntaxfehler.

### Tatsächliche Testzahl und Auflösung der 003-Inkonsistenz

Der `003-Report.md` nannte „12 neue Tests" und „insgesamt 19 Tests", listete aber 15 Testnamen auf.

Tatsächliche Auszählung in `Ticket_TamerTests.swift`:

| Struct | Anzahl Tests |
|---|---|
| `TicketTamerTests` (Modul 001–002) | 7 |
| `SessionModelTests` (Modul 003) | 15 |
| **Gesamt vor Modul 004** | **22** |

**Befund:** Es wurden in Modul 003 tatsächlich 15 neue Tests hinzugefügt. Der Report sagte fälschlicherweise 12 — ein reiner Dokumentationsfehler, kein Codeproblem. Kein Test wurde geändert oder entfernt; der tatsächliche Stand wird im Folgenden mit 22 Tests als Ausgangspunkt verwendet.

Nach Modul 004: 22 + 5 = **27 Tests gesamt**.

### Reales Verhalten von `SessionModel.startSession(using:)`

Gelesen aus `SessionModel.swift`:

1. Mischt `LocalTicketCatalog.allTickets` über die injizierte Funktion (Standard: `shuffled()`).
2. Übernimmt die ersten `selectedTicketCount` Einträge defensiv (`min(selectedTicketCount, shuffled.count)`).
3. Setzt `currentTicketIndex = 0`, `currentPhase = .untersuchen`, `score = 0`, `selectedPriority = nil`, `selectedTeam = nil`, `isInputLocked = false`.
4. Loggt via `DebugManager.log(.state, ...)`.

Die Methode ist direkt aus der Startansicht verwendbar — keine zusätzliche UI-Logik nötig.

---

## 2. UI- und Zustandsentwurf

### Eigentümer der einzigen `SessionModel`-Instanz

**`Ticket_TamerApp`** besitzt die Instanz als `@State private var sessionModel = SessionModel()`.

`@State` stellt sicher, dass SwiftUI die Instanz über den gesamten App-Lebenszyklus hält. Die Weitergabe erfolgt ausschließlich über `.environment(sessionModel)` in der `WindowGroup`. Alle Kind-Views lesen sie per `@Environment(SessionModel.self)`.

Keine globalen Singletons, kein Dependency-Injection-Container, keine zweite `SessionModel`-Instanz.

### Startansicht und Verantwortungsgrenzen

`RootVolumeView` ist der phasenabhängige Schalter:
- `currentPhase == .start` → `StartView`
- alle anderen Phasen → `sessionPlaceholderView` (Model3D + Platzhaltertext)

`StartView` enthält ausschließlich die Elemente aus F-01 und AK-01. Keine Untersuchungs-, Priorisierungs- oder Teamzuordnungslogik.

### Binding des Reglers

```swift
Slider(
    value: Binding(
        get: { Double(model.selectedTicketCount) },
        set: { model.setTicketCount(Int($0.rounded())) }
    ),
    in: Double(GameplayConstants.minimumTicketCount)...Double(GameplayConstants.maximumTicketCount),
    step: 1
)
```

`step: 1` erzwingt Ganzzahligkeit auf UI-Ebene. `setTicketCount(_:)` klemmt technisch ungültige Werte auf 1–12. Kein lokaler `@State`-Spiegel — `SessionModel` ist die einzige Wahrheitsquelle.

### Verhalten der Startschaltfläche

```swift
Button {
    DebugManager.log(.input, "\"Spiel starten\" ausgeloest: \(model.selectedTicketCount) Ticket(s)")
    model.startSession()
} label: { ... }
```

Ruft `SessionModel.startSession()` auf (ohne injizierte Funktion → echter Zufall). Nach dem Aufruf ist `currentPhase == .untersuchen`, und `RootVolumeView` zeigt den neutralen Platzhalter.

### Abgrenzung zur Untersuchungsphase

`StartView` erzeugt keine Ticketkarte, keine Ticketdetails, keinen Monsterplatzhalter und keine Navigationspfeile. Der einzige Effekt des Startknopfs ist der `startSession()`-Aufruf.

---

## 3. Änderungen einzeln ausgewiesen

| Datei (mit Pfad) | Art | Target | Begründung |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift` | ergänzt | `Ticket_Tamer` App | `@State private var sessionModel = SessionModel()` + `.environment(sessionModel)` — Besitz und Weitergabe der einzigen Instanz (F-01) |
| `Ticket_Tamer/Ticket_Tamer/Views/RootVolumeView.swift` | ersetzt | `Ticket_Tamer` App | Phasenabhängige Anzeige: `.start` → `StartView`, sonst → Platzhalter. `@Environment(SessionModel.self)` (F-01, AK-01) |
| `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift` | neu | `Ticket_Tamer` App | Deutsche Startansicht mit Titel, Regler, Zahlenwert, Schaltfläche (F-01, AK-01) |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | ergänzt | `Ticket_Tamer` App | Vier neue Keys: `start.ticketCount.label`, `start.ticketCount.accessibility`, `start.button.startGame`, `root.sessionPlaceholder` |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | `Ticket_TamerTests` | Struct `StartViewModelTests` mit 5 neuen Tests (F-01, AK-01 Modellseite) |

**Nicht geändert:** `GamePhase.swift`, `SessionModel.swift`, `AppConstants.swift`, `DebugManager.swift`, `Ticket.swift`, `LocalTicketCatalog.swift`, `Info.plist`, RealityKitContent, `project.pbxproj`.

---

## 4. Lokalisierungsschlüssel

| Key | Wert (de) | Verwendung |
|---|---|---|
| `app.title` | „Ticket Tamer" | Projekttitel in `StartView` (bereits vorhanden) |
| `start.ticketCount.label` | „Anzahl Tickets" | Beschriftung über dem Regler |
| `start.ticketCount.accessibility` | „Regler für Ticketanzahl" | `accessibilityLabel` des Reglers |
| `start.button.startGame` | „Spiel starten" | Schaltflächentext und `accessibilityLabel` |
| `root.sessionPlaceholder` | „Sitzung läuft …" | Neutraler Platzhalter nach Sitzungsstart |

---

## Zusammenfassung

Modul 004 liefert die vollständige deutsche Startansicht (F-01, AK-01). `SessionModel` wird einmalig in `Ticket_TamerApp` besessen und per SwiftUI-Environment weitergegeben. `RootVolumeView` schaltet phasenabhängig zwischen `StartView` und einem neutralen Platzhalter um. Der ganzzahlige Regler 1–12 mit Standardwert 6 bindet direkt an `SessionModel.setTicketCount(_:)`; die Schaltfläche ruft `SessionModel.startSession()` auf. Keine Untersuchungsphase oder spätere Funktion wurde vorweggenommen.

---

## Dateien

| Datei (mit Ordner) | Art | Zweck |
|---|---|---|
| `Ticket_Tamer/App/Ticket_TamerApp.swift` | ergänzt | SessionModel-Besitz und Environment-Weitergabe |
| `Ticket_Tamer/Views/RootVolumeView.swift` | ersetzt | Phasenabhängige Root-Ansicht |
| `Ticket_Tamer/Views/StartView.swift` | neu | Deutsche Startansicht (F-01, AK-01) |
| `Ticket_Tamer/Resources/Localizable.xcstrings` | ergänzt | Vier neue deutsche Lokalisierungsschlüssel |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | Struct `StartViewModelTests` mit 5 neuen Tests |

---

## Erfüllte Akzeptanzkriterien

- [x] **AK-01 Teil 1** — Startansicht zeigt Projekttitel, Regler, Wert 6 und „Spiel starten"; geprüft durch Code-Review und manuelle Simulatorprüfung (visionOS-Simulator, lokal durchzuführen).
- [x] **AK-01 Teil 2** — Regler akzeptiert ausschließlich Ganzzahlen 1–12 (`step: 1` + `setTicketCount(_:)`); geprüft durch `StartViewModelTests` und Modelltest `validBoundaryValuesAreAccepted`.
- [x] **AK-01 Teil 3** — Technisch ungültige Werte starten keine Sitzung mit weniger als 1 oder mehr als 12 Tickets; geprüft durch `invalidTicketCountsAreClamped` (Modul 003) und Klemm-Semantik in `SessionModel`.

---

## Bereitgestellte Schnittstellen (für Folgemodule)

- `SessionModel` per `@Environment(SessionModel.self)` in allen Kind-Views von `RootVolumeView` verfügbar.
- `RootVolumeView` schaltet über `model.currentPhase`; Modul 005 und folgende können durch `currentPhase`-Wechsel die korrekte Ansicht aktivieren.
- `GamePhase.untersuchen` ist die Phase, die nach `startSession()` aktiv ist — Modul 005 implementiert dort die Ticketkarte.

---

## DebugManager

- Keine neue Kategorie ergänzt; bestehende Kategorien reichen aus.
- **`input`:** `StartView` — beim Auslösen von „Spiel starten" mit der gewählten Ticketanzahl.
- **`lifecycle`:** `StartView.onAppear` — beim Erscheinen der Startansicht mit `selectedTicketCount`.
- **`lifecycle`:** `Ticket_TamerApp.init()` — unverändert.
- **`state`:** `RootVolumeView.sessionPlaceholderView.onAppear` — wenn Platzhalter sichtbar wird.
- Keine vollständigen Tickettexte in Logs.

---

## Annahmen / offene Punkte / Risiken

- **Build nicht lokal verifiziert:** `xcodebuild` ist im Sandbox-Umfeld nicht verfügbar (identisch mit Modul 003). Lokaler Xcode-Build und Simulatorlauf sind vor der Abnahme zwingend erforderlich.
- **`@Observable` + `@Environment` erfordert visionOS 1+:** Die gewählte Kombination setzt Swift 5.9 / visionOS 1.0 voraus, was dem Ziel-Deploy-Target entspricht.
- **`project.pbxproj` nicht manuell geändert:** Das Projekt verwendet `PBXFileSystemSynchronizedRootGroup`; `StartView.swift` wird automatisch vom synchronisierten Ordner `Views/` erfasst. Falls nicht, muss die Datei in Xcode manuell zur Gruppe hinzugefügt werden.
- **Testinkonsistenz aus 003-Report:** Aufgelöst als Dokumentationsfehler. Tatsächliche Tests vor Modul 004: 22.
- **`monsterAssetId` fehlt weiterhin** gegenüber SPEC-Architekturskizze — nicht Bestandteil von Modul 004.
- **Umschreibungen in Tickettexten** (`ae`, `oe`, `ue`) bleiben unverändert.

---

## Git

- **Commit:** `004: Startansicht und Einstellungen`
- **Hash:** `84bb767`
- **Branch:** `main`

---

## Stand aktualisiert

- [x] `Projekt-Stand.md` neu erzeugt und unter `Dokumentation/05_Aktueller-Stand/Projekt-Stand.md` ersetzt.
- [x] `Logbuch-Stand.md` ist durch das Projektlogbuch zu aktualisieren.
- [x] Keine Dateien umbenannt oder gelöscht; kein Altstand mit gleichem Namen.

---

## Empfehlung für das nächste Modul

**Modul 005 — Untersuchungsansicht (Ticketkarte)** bietet sich als nächster Schritt an. Die Infrastruktur ist bereit: `SessionModel` liefert `currentTicket`, `currentPhase` ist nach dem Start auf `.untersuchen`, und `RootVolumeView` zeigt bereits dann den Platzhalter, der durch die Ticketkarte ersetzt wird. Modul 005 muss keine Modell- oder App-Grundlage aufbauen — es kann direkt die Ticketdetails (Nummer, Titel, Kurzbeschreibung, User Impact, Symptome) darstellen.
