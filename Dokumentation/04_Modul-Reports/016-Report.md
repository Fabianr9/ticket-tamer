# Modul-Report — 016 Kompakte Ticketinfo

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.

**Erstellt am:** 2026-09-02  
**Status:** Implementiert und statisch geprüft; Xcode-Build, vollständiger Testlauf und Simulatorprüfung in dieser Linux-Umgebung offen.

## Nachbesserung: vollständige Lesbarkeit und Raumgröße

Nach der ersten Sichtprüfung wurde die Ticketinfo auf eine feste Designfläche von 520 × 560
Punkten umgestellt. `ScaledToFitView` passt diese Fläche mit einem einzigen Skalierungsfaktor
vollständig in den verfügbaren Bereich ein; dadurch werden weder Text noch X-Schalter an der
Volume-Kante abgeschnitten. Alle Textblöcke behalten ihre vollständige vertikale Größe.

Das zentrale Volume wurde von 1,0 × 1,0 × 0,4 m auf 1,2 × 1,15 × 0,45 m vergrößert. Die
Monster-Zielgröße wurde in der Untersuchung von 0,24 m auf 0,20 m und in den beiden
Drag-Drop-Phasen von 0,13 m auf 0,11 m reduziert. `MonsterAssetProvider.fit` skaliert weiterhin
mit einem einheitlichen Faktor über alle Achsen; die Modellproportionen bleiben unverändert.

## Zusammenfassung

Priorisierung und Teamzuordnung besitzen nun denselben Info-Schalter. Er öffnet eine kompakte
SwiftUI-Übersicht für exakt `model.currentTicket` und schließt sie bei erneutem Info-Tap oder
über den X-Schalter. Die Übersicht enthält ausschließlich Ticketnummer, Titel,
Kurzbeschreibung, User Impact und alle Symptome/Hinweise. Referenzpriorität, Referenzteam,
Score, Auswahlwerte, interne Ticket-ID und Monster-Asset-ID sind nicht Bestandteil ihres
Darstellungsmodells.

Während die Übersicht geöffnet ist, hat die verdeckte `RealityView` kein Hit-Testing.
Zusätzliche Guards in beiden Drag-Handlern verhindern auch für eine bereits laufende Geste
Monsterbewegung, Drop-Auswertung, Entscheidung und Snapback. Der fachliche
`model.isInputLocked`-Zustand wird weder für das Overlay gesetzt noch beim Schließen verändert.

## Vorab-Check

| Merkmal | Tatsächlicher Stand vor Modul 016 |
|---|---|
| Branch | `side` |
| HEAD | `9fd8706363983cf1ad4ccabbfddab1f5aef08424` (`feat: Eingangsprompt 16`) |
| Modul-015-Commit | `afe4bce` (`feat: Modul 15`) |
| Working Tree | sauber |
| Testdeklarationen | 228 `@Test`-Annotationen |
| Letzter belegter Xcode-Lauf | v1.0: 217 Passed, 0 Failed, 0 Skipped |
| Build-/Testbaseline für Modul 015 | offen; `xcodebuild` ist in der Linux-Umgebung nicht installiert |
| Modul-015-Simulatorprüfung | offen; kein visionOS-Simulator verfügbar |

Modul 015 war bereits separat committed. Daher wurden keine Änderungen aus 015 und 016
vermischt.

## Ticketinfo-Entwurf

`CompactTicketInfoView(ticket:onClose:)` erhält genau das aktuelle `Ticket` und leitet daraus
intern einen unveränderlichen `CompactTicketInfoContent` ab. Dieser Typ besitzt ausschließlich:

- `ticketNumber`
- `title`
- `shortDescription`
- `userImpact`
- `symptoms`

Die Darstellung liegt als kompaktes Material-Panel innerhalb des bestehenden zentralen
Volumes. Ein leicht abgedunkelter Hintergrund trennt sie von der 3D-Szene. Der Info-Schalter
bleibt darüber erreichbar, damit der erneute Tap das Overlay schließen kann. Der X-Schalter
besitzt das Accessibility-Label `Ticketinformationen schließen`; der Info-Schalter
`Ticketinformationen anzeigen oder schließen`. Die vorhandenen semantisch identischen
Lokalisierungen für Ticketnummer, Auswirkung und Symptome werden wiederverwendet.

Ausdrücklich ausgeschlossen sind Referenzpriorität, Referenzteam, richtige Lösung,
`selectedPriority`, `selectedTeam`, Score, interne Ticket-ID, `monsterAssetId` und sonstige
Bewertungsdaten. `currentTicket == nil` führt defensiv weder zu einem Info-Schalter noch zu
einem Overlay.

## Overlay-State und Drag-Sperre

Beide Entscheidungsviews halten separat:

```swift
@State private var isTicketInfoPresented = TicketInfoInteraction.initialPresentation
```

Der Initialwert ist `false`. Info-Tap toggelt den Wert, X setzt ihn auf `false`. `onAppear`
und jede Änderung von `model.currentPhase` schließen die Übersicht. Damit kann kein Overlay
in die Teamphase, zum nächsten Ticket oder ins Ergebnis übernommen werden.

Die Drag-Freigabe ist exakt:

```text
!isTicketInfoPresented && !model.isInputLocked
```

