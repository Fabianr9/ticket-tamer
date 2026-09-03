# Ticket Tamer – 16 kreative Ticket-Kandidaten

## Hinweis zur aktuellen Projektspezifikation

Der aktuelle Projektstand sieht **genau 12 lokale Tickets** vor und deckt dabei jede Kombination aus
**4 Teams × 3 Prioritäten** genau einmal ab. Deshalb sind **TT-001 bis TT-012** als direkt passender
12er-Basiskatalog aufgebaut. **TT-013 bis TT-016** sind zusätzliche Reserve-/Erweiterungstickets.

Wenn später tatsächlich alle 16 Tickets gleichzeitig in den produktiven Katalog übernommen werden,
müssen SPEC, Akzeptanzkriterien und die entsprechenden Tests angepasst werden.

## Referenzwerte

**Prioritäten:** Normal · Wichtig · Kritisch  
**Teams:** Netzwerk · Konto · Software · Hardware

---

## TT-001 – Das WLAN hat einen Lieblingsplatz

**Kurzbeschreibung:**  
Mein WLAN scheint heute sehr wählerisch zu sein. Am Schreibtisch funktioniert alles, aber sobald ich
mit dem Laptop in die kleine Sitzecke gehe, verschwindet die Verbindung. Wenn ich zwei Schritte zurück
zum Tisch mache, ist sie plötzlich wieder da. Vielleicht ist das WLAN einfach schüchtern.

**User Impact:**  
Eine Person kann in einem kleinen Bereich nicht drahtlos arbeiten. Am eigenen Arbeitsplatz funktioniert
die Verbindung weiterhin.

**Symptome / Hinweise:**
- WLAN bricht nur in einem bestimmten Bereich ab.
- Am normalen Arbeitsplatz besteht eine stabile Verbindung.
- Andere Arbeitsmöglichkeiten sind vorhanden.

**Referenzpriorität:** Normal  
**Referenzteam:** Netzwerk

---

## TT-002 – Die Videokonferenz teleportiert uns

**Kurzbeschreibung:**  
Unsere Besprechungen haben ein neues Feature: Alle paar Minuten friert das Bild ein und danach fehlen
plötzlich zehn Sekunden Gespräch. Das passiert in mehreren Konferenzräumen auf unserer Etage.
An den verkabelten Arbeitsplätzen läuft das Netz dagegen problemlos.

**User Impact:**  
Mehrere Teams können Videokonferenzen nur eingeschränkt durchführen. Normale Arbeit an verkabelten
Arbeitsplätzen ist weiterhin möglich.

**Symptome / Hinweise:**
- Mehrere Konferenzräume derselben Etage sind betroffen.
- Drahtlose Verbindungen brechen wiederholt ein.
- Kabelgebundene Arbeitsplätze funktionieren.

**Referenzpriorität:** Wichtig  
**Referenzteam:** Netzwerk

---

## TT-003 – Das Internet ist spontan in den Urlaub gefahren

**Kurzbeschreibung:**  
Seit wenigen Minuten ist unser gesamtes Büro digital von der Außenwelt abgeschnitten. Webseiten laden
nicht, interne Dienste sind nicht erreichbar und selbst die Kaffeemaschine mit Netzwerkanschluss blinkt
beleidigt. Niemand im Gebäude kommt aktuell ins Firmennetz.

**User Impact:**  
Das gesamte Büro kann zentrale Netzwerkdienste und Internetzugänge nicht verwenden. Der reguläre
Arbeitsbetrieb steht weitgehend still.

**Symptome / Hinweise:**
- Alle Arbeitsplätze sind betroffen.
- Internet und interne Netzwerkdienste sind gleichzeitig nicht erreichbar.
- Es gibt aktuell keinen funktionierenden Netzwerkzugang.

**Referenzpriorität:** Kritisch  
**Referenzteam:** Netzwerk

---

## TT-004 – Mein Passwort kennt mich nicht mehr

**Kurzbeschreibung:**  
Ich habe heute Morgen mein Passwort geändert und seitdem behauptet mein Benutzerkonto, wir hätten uns
noch nie gesehen. Nach drei Versuchen wurde ich ausgesperrt. Lokal kann ich an meinem Rechner noch
weiterarbeiten, aber anmelden kann ich mich am betroffenen Dienst nicht mehr.

