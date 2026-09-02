# Modul-Report — 015 Session-HUD und Interaktionshinweise

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.

**Erstellt am:** 2026-09-02  
**Status:** Implementiert; Xcode-Build, vollständiger Testlauf und Simulatorprüfung in dieser Linux-Umgebung offen.

## Zusammenfassung

Die drei laufenden Spielphasen zeigen nun dasselbe kompakte Sitzungs-HUD mit Ticketposition,
exaktem Phasentitel und linearem Ticketfortschritt. Priorisierung und Teamzuordnung zeigen
zusätzlich ihren dauerhaften Drag-Hinweis. HUD und Hinweise liegen als nicht interaktive
visionOS-Ornaments außerhalb der eigentlichen Szenenfläche; dadurch überdecken sie weder
Tickettexte noch Monster oder Zielpanels und verändern die bestehende RealityView-Geometrie nicht.

## Vorab-Check

| Merkmal | Tatsächlicher Stand vor der Änderung |
|---|---|
| Branch | `main` |
| HEAD | `fc39a56939bb9e16f08cd3f352595e8b673d71f6` (`feat: Version 1.1`) |
| Working Tree | sauber, keine uncommitted Änderungen |
| Letzter dokumentierter v1.0-Abschlussstand | Commit `1532953`: Build PASS, 217/217 Tests PASS nachgetragen |
| Testdatei | 217 statisch gezählte `@Test`-Annotationen |
| Letzter belegter Testlauf | 217 Passed, 0 Failed, 0 Skipped, 11 Suites, `arm64-apple-xros1.0-simulator` |
| Lokale Baseline-Ausführung | nicht möglich: `xcodebuild` ist in der Linux-Umgebung nicht installiert |

Geprüft wurden die aktuellen Fassungen von `InvestigationView`, `PrioritizationView`,
`TeamAssignmentView`, `SessionModel`, `GamePhase`, `Localizable.xcstrings`, `AppConstants`,
`DebugManager` und `Ticket_TamerTests`. `Views/Components/` bestand bereits und wird durch
die Xcode-Dateisystemsynchronisierung automatisch in das App-Target aufgenommen.

## UI-Entwurf

### `SessionHUDView`

Schnittstelle:

```swift
SessionHUDView(
    currentTicketIndex: Int,
    totalTicketCount: Int,
    phase: GamePhase
)
```

Die Komponente zeigt ausschließlich Phasentitel, `Ticket X von Y` und eine lineare
`ProgressView`. Sie erhält keinen Score und hat keinen Zugriff auf `SessionModel`.

### `InteractionHintView`

Schnittstelle:

```swift
InteractionHintView(text: String)
```

Die Komponente besitzt weder Zustand noch Persistenz oder Gesten. Ihre beiden Inhalte sind:

- `Monster greifen und auf eine Priorität ziehen.`
- `Monster greifen und dem zuständigen Team zuordnen.`

### Layout und Hit-Testing

Das HUD wird mit `.ornament(attachmentAnchor: .scene(.top))` oberhalb, der jeweilige Hinweis
mit `.ornament(attachmentAnchor: .scene(.bottom))` unterhalb der Szene verankert. Somit wird
kein Platz aus der `RealityView` abgezogen und es entsteht keine Überdeckung mit den oberen
oder unteren Zielpanels. Beide Komponenten setzen explizit `.allowsHitTesting(false)`.

### Accessibility und Lokalisierung

Die sichtbaren Texte bleiben normale SwiftUI-Texte. Der Fortschrittsbalken besitzt das
Accessibility-Label `Ticketfortschritt` und einen Prozentwert. Neue String-Catalog-Schlüssel:

- `hud.ticket.position`
- `hud.phase.investigation`
- `hud.phase.prioritization`
- `hud.phase.teamAssignment`
- `hud.progress.accessibility`
- `interactionHint.prioritization`
- `interactionHint.teamAssignment`

## HUD-Berechnung

`SessionHUDContent` ist eine rein darstellungsbezogene Ableitung:

```text
currentTicketNumber = clamp(currentTicketIndex + 1, 1...totalTicketCount)
progress = clamp(currentTicketNumber / totalTicketCount, 0...1)
```

Bei einer leeren Sitzung werden Ticketnummer und Fortschritt auf `0` gesetzt; es findet keine
Division statt. Die Phase beeinflusst nur den Titel und nicht den Fortschritt. Die Zuordnung ist:

| Phase | Titel |
|---|---|
| `.untersuchen` | `Ticket untersuchen` |
| `.priorisieren` | `Priorität zuordnen` |
| `.teamZuordnen` | `Team zuordnen` |

Für `.start` und `.ergebnis` wird das HUD nicht eingebunden.

