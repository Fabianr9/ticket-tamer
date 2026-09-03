# SPECs — Ticket Tamer

> **Funktion.** Übersetzt die Vision in umsetzbare, prüfbare Anforderungen und schneidet daraus die Module.
> Lebendes Dokument — Änderungen bewusst treffen und im Projektlogbuch vermerken.

## 1. Funktionale Anforderungen

Je eine testbare Aussage. Referenzierbar über `F-xx`.

**Versionshinweis:** Die IDs F-01 bis F-24 bilden den bereits abgeschlossenen Funktionsstand aus v1.0 und v1.1. Die v1.2-Anforderungen beginnen mit F-25. Wo v1.2 ein sichtbares Detail bewusst erweitert, gilt die spätere Anforderung zusätzlich beziehungsweise konkretisierend für den aktuellen Zielstand.

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
| F-14 | Das System bindet vier eigene, lokal mitgelieferte Blender-Monstertypen als RealityKit-kompatible 3D-Assets ein. Die Modellwahl darf keinen eindeutigen Rückschluss auf Referenzteam oder Referenzpriorität zulassen. | Muss |
| F-15 | Nach der Bearbeitung aller ausgewählten Tickets zeigt das System die erreichte Gesamtpunktzahl und die Schaltfläche „Erneut spielen“ an. | Muss |
| F-16 | „Erneut spielen“ führt zur Startansicht zurück, verwirft den bisherigen fachlichen Sitzungszustand und setzt den Regler wieder auf 6 Tickets. | Muss |
| F-17 | Das System kann in einer späteren Erweiterung optional zusätzliche Monster-Gesichts- oder Bewegungsreaktionen darstellen. Diese Funktion ist nicht erforderlich für den Pflichtumfang. | Kann |
| F-18 | Das System zeigt in Untersuchungs-, Priorisierungs- und Teamzuordnungsphase dauerhaft ein kompaktes Sitzungs-HUD mit „Ticket X von Y“, einem zur Phase passenden Titel und einem linearen Fortschrittsbalken. Das HUD enthält keinen Score. | Muss |
| F-19 | Das System bietet in Priorisierungs- und Teamzuordnungsphase einen Info-Button, der eine kompakte Ticketübersicht mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptomen beziehungsweise Hinweisen öffnet, ohne Referenzpriorität oder Referenzteam anzuzeigen. | Muss |
| F-20 | Das System zeigt in den beiden Zuweisungsphasen dauerhaft einen nicht interaktiven Hinweis zur benötigten Drag-Geste: „Monster greifen und auf eine Priorität ziehen.“ beziehungsweise „Monster greifen und dem zuständigen Team zuordnen.“ | Muss |
| F-21 | Das System zeigt während des bestehenden Feedbackfensters zusätzlich zum Sound bei einer richtigen Entscheidung einen grünen Haken mit „+100 Punkte“ und bei einer falschen Entscheidung ein rotes Kreuz. | Muss |
| F-22 | Die Startansicht ergänzt den vorhandenen Ticketanzahl-Slider um einen Minus- und einen Plus-Button, die die Auswahl jeweils um genau ein Ticket verändern, an den Grenzen 1 beziehungsweise 12 deaktiviert sind und mit Slider und Zahlenanzeige synchron bleiben. | Muss |
| F-23 | Bei einem Monster-Ladefehler zeigt das System in Untersuchung, Priorisierung und Teamzuordnung die Aktion „Erneut laden“. Ein Wiederholungsversuch lädt ausschließlich das aktuelle Monster neu und verändert weder fachlichen Sitzungszustand noch Score oder bereits aufgebaute Zielpanels. | Muss |
| F-24 | Die Startansicht zeigt unter dem Titel die Kurzbeschreibung „Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.“ und führt keine zusätzliche Tutorial- oder Popover-Logik ein. | Muss |
| F-25 | Das System hält beim Wechsel Ergebnis → „Erneut spielen“ die aktuell verwendete Volume- und Root-Layoutgröße stabil. Startansicht, Slider, Texte, Prioritätsziele und Teamziele dürfen allein durch Replay weder schrumpfen noch wachsen oder über mehrere Durchläufe kumulativ driften. | Muss |
| F-26 | Die Ergebnisansicht kennzeichnet die Gesamtpunktzahl sichtbar mit der Einheit „Punkte“, zum Beispiel „600 Punkte“, ohne weitere Ergebnisstatistiken einzuführen. | Muss |
| F-27 | Das visuelle Feedback einer falschen Prioritäts- oder Teamentscheidung zeigt zusätzlich zum roten Kreuz den Text „0 Punkte“. Richtige Entscheidungen zeigen weiterhin grünen Haken und „+100 Punkte“. | Muss |
| F-28 | Jede Teamstation zeigt zusätzlich zur bestehenden Textbezeichnung ein einfaches semantisch passendes Symbol. Der Text bleibt sichtbar und Farbe allein darf die Bedeutung nicht tragen. | Muss |
| F-29 | Die Entwicklungs-Schaltfläche `🔧 Team [DEV]` erscheint nicht im normalen App-Ablauf, auch nicht in einem regulären Debug-Build. Entwicklungszugriffe bleiben ausschließlich im separaten Debug-Harness beziehungsweise in explizit aktivierten Debug-Kontexten verfügbar. | Muss |
| F-30 | Das System kann alle 16 vorhandenen Monster-Farbvarianten laden. Für jedes Sitzungsticket wird beim Sitzungsstart eine Variante seines Monstertyps ausgewählt und für Untersuchung, Priorisierung, Teamzuordnung sowie Retry stabil beibehalten. Eine neue Sitzung darf neu auswählen; die Farbe codiert weder Priorität noch Team noch Richtigkeit. | Muss |

