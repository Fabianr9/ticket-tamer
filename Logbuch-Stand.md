# Projektlogbuch — Ticket Tamer

> Laufendes Gedächtnis und Steuerungsdokument des Projekts. Nach jedem eingearbeiteten Modul-Report wird diese Datei vollständig aktualisiert und als einziger aktueller `Logbuch-Stand.md` ersetzt.

**Stand:** Initialisierung vor Modul `001`  
**Datum:** 2026-07-15  
**Git-Commit:** noch keiner für Modul 001 dokumentiert

## Verbindlicher Projektumfang

Ticket Tamer ist ein visionOS-Trainingsspiel für Apple Vision Pro. Nutzende bearbeiten eine kurze Sitzung aus 1 bis 12 lokal gespeicherten Support-Tickets. Jedes Ticket wird als Monster dargestellt, zunächst anhand einer deutschen Ticketkarte untersucht, anschließend per Blickfokus, Pinch und Drag einer Priorität und danach einem Support-Team zugeordnet. Die Anwendung läuft als linearer Ablauf in genau einem zentralen Volume, berechnet je richtiger Teilentscheidung 100 Punkte, gibt nur akustisches Richtig-/Falsch-Feedback und zeigt am Ende ausschließlich die Gesamtpunktzahl sowie „Erneut spielen“.

Zum Muss-Umfang gehören genau zwölf lokale Tickets, vier eigene Blender-Monster, zwei lokale Sounds, ein vollständiger Reset und ein stabiler Ablauf ohne Backend, Konten, Datenbank, Cloud, persistente Spielhistorie, Immersive Space, zweites Volume, Tutorial, Detailstatistiken oder alternative 2D-Auswahl für die beiden Kernentscheidungen. Die Monsterreaktion nach einer Entscheidung ist ausschließlich eine Kann-Funktion.

## Modul-Status

| Modul | Titel | Status | Git-Commit | Erfüllt laut SPEC |
|---|---|---|---|---|
| 001 | Projektgrundgerüst und zentrales Volume | offen | – | F-05, struktureller Anteil von AK-05 |
| 002 | Ticketdatenmodell und lokaler Katalog | offen | – | F-02, F-03 |
| 003 | Sitzungsmodell und Zufallsauswahl | offen | – | F-04, F-16 |
| 004 | Startansicht und Einstellungen | offen | – | F-01 |
| 005 | Monster-Asset-Pipeline | offen | – | F-14 |
| 006 | Untersuchungsphase | offen | – | F-06, F-07 |
| 007 | Räumliche Interaktionsgrundlagen | offen | – | F-10 |
| 008 | Priorisierungsphase | offen | – | F-08 |
| 009 | Teamzuordnungsphase | offen | – | F-09 |
| 010 | Bewertung und Audiofeedback | offen | – | F-11, F-12, F-13 |
| 011 | Ergebnis und Neustart | offen | – | F-15, F-16 |
| 012 | Optionale Monsterreaktion | offen, Kann-Modul | – | F-17 |
| 013 | Integration und Gerätetest | offen | – | F-01 bis F-16 als Integrationstest |
| 014 | Abschlussmodul: Doku & Cleanup | offen | – | Dokumentenkonsistenz und Abgabeprüfung |

## Prüfung der Modul-Landkarte

### Gesamtbewertung

Die Landkarte ist für den Muss-Umfang grundsätzlich sinnvoll. Datenmodell und Sitzungslogik liegen vor den Views, die 3D-Assets liegen vor den monsterabhängigen Phasen, die allgemeine räumliche Interaktion liegt vor Priorisierung und Teamzuordnung, und Bewertung, Ergebnis sowie Integration schließen den Kernablauf nachvollziehbar ab.

Der Umfang ist bis zur Abgabe realistisch, aber nur bei strenger Begrenzung auf F-01 bis F-16. Die größten Termin- und Integrationsrisiken liegen in Modul 005, 007, 010 und 013: Blender-/USDZ-Pipeline, visionOS-Gesten und Zielerkennung, verzögerte Zustandsübergänge mit Audio sowie Tests auf echter Apple Vision Pro.

### Technische Abhängigkeiten

