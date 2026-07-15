# Modul-Eingangsprompt — 001 Projektgrundgerüst und zentrales Volume

> Vom Projektlogbuch erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet nur an Modul 001 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den realen Projektstand und baue nur, was hier beauftragt ist. Erfinde keine vorhandenen Dateien, Gruppen, Targets oder Schnittstellen.

## Modul

**Nummer:** 001  
**Titel:** Projektgrundgerüst und zentrales Volume  
**Ziel:** Das vorhandene visionOS-Default-Projekt wird kontrolliert analysiert und in ein einfaches, buildfähiges Grundgerüst mit genau einem zentralen Volume, nachvollziehbarer Ordnerstruktur, Debug-Grundlage, minimalen zentralen Konstanten, deutscher Lokalisierungsgrundlage und funktionsfähigem Swift-Testing-Target überführt.

## Verbindliche Quellengrundlage

Arbeite auf Basis dieser Dokumente:

- `Projektbeschreibung.md`
- `SPEC.md`
- `Akzeptanzkriterien.md`
- `Projekt-Stand.md` mit Stand vor Modul 001
- `Code-im-Projektraum.md`
- `DebugManager.swift` als bereitgestellte Vorlage
- `Modul-Report-Vorlage.md`

Bei Widersprüchen zum älteren Start-Prompt bestimmen Projektbeschreibung, SPEC und Akzeptanzkriterien den Funktionsumfang. Insbesondere gelten für dieses Modul:

- sichtbare App-Texte sind Deutsch,
- die Anwendung verwendet genau ein zentrales Volume,
- es wird kein zweites Volume und kein vollständiger Immersive Space eingerichtet,
- Monster-Integration gehört zu Modul 005 und wird hier nicht vorweggenommen,
- Modul 012 bleibt die optionale Monsterreaktion und ist kein Branding-Modul.

Eine String-Catalog-/i18n-Grundlage darf eingerichtet werden, muss aber deutsche sichtbare Basistexte verwenden.

## Zu erfüllende Anforderungen

### SPEC F-05

> Das System führt die Sitzung in genau einem zentralen Volume als lineare Zustandsfolge aus: Startansicht, Untersuchen, Priorisieren, Team zuordnen, nächstes Ticket und Ergebnis.

Modul 001 erfüllt davon nur die strukturelle Grundlage: App-Einstieg, genau ein zentrales Volume und eine einfache Grundlage für spätere Phasen. Die vollständige lineare Sitzung wird erst durch spätere Module gebaut und in Modul 013 vollständig abgenommen.

### Akzeptanzkriterium AK-05

- GEGEBEN eine Sitzung wurde gestartet, WENN sie vollständig durchlaufen wird, DANN erfolgt die Reihenfolge Start, Untersuchen, Priorisieren, Team zuordnen, nächstes Ticket und Ergebnis.
- Während der gesamten Sitzung bleibt die Anwendung innerhalb eines zentralen Volumes.
- Es wird weder ein zweites Volume noch ein vollständiger Immersive Space geöffnet.

**Wichtige Abnahmegrenze:** Markiere AK-05 im `001-Report.md` nicht vollständig als erfüllt, solange die späteren Phasen noch nicht implementiert sind. Weise stattdessen präzise aus, welche strukturellen Teilbedingungen erfüllt wurden. Die vollständige Abnahme erfolgt in Modul 013.

### Relevante nicht-funktionale Anforderungen

- Das Projekt muss mit Xcode 26.5 für visionOS 26 kompilieren.
- Swift, SwiftUI und RealityKit sind die vorgesehenen Technologien.
- Zustandswechsel und lokale Inhalte dürfen die Oberfläche nicht sichtbar blockieren.
- Verantwortungen für Daten, Sitzungslogik, Views, RealityKit, Services, Debugging und Ressourcen sollen nachvollziehbar getrennt werden.
- Alle sichtbaren Basistexte sind Deutsch.
- Es werden keine externen Verbindungen, Konten, Datenbanken oder Cloud-Dienste eingerichtet.

## Beschriebener Ausgangsstand