## 2. Nicht-funktionale Anforderungen

- **Performance:** Zustandswechsel, HUD-Aktualisierung, Overlays, Replay und das Laden des nächsten lokalen Monster-Assets dürfen keine sichtbare Blockierung der UI verursachen. Ein regulärer Zustandswechsel soll spätestens nach 2 Sekunden abgeschlossen sein.
- **Layout-Stabilität:** Ein Replay darf den angebotenen SwiftUI-/RealityKit-Layoutraum nicht kumulativ verändern. Die aktuelle Volume-Größe soll erhalten bleiben und alle Phasen müssen auf einer konsistenten Root-Layoutbasis aufgebaut werden.
- **Barrierefreiheit:** Tickettexte, HUD, Hinweise, Feedback-Symbole, Punkteangaben, Teamtexte und Teamsymbole müssen in der vorgesehenen Betrachtungsdistanz gut lesbar beziehungsweise erkennbar sein. Bedeutung darf nicht ausschließlich über Farbe vermittelt werden.
- **Stabilität:** Sitzungen mit 1 bis 12 Tickets müssen vollständig und mehrfach hintereinander durchspielbar sein. Mindestens fünf vollständige Replay-Zyklen dürfen weder Layoutdrift noch Doppelwertung, doppelte Zielpanels, Positionsdrift oder Zustandsübernahme verursachen.
- **Bedienbarkeit:** Der Kernablauf muss ohne separate Spielanleitung verständlich sein. Aktuelle Phase, Fortschritt, Drag-Handlung, Entscheidungsergebnis und Punktewirkung sind sichtbar beziehungsweise hörbar.
- **Fehlertoleranz:** Ein temporärer Monster-Ladefehler darf keine Sackgasse erzeugen. Retry muss dieselbe für das aktuelle Ticket ausgewählte Farbvariante erneut laden.
- **Datenschutz:** Es werden keine personenbezogenen Daten, Benutzerkonten oder externen Verbindungen verwendet.
- **Wartbarkeit:** `SessionModel` bleibt die einzige Quelle für fachlichen Sitzungszustand. Die Monster-Variantenauswahl wird zentral und deterministisch testbar verwaltet. Replay-Layoutstabilität wird zentral im Root-/Volume-Bereich gelöst, nicht durch unabhängige Sonderkorrekturen in mehreren Views.
- **Testbarkeit:** Die Auswahl der Monster-Farbvariante muss über eine injizierbare Auswahlfunktion deterministisch testbar sein. Replay-Stabilität benötigt zusätzlich zu Unit-Tests einen Simulator- oder Gerätetest mit realer Layoutmessung beziehungsweise visueller Gegenprüfung.
- **Lokalisierung:** Neue sichtbare v1.2-Texte wie „Punkte“ und „0 Punkte“ werden im bestehenden String Catalog gepflegt. Ein vollständiger Refactor aller historischen Texte ist nicht Teil von v1.2.
- **Gerätekompatibilität:** Das Projekt muss für visionOS 26.5 kompilieren und im visionOS-Simulator sowie auf einer verfügbaren Apple Vision Pro lauffähig sein.

