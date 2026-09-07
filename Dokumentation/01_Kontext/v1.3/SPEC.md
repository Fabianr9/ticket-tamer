# SPECs — Ticket Tamer

> **Funktion.** Übersetzt die Vision in umsetzbare, prüfbare Anforderungen und schneidet daraus die Module.
> Lebendes Dokument — Änderungen bewusst treffen und im Projektlogbuch vermerken.

## 1. Funktionale Anforderungen

Je eine testbare Aussage. Referenzierbar über `F-xx`.

| ID | Anforderung | Priorität (Muss/Kann) |
|---|---|---|
| F-01 | Das System zeigt beim App-Start eine deutsche Startansicht mit Projekttitel, Kurzbeschreibung, einem ganzzahligen Regler von 1 bis 16 Tickets, Standardwert 6, synchronen Minus-/Plus-Buttons und der Schaltfläche „Spiel starten“. | Muss |
| F-02 | Das System enthält genau 16 lokal definierte Tickets TT-001 bis TT-016. TT-001 bis TT-012 bilden jede Kombination aus 4 Teams × 3 Prioritäten genau einmal ab; TT-013 bis TT-016 erweitern die Verteilung auf je 4 Tickets pro Team sowie insgesamt 5× Normal, 6× Wichtig und 5× Kritisch. | Muss |
| F-03 | Jedes Ticket enthält mindestens Ticketnummer, Titel, Kurzbeschreibung, User Impact, ein bis drei Symptome oder Hinweise, eine Referenzpriorität, ein Referenzteam, eine Monsterzuordnung und eine feste lokale Video-Referenz. | Muss |
| F-04 | Beim Start einer Sitzung wählt das System entsprechend der Reglereinstellung zufällige Tickets ohne Wiederholung aus dem lokalen Ticketpool aus. | Muss |
| F-05 | Das System führt die Sitzung in genau einem zentralen Volume als lineare Zustandsfolge aus: Startansicht, Untersuchen, Priorisieren, Team zuordnen, nächstes Ticket und Ergebnis. | Muss |
| F-06 | In der Untersuchungsphase zeigt das System ein Ticket-Monster und eine gut lesbare Ticketkarte mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptomen beziehungsweise Hinweisen an. | Muss |
| F-07 | Die Untersuchungsphase enthält die Schaltfläche „Weiter zur Priorisierung“, die zur Priorisierungsphase desselben Tickets wechselt. | Muss |
| F-08 | In der Priorisierungsphase kann die nutzende Person das Monster mit Blickfokus, Pinch und Drag auf genau eines der beschrifteten Ziele Normal, Wichtig oder Kritisch bewegen und dort ablegen. | Muss |
| F-09 | In der Teamzuordnungsphase kann die nutzende Person das Monster mit Blickfokus, Pinch und Drag auf genau eine der beschrifteten Stationen Netzwerk, Konto, Software oder Hardware bewegen und dort ablegen. | Muss |
| F-10 | Ein Loslassen außerhalb eines gültigen Ziels verändert den Sitzungszustand nicht. Ein gültiges Ablegen speichert die Entscheidung genau einmal und sperrt weitere Eingaben bis zum Zustandswechsel. | Muss |
| F-11 | Das System verwendet weiterhin 100 Basispunkte pro richtiger Einzelentscheidung und 0 Punkte pro falscher Einzelentscheidung. Der Streak-Multiplikator aus F-37 verändert ausschließlich die Gesamtpunkte vollständig korrekt gelöster Tickets. | Muss |
| F-12 | Das System spielt nach jeder gültigen Einzelentscheidung genau einen zufällig ausgewählten lokalen Monster-Sound aus der passenden Gruppe ab: 4 Varianten für richtig und 4 Varianten für falsch. | Muss |
| F-13 | Das System zeigt nach einer Entscheidung weder die richtige Lösung noch eine textliche Begründung an und wechselt nach dem vorgesehenen Feedbackablauf automatisch zum nächsten Schritt. | Muss |
| F-14 | Das System bindet vier eigene, lokal mitgelieferte Blender-Monstertypen als RealityKit-kompatible 3D-Assets ein. Die Modellwahl darf keinen eindeutigen Rückschluss auf Referenzteam oder Referenzpriorität zulassen. | Muss |
| F-15 | Nach der Bearbeitung aller ausgewählten Tickets zeigt das System die erreichte Gesamtpunktzahl mit der Einheit „Punkte“ sowie die Schaltfläche „Erneut spielen“ an und keine zusätzlichen Ergebnisstatistiken. | Muss |
| F-16 | „Erneut spielen“ führt zur Startansicht zurück, verwirft den bisherigen fachlichen Sitzungszustand einschließlich Streak und setzt die Ticketanzahl wieder auf 6. | Muss |
| F-17 | Das System kann in einer späteren Erweiterung zusätzliche Monster-Gesichts- oder Bewegungsreaktionen darstellen. Diese Funktion ist nicht erforderlich für den Pflichtumfang. | Kann |
| F-18 | Das System zeigt in Untersuchungs-, Priorisierungs- und Teamzuordnungsphase dauerhaft ein kompaktes Sitzungs-HUD mit „Ticket X von Y“, einem zur Phase passenden Titel und einem linearen Fortschrittsbalken. Das HUD enthält weder Score noch dauerhaft sichtbaren Streak-Multiplikator. | Muss |
| F-19 | Das System bietet in Priorisierungs- und Teamzuordnungsphase einen Info-Button, der eine kompakte Ticketübersicht mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptomen beziehungsweise Hinweisen öffnet, ohne Referenzpriorität oder Referenzteam anzuzeigen. | Muss |
| F-20 | Das System zeigt in den beiden Zuweisungsphasen dauerhaft einen nicht interaktiven Hinweis zur benötigten Drag-Geste: „Monster greifen und auf eine Priorität ziehen.“ beziehungsweise „Monster greifen und dem zuständigen Team zuordnen.“ | Muss |
| F-21 | Das System zeigt während des Feedbackfensters zusätzlich zum Sound bei einer richtigen Entscheidung einen grünen Haken und die tatsächlich mit dieser Entscheidung gutgeschriebenen Punkte. Eine richtige Priorität zeigt `+100 Punkte`; bei einer richtigen Teamentscheidung können aufgrund von F-37 höhere Zusatzpunkte angezeigt werden. | Muss |
| F-22 | Die Startansicht ergänzt den Ticketanzahl-Slider um einen Minus- und einen Plus-Button, die die Auswahl jeweils um genau ein Ticket verändern, an den Grenzen 1 beziehungsweise 16 deaktiviert sind und mit Slider und Zahlenanzeige synchron bleiben. | Muss |
| F-23 | Bei einem Monster-Ladefehler zeigt das System in Untersuchung, Priorisierung und Teamzuordnung die Aktion „Erneut laden“. Ein Wiederholungsversuch lädt ausschließlich das aktuelle Monster beziehungsweise dieselbe ausgewählte Monster-Variante neu und verändert weder fachlichen Sitzungszustand noch Score oder Zielpanels. | Muss |
| F-24 | Die Startansicht zeigt unter dem Titel die Kurzbeschreibung „Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.“ und führt keine zusätzliche Tutorial- oder Popover-Logik ein. | Muss |
| F-25 | Das System hält beim Wechsel Ergebnis → „Erneut spielen“ die aktuell verwendete Volume- und Root-Layoutgröße stabil. Startansicht, Slider, Texte, Prioritätsziele und Teamziele dürfen allein durch Replay weder schrumpfen noch wachsen oder über mehrere Durchläufe kumulativ driften. | Muss |
| F-26 | Die Ergebnisansicht kennzeichnet die Gesamtpunktzahl sichtbar mit der Einheit „Punkte“, zum Beispiel „600 Punkte“, ohne weitere Ergebnisstatistiken einzuführen. | Muss |
| F-27 | Das visuelle Feedback einer falschen Prioritäts- oder Teamentscheidung zeigt zusätzlich zum roten Kreuz den Text „0 Punkte“. Es werden keine richtige Lösung und keine Begründung angezeigt. | Muss |
| F-28 | Jede Teamstation zeigt zusätzlich zur Textbezeichnung das bereitgestellte lokale JPEG-Teamlogo für Netzwerk, Konto, Software beziehungsweise Hardware. Der Text bleibt sichtbar; Drop-Geometrie und Teamlogik werden durch das Logo nicht verändert. | Muss |
| F-29 | Die Entwicklungs-Schaltfläche `🔧 Team [DEV]` erscheint nicht im normalen App-Ablauf, auch nicht in einem regulären Debug-Build. Entwicklungszugriffe bleiben ausschließlich im separaten Debug-Harness beziehungsweise in explizit aktivierten Debug-Kontexten verfügbar. | Muss |
| F-30 | Das System kann alle 16 vorhandenen Monster-Farbvarianten laden. Für jedes Sitzungsticket wird beim Sitzungsstart eine Variante seines Monstertyps ausgewählt und für Untersuchung, Priorisierung, Teamzuordnung sowie Retry stabil beibehalten. Eine neue Sitzung darf neu auswählen; die Farbe codiert weder Priorität noch Team noch Richtigkeit. | Muss |
| F-31 | Das System ersetzt die bisherigen Ticketinhalte vollständig durch die 16 bereitgestellten v1.3-Tickets TT-001 bis TT-016 aus `Tickets/Ticket-Tamer_Tickets.md`, ohne die festgelegten Referenzlösungen zu verändern oder eine Lösung im sichtbaren Tickettext zu verraten. | Muss |
| F-32 | Jedes der 16 Tickets besitzt genau eine feste lokale Video-Referenz `TT-001.mp4` bis `TT-016.mp4`. In der Untersuchungsphase ist für das aktuelle Ticket die Aktion „Video ansehen“ verfügbar; das Video startet nicht ohne diese Benutzeraktion. | Muss |
| F-33 | Nach „Video ansehen“ startet das aktuelle Ticketvideo automatisch in einer einfachen Videoansicht, kann pausiert/fortgesetzt und per `X` vorzeitig geschlossen werden, schließt sich nach regulärem Ende automatisch und kehrt zum unveränderten aktuellen Ticket zurück. Ein Ladefehler führt nicht zum Absturz und beeinflusst weder Score noch Streak noch Ticketfortschritt. | Muss |
| F-34 | Die acht neuen Monster-Feedbacksounds werden lokal unter einer nachvollziehbaren Ressourcenstruktur abgelegt. Bei jeder richtigen beziehungsweise falschen Einzelentscheidung wird zufällig genau eine der vier passenden Varianten ausgewählt; direkte Wiederholungen sind zulässig. | Muss |
| F-35 | Das System verwendet zwei zusätzliche lokale Streak-Sounds: Streak-Sound 01 bei x2 und x3 sowie Streak-Sound 02 bei x4 und höher. Der Streak-Sound wird ausschließlich nach einer vollständig korrekten Teamentscheidung mit Streak ≥ 2 zusätzlich zum positiven Monster-Sound abgespielt und nicht bei der Prioritätsentscheidung. | Muss |
| F-36 | Das System führt einen Sitzungszustand `streak` ein. Nur wenn Priorität und Team desselben Tickets korrekt sind, wird die Streak um 1 erhöht; sobald mindestens eine der beiden Entscheidungen falsch ist, wird die Streak auf 0 gesetzt. Neue Sitzung und Reset starten immer mit Streak 0. | Muss |
| F-37 | Für vollständig korrekt gelöste Tickets berechnet das System die Ticketgesamtpunkte als `200 × aktuelle Streak`. Streak 1 ergibt 200, Streak 2 400, Streak 3 600 usw. Da die Priorität weiterhin sofort 100 Punkte gutschreibt, schreibt die abschließende Teamentscheidung bei einem vollständig korrekten Ticket genau die noch fehlende Differenz gut. Teilweise richtige Tickets behalten nur ihre normalen Einzelpunkte und erhalten keinen Multiplikator. | Muss |
| F-38 | Der aktuelle Multiplikator wird nicht dauerhaft im HUD angezeigt. Nach einer richtigen Teamentscheidung, die ein vollständig korrektes Ticket mit Streak ≥ 2 abschließt, zeigt das System kurz `x2`, `x3`, `x4` usw. an. x2/x3 verwenden die normale Streak-Darstellung; ab x4 ist die Darstellung sichtbar größer und erhält zusätzlich eine kurze Puls-/Scale-Animation. | Muss |
| F-39 | Die bereitgestellten Teamlogos, Monster-Sounds, Streak-Sounds und Ticketvideos werden in einer klaren lokalen Ressourcenstruktur abgelegt und über zentrale Mappings beziehungsweise Services referenziert; fachliche Team-, Score- und Ticketlogik darf nicht von Dateipfaden in Views abhängen. | Muss |