Der Start-Prompt beschreibt folgenden Stand. Prüfe jede Angabe im echten Xcode-Projekt, bevor du Änderungen vornimmst:

- Projektpfad: `009 Projektumsetzung/Code/Ticket Tamer`
- Modulname: `Ticket_Tamer`
- bekannte App-Datei: `Ticket_TamerApp.swift`
- beschriebener aktueller Einstieg: `WindowGroup { ContentView() }`
- vorhandenes `RealityKitContent`-Package aus Reality Composer Pro
- vorhandenes Swift-Testing-Target
- keine Schnittstellen aus Vormodulen, weil dies Modul 001 ist
- `DebugManager.swift` liegt als separate Vorlage vor und ist noch nicht als integrierter Projektbestandteil bestätigt

Nenne im Report alle Abweichungen zwischen diesem beschriebenen Stand und dem tatsächlich vorgefundenen Projekt.

## Konkreter Arbeitsauftrag

### 1. Vorhandenes Xcode-Projekt analysieren

Dokumentiere vor der Änderung:

- tatsächlichen Dateibaum,
- Xcode-Gruppen und physische Ordner,
- App- und Test-Targets,
- Target-Mitgliedschaften vorhandener Dateien,
- Package-/Resource-Einbindungen,
- Scene-Konfiguration und App-Einstieg,
- aktuell erfolgreiche oder fehlschlagende Builds,
- vorhandene Warnungen, Importfehler oder doppelte Referenzen.

Verlasse dich nicht auf typische Default-Dateinamen. Verwende nur Dateien, die du tatsächlich findest.

### 2. Einfache Swift-Struktur entwerfen

Entwirf eine kleine, nachvollziehbare Struktur, die für drei Entwickler verständlich bleibt. Prüfe insbesondere sinnvolle Verantwortungsbereiche wie:

- `App/`
- `Views/`
- `Models/`
- `Entities/`
- `Components/`
- `Protocols/`
- `Extensions/`
- `Services/`
- `Debug/`
- `Resources/`
- Testordner des vorhandenen Swift-Testing-Targets

Diese Namen sind Kandidaten aus der Projektvorlage, keine Pflicht zu leeren Ordnern. Lege nur Bereiche an, die im aktuellen Projekt oder unmittelbar für Modul 001 benötigt werden. Führe keine Clean-Architecture-, Repository-, Coordinator-, DI-Container- oder Mehrschicht-Architektur ein, wenn eine direkte SwiftUI-/RealityKit-Struktur ausreicht.

### 3. Gruppen und Ordner kontrolliert einrichten

- Physische Ordner und Xcode-Gruppen sollen dieselbe nachvollziehbare Struktur abbilden.
- Verschiebe bestehende Dateien nur nach vorheriger Prüfung.
- Erhalte Target-Mitgliedschaften und Package-Referenzen.
- Entferne keine Datei ohne Begründung.
- Vermeide doppelte Dateireferenzen und doppelte Typdefinitionen.
- Prüfe nach jeder strukturellen Änderung den Build.
- Fasse Änderungen an der Xcode-Projektdatei möglichst in einem zusammenhängenden Arbeitsschritt zusammen, um spätere Merge-Konflikte zu reduzieren.

### 4. SwiftUI, RealityKit und visionOS sinnvoll trennen

Die Struktur soll mindestens erkennen lassen:

- wo der App-/Scene-Einstieg liegt,
- wo SwiftUI-Oberflächen liegen,
- wo RealityKit-Entities beziehungsweise räumliche Inhalte liegen werden,
- wo gemeinsame Modelle und Services liegen werden,
- wo Debugging und Ressourcen liegen,
- wo Tests liegen.

Implementiere in diesem Modul keine Ticketmodelle, keinen Ticketkatalog, kein Sitzungsmodell, keine Monster-Pipeline, keine Drag-and-Drop-Logik, keine Punkteberechnung, kein Audiofeedback und keine Ergebnisansicht.

### 5. Genau ein zentrales Volume einrichten

