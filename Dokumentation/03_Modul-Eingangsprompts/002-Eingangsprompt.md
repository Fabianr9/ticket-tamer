# Modul-Eingangsprompt — 002 Ticketdatenmodell und lokaler Katalog

> Vom Projektlogbuch nach Abschluss von Modul 001 erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 002 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst die aktuellen Dateien aus dem Git-Branch beziehungsweise `main` und baue nur das Ticketdatenmodell und den lokalen Ticketkatalog. Erfinde keine vorhandenen Dateien, Gruppen, Targets oder Schnittstellen.

## Modul

**Nummer:** 002  
**Titel:** Ticketdatenmodell und lokaler Katalog  
**Ziel:** Das Projekt erhält einfache, klar benannte fachliche Ticketdatentypen und genau zwölf vollständig lokale, statische Support-Tickets, sodass jede Kombination aus vier Support-Teams und drei Prioritäten genau einmal vorkommt.

## Git- und Ausgangsstand

- Abgeschlossener Modul-001-Branch: `feature/001-project-foundation`
- Commit: `[COMMIT-HASH EINTRAGEN]`
- Merge in `main`: `[JA / NOCH NICHT]`
- Modul 001 ist technisch erfolgreich abgeschlossen.
- Vor Beginn muss geprüft werden, auf welchem Branch der bestätigte Modul-001-Stand tatsächlich verfügbar ist.
- Arbeite nicht auf einem Stand, in dem die Dateien oder Struktur aus Modul 001 fehlen.
- Erfinde keinen Commit-Hash und keinen Merge-Status.

## Zu erfüllende Anforderungen

### SPEC F-02

> Das System enthält genau 12 lokal definierte Tickets. Der Ticketpool deckt jede Kombination aus den Prioritäten Normal, Wichtig und Kritisch sowie den Teams Netzwerk, Konto, Software und Hardware genau einmal ab.

### SPEC F-03

> Jedes Ticket enthält mindestens Ticketnummer, Titel, Kurzbeschreibung, User Impact, ein bis drei Symptome oder Hinweise, eine Referenzpriorität und ein Referenzteam.

### Akzeptanzkriterien AK-02 — Lokaler Ticketpool

- GEGEBEN der lokale Ticketkatalog wird geprüft, WENN alle Einträge gezählt werden, DANN enthält er genau 12 Tickets.
- GEGEBEN die Referenzwerte aller Tickets werden ausgewertet, WENN Team und Priorität kombiniert werden, DANN kommt jede der 12 Kombinationen aus 4 Teams und 3 Prioritäten genau einmal vor.
- Kein Ticket benötigt zum Laden eine Netzwerkverbindung oder eine externe Datenquelle.

### Akzeptanzkriterien AK-03 — Vollständige Ticketdaten

- GEGEBEN ein beliebiges Ticket aus dem Katalog, WENN dessen Daten geprüft werden, DANN sind Ticketnummer, Titel, Kurzbeschreibung, User Impact, 1 bis 3 Symptome beziehungsweise Hinweise, Referenzpriorität und Referenzteam vorhanden.
- Kein Ticket enthält mehr als drei Symptome beziehungsweise Hinweise.
- Kein Ticket besitzt mehr als eine Referenzpriorität oder mehr als ein Referenzteam.

## Relevanter bestehender Projektstand aus Modul 001

### Bestätigter Codebaum

```text
Ticket_Tamer/
├─ Ticket_Tamer/
│  ├─ App/
│  │  └─ Ticket_TamerApp.swift
│  ├─ Debug/
│  │  └─ DebugManager.swift
│  ├─ Resources/
│  │  └─ Localizable.xcstrings
│  ├─ Support/
│  │  └─ AppConstants.swift
│  ├─ Views/
│  │  └─ RootVolumeView.swift
│  ├─ Assets.xcassets
│  └─ Info.plist
├─ Ticket_TamerTests/
│  └─ Ticket_TamerTests.swift
├─ Packages/
│  └─ RealityKitContent/
└─ Ticket_Tamer.xcodeproj/
```

### Verfügbare Schnittstellen

- `Ticket_TamerApp` — App-Einstieg mit genau einer volumetrischen Scene.
- `RootVolumeView` — minimale Root-Oberfläche im zentralen Volume.
- `DebugManager`
- `DebugManager.Category` mit `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`
- `DebugManager.log(_:_:function:)`
- `DebugManager.toggle(_:)`
- `LayoutConstants`
- `GameplayConstants`
- `AssetKeys`

