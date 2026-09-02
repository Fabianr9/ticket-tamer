# Usability-Änderungen für Ticket Tamer

## Ziel dieses Dokuments

Dieses Dokument vergleicht die ursprünglichen UI-Skizzen mit dem aktuellen Code und sammelt kleine, risikoarme Änderungen mit hohem Usability-Nutzen. Die Vorschläge bleiben innerhalb der bestehenden Architektur:

- genau ein zentrales Volume
- linearer Ablauf `Start → Untersuchen → Priorisieren → Team zuordnen → Ergebnis`
- `SessionModel` als einzige Quelle des fachlichen Sitzungszustands
- keine Anzeige der richtigen Lösung oder einer textlichen Begründung
- Ergebnisansicht weiterhin ausschließlich mit Gesamtpunktzahl und „Erneut spielen“
- keine Änderungen an Drop-Regel, Scoring, Exactly-once-Semantik oder Asset-Pipeline

## Beobachteter Ist-Zustand

Die aktuelle App setzt den Kernablauf stabil, aber wesentlich reduzierter als die ursprünglichen Skizzen um:

1. Auf der Startansicht werden Titel, Ticketanzahl-Slider, Zahlenwert und Startbutton angezeigt.
2. Nur in der Untersuchungsphase sind Monster und vollständige Ticketkarte gleichzeitig sichtbar.
3. In der Priorisierungsphase ersetzt eine reine 3D-Szene die Ticketansicht. Sichtbar sind Monster und drei beschriftete Zielpanels.
4. In der Teamphase sind Monster und vier beschriftete Zielpanels sichtbar.
5. Nach einer gültigen Entscheidung erfolgt nur akustisches Feedback; während der folgenden 1,5 Sekunden bleibt die Eingabe gesperrt.
6. Der Fortschritt innerhalb der Sitzung und die aktuelle Phase werden nicht sichtbar angezeigt.
7. Ladefehler werden angezeigt, bieten aber keinen sichtbaren Wiederholungsweg.
8. Die ursprünglichen Konzepte eines persistenten HUDs, einer Begleitfigur, zweier Spielmodi und raumgroßer Themenstationen wurden zugunsten des einzelnen kompakten Volumes nicht umgesetzt.

Der größte aktuelle Usability-Verlust entsteht beim Wechsel aus der Untersuchung: Die für die Entscheidung benötigten Ticketinformationen verschwinden vollständig. Die Person muss Titel, Beschreibung, Auswirkung und Symptome aus dem Gedächtnis priorisieren und anschließend bis zur Teamzuordnung behalten.

## Priorität 1: Ticketinformationen in beiden Zuweisungsphasen verfügbar halten

### Problem

`PrioritizationView` und `TeamAssignmentView` greifen zwar intern auf `model.currentTicket` zu, zeigen dessen Inhalt aber nicht an. Damit geht der fachliche Kontext genau in dem Moment verloren, in dem er gebraucht wird. Das weicht deutlich von der zweiten Skizze ab, in der das Ticket zentral und zusätzliche Details dauerhaft sichtbar bleiben.

### Änderung

In beiden Zuweisungsphasen wird eine kompakte, ein- und ausblendbare Ticketübersicht angezeigt. Sie enthält ausschließlich:

- Ticketnummer
- Titel
- Kurzbeschreibung
- User Impact
- Symptome beziehungsweise Hinweise

Referenzpriorität und Referenzteam dürfen niemals angezeigt werden.

Empfohlene Darstellung:

- ein kleiner Button „Ticket anzeigen“ beziehungsweise ein Info-Symbol am oberen Rand
- beim Aktivieren ein Material-Panel als SwiftUI-Overlay über der `RealityView`
- Panel standardmäßig kompakt oder eingeklappt, damit Ziele und Monster nicht verdeckt werden
- Schließen über „X“, erneutes Tippen auf den Info-Button oder Blick außerhalb
- `.allowsHitTesting(true)` nur innerhalb des Panels; die verdeckte 3D-Szene darf in diesem Zustand optional keine Drag-Eingaben annehmen

