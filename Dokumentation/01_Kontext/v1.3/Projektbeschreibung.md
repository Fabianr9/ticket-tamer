# Projektbeschreibung — Ticket Tamer

> **Funktion.** Der Nordstern des Projekts: Was bauen wir, für wen, warum? Entscheidet im Zweifel über Scope.
> Ausfüllen und als Projekt-Kontext hinterlegen. Lebt mit — Änderungen im Projektlogbuch vermerken.

## Einzeiler

Ticket Tamer ist ein visionOS-Trainingsspiel, in dem Support-Tickets als Monster untersucht, priorisiert und dem zuständigen IT-Support-Team zugeordnet werden; Version 1.3 erweitert den stabilen v1.2-Stand um neue Tickets und Medienassets, optionale Ticketvideos sowie ein Streak-/Multiplikator-System.

## Vision / Zweck

Ticket Tamer überträgt die Ticket-Triage aus dem IT-Support in eine räumliche, spielerische Trainingssituation auf Apple Vision Pro. Nutzende bearbeiten nacheinander Supportfälle, lesen die relevanten Ticketinformationen, bewerten die Dringlichkeit und ordnen den Fall dem passenden Support-Team zu.

Die Anwendung soll den grundlegenden Triage-Ablauf praktisch erfahrbar machen und ohne separates Tutorial verständlich bedienbar bleiben. Die räumliche Interaktion erfolgt über Blickfokus, Pinch und Drag innerhalb eines einzigen zentralen Volumes.

Version 1.0 etablierte den linearen Kernablauf, lokale Ticketdaten, räumliche Priorisierung und Teamzuordnung, Scoring, Audiofeedback, Ergebnisansicht und Reset. Version 1.1 ergänzte unter anderem Session-HUD, kompakte Ticketinformationen, Interaktionshinweise, visuelles Feedback, präzisere Ticketanzahlsteuerung, Ladefehler-Recovery und eine kurze Startbeschreibung. Version 1.2 stabilisierte den Replay-Ablauf, verbesserte Punktekommunikation und Teamdarstellung, isolierte Debug-UI und machte alle 16 Monster-Farbvarianten nutzbar.

Version 1.3 erweitert diesen Stand gezielt, ohne die grundlegende Navigation oder räumliche Kerninteraktion neu aufzubauen. Der bisherige Ticketpool wird vollständig durch 16 neue, humorvollere und dennoch eindeutig lösbare Tickets ersetzt. Jedes Ticket besitzt ein eigenes lokales Video, das auf Wunsch abgespielt werden kann. Die bisherigen Team-Symbole werden durch vier bereitgestellte Teamlogos ersetzt. Für richtiges und falsches Feedback stehen jeweils vier neue Monster-Sounds zur Verfügung, aus denen zufällig ausgewählt wird. Zusätzlich führt v1.3 ein Streak-System ein: Nur vollständig korrekt gelöste Tickets erhöhen die Streak; ab dem zweiten vollständig korrekten Ticket in Folge werden die Punkte des gesamten Tickets mit der aktuellen Streak-Stufe multipliziert.

Die bestehenden Regeln für einzelne Entscheidungen bleiben erhalten: Eine richtige Priorität ist 100 Basispunkte wert, ein richtiges Team ebenfalls 100 Basispunkte. Teilweise richtige Tickets erhalten weiterhin ihre normalen Einzelpunkte, setzen die Streak aber vollständig zurück und erhalten keinen Multiplikator.

## Zielgruppe

Die Anwendung richtet sich an:

- neue Mitarbeitende im IT-Support,
- Werkstudierende im IT-Support,
- Teilnehmende an Onboarding- oder Schulungssituationen,
- Personen, die grundlegende Entscheidungen der Ticket-Triage kennenlernen oder üben möchten.

Eine Spielsitzung besteht aus einer vor Spielbeginn gewählten Anzahl von 1 bis 16 Tickets. Der Standardwert bleibt 6. Videos sind rein optional und nicht erforderlich, um ein Ticket korrekt lösen zu können.