- `001` ist die gemeinsame Basis und muss vor paralleler Implementierung abgeschlossen werden.
- `002 → 003 → 004` ist eine klare Kette für Daten, Sitzung und Startansicht.
- `005` kann in der Asset-Erstellung früh vorbereitet werden; die endgültige Ticketzuordnung benötigt jedoch die Schnittstellen aus `002`.
- `006` benötigt Ticketdaten, Sitzung und verwendbare Monster-Assets.
- `007` benötigt mindestens eine funktionierende, interaktive Monster-Entity und das zentrale Volume.
- `008` baut auf dem Sitzungszustand, der Untersuchungsphase und der allgemeinen Drop-Logik auf.
- `009` sollte die in `008` bewährten Interaktions- und Zustandsübergänge wiederverwenden und deshalb erst danach integriert werden.
- `010` benötigt beide gespeicherten Entscheidungen und muss Doppelbewertung, Eingabesperre, Audio und den automatischen Übergang gemeinsam absichern.
- `011` nutzt die Reset-Logik aus `003`, vervollständigt sie aber erst aus Sicht der Ergebnisansicht.
- `013` bleibt die vollständige Abnahme aller Muss-Kriterien; Modulabnahmen davor ersetzen den Gesamttest nicht.

### Mögliche Parallelisierung für drei Entwickler

| Phase | Entwickler A | Entwickler B | Entwickler C | Integrationspunkt |
|---|---|---|---|---|
| Nach 001 | 002 Ticketmodell/Katalog | Vorbereitung 005 Blender-Assets | Testkonzept, Sound-/Lizenzvorbereitung und technischer Interaktions-Spike für 007 | Schnittstellen aus 002 bestätigen |
| Nach 002 | 003 Sitzungsmodell | 005 Export und Einbindung abschließen | Tests für 002/003 und Vorbereitung 007 | Build und Projekt-Stand gemeinsam prüfen |
| Nach 003 und 005 | 004 Startansicht oder 006 Ticketkarte | 007 Interaktionsgrundlagen | 006 Monster-/Ticketdarstellung oder Gerätetest-Unterstützung | Gemeinsames Entity-/State-Verhalten festlegen |
| Danach | 008 Priorisierung | Vorbereitung 009 Teamstationen | Tests für Drop-Logik und Eingabesperre | 008 vollständig integrieren |
| Kernabschluss | 009 Teamzuordnung | 010 Audio/Bewertung vorbereiten | Tests und Fehleranalyse | 009, dann 010 integrieren |
| Abschluss | 011 Ergebnis/Reset | 013 Gerätetest | Dokumentation und Abgabevorbereitung | Muss-Kriterien vor Kann-Modul sichern |

Parallelisierung bedeutet hier vor allem getrennte Dateien, Assets und Tests. Gemeinsame zentrale Dateien wie App-Einstieg, Sitzungsmodell und Projektdatei sollen möglichst nur von einer Person gleichzeitig geändert werden.

## Änderungsvorschläge — ausdrücklich nicht stillschweigend übernommen

| ID | Vorschlag | Begründung | Status |
|---|---|---|---|
| V-01 | Für widersprüchliche Aussagen gilt: Projektbeschreibung, SPEC und Akzeptanzkriterien bestimmen den Funktionsumfang; der Start-Prompt bestimmt Arbeitsweise und den beschriebenen Ausgangsstand. | Der Start-Prompt nennt eine englische UI, Window plus Volume, Monster-Austausch in Modul 011 und Branding in Modul 012. Dies widerspricht der aktuellen SPEC mit deutscher UI, genau einem zentralen Volume, Monster-Modul 005 und optionaler Monsterreaktion in Modul 012. | Für die initialen Dokumente angewendet; keine SPEC-Anforderung geändert. |
| V-02 | AK-05 in Modul 001 nur als strukturellen Teilnachweis behandeln; vollständige Abnahme erst in Modul 013. | Modul 001 kann ein einziges Volume und die Navigationsgrundlage schaffen, aber noch nicht den vollständigen Ablauf mit allen späteren Phasen durchspielen. | Dokumentationspräzisierung; Modul-Zuordnung der SPEC bleibt formal unverändert. |
| V-03 | Optionales Modul 012 erst nach erfolgreichem Muss-Integrationstest 013 durchführen oder nur bei gesichertem Zeitpuffer beginnen. | F-17 ist nicht abgabekritisch. Eine Animation darf die Stabilisierung von F-01 bis F-16 nicht verzögern. | Empfehlung, noch keine Änderung der verbindlichen Reihenfolge. |
| V-04 | Asset-Erstellung aus Modul 005 parallel zu 002 und 003 vorbereiten, die endgültige Integration aber erst nach Erfüllung der Abhängigkeiten abschließen. | Blender-Arbeit blockiert keine Swift-Datenmodelle; frühe Asset-Prototypen reduzieren das Risiko für 006 und 007. | Parallelisierungsvorschlag, keine Moduländerung. |

## Schnittstellen-Register

Noch keine Schnittstellen aus abgeschlossenen Modulen vorhanden.

| Bereitgestellt von | Typ / Methode | Zweck |
|---|---|---|
| – | – | Vor Modul 001 ist keine implementierte Projektschnittstelle bestätigt. |

### Bereitgestellte, noch nicht integrierte Vorlage

