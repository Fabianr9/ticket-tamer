# Replay-UI-Skalierungsfehler – Codeanalyse

Stand: 03.09.2026  
Untersuchter Ablauf: erfolgreicher Spieldurchlauf → Ergebnisansicht → **„Erneut spielen“** → neuer Durchlauf

## Ergebnis

Nach statischer Analyse ist **nicht sichergestellt**, dass der zweite Durchlauf mit derselben sichtbaren Größe wie der erste Durchlauf erscheint.

Der fachliche Spielzustand wird korrekt zurückgesetzt. Für die Größe des volumetrischen Fensters und den von SwiftUI angebotenen Layoutraum gibt es dagegen keinen entsprechenden Reset beziehungsweise keine phasenübergreifend stabile Layout-Hülle. Das passt genau zum beobachteten Fehlerbild: Nach „Erneut spielen“ wird bereits die Startansicht schmaler dargestellt; die Prioritäts- und Team-Panels werden danach aus dieser kleineren Laufzeitgeometrie neu berechnet und sind ebenfalls kleiner.

Die wahrscheinlichste Ursache ist daher **nicht** eine akkumulierte CSS-/Canvas-Skalierung (das Projekt ist eine native SwiftUI-/RealityKit-App), sondern eine instabile Layout- beziehungsweise Volume-Proposal-Kette beim Austausch der phasenabhängigen Root-Views.

## Was nachweislich korrekt zurückgesetzt wird

`ResultView` ruft beim Button-Tap ausschließlich `model.reset()` auf. `SessionModel.reset()` setzt folgende fachlichen Werte zurück:

- Ticketanzahl auf 6
- Sitzungstickets auf leer
- Ticketindex auf 0
- Phase auf `.start`
- Score auf 0
- Prioritäts- und Teamauswahl auf `nil`
- Eingabesperre auf `false`
- beide internen Bewertungsflags auf `false`

`RootVolumeView` wertet anschließend `currentPhase` neu aus und ersetzt `ResultView` durch `StartView`. Ein alter Reglerwert oder ein unvollständiger fachlicher Reset erklärt den Darstellungsfehler deshalb nicht.

Auch die lokalen Zustände der Spielansichten sind kein plausibler gemeinsamer Auslöser: `PrioritizationView` und `TeamAssignmentView` besitzen ihre RealityKit-Entities, Messwerte und Feedbackzustände als lokales `@State`. Beim Verlassen des jeweiligen `switch`-Astes verschwindet die View; beim erneuten Eintritt wird sie neu aufgebaut. Eine alte Monster- oder Panel-Skalierung kann damit nicht den bereits vorher sichtbaren, geschrumpften Slider der neuen `StartView` verursachen.

## Wahrscheinlichste Ursache

### 1. `defaultSize` ist nur beim Erzeugen des Fensters wirksam

In `Ticket_TamerApp` wird das einzige `WindowGroup` als volumetrisch deklariert und über `.defaultSize(..., in: .meters)` initial dimensioniert. Beim Replay wird aber kein neues Fenster erzeugt; dasselbe Volume bleibt während der gesamten App-Laufzeit bestehen. Der Reset des Modells kann `.defaultSize` daher nicht erneut anwenden.

Es fehlt eine explizite, phasenübergreifende Größenstrategie, etwa eine feste Root-Hülle beziehungsweise eine geeignete Window-Resizability-Konfiguration. Somit ist die Startgröße beschrieben, aber nicht die Stabilität des angebotenen Layoutraums bei späteren Inhaltswechseln.

Relevante Stellen:

- `Ticket_Tamer/App/Ticket_TamerApp.swift`, Zeilen 45–57
- `Ticket_Tamer/Views/RootVolumeView.swift`, Zeilen 26–50

### 2. Die Root-Views melden stark unterschiedliche Idealgrößen

`RootVolumeView` gibt direkt den jeweiligen `switch`-Ast zurück. Es gibt um alle Phasen herum keinen gemeinsamen `GeometryReader3D`, keinen volumenfüllenden Container und keinen stabilen Mindest-/Idealrahmen.

