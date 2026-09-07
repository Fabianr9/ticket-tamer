# Akzeptanzkriterien — Ticket Tamer

> **Funktion.** Definition of Done. Trennt „ist fertig“ von „sieht fertig aus“.
> Jedes Kriterium ist prüfbar, eindeutig und aus Nutzersicht formuliert. Verweist auf die `F-xx` der SPEC.

## Regeln

- Messbar und eindeutig — kein Interpretationsspielraum.
- „Funktioniert gut“ ist **kein** Kriterium.
- Ein Feature gilt erst als erledigt, wenn **alle** seine Kriterien erfüllt sind.

---

## AK-01 — zu F-01 „Startansicht und Ticketanzahl“

- [ ] GEGEBEN die App wird neu gestartet, WENN die Startansicht erscheint, DANN sind Projekttitel, Kurzbeschreibung, Ticketanzahlsteuerung, der Wert `6` und „Spiel starten“ sichtbar.
- [ ] GEGEBEN die Startansicht ist geöffnet, WENN Slider oder Minus-/Plus-Buttons bedient werden, DANN kann ausschließlich ein ganzzahliger Wert von 1 bis 16 eingestellt werden.
- [ ] Der Standardwert nach App-Start und nach Reset beträgt 6.

## AK-02 — zu F-02 „Lokaler Ticketpool“

- [ ] GEGEBEN der lokale Ticketkatalog wird geprüft, WENN alle Einträge gezählt werden, DANN enthält er genau TT-001 bis TT-016 und damit 16 Tickets.
- [ ] GEGEBEN TT-001 bis TT-012 werden nach Team und Priorität gruppiert, WENN die Matrix geprüft wird, DANN kommt jede Kombination aus vier Teams und drei Prioritäten genau einmal vor.
- [ ] GEGEBEN alle 16 Tickets werden gruppiert, WENN die Teamverteilung geprüft wird, DANN besitzt jedes der vier Teams genau 4 Tickets.
- [ ] GEGEBEN alle 16 Tickets werden gruppiert, WENN die Prioritäten gezählt werden, DANN ergeben sich 5× Normal, 6× Wichtig und 5× Kritisch.

## AK-03 — zu F-03 „Vollständige Ticketdaten“

- [ ] Jedes Ticket besitzt Ticketnummer, Titel, Kurzbeschreibung, User Impact, 1 bis 3 Symptome/Hinweise, genau eine Referenzpriorität, genau ein Referenzteam, eine Monsterzuordnung und genau eine Video-Referenz.
- [ ] Die Video-Referenz von TT-001 ist `TT-001.mp4`, entsprechend fortlaufend bis TT-016 → `TT-016.mp4`.
- [ ] Kein sichtbares Ticketfeld verrät Referenzpriorität oder Referenzteam unmittelbar als Lösung.

## AK-04 — zu F-04 „Sitzungsauswahl ohne Wiederholung“

- [ ] GEGEBEN auf der Startansicht ist die Ticketanzahl `n` mit `1 ≤ n ≤ 16` gewählt, WENN „Spiel starten“ aktiviert wird, DANN enthält die Sitzung genau `n` Tickets.
- [ ] Innerhalb einer Sitzung kommt keine Ticket-ID doppelt vor.
- [ ] Mehrere neue Sitzungen dürfen unterschiedliche Auswahl/Reihenfolge erzeugen.

## AK-05 — zu F-05 „Linearer Ablauf in einem Volume“

- [ ] Eine Sitzung folgt weiterhin Start → Untersuchen → Priorisieren → Team zuordnen → nächstes Ticket → Ergebnis.
- [ ] Während des gesamten Ablaufs bleibt die Anwendung innerhalb eines zentralen Volumes.
- [ ] Videoanzeige, Streak und neue Assets führen keine alternative Produktnavigation ein.

## AK-06 — zu F-06 „Untersuchungsphase“

- [ ] Beim aktiven Ticket sind Monster sowie Ticketnummer, Titel, Kurzbeschreibung, User Impact und alle Symptome/Hinweise sichtbar.
- [ ] Die angezeigten Inhalte entsprechen exakt dem aktuellen TT-xxx-Eintrag des lokalen Katalogs.
- [ ] Referenzpriorität und Referenzteam sind nicht sichtbar.