## 3. Architektur-Skizze

v1.2 erweitert die bestehende Architektur an zwei klar abgegrenzten Stellen: Erstens wird um alle Phasen eine stabile gemeinsame Root-/Volume-Layoutstrategie gelegt. Zweitens erhält der Sitzungszustand eine stabile Zuordnung von Ticket zu Monster-Farbvariante.

```text
[Ticket_TamerApp / volumetrisches WindowGroup]
             |
             v
[stabile Root-/Volume-Layoutfläche]
             |
             v
[RootVolumeView]
   |--- StartView
   |--- InvestigationView
   |--- PrioritizationView
   |--- TeamAssignmentView
   |--- ResultView
             |
             v
[SessionModel / GameState]
   |-- Ticketkatalog / Auswahl / Score / Phase / Exactly-once
   |-- selectedMonsterVariantByTicketID
   |
   +--------------------+--------------------------+
   |                    |                          |
   v                    v                          v
[HUD / Ticketinfo]  [RealityKit-Views]       [Audio / Feedback]
                         |
                         +--> MonsterAssetProvider
                                |
                                +--> Monstertyp -> 4 explizite Varianten
                                +--> insgesamt 16 lokale Assets

[ResultView]
   |-- „X Punkte“
   +-- „Erneut spielen“
          |
          +--> SessionModel.reset()
          +--> Root-/Volume-Größe bleibt unverändert
```

Die Layoutkorrektur gehört primär in `Ticket_TamerApp` beziehungsweise `RootVolumeView`: Alle Phasen erhalten dieselbe stabile Layoutbasis. Einzelne Start-, Priorisierungs- oder Team-Views dürfen nicht mit voneinander unabhängigen Replay-Sonderfixes arbeiten.

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
- monsterAssetId / monsterTypeId: String
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
- selectedTicketCount: Int
- sessionTickets: [Ticket]
- currentTicketIndex: Int
- currentPhase: GamePhase
- score: Int
- selectedPriority: TicketPriority?
- selectedTeam: SupportTeam?
- isInputLocked: Bool
```

### v1.1-Darstellungszustände

```text
PrioritizationView / TeamAssignmentView
- isTicketInfoPresented: Bool
- feedbackResult: Bool?

Monster-Ladeansichten
- loadError: Error?
- lokaler Lade-/Retry-Zustand
```

### Neuer v1.2-Zustand für Monster-Varianten

Die konkrete Implementierung darf als Dictionary oder kleine sitzungsbezogene Präsentationsstruktur erfolgen. Fachlich gilt:

```text
MonsterAssetVariant
- monsterTypeId: String
- assetFileName: String
- variantKey: String