Die Größencharakteristik wechselt daher deutlich:

- `StartView`: inhaltsgroße `VStack` mit Padding
- `ResultView`: besonders kleine `VStack`, nur Score und Button
- `PrioritizationView`/`TeamAssignmentView`: `GeometryReader3D` plus vollflächige `RealityView`
- `InvestigationView`: weitere flexible Geometry-/RealityView-Kombination

Die Ergebnisansicht ist der kleinste Ast. Wenn der bestehende volumetrische Fensterspace beziehungsweise seine SwiftUI-Proposal beim Wechsel auf diesen Inhalt kleiner wird oder klein weitergereicht wird, erhält die danach erzeugte `StartView` nicht wieder dieselben Rahmenbedingungen wie beim Cold Start.

Relevante Stellen:

- `Ticket_Tamer/Views/RootVolumeView.swift`, Zeilen 26–50
- `Ticket_Tamer/Views/ResultView.swift`, Zeilen 26–35
- `Ticket_Tamer/Views/StartView.swift`, Zeilen 31–122
- `Ticket_Tamer/Views/PrioritizationView.swift`, ab Zeile 142
- `Ticket_Tamer/Views/TeamAssignmentView.swift`, ab Zeile 145

### 3. Der Slider besitzt nur eine Maximal-, aber keine Ziel- oder Mindestbreite

Der Slider verwendet:

```swift
.frame(maxWidth: LayoutConstants.startSliderMaximumWidth)
```

Das begrenzt ihn lediglich nach oben auf 320 Punkte. Bei einem kleineren Proposal darf SwiftUI ihn stark zusammenschieben. Zusätzlich haben die beiden Buttons im selben `HStack` Mindestgrößen und Abstände; der flexible Slider trägt daher bevorzugt die Kompression. Das erklärt, warum der Slider besonders auffällig schrumpft und Text umbrechen beziehungsweise abgeschnitten wirken kann.

Relevante Stelle: `Ticket_Tamer/Views/StartView.swift`, Zeilen 54–92, besonders Zeile 76.

### 4. Die Panels übernehmen die kleinere Geometrie absichtlich

Prioritäts- und Teamansicht vermessen ihren aktuellen `GeometryReader3D`-Rahmen in jedem RealityView-Update. `TargetPanelLayout` berechnet Panelbreite, Panelhöhe und Positionen anschließend aus den gemessenen Volume-Grenzen. Das ist innerhalb einer stabilen Fenstergröße richtig, verstärkt aber den Replay-Fehler: Ist der angebotene/geometrisch umgerechnete Raum nach dem Neustart kleiner, werden die Panels korrekt nach dieser kleineren Messung erzeugt – und sehen damit gegenüber dem ersten Durchlauf geschrumpft aus.

Relevante Stellen:

- `Ticket_Tamer/Views/PrioritizationView.swift`, Zeilen 454–488
- `Ticket_Tamer/Views/TeamAssignmentView.swift`, Zeilen 422–453
- `Ticket_Tamer/Services/TargetPanelLayout.swift`, Methode `resolve(...)`

### 5. Asynchrone Messwertübernahme kann ein zusätzliches Timingproblem erzeugen

Beide Zuweisungsansichten messen innerhalb des RealityView-Callbacks und schreiben das Ergebnis anschließend über einen unstrukturierten `Task { @MainActor in ... }` in den lokalen Geometriezustand. Der Task wird weder gespeichert noch beim Verschwinden der View explizit abgebrochen. Das erklärt den geschrumpften Startbildschirm nicht, kann aber während schneller Phasenwechsel zusätzliche, schwer reproduzierbare Layoutupdates begünstigen.

Es gibt außerdem keinen UI-Test, der die tatsächlich angebotene Größe vor und nach dem Replay vergleicht. Die vielen Reset-Tests prüfen ausschließlich Werte in `SessionModel`.