## Kernfunktionen (Scope)

Die Dinge, die das Projekt können *muss*:

1. Die Startansicht zeigt Projekttitel, Kurzbeschreibung, einen Slider von 1 bis 16 Tickets, Minus-/Plus-Buttons, Standardwert 6 und „Spiel starten“.
2. Eine Sitzung wählt die gewünschte Anzahl zufälliger Tickets ohne Wiederholung aus einem lokalen Pool von genau 16 neuen Tickets aus.
3. TT-001 bis TT-012 bilden weiterhin die vollständige 4×3-Matrix aus vier Teams und drei Prioritätsstufen. TT-013 bis TT-016 erweitern diese Matrix auf insgesamt 16 Fälle.
4. Die Gesamtverteilung der 16 Tickets beträgt je 4 Tickets für Netzwerk, Konto, Software und Hardware sowie 5× Normal, 6× Wichtig und 5× Kritisch.
5. Jedes Ticket besitzt Ticketnummer, Titel, Kurzbeschreibung, User Impact, ein bis drei Symptome beziehungsweise Hinweise, genau eine Referenzpriorität, genau ein Referenzteam und eine feste lokale Video-Referenz.
6. Die verbindlichen neuen Tickettexte werden aus `Tickets/Ticket-Tamer_Tickets.md` in den lokalen Ticketkatalog übernommen; die bisherigen Ticketinhalte werden vollständig ersetzt.
7. Der grundlegende Ablauf bleibt linear in einem zentralen Volume: Start → Untersuchen → Priorisieren → Team zuordnen → nächstes Ticket → Ergebnis.
8. Beim Untersuchen werden Monster und vollständige Ticketinformationen wie bisher angezeigt. Zusätzlich ist eine Aktion „Video ansehen“ verfügbar.
9. „Video ansehen“ öffnet ausschließlich das Video des aktuellen Tickets. Die Wiedergabe startet nach der Benutzeraktion automatisch, kann pausiert beziehungsweise fortgesetzt und jederzeit per `X` geschlossen werden.
10. Nach regulärem Videoende schließt sich die Videoansicht automatisch. Danach befindet sich die nutzende Person wieder beim selben Ticket; Score, Streak und Ticketzustand bleiben durch das Ansehen unverändert.
11. Wenn ein Video fehlt oder nicht geladen werden kann, bleibt die App stabil, zeigt eine verständliche Fehlermeldung und lässt das Ticket weiterhin normal bearbeiten.
12. Die 16 Videos liegen lokal vor und sind eindeutig als `TT-001.mp4` bis `TT-016.mp4` den gleichnamigen Tickets zugeordnet.
13. Die vier Teamstationen verwenden die bereitgestellten JPEG-Teamlogos für Netzwerk, Konto, Software und Hardware. Der Teamname bleibt zusätzlich immer sichtbar; Drop-Geometrie und Teamlogik ändern sich dadurch nicht.
14. Für richtige Entscheidungen stehen vier neue lokale Monster-Sounds zur Verfügung, für falsche Entscheidungen ebenfalls vier. Bei jeder gültigen Einzelentscheidung wird zufällig genau ein Sound der passenden Gruppe abgespielt.
15. Direkte Wiederholungen desselben Monster-Sounds sind zulässig; es wird keine Anti-Wiederholungslogik eingeführt.
16. Bei vollständig korrekten Tickets wird eine Streak geführt. Ein Ticket erhöht die Streak ausschließlich dann, wenn Priorität **und** Team richtig sind.
17. Ein teilweise oder vollständig falsches Ticket setzt die Streak auf 0. Das nächste vollständig korrekte Ticket beginnt wieder bei Streak 1.
18. Die Streak hat keinen künstlichen Cap. Durch maximal 16 Tickets pro Sitzung ist praktisch höchstens Streak 16 möglich.
19. Die normale Einzelwertung bleibt erhalten: richtige Priorität = 100 Punkte, richtiges Team = 100 Punkte, falsche Einzelentscheidung = 0 Punkte.
20. Ein vollständig korrektes Ticket erhält `200 × aktuelle Streak` Punkte. Streak 1 ergibt 200 Punkte, Streak 2 ergibt 400 Punkte, Streak 3 ergibt 600 Punkte usw.
21. Da die Prioritätsentscheidung weiterhin sofort bewertet wird, werden bei einem vollständig korrekten Streak-Ticket die noch fehlenden Punkte bei der Teamentscheidung gutgeschrieben. Beispiel: Streak 2 → Priorität `+100`, Teamabschluss `+300`, insgesamt 400 Punkte.
22. Ein teilweise richtiges Ticket erhält ausschließlich seine normalen Einzelpunkte und keinen Multiplikator. Beispiel: Priorität richtig, Team falsch → insgesamt 100 Punkte und Streak 0.
23. Der Streak-Multiplikator wird nicht dauerhaft im HUD angezeigt. Er erscheint ausschließlich nach einer richtigen Teamzuordnung, wenn dadurch ein vollständig korrektes Ticket mit Streak ≥ 2 abgeschlossen wird, und wird anschließend wieder ausgeblendet.
24. `x2` und `x3` erscheinen als normales deutlich sichtbares Streak-Overlay. Ab `x4` wird die Anzeige sichtbar größer und durch eine kurze zusätzliche Puls-/Scale-Animation prägnanter dargestellt. Für `x5` und höher wird dieselbe stärkere Darstellungslogik verwendet.
25. Zusätzlich zu einem zufälligen positiven Monster-Sound wird bei Streak x2 oder x3 der bereitgestellte Streak-Sound 01 und bei x4 oder höher der Streak-Sound 02 abgespielt. Die Sounds werden leicht zeitversetzt beziehungsweise nacheinander wiedergegeben und nicht störend gleichzeitig überlagert.
26. Bei einer neuen Sitzung, nach „Erneut spielen“ und nach Rückkehr zur Startansicht wird die Streak immer vollständig auf 0 zurückgesetzt.
27. Die Ergebnisansicht bleibt minimal und zeigt weiterhin nur `X Punkte` sowie „Erneut spielen“; es werden keine Streak-Statistiken ergänzt.
28. Die bisherigen v1.2-Funktionen – Replay-Layoutstabilität, Session-HUD, kompakte Ticketinfo, Drag-Hinweise, Retry, Monster-Farbvarianten, Exactly-once-Logik, Drop-Regeln und grundlegende Navigation – bleiben funktionsfähig.