SessionModel
- selectedMonsterVariantByTicketID: [Ticket.ID: MonsterAssetVariant]
```

Regeln:

- Die Auswahl wird beim Aufbau einer neuen Sitzung für jedes ausgewählte Ticket genau einmal erzeugt.
- Pro Monstertyp stehen exakt die tatsächlich vorhandenen vier Dateinamen zur Auswahl.
- Die Auswahl wird nicht bei jedem View-Aufbau erneut gewürfelt.
- Untersuchung, Priorisierung und Teamzuordnung lesen dieselbe Auswahl.
- `Erneut laden` lädt dieselbe Variante erneut.
- `reset()` verwirft alle Varianten der abgeschlossenen Sitzung.
- Eine neue Sitzung darf neue Varianten auswählen.
- Die Auswahlfunktion wird injizierbar gemacht, damit Unit-Tests deterministische Varianten erzwingen können.

### Vorhandene Farbvarianten

Es stehen vier Varianten pro Monstertyp zur Verfügung, insgesamt 16 Assets. Die konkreten Dateinamen werden explizit gemappt; es wird nicht vorausgesetzt, dass alle Monstertypen identische Farbnamen besitzen. Insbesondere besitzt Monstertyp 3 laut Bestandsanalyse `blue`, `green`, `pink` und `yellow`, während die übrigen Typen `blue`, `green`, `pink` und `red` verwenden.

### Replay-Layoutzustand

Die sichtbare Volume-Größe ist **kein fachlicher Sitzungszustand** und wird nicht durch `SessionModel.reset()` zurückgesetzt. Die App muss beim Replay mit derselben aktuell gewährten Volume-/Root-Geometrie weiterarbeiten.

Die Lösung soll:

- eine phasenübergreifend stabile Root-Layoutfläche verwenden,
- die aktuelle tatsächlich gewährte Geometrie als Grundlage nutzen,
- `.defaultSize` nicht als Replay-Reset missbrauchen,
- die StartView nicht nur über eine reine `maxWidth`-Begrenzung vom verfügbaren Proposal abhängig machen,
- Prioritäts- und Teamzielgrößen weiterhin aus der tatsächlich gemessenen Geometrie ableiten.

### Bewertungs- und Feedbackregeln v1.2

- Richtige Priorität: `+100`
- Falsche Priorität: `+0`
- Richtiges Team: `+100`
- Falsches Team: `+0`
- Richtige Entscheidung: Erfolgssound + grüner Haken + `+100 Punkte`
- Falsche Entscheidung: Fehlersound + rotes Kreuz + `0 Punkte`
- Keine Anzeige der richtigen Lösung oder einer Begründung
- Feedbackdauer bleibt ungefähr 1,5 Sekunden
- Exactly-once-Semantik bleibt unverändert

### Teamdarstellung v1.2

Jede Teamstation besitzt Text plus Symbol:

- Netzwerk → Netzwerk-/Verbindungssymbol
- Konto → Personen- oder Schlüsselsymbol
- Software → App-/Fenstersymbol
- Hardware → Computer- oder Werkzeugsymbol

[Vorschlag innerhalb der Implementierung] Soweit passend, werden Apple SF Symbols genutzt, damit keine zusätzlichen Grafikassets erforderlich sind. Die finale Symbolwahl darf variieren, solange Semantik und Akzeptanzkriterien erfüllt bleiben.

## 5. Modul-Landkarte

Der Bauplan in Modulen. Module 001 bis 014 bilden v1.0, 015 bis 020 v1.1. v1.2 beginnt mit Modul 021.

| Modul | Titel | Leistet | Erfüllt | Hängt ab von |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | visionOS-Projekt, App-Einstieg, zentrales Volume und Grundrouting | F-05 | – |
| 002 | Ticketdatenmodell und lokaler Katalog | Datentypen, Enumerationen und 12 lokale Tickets | F-02, F-03 | 001 |
| 003 | Sitzungsmodell und Zufallsauswahl | Sitzungszustand, Auswahl ohne Wiederholung, Index, Score und Reset | F-04, F-16 | 002 |
| 004 | Startansicht v1.0 | Projekttitel, Slider 1 bis 12, Standardwert 6 und „Spiel starten“ | F-01 | 003 |
| 005 | Monster-Asset-Pipeline v1.0 | Vier eigene Monstertypen lokal einbinden und neutral zuordnen | F-14 | 001, 002 |
| 006 | Untersuchungsphase | Ticketkarte, Monsterdarstellung und Wechsel zur Priorisierung | F-06, F-07 | 002, 003, 005 |
| 007 | Räumliche Interaktionsgrundlagen | Blickfokus, Pinch, Drag, Drop-Bounds, Snapback und Eingabesperre | F-10 | 001, 005 |
| 008 | Priorisierungsphase | Drei Prioritätsziele und Speichern der Prioritätsentscheidung | F-08 | 003, 006, 007 |
| 009 | Teamzuordnungsphase | Vier Teamziele und Speichern der Teamentscheidung | F-09 | 003, 007, 008 |
| 010 | Bewertung und Audiofeedback | Punkte, Sounds, Exactly-once und 1,5-s-Übergänge | F-11, F-12, F-13 | 003, 008, 009 |
| 011 | Ergebnis und Neustart | Gesamtpunktzahl und „Erneut spielen“; vollständiger fachlicher Reset | F-15, F-16 | 003, 010 |
| 012 | Optionale Monsterreaktion | Historischer Kann-Baustein für zusätzliche Monsteranimation | F-17 | 005, 010 |
| 013 | Integration und Gerätetest v1.0 | Gesamtablauf, Geometrie, Stabilität und Regressionen prüfen | F-01 bis F-16 | 001 bis 011 |
| 014 | Doku & Cleanup v1.0 | Projektstand bereinigen, dokumentieren und v1.0 abschließen | – | 001 bis 013 |
| 015 | Session-HUD und Interaktionshinweise | HUD mit Ticketfortschritt, Phasentitel, Fortschrittsbalken und Drag-Hinweisen | F-18, F-20 | 006, 008, 009 |
| 016 | Kompakte Ticketinfo | Ticketinfo-Overlay, Info-Button, Schließen und Interaktionssperre | F-19 | 002, 008, 009, 015 |
| 017 | Startseiten-Usability | Kurzbeschreibung sowie Minus-/Plus-Buttons zum Slider | F-22, F-24 | 003, 004 |
| 018 | Visuelles Entscheidungsfeedback v1.1 | Grüner Haken + `+100 Punkte` beziehungsweise rotes Kreuz | F-21 | 010 |
| 019 | Ladefehler-Recovery | „Erneut laden“ in allen Monsterphasen | F-23 | 005, 006, 008, 009 |
| 020 | Integration und Abnahme v1.1 | v1.1-Komponenten gemeinsam prüfen und abschließen | F-18 bis F-24 | 015 bis 019 |
| 021 | Replay-Layoutstabilisierung | Gemeinsame Root-/Volume-Layoutbasis herstellen, Replay-Schrumpfen beseitigen und aktuelle Volume-Größe erhalten | F-25 | 001, 004, 008, 009, 011, 020 |
| 022 | Punktekommunikation v1.2 | Ergebnis als „X Punkte“ kennzeichnen und falsches Feedback um „0 Punkte“ ergänzen | F-26, F-27 | 011, 018 |
| 023 | Teamstation-Symbole | Semantische Symbole zusätzlich zu den vier Teamtexten integrieren | F-28 | 009, 020 |
| 024 | Debug-UI-Isolation | DEV-Schaltfläche aus dem normalen App-Flow entfernen und nur im Debug-Harness verfügbar halten | F-29 | 009, 020 |
| 025 | Monster-Farbvarianten | Alle 16 Assets bündeln, Variantenmapping, sitzungsstabile Auswahl und deterministische Tests ergänzen | F-30 | 002, 003, 005, 019, 020 |
| 026 | Integration und Abnahme v1.2 | Replay über fünf Zyklen, 16 Assetvarianten, neue Punktekommunikation, Teamsymbole und Debug-Isolation regressionssicher prüfen | F-25 bis F-30 | 021 bis 025 |

## 6. Technische Constraints

- Zielplattform ist Apple Vision Pro mit visionOS Deployment Target 26.5.
- Das bestehende Xcode-/Swift-/SwiftUI-/RealityKit-Projekt wird ohne neue Third-Party-Abhängigkeiten fortgeführt.
- `SessionModel` bleibt die einzige fachliche Source of Truth. Die pro Sitzung ausgewählte Monster-Variante darf dort oder in einer eindeutig sitzungsbezogenen Struktur verwaltet werden.
- Die 16 Monsterdateien werden in die produktive lokale `RealityKitContent/MonsterAssets`-Ressourcenquelle aufgenommen. Der Root-Ordner `Monster/` allein genügt nicht als Build-Ressourcenquelle.
- Varianten werden über explizite Dateinamen je Monstertyp gemappt; keine Dateinamen aus pauschal angenommenen Farbnamen konstruieren.
- Retry darf niemals eine neue Variante würfeln.
- Die Variantenwahl muss injizierbar beziehungsweise deterministisch testbar sein.
- Farbe, Modelltyp, Team und Priorität bleiben fachlich voneinander unabhängig.
- Die Replay-Korrektur wird zentral in `Ticket_TamerApp`/`RootVolumeView` beziehungsweise einer gemeinsamen Root-Layoutkomponente vorgenommen. Keine mehrfach duplizierten phasenspezifischen Skalierungs-Hacks.
- Die App erhält beim Replay die aktuell verwendete Volume-Größe; ein Nutzer-Resize wird nicht auf Cold-Start-Defaultwerte zurückgesetzt.
- Die konkrete visionOS-API für Window-Resizability beziehungsweise Größenpolitik muss gegen das tatsächlich verwendete SDK geprüft werden; maßgeblich ist das beobachtbare Verhalten aus F-25/AK-25.
- `StartView` erhält innerhalb der stabilen Rootfläche eine robuste Inhalts-/Sliderbreitenstrategie und verlässt sich nicht ausschließlich auf `maxWidth` als Zielbreite.
- Prioritäts- und Team-Layouts dürfen weiterhin aus tatsächlich gemessenen Volume-Bounds berechnet werden.
- Unstrukturierte asynchrone Layout-Mess-Tasks sollen bei Änderungen am Replay-Fix nicht zusätzlich vermehrt werden; falls sie berührt werden, ist Cancellation sauber zu behandeln.
- `🔧 Team [DEV]` darf nur im separaten Debug-Harness oder nach einer expliziten Debug-Aktivierung erscheinen, nicht im normalen Routing.
- Teamstationen behalten ihre Textbezeichnungen. Symbole ergänzen den Text und dürfen die Drop-Geometrie nicht verändern.
- Neue sichtbare Texte „Punkte“ und „0 Punkte“ werden im String Catalog gepflegt.
- Scoring, 50-%-Drop-Regel, Z-Toleranz, Snapback, Exactly-once, 1,5-s-Transition und Ticketreferenzwerte bleiben unverändert.
- [Annahme] v1.1 ist vollständig abgeschlossen und alle bisherigen Pflicht-AKs gelten vor Start von Modul 021 als PASS.

## 7. Offene Fragen

- [Offen] Die konkrete SwiftUI-/visionOS-Implementierung der stabilen Root-/Window-Größenpolitik wird in Modul 021 anhand des verwendeten SDKs ausgewählt. Das fachliche Ziel – keine Replay-bedingte Größenänderung bei Erhalt der aktuellen Volume-Größe – ist bereits entschieden.
- [Offen] Die final verwendeten SF Symbols für Netzwerk, Konto, Software und Hardware werden in Modul 023 ausgewählt und auf Lesbarkeit in der vorgesehenen Betrachtungsdistanz geprüft.
- [Offen] Die genaue interne Form des sitzungsbezogenen Variantenmappings (`Dictionary` oder kleine Presentation-Struktur) wird in Modul 025 gewählt; Stabilitäts- und Testregeln aus F-30 sind verbindlich.
