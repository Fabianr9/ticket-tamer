# Modul-Eingangsprompt — 007 Räumliche Interaktionsgrundlagen

> Vom Projektlogbuch nach Einarbeitung des `006-Report.md` erzeugt. Diesen Prompt vollständig in einen neuen Modul-Chat einfügen. Der Modul-Chat arbeitet ausschließlich an Modul 007 und benötigt keine Kenntnis anderer Chats.

---

Du bist Fachentwickler:in für genau dieses eine Modul. Analysiere zuerst den aktuellen Git-, Xcode-, Test- und RealityKit-Stand. Implementiere ausschließlich die **wiederverwendbaren räumlichen Interaktionsgrundlagen** für das Ticket-Monster.

Modul 007 baut **keine Priorisierungsphase** und **keine Teamzuordnung**. Die fachlichen Zielwerte „Normal/Wichtig/Kritisch“ gehören Modul 008; „Netzwerk/Konto/Software/Hardware“ gehören Modul 009.

Erfinde keine vorhandenen Dateien, API-Verfügbarkeit, Build-Ergebnisse, Testresultate oder Simulatorerfolge.

## Modul

**Nummer:** 007  
**Titel:** Räumliche Interaktionsgrundlagen  
**Ziel:** Das Monster erhält eine einfache, wiederverwendbare visionOS-Interaktionsgrundlage für Blickfokus, Pinch/Greifen und räumliches Bewegen. Eine generische Drop-Mechanik erkennt gültige beziehungsweise ungültige Zielbereiche und verhindert Mehrfachauswertung durch die bestehende Eingabesperre, ohne bereits Prioritäts- oder Teamentscheidungen zu implementieren.

## Zu erfüllende Anforderung

### SPEC F-10

> Ein Loslassen außerhalb eines gültigen Ziels verändert den Sitzungszustand nicht. Ein gültiges Ablegen speichert die Entscheidung genau einmal und sperrt weitere Eingaben bis zum Zustandswechsel.

### AK-10 — Gültige und ungültige Ablage

- GEGEBEN das Monster wird gezogen, WENN es außerhalb eines gültigen Ziels losgelassen wird, DANN werden weder Entscheidung noch Punkte noch Phase verändert.
- GEGEBEN das Monster wird innerhalb eines gültigen Ziels losgelassen, WENN die Entscheidung gespeichert wurde, DANN ist die Eingabe bis zum nächsten Zustandswechsel gesperrt.
- Mehrfaches Pinchen oder erneutes Ziehen während der Eingabesperre verändert die gespeicherte Entscheidung und den Punktestand nicht.

## Abnahmegrenze dieses Moduls

Die SPEC ordnet F-10 Modul 007 zu, während die konkrete Prioritätsentscheidung erst in Modul 008 und die konkrete Teamentscheidung erst in Modul 009 eingeführt werden.

Deshalb gilt für Modul 007:

### In Modul 007 vollständig umzusetzen

- Monster kann für Gameplay-Interaktion fokussiert/angesprochen werden,
- Pinch beziehungsweise Greifen startet die Manipulation,
- Monster kann räumlich bewegt werden,
- generische gültige Zielbereiche können erkannt werden,
- Loslassen außerhalb eines gültigen Zielbereichs erzeugt **keinen Gameplay-Zustandswechsel**,
- ungültiges Ablegen stellt das Monster kontrolliert an seine Ausgangsposition zurück oder verwendet eine gleichwertig klare Rücksetzsemantik,
- ein gültiger Drop kann genau einmal als generisches Drop-Ereignis akzeptiert werden,
- nach akzeptiertem Drop ist `SessionModel.isInputLocked == true`,
- weitere Interaktionen werden während des Locks ignoriert,
- keine Punkte, Phase oder fachliche Entscheidung werden durch die Interaktionsgrundlage selbst verändert.

### Erst in Modul 008/009 integrierbar

- Speichern von `selectedPriority`,
- Speichern von `selectedTeam`,
- konkrete beschriftete Prioritätsziele,
- konkrete beschriftete Teamstationen.