## Nicht-Ziele (Out of Scope)

Bewusst *nicht* Teil des Projekts beziehungsweise der v1.3-Erweiterung:

- mehrere Spiel-, Lern- oder Challenge-Modi,
- ein vollständiger Immersive Space oder mehrere Volumes,
- Zeitmessung oder Stoppuhr,
- dauerhafte Anzeige des Streak-Multiplikators im Session-HUD,
- Best-Streak-, Streak-Historie oder Streak-Statistik in der Ergebnisansicht,
- ein künstliches Streak-Maximum unterhalb der durch die Sitzungsgröße entstehenden Grenze,
- automatische Videowiedergabe ohne vorherige Benutzeraktion auf „Video ansehen“,
- Pflicht zum Anschauen eines Videos vor der Bearbeitung,
- Streaming, Cloud-Hosting oder externe Video-URLs,
- Untertitel-, Schnitt- oder Bearbeitungsfunktionen für Videos,
- ein Companion-Assistent,
- ein ausführliches Tutorial oder persistente Tutorialverwaltung,
- Anzeige der richtigen Lösung oder einer textlichen Begründung,
- detaillierte Ergebnisstatistiken, Fehlerlisten, Badges, Ranglisten oder Prozentwerte,
- Benutzerkonten, Datenbank, Cloud-Anbindung oder dauerhafte Spielhistorie,
- Import aus einem echten Ticketsystem oder externe APIs,
- Änderungen an den vier Teams oder den drei Prioritätsstufen,
- Änderungen an der 50-%-Drop-Regel, Z-Toleranz, Snapback oder Exactly-once-Semantik,
- Anti-Wiederholungslogik für zufällige Monster-Sounds,
- komplexe Partikeleffekte für Streaks,
- Neuimplementierung der Monster-Auswahl oder der in v1.2 eingeführten Farbvariantenlogik.

