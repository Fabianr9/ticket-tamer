# Modul-Eingangsprompt — 005 Monster-Asset-Pipeline

> Vom Projektlogbuch nach Einarbeitung des `004-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 005 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git-, Xcode- und Asset-Stand. Implementiere ausschließlich die Monster-Asset-Pipeline aus der verbindlichen SPEC.

**Wichtig:** Die Empfehlung im `004-Report.md`, Modul 005 als Untersuchungsansicht umzusetzen, ist nicht verbindlich. Laut SPEC ist Modul 005 **„Monster-Asset-Pipeline“**. Die Untersuchungsphase ist Modul 006. Ändere diese Reihenfolge nicht stillschweigend.

Erfinde keine vorhandenen Blender-Dateien, USDZ-Dateien, Asset-Namen, Commit-Hashes, Build-Ergebnisse oder erfolgreichen Gerätetests.

## Modul

**Nummer:** 005  
**Titel:** Monster-Asset-Pipeline  
**Ziel:** Vier eigene Blender-Monster werden als lokale, RealityKit-kompatible 3D-Assets sauber in das Projekt eingebunden und über eine einfache, stabile Asset-Zuordnung bereitgestellt, ohne dass die Modellwahl das richtige Support-Team oder die richtige Priorität verrät.

## Zu erfüllende Anforderungen

### SPEC F-14

> Das System bindet vier eigene, lokal mitgelieferte Blender-Monster als RealityKit-kompatible 3D-Assets ein. Die Modellwahl darf keinen eindeutigen Rückschluss auf Referenzteam oder Referenzpriorität zulassen.

### AK-14 — Eigene Monster-Assets

- GEGEBEN das App-Bundle wird geprüft, WENN die Monster-Assets gezählt werden, DANN sind vier eigene Blender-Monster als RealityKit-kompatible lokale 3D-Assets enthalten.
- GEGEBEN Tickets verschiedener Teams und Prioritäten werden gespielt, WENN die verwendeten Monster verglichen werden, DANN existiert keine feste 1:1-Zuordnung eines Modells zu einem Team oder einer Priorität.
- Alle vier Modelle können im zentralen Volume dargestellt und per Blickfokus, Pinch und Drag bewegt werden.
- Für die Anzeige eines Monsters ist keine Netzwerkverbindung erforderlich.

## Abnahmegrenze dieses Moduls

F-14 wird in Modul 005 auf Asset-, Lade- und Zuordnungsebene umgesetzt.

Die dritte AK-14-Aussage enthält bereits Blickfokus, Pinch und Drag. Die verbindliche Modul-Landkarte ordnet die allgemeinen räumlichen Interaktionsgrundlagen jedoch Modul 007 zu.

Deshalb gilt für Modul 005:

- **muss jetzt erfüllt werden:** vier eigene lokale Modelle, RealityKit-kompatible Einbindung, Darstellung im zentralen Volume, robuste lokale Ladefähigkeit, keine verräterische 1:1-Zuordnung;
- **muss jetzt vorbereitet werden:** Entities/Assets dürfen eine spätere Interaktion nicht technisch verhindern;
- **darf nicht vorweggenommen werden:** die allgemeine Blickfokus-/Pinch-/Drag-/Drop-Logik aus Modul 007.

Dokumentiere AK-14 im `005-Report.md` entsprechend:
- Asset- und Darstellungsanteile vollständig prüfen,
- Bewegungs-/Gestenanteil als bis Modul 007/013 noch offen kennzeichnen.

Dies ändert AK-14 nicht; es trennt nur die technisch unterschiedlichen Abnahmeschritte.

## Aktueller Git- und Projektstand

Laut `004-Report.md`:

- Branch: `main`
- Modul-003-Commit: `dd78700 Feat: addModul3`
- Commit vor Modul 004: `f3d4bf3 feat: add doc files`
- Modul-004-Commit: `84bb767 004: Startansicht und Einstellungen`
- Xcode-Build nach Modul 004: nicht nachgewiesen
- Simulatorstart nach Modul 004: nicht nachgewiesen
- Testdeklarationen nach Modul 004: 27
- tatsächlicher Testlauf nach Modul 004: nicht nachgewiesen

Prüfe den echten Stand vor jeder Änderung.

## Verbindlicher Vorab-Check

### 1. Git und Xcode

Ermittle:

- aktuellen Branch,
- aktuellen Commit,
- ob `84bb767` im aktuellen Stand enthalten ist,
- tatsächlichen Xcode-Dateibaum,
- App- und Test-Target,
- Buildstatus,
- Simulatorstart,
- tatsächliche Testzahl und Testergebnis.

Falls Xcode/`xcodebuild` in deinem Ausführungsumfeld nicht verfügbar ist, sage das ausdrücklich. Behaupte keinen erfolgreichen Build oder Testlauf.

### 2. AK-01-Nachprüfung

Da Modul 004 keinen ausgeführten Simulatornachweis liefern konnte, prüfe vor Asset-Arbeit nach Möglichkeit:

- Startansicht sichtbar,
- Projekttitel sichtbar,
- Regler sichtbar,
- Standardwert 6,
- „Spiel starten“ sichtbar,
- Ganzzahlschritte 1 bis 12,
- Startaktion funktioniert,
- genau ein zentrales Volume,
- kein zweites Fenster/Volume,
- kein Immersive Space.

Wenn diese Prüfung nicht möglich ist, bleibt sie offen und wird nicht als bestanden markiert.

### 3. Vorhandene 3D-Assets real inventarisieren

Suche im tatsächlichen Repository beziehungsweise im vom Team bereitgestellten Arbeitsordner nach:

- `.blend`,
- `.usdz`,
- `.usd`,
- `.usda`,
- `.usdc`,
- Reality Composer Pro Assets,
- Texturen und Materialien,
- vorhandenen Monster-Dateinamen.

Erstelle eine Tabelle:

| Asset | Quelldatei | Exportdatei | Format | Größe | Texturen | Status |
|---|---|---|---|---|---|---|

Wenn weniger als vier eigene Monster tatsächlich vorliegen, erfinde keine Dateien. Dokumentiere exakt, welche Assets fehlen und was das Team noch liefern muss.

## Relevanter bestehender Codekontext

### App und UI

- `Ticket_TamerApp`
- genau eine `SessionModel`-Instanz als `@State`
- `.environment(sessionModel)`
- `RootVolumeView`
- `StartView`
- genau eine volumetrische `WindowGroup`
- kein zweites Volume
- kein Immersive Space

### Daten

- `TicketPriority`
- `SupportTeam`
- `Ticket`
- `LocalTicketCatalog.allTickets`

### Sitzung

- `GamePhase`
- `SessionModel`
- `SessionModel.currentTicket`
- `SessionModel.currentPhase`
- `SessionModel.sessionTickets`

### Support

- `DebugManager`
- Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`
- `LayoutConstants`
- `GameplayConstants`
- `AssetKeys`
- `RealityKitContent`-Package

