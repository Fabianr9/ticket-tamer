# Akzeptanzkriterien — Ticket Tamer

> **Funktion.** Definition of Done. Trennt „ist fertig“ von „sieht fertig aus“.
> Jedes Kriterium ist prüfbar, eindeutig und aus Nutzersicht formuliert. Verweist auf die `F-xx` der SPEC.

## Regeln

- Messbar und eindeutig — kein Interpretationsspielraum.
- „Funktioniert gut“ ist **kein** Kriterium.
- Ein Feature gilt erst als erledigt, wenn **alle** seine Kriterien erfüllt sind.

---

## AK-01 — zu F-01 „Startansicht und Ticketanzahl“

- [ ] GEGEBEN die App wird neu gestartet, WENN die Startansicht erscheint, DANN sind Projekttitel, Ticketanzahl-Regler, der Wert `6` und die Schaltfläche „Spiel starten“ sichtbar.
- [ ] GEGEBEN die Startansicht ist geöffnet, WENN der Regler bewegt wird, DANN kann ausschließlich ein ganzzahliger Wert von 1 bis 12 eingestellt werden.
- [ ] Eine Sitzung startet nie mit weniger als 1 oder mehr als 12 Tickets.

## AK-02 — zu F-02 „Lokaler Ticketpool“

- [ ] GEGEBEN der lokale Ticketkatalog wird geprüft, WENN alle Einträge gezählt werden, DANN enthält er genau 12 Tickets.
- [ ] GEGEBEN die Referenzwerte aller Tickets werden ausgewertet, WENN Team und Priorität kombiniert werden, DANN kommt jede der 12 Kombinationen aus 4 Teams und 3 Prioritäten genau einmal vor.
- [ ] Kein Ticket benötigt zum Laden eine Netzwerkverbindung oder externe Datenquelle.

## AK-03 — zu F-03 „Vollständige Ticketdaten“

- [ ] GEGEBEN ein beliebiges Ticket aus dem Katalog, WENN dessen Daten geprüft werden, DANN sind Ticketnummer, Titel, Kurzbeschreibung, User Impact, 1 bis 3 Symptome beziehungsweise Hinweise, Referenzpriorität und Referenzteam vorhanden.
- [ ] Kein Ticket besitzt mehr als eine Referenzpriorität oder mehr als ein Referenzteam.

## AK-04 — zu F-04 „Sitzungsauswahl ohne Wiederholung“

- [ ] GEGEBEN auf der Startansicht ist die Ticketanzahl `n` gewählt, WENN „Spiel starten“ aktiviert wird, DANN enthält die Sitzung genau `n` Tickets.
- [ ] GEGEBEN eine Sitzung läuft, WENN alle ausgewählten Ticket-IDs verglichen werden, DANN kommt keine Ticket-ID doppelt vor.
- [ ] GEGEBEN mehrere Sitzungen werden nacheinander gestartet, WENN ihre Auswahl verglichen wird, DANN darf die Reihenfolge beziehungsweise Auswahl variieren.

## AK-05 — zu F-05 „Linearer Ablauf in einem Volume“

- [ ] GEGEBEN eine Sitzung wurde gestartet, WENN sie vollständig durchlaufen wird, DANN erfolgt die Reihenfolge Start, Untersuchen, Priorisieren, Team zuordnen, nächstes Ticket und Ergebnis.
- [ ] Während der gesamten Sitzung bleibt die Anwendung innerhalb eines zentralen Volumes.
- [ ] Es wird weder ein zweites Volume noch ein vollständiger Immersive Space geöffnet.

## AK-06 — zu F-06 „Untersuchungsphase“

- [ ] GEGEBEN ein Ticket ist aktiv, WENN die Untersuchungsphase erscheint, DANN sind ein Monster sowie Ticketnummer, Titel, Kurzbeschreibung, User Impact und alle hinterlegten Symptome beziehungsweise Hinweise sichtbar.
- [ ] Die sichtbaren Informationen entsprechen exakt dem aktiven Ticket im Sitzungsmodell.
- [ ] Referenzpriorität und Referenzteam werden nicht als Lösung angezeigt.
- [ ] Alle vier produktiven Monsterassets werden in der Untersuchungsansicht innerhalb des vorgesehenen sichtbaren Bereichs dargestellt, ohne für die Nutzung relevante Teile abzuschneiden.