## AK-07 — zu F-07 „Weiter zur Priorisierung“

- [ ] „Weiter zur Priorisierung“ öffnet die Priorisierungsphase desselben Tickets.
- [ ] Der Ticketindex ändert sich dabei nicht.

## AK-08 — zu F-08 „Räumliche Priorisierung“

- [ ] Das Monster kann per Blickfokus, Pinch und Drag gültig auf Normal, Wichtig oder Kritisch abgelegt werden.
- [ ] Genau die abgelegte Priorität wird gespeichert.
- [ ] Pro Ticket kann höchstens eine Prioritätsentscheidung gewertet werden.

## AK-09 — zu F-09 „Räumliche Teamzuordnung“

- [ ] Das Monster kann per Blickfokus, Pinch und Drag gültig auf Netzwerk, Konto, Software oder Hardware abgelegt werden.
- [ ] Genau das abgelegte Team wird gespeichert.
- [ ] Pro Ticket kann höchstens eine Teamentscheidung gewertet werden.

## AK-10 — zu F-10 „Gültige/ungültige Ablage und Exactly-once“

- [ ] Ein Drop außerhalb eines gültigen Zielbereichs verändert weder Entscheidung noch Punkte noch Phase.
- [ ] Ein gültiger Drop wird genau einmal gespeichert und bewertet.
- [ ] Während der Eingabesperre führt weiteres Pinchen/Draggen zu keiner Doppelwertung.

## AK-11 — zu F-11 „Basispunkte“

- [ ] Eine richtige Priorität besitzt einen Basiswert von 100 Punkten.
- [ ] Ein richtiges Team besitzt einen Basiswert von 100 Punkten.
- [ ] Eine falsche Einzelentscheidung besitzt einen Basiswert von 0 Punkten und verursacht keinen Abzug.
- [ ] Zusätzliche Punkte oberhalb der Basispunkte entstehen ausschließlich durch die Streak-Regel aus AK-37.

## AK-12 — zu F-12 „Monster-Feedbacksounds“

- [ ] Nach jeder gültigen richtigen Einzelentscheidung wird genau ein Sound aus der Correct-Gruppe abgespielt.
- [ ] Nach jeder gültigen falschen Einzelentscheidung wird genau ein Sound aus der Incorrect-Gruppe abgespielt.
- [ ] Jede Gruppe enthält genau vier ladbare lokale WAV-Varianten.
- [ ] Ein ungültiger Drop löst keinen Bewertungssound aus.

## AK-13 — zu F-13 „Keine Lösungsausgabe und automatischer Ablauf“

- [ ] Feedback zeigt niemals die richtige Priorität, das richtige Team oder eine textliche Begründung.
- [ ] Nach abgeschlossenem Feedback erfolgt automatisch der vorgesehene nächste Schritt.
- [ ] Video- oder Streak-Erweiterungen führen zu keinem doppelten Phasenwechsel.

## AK-14 — zu F-14 „Monster-Assets“

- [ ] Vier Monstertypen bleiben als lokale RealityKit-kompatible Assets vorhanden.
- [ ] Monstertyp und Farbe verraten keine Referenzlösung.
- [ ] Bestehende Interaktion und Skalierung bleiben funktionsfähig.

## AK-15 — zu F-15 „Ergebnisansicht“

- [ ] Nach dem letzten Ticket wird die korrekte Gesamtpunktzahl als `X Punkte` angezeigt.
- [ ] Zusätzlich ist nur „Erneut spielen“ als Ergebnisaktion vorhanden.
- [ ] Keine Streak-Historie, Best-Streak, Prozentzahl, Fehlerliste oder weitere Ergebnisstatistik wird angezeigt.

## AK-16 — zu F-16 „Neustart und Reset“

- [ ] „Erneut spielen“ führt zur Startansicht zurück.
- [ ] Ticketanzahl steht wieder auf 6.
- [ ] Score, Ticketindex, Sitzungstickets, Entscheidungen und Input-Lock sind zurückgesetzt.
- [ ] Die Streak ist nach dem Reset exakt 0.
- [ ] Kein Wert aus der vorherigen Sitzung beeinflusst die neue Sitzung.

## AK-17 — zu F-17 „Optionale Monsterreaktion“