**User Impact:**  
Eine einzelne Person kann sich an einem Dienst nicht anmelden. Andere Personen und lokale Arbeit sind
nicht betroffen.

**Symptome / Hinweise:**
- Problem begann unmittelbar nach einer Passwortänderung.
- Nur ein Benutzerkonto ist betroffen.
- Das Konto wurde nach mehreren Versuchen gesperrt.

**Referenzpriorität:** Normal  
**Referenzteam:** Konto

---

## TT-005 – Die Buchhaltung steht vor der digitalen Zugbrücke

**Kurzbeschreibung:**  
Acht Personen aus der Buchhaltung stehen gerade vor unserem Abrechnungssystem wie vor einer Burg ohne
Zugbrücke. Die Anmeldung wird für alle acht Konten abgelehnt. Andere Programme funktionieren und
Kollegen außerhalb der Buchhaltung können sich normal anmelden.

**User Impact:**  
Ein komplettes Fachteam kann eine wichtige Anwendung nicht nutzen. Andere Unternehmensbereiche können
weiterarbeiten.

**Symptome / Hinweise:**
- Mehrere Konten derselben Abteilung sind betroffen.
- Die Anmeldung an einem geschäftskritischen Dienst schlägt fehl.
- Andere Benutzergruppen können sich weiterhin anmelden.

**Referenzpriorität:** Wichtig  
**Referenzteam:** Konto

---

## TT-006 – Der digitale Türsteher lässt niemanden mehr rein

**Kurzbeschreibung:**  
Unser zentrales Anmeldesystem hat offenbar beschlossen, heute besonders streng zu sein: Es weist jedes
Benutzerkonto ab. Egal ob Support, Verwaltung oder Geschäftsführung – niemand kommt in die zentralen
Anwendungen. Lokale Rechner starten zwar, danach endet die Reise aber an der Anmeldung.

**User Impact:**  
Nahezu alle Mitarbeitenden können zentrale Unternehmensanwendungen nicht mehr verwenden.

**Symptome / Hinweise:**
- Alle getesteten Benutzerkonten sind betroffen.
- Mehrere zentrale Anwendungen können nicht geöffnet werden.
- Die gemeinsame Anmeldung schlägt unternehmensweit fehl.

**Referenzpriorität:** Kritisch  
**Referenzteam:** Konto

---

## TT-007 – Meine Tabelle spricht plötzlich Hieroglyphen

**Kurzbeschreibung:**  
Meine Tabellenanwendung hat heute Morgen beschlossen, moderne Kunst zu machen. Einige Symbole werden
falsch dargestellt und ein Menü sieht aus, als hätte jemand die Beschriftungen durcheinandergewürfelt.
Die Datei selbst ist noch da und über die Web-Version kann ich weiterarbeiten.

**User Impact:**  
Eine Person hat Darstellungsprobleme in einer Anwendung. Es existiert ein funktionierender Workaround.

**Symptome / Hinweise:**
- Nur eine lokale Anwendung ist betroffen.
- Dateien und Daten sind weiterhin vorhanden.
- Die Web-Version funktioniert.

**Referenzpriorität:** Normal  
**Referenzteam:** Software

---

## TT-008 – Die Präsentation frisst ihre eigenen Folien

**Kurzbeschreibung:**  
Unsere Präsentationssoftware beendet sich jedes Mal, sobald wir die aktuelle Kampagnenpräsentation
öffnen. Inzwischen sitzen sechs Personen vor ihren Rechnern und beobachten denselben Absturz.
Ältere Präsentationen lassen sich noch öffnen, aber an der aktuellen Kampagne können wir nicht arbeiten.

**User Impact:**  
Ein Team kann an einem wichtigen gemeinsamen Arbeitsstand nicht weiterarbeiten. Andere Dateien und
Anwendungen funktionieren weiterhin.

**Symptome / Hinweise:**
- Mehrere Personen erleben denselben Anwendungsabsturz.
- Der Fehler tritt bei der aktuellen Arbeitsdatei reproduzierbar auf.
- Andere Präsentationen lassen sich öffnen.