## AK-07 — zu F-07 „Weiter zur Priorisierung“

- [ ] GEGEBEN die Untersuchungsphase ist aktiv, WENN „Weiter zur Priorisierung“ ausgelöst wird, DANN erscheint die Priorisierungsphase desselben Tickets.
- [ ] Der Ticketindex ändert sich durch diese Aktion nicht.
- [ ] Ohne Auslösen der Schaltfläche wird keine Prioritätsentscheidung gespeichert.

## AK-08 — zu F-08 „Räumliche Priorisierung“

- [ ] GEGEBEN die Priorisierungsphase ist aktiv, WENN das Monster per Blickfokus, Pinch und Drag auf Normal, Wichtig oder Kritisch gezogen und dort gültig losgelassen wird, DANN wird genau diese Priorität gespeichert.
- [ ] Alle drei Prioritätsziele sind eindeutig mit „Normal“, „Wichtig“ und „Kritisch“ beschriftet.
- [ ] Pro Ticket kann höchstens eine Prioritätsentscheidung gewertet werden.

## AK-09 — zu F-09 „Räumliche Teamzuordnung“

- [ ] GEGEBEN die Teamzuordnungsphase ist aktiv, WENN das Monster per Blickfokus, Pinch und Drag auf Netzwerk, Konto, Software oder Hardware gezogen und dort gültig losgelassen wird, DANN wird genau dieses Team gespeichert.
- [ ] Alle vier Teamstationen sind eindeutig mit „Netzwerk“, „Konto“, „Software“ und „Hardware“ beschriftet.
- [ ] Pro Ticket kann höchstens eine Teamentscheidung gewertet werden.

## AK-10 — zu F-10 „Gültige und ungültige Ablage“

- [ ] GEGEBEN das Monster wird gezogen, WENN es außerhalb eines gültigen Ziels losgelassen wird, DANN werden weder Entscheidung noch Punkte noch Phase verändert.
- [ ] GEGEBEN das Monster wird innerhalb eines gültigen Ziels losgelassen, WENN die Entscheidung gespeichert wurde, DANN ist die Eingabe bis zum nächsten Zustandswechsel gesperrt.
- [ ] Mehrfaches Pinchen oder erneutes Ziehen während der Eingabesperre verändert die gespeicherte Entscheidung und den Punktestand nicht.

## AK-11 — zu F-11 „Punkteberechnung“

- [ ] GEGEBEN die gewählte Priorität entspricht der Referenzpriorität, WENN die Entscheidung bewertet wird, DANN erhöht sich der interne Punktestand um genau 100 Punkte.
- [ ] GEGEBEN das gewählte Team entspricht dem Referenzteam, WENN die Entscheidung bewertet wird, DANN erhöht sich der interne Punktestand um genau 100 Punkte.
- [ ] GEGEBEN eine Entscheidung ist falsch, WENN sie bewertet wird, DANN erhöht sich der Punktestand um 0 Punkte und wird nicht reduziert.
- [ ] GEGEBEN eine Sitzung mit `n` Tickets ist vollständig korrekt, WENN das Ergebnis berechnet wird, DANN beträgt die Gesamtpunktzahl `n × 200`.

## AK-12 — zu F-12 „Akustisches Feedback“

- [ ] GEGEBEN eine richtige Entscheidung wurde gültig abgelegt, WENN sie bewertet wird, DANN wird genau der definierte Erfolgssound abgespielt.
- [ ] GEGEBEN eine falsche Entscheidung wurde gültig abgelegt, WENN sie bewertet wird, DANN wird genau der definierte Fehlersound abgespielt.
- [ ] Bei einem ungültigen Ablegen wird keiner der beiden Bewertungssounds abgespielt.

