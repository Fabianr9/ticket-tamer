# Projektbeschreibung — Ticket Tamer

> **Funktion.** Der Nordstern des Projekts: Was bauen wir, für wen, warum? Entscheidet im Zweifel über Scope.
> Ausfüllen und als Projekt-Kontext hinterlegen. Lebt mit — Änderungen im Projektlogbuch vermerken.

## Einzeiler

Ticket Tamer ist ein visionOS-Trainingsspiel, in dem Support-Tickets als Monster untersucht, priorisiert und dem zuständigen IT-Support-Team zugeordnet werden; Version 1.2 stabilisiert den Replay-Ablauf und ergänzt gezielte visuelle sowie technische Usability-Verbesserungen.

## Vision / Zweck

Ticket Tamer überträgt die Ticket-Triage aus dem IT-Support in eine räumliche, spielerische Trainingssituation auf Apple Vision Pro. Nutzende bearbeiten nacheinander realitätsnahe Supportfälle, lesen die relevanten Ticketinformationen, bewerten die Dringlichkeit und ordnen den Fall dem passenden Support-Team zu.

Die Anwendung soll den grundlegenden Triage-Ablauf praktisch erfahrbar machen und dabei ohne separate Spielanleitung verständlich bedienbar sein. Die räumliche Interaktion erfolgt über Blickfokus, Pinch und Drag innerhalb eines einzigen zentralen Volumes.

Version 1.1 ergänzte den stabilen v1.0-Kern um kompakte Ticketinformationen während der Entscheidungsphasen, Sitzungs-HUD und Fortschrittsbalken, dauerhafte Interaktionshinweise, visuelles Entscheidungsfeedback, Minus-/Plus-Steuerung der Ticketanzahl, Ladefehler-Recovery und eine kurze Startseitenbeschreibung.

Version 1.2 baut auf diesem abgeschlossenen Stand auf. Im Mittelpunkt stehen ein reproduzierbarer Replay-Layoutfehler und fünf kleine Erweiterungen mit hohem Nutzwert: Die sichtbare Größe des zentralen Volumes und seiner Inhalte muss über wiederholte Spielsitzungen stabil bleiben, die Ergebniszahl erhält die Einheit „Punkte“, falsche Entscheidungen zeigen zusätzlich „0 Punkte“, Teamstationen werden neben Text auch durch Symbole unterstützt, die DEV-Schaltfläche wird aus dem normalen App-Ablauf entfernt und alle 16 bereits vorhandenen Monster-Farbvarianten werden nutzbar gemacht.

Die Kernlogik bleibt unverändert: Scoring, Drop-Regel, Exactly-once-Semantik, lineare Phasenfolge, lokale Ticketdaten und die grundsätzliche Drag-&-Drop-Interaktion werden durch v1.2 nicht fachlich verändert.

## Zielgruppe

Die Anwendung richtet sich an:

- neue Mitarbeitende im IT-Support,
- Werkstudierende im IT-Support,
- Teilnehmende an Onboarding- oder Schulungssituationen,
- Personen, die grundlegende Entscheidungen der Ticket-Triage kennenlernen oder üben möchten.

Eine Spielsitzung besteht aus einer vor Spielbeginn gewählten Anzahl von 1 bis 12 Tickets. Die Anwendung soll auch für Personen verständlich sein, die Ticket Tamer zum ersten Mal auf Apple Vision Pro verwenden.

## Kernfunktionen (Scope)

Die Dinge, die das Projekt können *muss*:

