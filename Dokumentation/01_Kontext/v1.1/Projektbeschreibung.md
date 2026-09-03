# Projektbeschreibung — Ticket Tamer

> **Funktion.** Der Nordstern des Projekts: Was bauen wir, für wen, warum? Entscheidet im Zweifel über Scope.
> Ausfüllen und als Projekt-Kontext hinterlegen. Lebt mit — Änderungen im Projektlogbuch vermerken.

## Einzeiler

Ticket Tamer ist ein visionOS-Trainingsspiel, in dem Support-Tickets als Monster untersucht, priorisiert und dem zuständigen IT-Support-Team zugeordnet werden; Version 1.1 ergänzt den stabilen v1.0-Kern um gezielte Usability-Verbesserungen.

## Vision / Zweck

Ticket Tamer überträgt die Ticket-Triage aus dem IT-Support in eine räumliche, spielerische Trainingssituation auf Apple Vision Pro. Nutzende bearbeiten nacheinander realitätsnahe Supportfälle, lesen die relevanten Ticketinformationen, bewerten die Dringlichkeit und ordnen den Fall dem passenden Support-Team zu.

Die Anwendung soll den grundlegenden Triage-Ablauf praktisch erfahrbar machen und dabei ohne separate Spielanleitung verständlich bedienbar sein. Die räumliche Interaktion erfolgt über Blickfokus, Pinch und Drag innerhalb eines einzigen zentralen Volumes.

Version 1.1 erweitert den bereits vorhandenen v1.0-Funktionskern ausschließlich um kleine, risikoarme Usability-Verbesserungen: Ticketinformationen bleiben in den Entscheidungsphasen abrufbar, Sitzungsfortschritt und aktuelle Phase werden sichtbar, Drag-Gesten werden kurz erklärt, Entscheidungen erhalten zusätzlich zum Sound ein visuelles Feedback, die Ticketanzahl lässt sich präziser einstellen, Ladefehler können erneut angestoßen werden und die Startansicht erklärt den Spielzweck in einem Satz.

Die bestehende Spiellogik, das Scoring, die Drop-Regeln, die Exactly-once-Semantik, der lineare Ablauf und die Asset-Pipeline werden durch diese Erweiterungen nicht fachlich verändert.

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
13. Richtige und falsche Entscheidungen werden weiterhin durch zwei unterschiedliche lokale Sounds signalisiert. Zusätzlich wird während des bestehenden Feedbackfensters bei einer richtigen Entscheidung ein grüner Haken mit „+100 Punkte“ und bei einer falschen Entscheidung ein rotes Kreuz ohne Punktetext eingeblendet.
14. Die visuelle Rückmeldung zeigt weder die richtige Lösung noch eine Begründung und verändert weder Scoring noch Exactly-once-Verhalten oder automatischen Phasenwechsel.
15. Nach einer gültigen Entscheidung wird die Eingabe kurz gesperrt und der Ablauf nach ungefähr 1,5 Sekunden automatisch fortgesetzt.
16. Vier eigene Blender-Monster werden als lokale 3D-Assets eingebunden. Die Wahl des Modells darf weder das richtige Team noch die richtige Priorität verraten.
17. Bei einem Monster-Ladefehler wird in Untersuchung, Priorisierung und Teamzuordnung eine sichtbare Aktion „Erneut laden“ angeboten. Der Wiederholungsversuch lädt ausschließlich das aktuelle Monster neu und verändert weder Sitzung, Score noch Zielszene.
18. Die Ergebnisansicht zeigt ausschließlich die erreichte Gesamtpunktzahl als Zahl und die Schaltfläche „Erneut spielen“.
19. „Erneut spielen“ führt zurück zur Startansicht, setzt die Sitzung zurück und stellt die Ticketanzahl wieder auf den Standardwert 6.
20. [Kann] Eine spätere Version kann zusätzliche Monster-Gesichts- oder Bewegungsreaktionen ergänzen. Diese sind nicht Bestandteil des Pflichtumfangs von v1.1.