## AK-13 — zu F-13 „Keine Lösungsausgabe und automatischer Übergang“

- [ ] GEGEBEN eine richtige oder falsche Entscheidung wurde bewertet, WENN das Feedback erfolgt, DANN wird weder die richtige Lösung noch eine textliche Begründung eingeblendet.
- [ ] GEGEBEN eine gültige Entscheidung wurde bewertet, WENN ungefähr 1,5 Sekunden vergangen sind, DANN wechselt die App automatisch zum nächsten vorgesehenen Schritt.
- [ ] Für den Übergang ist keine zusätzliche „Weiter“-Schaltfläche erforderlich.

## AK-14 — zu F-14 „Eigene Monster-Assets“

- [ ] GEGEBEN das App-Bundle wird geprüft, WENN die Monster-Assets gezählt werden, DANN sind vier eigene Blender-Monster als lokale RealityKit-kompatible 3D-Assets enthalten.
- [ ] GEGEBEN Tickets verschiedener Teams und Prioritäten werden gespielt, WENN die verwendeten Monster verglichen werden, DANN existiert keine feste 1:1-Zuordnung eines Modells zu einem Team oder einer Priorität.
- [ ] Alle vier Modelle können im zentralen Volume dargestellt und in den Entscheidungsphasen per Blickfokus, Pinch und Drag bewegt werden.

## AK-15 — zu F-15 „Ergebnisansicht“

- [ ] GEGEBEN alle ausgewählten Tickets wurden vollständig bearbeitet, WENN die Ergebnisphase erscheint, DANN wird die erreichte Gesamtpunktzahl als Zahl angezeigt.
- [ ] Zusätzlich zur Punktzahl ist ausschließlich die Schaltfläche „Erneut spielen“ als Ergebnisaktion vorhanden.
- [ ] Zeit, Streak, Fehlerliste, richtige Lösungen, Badges, Rang, Prozentwert und Detailstatistiken werden nicht angezeigt.

## AK-16 — zu F-16 „Neustart und Reset“

- [ ] GEGEBEN die Ergebnisansicht ist geöffnet, WENN „Erneut spielen“ ausgelöst wird, DANN erscheint die Startansicht.
- [ ] Nach dem Neustart beträgt der angezeigte Ticketwert wieder 6.
- [ ] Punktestand, Ticketindex, gespeicherte Entscheidungen und vorherige Sitzungstickets sind zurückgesetzt.
- [ ] Nach mindestens fünf aufeinanderfolgenden Neustarts bleibt die App lauffähig und übernimmt keine Punkte aus früheren Sitzungen.

## AK-17 — zu F-17 „Optionale zusätzliche Monsterreaktion“

- [ ] [Kann] Wird eine zusätzliche Monster-Gesichts- oder Bewegungsreaktion später umgesetzt, darf sie keine bestehende Bewertung, Eingabesperre oder Phasenlogik verändern.
- [ ] Wird diese Kann-Funktion nicht umgesetzt, bleiben alle Muss-Kriterien der v1.0- und v1.1-Version vollständig erfüllbar.

## AK-18 — zu F-18 „Session-HUD und Fortschrittsbalken“

- [ ] GEGEBEN eine Sitzung läuft, WENN Untersuchung, Priorisierung oder Teamzuordnung angezeigt wird, DANN ist dauerhaft ein kompaktes HUD sichtbar.
- [ ] GEGEBEN Ticket `x` von insgesamt `y` Tickets ist aktiv, WENN das HUD angezeigt wird, DANN zeigt es exakt `Ticket x von y`.
- [ ] GEGEBEN die aktuelle Phase ist Untersuchung, Priorisierung oder Teamzuordnung, WENN das HUD angezeigt wird, DANN lautet der Phasentitel entsprechend „Ticket untersuchen“, „Priorität zuordnen“ oder „Team zuordnen“.
- [ ] GEGEBEN Ticket 3 von 6 ist aktiv, WENN der Fortschrittsbalken angezeigt wird, DANN entspricht sein Fortschritt `3/6 = 50 %`.
- [ ] Der Fortschrittswert bleibt während aller drei Phasen desselben Tickets unverändert und erhöht sich erst beim nächsten Ticket.
- [ ] Das HUD zeigt keinen Score, keine Zeit, keinen Streak und keine Richtig-/Falsch-Statistik.
- [ ] Das nicht interaktive HUD blockiert keine Blick-, Pinch- oder Drag-Geste der 3D-Szene.