## 2. Nicht-funktionale Anforderungen

- **Performance:** Lokale Ticket-, Audio-, Logo- und Videoressourcen sollen ohne Netzwerkzugriff geladen werden. Zustandswechsel und normale UI-Interaktionen dürfen durch die neuen Medienfunktionen nicht sichtbar blockieren.
- **Video-Stabilität:** Das Öffnen, Pausieren, Schließen und automatische Beenden eines Videos darf keine zweite Sitzung, keinen doppelten Phasenwechsel und keine Score-/Streak-Mutation auslösen.
- **Audio-Stabilität:** Pro gültiger Einzelentscheidung wird genau ein Monster-Feedbacksound ausgelöst. Ein zusätzlicher Streak-Sound darf ausschließlich bei einem vollständig korrekten Teamabschluss mit Streak ≥ 2 ausgelöst werden.
- **Determinismus/Testbarkeit:** Zufallsauswahl von Tickets, Monster-Farbvarianten und Feedbacksoundvarianten soll über injizierbare beziehungsweise isoliert testbare Auswahlfunktionen deterministisch prüfbar sein.
- **Barrierefreiheit:** Teamlogos ersetzen niemals die Textbezeichnung. Feedback bleibt zusätzlich visuell sichtbar. Video- und Schließen-Aktionen erhalten verständliche Accessibility-Beschriftungen.
- **Stabilität:** Sitzungen mit 1, 6 und 16 Tickets sowie mindestens fünf Replay-Zyklen müssen ohne Absturz, Score-Carryover, Streak-Carryover oder Layoutdrift durchspielbar sein.
- **Bedienbarkeit:** Videos sind optional. Ein Ticket bleibt jederzeit auch allein anhand der sichtbaren Ticketinformationen lösbar.
- **Wartbarkeit:** Ticketdaten, Videozuordnung, Audioauswahl, Streak-/Scoringlogik und Ressourcenmappings liegen in getrennten Verantwortungsbereichen; `SessionModel` bleibt die zentrale fachliche Zustandsquelle.
- **Datenschutz:** Es werden keine personenbezogenen Daten, Benutzerkonten oder externen Verbindungen verwendet.
- **Sprache:** Alle sichtbaren UI-Texte bleiben deutsch. Monster-Sounds enthalten keine verständliche Sprache.
- **Gerätekompatibilität:** Das Projekt muss unter der bestehenden visionOS-/Xcode-Konfiguration kompilieren und im Apple-Vision-Pro-Simulator sowie soweit verfügbar auf echter Hardware lauffähig bleiben.