- Richte den App-Einstieg so ein, dass das Projekt genau ein zentrales Volume als zentrale App-Szene verwendet.
- Erzeuge keinen zweiten Volume.
- Erzeuge keinen vollständigen Immersive Space.
- Baue keine zusätzliche klassische Window-Szene als separaten Nutzerablauf ein.
- Halte die Inhalte in diesem Modul minimal: ein klarer deutscher Platzhalter beziehungsweise eine Grundansicht genügt.
- Lege noch keine vollständige GamePhase- oder SessionModel-Implementierung an; diese gehört in spätere Module.
- Dokumentiere die verwendete Scene-Konfiguration im Report, ohne unnötige Abstraktionen einzuführen.

### 6. DebugManager kontrolliert integrieren

Nutze die bereitgestellte Datei `DebugManager.swift` als Vorlage.

- Prüfe sie auf Kompatibilität mit dem aktuellen Projekt und SDK.
- Lege die aktive Projektdatei in einem passenden `Debug/`-Bereich ab.
- Behalte kategorisiertes Logging statt verteilter `print()`-Aufrufe bei.
- Verwende für Modul 001 mindestens die bestehende Kategorie `lifecycle`, sofern sie zur protokollierten Scene-/View-Aktivität passt.
- Ergänze keine neue Kategorie, wenn eine bestehende ausreicht.
- Das optionale `DebugPanel` darf nicht Teil des regulären Nutzerablaufs werden.
- Falls du die Vorlage aus Build- oder Strukturgründen aufteilst oder minimal anpasst, dokumentiere jede Abweichung exakt im Report.
- Es darf am Ende nur eine aktive Projektkopie des DebugManagers geben.

### 7. Minimale Constants-Foundation einrichten

Richte eine zentrale Grundlage gegen verstreute Magic Numbers und Asset-Strings ein. Vorgesehene Bereiche sind:

- `LayoutConstants`
- `GameplayConstants`
- `BalancingConstants`
- `AssetKeys`

Grenzen:

- Lege nur Werte an, die in Modul 001 tatsächlich gebraucht werden oder bereits verbindlich in der SPEC stehen.
- Erfinde keine Asset-Namen, Volume-Maße, Animationswerte oder spätere Gameplay-Details.
- Implementiere keine Logik späterer Module in den Constants.
- Wenn ein vorgesehenes Enum in Modul 001 noch keinen sinnvollen Wert besitzt, begründe im Report, warum es noch nicht angelegt wurde, statt eine leere oder künstliche Struktur zu erzeugen.

### 8. Deutsche Lokalisierungsgrundlage einrichten

- Prüfe, ob bereits ein String Catalog oder eine andere Lokalisierungsstruktur existiert.
- Richte bei Bedarf eine einfache String-Catalog-Grundlage ein.
- Verwende für sichtbare Platzhalter und Basistexte Deutsch.
- Baue keine umfangreiche Mehrsprachigkeit und keine englische Nutzeroberfläche.
- Halte String-Schlüssel und Nutzung nachvollziehbar und zentral.

### 9. Swift Testing prüfen

- Prüfe den vorhandenen Swift-Testing-Target und seinen tatsächlichen Modulimport.
- Stelle sicher, dass der Test-Target nach den Datei- und Gruppenänderungen weiterhin baut.
- Verwende `@testable import Ticket_Tamer` nur, wenn dies dem tatsächlichen Modulnamen entspricht.
- Ergänze höchstens einen kleinen, sinnvollen Smoke-Test für Modul-001-Grundlagen; erfinde keine Tests für noch nicht implementierte Spiellogik.
- Dokumentiere Testbefehl, Ergebnis und gegebenenfalls noch bestehende Einschränkungen.

### 10. Build- und Strukturprüfung

Am Ende müssen mindestens geprüft sein:

- App-Target baut ohne Import- oder Referenzfehler,
- Swift-Testing-Target baut und vorhandene beziehungsweise neue Tests laufen,
- keine doppelte aktive Swift-Datei nach Verschiebungen,
- genau ein zentrales Volume,
- kein zweites Volume und kein Immersive Space,
- physische Ordner und Xcode-Gruppen sind verständlich,
- SwiftUI-, RealityKit- und visionOS-Verantwortungen sind erkennbar getrennt,
- der Aufbau bleibt klein genug, dass drei Entwickler ihn ohne lange Architektur-Einarbeitung nutzen können.