## Bekannte SPEC-Abweichung: `monsterAssetId`

Die SPEC-Architekturskizze definiert für `Ticket`:

- `monsterAssetId: String`

Das implementierte `Ticket` aus Modul 002 besitzt dieses Feld laut bisherigen Reports nicht.

Diese Abweichung muss in Modul 005 bewusst aufgelöst werden, weil Modul 005 die Monsterzuordnung zu Tickets einführt.

### Bevorzugte minimale Lösung

Wenn der reale Code keine bessere bereits vorhandene Lösung enthält:

- ergänze am Ticketmodell einen einfachen logischen Monster-/Asset-Identifier,
- aktualisiere die zwölf statischen Ticketdatensätze kontrolliert,
- verwende nur stabile, zentrale Asset-Schlüssel,
- halte die Zuordnung rein datenbezogen,
- implementiere keine RealityKit-Entity direkt im `Ticket`-Modell,
- stelle sicher, dass dieselben Monster über verschiedene Teams und Prioritäten verteilt vorkommen,
- keine Monster-ID darf fachlich „Netzwerk“, „Kritisch“ o. Ä. codieren.

### Alternative Lösung

Falls du eine andere, gleichwertig einfache Mapping-Struktur verwendest, die F-14 erfüllt, musst du:

1. erklären, warum das SPEC-Feld `monsterAssetId` nicht verwendet wird,
2. diese Abweichung als **Änderungsvorschlag** kennzeichnen,
3. sie nicht stillschweigend als neue SPEC behandeln,
4. im Report die Konsequenzen für Modul 006 und spätere Module dokumentieren.

Keine Repository-, Datenbank- oder Dependency-Injection-Schicht einführen.

## Verbindliche Modulgrenze

Modul 005 bearbeitet ausschließlich:

- Bestandsaufnahme der vier eigenen Blender-Monster,
- notwendige Exporte in ein RealityKit-kompatibles lokales Format,
- lokale Einbindung in das App-Bundle beziehungsweise RealityKitContent,
- eindeutige zentrale Asset-Schlüssel,
- einfache Lade-/Bereitstellungsschnittstelle für Monster,
- sichere Darstellung jedes einzelnen Monsters im bestehenden zentralen Volume,
- Zuordnung der Monster zu Tickets ohne eindeutigen Rückschluss auf Team oder Priorität,
- Auflösung der dokumentierten `monsterAssetId`-Lücke,
- Tests beziehungsweise Prüfungen für Assetanzahl, Zuordnung und lokale Verfügbarkeit,
- notwendiges Debug-Logging für Asset-Ladevorgänge,
- Aktualisierung des Dateibaums und Modulreports.

Modul 005 bearbeitet ausdrücklich nicht:

- vollständige Untersuchungsansicht,
- Ticketkarte,
- „Weiter zur Priorisierung“,
- allgemeine Blickfokus-/Pinch-/Drag-Interaktion,
- Drop-Ziele,
- Priorisierung,
- Teamzuordnung,
- Score,
- Audiofeedback,
- automatische Übergänge,
- Ergebnisansicht,
- optionale Monsterreaktionen,
- komplexe Animationen,
- Physiksimulation.

## Konkreter Arbeitsauftrag

### 1. Asset-Namensschema festlegen

Verwende neutrale Namen, die keine Lösung verraten.

Geeignet sind beispielsweise neutrale IDs wie:

- `monster01`
- `monster02`
- `monster03`
- `monster04`

Die tatsächlichen Namen dürfen anders sein, müssen aber:

- stabil,
- eindeutig,
- neutral gegenüber Team und Priorität,
- zentral referenzierbar sein.

Keine Namen wie `criticalMonster`, `networkMonster` oder `hardwareMonster`.

### 2. Blender- und Exportpipeline dokumentieren

Für jedes der vier Modelle dokumentiere mindestens:

- Blender-Quelldatei,
- Exportformat,
- Exportdatei,
- Textur-/Materialabhängigkeiten,
- Skalierung,
- Orientierung,
- Transform-Ursprung,
- ungefähre Dateigröße,
- ob das Modell lokal geladen werden kann.

Bevorzugtes Exportformat laut SPEC: USDZ.

Wenn das reale Projekt aus technischen Gründen ein anderes RealityKit-kompatibles USD-Format verwendet, begründe dies im Report.

### 3. Lokale Einbindung

Stelle sicher:

- alle vier Assets sind Teil des lokalen Projekts/App-Bundles oder des lokal eingebundenen RealityKitContent-Packages,
- kein HTTP-/Netzwerkzugriff,
- keine Cloud-Abhängigkeit,
- keine externe Laufzeit-API,
- keine dynamische Nachladung aus dem Internet.

Dokumentiere den genauen Ablageort jedes Assets.

### 4. Zentrale Asset-Schlüssel

Erweitere die bestehende `AssetKeys`-Grundlage nur so weit wie erforderlich.

Anforderungen:

- keine verstreuten Dateinamen-Strings,
- genau vier Monster-Schlüssel,
- neutrale Benennung,
- Standardszene aus Modul 001 nicht unnötig verändern.

Falls `AssetKeys` für die konkrete technische Lösung ungeeignet ist, begründe eine kleine alternative Typstruktur.

### 5. Monster-Bereitstellung

Erstelle die einfachste nachvollziehbare Schnittstelle, mit der Modul 006 anhand eines logischen Asset-Identifiers das richtige Monster laden beziehungsweise anzeigen kann.

Die Schnittstelle soll:

- lokale Assets laden,
- einen klaren Fehlerfall haben,
- keine Netzwerklogik enthalten,
- keine Ticketkarte kennen,
- keine Team-/Prioritätsentscheidung treffen,
- keine zufällige Sitzungsauswahl duplizieren,
- keine Gesten implementieren.

Bevorzuge einen kleinen Provider/Loader nur dann, wenn er die wiederholte RealityKit-Ladelogik tatsächlich kapselt. Keine unnötige Protokoll-/DI-Hierarchie.

### 6. Modellunabhängige Ticketzuordnung

Prüfe alle zwölf Tickets.

Die Zuordnung muss sicherstellen:

- vier Monster werden über den Katalog verteilt verwendet,
- kein Monster steht ausschließlich für ein bestimmtes Team,
- kein Monster steht ausschließlich für eine bestimmte Priorität,
- anhand eines Modells allein kann die korrekte Lösung nicht eindeutig abgeleitet werden.

Erstelle im Report eine Matrix:

| Ticket | Team | Priorität | Monster-ID |
|---|---|---|---|

und zusätzlich eine Zusammenfassung pro Monster:

| Monster-ID | verwendete Teams | verwendete Prioritäten | Anzahl Tickets |
|---|---|---|---|

