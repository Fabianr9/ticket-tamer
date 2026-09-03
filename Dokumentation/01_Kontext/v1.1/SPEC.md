# SPECs — Ticket Tamer

> **Funktion.** Übersetzt die Vision in umsetzbare, prüfbare Anforderungen und schneidet daraus die Module.
> Lebendes Dokument — Änderungen bewusst treffen und im Projektlogbuch vermerken.

## 1. Funktionale Anforderungen

Je eine testbare Aussage. Referenzierbar über `F-xx`.

| ID | Anforderung | Priorität (Muss/Kann) |
|---|---|---|
| F-01 | Das System zeigt beim App-Start eine deutsche Startansicht mit Projekttitel, einem ganzzahligen Regler von 1 bis 12 Tickets, dem Standardwert 6 und der Schaltfläche „Spiel starten“. | Muss |
| F-02 | Das System enthält genau 12 lokal definierte Tickets. Der Ticketpool deckt jede Kombination aus den Prioritäten Normal, Wichtig und Kritisch sowie den Teams Netzwerk, Konto, Software und Hardware genau einmal ab. | Muss |
| F-03 | Jedes Ticket enthält mindestens Ticketnummer, Titel, Kurzbeschreibung, User Impact, ein bis drei Symptome oder Hinweise, eine Referenzpriorität und ein Referenzteam. | Muss |
| F-04 | Beim Start einer Sitzung wählt das System entsprechend der Reglereinstellung zufällige Tickets ohne Wiederholung aus dem lokalen Ticketpool aus. | Muss |
| F-05 | Das System führt die Sitzung in genau einem zentralen Volume als lineare Zustandsfolge aus: Startansicht, Untersuchen, Priorisieren, Team zuordnen, nächstes Ticket und Ergebnis. | Muss |
| F-06 | In der Untersuchungsphase zeigt das System ein Ticket-Monster und eine gut lesbare Ticketkarte mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptomen beziehungsweise Hinweisen an. | Muss |
| F-07 | Die Untersuchungsphase enthält die Schaltfläche „Weiter zur Priorisierung“, die zur Priorisierungsphase desselben Tickets wechselt. | Muss |
| F-08 | In der Priorisierungsphase kann die nutzende Person das Monster mit Blickfokus, Pinch und Drag auf genau eines der beschrifteten Ziele Normal, Wichtig oder Kritisch bewegen und dort ablegen. | Muss |
| F-09 | In der Teamzuordnungsphase kann die nutzende Person das Monster mit Blickfokus, Pinch und Drag auf genau eine der beschrifteten Stationen Netzwerk, Konto, Software oder Hardware bewegen und dort ablegen. | Muss |
| F-10 | Ein Loslassen außerhalb eines gültigen Ziels verändert den Sitzungszustand nicht. Ein gültiges Ablegen speichert die Entscheidung genau einmal und sperrt weitere Eingaben bis zum Zustandswechsel. | Muss |
| F-11 | Das System vergibt für eine richtige Priorität 100 Punkte und für ein richtiges Team 100 Punkte. Eine falsche Entscheidung vergibt 0 Punkte und zieht keine Punkte ab. | Muss |
| F-12 | Das System spielt nach jeder gültigen Entscheidung sofort einen von zwei unterschiedlichen lokalen Sounds ab: einen Erfolgssound bei einer richtigen Entscheidung und einen Fehlersound bei einer falschen Entscheidung. | Muss |
| F-13 | Das System zeigt nach einer Entscheidung weder die richtige Lösung noch eine textliche Begründung an und wechselt nach ungefähr 1,5 Sekunden automatisch zum nächsten Schritt. | Muss |
| F-14 | Das System bindet vier eigene, lokal mitgelieferte Blender-Monster als RealityKit-kompatible 3D-Assets ein. Die Modellwahl darf keinen eindeutigen Rückschluss auf Referenzteam oder Referenzpriorität zulassen. | Muss |
| F-15 | Nach der Bearbeitung aller ausgewählten Tickets zeigt das System ausschließlich die erreichte Gesamtpunktzahl als Zahl und die Schaltfläche „Erneut spielen“ an. | Muss |
| F-16 | „Erneut spielen“ führt zur Startansicht zurück, verwirft den bisherigen Sitzungszustand und setzt den Regler wieder auf 6 Tickets. | Muss |
| F-17 | Das System kann in einer späteren Erweiterung optional zusätzliche Monster-Gesichts- oder Bewegungsreaktionen darstellen. Diese Funktion ist nicht erforderlich für den Pflichtumfang von v1.1. | Kann |
| F-18 | Das System zeigt in Untersuchungs-, Priorisierungs- und Teamzuordnungsphase dauerhaft ein kompaktes Sitzungs-HUD mit „Ticket X von Y“, einem zur Phase passenden Titel und einem linearen Fortschrittsbalken. Das HUD enthält keinen Score. | Muss |
| F-19 | Das System bietet in Priorisierungs- und Teamzuordnungsphase einen Info-Button, der eine kompakte Ticketübersicht mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptomen beziehungsweise Hinweisen öffnet, ohne Referenzpriorität oder Referenzteam anzuzeigen. | Muss |
| F-20 | Das System zeigt in den beiden Zuweisungsphasen dauerhaft einen nicht interaktiven Hinweis zur benötigten Drag-Geste: „Monster greifen und auf eine Priorität ziehen.“ beziehungsweise „Monster greifen und dem zuständigen Team zuordnen.“ | Muss |
| F-21 | Das System zeigt während des bestehenden Feedbackfensters zusätzlich zum Sound bei einer richtigen Entscheidung einen grünen Haken mit „+100 Punkte“ und bei einer falschen Entscheidung ein rotes Kreuz ohne Punktetext. | Muss |
| F-22 | Die Startansicht ergänzt den vorhandenen Ticketanzahl-Slider um einen Minus- und einen Plus-Button, die die Auswahl jeweils um genau ein Ticket verändern, an den Grenzen 1 beziehungsweise 12 deaktiviert sind und mit Slider und Zahlenanzeige synchron bleiben. | Muss |
| F-23 | Bei einem Monster-Ladefehler zeigt das System in Untersuchung, Priorisierung und Teamzuordnung die Aktion „Erneut laden“. Ein Wiederholungsversuch lädt ausschließlich das aktuelle Monster neu und verändert weder fachlichen Sitzungszustand noch Score oder bereits aufgebaute Zielpanels. | Muss |
| F-24 | Die Startansicht zeigt unter dem Titel die Kurzbeschreibung „Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.“ und führt keine zusätzliche Tutorial- oder Popover-Logik ein. | Muss |