## Dateien

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Ticket_Tamer/Ticket_Tamer/Views/Components/SessionHUDView.swift` | neu | HUD und defensive Anzeigeableitung | F-18 / AK-18 |
| `Ticket_Tamer/Ticket_Tamer/Views/Components/InteractionHintView.swift` | neu | nicht interaktive Drag-Hinweise | F-20 / AK-20 |
| `Ticket_Tamer/Ticket_Tamer/Views/InvestigationView.swift` | geändert | HUD oberhalb der Untersuchung | F-18 / AK-18 |
| `Ticket_Tamer/Ticket_Tamer/Views/PrioritizationView.swift` | geändert | HUD oben, Priorisierungshinweis unten | F-18, F-20 / AK-18, AK-20 |
| `Ticket_Tamer/Ticket_Tamer/Views/TeamAssignmentView.swift` | geändert | HUD oben, Teamhinweis unten | F-18, F-20 / AK-18, AK-20 |
| `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings` | geändert | sieben lokalisierte sichtbare Texte | AK-18, AK-20 |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | geändert | elf Tests für Ableitung, Titel und Hinweise | AK-18, AK-20 |

Tatsächlicher geänderter App-Dateibaum:

```text
Ticket_Tamer/Ticket_Tamer/
├── Resources/Localizable.xcstrings
└── Views/
    ├── InvestigationView.swift
    ├── PrioritizationView.swift
    ├── TeamAssignmentView.swift
    └── Components/
        ├── InteractionHintView.swift
        └── SessionHUDView.swift
```

## Tests

| Kennzahl | Vorher | Nachher im Quellstand |
|---|---:|---:|
| `@Test`-Fälle | 217 | 228 |
| neue Tests | – | 11 |

Die neuen Tests prüfen 1/6, 3/6 = 0,5, 6/6 = 1, unveränderten Fortschritt über alle
drei Unterphasen, Erhöhung beim nächsten Index, leere Sitzung, defensive Indexbegrenzung,
alle exakten Phasentitel, ausgeblendete Phasen und beide exakten Hinweise. `jq empty` für den
String Catalog und `git diff --check` sind PASS.

Ein neuer Xcode-Testlauf konnte nicht ausgeführt werden, weil diese Umgebung weder Xcode noch
`xcodebuild` oder den visionOS-Simulator bereitstellt. Deshalb werden keine Passed-/Failed-/
Skipped-Zahlen für den geänderten Stand behauptet. Zielplattform bleibt Apple Vision Pro,
visionOS-Simulator (`xros`).

## Simulator- und Regressionsprüfung

Die folgende visuelle und interaktive Prüfung ist mangels visionOS-Simulator offen:

- Untersuchung mit `Ticket 1 von 6`, Titel und ca. 1/6 Fortschritt
- Priorisierung mit unverändertem Fortschritt und dauerhaftem Hinweis
- Teamzuordnung mit unverändertem Fortschritt und dauerhaftem Hinweis
- `Ticket 3 von 6` = 50 Prozent sowie `Ticket 6 von 6` = 100 Prozent
- Blickfokus, Pinch und Drag in beiden Entscheidungsphasen
- vollständiger Zyklus Untersuchung → Priorität → Team → nächstes Ticket

Die Überlappungsvermeidung ist konstruktiv im Code umgesetzt: Ornaments liegen außerhalb der
Szenenfläche und verändern weder gemessene Volume-Bounds noch Panel- oder Monsterpositionen.
Die tatsächliche Sichtprüfung bei verschiedenen Betrachtungswinkeln bleibt dennoch erforderlich.

## Erfüllte Akzeptanzkriterien

- [x] AK-18.1–6 — HUD-Inhalt und Ticketfortschritt implementiert und durch Ableitungstests abgesichert.
- [x] AK-18.7 — HUD explizit ohne Hit-Testing und außerhalb der 3D-Szenenfläche.
- [x] AK-20.1–4 — beide exakten, dauerhaften Hinweise ohne Persistenz oder Drag-Zustandsbindung.
- [x] AK-20.5 — Hinweise explizit ohne Hit-Testing und außerhalb der 3D-Szenenfläche.
- [ ] Visueller/Interaktions-Nachweis — in Xcode/visionOS-Simulator noch auszuführen.

## Schutz des v1.0-Kerns

- HUD zeigt keinen Score, keine Zeit, keinen Streak und keine Entscheidungsstatistik.
- Es gibt keinen neuen fachlichen Zustand und keine Änderung an `SessionModel`.
- Drop-Regel, DragBounds, Z-Toleranz, Snapback und Zielpanelgeometrie sind unverändert.
- Scoring, Exactly-once, Audio und Feedback-Transition sind unverändert.
- Die Komponenten starten keine Tasks und lösen keinen Phasenwechsel aus.
- `DebugManager` erhielt keine neue Kategorie und kein Render-Logging.

## Annahmen / offene Punkte / Risiken

- Ornaments sind für das vorhandene visionOS-Ziel die risikoärmste Möglichkeit, Anzeigen ohne
  Überlappung und ohne Änderung der RealityView-Geometrie anzubringen.
- Build und 228er-Testsuite müssen in Xcode nachgeholt werden.
- Eine Sichtprüfung mit sechs Tickets und Drag in beiden Phasen bleibt verpflichtend.

## Git

- Vorgesehener Commit: `015: Session-HUD und Interaktionshinweise`
- Noch kein Commit erzeugt, da Build, Testsuite und Simulatorprüfung vor dem Commit nicht
  vollständig ausgeführt werden konnten.

## Empfehlung für Modul 016 — Kompakte Ticketinfo

Modul 016 sollte seine Ticketinfo ebenfalls als klar abgegrenzte SwiftUI-Darstellung ergänzen,
aber den nun belegten oberen HUD- und unteren Hinweisbereich respektieren. Eine geöffnete
Ticketinfo darf erst nach eigener Spezifikation die Drag-Interaktion sperren; Modul 015 selbst
führt bewusst keine solche Sperre ein.