## Merge-Konflikte minimieren

- Ändere die Xcode-Projektdatei nur so weit wie nötig.
- Verteile neue Verantwortungen auf kleine, eindeutig benannte Dateien, ohne künstliche Dateizahl.
- Vermeide zentrale Sammeldateien, die später alle drei Entwickler gleichzeitig ändern müssten.
- Dokumentiere Dateien, die als konfliktanfällig gelten, insbesondere App-Einstieg, Projektdatei und zentrale Constants.
- Erstelle keine parallelen Altdateien mit Suffixen wie `New`, `Old`, `Copy` oder `Backup`.

## Dokumentationspflicht im Code

- `///`-Doc-Kommentare an jedem neuen Typ und jeder von anderen Modulen nutzbaren Methode,
- `// MARK: -` zur nachvollziehbaren Gliederung,
- Warum-Kommentare an technisch nicht offensichtlichen Stellen,
- keine Kommentare, die nur den Code wiederholen.

## Außerhalb dieses Moduls

Nicht implementieren:

- F-01-Startansicht mit fertigem Regler und Spielsitzung,
- Tickettypen oder die zwölf Tickets,
- Sitzungsauswahl, Index, Score oder Reset-Logik,
- Monster-Assets oder MonsterProvider,
- Untersuchungs-, Priorisierungs- oder Teamzuordnungsphase,
- Gesten, Kollisionen und Drop-Ziele,
- Audio, Bewertung und automatische 1,5-Sekunden-Übergänge,
- Ergebnisansicht,
- optionale Monsterreaktionen,
- Branding-Feinschliff oder komplexes Designsystem.

Wenn du für Modul 001 eine Schnittstelle aus einem späteren Modul zu benötigen glaubst, stoppe diese Erweiterung und dokumentiere sie als Annahme oder offenen Punkt im Report.

## Ausgabeformat

Gib die Ergebnisse in dieser Reihenfolge aus:

1. **Analyse des vorgefundenen Xcode-Projekts**  
   Tatsächlicher Dateibaum, Targets, Gruppen, Packages, Scene-Konfiguration, Build- und Testzustand.

2. **Begründeter Strukturentwurf**  
   Endgültig für den jetzt vorgefundenen Projektstand vorgeschlagene einfache Ordner-/Gruppenstruktur und kurze Begründung pro Verantwortungsbereich.

3. **Änderungen einzeln ausgewiesen**  
   Für jede Datei beziehungsweise Projektänderung:
   - exakter Pfad,
   - neu, verschoben, ergänzt, ersetzt oder entfernt,
   - ursprünglicher Ort bei Verschiebungen,
   - Target-Mitgliedschaft,
   - genauer Einbau-/Änderungsort,
   - Begründung mit Bezug zu F-05 beziehungsweise dem strukturellen Teil von AK-05.

4. **Build- und Test-Anleitung**  
   Konkrete Schritte für Simulator beziehungsweise Xcode sowie dokumentiertes Ergebnis. Weise aus, was erst auf Apple Vision Pro vollständig prüfbar ist.

5. **Vollständiger `001-Report.md`** nach der bereitgestellten Modul-Report-Vorlage.  
   Der Report muss zusätzlich enthalten:
   - tatsächlich eingerichteten Dateibaum,
   - alle verschobenen und nicht mehr vorhandenen Pfade,
   - öffentliche Schnittstellen für Folgemodule,
   - integrierte oder geänderte DebugManager-Kategorien,
   - Constants-Dateien und enthaltene Wertebereiche,
   - Lokalisierungsstand,
   - Test-Target und Testergebnis,
   - verbleibende Risiken,
   - klare Aussage, dass AK-05 nur strukturell teilweise erfüllt ist,
   - Empfehlung für Modul 002.

## Git

Vorgesehener Commit:

`001: Projektgrundgerüst und zentrales Volume`

Der Modul-Chat soll keinen Commit-Hash erfinden. Falls der Hash nicht bekannt ist, bleibt er im Report als offen markiert.