## 2. Nicht-funktionale Anforderungen

- **Performance:** Zustandswechsel, HUD-Aktualisierung, Overlays und das Laden des nächsten lokal gespeicherten Tickets dürfen keine sichtbare Blockierung der UI verursachen. Ein regulärer Zustandswechsel soll spätestens nach 2 Sekunden abgeschlossen sein.
- **Barrierefreiheit:** Tickettexte, HUD, Hinweise, Feedback-Symbole und Bedienelemente müssen in der vorgesehenen Betrachtungsdistanz gut lesbar sein. Minus-/Plus-Buttons, Info-Button, Schließen-Button und Retry erhalten verständliche Accessibility-Labels.
- **Stabilität:** Sitzungen mit 1 bis 12 Tickets müssen vollständig durchspielbar sein. Neue Overlays dürfen keine Doppelwertung, doppelten Phasenwechsel, Positionsdrift oder doppelte Zielpanels verursachen.
- **Bedienbarkeit:** Der Kernablauf muss ohne separate Spielanleitung verständlich sein. Die aktuelle Phase, der Sitzungsfortschritt und die benötigte Drag-Handlung sind während der Sitzung sichtbar.
- **Fehlertoleranz:** Ein temporärer Monster-Ladefehler darf keine Sackgasse erzeugen. Ein Wiederholungsversuch muss möglich sein, ohne die Sitzung neu zu starten.
- **Datenschutz:** Es werden keine personenbezogenen Daten, Benutzerkonten oder externen Verbindungen verwendet.
- **Wartbarkeit:** `SessionModel` bleibt die einzige Quelle für fachlichen Sitzungszustand. Neue v1.1-Darstellungszustände wie geöffnetes Ticketinfo-Overlay oder Feedback-Ergebnis bleiben lokal in der jeweiligen View.
- **Lokalisierung:** Alle neuen sichtbaren Texte und Accessibility-Texte werden im vorhandenen String Catalog gepflegt.
- **Gerätekompatibilität:** Das Projekt muss für visionOS 26.5 kompilieren und im visionOS-Simulator sowie auf einer verfügbaren Apple Vision Pro lauffähig sein.

