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
| F-17 | Das System kann nach einer Entscheidung optional einen fröhlichen oder traurigen Gesichtsausdruck beziehungsweise eine kurze Monsteranimation zeigen. | Kann |

## 2. Nicht-funktionale Anforderungen

- **Performance:** Zustandswechsel und das Laden des nächsten lokal gespeicherten Tickets sollen auf der Zielhardware ohne sichtbare Blockierung erfolgen. Ein regulärer Wechsel soll spätestens nach 2 Sekunden abgeschlossen sein.
- **Barrierefreiheit:** Alle Tickettexte, Zielbeschriftungen und Schaltflächen müssen in der vorgesehenen Betrachtungsdistanz gut lesbar sein. Ziele müssen groß genug sein, um ohne feinmotorisch präzises Ablegen getroffen zu werden.
- **Stabilität:** Eine Sitzung mit 1 bis 12 Tickets muss vollständig durchspielbar sein. Wiederholtes Zurückkehren zur Startansicht darf weder zu einem Absturz noch zu einer fehlerhaften Punkteübernahme führen.
- **Bedienbarkeit:** Der Kernablauf muss ohne separate Spielanleitung anhand der sichtbaren Beschriftungen und der üblichen visionOS-Interaktionen verständlich sein.
- **Datenschutz:** Es werden keine personenbezogenen Daten, Benutzerkonten oder externen Verbindungen verwendet.
- **Wartbarkeit:** Ticketdaten, Sitzungslogik, Punktelogik, View-Zustände, Audiofeedback und 3D-Assets sollen in getrennten Verantwortungsbereichen organisiert sein.
- **Sprache:** Alle sichtbaren Texte der Anwendung sind auf Deutsch.
- **Gerätekompatibilität:** Das Projekt muss mit Xcode 26.5 für visionOS 26 kompilieren und auf einer verfügbaren Apple Vision Pro lauffähig sein.

## 3. Architektur-Skizze

Die Anwendung verwendet ein zentrales Sitzungsmodell als einzige Quelle für den aktuellen Spielzustand. SwiftUI stellt Start-, Ticket- und Ergebnisinformationen dar. RealityKit enthält Monster, Prioritätsziele und Teamstationen innerhalb eines einzigen Volumes. Interaktionsereignisse werden an das Sitzungsmodell weitergegeben; das Modell bewertet Entscheidungen, aktualisiert die Punkte und steuert den nächsten Zustand.

```text
[Start-/Settings-View]
        |
        | Ticketanzahl + Start
        v
[SessionModel / GameState]
        |-- lädt --> [lokaler Ticketkatalog]
        |-- verwaltet --> aktuelle Sitzung, Index, Score, Eingabesperre
        |-- steuert --> Phase: inspect | prioritize | route | result
        |
        +--------------------+-----------------------+
        |                    |                       |
        v                    v                       v
[SwiftUI-Ticketkarte]  [RealityKit-Volume]      [AudioService]
                         |       |                    |
                         |       +--> Teamstationen   +--> richtig.wav
                         +----------> Prioritätsziele +--> falsch.wav
                         +----------> Monster-Assets
        |
        v
[Ergebnis-View] -- „Erneut spielen“ --> [Reset auf Startansicht]
```

[Vereinfachungsentscheidung] Es wird kein zweites Volume, kein Immersive Space, kein Backend und keine persistente Datenbank verwendet.

## 4. Datenmodell / Zustand

### Ticket

```text
Ticket
- id: String
- ticketNumber: String
- title: String
- shortDescription: String
- userImpact: String
- symptoms: [String]          // 1 bis 3 Einträge
- referencePriority: Priority
- referenceTeam: SupportTeam
- monsterAssetId: String
```

### Enumerationen

```text
Priority
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
- inspect
- prioritize
- route
- result
```

### Sitzungszustand

```text
SessionState
- selectedTicketCount: Int    // 1 bis 12, Standardwert 6
- sessionTickets: [Ticket]    // zufällig, ohne Wiederholung
- currentTicketIndex: Int
- currentPhase: GamePhase
- score: Int
- selectedPriority: Priority?
- selectedTeam: SupportTeam?
- isInputLocked: Bool
```

### Bewertungsregeln

- Richtige Priorität: `+100`
- Falsche Priorität: `+0`
- Richtiges Team: `+100`
- Falsches Team: `+0`
- Maximalpunktzahl: `Anzahl der Tickets × 200`
- Kein Punktabzug
- Keine Anzeige der Punkte während der Sitzung
- Keine dauerhafte Speicherung nach App-Ende

### Ticketverteilung

Der lokale Katalog enthält genau zwölf Tickets. Jede Kombination aus einem Support-Team und einer Prioritätsstufe kommt genau einmal vor.

| Team | Normal | Wichtig | Kritisch |
|---|---:|---:|---:|
| Netzwerk | 1 | 1 | 1 |
| Konto | 1 | 1 | 1 |
| Software | 1 | 1 | 1 |
| Hardware | 1 | 1 | 1 |

### 3D-Zustand

- Vier lokal mitgelieferte Monster-Assets
- Export vorzugsweise als USDZ
- Zuordnung der Modelle zu Tickets unabhängig von Referenzteam und Referenzpriorität
- Interaktionskomponenten für Fokussieren, Greifen, Ziehen und Ablegen
- Kollisions- beziehungsweise Zielbereiche für drei Prioritätsziele und vier Teamstationen
- [Kann] Zusätzlicher Zustand für fröhlichen oder traurigen Gesichtsausdruck

## 5. Modul-Landkarte

Der Bauplan in Modulen. Die Spalte „Entwicklungsreihenfolge“ ist verbindlich; spätere Module dürfen parallel vorbereitet werden, sobald ihre Abhängigkeiten erfüllt sind.

