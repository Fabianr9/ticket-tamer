# Projektbeschreibung — Ticket Tamer

> **Funktion.** Der Nordstern des Projekts: Was bauen wir, für wen, warum? Entscheidet im Zweifel über Scope.
> Ausfüllen und als Projekt-Kontext hinterlegen. Lebt mit — Änderungen im Projektlogbuch vermerken.

## Einzeiler

Ticket Tamer ist ein visionOS-Trainingsspiel, in dem Support-Tickets als Monster untersucht, priorisiert und dem zuständigen IT-Support-Team zugeordnet werden.

## Vision / Zweck

Ticket Tamer überträgt die Ticket-Triage aus dem IT-Support in eine räumliche, spielerische Trainingssituation. Nutzende bearbeiten nacheinander realitätsnahe Supportfälle, lesen die relevanten Ticketinformationen, bewerten die Dringlichkeit und ordnen den Fall dem passenden Support-Team zu.

Ziel ist eine kompakte, verständliche und auf Apple Vision Pro lauffähige Anwendung, die den grundlegenden Triage-Ablauf praktisch erfahrbar macht. Die Interaktion soll nicht nur über klassische Schaltflächen erfolgen, sondern die räumlichen Möglichkeiten von visionOS durch Blickfokus, Pinch und Drag nutzen.

Die Umsetzung konzentriert sich bewusst auf einen stabilen Kernablauf innerhalb eines einzigen zentralen Volumes. Mehrere Volumes oder ein vollständiger Immersive Space sind für den vorgesehenen Projektzeitraum nicht erforderlich.

## Zielgruppe

Die Anwendung richtet sich an:

- neue Mitarbeitende im IT-Support,
- Werkstudierende im IT-Support,
- Teilnehmende an Onboarding- oder Schulungssituationen,
- Personen, die grundlegende Entscheidungen der Ticket-Triage kennenlernen oder üben möchten.

Die Anwendung wird als kurze Spielsitzung auf einer Apple Vision Pro genutzt. Eine Sitzung besteht aus einer vor Spielbeginn gewählten Anzahl von Tickets.

## Kernfunktionen (Scope)

Die Dinge, die das Projekt können *muss*:

1. Eine Startansicht zeigt den Projekttitel, einen Regler für 1 bis 12 Tickets mit dem Standardwert 6 und eine Schaltfläche zum Starten des Spiels.
2. Eine Sitzung wählt die gewünschte Anzahl zufälliger Tickets ohne Wiederholung aus einem lokalen Pool von genau 12 selbst erstellten Tickets aus.
3. Jedes Ticket enthält eine Ticketnummer, einen Titel, eine Kurzbeschreibung, den User Impact, ein bis drei Symptome oder Hinweise sowie feste Referenzwerte für Priorität und Support-Team.
4. Die Sitzung läuft linear innerhalb eines zentralen visionOS-Volumes ab: Start, Ticket untersuchen, priorisieren, Team zuordnen, nächstes Ticket und abschließende Ergebnisansicht.
5. Beim Untersuchen werden das Ticket-Monster und eine gut lesbare Ticketkarte mit allen notwendigen Informationen angezeigt.
6. Die Priorität wird räumlich gewählt, indem das Monster per Blickfokus, Pinch und Drag auf eines der Ziele „Normal“, „Wichtig“ oder „Kritisch“ bewegt wird.
7. Das zuständige Team wird räumlich gewählt, indem das Monster auf eine der Stationen „Netzwerk“, „Konto“, „Software“ oder „Hardware“ bewegt wird.
8. Für eine richtige Priorität und eine richtige Teamzuordnung werden jeweils 100 Punkte vergeben. Falsche Entscheidungen geben 0 Punkte und verursachen keinen Punktabzug.
9. Richtige und falsche Entscheidungen werden durch zwei unterschiedliche lokale Sounds signalisiert. Die richtige Lösung und eine Erklärung werden nicht eingeblendet.
10. Nach einer gültigen Entscheidung wird die Eingabe kurz gesperrt und der Ablauf nach ungefähr 1,5 Sekunden automatisch fortgesetzt.
11. Vier eigene Blender-Monster werden als lokale 3D-Assets eingebunden. Die Wahl des Modells darf weder das richtige Team noch die richtige Priorität verraten.
12. Die Ergebnisansicht zeigt ausschließlich die erreichte Gesamtpunktzahl als Zahl und eine Schaltfläche „Erneut spielen“.
13. „Erneut spielen“ führt zurück zur Startansicht, setzt die Sitzung zurück und stellt die Ticketanzahl wieder auf den Standardwert 6.
14. [Kann] Ein Monster kann nach einer Entscheidung zusätzlich einen fröhlichen oder traurigen Gesichtsausdruck beziehungsweise eine kurze Animation zeigen.