### Technische Umsetzung

Eine neue wiederverwendbare View anlegen:

```text
Ticket_Tamer/Ticket_Tamer/Views/Components/CompactTicketInfoView.swift
```

Mögliche Schnittstelle:

```swift
struct CompactTicketInfoView: View {
    let ticket: Ticket
    let onClose: () -> Void
}
```

`PrioritizationView` und `TeamAssignmentView` erhalten nur lokalen Darstellungszustand:

```swift
@State private var isTicketInfoPresented = false
```

Die Daten werden direkt aus `model.currentTicket` gelesen. Es ist keine Änderung am `SessionModel` erforderlich. Layout und Typografie können aus `TicketCardView` übernommen werden; die Aktionsschaltfläche „Weiter zur Priorisierung“ gehört jedoch nicht in die kompakte Variante.

### Aufwand und Risiko

- Aufwand: klein bis mittel
- Risiko: gering
- Hoher Nutzen, weil die Aufgabe nicht mehr vom Kurzzeitgedächtnis abhängt
- Tests: View-Previews für kurze und lange Tickets; Simulatorprüfung, dass das Overlay Drag-Gesten nicht versehentlich auslöst

## Priorität 2: Permanentes kompaktes Sitzungs-HUD

### Problem

Die erste Skizze sieht ein dauerhaft sichtbares Fortschritts-HUD vor. Im aktuellen Code ist weder die Position in der Sitzung noch die aktuelle Aufgabe sichtbar. Bei 6 oder 12 Tickets fehlt dadurch Orientierung.

### Änderung

Am oberen Rand der Untersuchungs- und Zuweisungsphasen erscheint eine kleine, ruhige Statusleiste:

```text
Ticket 3 von 6  ·  Priorität zuordnen
```

Optional kann darunter ein linearer Fortschrittsbalken stehen. Score, richtige/falsche Antworten, Zeit und Streak sollten zunächst nicht ergänzt werden: Diese Informationen sind im gegenwärtigen Sitzungsmodell nicht als UX-Anforderung vorgesehen und würden das schlanke Spielkonzept stärker verändern.

### Technische Umsetzung

Neue Komponente:

```text
Ticket_Tamer/Ticket_Tamer/Views/Components/SessionHUDView.swift
```

Sie erhält reine Werte statt einer zweiten Modelinstanz:

```swift
struct SessionHUDView: View {
    let currentTicketNumber: Int
    let totalTicketCount: Int
    let phaseTitle: LocalizedStringKey
}
```

Vorhandene Daten genügen:

```swift
currentTicketNumber: model.currentTicketIndex + 1
totalTicketCount: model.sessionTickets.count
```

Phasentitel:

- „Ticket untersuchen“
- „Priorität zuordnen“
- „Team zuordnen“

Die Komponente wird als nicht interaktives Overlay mit `.allowsHitTesting(false)` eingebunden. Neue Texte gehören in `Resources/Localizable.xcstrings`.

### Aufwand und Risiko

- Aufwand: klein
- Risiko: sehr gering
- Keine Modelmutation und keine Änderung am Ablauf
- Besonders hoher Orientierungsgewinn bei langen Sitzungen

## Priorität 3: Sichtbare Interaktionsanweisung und Phasenziel

### Problem

Die ursprünglichen Skizzen zeigen „How to interact“-Hinweise und konkrete Handlungsaufforderungen. Im aktuellen Zuweisungsmodus erscheinen nur Monster und Stationsnamen. Dass das Monster per Blick, Pinch und Drag bewegt werden soll, muss erraten werden. Dies widerspricht dem Ziel, den Kernablauf ohne separate Anleitung verständlich zu machen.

### Änderung

Unter dem HUD oder nahe am Monster wird eine kurze Anweisung angezeigt:

- Priorisierung: „Monster greifen und auf eine Priorität ziehen.“
- Teamzuordnung: „Monster greifen und dem zuständigen Team zuordnen.“

Optional erscheint beim ersten Zuweisungsschritt ein kleines SF-Symbol für Pinch/Drag. Nach Beginn der ersten Drag-Geste kann der Hinweis dezent ausblenden, damit er nicht dauerhaft Platz belegt.

### Technische Umsetzung

Minimalvariante: reines `Text`-Overlay in beiden Views.

Verbesserte Variante: wiederverwendbare `InteractionHintView` und lokaler Zustand:

```swift
@State private var hasStartedDragging = false
```

In `handleDragChanged` wird der Wert beim ersten gültigen Drag gesetzt. Keine Persistenz ist nötig. Soll der Hinweis nur beim allerersten Appgebrauch erscheinen, kann später `@AppStorage` ergänzt werden; für die erste Umsetzung ist das nicht erforderlich.

Das Overlay muss `.allowsHitTesting(false)` verwenden, damit es die Entity-Geste nicht blockiert.

### Aufwand und Risiko

- Aufwand: sehr klein
- Risiko: sehr gering
- Deutlich bessere Erstbenutzung und geringere Fehlinterpretation der 3D-Szene

## Priorität 4: Feedbackphase visuell verständlich machen

### Problem

Nach einem gültigen Drop wird die Eingabe gesperrt, ein Sound abgespielt und nach 1,5 Sekunden automatisch gewechselt. Ohne hörbaren Ton wirkt die Szene in diesem Zeitraum möglicherweise eingefroren. Die Spezifikation erlaubt eine fröhliche oder traurige Monsteranimation, verbietet aber die Anzeige der richtigen Lösung und einer textlichen Begründung.

### Änderung

Während der vorhandenen Feedbackzeit erhält das Monster ein kurzes, rein visuelles Feedback:

- richtig: leichtes Aufspringen beziehungsweise sanftes Pulsieren
- falsch: kurzes seitliches Wackeln
- zusätzlich optional ein neutraler kleiner Übergangsindikator ohne Lösungstext

Kein Text wie „Richtig“, „Falsch“ oder die korrekte Zielbezeichnung anzeigen, solange die bestehende Anforderung unverändert bleibt. Die Animation ergänzt den Sound barriereärmer, ohne eine Lösung offenzulegen.

### Technische Umsetzung

`evaluatePriority()` und `evaluateTeam()` liefern bereits `Bool?`. Das Ergebnis wird nur lokal für die Animation gehalten:

```swift
@State private var feedbackResult: Bool?
```

Vor dem bestehenden `Task.sleep`:

1. Ergebnis speichern.
2. Entity-Transform mit kurzer RealityKit-/SwiftUI-Animation verändern.
3. Nach 1,5 Sekunden Zustand zurücksetzen und den bereits vorhandenen Phasenwechsel ausführen.

Die Entity muss vor Beginn der Animation ihre Basis-Transformation sichern, damit kein Scale- oder Positionsdrift über mehrere Tickets entsteht. Die Exactly-once-Bewertung und `feedbackTaskStarted` bleiben unverändert.

### Aufwand und Risiko

- Aufwand: klein bis mittel
- Risiko: gering, wenn ausschließlich der visuelle Transform animiert wird
- Wichtig: Regressionstest für Ausgangstransform, Eingabesperre und genau einen Phasenwechsel

## Priorität 5: Ticketanzahl präziser bedienbar machen

### Problem

Der Startbildschirm verwendet nur einen Slider für diskrete Werte von 1 bis 12. In einer räumlichen Oberfläche ist eine exakte Zahl per Slider schwieriger zu treffen als über direkte Schaltflächen.

### Änderung

Den Slider beibehalten, aber den sichtbaren Wert um Minus- und Plus-Buttons ergänzen:

```text
[ − ]   6 Tickets   [ + ]
```

Die Buttons werden bei 1 beziehungsweise 12 deaktiviert. Dadurch bleiben schnelle grobe Auswahl und präzise Einzelschritte möglich.

### Technische Umsetzung

Die vorhandene Validierung wird wiederverwendet:

```swift
model.setTicketCount(model.selectedTicketCount - 1)
model.setTicketCount(model.selectedTicketCount + 1)
```

Es wird kein zusätzlicher Zustand eingeführt. Accessibility-Labels:

- „Ein Ticket weniger“
- „Ein Ticket mehr“
- Zahlenanzeige als „6 Tickets“

### Aufwand und Risiko

- Aufwand: sehr klein
- Risiko: sehr gering
- Verbesserung für Präzision und motorische Zugänglichkeit

## Priorität 6: Ladefehler mit „Erneut versuchen“ auflösbar machen

### Problem

Alle Phasen zeigen Ladefehler an, bieten aber keine Recovery-Aktion. In den Zuweisungsphasen bleibt die Sitzung dadurch ohne Neustart hängen.

### Änderung

Jede Monster-Fehleransicht erhält den Button „Erneut versuchen“.

### Technische Umsetzung

In `InvestigationView` existieren mit `resetMonster()` und `loadMonster(for:)` bereits geeignete Methoden.

In `PrioritizationView` und `TeamAssignmentView` wird das Monsterladen aus `setupScene()` in eine getrennte Methode extrahiert, zum Beispiel:

```swift
private func loadCurrentMonster() async
```

Der Retry darf nur das Monster laden und nicht erneut die Zielpanels erzeugen. Vor dem Versuch `loadError = nil` setzen und einen Ladeindikator zeigen. Fachlicher Zustand, Auswahl und Score bleiben unberührt.

### Aufwand und Risiko

- Aufwand: klein
- Risiko: gering
- Verhindert eine Sackgasse bei temporären RealityKit-Ladeproblemen

## Priorität 7: Eingeklappte Kurzhilfe auf der Startansicht

### Problem

Die ursprüngliche Startskizze vermittelt App-Zweck und Lernkontext. Die aktuelle Startansicht enthält nur Titel, Ticketanzahl und Startbutton. Neue Personen wissen vor Sitzungsbeginn nicht, was sie erwartet.

### Änderung

Unter dem Titel eine knappe Erklärung ergänzen:

> Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.

Optional darunter ein kleiner Info-Button „So funktioniert’s“, der drei Schritte zeigt:

1. Ticket lesen
2. Priorität zuordnen
3. Team zuordnen

Keinen separaten Lern- und Challenge-Modus einführen; das wäre eine neue Produktfunktion mit zusätzlichen Zuständen, Regeln und Tests.

### Technische Umsetzung

Die Kurzbeschreibung ist ein lokalisierter `Text`. Die optionale Hilfe kann als kleines `popover` oder Material-Overlay rein lokal in `StartView` umgesetzt werden. Das `SessionModel` bleibt unverändert.

### Aufwand und Risiko

- Aufwand: sehr klein bis klein
- Risiko: sehr gering
- Verbessert Erwartungsmanagement vor dem Start

## Empfohlenes gemeinsames UI-Muster

Damit die Ergänzungen nicht zu vielen unabhängigen Overlays führen, sollte für die drei aktiven Sitzungsphasen ein gemeinsames Layoutmuster verwendet werden:

```text
┌──────────────────────────────────────────┐
│ Ticket 3 von 6 · Priorität zuordnen  [i]│  SessionHUDView
├──────────────────────────────────────────┤
│                                          │
│          bestehende RealityView          │
│                                          │
│ Monster greifen und auf ein Ziel ziehen │  InteractionHintView
└──────────────────────────────────────────┘

[i] öffnet CompactTicketInfoView als Overlay
```

