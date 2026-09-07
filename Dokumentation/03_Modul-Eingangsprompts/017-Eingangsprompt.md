# Modul-Eingangsprompt — 017 Startseiten-Usability

> Vom **Projektlogbuch** nach Einarbeitung des `016-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 017.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**. Baue nur, was hier beauftragt ist.

# Modul

**Nummer:** 017  
**Titel:** Startseiten-Usability  
**Erfüllt:** F-22, F-24 / AK-22, AK-24

**Ziel:** Ergänze die bestehende v1.0-Startansicht um zwei direkte Ticketanzahl-Schaltflächen Minus/Plus sowie eine kurze feste Beschreibung unter dem Titel. Slider, Zahlenanzeige und Buttons verwenden weiterhin ausschließlich `SessionModel.selectedTicketCount`.

---

# Verbindliche Anforderungen

## F-22 — Minus-/Plus-Buttons für Ticketanzahl

> Die Startansicht ergänzt den vorhandenen Ticketanzahl-Slider um einen Minus- und einen Plus-Button, die die Auswahl jeweils um genau ein Ticket verändern, an den Grenzen 1 beziehungsweise 12 deaktiviert sind und mit Slider und Zahlenanzeige synchron bleiben.

## AK-22

1. GEGEBEN die Startansicht ist geöffnet, WENN der Plus-Button einmal aktiviert wird, DANN erhöht sich die Ticketanzahl genau um 1.
2. GEGEBEN die Startansicht ist geöffnet, WENN der Minus-Button einmal aktiviert wird, DANN verringert sich die Ticketanzahl genau um 1.
3. GEGEBEN der Wert ist 1, WENN die Startansicht angezeigt wird, DANN ist der Minus-Button deaktiviert.
4. GEGEBEN der Wert ist 12, WENN die Startansicht angezeigt wird, DANN ist der Plus-Button deaktiviert.
5. Slider, Zahlenanzeige und Minus-/Plus-Buttons spiegeln jederzeit denselben Wert wider.
6. Der vorhandene Slider bleibt nutzbar.
7. Nach „Erneut spielen“ steht die Ticketanzahl wieder auf 6.
8. Accessibility-Labels exakt:
   - `Ein Ticket weniger`
   - `Ein Ticket mehr`

## F-24 — Kurze Startseitenbeschreibung

> Die Startansicht zeigt unter dem Titel die Kurzbeschreibung „Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.“ und führt keine zusätzliche Tutorial- oder Popover-Logik ein.

## AK-24

1. GEGEBEN die Startansicht erscheint, WENN die App gestartet oder nach „Erneut spielen“ zurückgesetzt wird, DANN ist unter dem Titel exakt sichtbar:

   `Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.`

2. Die Startansicht enthält keinen zusätzlichen „So funktioniert’s“-Button, kein Tutorial-Popover und keine persistente Tutorialverwaltung.
3. Die Kurzbeschreibung verhindert nicht die Bedienung von Ticketanzahl-Steuerung und „Spiel starten“.

---

# Aktueller v1.1-Stand

## Modul 015

Commit:

`afe4bce feat: Modul 15`

Implementiert:

- Session-HUD
- Interaktionshinweise

Laufzeitabnahme laut 015-Report noch offen.

## Modul 016

Implementiert:

- `CompactTicketInfoView`
- Info-Button in Priorisierung und Team
- lokaler Overlay-State
- Drag-Sperre bei geöffnetem Overlay
- Schließen über X oder erneuten Info-Tap

Testdeklarationen:

`246`

Build/Test/Simulator nach 016:

offen.

Modul-016-Commit:

noch offen.

---

# Wichtiger 016-Preflight vor Modul 017

Modul 016 enthält zusätzlich eine Layout-Nachbesserung, die über die reine F-19-Umsetzung hinausgeht.

Gemeldet wurden:

- zentrales Volume von `1.0 × 1.0 × 0.4 m` auf `1.2 × 1.15 × 0.45 m`,
- Investigation-Monsterzielgröße `0.24 → 0.20 m`,
- Priorisierung/Team-Monsterzielgröße `0.13 → 0.11 m`,
- Ticketinfo-Designfläche `520 × 560 pt`.

Die Dateiänderungstabelle im 016-Report nennt jedoch nicht alle Dateien, in denen diese Größen geändert worden sein müssen.

## Deshalb vor Modul-017-Code zwingend:

### Git

Ermittle:

- Branch,
- HEAD,
- Working Tree,
- tatsächlichen Modul-016-Commit oder uncommitted Stand.

### Diff

Prüfe real:

- welche Dateien seit `afe4bce` verändert wurden,
- wo Volume-Größe verändert wurde,
- wo Investigation-Monstergröße verändert wurde,
- wo Drag-Phase-Monstergröße verändert wurde,
- wo Ticketinfo-Designgröße definiert ist.

Dokumentiere diese realen Dateien im 017-Report als übernommenen 016-Stand.

### Baseline

Wenn Modul 016 noch uncommitted:

1. Build durchführen.
2. vollständige 246er-Suite durchführen.
3. Simulatorprüfung 016 durchführen.
4. Regression der Layoutgrößen durchführen.
5. Modul 016 separat committen.
6. erst dann Modul 017 beginnen.

Keine 016-Änderungen mit 017 vermischen.

Wenn 016 noch Fehler hat, die ausschließlich aus diesen 016-Änderungen stammen:

- als 016-Nachfix behandeln,
- separat dokumentieren/committen.

---

# Bestehende Startansicht

Aus v1.0 bekannt:

- Projekttitel `Ticket Tamer`
- Label `Anzahl Tickets`
- Slider 1...12, Schritt 1
- sichtbare aktuelle Ticketanzahl
- `Spiel starten`

`StartView` verwendet:

```text
@Environment(SessionModel.self)
```

Der Slider liest/schreibt direkt:

`model.selectedTicketCount`

über:

`model.setTicketCount(_:)`

Es existiert kein lokaler Spiegelzustand.

Diese Architektur bleibt bestehen.

---

# Verbindliche Architektur für Modul 017

## Keine neuen SessionModel-Felder

Nicht hinzufügen:

- `@State ticketCount`
- zweiter fachlicher Ticketanzahlwert
- StartViewModel nur für Plus/Minus
- persistente Einstellung

Source of Truth bleibt:

`SessionModel.selectedTicketCount`

## Buttons nutzen bestehende Methode

Minus:

```text
model.setTicketCount(model.selectedTicketCount - 1)
```

Plus:

```text
model.setTicketCount(model.selectedTicketCount + 1)
```

oder semantisch gleichwertig.

Die bestehende Clamp-Semantik in `setTicketCount(_:)` bleibt Sicherheitsnetz.

Zusätzlich müssen Buttons an den Grenzen visuell/semantisch deaktiviert sein.

---

# Konkreter Arbeitsauftrag

## 1. Kurzbeschreibung unter Titel ergänzen

In `StartView` direkt unter `Ticket Tamer` sichtbar:

`Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.`

Eigenschaften:

- gut lesbar,
- deutlich untergeordnet zum Titel,
- keine zusätzliche Interaktion,
- kein Tutorial,
- kein Popover,
- keine Persistenz.

Die Beschreibung muss auch nach `Erneut spielen` wieder sichtbar sein, weil `StartView` erneut erscheint.

## 2. Ticketanzahl-Bedienung ergänzen

Bestehenden Slider erhalten.

Ergänze:

- Minus-Button
- Plus-Button

Bevorzugtes kompaktes Layout:

```text
[ - ]   [ Slider ]   [ + ]
            6