- `DebugManager.swift` ist als externe Vorlage vorhanden. Die Vorlage bietet kategorisiertes Logging mit den Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state` und `audio`. Erst Modul 001 darf sie kontrolliert in das Xcode-Projekt integrieren.

## Entscheidungs-Log

| Datum | Entscheidung | Begründung |
|---|---|---|
| 2026-07-15 | Die Dokumentationsstruktur unter `Dokumentation/` wird verbindlich festgelegt. | Eingangsprompts, Reports, aktueller Stand und Abgabeunterlagen müssen dauerhaft eindeutig auffindbar sein. |
| 2026-07-15 | Die interne Swift-/Xcode-Ordnerstruktur wird vor Modul 001 nicht als Ist-Zustand festgeschrieben. | Das vorhandene Projekt muss zuerst analysiert werden; bestehende Dateien und Target-Zugehörigkeiten dürfen nicht erfunden werden. |
| 2026-07-15 | Code-Wahrheitsstand ist ausschließlich das aktuelle Xcode-Projekt plus Git. | Der Projektraum soll keine alten oder doppelten Codekopien enthalten. |
| 2026-07-15 | `Logbuch-Stand.md` und `Projekt-Stand.md` existieren jeweils nur einmal als aktueller Stand und werden ersetzt. | Dadurch bleiben Übergaben für neue Chats eindeutig und frei von Altständen. |
| 2026-07-15 | Bei Scope-Widersprüchen haben Projektbeschreibung, SPEC und Akzeptanzkriterien Vorrang vor abweichenden technischen Stichpunkten im Start-Prompt. | Die drei Kontextdokumente sind konsistent und definieren den aktuellen Scope; der Start-Prompt verweist selbst auf die SPEC als verbindliche Modul-Landkarte. |
| 2026-07-15 | Sichtbare App-Texte sind Deutsch. Eine mögliche String-Catalog-Grundlage darf dies nicht in eine englische UI ändern. | F-01, nicht-funktionale Sprachvorgabe und Projektbeschreibung verlangen Deutsch. |
| 2026-07-15 | Modul 001 darf keine Ticketlogik, Monster-Pipeline, Interaktionsmechanik oder Bewertung aus späteren Modulen vorwegnehmen. | Die Architektur soll einfach bleiben und Merge-Konflikte durch klar abgegrenzte Module reduzieren. |

## Offene Punkte / Risiken

- [ ] Modul 001 muss den tatsächlichen Dateibaum, die Xcode-Gruppen, physischen Ordner, Target-Namen und Target-Mitgliedschaften prüfen.
- [ ] Der aktuelle App-Einstieg mit `WindowGroup { ContentView() }` muss kontrolliert an die verbindliche Ein-Volume-Anforderung angepasst werden.
- [ ] Die zwölf konkreten Ticketinhalte müssen in Modul 002 erstellt und fachlich auf eindeutige Priorität und Teamzuordnung geprüft werden.
- [ ] Namen, Stil, Polygonbudget und Exportparameter der vier Monster sind offen.
- [ ] Erfolgssound, Fehlersound, Rechte und Lautstärke müssen festgelegt und auf dem Gerät geprüft werden.
- [ ] Zugriff und Zeitfenster für Apple-Vision-Pro-Tests müssen frühzeitig gesichert werden.
- [ ] Die Entscheidung über F-17 bleibt offen; das Kann-Modul darf Muss-Funktionen nicht gefährden.
- [ ] Die endgültige Aufteilung auf drei Entwickler und Regeln für gemeinsame Dateien müssen vor parallelen Branches festgelegt werden.
- [ ] Xcode-Projektdateien können bei parallelen Gruppen-/Target-Änderungen Merge-Konflikte erzeugen; Strukturänderungen deshalb zentral in Modul 001 durchführen.

## Chronik

Noch kein Modul abgeschlossen.

### Initialisierung — 2026-07-15

Die Projektunterlagen, Vorlagen, der beschriebene Xcode-Ausgangsstand und die DebugManager-Vorlage wurden geprüft. Die Dokumentationsstruktur wurde festgelegt, die Modul-Landkarte bewertet und widersprüchliche ältere Angaben im Start-Prompt wurden als dokumentierte Abweichungen erfasst. Als nächster Schritt wird Modul 001 mit Analyse des realen Xcode-Projekts, Einrichtung einer einfachen Struktur, Integration des DebugManagers und Absicherung eines einzigen zentralen Volumes beauftragt.

## Nächster Schritt

`001-Eingangsprompt.md` in einen neuen Modul-Chat geben. Nach Abschluss ausschließlich den vollständigen `001-Report.md`, den Git-Commit beziehungsweise Hash sowie den tatsächlich aktualisierten Dateibaum an dieses Projektlogbuch zurückgeben.