## Nicht-Ziele (Out of Scope)

Bewusst *nicht* Teil des Projekts beziehungsweise der v1.1-Erweiterung:

- mehrere Spiel-, Lern- oder Challenge-Modi,
- ein vollständiger Immersive Space oder mehrere Volumes,
- Zeitmessung, Stoppuhr, Streaks oder ein sichtbarer Punktestand während der Sitzung,
- ein Companion-Assistent,
- ein ausführliches Tutorial, „So funktioniert’s“-Popover oder persistente Tutorialverwaltung,
- Anzeige der richtigen Lösung oder einer textlichen Begründung,
- „+0 Punkte“ bei einer falschen Entscheidung,
- detaillierte Ergebnisstatistiken, Fehlerlisten, Badges, Ranglisten oder Verbesserungshinweise,
- Benutzerkonten, Datenbank, Cloud-Anbindung oder dauerhafte Spielhistorie,
- Import aus einem echten Ticketsystem oder eine externe API,
- SLA-Countdown, Aktivitätsverlauf, Bearbeiter, Kommentare oder Anhänge,
- Spracheingabe, Controller-Unterstützung oder alternative 2D-Steuerung für Priorisierung und Teamzuordnung,
- Änderungen an Drop-Regel, Scoring, Exactly-once-Semantik oder Asset-Pipeline,
- komplexe Physiksimulationen,
- verpflichtende fröhliche/traurige Monsteranimationen.

## Rahmenbedingungen

- **Plattform / Stack:** Apple Vision Pro, visionOS Deployment Target 26.5, Xcode 26.5, Swift, SwiftUI, RealityKit, Observation, AVFoundation
- **Projektversion:** v1.0 = abgeschlossener Kernstand; v1.1 = aktuelle Usability-Erweiterung
- **Zeitbudget:** Abgabe am 27.09.2026; drei Studierende; ungefähr 3 bis 4 gemeinsame Arbeitsstunden pro Woche zuzüglich individueller Vorbereitung
- **Werkzeuge / Bibliotheken:** Xcode, GitHub, Blender, Reality Composer Pro sowie Apple-Systemframeworks; keine externen Third-Party-Abhängigkeiten
- **Abgabeform:** Xcode-Projekt + KI-Dokumentation
- **Sprache:** Benutzeroberfläche und Tickettexte auf Deutsch
- **3D-Assets:** Vier eigene, lokal mitgelieferte Blender-Modelle in RealityKit-kompatiblem Format
- **Datenhaltung:** Lokale statische Ticketdaten; Sitzungszustand nur im Arbeitsspeicher
- **Testumgebung:** visionOS-Simulator und verfügbare Apple Vision Pro
- **Architektur:** `SessionModel` bleibt die einzige Source of Truth für den fachlichen Sitzungszustand; neue v1.1-UI-Zustände bleiben lokal in den betreffenden Views
- **[Annahme]** Der v1.0-Stand einschließlich AK-06 wird für diese Planungsphase als abgeschlossen und stabil behandelt.
- **[Annahme]** Die vorhandenen Feedback-Sounds und Monster-Assets bleiben unverändert nutzbar.

## Erfolgsbild

Das Projekt ist gelungen, wenn eine Person auf Apple Vision Pro eine komplette Spielsitzung ohne externe Hilfe starten und abschließen kann. Sie kann die Ticketanzahl präzise einstellen, versteht den Zweck der App bereits auf der Startseite, erkennt jederzeit aktuelles Ticket und Phase, kann bei Bedarf Ticketinformationen während der Entscheidung erneut öffnen und erhält nach jeder Entscheidung sowohl akustisches als auch sichtbares Feedback.

Die neuen Usability-Funktionen dürfen die bestehende v1.0-Spiellogik nicht verändern: Drag & Drop, Bewertung, Exactly-once-Verhalten, 1,5-Sekunden-Übergang, Scoring, Ergebnisansicht und Reset müssen weiterhin stabil funktionieren. Ladefehler müssen ohne Neustart der Sitzung erneut angestoßen werden können.