Daher darf der `007-Report.md` AK-10 nicht als vollständig fachlich integriert markieren, solange noch keine echte Prioritäts-/Teamentscheidung gespeichert wird. Er soll klar zwischen **generischer Interaktionssemantik** und **späterer fachlicher Entscheidungsspeicherung** unterscheiden.

Das ist keine Anforderungsänderung, sondern eine stufenweise Umsetzung entsprechend der vorhandenen Modulgrenzen.

## Verbindlicher Vorab-Check

### 1. Git und Projektstand

Ermittle und dokumentiere:

- aktuellen Branch,
- aktuellen Commit,
- tatsächlichen Modul-006-Commit,
- ob `98cd95d fix:import error` und der 006-Stand enthalten sind,
- aktuellen Dateibaum,
- tatsächliche `SessionModel`-Schnittstellen,
- tatsächliche `InvestigationView`,
- `MonsterAssetProvider`,
- aktuelle RealityKit- und visionOS-Deployment-Einstellungen.

### 2. Build, Simulator und Tests

Nach Modul 006 sind noch nicht nachgewiesen:

- Build,
- Simulatorstart,
- Ausführung der 45 gemeldeten Tests.

Führe vor Änderungen nach Möglichkeit aus:

- App-Build,
- Simulatorstart,
- komplette Test-Suite,
- tatsächliche Anzahl aller Tests und Suites.

Falls Xcode beziehungsweise `xcodebuild` im Ausführungsumfeld nicht verfügbar ist, kennzeichne das ausdrücklich. Behaupte keine erfolgreiche Ausführung.

### 3. Offene Abnahmen nachholen

Wenn Simulator verfügbar:

#### AK-01

- Startansicht,
- Titel,
- Regler 1–12,
- Standardwert 6,
- Startschaltfläche.

#### AK-06 / AK-07

- Untersuchungsansicht sichtbar,
- Monster sichtbar,
- vollständige Ticketkarte,
- keine Referenzlösung,
- „Weiter zur Priorisierung“,
- gleicher Ticketindex nach Phasenwechsel.

Dokumentiere diese als Nachprüfung; baue Modul 004/006 nicht unnötig um.

### 4. Monster-Asset-Status

Prüfe, ob inzwischen finale Blender-/USDZ-Monster vorliegen.

Wenn weiterhin nur USDA-Kugeln vorhanden sind:

- nutze sie als technische Interaktionsobjekte,
- kennzeichne sie weiterhin als Platzhalter,
- behaupte F-14/AK-14 nicht vollständig erfüllt.

## Technische API-Leitlinie für visionOS 26

Das Projekt zielt auf visionOS 26.

Prüfe im real verfügbaren SDK zuerst die einfache native RealityKit-Lösung über `ManipulationComponent`.

Apple beschreibt für visionOS 26, dass `ManipulationComponent` die Objektmanipulation für RealityKit-Entities bereitstellt und die nötigen Interaktionskomponenten wie `InputTargetComponent`, `CollisionComponent` und Hover-Verhalten konfigurieren kann. Die API unterstützt auch indirekte Eingabe über Blickfokus plus Pinch.

**Bevorzugung:** Wenn `ManipulationComponent` im vorhandenen Xcode-/SDK-Stand die benötigte reine Translation und Release-Auswertung sauber unterstützt, verwende diese einfache Systemlösung.

**Alternative:** Falls die präzise Drop-Logik mit einem gezielten SwiftUI-`DragGesture` und RealityKit-Targeting im realen Projekt deutlich einfacher und kontrollierbarer ist, darf diese Variante verwendet werden. Dann sind `InputTargetComponent`, `CollisionComponent` und ein auf die Entity gerichtetes Gesture-Targeting sauber einzurichten.

Keine komplizierte eigene Handtracking-/ARKit-Pipeline implementieren. Keine Rohdaten für Augen- oder Handtracking verwenden.

Begründe im Report kurz, welche Variante gewählt wurde und warum.

## Relevanter bestehender Projektstand

### Monster