1. Eine Startansicht zeigt den Projekttitel, die Kurzbeschreibung „Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.“, einen Regler für 1 bis 12 Tickets mit Standardwert 6, ergänzende Minus-/Plus-Buttons und die Schaltfläche „Spiel starten“.
2. Eine Sitzung wählt die gewünschte Anzahl zufälliger Tickets ohne Wiederholung aus einem lokalen Pool von genau 12 selbst erstellten Tickets aus.
3. Jedes Ticket enthält Ticketnummer, Titel, Kurzbeschreibung, User Impact, ein bis drei Symptome beziehungsweise Hinweise sowie feste Referenzwerte für Priorität und Support-Team.
4. Die Sitzung läuft linear innerhalb eines zentralen visionOS-Volumes ab: Start, Ticket untersuchen, priorisieren, Team zuordnen, nächstes Ticket und abschließende Ergebnisansicht.
5. Beim Untersuchen werden das Ticket-Monster und eine gut lesbare Ticketkarte mit allen notwendigen Ticketinformationen angezeigt.
6. In den Phasen Untersuchen, Priorisieren und Team zuordnen ist ein kompaktes Sitzungs-HUD sichtbar. Es zeigt „Ticket X von Y“, die aktuelle Phase und einen schmalen Fortschrittsbalken, aber keinen Score.
7. In Priorisierung und Teamzuordnung kann über einen Info-Button eine kompakte Ticketübersicht geöffnet werden. Sie zeigt Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptome beziehungsweise Hinweise, aber niemals Referenzpriorität oder Referenzteam.
8. Während die kompakte Ticketübersicht geöffnet ist, ist die räumliche Drag-Interaktion der verdeckten 3D-Szene deaktiviert. Das Overlay kann über „X“ oder erneutes Aktivieren des Info-Buttons geschlossen werden und wird beim Phasenwechsel automatisch geschlossen.
9. Die Priorität wird räumlich gewählt, indem das Monster per Blickfokus, Pinch und Drag auf eines der Ziele „Normal“, „Wichtig“ oder „Kritisch“ bewegt wird.
10. Das zuständige Team wird räumlich gewählt, indem das Monster auf eine der Stationen „Netzwerk“, „Konto“, „Software“ oder „Hardware“ bewegt wird.
11. In der Priorisierungsphase ist dauerhaft der Hinweis „Monster greifen und auf eine Priorität ziehen.“ sichtbar. In der Teamphase ist dauerhaft der Hinweis „Monster greifen und dem zuständigen Team zuordnen.“ sichtbar.
12. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug.
13. Richtige und falsche Entscheidungen werden durch zwei unterschiedliche lokale Sounds und ein sichtbares Overlay signalisiert. Eine richtige Entscheidung zeigt einen grünen Haken mit „+100 Punkte“. Eine falsche Entscheidung zeigt ein rotes Kreuz mit „0 Punkte“.
14. Die visuelle Rückmeldung zeigt weder die richtige Lösung noch eine Begründung und verändert weder Scoring noch Exactly-once-Verhalten oder automatischen Phasenwechsel.
15. Nach einer gültigen Entscheidung wird die Eingabe kurz gesperrt und der Ablauf nach ungefähr 1,5 Sekunden automatisch fortgesetzt.
16. Vier selbst erstellte Monstertypen werden als lokale RealityKit-kompatible 3D-Assets verwendet. Für jeden Monstertyp stehen vier vorhandene Farbvarianten zur Verfügung, insgesamt 16 ladbare Monster-Assets.
17. Für jedes Sitzungsticket wird eine konkrete Monster-Farbvariante ausgewählt. Diese Auswahl bleibt in Untersuchung, Priorisierung, Teamzuordnung und bei „Erneut laden“ unverändert; eine neue Sitzung darf neu auswählen.
18. Farbe und Monstertyp dürfen keinen eindeutigen Rückschluss auf richtige Priorität, richtiges Team oder Richtigkeit einer Entscheidung ermöglichen.
19. Bei einem Monster-Ladefehler wird in Untersuchung, Priorisierung und Teamzuordnung eine sichtbare Aktion „Erneut laden“ angeboten. Der Wiederholungsversuch lädt ausschließlich dieselbe für das Ticket ausgewählte Monster-Variante neu und verändert weder Sitzung, Score noch Zielszene.
20. Die vier Teamstationen zeigen zusätzlich zu ihrer Textbezeichnung jeweils ein einfaches, eindeutig passendes Symbol. Der Text bleibt immer sichtbar und Farbe ist nicht das alleinige Bedeutungsmerkmal.
21. Die Ergebnisansicht zeigt die erreichte Gesamtpunktzahl mit der Einheit „Punkte“, zum Beispiel „600 Punkte“, und die Schaltfläche „Erneut spielen“. Es werden keine zusätzlichen Ergebnisstatistiken ergänzt.
22. „Erneut spielen“ führt zurück zur Startansicht, setzt die fachliche Sitzung vollständig zurück und stellt die Ticketanzahl wieder auf 6.
23. Beim Replay bleibt die aktuell verwendete Volume-Größe erhalten. Startansicht, Slider, Texte, Prioritätsziele und Teamziele dürfen sich allein durch den Wechsel Ergebnis → „Erneut spielen“ nicht verkleinern, vergrößern oder über mehrere Durchläufe driften.
24. Der Replay-Ablauf muss mindestens fünf vollständige aufeinanderfolgende Sitzungen ohne zunehmende Layoutveränderung bestehen.
25. Die Entwicklungs-Schaltfläche `🔧 Team [DEV]` erscheint nicht mehr im normalen App-Ablauf, auch nicht in einem regulären Debug-Build. Debug-Funktionalität bleibt ausschließlich im vorhandenen Debug-Harness beziehungsweise in explizit dafür vorgesehenen Debug-Kontexten verfügbar.
26. [Kann] Eine spätere Version kann zusätzliche Monster-Gesichts- oder Bewegungsreaktionen, Grab-Glow oder weitere Drag-Rückmeldungen ergänzen. Diese Funktionen sind nicht Bestandteil des Pflichtumfangs von v1.2.

## Nicht-Ziele (Out of Scope)

Bewusst *nicht* Teil des Projekts beziehungsweise der v1.2-Erweiterung:

- mehrere Spiel-, Lern- oder Challenge-Modi,
- ein vollständiger Immersive Space oder mehrere Volumes,
- Zeitmessung, Stoppuhr, Streaks oder ein sichtbarer Gesamtpunktestand während der Sitzung,
- ein Companion-Assistent,
- ein ausführliches Tutorial, „So funktioniert’s“-Popover oder persistente Tutorialverwaltung,
- Anzeige der richtigen Lösung oder einer textlichen Begründung,
- detaillierte Ergebnisstatistiken, Fehlerlisten, Badges, Ranglisten, Prozentwerte oder Verbesserungshinweise,
- Sitzungs-Presets wie „kurz“, „normal“ oder „intensiv“,
- zusätzliche Beschriftung des bestehenden Info-Buttons mit „Ticket anzeigen“,
- neues Grab-/Glow-Feedback beim Greifen des Monsters,
- neue Textmeldung bei einem ungültigen Drop,
- vollständiger Lokalisierungs-Refactor aller bereits bestehenden sichtbaren Texte,
- Benutzerkonten, Datenbank, Cloud-Anbindung oder dauerhafte Spielhistorie,
- Import aus einem echten Ticketsystem oder eine externe API,
- SLA-Countdown, Aktivitätsverlauf, Bearbeiter, Kommentare oder Anhänge,
- Spracheingabe, Controller-Unterstützung oder alternative 2D-Steuerung für Priorisierung und Teamzuordnung,
- Änderungen an 50-%-Drop-Regel, Z-Toleranz, Snapback, Scoring oder Exactly-once-Semantik,
- komplexe Physiksimulationen,
- verpflichtende fröhliche oder traurige Monsteranimationen.

## Rahmenbedingungen

- **Plattform / Stack:** Apple Vision Pro, visionOS Deployment Target 26.5, Xcode 26.5/26.6 kompatibler Projektstand, Swift, SwiftUI, RealityKit, Observation, AVFoundation
- **Projektversion:** v1.0 = abgeschlossener Kernstand; v1.1 = abgeschlossene Usability-Erweiterung; v1.2 = aktuelle Replay-/UX-Erweiterung
- **Zeitbudget:** Abgabe am 27.09.2026; drei Studierende; ungefähr 3 bis 4 gemeinsame Arbeitsstunden pro Woche zuzüglich individueller Vorbereitung
- **Werkzeuge / Bibliotheken:** Xcode, GitHub, Blender, Reality Composer Pro sowie Apple-Systemframeworks; keine externen Third-Party-Abhängigkeiten
- **Abgabeform:** Xcode-Projekt + KI-Dokumentation
- **Sprache:** Benutzeroberfläche und Tickettexte auf Deutsch
- **3D-Assets:** Vier selbst erstellte Monstertypen mit jeweils vier vorhandenen Farbvarianten, insgesamt 16 lokale USDC-/RealityKit-kompatible Assets
- **Datenhaltung:** Lokale statische Ticketdaten; Sitzungszustand und ausgewählte Monster-Variante nur für die laufende Sitzung im Arbeitsspeicher
- **Testumgebung:** visionOS-Simulator und verfügbare Apple Vision Pro
- **Architektur:** `SessionModel` bleibt die einzige Source of Truth für den fachlichen Sitzungszustand; die pro Ticket ausgewählte Monster-Variante ist sitzungsbezogener Zustand und wird nicht persistent gespeichert
- **Replay-Layout:** Die aktuelle vom System beziehungsweise Nutzer verwendete Volume-Größe wird beim Replay beibehalten; `.defaultSize` dient nicht als erzwungener Reset auf eine feste Größe
- **[Annahme]** v1.1 einschließlich aller bisherigen Pflicht-Akzeptanzkriterien gilt als abgeschlossen und bildet die stabile Ausgangsbasis für v1.2.
- **[Annahme]** Alle 16 vorhandenen Monster-Farbvarianten sind eigene beziehungsweise rechtlich nutzbare Projektassets und können in das lokale `RealityKitContent`-Package übernommen werden.

## Erfolgsbild

Version 1.2 ist gelungen, wenn eine Person Ticket Tamer mehrfach hintereinander auf Apple Vision Pro beziehungsweise im visionOS-Simulator durchspielen kann, ohne dass Startansicht, Slider oder 3D-Zielpanels nach „Erneut spielen“ ihre sichtbare Größe verändern. Das aktuelle Volume darf dabei seine vom Nutzer verwendete Größe behalten.

Die Ergebnisansicht zeigt eindeutig „X Punkte“, richtige und falsche Entscheidungen kommunizieren ihre Punktwirkung symmetrisch über `+100 Punkte` beziehungsweise `0 Punkte`, und die Teamstationen sind durch Text plus Symbol schnell erfassbar. Alle 16 Monster-Farbvarianten sind grundsätzlich ladbar; ein Ticket behält seine gewählte Variante durch alle drei Bearbeitungsphasen und bei Retry, während eine neue Sitzung neue Varianten auswählen darf. Der normale App-Ablauf bleibt frei von der DEV-Schaltfläche. Alle bisherigen Kernfunktionen aus v1.0 und v1.1 funktionieren weiterhin ohne Regression.