Sie wird an der `RealityView` über `allowsHitTesting` angewendet. Beide Gesture-Handler haben
zusätzlich einen frühen Overlay-Guard. Beim Schließen wird kein `model.unlockInput()` gerufen:
Ein bestehender fachlicher Lock bleibt daher maßgeblich, ein fachlich freier Drag wird sofort
wieder möglich.

## Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Views/Components/CompactTicketInfoView.swift` | neu | Begrenztes Darstellungsmodell, gemeinsame Ticketinfo, Toggle-/Drag-Regeln | F-19 / AK-19.1–5 |
| `Views/PrioritizationView.swift` | geändert | lokaler State, Info-Button, Overlay, Drag-Sperre und Phasenreset | F-19 / AK-19.1, 4–6 |
| `Views/TeamAssignmentView.swift` | geändert | identische Integration in der Teamphase | F-19 / AK-19.1, 4–6 |
| `Resources/Localizable.xcstrings` | geändert | Accessibility-Texte für Info und X | AK-19 |
| `Ticket_TamerTests.swift` | geändert | 18 Tests für Inhalt, Ausschlüsse, Toggle, Drag-Freigabe und Layoutgrößen | AK-19 |
| `016-Report.md` | neu | tatsächlicher Implementierungs- und Prüfstand | Modulabschluss |

`InvestigationView`, `SessionHUDView`, `InteractionHintView`, `SessionModel`, `Ticket` sowie
Scoring-, Audio-, Drop- und Geometriecode blieben unverändert. Insbesondere gibt es in der
Untersuchungsphase keinen zusätzlichen Info-Button.

## Tests

| Kennzahl | Vorher | Nachher im Quellstand |
|---|---:|---:|
| `@Test`-Fälle | 228 | 246 |
| neue Tests | – | 18 |

Die neuen Tests sichern die fünf sichtbaren Datenfelder einschließlich aller Symptome,
Unabhängigkeit von Referenzpriorität, Referenzteam, interner ID und Monsterasset, geschlossenen
Initialzustand, beide Toggle-Richtungen, geschlossenen Neustartzustand sowie die Kombinationen
von Overlay und fachlichem Input-Lock ab. Drei zusätzliche Layouttests sichern Designfläche,
vergrößertes Volume und reduzierte Monster-Zielgrößen. Score und Auswahlwerte werden vom
Darstellungsmodell nicht angefordert.

Statische Prüfungen:

- `jq empty Resources/Localizable.xcstrings`: PASS
- `git diff --check`: PASS
- Testdeklarationszählung: 246

Ein Xcode-Build und die Testsuite konnten nicht ausgeführt werden, weil `xcodebuild`, Xcode und
die visionOS-Laufzeit in dieser Linux-Umgebung fehlen. Daher werden für den neuen Stand keine
Passed-/Failed-/Skipped-Zahlen behauptet. Zielplattform bleibt Apple Vision Pro / visionOS.

## Simulator- und Regressionstest

Mangels visionOS-Simulator offen:

- Overlay und Inhalt in Priorisierung und Teamzuordnung visuell prüfen
- X und erneuten Info-Tap prüfen
- Drag bei offenem Overlay blockiert, nach Schließen wieder aktiv
- Overlay bei Priorität → Team und Team → nächstes Ticket/Ergebnis geschlossen
- vollständigen Ticketzyklus ohne Doppelwertung, Doppelsound oder doppelte Zielpanels prüfen
- HUD und untere Interaktionshinweise aus Modul 015 auf unverändertes Layout prüfen

Konstruktiv bleibt die v1.0-/015-Logik unverändert: Das Overlay erzeugt weder Entities noch
Tasks, schreibt keinen Sessionzustand und ruft keine Bewertungs-, Speicher-, Lock- oder
Phasenwechselmethode auf.

## Erfüllte Akzeptanzkriterien

- [x] AK-19.1–3 — aktuelle Ticketquelle und exakt begrenzter Inhalt
- [x] AK-19.4 — RealityView-Hit-Testing und Gesture-Handler bei offenem Overlay gesperrt
- [x] AK-19.5 — Schließen über X und erneuten Info-Tap; fachlicher Lock bleibt erhalten
- [x] AK-19.6 — lokaler Initialzustand sowie expliziter Reset bei View-/Phasenwechsel
- [x] AK-19.7 — `InvestigationView` unverändert ohne neuen Info-Button
- [ ] Visueller/Interaktions-Nachweis und vollständiger Xcode-Testlauf

## Offene Risiken

Die tatsächliche räumliche Größe, Lesbarkeit, Blickfokus-Reihenfolge und Interaktion müssen auf
Apple Vision Pro beziehungsweise im visionOS-Simulator abgenommen werden. Erst danach sollte
der vorgesehene Commit `016: Kompakte Ticketinfo` erzeugt werden; aktuell wurde kein Hash
erfunden und kein Modul-016-Commit angelegt.

## Empfehlung für Modul 017 — Startseiten-Usability

Modul 017 kann ausschließlich die beschriebene Startseiten-Ergänzung und Minus-/Plus-Bedienung
umsetzen. Die lokale Ticketinfo, ihre Drag-Sperre und die Entscheidungssichten sollten dabei
unverändert bleiben.