| Modul | Titel | Aufgabe / Leistet | Erfüllt | Hängt ab von | Entwicklungsreihenfolge |
|---|---|---|---|---|---:|
| 001 | Projektgrundgerüst und zentrales Volume | visionOS-Projekt, App-Einstieg, ein zentrales Volume, Grundnavigation und GitHub-Struktur einrichten | F-05 | – | 1 |
| 002 | Ticketdatenmodell und lokaler Katalog | Datentypen, Enumerationen und genau 12 lokale Tickets mit vollständigen Referenzwerten bereitstellen | F-02, F-03 | 001 | 2 |
| 003 | Sitzungsmodell und Zufallsauswahl | Sitzungszustand, Ticketanzahl, zufällige Auswahl ohne Wiederholung, Index und Reset implementieren | F-04, F-16 | 002 | 3 |
| 004 | Startansicht und Einstellungen | Titel, Regler 1 bis 12, Standardwert 6 und „Spiel starten“ umsetzen | F-01 | 003 | 4 |
| 005 | Monster-Asset-Pipeline | Vier eigene Blender-Modelle exportieren, lokal einbinden und modellunabhängig den Tickets zuordnen | F-14 | 001, 002 | 5 |
| 006 | Untersuchungsphase | Ticket-Monster, Ticketkarte und „Weiter zur Priorisierung“ darstellen | F-06, F-07 | 002, 003, 005 | 6 |
| 007 | Räumliche Interaktionsgrundlagen | Blickfokus, Pinch, Drag, gültige Zielbereiche, ungültiges Ablegen und Eingabesperre bereitstellen | F-10 | 001, 005 | 7 |
| 008 | Priorisierungsphase | Drei beschriftete Prioritätsziele, Ablegen und Speichern der gewählten Priorität umsetzen | F-08 | 003, 006, 007 | 8 |
| 009 | Teamzuordnungsphase | Vier beschriftete Teamstationen, Ablegen und Speichern des gewählten Teams umsetzen | F-09 | 003, 007, 008 | 9 |
| 010 | Bewertung und Audiofeedback | Punkte berechnen, zwei lokale Sounds abspielen, Lösungstext verhindern und automatischen Übergang steuern | F-11, F-12, F-13 | 003, 008, 009 | 10 |
| 011 | Ergebnis und Neustart | Nur Gesamtpunktzahl und „Erneut spielen“ anzeigen; vollständigen Reset auf Startansicht ausführen | F-15, F-16 | 003, 010 | 11 |
| 012 | Optionale Monsterreaktion | Fröhlichen oder traurigen Gesichtsausdruck beziehungsweise kurze Animation ergänzen, ohne den Kernablauf zu verändern | F-17 | 005, 010 | 12 |
| 013 | Integration und Gerätetest | Gesamtablauf mit 1, 6 und 12 Tickets im Simulator und auf Apple Vision Pro prüfen und Fehler beheben | F-01 bis F-16 | 001 bis 011 | 13 |
| 014 | Abschlussmodul: Doku & Cleanup | Projektstruktur bereinigen, Dokumente abgleichen, Quellen und Assets dokumentieren, Abgabe vorbereiten | – | alle Muss-Module | 14 |

## 6. Technische Constraints

- Zielplattform ist visionOS 26; das Projekt wird mit Xcode 26.5 erstellt.
- Verwendete Programmiersprachen und Frameworks sind Swift, SwiftUI und RealityKit.
- Die Anwendung verwendet genau ein zentrales Volume und keinen vollständigen Immersive Space.
- Die Benutzeroberfläche und alle Tickettexte sind auf Deutsch.
- Priorisierung und Teamzuordnung erfolgen ausschließlich über Blickfokus, Pinch und Drag.
- Es werden keine Controller, keine Spracheingabe und keine alternative 2D-Auswahl für die beiden Kernentscheidungen implementiert.
- Alle Ticketdaten liegen lokal und statisch in der App.
- Es werden keine Benutzerkonten, keine Datenbank, keine Cloud und keine externe API verwendet.
- Sitzungsdaten werden nur im Arbeitsspeicher gehalten.
- Vier eigene Monster-Modelle werden lokal mitgeliefert und vorzugsweise als USDZ eingebunden.
- Die Monster dürfen die richtige Priorität oder das richtige Team nicht visuell verraten.
- Zwei lokale Audiodateien signalisieren richtige und falsche Entscheidungen.
- Die App zeigt weder während der Sitzung noch im Ergebnis Detailstatistiken an.
- Die Ergebnisansicht enthält nur die Gesamtpunktzahl als Zahl und „Erneut spielen“.
- Änderungen an Anforderungen oder Umfang werden im späteren Projektlogbuch dokumentiert.
- [Annahme] Das Team verfügt bis zur Abgabe weiterhin über Zugriff auf mindestens eine Apple Vision Pro für Integrations- und Abnahmetests.
- [Annahme] Die verwendeten Audio- und 3D-Assets sind selbst erstellt oder rechtlich für die Abgabe nutzbar.

## 7. Offene Fragen

- [Offen] Die konkreten Inhalte und Formulierungen der zwölf Tickets müssen noch erstellt und fachlich auf Eindeutigkeit geprüft werden.
- [Offen] Die finalen Namen, visuellen Stile und Polygonbudgets der vier Blender-Monster sind noch festzulegen.
- [Offen] Die konkreten Sounddateien und ihre Lautstärke müssen noch ausgewählt und auf der Apple Vision Pro getestet werden.
- [Offen] Es ist noch zu entscheiden, ob F-17 innerhalb des Zeitbudgets umgesetzt wird; die Abgabe ist auch ohne diese Kann-Funktion vollständig.