- `Ticket.monsterAssetId`
- `AssetKeys.Monster.allIDs`
- `MonsterAssetProvider.loadMonster(assetID:)`
- `MonsterAssetProvider.LoadError`
- `InvestigationView` zeigt das geladene Monster in einer `RealityView`
- Entity-Hierarchie wurde laut Modul 006 flach gehalten

### Sitzung

`SessionModel` enthält unter anderem:

- `currentPhase`
- `currentTicket`
- `currentTicketIndex`
- `score`
- `selectedPriority`
- `selectedTeam`
- `isInputLocked`

`isInputLocked` ist laut bisherigen Reports `private(set)` und besitzt noch keine allgemeine Mutationsschnittstelle.

### Debug

Vorhandene Kategorien:

- `lifecycle`
- `input`
- `physics`
- `spawning`
- `state`
- `audio`

## Verbindliche Modulgrenze

Modul 007 bearbeitet ausschließlich:

- Konfiguration einer Monster-Entity für visionOS-Interaktion,
- Blick-/Hover-Erkennbarkeit als Interaktionshinweis,
- Pinch/Greifen,
- räumliche Translation/Drag,
- Speichern der Ausgangstransformation für ungültige Ablage,
- minimale generische Definition eines Drop-Zielbereichs,
- Erkennung gültiger versus ungültiger Ablage,
- Rücksetzung nach ungültigem Ablegen,
- genau einmal akzeptierbares generisches Drop-Ereignis,
- kontrollierte Nutzung von `SessionModel.isInputLocked`,
- Unterdrückung weiterer Eingaben während des Locks,
- Tests der zustandsunabhängigen beziehungsweise modellseitigen Interaktionslogik,
- DEBUG-/Development-Prüfung der Interaktion im Simulator, ohne eine fachliche Priorisierungsansicht zu bauen.

Modul 007 bearbeitet ausdrücklich nicht:

- `selectedPriority` speichern,
- `selectedTeam` speichern,
- Prioritätsziele mit „Normal“, „Wichtig“, „Kritisch“,
- Teamstationen,
- Punkte,
- Audio,
- 1,5-Sekunden-Übergang,
- Ergebnisansicht,
- neue Monsteranimationen,
- neue Blender-Modellierung,
- vollständige Untersuchungsansicht umbauen.

## Konkreter Arbeitsauftrag

### 1. Interaktionsarchitektur klein halten

Wähle die einfachste Struktur, die Module 008 und 009 wiederverwenden können.

Erlaubt sind beispielsweise:

- ein kleiner RealityKit-Helfer/Configurator für interaktive Monster,
- ein minimaler eigener Component-Typ zum Markieren generischer Drop-Ziele,
- ein kleiner Drop-Auswerter für gültig/ungültig,
- schmale SessionModel-Methoden für Input-Lock.

Nicht erwünscht:

- allgemeine Game-Engine-Schicht,
- Event-Bus,
- Dependency-Injection-Container,
- komplexe Protokollhierarchie,
- generische Physik-Engine,
- eigene Handtracking-Infrastruktur.

### 2. Monster für Blickfokus und Pinch vorbereiten

Das Monster muss über die native visionOS-Eingabe anwählbar sein.

Prüfe beziehungsweise richte je nach gewählter API ein:

- Input Target,
- geeignete Collision Shape,
- sichtbares Hover-/Focus-Feedback,
- Unterstützung indirekter Eingabe über Blick + Pinch,
- Manipulation ausschließlich am Monster beziehungsweise dessen klarer Root-Entity.

Die Kollisionsform soll groß genug für zuverlässige Interaktion sein, aber nicht so groß, dass benachbarte Ziele oder UI unbeabsichtigt getroffen werden.

### 3. Nur benötigte Manipulation erlauben

Für das Spiel wird das Monster **bewegt**, nicht frei als 3D-Modell skaliert oder beliebig gedreht.

Konfiguriere deshalb möglichst nur die für den Spielablauf benötigte Translation.