- [ ] [Kann] Zusätzliche Gesichts-/Bewegungsreaktionen dürfen ergänzt werden, sind aber für v1.3 nicht erforderlich.
- [ ] Das Weglassen dieser Kann-Funktion verhindert keinen PASS der Muss-Kriterien.

## AK-18 — zu F-18 „Session-HUD“

- [ ] Untersuchung, Priorisierung und Teamzuordnung zeigen `Ticket X von Y`, Phasentitel und Fortschrittsbalken.
- [ ] Das HUD zeigt keinen laufenden Gesamtscore.
- [ ] Der Streak-Multiplikator wird nicht dauerhaft im HUD angezeigt.

## AK-19 — zu F-19 „Kompakte Ticketinfo“

- [ ] Priorisierung und Teamzuordnung besitzen einen Info-Button.
- [ ] Das Overlay zeigt ausschließlich Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptome/Hinweise.
- [ ] Referenzpriorität und Referenzteam bleiben verborgen.
- [ ] Während des offenen Overlays ist die darunterliegende Drag-Interaktion deaktiviert.

## AK-20 — zu F-20 „Interaktionshinweise“

- [ ] Priorisierung zeigt dauerhaft „Monster greifen und auf eine Priorität ziehen.“
- [ ] Teamzuordnung zeigt dauerhaft „Monster greifen und dem zuständigen Team zuordnen.“
- [ ] Die Hinweise blockieren keine RealityKit-Gesten.

## AK-21 — zu F-21 „Visuelles positives Punktefeedback“

- [ ] Eine richtige Priorität zeigt einen grünen Haken und `+100 Punkte`.
- [ ] Eine richtige Teamentscheidung zeigt einen grünen Haken und genau die Punkte, die mit diesem Teamabschluss tatsächlich zusätzlich zum Score gutgeschrieben werden.
- [ ] Bei Streak 1 ohne Bonus sind das `+100 Punkte`; bei Streak 2 eines vollständig korrekten Tickets `+300 Punkte`; bei Streak 3 `+500 Punkte`.
- [ ] Die Anzeige selbst führt keine zusätzliche Scoremutation aus.

## AK-22 — zu F-22 „Minus-/Plus-Buttons für Ticketanzahl“

- [ ] Plus erhöht genau um 1, Minus verringert genau um 1.
- [ ] Bei 1 ist Minus deaktiviert.
- [ ] Bei 16 ist Plus deaktiviert.
- [ ] Slider, Zahlenanzeige und Buttons bleiben synchron.
- [ ] Nach Reset steht der Wert wieder auf 6.

## AK-23 — zu F-23 „Erneut laden bei Monster-Ladefehler“

- [ ] In Untersuchung, Priorisierung und Teamzuordnung erscheint bei Monster-Ladefehler „Erneut laden“.
- [ ] Retry lädt dieselbe zuvor ausgewählte Monster-Farbvariante erneut.
- [ ] Ticket, Score, Streak, Entscheidungen, Phase und Zielpanels bleiben unverändert.
- [ ] Retry erzeugt keine doppelten Monster oder Zielpanels.

## AK-24 — zu F-24 „Kurze Startseitenbeschreibung“

- [ ] Unter dem Titel steht „Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.“
- [ ] Es wird kein zusätzliches Tutorial/Popover eingeführt.

## AK-25 — zu F-25 „Replay-Layoutstabilität“

- [ ] Nach „Erneut spielen“ entsprechen Startansicht, Slider sowie Prioritäts- und Teamziele bei gleicher Volume-Größe visuell dem ersten Durchlauf.
- [ ] Fünf vollständige Replay-Zyklen erzeugen keine kumulative Größen- oder Layoutdrift.
- [ ] Eine aktuell verwendete zulässige Volume-Größe bleibt erhalten und wird nicht zwangsweise auf eine Cold-Start-Größe zurückgesetzt.

## AK-26 — zu F-26 „Ergebnis als X Punkte“

- [ ] Bei 600 Gesamtpunkten zeigt die Ergebnisansicht `600 Punkte`.
- [ ] Bei jedem anderen gültigen Score wird exakt dieser Wert mit der Einheit `Punkte` angezeigt.
- [ ] Keine zusätzliche Ergebniskennzahl wird ergänzt.

## AK-27 — zu F-27 „0 Punkte bei falscher Entscheidung“