## 3. Architektur-Skizze

Die v1.3-Erweiterung ergänzt die bestehende Architektur, ohne den Router oder die räumlichen Kernservices neu aufzubauen.

```text
[StartView]
   |  Ticketanzahl 1...16
   v
[SessionModel / GameState]
   |-- wählt --> [LocalTicketCatalog: TT-001...TT-016]
   |               |-- Video-Referenz --> TT-xxx.mp4
   |
   |-- verwaltet --> Phase, Index, Score, Streak, Input-Lock,
   |                 aktuelle Entscheidungen, Monster-Variante
   |
   +-------------------+---------------------+--------------------+
   |                   |                     |                    |
   v                   v                     v                    v
[Investigation]   [Prioritize]          [TeamAssignment]    [ResultView]
   |                   |                     |
   | Video ansehen     | Entscheidung        | Entscheidung +
   v                   v                     | Ticketabschluss
[TicketVideoView]   [Scoring]                v
   |                   |                 [Streak/Scoring]
   | AVPlayer/AVKit    |                     |
   +--> auto close     +--> [AudioService] <-+
                              |-- MonsterSounds/Correct (4)
                              |-- MonsterSounds/Incorrect (4)
                              `-- StreakSounds (01/02)

[TeamLogoProvider / Asset Mapping] --> TeamAssignmentView
[MonsterAssetProvider]             --> bestehende 16 Farbvarianten
```

`SessionModel` bleibt die einzige fachliche Source of Truth. Video-Player-Zustände wie `isVideoPresented` oder der konkrete `AVPlayer` dürfen view-/service-lokal bleiben, solange sie keinen fachlichen Sitzungszustand duplizieren. Die Streak selbst ist fachlicher Zustand und gehört in das zentrale Sitzungsmodell beziehungsweise einen von diesem kontrollierten Scoring-Baustein.

## 4. Datenmodell / Zustand

### Ticket

```text
Ticket
- id: String                  // TT-001 ... TT-016
- ticketNumber: String
- title: String
- shortDescription: String
- userImpact: String
- symptoms: [String]          // 1 bis 3 Einträge
- referencePriority: TicketPriority
- referenceTeam: SupportTeam
- monsterTypeId: String
- videoAssetName: String      // TT-001.mp4 ... TT-016.mp4
```

Die tatsächlichen Textinhalte werden verbindlich aus `Tickets/Ticket-Tamer_Tickets.md` in den lokalen Swift-Katalog übertragen. Die Markdown-Datei wird nicht zur Laufzeit geparst.

### Referenzverteilung der 16 Tickets

| Team | Normal | Wichtig | Kritisch | Gesamt |
|---|---|---|---|---:|
| Netzwerk | TT-001 | TT-002, TT-013 | TT-003 | 4 |
| Konto | TT-004, TT-014 | TT-005 | TT-006 | 4 |
| Software | TT-007 | TT-008, TT-015 | TT-009 | 4 |
| Hardware | TT-010 | TT-011 | TT-012, TT-016 | 4 |
| **Gesamt** | **5** | **6** | **5** | **16** |

Zusätzliche Fälle:

- TT-013 – Homeoffice/VPN → Netzwerk + Wichtig
- TT-014 – Zwei-Faktor-Anmeldung → Konto + Normal
- TT-015 – Ticketsystem erzeugt Duplikate → Software + Wichtig
- TT-016 – Lager-Scanner ausgefallen → Hardware + Kritisch

### SessionState / SessionModel

Bestehende Werte bleiben erhalten und werden um Streak-relevanten Zustand ergänzt:

```text
SessionState
- selectedTicketCount: Int    // 1...16, Standard 6
- sessionTickets: [Ticket]
- currentTicketIndex: Int
- currentPhase: GamePhase
- score: Int
- streak: Int                 // Start/Reset = 0
- selectedPriority: TicketPriority?
- selectedTeam: SupportTeam?
- currentPriorityWasCorrect: Bool?
- isInputLocked: Bool
- selectedMonsterVariantByTicket: Mapping
```

### Streak- und Punkteberechnung

Verbindliche Regeln:

1. Richtige Priorität schreibt sofort +100 Basispunkte gut.
2. Falsche Priorität schreibt 0 gut und setzt die Streak auf 0 beziehungsweise markiert das aktuelle Ticket als nicht streak-fähig.
3. Bei der Teamentscheidung wird geprüft, ob Priorität **und** Team korrekt sind.
4. Wenn beide korrekt sind:
   - `streak += 1`
   - `ticketTotal = 200 × streak`
   - `teamCredit = ticketTotal - bereitsFürDiesesTicketGutgeschriebenePunkte`
5. Wenn mindestens eine Entscheidung falsch ist:
   - `streak = 0`
   - die Teamentscheidung schreibt nur ihre normalen Einzelpunkte gut (`100` oder `0`)
   - kein Multiplikator wird angewandt.
6. Direkte Beispiele:

```text
vollständig korrekt, Streak 1:
Priorität +100, Team +100  => Ticket 200

