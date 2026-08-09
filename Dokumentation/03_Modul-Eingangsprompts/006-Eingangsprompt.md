# Modul-Eingangsprompt — 006 Untersuchungsphase

> Vom Projektlogbuch nach Einarbeitung des `005-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 006 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git-, Xcode-, Test- und Asset-Stand. Implementiere ausschließlich die Untersuchungsphase gemäß F-06 und F-07.

Die Monster-Asset-Pipeline aus Modul 005 darf verwendet werden. Die vier derzeitigen USDA-Kugeln sind jedoch nur technische Platzhalter und **keine finalen eigenen Blender-Monster**. Behaupte daher nicht, F-14 oder AK-14 seien vollständig erfüllt.

## Modul

**Nummer:** 006  
**Titel:** Untersuchungsphase  
**Ziel:** Wenn `SessionModel.currentPhase == .untersuchen`, zeigt das zentrale Volume das aktuelle Ticket mit Monster und gut lesbarer deutscher Ticketkarte. Eine Schaltfläche „Weiter zur Priorisierung“ wechselt beim selben Ticket in die Priorisierungsphase, ohne bereits Prioritätsziele oder Drag-and-Drop zu implementieren.

## Zu erfüllende Anforderungen

### SPEC F-06

> In der Untersuchungsphase zeigt das System ein Ticket-Monster und eine gut lesbare Ticketkarte mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptomen beziehungsweise Hinweisen an.

### SPEC F-07

> Die Untersuchungsphase enthält die Schaltfläche „Weiter zur Priorisierung“, die zur Priorisierungsphase desselben Tickets wechselt.

### AK-06 — Untersuchungsphase

- GEGEBEN ein Ticket ist aktiv, WENN die Untersuchungsphase erscheint, DANN sind ein Monster sowie Ticketnummer, Titel, Kurzbeschreibung, User Impact und alle hinterlegten Symptome beziehungsweise Hinweise sichtbar.
- Die sichtbaren Informationen entsprechen exakt dem aktiven Ticket im Sitzungsmodell.
- Referenzpriorität und Referenzteam werden in dieser Phase nicht als Lösung angezeigt.

### AK-07 — Weiter zur Priorisierung

- GEGEBEN die Untersuchungsphase ist aktiv, WENN „Weiter zur Priorisierung“ ausgelöst wird, DANN erscheint die Priorisierungsphase desselben Tickets.
- Der Ticketindex ändert sich durch diese Aktion nicht.
- Ohne Auslösen der Schaltfläche wird keine Prioritätsentscheidung gespeichert.

## Verbindlicher Vorab-Check

### 1. Git und Projektstand

Ermittle:

- aktuellen Branch,
- aktuellen Commit,
- ob der Modul-005-Stand enthalten ist,
- tatsächlichen Dateibaum,
- `Ticket.monsterAssetId`,
- `AssetKeys.Monster`,
- `MonsterAssetProvider`,
- `SessionModel`,
- `RootVolumeView`.

Erfinde keine Dateien oder Schnittstellen.

### 2. Build, Simulator und Tests

Der 005-Report konnte keine Xcode-Ausführung nachweisen.

Prüfe vor Änderungen nach Möglichkeit:

- App-Build,
- Simulatorstart,
- vorhandene Test-Suites,
- tatsächliche Zahl der Tests,
- bestandene/fehlgeschlagene Tests.

Der 005-Report ist bei der Testzahl widersprüchlich:
- einmal „9 neue Tests“,
- detailliert 11 Testnamen,
- berechnet 38 Tests gesamt.

Ermittle die reale Zahl aus dem Quellcode und Testlauf. Ändere keine Tests nur, um eine Reportzahl zu erreichen.

### 3. AK-01-Nachprüfung

Wenn Simulator verfügbar ist, prüfe die Startansicht aus Modul 004:

- Projekttitel,
- Regler,
- Standardwert 6,
- „Spiel starten“,
- Ganzzahlschritte 1–12,
- Startaktion,
- genau ein zentrales Volume,
- kein Immersive Space.

Wenn nicht ausführbar, offen lassen.

### 4. Asset-Pipeline prüfen

Prüfe:

- laden `monster01` bis `monster04` tatsächlich über `MonsterAssetProvider`,
- sind die vier USDA-Platzhalter im Simulator sichtbar,
- funktionieren die Asset-IDs aus den Tickets,
- gibt es inzwischen echte Blender-/USDZ-Modelle.

Falls echte Modelle inzwischen vorliegen, integriere sie **nicht automatisch als Zusatzscope**, außer ihr Austausch ist eine reine, kontrollierte Ersetzung der Modul-005-Platzhalter. Dokumentiere eine solche Ersetzung separat als Nacharbeit zu Modul 005.

## Aktueller technischer Kontext

### Sitzung

`SessionModel` ist `@Observable @MainActor` und wird einmal in `Ticket_TamerApp` gehalten und über SwiftUI Environment weitergegeben.

Relevant:

- `SessionModel.currentPhase`
- `SessionModel.currentTicket`
- `SessionModel.currentTicketIndex`
- `SessionModel.sessionTickets`
- `SessionModel.selectedPriority`

Nach `startSession()` ist die Phase laut geprüftem Modul-004-Stand `.untersuchen`.

### Ticket

`Ticket` enthält:

- `id`
- `ticketNumber`
- `title`
- `shortDescription`
- `userImpact`
- `symptoms`
- `referencePriority`
- `referenceTeam`
- `monsterAssetId`

### Monster

Verfügbar:

- `AssetKeys.Monster.monster01...monster04`
- `AssetKeys.Monster.allIDs`
- `MonsterAssetProvider.loadMonster(assetID:) async throws -> Entity`
- `MonsterAssetProvider.LoadError`

Die aktuellen USDA-Dateien sind technische Platzhalter. Modul 006 darf sie zur Entwicklung und Darstellung verwenden.

## Verbindliche Modulgrenze

Modul 006 bearbeitet ausschließlich:

- Ansicht für `GamePhase.untersuchen`,
- Monsteranzeige für `SessionModel.currentTicket`,
- Ticketkarte mit allen F-06-Daten,
- gut lesbare deutsche Beschriftungen,
- Darstellung aller 1 bis 3 Symptome/Hinweise,
- klare Ausblendung der Referenzlösung,
- Schaltfläche „Weiter zur Priorisierung“,
- minimal notwendige Modellmethode zum Phasenwechsel `.untersuchen -> .priorisieren`, falls im realen `SessionModel` noch keine passende kontrollierte Mutation existiert,
- Sicherstellung, dass Ticketindex beim Phasenwechsel gleich bleibt,
- Sicherstellung, dass keine Prioritätsentscheidung beim bloßen Anzeigen oder Weitergehen gespeichert wird,
- Tests für die Modell-/Phasenbedingungen,
- Simulatorprüfung der Untersuchungsansicht.

Modul 006 bearbeitet ausdrücklich nicht:

- Prioritätsziele,
- Blickfokus/Pinch/Drag,
- Drop-Validierung,
- Teamstationen,
- Bewertung,
- Punkte,
- Audiofeedback,
- automatischen 1,5-Sekunden-Übergang,
- Ergebnisansicht,
- vollständige Monster-Interaktion,
- optionale Monsteranimation,
- neue Blender-Modellierung.

## Konkreter Arbeitsauftrag

### 1. Root-Phasenrouting erweitern

`RootVolumeView` zeigt derzeit:

- `.start` → `StartView`
- andere Phasen → neutralen Platzhalter

Erweitere nur soweit nötig:

- `.start` → `StartView`
- `.untersuchen` → neue Untersuchungsansicht
- andere noch nicht implementierte Phasen → neutraler Platzhalter

Keine Priorisierungs- oder Teamansicht implementieren.

### 2. Untersuchungsansicht erstellen

Erstelle eine klar benannte SwiftUI-View, beispielsweise `InvestigationView` oder eine gleichwertig verständliche deutsche/englische technische Bezeichnung.

Sie erhält ihren Zustand aus dem bestehenden `SessionModel` über Environment oder eine einfache explizite Übergabe.

Die View muss sichtbar enthalten:

- Monster des aktuellen Tickets,
- Ticketnummer,
- Titel,
- Kurzbeschreibung,
- User Impact,
- alle 1–3 Symptome/Hinweise,
- Schaltfläche „Weiter zur Priorisierung“.

### 3. Ticketinformationen exakt aus `currentTicket`

Keine Kopie des Ticketkatalogs und keine hartcodierten Tickettexte in der View.

Die angezeigten Werte stammen ausschließlich aus:

- `SessionModel.currentTicket`

Falls `currentTicket == nil` ist, muss die View einen klaren, lokalen Fehler-/Fallbackzustand zeigen oder kontrolliert verhindern, dass eine inkonsistente Untersuchungsansicht entsteht.

Keine externe Datenquelle.

### 4. Referenzlösung nicht anzeigen

In der Untersuchungsphase dürfen nicht sichtbar sein:

- `referencePriority`,
- `referenceTeam`,
- technische IDs, aus denen die Lösung abgeleitet werden könnte.

`monsterAssetId` ist intern zu verwenden, aber nicht als Nutzertext anzuzeigen.

### 5. Deutsche Tickettexte prüfen

Der bisherige Projektstand dokumentiert, dass einige Tickettexte `ae`, `oe`, `ue` enthalten.

Da Modul 006 diese Texte erstmals sichtbar macht:

- prüfe alle zwölf Tickets auf solche technischen Umschreibungen,
- ersetze sie nur dort kontrolliert durch korrekte deutsche Umlaute, wo dies sprachlich eindeutig ist,
- ändere dabei keine fachliche Bedeutung, Priorität oder Teamzuordnung,
- dokumentiere jede Textkorrektur im Report.

Dies ist keine neue Feature-Anforderung, sondern eine Qualitätskorrektur für die verbindliche deutsche UI.

### 6. Monster laden und darstellen

Nutze ausschließlich:

`MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)`

Anforderungen:

- keine duplizierte Asset-Ladelogik,
- kein direkter Switch über Ticketnummer,
- kein Team-/Prioritäts-Mapping,
- kein Netzwerk,
- klarer Ladefehlerzustand,
- asynchrones Laden darf die UI nicht blockieren,
- beim Ticketwechsel muss später ein anderes Monster geladen werden können.

Die Darstellung soll im zentralen Volume gut proportioniert sein.

Keine Gestenkomponenten in diesem Modul.

### 7. Phasenwechsel zur Priorisierung

Prüfe das reale `SessionModel`.

Falls noch keine kontrollierte Methode existiert, darf Modul 006 eine kleine fachliche Methode ergänzen, beispielsweise sinngemäß:

- nur von `.untersuchen` nach `.priorisieren`,
- kein Ticketindexwechsel,
- keine Prioritätsentscheidung,
- kein Score,
- keine Eingabesperre notwendig, sofern sie nicht fachlich für den simplen Buttonwechsel gebraucht wird.

Keine allgemeine State-Machine-Abstraktion.

Die Schaltfläche „Weiter zur Priorisierung“ ruft ausschließlich diese kontrollierte Phasenmutation auf.

### 8. Verhalten nach dem Phasenwechsel

Da Modul 008 die echte Priorisierungsansicht implementiert, darf nach `.priorisieren` weiterhin ein neutraler Platzhalter erscheinen.

Wichtig:

- Ticket bleibt dasselbe,
- `currentTicketIndex` unverändert,
- `selectedPriority` bleibt `nil`,
- keine Punkte,
- kein Sound.

### 9. Layout und Lesbarkeit

Die Ticketkarte muss in vorgesehener Betrachtungsdistanz gut lesbar sein.

Achte auf:

- klare Hierarchie,
- ausreichend große Schrift,
- sinnvolle Abstände,
- keine überladene Karte,
- alle Symptome sichtbar,
- kein Abschneiden typischer Tickettexte,
- sinnvolle Anordnung von Monster und Karte innerhalb des vorhandenen Volumes.

Verwende vorhandene `LayoutConstants`, wo passend. Ergänze nur notwendige neue Layoutwerte zentral und ohne Magic Numbers.

### 10. Lokalisierung

Alle neuen sichtbaren UI-Bezeichnungen in den vorhandenen `Localizable.xcstrings`.

Mindestens:

- Label für Ticketnummer, falls separat nötig,
- „User Impact“ oder eine passende deutsche Formulierung,
- Überschrift für Symptome/Hinweise,
- „Weiter zur Priorisierung“,
- Lade-/Fehlertext nur falls sichtbar notwendig.

Bestehende Tickettexte stammen aus dem Katalog und werden nicht als einzelne String-Catalog-Keys dupliziert.

### 11. DebugManager

Geeignete bestehende Kategorien:

- `lifecycle` beim Erscheinen der Untersuchungsansicht,
- `spawning` wird bereits vom MonsterProvider genutzt,
- `input` beim Button „Weiter zur Priorisierung“,
- `state` beim Phasenwechsel.

Keine neue Kategorie, wenn bestehende ausreichen.

Keine vollständigen Tickettexte loggen.

### 12. Tests

Erhalte alle bestehenden Tests.

Automatisiert mindestens prüfen:

- Phasenwechsel `.untersuchen -> .priorisieren`,
- `currentTicketIndex` bleibt unverändert,
- `currentTicket` bleibt dasselbe,
- `selectedPriority` bleibt `nil`,
- ungültiger Phasenaufruf verändert den Zustand nicht, falls die neue Methode phasengebunden ist,
- Ticketdaten für Untersuchungsansicht sind vollständig vorhanden,
- 1 bis 3 Symptome bleiben erhalten.

UI-Sichtbarkeit kann zusätzlich manuell im Simulator geprüft werden; baue kein neues UI-Test-Target nur für dieses Modul, sofern keines existiert.

### 13. Simulatorprüfung

Prüfe mindestens mit mehreren Tickets:

- Startansicht → Spiel starten,
- Untersuchungsansicht erscheint,
- Monster sichtbar,
- Ticketnummer sichtbar,
- Titel sichtbar,
- Kurzbeschreibung sichtbar,
- User Impact sichtbar,
- alle Symptome sichtbar,
- keine Referenzpriorität sichtbar,
- kein Referenzteam sichtbar,
- „Weiter zur Priorisierung“ sichtbar,
- Klick wechselt in `.priorisieren`,
- Ticket bleibt dasselbe,
- danach nur neutraler Priorisierungsplatzhalter,
- genau ein zentrales Volume.

Wenn nur USDA-Platzhalter vorhanden sind, dokumentiere klar: Monsterdarstellung technisch geprüft, finale Blender-Darstellung weiterhin offen.

## Bestehende Dateien schützen

Voraussichtlich relevant:

- `Views/RootVolumeView.swift`
- neue Untersuchungs-View unter `Views/`
- `Models/SessionModel.swift` nur für minimalen kontrollierten Phasenwechsel
- `Resources/Localizable.xcstrings`
- `Support/AppConstants.swift` nur bei benötigten Layoutkonstanten
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Nach Möglichkeit nicht ändern:

- `Ticket_TamerApp.swift`
- Zufallsauswahl,
- `TicketPriority`,
- `SupportTeam`,
- Monster-Mapping,
- `MonsterAssetProvider`,
- `Info.plist`,
- Scene-Konfiguration.

`LocalTicketCatalog.swift` nur für eindeutig notwendige deutsche Textkorrekturen ändern; keine Referenzwerte oder Monsterzuordnung verändern.

## Bekannte offene Punkte, die nicht Teil von Modul 006 sind

- finale vier Blender-Monster fehlen,
- Blender-Exportpipeline/Lizenzstatus,
- vollständige Drag-Gesten,
- Drop-Ziele,
- Bewertung,
- Audio,
- Ergebnisreset,
- `.DS_Store`-Bereinigung.

Nicht stillschweigend erledigen.

## Git

Vorgesehener Commit:

`006: Untersuchungsphase`

Erfinde keinen Hash.

## Ausgabeformat

1. **Vorab-Check**
   - Branch/Commit,
   - Build-/Simulatorstatus,
   - tatsächliche Testzahl,
   - AK-01-Nachprüfung,
   - Monster-Ladeprüfung.

2. **Entwurf der Untersuchungsphase**
   - View-Struktur,
   - Datenfluss aus `SessionModel.currentTicket`,
   - Monster-Ladefluss,
   - Fehler-/Loadingzustand,
   - Layoutentscheidung.

3. **Phasenwechsel**
   - vorhandene oder neu ergänzte SessionModel-Methode,
   - Vorbedingungen,
   - garantierte Nichtänderung von Ticketindex und Prioritätsentscheidung.

4. **Textprüfung**
   - welche Tickettexte korrigiert wurden,
   - Bestätigung, dass Referenzwerte unverändert blieben.

5. **Änderungen je Datei**
   - Pfad,
   - Art,
   - Target,
   - Zweck,
   - Bezug zu F-06/F-07/AK-06/AK-07.

6. **Tests und Simulatorprüfung**
   - reale Testzahl,
   - Testergebnis,
   - Sichtbarkeit aller Pflichtinformationen,
   - Monsterdarstellung,
   - Phasenwechsel,
   - genau ein Volume.

7. **Vollständiger `006-Report.md` nach der Report-Vorlage**

Der Report muss zusätzlich enthalten:

- tatsächlichen Dateibaum,
- neue/änderte Dateien,
- öffentliche Schnittstellen für Modul 007/008,
- Lokalisierungsschlüssel,
- Tickettextkorrekturen,
- Build-/Simulator-/Testergebnis,
- DebugManager-Nutzung,
- klare Bestätigung, dass keine Priorisierungsziele, Drag-Gesten, Teamstationen, Bewertung oder Audio implementiert wurden,
- Hinweis, ob echte Blender-Monster inzwischen vorhanden sind oder weiterhin Platzhalter genutzt werden,
- offene Risiken,
- Empfehlung für Modul 007.

Baue nichts außerhalb dieses Moduls um.