Die obere Leiste ist nicht interaktiv, mit Ausnahme des Info-Buttons. Ticketinfo und Anweisung sind SwiftUI-Schichten; Monster, Panels, Drag-Grenzen und Drop-Auswertung bleiben unverändert in RealityKit.

## Empfohlene Umsetzungsreihenfolge

### Schnellpaket mit maximalem Nutzen

1. `CompactTicketInfoView` in beiden Zuweisungsphasen
2. `SessionHUDView` mit Ticketfortschritt und Phasentitel
3. `InteractionHintView` mit kurzer Drag-Anweisung
4. Plus-/Minus-Buttons auf der Startansicht

Diese vier Änderungen benötigen keine Mutation der Spiellogik und sollten zuerst umgesetzt und gemeinsam im Simulator geprüft werden.

### Zweites Paket

5. Visuelle Monsterreaktion während des vorhandenen Feedbackfensters
6. Wiederholen-Aktion für Monster-Ladefehler
7. Kurze Startseiten-Erklärung beziehungsweise einklappbare Hilfe

## Bewusst nicht als schnelle Änderung empfohlen

Folgende Elemente der ursprünglichen Skizzen wären interessante spätere Produktideen, sind aber keine kleinen, risikoarmen UI-Verbesserungen:

- **Raumgroße begehbare Teamstationen:** widersprechen der aktuellen kompakten Ein-Volume-Geometrie und erfordern ein neues Layout-, Reichweiten- und Gerätetestkonzept.
- **Roboter-Begleitfigur:** benötigt zusätzliches 3D-Asset, Animationen, Dialogzustand, Platzierung und Kollisionsregeln.
- **Learning Mode und Challenge Mode:** benötigen neue Sitzungsmodi, Regeln, UI-Zustände und Testmatrizen.
- **Timer und Streak-System:** verändern Spielgefühl, Modellzustand, Reset, Scoringdarstellung und möglicherweise Barrierefreiheit. Als reines HUD wären sie irreführend, solange keine fachliche Logik dahintersteht.
- **Dauerhafte Punktanzeige während der Sitzung:** widerspricht möglicherweise der bewussten Reduktion auf eine Endpunktzahl und sollte erst nach einer Produktentscheidung ergänzt werden.
- **Vollständige Sidepanels mit SLA, Timeline und Kategorieprognose:** Die aktuellen Ticketdaten enthalten diese Felder nicht. Ihre Einführung wäre eine Domänen- und Datenmodellerweiterung, keine reine UI-Änderung.
- **Detailstatistik im Ergebnis:** durch die bestehende Spezifikation ausdrücklich ausgeschlossen.

## Abnahmecheck für die vorgeschlagenen Änderungen

Nach der Umsetzung sollte mindestens geprüft werden:

- Ticketinfo zeigt immer exakt `model.currentTicket` und niemals Referenzpriorität oder Referenzteam.
- Info-Overlay verdeckt keine notwendigen Inhalte dauerhaft und löst keine Drag-Geste aus.
- Drag funktioniert nach Öffnen und Schließen der Ticketinfo unverändert.
- HUD zeigt bei 1, 6 und 12 Tickets korrekte Werte ohne Indexüberlauf.
- Hinweise und HUD bleiben in der vorgesehenen Betrachtungsdistanz lesbar.
- Plus-/Minus-Buttons bleiben im Bereich 1 bis 12 und synchron zum Slider.
- Visuelles Feedback verändert Score und Exactly-once-Verhalten nicht.
- Während der 1,5 Sekunden bleibt die Eingabe gesperrt und genau ein Übergang erfolgt.
- Retry erzeugt keine doppelten Monster oder Zielpanels.
- Alle neuen sichtbaren Texte sind im String Catalog lokalisiert.
- Vollständige Swift-Testing-Suite bleibt grün.
- Simulatorlauf: Start → Untersuchung → Priorisierung → Team → nächstes Ticket → Ergebnis → Reset.