## 3. Architektur-Skizze

Die v1.1-Erweiterung bleibt vollständig innerhalb der bestehenden Architektur. `SessionModel` bleibt die einzige Source of Truth für den fachlichen Spielzustand. Die neuen Komponenten lesen vorhandene Werte und führen nur lokalen Darstellungszustand ein.

```text
[StartView]
   |-- Kurzbeschreibung
   |-- Slider + Minus/Plus
   |-- Spiel starten
   v
[SessionModel / GameState]
   |-- Ticketkatalog / Auswahl / Score / Phase / Exactly-once
   |
   +----------------------+------------------------+
   |                      |                        |
   v                      v                        v
[InvestigationView] [PrioritizationView]   [TeamAssignmentView]
   |                  |         |              |         |
   |                  |         |              |         |
   +--> SessionHUD <--+         +--------------+         |
                      |                                  |
                      +--> InteractionHintView <---------+
                      |
                      +--> Info-Button --> CompactTicketInfoView
                      |
                      +--> FeedbackOverlay (lokaler Bool?-State)
                      |
                      +--> RealityView / Drag & Drop / Zielpanels

Monster-Ladefehler in allen drei Phasen
        |
        +--> „Erneut laden“ --> nur aktuelles Monster neu laden

[ResultView]
   |-- nur Scorezahl
   +-- „Erneut spielen“ --> Reset --> StartView
```

[Vereinfachungsentscheidung] Es werden keine neuen Fenster, Volumes, Navigationspfade, Persistenzschichten oder Modelzustände eingeführt, wenn die Funktion rein lokal in einer View abbildbar ist.

## 4. Datenmodell / Zustand

### Bestehendes Ticketmodell

```text
Ticket
- id: String
- ticketNumber: String
- title: String
- shortDescription: String
- userImpact: String
- symptoms: [String]
- referencePriority: TicketPriority
- referenceTeam: SupportTeam
- monsterAssetId: String
```

### Bestehende Enumerationen

```text
TicketPriority
- normal
- wichtig
- kritisch

SupportTeam
- netzwerk
- konto
- software
- hardware

GamePhase
- start
- untersuchen
- priorisieren
- teamZuordnen
- ergebnis
```

### Bestehender Sitzungszustand

```text
SessionModel
- selectedTicketCount: Int        // 1 bis 12, Standard 6
- sessionTickets: [Ticket]
- currentTicketIndex: Int
- currentPhase: GamePhase
- score: Int
- selectedPriority: TicketPriority?
- selectedTeam: SupportTeam?
- isInputLocked: Bool
```

### Neue v1.1-Darstellungszustände

Diese Zustände gehören ausdrücklich **nicht** in `SessionModel`:

```text
PrioritizationView / TeamAssignmentView
- isTicketInfoPresented: Bool
- feedbackResult: Bool?

Monster-Ladeansichten
- loadError: Error?
- lokaler Lade-/Retry-Zustand nach bestehendem Muster
```

`SessionHUDView` und `InteractionHintView` erhalten nur Werte und besitzen keinen fachlichen Zustand.

### HUD-Berechnung

```text
currentTicketNumber = currentTicketIndex + 1
totalTicketCount = sessionTickets.count
progress = currentTicketNumber / totalTicketCount
```

