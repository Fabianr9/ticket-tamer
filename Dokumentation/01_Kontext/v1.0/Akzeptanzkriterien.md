# Akzeptanzkriterien — Ticket Tamer

> **Funktion.** Definition of Done. Trennt „ist fertig“ von „sieht fertig aus“.
> Jedes Kriterium ist prüfbar, eindeutig und aus Nutzersicht formuliert. Verweist auf die `F-xx` der SPEC.

## Regeln

- Messbar und eindeutig — kein Interpretationsspielraum.
- „Funktioniert gut“ ist **kein** Kriterium. „Fällt in unter 2 s auf den Boden“ ist eines.
- Ein Feature gilt erst als erledigt, wenn **alle** seine Kriterien erfüllt sind.

---

## AK-01 — zu F-01 „Startansicht und Ticketanzahl“

- [ ] GEGEBEN die App wird neu gestartet, WENN die Startansicht erscheint, DANN sind der Projekttitel, ein Regler, der Wert `6` und die Schaltfläche „Spiel starten“ sichtbar.
- [ ] GEGEBEN die Startansicht ist geöffnet, WENN der Regler bewegt wird, DANN kann ausschließlich ein ganzzahliger Wert von 1 bis 12 eingestellt werden.
- [ ] GEGEBEN ein Wert außerhalb von 1 bis 12 wird technisch angefordert, WENN die Einstellung übernommen wird, DANN startet keine Sitzung mit weniger als 1 oder mehr als 12 Tickets.

## AK-02 — zu F-02 „Lokaler Ticketpool“

- [ ] GEGEBEN der lokale Ticketkatalog wird geprüft, WENN alle Einträge gezählt werden, DANN enthält er genau 12 Tickets.
- [ ] GEGEBEN die Referenzwerte aller Tickets werden ausgewertet, WENN Team und Priorität kombiniert werden, DANN kommt jede der 12 Kombinationen aus 4 Teams und 3 Prioritäten genau einmal vor.
- [ ] Kein Ticket benötigt zum Laden eine Netzwerkverbindung oder eine externe Datenquelle.

## AK-03 — zu F-03 „Vollständige Ticketdaten“

- [ ] GEGEBEN ein beliebiges Ticket aus dem Katalog, WENN dessen Daten geprüft werden, DANN sind Ticketnummer, Titel, Kurzbeschreibung, User Impact, 1 bis 3 Symptome beziehungsweise Hinweise, Referenzpriorität und Referenzteam vorhanden.
- [ ] Kein Ticket enthält mehr als drei Symptome beziehungsweise Hinweise.
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
- [ ] Referenzpriorität und Referenzteam werden in dieser Phase nicht als Lösung angezeigt.

## AK-07 — zu F-07 „Weiter zur Priorisierung“

- [ ] GEGEBEN die Untersuchungsphase ist aktiv, WENN „Weiter zur Priorisierung“ ausgelöst wird, DANN erscheint die Priorisierungsphase desselben Tickets.
- [ ] Der Ticketindex ändert sich durch diese Aktion nicht.
- [ ] Ohne Auslösen der Schaltfläche wird keine Prioritätsentscheidung gespeichert.

## AK-08 — zu F-08 „Räumliche Priorisierung“

- [ ] GEGEBEN die Priorisierungsphase ist aktiv, WENN das Monster per Blickfokus, Pinch und Drag auf Normal, Wichtig oder Kritisch gezogen und dort losgelassen wird, DANN wird genau diese Priorität gespeichert.
- [ ] Alle drei Prioritätsziele sind eindeutig mit den deutschen Bezeichnungen „Normal“, „Wichtig“ und „Kritisch“ beschriftet.
- [ ] Pro Ticket kann höchstens eine Prioritätsentscheidung gewertet werden.

## AK-09 — zu F-09 „Räumliche Teamzuordnung“