vollständig korrekt, Streak 2:
Priorität +100, Team +300  => Ticket 400

vollständig korrekt, Streak 3:
Priorität +100, Team +500  => Ticket 600

Priorität korrekt, Team falsch:
Priorität +100, Team +0    => Ticket 100, Streak 0

Priorität falsch, Team korrekt:
Priorität +0, Team +100    => Ticket 100, Streak 0

beide falsch:
0 Punkte, Streak 0
```

Die maximale Streak ist nicht künstlich begrenzt; durch die maximale Sitzungsgröße beträgt die praktisch höchste Streak 16.

### Audiozustand

- Correct Monster Sounds: 4 WAV-Dateien
- Incorrect Monster Sounds: 4 WAV-Dateien
- Streak Sound 01: x2 und x3
- Streak Sound 02: x4+
- pro Einzelentscheidung genau ein Monster-Sound
- bei vollständig korrektem Teamabschluss ab x2 zusätzlich genau ein Streak-Sound
- Streak-Sound leicht zeitversetzt beziehungsweise nacheinander mit dem Monster-Sound
- keine Anti-Wiederholungslogik für Monster-Sounds

### Videozustand

View-/Service-lokaler Zustand kann umfassen:

```text
TicketVideoState
- isPresented: Bool
- player: AVPlayer?
- loadError: VideoLoadError?
```

Fachliche Invarianten:

- Öffnen/Schließen ändert weder Ticketindex, Phase, Score noch Streak.
- Nach Videoende automatische Rückkehr zur Untersuchungsansicht desselben Tickets.
- Manuelles `X` führt ebenfalls zurück zum selben Ticket.
- Video-Fehler blockieren die Ticketbearbeitung nicht.

### Ressourcenstruktur

```text
Resources/
├── Audio/
│   ├── MonsterSounds/
│   │   ├── Correct/      // 4 WAV
│   │   └── Incorrect/    // 4 WAV
│   └── StreakSounds/     // 01, 02
├── TeamLogos/            // 4 JPEG
└── Videos/
    ├── TT-001.mp4
    ├── ...
    └── TT-016.mp4