- [ ] Falsche Priorität zeigt rotes Kreuz + `0 Punkte`.
- [ ] Falsches Team zeigt rotes Kreuz + `0 Punkte`.
- [ ] Die Anzeige verändert den Score nicht und verrät keine korrekte Lösung.

## AK-28 — zu F-28 „Teamlogos“

- [ ] Jede der vier Teamstationen zeigt das korrekte bereitgestellte JPEG-Logo ihres Teams.
- [ ] Die Texte Netzwerk, Konto, Software und Hardware bleiben vollständig sichtbar.
- [ ] Die Logos ersetzen die bisherigen Team-Symbole, verändern aber weder Zielgröße noch Drop-Bounds oder Drop-Auswertung.
- [ ] Ein fehlendes Logo darf die fachliche Teamzuordnung nicht verändern; der Fehler wird sichtbar/logisch robust behandelt.

## AK-29 — zu F-29 „DEV-Schaltfläche isoliert“

- [ ] `🔧 Team [DEV]` erscheint in keinem normalen App-Ablauf, auch nicht im regulären Debug-Build.
- [ ] Debug-Funktionalität darf im separaten Debug-Harness erhalten bleiben.

## AK-30 — zu F-30 „16 Monster-Farbvarianten“

- [ ] Alle 16 vorhandenen Monster-Farbvarianten sind ladbar.
- [ ] Ein Ticket behält seine konkrete Variante über Untersuchung, Priorisierung, Teamzuordnung und Retry.
- [ ] Eine neue Sitzung darf neue Varianten wählen.
- [ ] Keine Farbe codiert Priorität, Team oder Richtigkeit.

## AK-31 — zu F-31 „Neue v1.3-Ticketinhalte“

- [ ] GEGEBEN `Tickets/Ticket-Tamer_Tickets.md` als verbindliche Quelle, WENN der lokale Ticketkatalog geprüft wird, DANN entsprechen Titel, Beschreibungen, User Impact und Hinweise von TT-001 bis TT-016 den bereitgestellten v1.3-Inhalten und nicht mehr den bisherigen Tickettexten.
- [ ] TT-001 bis TT-012 behalten die bestätigten Referenzlösungen der 4×3-Matrix.
- [ ] TT-013 besitzt Netzwerk + Wichtig, TT-014 Konto + Normal, TT-015 Software + Wichtig und TT-016 Hardware + Kritisch.
- [ ] Jeder neue Tickettext bleibt ohne Video lösbar und verrät die Referenzlösung nicht direkt.
- [ ] Die zufällige Sitzungsauswahl funktioniert mit allen 16 neuen Tickets weiterhin ohne Wiederholung.

## AK-32 — zu F-32 „Videozuordnung und Video-Start“

- [ ] Jedes Ticket TT-001 bis TT-016 besitzt genau die gleichnamige lokale MP4-Datei als Video-Referenz.
- [ ] In der Untersuchungsphase ist „Video ansehen“ sichtbar.
- [ ] Ohne Aktivierung von „Video ansehen“ wird kein Ticketvideo gestartet.
- [ ] GEGEBEN TT-007 ist aktiv, WENN „Video ansehen“ ausgelöst wird, DANN wird `TT-007.mp4` geöffnet; analog gilt die 1:1-Zuordnung für alle 16 Tickets.

## AK-33 — zu F-33 „Video-Wiedergabe, Schließen und Fehlerfall“

- [ ] GEGEBEN „Video ansehen“ wurde aktiviert und das Video ist ladbar, WENN die Videoansicht erscheint, DANN startet die Wiedergabe automatisch.
- [ ] Die nutzende Person kann pausieren und fortsetzen.
- [ ] Ein sichtbares `X` schließt die Videoansicht jederzeit vorzeitig.
- [ ] Erreicht das Video regulär sein Ende, schließt sich die Videoansicht automatisch ohne zusätzliche Benutzeraktion.
- [ ] Nach manuellem oder automatischem Schließen ist dasselbe Ticket weiterhin in der Untersuchungsphase aktiv.
- [ ] Score, Streak, Ticketindex und Referenzentscheidungen sind durch das Abspielen unverändert.
- [ ] GEGEBEN ein Video fehlt oder kann nicht geladen werden, WENN der Ladeversuch fehlschlägt, DANN stürzt die App nicht ab, zeigt eine verständliche Fehlermeldung und das Ticket bleibt normal spielbar.