### Relevante bestehende Konstanten

- `GameplayConstants.minimumTicketCount = 1`
- `GameplayConstants.maximumTicketCount = 12`
- `GameplayConstants.defaultTicketCount = 6`

### Build- und Testgrundlage

- Build erfolgreich.
- Simulatorstart erfolgreich.
- Test-Suite: `TicketTamerTests`.
- Testplattform: `arm64-apple-xros1.0-simulator`.
- 1 von 1 bestehendem Test bestanden.

## Verbindliche Modulgrenze

Modul 002 bearbeitet ausschließlich:

- fachliche Enumerationen für Priorität und Support-Team,
- den Ticket-Datentyp,
- genau zwölf statische lokale Ticketdatensätze,
- eine einfache, lokale Zugriffsstelle auf den vollständigen Katalog,
- Tests für F-02, F-03, AK-02 und AK-03,
- unmittelbar dafür notwendige Dokumentation und Projektstruktur.

Modul 002 bearbeitet ausdrücklich nicht:

- Sitzungszustand,
- Auswahl einer gewünschten Ticketanzahl,
- Zufallsauswahl,
- Auswahl ohne Wiederholung für eine Sitzung,
- aktuelle Sitzungstickets,
- Ticketindex,
- Spielphasen,
- Score oder Bewertung,
- Eingabesperre,
- Reset oder Neustart,
- Startansicht oder Regler,
- Monster-Auswahl- oder Asset-Ladelogik,
- RealityKit-Entities,
- Drag-and-Drop,
- Audio,
- Ergebnisansicht.

Diese ausgeschlossenen Bereiche gehören zu Modul 003 oder späteren Modulen.

## Konkreter Arbeitsauftrag

### 1. Aktuellen Projektstand prüfen

Prüfe vor Änderungen:

- tatsächliche Lage der Dateien aus Modul 001,
- aktiven Branch und Verfügbarkeit des bestätigten Modul-001-Stands,
- App- und Test-Target,
- vorhandene physische Ordner und synchronisierte Xcode-Gruppen,
- aktuellen erfolgreichen Build und bestehenden Test,
- ob bereits Tickettypen oder Ticketdaten existieren.

Falls bereits Ticketdateien existieren, dokumentiere sie und entscheide kontrolliert, ob sie ergänzt, ersetzt oder entfernt werden müssen. Lege keine parallelen Alt- oder Kopiedateien an.

### 2. Einfache fachliche Struktur einrichten

Lege nur die für dieses Modul notwendigen Bereiche an. Eine einfache Trennung ist zu bevorzugen, zum Beispiel:

- fachliche Modelle unter einem Bereich wie `Models/`,
- statischer Katalog unter einem Bereich wie `Data/` oder `Catalog/`,
- Tests im bestehenden `Ticket_TamerTests`-Target.

Die konkreten Pfade sind nach Analyse des realen Projekts festzulegen und im Report zu dokumentieren. Es sollen keine leeren Ordner, keine Repository-Schicht, keine Datenbank-Abstraktion, kein Netzwerk-Service und kein Dependency-Injection-Container entstehen.

### 3. Fachliche Enumerationen definieren

Es werden genau die fachlich benötigten Werte abgebildet:

**Prioritäten**

- Normal
- Wichtig
- Kritisch

**Support-Teams**

- Netzwerk
- Konto
- Software
- Hardware

Anforderungen:

- intern stabile und nachvollziehbare Werte,
- sichtbare deutsche Bezeichnungen müssen später eindeutig ableitbar sein,
- keine zusätzliche Priorität,
- kein zusätzliches Team,
- keine Zuordnung zu UI-Farben, Punkten, Sounds oder RealityKit-Entities in diesem Modul,
- keine Sitzungslogik innerhalb der Enumerationen.

### 4. Ticket-Datentyp definieren

Der Ticket-Datentyp muss mindestens enthalten:

- stabile eindeutige ID,
- Ticketnummer,
- Titel,
- Kurzbeschreibung,
- User Impact,
- ein bis drei Symptome beziehungsweise Hinweise,
- genau eine Referenzpriorität,
- genau ein Referenzteam.

Die SPEC-Architekturskizze nennt zusätzlich `monsterAssetId`. Prüfe diesen Punkt bewusst:

- Falls das Feld bereits jetzt als reines fachliches beziehungsweise logisches Datenfeld umgesetzt wird, darf es keine Asset-Lade-, Auswahl- oder RealityKit-Logik enthalten.
- Falls die endgültige Monsterzuordnung bewusst Modul 005 überlassen wird, dokumentiere diese Abgrenzung im Report.
- Ändere die SPEC nicht stillschweigend und begründe die gewählte Lösung.

Der Datentyp darf keinen Sitzungsindex, keinen Score, keine ausgewählte Nutzerentscheidung und keine Zustandsphase enthalten.

### 5. Genau zwölf lokale Tickets erstellen

Erstelle genau zwölf statische, lokal im App-Code beziehungsweise App-Bundle definierte Tickets.

Die Verteilung muss exakt sein:

| Team | Normal | Wichtig | Kritisch |
|---|---:|---:|---:|
| Netzwerk | 1 | 1 | 1 |
| Konto | 1 | 1 | 1 |
| Software | 1 | 1 | 1 |
| Hardware | 1 | 1 | 1 |

Inhaltliche Anforderungen:

- alle Texte auf Deutsch,
- realitätsnahe IT-Support-Fälle,
- jede Referenzpriorität und jedes Referenzteam muss anhand der Ticketinformationen fachlich nachvollziehbar sein,
- keine mehrdeutigen Fälle, bei denen mehrere Teams oder Prioritäten gleich plausibel wären,
- Ticketnummern und IDs eindeutig,
- Titel, Kurzbeschreibung und User Impact nicht leer,
- pro Ticket mindestens ein und höchstens drei Symptome beziehungsweise Hinweise,
- keine Lösungserklärung im Nutzertext,
- keine personenbezogenen Echtdaten,
- keine Netzwerkverbindung, Datei-Downloads, API oder externe Datenquelle.

### 6. Einfache lokale Katalogschnittstelle bereitstellen

Stelle eine kleine, eindeutige Zugriffsmöglichkeit auf alle zwölf Tickets bereit.

Grenzen:

- kein zufälliges Mischen,
- keine Auswahl von `n` Tickets,
- keine Filterung für eine Spielsitzung,
- keine Speicherung einer aktuellen Sitzung,
- kein veränderbarer globaler Sitzungszustand,
- keine Persistenz,
- keine Datenbank,
- kein JSON-Download,
- keine externe API.

Der Katalog soll die statischen Daten lediglich vollständig und testbar bereitstellen.

### 7. Automatisierte Tests ergänzen

Nutze das bestehende Swift-Testing-Target und erhalte den vorhandenen Smoke-Test.

Ergänze Tests, die mindestens prüfen:

- Katalog enthält genau 12 Tickets,
- alle Ticket-IDs sind eindeutig,
- alle Ticketnummern sind eindeutig,
- jede Kombination aus 4 Teams und 3 Prioritäten kommt genau einmal vor,
- alle Pflichttexte sind vorhanden und nicht leer,
- jedes Ticket besitzt 1 bis 3 Symptome beziehungsweise Hinweise,
- jedes Ticket besitzt genau eine Referenzpriorität,
- jedes Ticket besitzt genau ein Referenzteam,
- der Katalog ist lokal und benötigt keine externe Quelle,
- alle 12 erwarteten Team-/Prioritätskombinationen sind vollständig abgedeckt.

Falls `monsterAssetId` in Modul 002 enthalten ist, ergänze nur eine passende Datenvalidierung; teste keine Asset-Verfügbarkeit oder RealityKit-Darstellung.

Alle bestehenden Tests aus Modul 001 müssen weiterhin bestehen.

### 8. DebugManager nutzen

- Verwende vorhandene Kategorien.
- Ergänze keine neue Kategorie, wenn `state` für einen tatsächlich notwendigen Katalogzugriff ausreicht.
- Baue keine unnötigen Log-Ausgaben beim bloßen Initialisieren statischer Konstanten ein.
- Tests dürfen nicht von Log-Ausgaben abhängen.
- Dokumentiere im Report, ob und wo geloggt wird.
- Verteilte `print()`-Aufrufe sind nicht zulässig.

### 9. Bestehende Dateien schützen

Ändere nach Möglichkeit nicht:

- `Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Info.plist`
- RealityKitContent-Dateien
- Volume-Konfiguration
- deutsche Basistexte aus Modul 001

`AppConstants.swift` darf nur ergänzt werden, wenn ein Wert wirklich modulübergreifend und für F-02/F-03 notwendig ist. Ticketinhalte gehören nicht in allgemeine App-Konstanten.