```

Die Views erhalten fachliche IDs beziehungsweise URLs über Provider/Services und sollen keine verstreuten hart codierten relativen Dateipfade enthalten.

## 5. Modul-Landkarte

Der Bauplan in Modulen. Module 001–014 bilden v1.0, 015–020 v1.1, 021–026 v1.2. Version 1.3 beginnt mit Modul 027. Historische Module bleiben dokumentiert; v1.3-Module erweitern beziehungsweise ersetzen gezielt einzelne frühere Inhalte.

| Modul | Titel | Leistet | Erfüllt | Hängt ab von |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | visionOS-Projekt, App-Einstieg, zentrales Volume und Grundrouting | F-05 | – |
| 002 | Ticketdatenmodell und lokaler Katalog v1.0 | Historischer 12-Ticket-Katalog und Grundtypen | F-02, F-03 | 001 |
| 003 | Sitzungsmodell und Zufallsauswahl | Sitzungszustand, Auswahl ohne Wiederholung, Index, Score und Reset | F-04, F-16 | 002 |
| 004 | Startansicht v1.0 | Historischer Slider 1 bis 12, Standardwert 6 und „Spiel starten“ | F-01 | 003 |
| 005 | Monster-Asset-Pipeline v1.0 | Vier eigene Monstertypen lokal einbinden und neutral zuordnen | F-14 | 001, 002 |
| 006 | Untersuchungsphase | Ticketkarte, Monsterdarstellung und Wechsel zur Priorisierung | F-06, F-07 | 002, 003, 005 |
| 007 | Räumliche Interaktionsgrundlagen | Blickfokus, Pinch, Drag, Drop-Bounds, Snapback und Eingabesperre | F-10 | 001, 005 |
| 008 | Priorisierungsphase | Drei Prioritätsziele und Speichern der Prioritätsentscheidung | F-08 | 003, 006, 007 |
| 009 | Teamzuordnungsphase | Vier Teamziele und Speichern der Teamentscheidung | F-09 | 003, 007, 008 |
| 010 | Bewertung und Audiofeedback v1.0 | Basispunkte, ursprüngliche Sounds, Exactly-once und Übergänge | F-11, F-12, F-13 | 003, 008, 009 |
| 011 | Ergebnis und Neustart | Gesamtpunktzahl und „Erneut spielen“; vollständiger fachlicher Reset | F-15, F-16 | 003, 010 |
| 012 | Optionale Monsterreaktion | Historischer Kann-Baustein | F-17 | 005, 010 |
| 013 | Integration und Gerätetest v1.0 | Gesamtablauf, Geometrie, Stabilität und Regressionen prüfen | F-01 bis F-16 | 001 bis 011 |
| 014 | Doku & Cleanup v1.0 | Projektstand bereinigen, dokumentieren und v1.0 abschließen | – | 001 bis 013 |
| 015 | Session-HUD und Interaktionshinweise | HUD mit Ticketfortschritt, Phasentitel, Fortschrittsbalken und Drag-Hinweisen | F-18, F-20 | 006, 008, 009 |
| 016 | Kompakte Ticketinfo | Ticketinfo-Overlay, Info-Button, Schließen und Interaktionssperre | F-19 | 002, 008, 009, 015 |
| 017 | Startseiten-Usability | Kurzbeschreibung sowie Minus-/Plus-Buttons | F-22, F-24 | 003, 004 |
| 018 | Visuelles Entscheidungsfeedback v1.1 | Grüner Haken/Punkte und rotes Kreuz | F-21 | 010 |
| 019 | Ladefehler-Recovery | „Erneut laden“ in allen Monsterphasen | F-23 | 005, 006, 008, 009 |
| 020 | Integration und Abnahme v1.1 | v1.1-Komponenten gemeinsam prüfen | F-18 bis F-24 | 015 bis 019 |
| 021 | Replay-Layoutstabilisierung | Root-/Volume-Layout stabilisieren und Replay-Schrumpfen beseitigen | F-25 | 001, 004, 008, 009, 011, 020 |
| 022 | Punktekommunikation v1.2 | Ergebnis als „X Punkte“ und falsches Feedback mit „0 Punkte“ | F-26, F-27 | 011, 018 |
| 023 | Teamstation-Symbole v1.2 | Historische semantische Symbole zusätzlich zu Teamtexten | F-28 | 009, 020 |
| 024 | Debug-UI-Isolation | DEV-Schaltfläche aus dem normalen App-Flow entfernen | F-29 | 009, 020 |
| 025 | Monster-Farbvarianten | 16 Varianten, sitzungsstabile Auswahl und deterministische Tests | F-30 | 002, 003, 005, 019, 020 |
| 026 | Integration und Abnahme v1.2 | Replay, Farbvarianten, Punktekommunikation, Teamdarstellung und Debug-Isolation prüfen | F-25 bis F-30 | 021 bis 025 |
| 027 | Neue Ticketdaten und 16er-Sitzung | TT-001 bis TT-016 aus der bereitgestellten Markdown-Datei übernehmen, Referenzmatrix prüfen und Auswahlbereich 1...16 aktualisieren | F-01, F-02, F-03, F-04, F-22, F-31 | 002, 003, 017, 026 |
| 028 | Teamlogos v1.3 | Bisherige Team-Symbole durch vier bereitgestellte JPEG-Logos ersetzen, Text und Drop-Geometrie beibehalten, Assets sauber strukturieren | F-28, F-39 | 009, 023, 026 |
| 029 | Monster- und Streak-Audio | 8 Monster-Sounds und 2 Streak-Sounds integrieren, zufällige Auswahl und Streak-Mapping implementieren | F-12, F-34, F-35, F-39 | 010, 026 |
| 030 | Ticketvideo-System | Video-Referenz ins Ticketmodell integrieren, 16 MP4s strukturieren, Videoansicht, Auto-Start nach Aktion, manuelles/automatisches Schließen und Fehlerfall umsetzen | F-03, F-32, F-33, F-39 | 006, 027 |
| 031 | Streak-State und Scoring | Streak im zentralen Zustand ergänzen, Resetregeln und zentrale Multiplikator-/Differenzberechnung implementieren | F-11, F-16, F-36, F-37 | 003, 010, 027 |
| 032 | Streak-Feedback v1.3 | Teamabschluss um x2/x3-Overlay, stärkere x4+-Darstellung, Zusatzpunkteanzeige und Streak-Soundtrigger ergänzen | F-18, F-21, F-35, F-38 | 018, 022, 029, 031 |
| 033 | Integration und Abnahme v1.3 | 16 Tickets/Videos, Teamlogos, Audiozufall, Streak-Scoring, Reset, Replay und Regression gegen v1.2 vollständig prüfen und Versionsreport erstellen | F-01 bis F-39, Schwerpunkt F-31 bis F-39 | 027 bis 032 |

## 6. Technische Constraints

- Zielplattform bleibt Apple Vision Pro / visionOS unter der bestehenden Xcode-Konfiguration.
- Swift, SwiftUI, RealityKit, Observation und bestehende Apple-Frameworks bleiben Grundlage; für lokale Videowiedergabe darf AVKit ergänzt werden.
- Genau ein zentrales Volume; kein Immersive Space und keine zusätzlichen Fenster als neue Produktnavigation.
- `SessionModel` bleibt einzige fachliche Zustandsquelle. Streak und Score dürfen nicht als konkurrierende lokale View-Zustände geführt werden.
- Tickettexte werden aus `Tickets/Ticket-Tamer_Tickets.md` manuell/strukturiert in den lokalen Swift-Katalog übertragen; die Markdown-Datei wird nicht zur Laufzeit geparst.
- Die Ticketanzahlgrenze beträgt 1...16, Standardwert 6.
- Alle 16 Videos sind lokale MP4-Ressourcen und werden 1:1 über Ticket-ID zugeordnet.
- Video startet nur nach Benutzeraktion auf „Video ansehen“; nach Öffnung startet die Wiedergabe automatisch.
- Video darf Score, Streak, Phase oder Ticketindex nicht verändern.
- Teamlogos sind lokale JPEG-Ressourcen und ersetzen die bisherigen Symbole, nicht die Textbezeichnungen.
- Monster-Feedbackaudio umfasst 4 Correct- und 4 Incorrect-WAV-Dateien; Auswahl pro Einzelentscheidung zufällig.
- Streak-Audio umfasst zwei lokale WAV-Dateien: 01 für x2/x3, 02 für x4+.
- Keine Anti-Wiederholungslogik für Feedbacksounds.
- Das Streak-System besitzt keinen künstlichen Cap; Sitzungsgröße begrenzt es praktisch auf 16.
- Die Punkteberechnung muss zentral und Exactly-once-sicher bleiben. Insbesondere darf die Differenzgutschrift beim Teamabschluss nicht zu Doppelzählungen führen.
- Multiplikatoranzeige erscheint ausschließlich beim Teamabschluss vollständig korrekter Tickets ab Streak 2 und ist nicht dauerhaft im HUD sichtbar.
- x4+ muss sichtbar stärker als x2/x3 dargestellt werden; Partikeleffekte sind nicht erforderlich.
- Bestehende Replay-Layoutstabilisierung aus v1.2 darf durch Video-, Logo- oder Streak-Overlays nicht regressieren.
- Bestehende 50-%-Drop-Regel, Z-Toleranz, Snapback, Monster-Farbvarianten und Retry-Verhalten bleiben unverändert.
- Ressourcen sollen in klaren Ordnern für `Audio/MonsterSounds`, `Audio/StreakSounds`, `TeamLogos` und `Videos` liegen und über zentrale Provider/Mappings referenziert werden.
- Neue Tests verwenden weiterhin Swift Testing und sollen Zufalls-/Scoringlogik ohne laufenden Render-Loop prüfbar halten.
- [Annahme] Die bereitgestellten Audio-, Video- und Logoassets besitzen kompatible Formate und dürfen in der Abgabe verwendet werden.

## 7. Offene Fragen

- [Offen] Die exakten Dateinamen der acht Monster-Sounds, zwei Streak-Sounds und vier JPEG-Teamlogos sind in dieser Strategieunterlage nicht benannt; Modul 028/029 übernimmt die vorhandenen Dateien aus den bereitgestellten Ordnern und dokumentiert das endgültige Mapping.
- [Offen] Die konkrete SwiftUI-/AVKit-Darstellung der Videoansicht (`VideoPlayer`, Sheet/Overlay oder funktional gleichwertige Lösung innerhalb des bestehenden Volumes) wird in Modul 030 anhand der vorhandenen visionOS-UI festgelegt. Das definierte Verhalten aus F-32/F-33 ist verbindlich.
- [Offen] Die exakten Scale-/Animationswerte für die stärkere x4+-Darstellung werden in Modul 032 visuell abgestimmt; verbindlich ist, dass x4+ eindeutig prägnanter als x2/x3 erscheint und keine restliche UI verdeckt.