## AK-34 — zu F-34 „Zufällige Monster-Soundvarianten“

- [ ] Die Ressourcenstruktur enthält genau vier Correct- und vier Incorrect-Monster-Sounds als lokale WAV-Dateien.
- [ ] Bei einer richtigen Prioritätsentscheidung kann jede der vier Correct-Varianten über eine deterministische Testauswahl erzwungen werden.
- [ ] Bei einer richtigen Teamentscheidung kann ebenfalls jede Correct-Variante gewählt werden.
- [ ] Entsprechend sind alle vier Incorrect-Varianten für falsche Prioritäts- und Teamentscheidungen erreichbar.
- [ ] Pro Einzelentscheidung wird genau ein Monster-Sound abgespielt.
- [ ] Direkte Wiederholung derselben Variante bei zwei aufeinanderfolgenden Entscheidungen ist zulässig.

## AK-35 — zu F-35 „Streak-Sounds“

- [ ] GEGEBEN ein Ticket beendet eine Streak auf x2 oder x3, WENN die Teamentscheidung vollständig korrekt abgeschlossen wird, DANN wird zusätzlich Streak-Sound 01 abgespielt.
- [ ] GEGEBEN ein Ticket beendet eine Streak auf x4 oder höher, WENN die Teamentscheidung vollständig korrekt abgeschlossen wird, DANN wird zusätzlich Streak-Sound 02 abgespielt.
- [ ] Bei Streak 0 oder 1 wird kein Streak-Sound abgespielt.
- [ ] Bei Prioritätsentscheidungen wird niemals ein Streak-Sound abgespielt.
- [ ] Positiver Monster-Sound und Streak-Sound werden leicht zeitversetzt beziehungsweise nacheinander ausgelöst und nicht als unbeabsichtigte doppelte Gleichzeitigausgabe gestartet.
- [ ] Pro qualifiziertem Teamabschluss wird höchstens ein Streak-Sound ausgelöst.

## AK-36 — zu F-36 „Streak-State und Reset“

- [ ] Neue Sitzung startet mit `streak = 0`.
- [ ] Erstes vollständig korrektes Ticket setzt `streak = 1`.
- [ ] Zweites vollständig korrektes Ticket in Folge setzt `streak = 2`.
- [ ] Drittes vollständig korrektes Ticket in Folge setzt `streak = 3`.
- [ ] Falsche Priorität setzt die Streak auf 0 beziehungsweise verhindert verbindlich die Fortsetzung der laufenden Streak für dieses Ticket.
- [ ] Falsches Team setzt die Streak auf 0.
- [ ] Beide falsch setzen die Streak auf 0.
- [ ] Nach einer Unterbrechung beginnt das nächste vollständig korrekte Ticket wieder bei Streak 1.
- [ ] „Erneut spielen“ und jeder neue Sitzungsstart beginnen mit Streak 0.
- [ ] Es existiert kein künstlicher Cap; in einer 16-Ticket-Sitzung kann bei vollständiger Korrektheit Streak 16 erreicht werden.

## AK-37 — zu F-37 „Multiplikator-Scoring“

- [ ] Erstes vollständig korrektes Ticket einer Streak ergibt insgesamt 200 Punkte für dieses Ticket.
- [ ] Zweites vollständig korrektes Ticket in Folge ergibt insgesamt 400 Punkte: Priorität +100 und Teamabschluss +300.
- [ ] Drittes vollständig korrektes Ticket in Folge ergibt insgesamt 600 Punkte: Priorität +100 und Teamabschluss +500.
- [ ] Viertes vollständig korrektes Ticket in Folge ergibt insgesamt 800 Punkte.
- [ ] Für Streak `n ≥ 1` gilt bei vollständig korrektem Ticket exakt `200 × n` Ticketpunkte.
- [ ] Priorität richtig + Team falsch ergibt exakt 100 Ticketpunkte und Streak 0.
- [ ] Priorität falsch + Team richtig ergibt exakt 100 Ticketpunkte und Streak 0.
- [ ] Beide falsch ergeben 0 Ticketpunkte und Streak 0.
- [ ] Teilweise richtige Tickets erhalten niemals einen Multiplikator.
- [ ] Die Differenzgutschrift beim Teamabschluss erzeugt keine Doppelzählung und jede Entscheidung bleibt Exactly-once.
- [ ] Die Ergebnisansicht entspricht nach einer Testsequenz exakt der Summe aller Basispunkte und Multiplikatorgutschriften.