Der Fortschrittswert bleibt während Untersuchung, Priorisierung und Teamzuordnung desselben Tickets identisch und erhöht sich erst mit dem nächsten Ticket.

### Bewertungs- und Feedbackregeln

- Richtige Priorität: `+100`
- Falsche Priorität: `+0`
- Richtiges Team: `+100`
- Falsches Team: `+0`
- Richtige Entscheidung: bestehender Erfolgssound + grüner Haken + `+100 Punkte`
- Falsche Entscheidung: bestehender Fehlersound + rotes Kreuz
- Keine Anzeige von `+0 Punkte`
- Keine Anzeige der richtigen Lösung oder Begründung
- Feedbackdauer: vorhandenes Fenster von ungefähr 1,5 Sekunden
- Score bleibt während der Sitzung außerhalb des Feedback-Overlays verborgen

### Ticketinfo-Regeln

Die kompakte Ticketinfo darf ausschließlich enthalten:

- Ticketnummer
- Titel
- Kurzbeschreibung
- User Impact
- Symptome beziehungsweise Hinweise

Nicht zulässig:

- Referenzpriorität
- Referenzteam
- interne Bewertungsdaten
- richtige Lösung
- Lösungshinweise

Während das Overlay geöffnet ist, nimmt die verdeckte 3D-Szene keine Drag-Eingaben an.

## 5. Modul-Landkarte

Der Bauplan in Modulen. Die Module 001 bis 014 bilden den abgeschlossenen v1.0-Kern; v1.1 setzt ab Modul 015 fort.

| Modul | Titel | Leistet | Erfüllt | Hängt ab von |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | visionOS-Projekt, App-Einstieg, zentrales Volume und Grundrouting | F-05 | – |
| 002 | Ticketdatenmodell und lokaler Katalog | Datentypen, Enumerationen und 12 lokale Tickets | F-02, F-03 | 001 |
| 003 | Sitzungsmodell und Zufallsauswahl | Sitzungszustand, Auswahl ohne Wiederholung, Index, Score und Reset | F-04, F-16 | 002 |
| 004 | Startansicht v1.0 | Projekttitel, Slider 1 bis 12, Standardwert 6 und „Spiel starten“ | F-01 | 003 |
| 005 | Monster-Asset-Pipeline | Vier eigene Monster lokal einbinden und neutral zuordnen | F-14 | 001, 002 |
| 006 | Untersuchungsphase | Ticketkarte, Monsterdarstellung und Wechsel zur Priorisierung | F-06, F-07 | 002, 003, 005 |
| 007 | Räumliche Interaktionsgrundlagen | Blickfokus, Pinch, Drag, Drop-Bounds, Snapback und Eingabesperre | F-10 | 001, 005 |
| 008 | Priorisierungsphase | Drei Prioritätsziele und Speichern der Prioritätsentscheidung | F-08 | 003, 006, 007 |
| 009 | Teamzuordnungsphase | Vier Teamziele und Speichern der Teamentscheidung | F-09 | 003, 007, 008 |
| 010 | Bewertung und Audiofeedback | Punkte, Sounds, Exactly-once und 1,5-s-Übergänge | F-11, F-12, F-13 | 003, 008, 009 |
| 011 | Ergebnis und Neustart | Nur Gesamtpunktzahl und „Erneut spielen“; vollständiger Reset | F-15, F-16 | 003, 010 |
| 012 | Optionale Monsterreaktion | Historischer Kann-Baustein für zusätzliche Monsteranimation | F-17 | 005, 010 |
| 013 | Integration und Gerätetest v1.0 | Gesamtablauf, Geometrie, Stabilität und Regressionen prüfen | F-01 bis F-16 | 001 bis 011 |
| 014 | Doku & Cleanup v1.0 | Projektstand bereinigen, dokumentieren und v1.0 abschließen | – | 001 bis 013 |
| 015 | Session-HUD und Interaktionshinweise | Wiederverwendbares HUD mit Ticketfortschritt, Phasentitel, ProgressView und dauerhafte Drag-Hinweise ergänzen | F-18, F-20 | 006, 008, 009 |
| 016 | Kompakte Ticketinfo | `CompactTicketInfoView`, Info-Button, Schließen und Eingabesperre in den Entscheidungsphasen ergänzen | F-19 | 002, 008, 009, 015 |
| 017 | Startseiten-Usability | Kurzbeschreibung sowie Minus-/Plus-Buttons synchron zum bestehenden Slider ergänzen | F-22, F-24 | 003, 004 |
| 018 | Visuelles Entscheidungsfeedback | Grüner Haken + `+100 Punkte` beziehungsweise rotes Kreuz innerhalb des vorhandenen Feedbackfensters ergänzen | F-21 | 010 |
| 019 | Ladefehler-Recovery | „Erneut laden“ in allen Monsterphasen ergänzen und Monsterladeoperationen retry-fähig kapseln | F-23 | 005, 006, 008, 009 |
| 020 | Integration und Abnahme v1.1 | Neue UI-Komponenten gemeinsam prüfen, vollständige Test-Suite und Simulator-/Geräteregression durchführen | F-18 bis F-24 | 015 bis 019 |