Ein akzeptables Mapping muss für jedes Monster mehrere fachlich unterschiedliche Tickets umfassen oder anderweitig eindeutig nachweisen, dass keine 1:1-Signalisierung entsteht.

### 7. Darstellung jedes Monsters prüfen

Baue nur die minimal notwendige technische Vorschau beziehungsweise Testmöglichkeit, um nachzuweisen:

- Monster 1 lädt,
- Monster 2 lädt,
- Monster 3 lädt,
- Monster 4 lädt,
- jedes Modell kann im bestehenden zentralen Volume dargestellt werden,
- Größe und Orientierung sind grundsätzlich verwendbar.

Die Vorschau darf keine neue Benutzerfunktion und keinen zweiten App-Ablauf darstellen.

Bevorzuge:

- eine Debug-/Development-Prüfung,
- einen kleinen Test-Harness,
- oder eine kontrollierte temporäre/DEBUG-only Vorschau,

statt die Startansicht oder Untersuchungsphase fachlich umzubauen.

Wenn eine temporäre Vorschau eingebaut wird, dokumentiere genau, ob sie im endgültigen Modulstand verbleibt oder wieder entfernt wurde.

### 8. Interaktionsvorbereitung ohne Modul 007 vorwegzunehmen

AK-14 verlangt später Beweglichkeit über Blickfokus, Pinch und Drag.

Modul 005 darf deshalb prüfen, dass:

- die Entity-Hierarchie nicht unnötig verschachtelt oder gesperrt ist,
- Skalierung und Transform grundsätzlich manipulierbar sind,
- spätere Collision/Input-Komponenten technisch ergänzt werden können.

Aber:

- keine vollständige Drag-Geste,
- keine Drop-Erkennung,
- keine Zielbereiche,
- keine Eingabesperre,
- keine Prioritäts-/Teamentscheidung.

Diese Logik bleibt Modul 007.

### 9. Fehlerbehandlung

Fehlende oder nicht ladbare Assets dürfen nicht stillschweigend zu Netzwerkzugriff oder zufälligen fremden Assets führen.

Bevorzuge:

- klaren lokalen Fehler,
- Debug-Log mit Asset-ID,
- ggf. neutralen Development-Fallback nur wenn bereits vorhanden und ausdrücklich dokumentiert.

Kein Monster darf durch die RealityKit-Standardszene fachlich ersetzt werden, wenn damit F-14 als erfüllt behauptet würde.

### 10. DebugManager

Nutze bestehende Kategorien.

Geeignet:

- `spawning` für Erzeugen/Laden einer Monster-Entity,
- `lifecycle` für Development-Vorschau,
- `state` nur für reine Mapping-/Zustandsinformation.

Keine neue Kategorie, wenn eine bestehende ausreicht.

Logge:

- Asset-ID,
- Ladeerfolg oder Fehler,
- keine unnötigen vollständigen Tickettexte.

Keine `print()`-Aufrufe.

### 11. Tests und Prüfungen

Automatisiert prüfbar sind mindestens:

- genau vier Monster-Asset-IDs,
- alle vier IDs eindeutig,
- jede im Ticketkatalog verwendete Monster-ID ist bekannt,
- keine unbekannten Asset-IDs,
- Mapping enthält keine feste 1:1-Zuordnung Team → Monster,
- Mapping enthält keine feste 1:1-Zuordnung Priorität → Monster,
- alle zwölf Tickets besitzen eine gültige Zuordnung, falls `monsterAssetId` im Ticketmodell verwendet wird.

Zusätzlich manuell beziehungsweise im Simulator:

- jedes der vier Assets wird lokal geladen,
- jedes der vier Assets ist sichtbar,
- Skalierung und Orientierung sind brauchbar,
- kein Netzwerk notwendig,
- genau ein Volume bleibt bestehen.

Bewegung per Blick/Pinch/Drag wird erst in Modul 007 vollständig abgenommen.

### 12. Build- und Regressionstest

Am Ende:

- App-Build ausführen,
- Simulatorstart prüfen,
- alle bestehenden Tests aus 001–004 weiter ausführen,
- neue Modul-005-Tests ausführen,
- tatsächliche Gesamtzahl dokumentieren,
- Startansicht erneut kurz prüfen,
- keine Regression beim Start einer Sitzung,
- genau ein zentrales Volume,
- kein Immersive Space.

Falls Build/Test in deinem Ausführungsumfeld nicht möglich ist, markiere dies ehrlich als offen.

## Bestehende Dateien schützen

Nur bei fachlicher Notwendigkeit ändern:

- `Ticket_Tamer/Ticket_Tamer/Models/Ticket.swift`
- `Ticket_Tamer/Ticket_Tamer/Data/LocalTicketCatalog.swift`
- `Ticket_Tamer/Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`
- RealityKitContent-Dateien beziehungsweise lokale 3D-Asset-Verzeichnisse

Nach Möglichkeit unverändert lassen:

- `Ticket_Tamer/Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/SessionModel.swift`
- `Ticket_Tamer/Ticket_Tamer/Models/GamePhase.swift`
- `Ticket_Tamer/Ticket_Tamer/Info.plist`
- Startansicht-Logik

`RootVolumeView.swift` nur ändern, wenn eine minimale, klar abgegrenzte DEBUG-/Vorschaufunktion für die Asset-Verifikation zwingend nötig ist. Keine Untersuchungsansicht dort implementieren.

## Nicht im Modul beheben

Diese bekannten Punkte sind nicht automatisch Teil von Modul 005:

- Tickettexte mit `ae`, `oe`, `ue`,
- `.DS_Store`-Bereinigung,
- Audiodateien,
- Ergebnisreset,
- optionale Gesichtsanimation,
- vollständige Gesteninteraktion.

Nicht stillschweigend mit erledigen.

## Dokumentationspflicht

Für jede neu angelegte oder geänderte Datei:

- exakter Pfad,
- Art der Änderung,
- Target-/Package-Zugehörigkeit,
- Zweck,
- Bezug zu F-14/AK-14.

Zusätzlich dokumentieren:

- Asset-Quelle,
- ob selbst erstellt,
- Exportformat,
- Lizenz-/Urheberstatus,
- Dateigröße,
- Mapping zu Tickets,
- Ladeprüfung.

`///`-Doc-Kommentare an neuen Swift-Typen und folgemodulrelevanten Schnittstellen; `// MARK: -` zur Gliederung; Warum-Kommentare nur an nicht offensichtlichen Stellen.

## Git

Vorgesehener Commit:

`005: Monster-Asset-Pipeline`

Erfinde keinen Hash. Dokumentiere Branch, Commit und Hash nur, wenn sie tatsächlich vorliegen.

## Ausgabeformat

Gib die Ergebnisse in dieser Reihenfolge aus:

1. **Vorab-Check**
   - Branch und Commit,
   - Build-/Test-/Simulatorstatus,
   - AK-01-Nachprüfung,
   - tatsächlicher Assetbestand.

2. **Asset-Inventar und Pipeline**
   - vier Monster mit Quelle, Export und Zielpfad,
   - Formate, Materialien, Größen,
   - Asset-Schlüssel.

3. **Zuordnungsentscheidung**
   - Umgang mit `monsterAssetId`,
   - vollständige 12-Ticket-Mappingtabelle,
   - Nachweis, dass weder Team noch Priorität durch das Modell verraten wird.

4. **Bereitstellungsschnittstelle**
   - verwendeter Typ beziehungsweise Loader/Provider,
   - Pfad,
   - Ladeverhalten,
   - Fehlerbehandlung,
   - Schnittstelle für Modul 006.

5. **Änderungen einzeln ausgewiesen**
   - Dateipfad,
   - neu/ergänzt/ersetzt/verschoben,
   - Target/Package,
   - Begründung mit F-14/AK-14.

6. **Test- und Simulatorprüfung**
   - automatisierte Tests,
   - tatsächliche Gesamtzahl,
   - Darstellung aller vier Modelle,
   - lokale Verfügbarkeit,
   - Bestätigung, dass vollständige Drag-Interaktion noch nicht implementiert wurde.

7. **Vollständiger `005-Report.md` nach der Modul-Report-Vorlage**

Der Report muss zusätzlich enthalten:

- tatsächlichen Dateibaum nach Modul 005,
- Liste aller vier Monster-Quelldateien und Exporte,
- Asset-Schlüssel,
- Ticket-Monster-Mapping,
- Entscheidung zu `monsterAssetId`,
- öffentliche Schnittstellen für Modul 006/007,
- Build-, Simulator- und Testergebnis,
- DebugManager-Nutzung,
- Asset-/Lizenzstatus,
- klare Bestätigung, dass keine Untersuchungsphase und keine vollständige Gestenlogik umgesetzt wurde,
- AK-14-Aufteilung in bereits verifizierte Assetanteile und noch offenen Gestenanteil,
- offene Risiken,
- Empfehlung für Modul 006.

Baue nichts außerhalb dieses Moduls um. Wenn ein Problem nur durch eine Änderung der SPEC oder Modul-Landkarte lösbar wäre, kennzeichne es ausdrücklich als Änderungsvorschlag und implementiere es nicht stillschweigend.