## Rahmenbedingungen

- **Plattform / Stack:** Apple Vision Pro, visionOS 26.5, Xcode-26.5/26.6-kompatibler Projektstand, Swift, SwiftUI, RealityKit, Observation, AVFoundation; für die Videoansicht kann AVKit verwendet werden
- **Projektversion:** v1.0, v1.1 und v1.2 abgeschlossen; v1.3 ist die aktuelle Erweiterungsstufe
- **Zeitbudget / Abgabe:** Studienprojekt; bestehender stabiler Stand soll gezielt erweitert statt neu aufgebaut werden
- **Werkzeuge:** Xcode, GitHub, Blender/RealityKitContent sowie bereitgestellte lokale Medienassets
- **Datenhaltung:** vollständig lokal; keine Benutzerkonten, Datenbank oder Cloud
- **Ticketdaten:** `Tickets/Ticket-Tamer_Tickets.md` ist die verbindliche Inhaltsquelle für TT-001 bis TT-016; zur Laufzeit wird weiterhin der lokale Swift-Ticketkatalog verwendet
- **Videos:** 16 lokale MP4-Dateien `TT-001.mp4` bis `TT-016.mp4`
- **Audio:** 4 Correct-Monster-Sounds, 4 Incorrect-Monster-Sounds und 2 Streak-Sounds als lokale WAV-Dateien
- **Teamlogos:** 4 lokale JPEG-Dateien aus dem bereitgestellten Ordner `teamslogos`
- **Monster:** bestehende vier Monstertypen und 16 v1.2-Farbvarianten bleiben erhalten
- **[Annahme]** Alle bereitgestellten WAV-, JPEG- und MP4-Dateien dürfen im Studienprojekt verwendet und zusammen mit der App ausgeliefert werden.

Empfohlene Ressourcenstruktur im App-Target beziehungsweise einem passenden lokalen Ressourcenbereich:

```text
Resources/
├── Audio/
│   ├── MonsterSounds/
│   │   ├── Correct/
│   │   └── Incorrect/
│   └── StreakSounds/
├── TeamLogos/
└── Videos/
    ├── TT-001.mp4
    ├── ...
    └── TT-016.mp4
```

Die Quelldatei mit den neuen Tickettexten bleibt als Dokumentations-/Eingaberessource getrennt vom Laufzeitmodell:

```text
Tickets/
└── Ticket-Tamer_Tickets.md
```

## Erfolgsbild

Version 1.3 ist gelungen, wenn eine Person eine Sitzung mit 1 bis 16 Tickets vollständig durchspielen kann und dabei alle bisherigen v1.2-Funktionen stabil bleiben. Die 16 neuen Tickets sind korrekt integriert und eindeutig lösbar, jedes Ticket kann auf Wunsch sein eigenes lokales Video abspielen, neue Teamlogos und zufällige Monster-Sounds funktionieren, und das Streak-System berechnet Punkte nachvollziehbar und ohne Doppelwertung.

Ein vollständig korrektes zweites, drittes beziehungsweise viertes Ticket in Folge muss sichtbar und rechnerisch korrekt als x2, x3 beziehungsweise x4 behandelt werden; Fehler setzen die Streak zurück. Die Videoansicht schließt nach regulärem Ende automatisch, kann jederzeit manuell beendet werden und beeinflusst den fachlichen Sitzungszustand nicht. Nach „Erneut spielen“ beginnt eine neue Sitzung wieder mit Streak 0 und dem stabilen v1.2-Replay-Layout.