## Weniger wahrscheinliche beziehungsweise ausgeschlossene Ursachen

- **Akkumulierende Zielskalierung:** Das 5-%-Highlight setzt den Scale der Ziel-Entity auf genau `1.05` oder `1.0`; es multipliziert nicht wiederholt. Außerdem werden Ziel-Entities beim erneuten Eintritt neu erstellt.
- **Alte RealityKit-Attachments:** Die Label-Attachments gehören zur jeweiligen `RealityView` und werden an neu erzeugte Panel-Roots gehängt. Sie erklären insbesondere nicht den kleineren Start-Slider.
- **Nicht zurückgesetzter Spielzustand:** `SessionModel.reset()` ist vollständig und wird durch mehrere Unit-Tests abgedeckt.
- **`ScaledToFitView`:** Der Startbildschirm und die normalen Panel-Labels verwenden diesen Container nicht. Er kann daher nicht die gemeinsame Ursache des beschriebenen Fehlers sein.
- **CSS, DOM, ResizeObserver oder `devicePixelRatio`:** Diese Mechanismen kommen im Projekt nicht vor.

## Empfohlene Behebung

1. Dem gesamten Phasenrouter eine einheitliche, volumenfüllende Root-Layoutfläche geben, sodass alle Phasen stets dasselbe Proposal erhalten. Die Stabilisierung gehört in `Ticket_TamerApp`/`RootVolumeView`, nicht in drei einzelne Unteransichten.
2. Die gewünschte Größenpolitik des volumetrischen Fensters explizit festlegen und nicht allein auf `.defaultSize` verlassen. Dabei gegen das tatsächlich verwendete visionOS-SDK prüfen, welche `windowResizability`-Variante für ein konstantes Volume passend ist.
3. `StartView` eine definierte Inhalts-/Sliderbreite innerhalb dieser stabilen Fläche geben. Eine reine `maxWidth`-Angabe garantiert keine Breite.
4. Optional die Volume-Messung zentralisieren und den Spielansichten als gemeinsames Ergebnis geben. So verwenden Priorisierung und Teamzuordnung garantiert dieselbe Messbasis.
5. Die unstrukturierten Mess-Tasks vermeiden oder an den View-Lifecycle binden.

## Notwendiger Regressionstest

Ein Unit-Test des Modells genügt nicht. Erforderlich ist mindestens ein manueller Simulator-/Gerätetest, besser ein UI-/Snapshot-Test mit diesem Ablauf:

1. Cold Start; Layoutbreite/-höhe von Root, Slider und Panels protokollieren.
2. Ein Ticket vollständig und erfolgreich durchspielen.
3. „Erneut spielen“ auslösen.
4. Dieselben Werte in der neuen Start-, Prioritäts- und Teamansicht erfassen.
5. Cold-Start- und Replay-Werte mit kleiner Toleranz vergleichen.
6. Den Ablauf mindestens fünfmal wiederholen, auch nach Änderung der Fensterplatzierung beziehungsweise zulässiger Fenstergröße.

Sinnvolle temporäre Diagnosewerte sind `GeometryProxy3D.frame(in: .local)`, die daraus konvertierte `BoundingBox`, die angebotene Breite der `StartView` und die berechnete `panelSize`. Der vorhandene `VolumeMetrics.debugSummary` kann für die Spielansichten bereits verwendet werden.

## Einschränkung der Analyse

Die Ursache ist durch den Code und das gemeldete phasenübergreifende Fehlerbild stark eingegrenzt, aber in dieser Linux-Arbeitsumgebung kann kein visionOS-Simulator gestartet werden. Ob das bestehende Volume selbst seine Größe ändert oder lediglich ein kleineres SwiftUI-Layout-Proposal innerhalb des Volumes weitergibt, muss mit den genannten Laufzeitmessungen unterschieden werden. Für die Behebung ist diese Unterscheidung zweitrangig: Eine stabile, gemeinsame Root-Layoutfläche und eine explizite Größenpolitik beseitigen beide Varianten.