Falls die verwendete System-API Rotation/Skalierung standardmäßig aktiviert, schränke sie nach Möglichkeit ein. Wenn das SDK dies nicht sinnvoll zulässt, dokumentiere die Einschränkung und verhindere zumindest, dass Skalierung/Rotation für die spätere Drop-Erkennung relevant werden.

### 4. Ausgangstransformation erfassen

Vor Beginn einer Manipulation muss eine zuverlässige Ausgangsposition beziehungsweise -transformation bekannt sein.

Sie dient dazu, ein ungültig abgelegtes Monster kontrolliert zurückzusetzen.

Anforderungen:

- kein Drift über wiederholte ungültige Drops,
- keine schrittweise Verschiebung der Ausgangsposition,
- kein Einfluss auf Ticketindex, Phase oder Score.

### 5. Generische Drop-Ziele

Definiere eine kleine wiederverwendbare Möglichkeit, eine Entity als gültiges Drop-Ziel zu markieren.

Der Typ darf **keine** Priorität und **kein** Support-Team kennen.

Beispielhafte Verantwortung:

- stabile generische Ziel-ID,
- räumlicher Trefferbereich,
- optionaler Debug-Name.

Module 008 und 009 müssen später ihre fachlichen Ziele mit dieser Grundlage markieren können.

Keine Strings wie `normal`, `kritisch`, `netzwerk` oder `hardware` in Modul 007 als Gameplay-Zielwerte einführen.

### 6. Gültigen Drop erkennen

Beim Loslassen muss die Interaktionsgrundlage feststellen können:

- liegt das Monster in/über genau einem gültigen Zielbereich,
- oder liegt es außerhalb aller gültigen Zielbereiche.

Verwende eine robuste, nachvollziehbare RealityKit-Lösung.

Bevorzugt:

- Collision-/Bounds-basierte Prüfung,
- oder eine kleine mathematische Bereichsprüfung in konsistentem Koordinatenraum.

Keine Bildschirmkoordinaten-Hacks.

Falls mehrere Ziele gleichzeitig getroffen würden, definiere eine eindeutige, dokumentierte Regel oder gestalte die Zielbereiche so, dass Überschneidungen ausgeschlossen werden.

### 7. Ungültiges Ablegen

Bei ungültigem Loslassen:

- kein `selectedPriority`,
- kein `selectedTeam`,
- kein Score,
- keine Phase,
- kein Ticketindex,
- `isInputLocked` bleibt `false`,
- Monster kehrt zur Ausgangsposition zurück.

Das Rücksetzen darf eine kleine Animation verwenden, wenn sie technisch einfach ist, ist aber keine Muss-Anforderung.

### 8. Gültiges Ablegen und Eingabesperre

Bei einem generisch gültigen Drop:

- Drop wird genau einmal akzeptiert,
- Interaktionsgrundlage liefert die generische Ziel-ID an die aufrufende spätere Phase,
- `SessionModel.isInputLocked` wird kontrolliert `true`,
- weitere Pinch-/Drag-/Release-Versuche werden ignoriert,
- Score bleibt unverändert,
- Phase bleibt in Modul 007 unverändert,
- `selectedPriority` und `selectedTeam` bleiben unverändert.

Wenn `SessionModel` noch keine passende Mutationsschnittstelle besitzt, ergänze nur schmale Methoden für den Lock-Lebenszyklus.

Beispiele für zulässige Verantwortung:

- Input nur sperren, wenn aktuell nicht gesperrt,
- Lock kontrolliert für den nächsten Phasenaufbau zurücksetzen.

Keine allgemeine Zustandsmaschine.

### 9. Lock genau einmal

Die Interaktionsgrundlage muss Mehrfachauswertung verhindern.

Prüfe Szenarien:

- mehrfaches Pinchen während eines gültig akzeptierten Drops,
- erneutes Loslassen,
- neue Drag-Geste während `isInputLocked == true`,
- zwei schnell aufeinanderfolgende Release-Ereignisse.

Keines davon darf einen zweiten akzeptierten Drop erzeugen.

### 10. DEBUG-/Development-Prüfung