## AK-19 — zu F-19 „Kompakte Ticketinformationen in Entscheidungsphasen“

- [ ] GEGEBEN die Priorisierungs- oder Teamzuordnungsphase ist aktiv, WENN der Info-Button aktiviert wird, DANN öffnet sich eine kompakte Ticketübersicht für exakt `model.currentTicket`.
- [ ] Die Übersicht zeigt ausschließlich Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptome beziehungsweise Hinweise.
- [ ] Referenzpriorität, Referenzteam, richtige Lösung und interne Bewertungsdaten werden niemals angezeigt.
- [ ] GEGEBEN die Ticketübersicht ist geöffnet, WENN versucht wird, das Monster in der verdeckten 3D-Szene zu ziehen, DANN wird keine Drag-Interaktion ausgelöst.
- [ ] GEGEBEN die Übersicht ist geöffnet, WENN „X“ oder der Info-Button erneut aktiviert wird, DANN schließt sich die Übersicht und Drag & Drop ist anschließend wieder möglich.
- [ ] GEGEBEN ein Phasenwechsel erfolgt, WENN die nächste Phase angezeigt wird, DANN ist die Ticketübersicht geschlossen.
- [ ] In der Untersuchungsphase wird kein zusätzlicher Info-Button benötigt, da die vollständige Ticketkarte bereits sichtbar ist.

## AK-20 — zu F-20 „Dauerhafte Interaktionshinweise“

- [ ] GEGEBEN die Priorisierungsphase ist aktiv, WENN die Ansicht sichtbar ist, DANN wird dauerhaft der Text „Monster greifen und auf eine Priorität ziehen.“ angezeigt.
- [ ] GEGEBEN die Teamzuordnungsphase ist aktiv, WENN die Ansicht sichtbar ist, DANN wird dauerhaft der Text „Monster greifen und dem zuständigen Team zuordnen.“ angezeigt.
- [ ] Die Hinweise bleiben auch nach einer begonnenen Drag-Geste sichtbar.
- [ ] Die Hinweise besitzen keine Persistenz über `@AppStorage` oder eine andere globale Tutorialverwaltung.
- [ ] Die Hinweise blockieren keine 3D-Interaktion.

## AK-21 — zu F-21 „Visuelles Richtig-/Falsch-Feedback“

- [ ] GEGEBEN eine richtige Prioritäts- oder Teamentscheidung wurde bewertet, WENN das Feedbackfenster beginnt, DANN erscheinen ein gut sichtbarer grüner Haken und der Text `+100 Punkte`.
- [ ] GEGEBEN eine falsche Prioritäts- oder Teamentscheidung wurde bewertet, WENN das Feedbackfenster beginnt, DANN erscheint ein gut sichtbares rotes Kreuz und kein Punktetext.
- [ ] Das visuelle Feedback erscheint parallel zum bereits vorhandenen passenden Erfolgs- beziehungsweise Fehlersound.
- [ ] Das visuelle Feedback bleibt nur während des vorhandenen ungefähr 1,5 Sekunden langen Feedbackfensters sichtbar und ist danach zurückgesetzt.
- [ ] Das Feedback zeigt weder die richtige Priorität noch das richtige Team noch eine textliche Begründung.
- [ ] Während des Feedbackfensters bleibt die vorhandene Eingabesperre aktiv.
- [ ] Eine gültige Entscheidung erzeugt weiterhin genau eine Bewertung, genau einen Sound und genau einen Phasenwechsel.
- [ ] Haken und Kreuz besitzen geeignete Accessibility-Labels, die das Ergebnis verständlich beschreiben.