**Referenzpriorität:** Wichtig  
**Referenzteam:** Software

---

## TT-009 – Das Bestellsystem ist in der Zeit eingefroren

**Kurzbeschreibung:**  
Unser Bestellsystem zeigt zwar noch alle Knöpfe, aber keiner davon scheint sich für Arbeit zu
interessieren. Neue Bestellungen lassen sich unternehmensweit weder speichern noch abschließen.
Mehrere Teams haben es getestet – überall dasselbe Ergebnis. Aktuell verlässt keine neue Bestellung das System.

**User Impact:**  
Ein zentraler Geschäftsprozess ist für alle betroffenen Abteilungen vollständig gestoppt.

**Symptome / Hinweise:**
- Alle Nutzer der Anwendung sind betroffen.
- Neue Bestellungen können nicht gespeichert oder abgeschlossen werden.
- Es gibt keinen bekannten Workaround.

**Referenzpriorität:** Kritisch  
**Referenzteam:** Software

---

## TT-010 – Der Drucker übt für seine Traktorprüfung

**Kurzbeschreibung:**  
Seit heute Morgen führt mein Drucker ein Eigenleben. Erst hat er drei leere Seiten ausgespuckt, dann
eine Seite mit halbem Text und jetzt macht er nur noch Geräusche, als würde er einen Traktor imitieren.
Drucken kann ich allerdings nichts mehr. Bitte schicken Sie jemanden, bevor er endgültig kündigt.

**User Impact:**  
Ein Arbeitsplatz kann diesen Drucker nicht verwenden. Ein anderer Drucker im Nachbarraum steht als
Ausweichmöglichkeit zur Verfügung.

**Symptome / Hinweise:**
- Ausdrucke sind leer oder nur teilweise bedruckt.
- Das Gerät erzeugt ungewöhnlich laute mechanische Geräusche.
- Ein alternativer Drucker ist verfügbar.

**Referenzpriorität:** Normal  
**Referenzteam:** Hardware

---

## TT-011 – Der Konferenzbildschirm hat Schneetag

**Kurzbeschreibung:**  
Der große Bildschirm im Hauptkonferenzraum zeigt nur noch schwarzes Bild und gelegentlich digitales
Schneegestöber. Heute stehen mehrere Kundentermine an. Ein kleiner Ersatzraum funktioniert zwar, dort
passen aber nur wenige Personen hinein.

**User Impact:**  
Mehrere geplante Kundentermine sind beeinträchtigt. Ein eingeschränkter Ausweichraum ist vorhanden.

**Symptome / Hinweise:**
- Der zentrale Konferenzbildschirm liefert kein nutzbares Bild.
- Mehrere Termine am selben Tag sind betroffen.
- Es existiert nur ein begrenzter Workaround.

**Referenzpriorität:** Wichtig  
**Referenzteam:** Hardware

---

## TT-012 – Der Dateiserver veranstaltet eine Lichtshow

**Kurzbeschreibung:**  
Im Serverraum blinkt unser zentrales Speichergerät plötzlich wie eine Diskokugel und gibt einen
Daueralarm von sich. Gleichzeitig sind die gemeinsamen Laufwerke im ganzen Unternehmen verschwunden.
Niemand kommt an die dort gespeicherten Arbeitsdateien.

**User Impact:**  
Unternehmensweit können zentrale Dateien nicht geöffnet oder gespeichert werden. Zahlreiche
Arbeitsprozesse sind blockiert.

**Symptome / Hinweise:**
- Das zentrale Speichergerät meldet einen physischen Fehlerzustand.
- Gemeinsame Laufwerke sind für alle Nutzer ausgefallen.
- Es steht aktuell kein Ersatzspeicher zur Verfügung.

**Referenzpriorität:** Kritisch  
**Referenzteam:** Hardware

---

# Zusätzliche Reserve-/Erweiterungstickets

## TT-013 – Das Homeoffice steckt im VPN-Labyrinth