```

oder eine ähnlich klare Anordnung.

Keine Entfernung des Sliders.

## 3. Minus-Semantik

Bei aktuellem Wert > 1:

- genau -1.

Bei Wert == 1:

- Button deaktiviert,
- kein Wertwechsel.

Nicht durch bloßes Clamping einen weiterhin aktiv wirkenden Button simulieren.

## 4. Plus-Semantik

Bei aktuellem Wert < 12:

- genau +1.

Bei Wert == 12:

- Button deaktiviert,
- kein Wertwechsel.

## 5. Synchronität

Folgende Elemente zeigen/ändern jederzeit denselben Wert:

- Minus-Button,
- Slider,
- sichtbare Zahl,
- Plus-Button.

Beispiele:

### Plus

6 → Plus → 7

Danach:

- Zahl 7,
- Sliderposition 7.

### Slider

Slider 7 → 3

Danach:

- Zahl 3,
- nächster Minus-Tap → 2,
- nächster Plus-Tap → 4.

Keine UI-Quelle darf hinterherhinken.

## 6. Grenzen testen

### Minimum

Wert 1:

- Minus disabled
- Plus enabled
- Slider weiterhin nutzbar

### Maximum

Wert 12:

- Plus disabled
- Minus enabled
- Slider weiterhin nutzbar

## 7. Reset schützen

Bestehender v1.0-Reset:

`SessionModel.reset()`

setzt:

`selectedTicketCount = 6`

Modul 017 darf daran nichts ändern.

Nach:

`Ergebnis → Erneut spielen`

müssen:

- Slider 6,
- Zahl 6,
- Minus enabled,
- Plus enabled

anzeigen.

Kein zusätzlicher Reset in `StartView.onAppear`.

## 8. Accessibility

Minus-Button exakt:

`Ein Ticket weniger`

Plus-Button exakt:

`Ein Ticket mehr`

Buttons sollen sinnvolle Symbole verwenden, beispielsweise:

- `minus`
- `plus`

Die Symbole selbst ersetzen nicht die Accessibility-Labels.

Disabled-Zustand muss für Accessibility korrekt über den tatsächlichen Button-Disabled-State entstehen.

## 9. Lokalisierung

Neue sichtbare Beschreibung und Accessibility-Labels in:

`Resources/Localizable.xcstrings`

Mindestens:

- Kurzbeschreibung
- `Ein Ticket weniger`
- `Ein Ticket mehr`

Bestehende Startseitenkeys wiederverwenden:

- `app.title`
- `start.ticketCount.label`
- `start.ticketCount.accessibility`
- `start.button.startGame`

Keine unnötigen Duplikate.

## 10. Layout

Die Startansicht muss im aktuell durch 016 gemeldeten größeren zentralen Volume sauber aussehen.

Prüfe:

- Beschreibung vollständig lesbar,
- Slider breit genug,
- Minus/Plus nicht zu klein,
- Zahl eindeutig zugeordnet,
- `Spiel starten` weiterhin gut erreichbar.

Nicht wegen Modul 017 erneut das zentrale Volume verändern, solange kein echter Fehler nachgewiesen ist.

Die Volume-/Monstergrößen aus 016 gehören nicht zum Scope von 017.

---

# Schutz von Modul 015/016 und v1.0

Modul 017 darf nicht ändern:

- HUD,
- InteractionHint,
- Ticketinfo,
- Overlay-State,
- Drag-Sperre,
- RealityView,
- Monstergrößen,
- Volume-Größe,
- Drop-Regel,
- Scoring,
- Audio,
- Feedback,
- Ergebnisansicht,
- Reset-Semantik.

`StartView` ist der primäre fachliche Änderungsort.

---

# Harte Modulgrenze

Modul 017 bearbeitet ausschließlich:

- F-22 / AK-22
- F-24 / AK-24

Nicht implementieren:

## Modul 018

- keinen grünen Haken,
- kein `+100 Punkte`,
- kein rotes Kreuz.

## Modul 019

- kein `Erneut laden`,
- keine Retry-Pipeline.

## Modul 020

- keine vollständige v1.1-Integration vorziehen.

Nicht hinzufügen:

- Tutorial
- Info-Button auf Startseite
- Popover
- `@AppStorage`
- Benutzerpräferenzen
- gespeicherte Ticketanzahl
- zusätzliche Startmodi.

---

# Automatisierte Tests

Erhalte alle vorhandenen Tests.

Ausgangswert laut 016-Report:

246 Testdeklarationen.

Ergänze mindestens Tests für:

1. Plus von 6 → 7.
2. Minus von 6 → 5.
3. Plus erhöht immer genau um 1.
4. Minus verringert immer genau um 1.
5. Minimum 1 kann nicht unterschritten werden.
6. Maximum 12 kann nicht überschritten werden.
7. Minus ist bei 1 als disabled ableitbar.
8. Plus ist bei 12 als disabled ableitbar.
9. Bei 6 sind beide enabled.
10. Slideränderung und Buttonänderung nutzen denselben `selectedTicketCount`.
11. Reset setzt Wert auf 6.
12. Nach Reset sind beide Buttons enabled.
13. Kurzbeschreibung entspricht exakt:
   `Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu.`
14. Accessibility-Text Minus exakt:
   `Ein Ticket weniger`
15. Accessibility-Text Plus exakt:
   `Ein Ticket mehr`

Bevorzuge eine kleine rein darstellungsbezogene Hilfsableitung nur, wenn damit disabled-Zustände/Testbarkeit sauberer werden.

Keine zweite Ticketanzahl speichern.

Nach Änderungen vollständige Suite ausführen.

Dokumentiere:

- vorher,
- neue Tests,
- nachher,
- Passed,
- Failed,
- Skipped,
- Plattform.

---

# Simulatorprüfung

## App-Neustart

Startansicht:

- Ticket Tamer
- Kurzbeschreibung direkt unter Titel
- Anzahl Tickets
- Minus
- Slider
- Plus
- Wert 6
- Spiel starten

## Plus

Von 6:

- einmal Plus → 7
- Slider → 7
- Zahl → 7

Mehrfach bis 12:

- bei 12 Plus disabled.

## Minus

Von 12:

- Minus → 11

Mehrfach bis 1:

- bei 1 Minus disabled.

## Slider-Synchronität

- Slider auf 4
- Zahl 4
- Minus → 3
- Plus → 4

## Start

Mit gewähltem Wert:

- `Spiel starten`
- Sitzung enthält genau diese Ticketanzahl.

## Reset

Sitzung vollständig oder über geeigneten Development-Weg bis Ergebnis:

- `Erneut spielen`
- Startansicht
- Wert 6
- Slider 6
- beide Buttons enabled
- Kurzbeschreibung sichtbar.

## Regression

Prüfe kurz:

- Start funktioniert,
- Modul-015-HUD erscheint in Untersuchung,
- Modul-016-Info in Priorisierung weiterhin erreichbar,
- keine Layoutänderung an Entscheidungsphasen durch Modul 017.

---

# Voraussichtlich relevante Dateien

## Geändert

- `Ticket_Tamer/Ticket_Tamer/Views/StartView.swift`
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Nur wenn anhand des realen Codes wirklich erforderlich:

- eine kleine wiederverwendbare rein visuelle Komponente unter `Views/Components/`,
- `AppConstants.swift` für klar zentrale Startlayoutwerte.

Nach Möglichkeit unverändert:

- `SessionModel.swift`
- `RootVolumeView.swift`
- `InvestigationView.swift`
- `PrioritizationView.swift`
- `TeamAssignmentView.swift`
- `CompactTicketInfoView.swift`
- `SessionHUDView.swift`
- `InteractionHintView.swift`
- Drag-/Drop-/Geometry-Code
- AudioService
- MonsterAssetProvider
- ResultView
- RealityKitContent

---

# DebugManager

Keine neue Kategorie.

Optional `.input` für:

- Minus-Tap
- Plus-Tap

Keine Logs pro Slider-Frame, wenn dies unnötig spammt.

Keine neue Debugstruktur.

---

# Git

## Vor 017

Modul 016 muss sauber getrennt sein.

Vorgesehener 016-Commit:

`016: Kompakte Ticketinfo`

Tatsächlichen Hash dokumentieren.

## Modul 017

Vorgesehener Commit:

`017: Startseiten-Usability`

Vor Commit:

- Build,
- vollständige Tests,
- Simulatorprüfung,
- `git diff --check`,
- prüfen, dass keine 016-Nachfixes im 017-Commit versteckt sind.

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- Working Tree
- tatsächlicher Modul-016-Commit
- reale 016-Dateien inklusive Volume-/Monstergrößenänderung
- Build/Test/Simulator 016
- tatsächliche Testzahl

## 2. Startseiten-Entwurf

- Kurzbeschreibung
- Minus/Slider/Plus-Layout
- Zahl
- Disabled-Zustände
- Accessibility

## 3. Zustandsfluss

- Source of Truth
- Plus
- Minus
- Slider
- Reset
- keine lokale Duplikation

## 4. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 5. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 6. Simulator-/Regressionstest

- Start bei 6
- Grenzen 1/12
- Slider-Synchronität
- Reset auf 6
- Beschreibung
- Regression 015/016

## 7. Vollständiger `017-Report.md`

Der Report muss zusätzlich ausdrücklich enthalten:

- tatsächlichen Git-Stand,
- tatsächlichen Modul-016-Commit,
- nachgetragene reale Dateien der 016-Layoutänderung,
- exakten Kurzbeschreibungstext,
- exakte Accessibility-Labels,
- Plus-/Minus-Semantik,
- Disabled-Grenzen,
- Synchronität Slider/Zahl/Buttons,
- Bestätigung: Slider bleibt vorhanden,
- Bestätigung: kein lokaler Ticketanzahl-State,
- Bestätigung: Reset bleibt `SessionModel.reset()`,
- Bestätigung: kein Tutorial/Popover/Persistenz,
- Bestätigung: Modul-015-HUD und Modul-016-Ticketinfo unverändert,
- Build/Test/Simulatorergebnis,
- Status AK-22,
- Status AK-24,
- offene Risiken,
- Empfehlung für **Modul 018 — Visuelles Entscheidungsfeedback**.

Baue nichts außerhalb dieses Moduls um.