- [ ] GEGEBEN die Teamzuordnungsphase ist aktiv, WENN das Monster per Blickfokus, Pinch und Drag auf Netzwerk, Konto, Software oder Hardware gezogen und dort losgelassen wird, DANN wird genau dieses Team gespeichert.
- [ ] Alle vier Teamstationen sind eindeutig mit den deutschen Bezeichnungen „Netzwerk“, „Konto“, „Software“ und „Hardware“ beschriftet.
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
- [ ] Erfolgssound und Fehlersound sind akustisch unterscheidbar und werden lokal aus dem App-Bundle geladen.
- [ ] Bei einem ungültigen Ablegen wird keiner der beiden Bewertungssounds abgespielt.

## AK-13 — zu F-13 „Keine Lösungsausgabe und automatischer Übergang“

- [ ] GEGEBEN eine richtige oder falsche Entscheidung wurde bewertet, WENN das Feedback erfolgt, DANN wird weder die richtige Lösung noch eine textliche Begründung eingeblendet.
- [ ] GEGEBEN eine gültige Entscheidung wurde bewertet, WENN ungefähr 1,5 Sekunden vergangen sind, DANN wechselt die App automatisch zum nächsten vorgesehenen Schritt.
- [ ] Für den Übergang ist keine zusätzliche „Weiter“-Schaltfläche erforderlich.

## AK-14 — zu F-14 „Eigene Monster-Assets“

- [ ] GEGEBEN das App-Bundle wird geprüft, WENN die Monster-Assets gezählt werden, DANN sind vier eigene Blender-Monster als RealityKit-kompatible lokale 3D-Assets enthalten.
- [ ] GEGEBEN Tickets verschiedener Teams und Prioritäten werden gespielt, WENN die verwendeten Monster verglichen werden, DANN existiert keine feste 1:1-Zuordnung eines Modells zu einem Team oder einer Priorität.
- [ ] Alle vier Modelle können im zentralen Volume dargestellt und per Blickfokus, Pinch und Drag bewegt werden.
- [ ] Für die Anzeige eines Monsters ist keine Netzwerkverbindung erforderlich.

## AK-15 — zu F-15 „Ergebnisansicht“

- [ ] GEGEBEN alle ausgewählten Tickets wurden vollständig bearbeitet, WENN die Ergebnisphase erscheint, DANN wird die erreichte Gesamtpunktzahl als Zahl angezeigt.
- [ ] Zusätzlich zur Punktzahl ist ausschließlich die Schaltfläche „Erneut spielen“ als Ergebnisaktion vorhanden.
- [ ] Zeit, Streak, Fehlerliste, richtige Lösungen, Badges, Rang, Prozentwert und Detailstatistiken werden nicht angezeigt.

## AK-16 — zu F-16 „Neustart und Reset“

- [ ] GEGEBEN die Ergebnisansicht ist geöffnet, WENN „Erneut spielen“ ausgelöst wird, DANN erscheint die Startansicht.
- [ ] Nach dem Neustart beträgt der angezeigte Ticketwert wieder 6.
- [ ] Punktestand, Ticketindex, gespeicherte Entscheidungen und vorherige Sitzungstickets sind zurückgesetzt.
- [ ] Nach mindestens fünf aufeinanderfolgenden Neustarts bleibt die App lauffähig und übernimmt keine Punkte aus früheren Sitzungen.

## AK-17 — zu F-17 „Optionale Monsterreaktion“

- [ ] [Kann] GEGEBEN eine richtige Entscheidung wird bewertet, WENN die optionale Reaktion implementiert ist, DANN zeigt das Monster kurz einen fröhlichen Ausdruck oder eine positive Animation.
- [ ] [Kann] GEGEBEN eine falsche Entscheidung wird bewertet, WENN die optionale Reaktion implementiert ist, DANN zeigt das Monster kurz einen traurigen Ausdruck oder eine negative Animation.
- [ ] Wird diese Kann-Funktion nicht umgesetzt, bleiben alle Muss-Kriterien AK-01 bis AK-16 vollständig erfüllbar.

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
| 013 | AK-01 bis AK-16 als Integrationstest |
| 014 | Dokumentenkonsistenz und Abgabeprüfung |