## AK-38 — zu F-38 „Streak-Visualisierung“

- [ ] Bei Streak 0 oder 1 erscheint kein Multiplikator-Overlay.
- [ ] Nach Abschluss eines vollständig korrekten zweiten Tickets in Folge erscheint kurz `x2` in der Teamzuordnungsphase und wird danach wieder ausgeblendet.
- [ ] Nach dem dritten vollständig korrekten Ticket erscheint entsprechend `x3`.
- [ ] `x2` und `x3` verwenden dieselbe normale Streak-Darstellung.
- [ ] Ab `x4` erscheint der Multiplikator sichtbar größer als x2/x3 und erhält eine zusätzliche kurze Puls-/Scale-Animation.
- [ ] Für x5 und höher wird dieselbe stärkere Darstellungslogik verwendet.
- [ ] Das Multiplikator-Overlay ist nicht dauerhaft im Session-HUD sichtbar.
- [ ] Die Streak-Anzeige verdeckt Tickettext, Teamziele oder notwendige Bedienelemente nicht dauerhaft.

## AK-39 — zu F-39 „Ressourcenstruktur und zentrale Zuordnung“

- [ ] Die acht Monster-Sounds liegen unter einer klaren `Audio/MonsterSounds`-Struktur mit getrennten Correct-/Incorrect-Gruppen oder einer funktional gleichwertigen Struktur.
- [ ] Die zwei Streak-Sounds liegen getrennt unter `Audio/StreakSounds` oder funktional gleichwertig.
- [ ] Die vier JPEG-Teamlogos liegen gemeinsam in einem Teamlogo-Ressourcenbereich.
- [ ] Die 16 MP4-Dateien liegen gemeinsam in einem Video-Ressourcenbereich und sind über Ticket-ID auffindbar.
- [ ] Ticket-, Team-, Audio- und Videozuordnung wird über zentrale Mappings/Provider/Services vorgenommen; Views enthalten keine verstreuten hart codierten vollständigen Ressourcenpfade.
- [ ] Ein Release-/Simulator-Build findet alle für v1.3 notwendigen Ressourcen ohne Netzwerkzugriff.

---

## Modul-Zuordnung (Übersicht)

Welche Akzeptanzkriterien welches Modul abnimmt:

| Modul | Erfüllt Kriterien |
|---|---|
| 001 | AK-05 |
| 002 | historisch AK-02, AK-03 |
| 003 | AK-04, AK-16 |
| 004 | historisch AK-01 |
| 005 | AK-14 |
| 006 | AK-06, AK-07 |
| 007 | AK-10 |
| 008 | AK-08 |
| 009 | AK-09 |
| 010 | AK-11, AK-12, AK-13 |
| 011 | AK-15, AK-16 |
| 012 | AK-17 |
| 013 | v1.0-Integration |
| 014 | v1.0-Dokumentation/Cleanup |
| 015 | AK-18, AK-20 |
| 016 | AK-19 |
| 017 | AK-22, AK-24 |
| 018 | AK-21 |
| 019 | AK-23 |
| 020 | v1.1-Integration |
| 021 | AK-25 |
| 022 | AK-26, AK-27 |
| 023 | historisch AK-28 |
| 024 | AK-29 |
| 025 | AK-30 |
| 026 | v1.2-Integration |
| 027 | AK-01, AK-02, AK-03, AK-04, AK-22, AK-31 |
| 028 | AK-28, AK-39 (Teamlogo-Anteil) |
| 029 | AK-12, AK-34, AK-35, AK-39 (Audio-Anteil) |
| 030 | AK-03, AK-32, AK-33, AK-39 (Video-Anteil) |
| 031 | AK-11, AK-16, AK-36, AK-37 |
| 032 | AK-18, AK-21, AK-35, AK-38 |
| 033 | AK-01 bis AK-39 als v1.3-Regressions-/Integrationstest, Schwerpunkt AK-31 bis AK-39 |