Da Modul 008 noch keine Prioritätsziele besitzt, darf Modul 007 für die manuelle Interaktionsprüfung eine kleine **nicht fachliche DEBUG-Lösung** verwenden.

Beispielsweise:

- ein neutraler Zielbereich mit ID wie `testTargetA`,
- nur in DEBUG sichtbar,
- nicht Bestandteil des normalen Spielablaufs,
- keine Prioritäts-/Teambezeichnung.

Bevorzuge einen solchen kleinen Test-Harness gegenüber dem Vorziehen von Modul 008.

Dokumentiere:

- wo er liegt,
- ob er im finalen Modulstand verbleibt,
- wie verhindert wird, dass er im normalen Nutzerablauf erscheint.

### 11. InvestigationView schützen

Die Untersuchungsphase ist zum Lesen gedacht.

Aktiviere die neue Gameplay-Drag-Interaktion **nicht automatisch dauerhaft in der regulären `InvestigationView`**, wenn dadurch Nutzende das Monster bereits vor der Priorisierungsphase verschieben können.

Bevorzuge:

- wiederverwendbare Interaktionskonfiguration,
- DEBUG-Harness,
- oder Vorbereitung der Entity,

und aktiviere die echte Gameplay-Manipulation erst in Modul 008.

Falls ein kleiner temporärer Test in `InvestigationView` technisch nötig ist, muss er DEBUG-only sein und im Report ausdrücklich dokumentiert werden.

### 12. DebugManager

Verwende vorhandene Kategorien:

- `.input`: Beginn/Ende Pinch oder Manipulation,
- `.physics`: Drop-/Collision-Auswertung,
- `.state`: Lock gesetzt/ignoriert,
- `.spawning`: nur vorhandenes Laden.

Keine neue Kategorie, wenn diese ausreichen.

Logge nur:

- Entity-/Ziel-ID,
- valid/invalid,
- Lock-Zustand.

Keine vollständigen Tickettexte.

### 13. Automatisierte Tests

Erhalte alle bestehenden 45 Testdeklarationen.

Automatisiert sollte mindestens geprüft werden, soweit ohne Simulator sinnvoll:

- Input-Lock startet `false`,
- erster gültiger generischer Drop kann den Lock setzen,
- zweiter gültiger Drop während Lock wird abgewiesen,
- ungültiger Drop setzt keinen Lock,
- ungültiger Drop verändert Phase nicht,
- ungültiger Drop verändert Score nicht,
- ungültiger Drop verändert `selectedPriority` nicht,
- ungültiger Drop verändert `selectedTeam` nicht,
- Reset beziehungsweise definierter Unlock stellt den erwarteten Inputzustand wieder her,
- generische Ziel-IDs sind fachlich neutral.

RealityKit-Gesten selbst müssen zusätzlich im Simulator beziehungsweise auf dem Gerät geprüft werden.

### 14. Simulatorprüfung

Prüfe mit einem neutralen Development-Ziel:

- Monster zeigt Focus-/Hover-Reaktion beim Ansehen,
- Pinch greift das Monster,
- Monster lässt sich räumlich bewegen,
- Loslassen außerhalb → Rückkehr zur Ausgangsposition,
- kein Session-Zustand verändert sich,
- Loslassen im neutralen Ziel → genau ein akzeptiertes Drop-Ereignis,
- `isInputLocked` wird `true`,
- erneutes Greifen/Drag bleibt wirkungslos,
- kein Score,
- keine Phasenänderung,
- keine Prioritäts-/Teamentscheidung,
- genau ein zentrales Volume.

Wenn nur USDA-Kugeln vorliegen, reicht dies für die technische Interaktionsprüfung; F-14 bleibt wegen fehlender Blender-Monster weiterhin offen.

## Bestehende Dateien schützen

Voraussichtlich relevant:

- `Assets/MonsterAssetProvider.swift` nur falls Interaktionskonfiguration sinnvoll dort anschließt,
- neue kleine Interaktionsdateien in einem passenden Bereich wie `Components/`, `Entities/` oder `Services/`,
- `Models/SessionModel.swift` nur für schmale Lock-Methoden,
- `Support/AppConstants.swift` nur für echte Interaktionsmaße/Toleranzen,
- `Ticket_TamerTests/Ticket_TamerTests.swift`,
- eventuell DEBUG-only Vorschau-/Harness-Datei.