Die Xcode-Projektdatei soll nur geändert werden, wenn die tatsächliche Projektstruktur dies verlangt.

### 10. Build und Tests abschließen

Am Ende müssen mindestens bestätigt sein:

- App-Target baut erfolgreich,
- vorhandener Simulatorstart bleibt möglich,
- bestehender Modul-001-Test besteht weiterhin,
- alle neuen Ticketmodell- und Katalogtests bestehen,
- genau zwölf Tickets vorhanden,
- jede Team-/Prioritätskombination genau einmal vorhanden,
- keine Sitzungslogik implementiert,
- keine externe Datenquelle eingebunden,
- keine doppelten aktiven Dateien oder Typdefinitionen.

## Querschnitts-Anforderungen

### Ordnerstruktur

- Jede neue Datei erhält einen nachvollziehbaren fachlichen Pfad.
- Physische Ordner und Xcode-Gruppen sollen konsistent bleiben.
- Neue Dateien und Target-Mitgliedschaften sind im Report exakt zu nennen.
- Keine `New`-, `Old`-, `Copy`- oder `Backup`-Dateien.

### Dokumentation im Code

- `///`-Doc-Kommentare an jedem neuen Typ und jeder für Folgemodule nutzbaren Schnittstelle,
- `// MARK: -` zur Gliederung,
- Warum-Kommentare nur an fachlich oder technisch nicht offensichtlichen Stellen,
- keine Kommentare, die nur den Code wiederholen.

### Wartbarkeit

- Ticketdatentyp, Enumerationen und Katalog sollen getrennte, aber einfache Verantwortungen haben.
- Keine unnötige generische Architektur.
- Keine vorweggenommene Sitzungs-, Repository- oder Service-Schicht.
- Die Struktur muss für drei Entwickler schnell verständlich sein.

### Git

Vorgesehener Commit:

`002: Ticketdatenmodell und lokaler Katalog`

Der Modul-Chat darf keinen Commit-Hash erfinden.

## Ausgabeformat

Gib die Ergebnisse in dieser Reihenfolge aus:

1. **Analyse des vorgefundenen Projektstands**
   - tatsächlicher Branch,
   - relevante vorhandene Dateien,
   - Build- und Testausgangslage,
   - eventuell bereits vorhandene Tickettypen oder Daten.

2. **Fachlicher Modell- und Katalogentwurf**
   - definierte Typen und Verantwortungen,
   - gewählte Ordner- und Dateistruktur,
   - begründete Behandlung von `monsterAssetId`,
   - Tabelle der zwölf Tickets mit Ticketnummer, Titel, Referenzpriorität und Referenzteam,
   - Nachweis der vollständigen 4×3-Kombinationsmatrix.

3. **Code-Teile einzeln ausgewiesen**
   Zu jedem Teil:
   - exakter Dateipfad,
   - neu, ergänzt, ersetzt, verschoben oder entfernt,
   - Target-Mitgliedschaft,
   - genauer Einbauort,
   - Begründung mit Bezug zu F-02, F-03, AK-02 oder AK-03.

4. **Test-Anleitung und Testergebnisse**
   - konkrete Xcode-/Simulator-Schritte,
   - alle ausgeführten Tests,
   - Ergebnis der bestehenden und neuen Tests,
   - Bestätigung, dass keine Sitzungslogik enthalten ist.

5. **Vollständiger `002-Report.md` nach der Modul-Report-Vorlage**
   Der Report muss zusätzlich enthalten:
   - tatsächlichen Dateibaum nach Modul 002,
   - alle neuen, geänderten, verschobenen und entfernten Dateien,
   - öffentliche Schnittstellen für Modul 003 und spätere Module,
   - vollständige Liste der zwölf Ticketnummern und ihrer Referenzkombinationen,
   - Testnachweis für genau zwölf Tickets und vollständige 4×3-Abdeckung,
   - behandelte `monsterAssetId`-Entscheidung,
   - DebugManager-Nutzung,
   - klare Bestätigung, dass keine Sitzungslogik oder Zufallsauswahl umgesetzt wurde,
   - offene fachliche Risiken oder mehrdeutige Ticketfälle,
   - Empfehlung für Modul 003.

Baue nichts außerhalb dieses Moduls um. Wenn eine Schnittstelle benötigt wird, die erst Modul 003 oder später gehört, dokumentiere sie als offenen Punkt, statt sie vorwegzunehmen.