## Nicht-Ziele (Out of Scope)

Bewusst *nicht* Teil des Projekts:

- mehrere Spiel-, Lern- oder Challenge-Modi,
- eine Spielanleitung, ein Tutorial oder ein Companion-Assistent,
- ein vollständiger Immersive Space oder mehrere Volumes,
- Zeitmessung, Stoppuhr, Streaks oder ein während des Spiels sichtbares Punkte-HUD,
- Anzeige der richtigen Lösung oder ausführliche Erklärungen nach einer Entscheidung,
- detaillierte Ergebnisstatistiken, Fehlerlisten, Badges, Ranglisten oder Verbesserungshinweise,
- Benutzerkonten, Datenbank, Cloud-Anbindung oder dauerhafte Spielhistorie,
- Import aus einem echten Ticketsystem oder eine externe API,
- SLA-Countdown, Aktivitätsverlauf, Bearbeiter, Kommentare oder Anhänge,
- Spracheingabe, Controller-Unterstützung oder alternative 2D-Steuerung für Priorisierung und Teamzuordnung,
- komplexe Physiksimulationen,
- verpflichtende Gesichts-, Zustands- oder Bewegungsanimationen der Monster.

## Rahmenbedingungen

- **Plattform / Stack:** Apple Vision Pro, visionOS 26, Xcode 26.5, Swift, SwiftUI und RealityKit
- **Zeitbudget:** Abgabe am 27.09.2026; drei Studierende; ungefähr 3 bis 4 gemeinsame Arbeitsstunden pro Woche zuzüglich individueller Vorbereitung
- **Werkzeuge / Bibliotheken:** Xcode, GitHub, Blender sowie die mit visionOS, SwiftUI und RealityKit bereitgestellten Frameworks
- **Abgabeform:** Xcode-Projekt + KI-Dokumentation
- **Sprache:** Benutzeroberfläche und Tickettexte auf Deutsch
- **3D-Assets:** Vier eigene, lokal mitgelieferte Blender-Modelle, vorzugsweise als USDZ exportiert
- **Datenhaltung:** Lokale statische Ticketdaten; Sitzungszustand nur im Arbeitsspeicher
- **Testumgebung:** Entwicklung im visionOS-Simulator und Prüfung auf einer verfügbaren Apple Vision Pro
- **[Annahme]** Die zwei Feedback-Sounds werden selbst erstellt oder aus einer rechtlich nutzbaren Quelle bezogen und zusammen mit der App ausgeliefert.

## Erfolgsbild

Das Projekt ist gelungen, wenn eine Person auf der Apple Vision Pro eine komplette Spielsitzung ohne externe Hilfe starten und abschließen kann. Die Person kann die gewünschte Ticketanzahl wählen, jedes Ticket lesen, das Monster räumlich einer Priorität und anschließend einem Team zuordnen und am Ende eine korrekt berechnete Gesamtpunktzahl sehen. Der Ablauf funktioniert stabil innerhalb eines einzigen Volumes, die zwölf lokalen Tickets werden ohne Wiederholung ausgewählt und die vier eigenen 3D-Modelle sowie die beiden Feedback-Sounds sind funktionsfähig integriert.