## 6. Technische Constraints

- Zielplattform ist Apple Vision Pro mit visionOS Deployment Target 26.5.
- Das Projekt wird mit Xcode 26.5 und dem bestehenden Swift-/SwiftUI-/RealityKit-Stack fortgeführt.
- Das App-Target verwendet den vorhandenen `SessionModel` als einzige fachliche Source of Truth.
- Neue v1.1-UI-Zustände dürfen `SessionModel` nicht duplizieren oder eine zweite Sitzungszustandsmaschine bilden.
- Neue wiederverwendbare SwiftUI-Komponenten werden unter `Views/Components` abgelegt.
- Sichtbare neue Texte und Accessibility-Texte werden in `Localizable.xcstrings` gepflegt.
- `SessionHUDView` und `InteractionHintView` dürfen Drag-Interaktionen nicht blockieren; nicht interaktive Overlays verwenden `.allowsHitTesting(false)`.
- Bei geöffnetem `CompactTicketInfoView` wird die verdeckte Drag-Interaktion bewusst deaktiviert.
- `CompactTicketInfoView` liest ausschließlich aus `model.currentTicket` und zeigt keine Referenzwerte.
- Der Info-Zustand ist view-lokal und wird beim Phasenwechsel zurückgesetzt.
- Das visuelle Feedback nutzt nur das bereits vorhandene Bool-Ergebnis der Bewertung und verändert keine Punktelogik.
- Die vorhandene Eingabesperre, Exactly-once-Semantik und der 1,5-Sekunden-Übergang bleiben unverändert.
- Der Retry lädt nur das aktuelle Monster neu. Bereits erstellte Zielpanels dürfen nicht erneut angelegt werden.
- Änderungen an DragBounds, 50-%-Drop-Regel, Z-Toleranz, Snapback, Scoring und Asset-Mapping sind nicht Teil von v1.1.
- Alle Ticketdaten und Assets bleiben lokal; es werden keine neuen externen Abhängigkeiten eingeführt.
- Die Ergebnisansicht bleibt unverändert auf Scorezahl und „Erneut spielen“ beschränkt.
- [Annahme] AK-06 und alle übrigen Pflicht-AKs der v1.0-Basis gelten für diese Weiterentwicklungsplanung als abgeschlossen.

## 7. Offene Fragen

- [Offen] Das finale visuelle Styling von `SessionHUDView`, ProgressView, Info-Button und Feedback-Overlay wird während der Umsetzung innerhalb der festgelegten funktionalen Grenzen bestimmt.
- [Offen] Die konkrete Größe und Position des kompakten Ticketinfo-Panels muss im visionOS-Simulator und auf der Apple Vision Pro so abgestimmt werden, dass Monster und Ziele nicht dauerhaft verdeckt werden.
- [Offen] Die konkrete SF-Symbol- beziehungsweise Custom-Symbol-Darstellung für den grünen Haken und das rote Kreuz wird in der Umsetzung festgelegt; Bedeutung, Farbe und Textumfang sind bereits fest definiert.