**Kurzbeschreibung:**  
Seit heute Nachmittag kommen unsere Mitarbeitenden im Homeoffice zwar bis zum VPN-Login, danach dreht
sich die Verbindung aber im Kreis und bricht ab. Im Büro funktioniert das Firmennetz normal.
Mehrere Remote-Kollegen melden denselben Effekt.

**User Impact:**  
Viele Mitarbeitende im Homeoffice können interne Dienste nicht erreichen. Mitarbeitende vor Ort sind
nicht betroffen.

**Symptome / Hinweise:**
- Mehrere externe Verbindungen sind betroffen.
- Das interne Netz im Büro funktioniert.
- Der Fehler tritt beim Aufbau der VPN-Verbindung auf.

**Referenzpriorität:** Wichtig  
**Referenzteam:** Netzwerk

---

## TT-014 – Die Zwei-Faktor-Anmeldung lebt in einer Zeitschleife

**Kurzbeschreibung:**  
Bei meiner Anmeldung erscheint immer wieder dieselbe Bestätigungsabfrage. Ich bestätige sie am Handy,
der Rechner denkt kurz nach und zeigt mir anschließend exakt dieselbe Abfrage noch einmal.
Alle anderen Kollegen können sich normal anmelden.

**User Impact:**  
Eine Person kann sich an einem geschützten Dienst nicht anmelden. Andere Nutzer sind nicht betroffen.

**Symptome / Hinweise:**
- Nur ein Benutzerkonto ist betroffen.
- Die Mehrfaktor-Bestätigung wird akzeptiert, aber nicht abgeschlossen.
- Andere Benutzer können sich normal anmelden.

**Referenzpriorität:** Normal  
**Referenzteam:** Konto

---

## TT-015 – Das Ticketsystem züchtet Klone

**Kurzbeschreibung:**  
Unser Supportsystem hat eine neue Superkraft entdeckt: Aus einem neuen Ticket werden manchmal gleich
drei. Seit heute Morgen müssen mehrere Support-Mitarbeitende ständig Ticket-Klone aussortieren.
Arbeiten können wir noch, aber die Warteschlange wird zunehmend chaotisch.

**User Impact:**  
Das Supportteam kann weiterarbeiten, benötigt aber erheblichen manuellen Mehraufwand und riskiert
Doppelbearbeitungen.

**Symptome / Hinweise:**
- Neu angelegte Tickets erscheinen mehrfach.
- Mehrere Support-Mitarbeitende sind betroffen.
- Eine manuelle Bereinigung ist als Workaround möglich.

**Referenzpriorität:** Wichtig  
**Referenzteam:** Software

---

## TT-016 – Die Lager-Scanner haben kollektiv Feierabend

**Kurzbeschreibung:**  
Alle Handscanner im Versandlager bleiben seit wenigen Minuten dunkel. Ersatzakkus bringen nichts und
auch die Ladestationen zeigen keine Reaktion. Ohne die Geräte können keine Pakete verbucht oder
freigegeben werden – inzwischen wächst der Paketberg sichtbar.

**User Impact:**  
Der komplette Versandprozess ist gestoppt. Keine ausgehenden Pakete können regulär verarbeitet werden.

**Symptome / Hinweise:**
- Alle Scanner im Versandbereich sind gleichzeitig nicht nutzbar.
- Akkutausch behebt das Problem nicht.
- Ohne die Geräte ist keine Versandfreigabe möglich.

**Referenzpriorität:** Kritisch  
**Referenzteam:** Hardware

---

## Verteilung

### Basiskatalog TT-001 bis TT-012

| Team | Normal | Wichtig | Kritisch |
|---|---|---|---|
| Netzwerk | TT-001 | TT-002 | TT-003 |
| Konto | TT-004 | TT-005 | TT-006 |
| Software | TT-007 | TT-008 | TT-009 |
| Hardware | TT-010 | TT-011 | TT-012 |

Damit decken die ersten zwölf Tickets jede Team-Prioritäts-Kombination genau einmal ab.

### Reserve

| Ticket | Team | Priorität |
|---|---|---|
| TT-013 | Netzwerk | Wichtig |
| TT-014 | Konto | Normal |
| TT-015 | Software | Wichtig |
| TT-016 | Hardware | Kritisch |