Nach Möglichkeit unverändert:

- `StartView.swift`,
- normale `InvestigationView`-UX,
- Ticketdaten,
- Monster-Mapping,
- `GamePhase`,
- `Info.plist`,
- Lokalisierung, sofern der DEBUG-Harness keinen sichtbaren Nutzertext benötigt.

## Keine fachlichen Zielwerte

In Modul 007 dürfen nicht als Gameplay-Entscheidungen eingeführt werden:

- Normal,
- Wichtig,
- Kritisch,
- Netzwerk,
- Konto,
- Software,
- Hardware.

Diese Werte existieren natürlich bereits als Ticket-Referenzdaten. Modul 007 darf sie aber nicht zur Drop-Auswertung oder Zieldefinition verwenden.

## Bekannte offene Punkte außerhalb des Moduls

- finale Blender-Monster fehlen,
- F-14/AK-14 bleibt teilweise offen,
- AK-01/AK-06/AK-07-Laufzeitnachweise sind noch nachzuholen, falls bisher nicht erfolgt,
- Priorisierungsphase folgt Modul 008,
- Teamzuordnung folgt Modul 009,
- Bewertung/Audio folgt Modul 010,
- `.DS_Store`-Bereinigung ist kein Teil dieses Moduls.

## Git

Vorgesehener Commit:

`007: Räumliche Interaktionsgrundlagen`

Erfinde keinen Hash.

## Ausgabeformat

1. **Vorab-Check**
   - Branch/Commit,
   - tatsächlicher Modul-006-Commit,
   - Build-/Simulator-/Teststatus,
   - tatsächliche Testzahl,
   - offene AK-Nachprüfungen,
   - Monster-Asset-Status.

2. **Technische Interaktionsentscheidung**
   - verwendete visionOS-/RealityKit-API,
   - Begründung `ManipulationComponent` versus gezieltes Gesture-Handling,
   - Input-/Collision-/Hover-Konfiguration,
   - erlaubte Manipulationsoperationen.

3. **Drop-Grundlage**
   - generischer Zieltyp,
   - Koordinaten-/Collision-Strategie,
   - Ausgangsposition,
   - valid/invalid-Semantik,
   - Rücksetzverhalten.

4. **Input-Lock**
   - ergänzte SessionModel-Schnittstellen,
   - genau-einmal-Semantik,
   - Unlock-/Reset-Verhalten,
   - klare Bestätigung, dass weder Score noch Priorität noch Team verändert werden.

5. **DEBUG-/Simulator-Harness**
   - neutraler Testzielbereich,
   - Pfad,
   - nur DEBUG beziehungsweise außerhalb des normalen Flows,
   - Simulatorergebnisse.

6. **Änderungen je Datei**
   - Pfad,
   - Art,
   - Target,
   - Zweck,
   - Bezug zu F-10/AK-10.

7. **Tests**
   - reale Testzahl vor und nach Modul 007,
   - Testergebnis,
   - Unit-/Modeltests,
   - manuelle Gestenprüfung.

8. **Vollständiger `007-Report.md` nach der Report-Vorlage**

Der Report muss zusätzlich enthalten:

- tatsächlichen Dateibaum,
- alle neuen/geänderten Dateien,
- neue Schnittstellen für Modul 008 und 009,
- gewählte RealityKit-Interaktions-API,
- Drop-Ziel-Abstraktion,
- Lock-Semantik,
- DebugManager-Nutzung,
- Build-/Simulator-/Testergebnis,
- Status von AK-10 getrennt nach generischer Interaktion und späterer fachlicher Entscheidungsspeicherung,
- klare Bestätigung, dass keine Prioritätsziele und keine Teamstationen implementiert wurden,
- Status der Blender-Monster,
- offene Risiken,
- Empfehlung für Modul 008.

Baue nichts außerhalb dieses Moduls um.