## AK-22 — zu F-22 „Minus-/Plus-Buttons für Ticketanzahl“

- [ ] GEGEBEN die Startansicht ist geöffnet, WENN der Plus-Button einmal aktiviert wird, DANN erhöht sich die Ticketanzahl genau um 1.
- [ ] GEGEBEN die Startansicht ist geöffnet, WENN der Minus-Button einmal aktiviert wird, DANN verringert sich die Ticketanzahl genau um 1.
- [ ] GEGEBEN der Wert ist 1, WENN die Startansicht angezeigt wird, DANN ist der Minus-Button deaktiviert.
- [ ] GEGEBEN der Wert ist 12, WENN die Startansicht angezeigt wird, DANN ist der Plus-Button deaktiviert.
- [ ] Slider, Zahlenanzeige und Minus-/Plus-Buttons spiegeln jederzeit denselben Wert wider.
- [ ] Der vorhandene Slider bleibt nutzbar.
- [ ] Nach „Erneut spielen“ steht die Ticketanzahl wieder auf 6.
- [ ] Minus- und Plus-Button besitzen die Accessibility-Labels „Ein Ticket weniger“ und „Ein Ticket mehr“.

## AK-23 — zu F-23 „Erneut laden bei Monster-Ladefehler“

- [ ] GEGEBEN das Monster kann in Untersuchung, Priorisierung oder Teamzuordnung nicht geladen werden, WENN der Fehlerzustand angezeigt wird, DANN ist die Aktion „Erneut laden“ sichtbar.
- [ ] GEGEBEN „Erneut laden“ wird aktiviert, WENN der Wiederholungsversuch beginnt, DANN wird der vorherige Ladefehler zurückgesetzt und das aktuelle Monster erneut geladen.
- [ ] Der Retry verändert weder aktuelles Ticket noch Ticketindex noch aktuelle Phase noch Score noch bereits gespeicherte Entscheidungen.
- [ ] In Priorisierung und Teamzuordnung erzeugt ein Retry keine zusätzlichen Prioritäts- oder Team-Zielpanels.
- [ ] GEGEBEN der Wiederholungsversuch erfolgreich ist, WENN das Monster geladen wurde, DANN kann die Sitzung in derselben Phase normal fortgesetzt werden.
- [ ] Mehrere aufeinanderfolgende Retry-Versuche erzeugen weder doppelte Monster noch doppelte Zielpanels.

## AK-24 — zu F-24 „Kurze Startseitenbeschreibung“

- [ ] GEGEBEN die Startansicht erscheint, WENN die App gestartet oder nach „Erneut spielen“ zurückgesetzt wird, DANN ist unter dem Titel der Text „Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.“ sichtbar.
- [ ] Die Startansicht enthält keinen zusätzlichen „So funktioniert’s“-Button, kein Tutorial-Popover und keine persistente Tutorialverwaltung.
- [ ] Die Kurzbeschreibung verhindert nicht die Bedienung von Ticketanzahl-Steuerung und „Spiel starten“.

---

## Modul-Zuordnung (Übersicht)

Welche Akzeptanzkriterien welches Modul abnimmt:

| Modul | Erfüllt Kriterien |
|---|---|
| 001 | AK-05 |
| 002 | AK-02, AK-03 |
| 003 | AK-04, AK-16 |
| 004 | AK-01 |
| 005 | AK-14 |
| 006 | AK-06, AK-07 |
| 007 | AK-10 |
| 008 | AK-08 |
| 009 | AK-09 |
| 010 | AK-11, AK-12, AK-13 |
| 011 | AK-15, AK-16 |
| 012 | AK-17 |
| 013 | AK-01 bis AK-16 als v1.0-Integrationstest |
| 014 | Dokumentenkonsistenz und v1.0-Abschluss |
| 015 | AK-18, AK-20 |
| 016 | AK-19 |
| 017 | AK-22, AK-24 |
| 018 | AK-21 |
| 019 | AK-23 |
| 020 | AK-18 bis AK-24 als v1.1-Integrationstest |
