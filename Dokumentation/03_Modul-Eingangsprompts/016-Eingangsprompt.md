# Modul-Eingangsprompt — 016 Kompakte Ticketinfo

> Vom **Projektlogbuch** nach Einarbeitung des `015-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 016.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**. Baue nur, was hier beauftragt ist.

# Modul

**Nummer:** 016  
**Titel:** Kompakte Ticketinfo  
**Erfüllt:** F-19 / AK-19

**Ziel:** Ergänze in Priorisierung und Teamzuordnung einen Info-Button und eine kompakte Ticketübersicht für exakt das aktuelle Ticket. Während die Übersicht geöffnet ist, darf die verdeckte 3D-Szene keine Drag-Eingaben annehmen. Das Overlay kann über `X` oder erneuten Info-Tap geschlossen werden und ist bei jedem Phasenwechsel geschlossen.

---

# Versionskontext

Ticket Tamer v1.0 ist abgeschlossen.

Version 1.1 ergänzt ausschließlich kleine Usability-Funktionen.

Bereits in Modul 015 implementiert:

- `SessionHUDView`,
- `InteractionHintView`,
- HUD in Untersuchung/Priorisierung/Teamzuordnung,
- dauerhafter Drag-Hinweis in Priorisierung/Teamzuordnung.

Modul 015 ist laut Report noch nicht vollständig in Xcode abgenommen:

- Build nach Modul 015 offen,
- vollständiger Lauf der 228 Testdeklarationen offen,
- Simulator-/Drag-Abnahme offen,
- Modul-015-Commit noch nicht erzeugt.

**Deshalb zuerst Baseline sichern.**

Wenn der Stand weiterhin uncommitted ist, führe nach Möglichkeit Build, vollständige Tests und die kurze Modul-015-Simulatorprüfung aus und committe Modul 015 mit einem echten Hash, bevor du fachliche Modul-016-Änderungen mischst.

Keinen Hash erfinden.

---

# F-19 — Kompakte Ticketinformationen in Entscheidungsphasen

> Das System bietet in Priorisierungs- und Teamzuordnungsphase einen Info-Button, der eine kompakte Ticketübersicht mit Ticketnummer, Titel, Kurzbeschreibung, User Impact und Symptomen beziehungsweise Hinweisen öffnet, ohne Referenzpriorität oder Referenzteam anzuzeigen.

# AK-19 — verbindliche Abnahme

Alle Punkte müssen erfüllt sein:

1. GEGEBEN Priorisierung oder Teamzuordnung ist aktiv, WENN der Info-Button aktiviert wird, DANN öffnet sich eine kompakte Ticketübersicht für exakt `model.currentTicket`.
2. Die Übersicht zeigt ausschließlich:
   - Ticketnummer,
   - Titel,
   - Kurzbeschreibung,
   - User Impact,
   - Symptome beziehungsweise Hinweise.
3. Niemals anzeigen:
   - Referenzpriorität,
   - Referenzteam,
   - richtige Lösung,
   - interne Bewertungsdaten.
4. GEGEBEN die Übersicht ist geöffnet, WENN versucht wird, das Monster in der verdeckten 3D-Szene zu ziehen, DANN wird **keine Drag-Interaktion** ausgelöst.
5. GEGEBEN die Übersicht ist geöffnet, WENN `X` oder der Info-Button erneut aktiviert wird, DANN schließt sich die Übersicht und Drag & Drop ist anschließend wieder möglich.
6. GEGEBEN ein Phasenwechsel erfolgt, WENN die nächste Phase angezeigt wird, DANN ist die Ticketübersicht geschlossen.
7. In der Untersuchungsphase gibt es **keinen zusätzlichen Info-Button**, weil die vollständige Ticketkarte dort bereits sichtbar ist.

---

# Verbindliche Architektur

## `SessionModel` bleibt unverändert

Der Overlay-Zustand ist rein darstellungsbezogen.

Laut SPEC ausdrücklich view-lokal:

```text
PrioritizationView
- isTicketInfoPresented: Bool

TeamAssignmentView
- isTicketInfoPresented: Bool
```

Nicht hinzufügen zu:

- `SessionModel`,
- `Ticket`,
- `GamePhase`.

Keine globale Overlay-Verwaltung.

## Ticketquelle

Die Übersicht liest ausschließlich:

`model.currentTicket`

Keine Kopie des Tickets in einem zweiten fachlichen Zustand.

Wenn `currentTicket == nil`:

- Overlay nicht mit erfundenen Daten anzeigen,
- defensiv behandeln,
- kein Crash.

---

# Verbindlicher Vorab-Check

## 1. Git

Ermittle real:

- Branch,
- HEAD,
- Working Tree,
- tatsächlichen Modul-015-Commit oder noch offenen Stand.

Wenn Modul 015 noch uncommitted ist:

- Diff klar trennen,
- nach Möglichkeit 015 erst validieren und committen,
- 016 nicht in denselben Commit mischen.

## 2. Build/Test-Baseline

Laut 015-Report:

- v1.0-Basis: 217/217 PASS,
- aktueller Quellstand nach 015: 228 Testdeklarationen,
- neuer Xcode-Lauf offen.

Führe nach Möglichkeit vor 016 aus:

- Build,
- vollständige Tests.

Dokumentiere echte Zahlen.

Wenn 228 nicht mehr stimmt, verwende die reale Zahl.

## 3. Modul-015-Simulatorregression

Wenn Simulator verfügbar, kurz prüfen:

- HUD sichtbar,
- Ticketfortschritt korrekt,
- Interaktionshinweise sichtbar,
- Prioritätsdrag nicht blockiert,
- Teamdrag nicht blockiert.

Erst dann Modul 016 darauf aufbauen.

## 4. Relevante Dateien lesen

Mindestens:

- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Views/InvestigationView.swift`
- `Views/Components/SessionHUDView.swift`
- `Views/Components/InteractionHintView.swift`
- `Models/Ticket.swift`
- `Models/SessionModel.swift`
- `Services/MonsterInteractionConfigurator.swift`
- aktuelle Gesture-/Drag-Handler in beiden Entscheidungsviews
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

---

# Konkreter Arbeitsauftrag

## 1. `CompactTicketInfoView` erstellen

Neue wiederverwendbare Komponente:

`Ticket_Tamer/Ticket_Tamer/Views/Components/CompactTicketInfoView.swift`

Sie erhält das aktuelle `Ticket` oder exakt die zur Darstellung erforderlichen Ticketdaten.

Bevorzuge eine kleine API, die keine verbotenen Referenzwerte benötigt.

Beispielverantwortung:

- Ticketnummer,
- Titel,
- Kurzbeschreibung,
- User Impact,
- Symptome/Hinweise,
- Schließen-Aktion.

Keine Scoring-/Sessionlogik.

## 2. Sichtbarer Inhalt exakt begrenzen

Die kompakte Übersicht darf ausschließlich anzeigen:

- Ticketnummer,
- Titel,
- Kurzbeschreibung,
- User Impact,
- Symptome/Hinweise.

Nicht anzeigen:

- `referencePriority`,
- `referenceTeam`,
- `selectedPriority`,
- `selectedTeam`,
- `score`,
- richtig/falsch,
- Lösungshinweise,
- `monsterAssetId`,
- interne IDs, sofern sie keine sichtbare Ticketnummer sind.

Auch keine aus den Daten ableitbare Lösungserklärung.

## 3. Info-Button in Priorisierung

Ergänze in `PrioritizationView` einen gut sichtbaren Info-Button.

Eigenschaften:

- öffnet Ticketinfo,
- erneuter Tap schließt Ticketinfo,
- Accessibility-Label verständlich,
- liegt so, dass HUD und unterer Interaktionshinweis aus Modul 015 nicht verdeckt werden.

Der Button darf das bestehende HUD nicht ersetzen.

## 4. Info-Button in Teamzuordnung

Identisches Verhalten in `TeamAssignmentView`.

Nutze möglichst dasselbe visuelle Muster und dieselben Lokalisierungsschlüssel.

Keine zwei fachlich unterschiedlichen Implementierungen.

## 5. View-lokalen Zustand verwenden

Je View:

```text
@State private var isTicketInfoPresented = false
```

oder eine semantisch gleichwertige lokale Lösung.

Nicht in `SessionModel`.

Der Zustand darf nicht zwischen Tickets oder Phasen persistieren.

## 6. Overlay-Darstellung

Das Overlay soll:

- kompakt,
- gut lesbar,
- klar über der verdeckten Szene,
- innerhalb des zentralen Volumes,
- ohne neues Fenster/Sheet/Volume/Immersive Space

dargestellt werden.

Bevorzuge eine SwiftUI-Lösung innerhalb der vorhandenen View.

Keine neue Navigation.

### Layoutkonflikte vermeiden

Modul 015 belegt:

- oben: Session-HUD,
- unten: InteractionHint.

Die Ticketinfo darf diese Bereiche nicht dauerhaft unbrauchbar machen.

Sie darf während des geöffneten Zustands die eigentliche 3D-Szene bewusst verdecken, weil Drag dann ohnehin gesperrt sein muss.

## 7. `X`-Schließen

Das Overlay enthält einen klaren Schließen-Button `X`.

Anforderungen:

- sichtbar,
- bedienbar,
- Accessibility-Label, z. B. sinngemäß `Ticketinformationen schließen`,
- setzt ausschließlich `isTicketInfoPresented = false`.

Kein Phasenwechsel.

## 8. Erneuter Info-Tap schließt

Wenn Overlay geöffnet und Info-Button erneut aktiviert:

- Overlay schließt.

Danach Drag & Drop wieder möglich.

Keine zusätzliche „Fertig“-Schaltfläche erforderlich.

## 9. Drag während Overlay zwingend deaktivieren

Das ist ein Kernpunkt von AK-19.

Wenn Ticketinfo geöffnet:

- Blick/Pinch/Drag der verdeckten 3D-Szene darf keine Monsterbewegung auslösen,
- kein `handleDragChanged`,
- kein `handleDragEnded`,
- keine Entscheidung,
- kein Score,
- kein Lock durch Drag,
- kein Snapback-Task wegen eines nicht gestarteten Drags.

Bevorzuge eine klare, robuste Sperre an der View-/RealityView-Ebene, beispielsweise:

- RealityView/Gesture-Fläche erhält während Overlay kein Hit-Testing,

oder eine gleichwertige technisch saubere Lösung.

Wenn die bestehende Gesture-Struktur eine zusätzliche Guard-Prüfung benötigt, ist sie zulässig.

Wichtig:

**Diese Overlay-Sperre ist keine fachliche `SessionModel.isInputLocked`-Entscheidung.**

`isInputLocked` nicht als Overlay-State missbrauchen.

Warum:

- `isInputLocked` gehört zur Exactly-once-/Feedbacklogik,
- das Ticketinfo-Overlay ist nur lokaler UI-Zustand.

## 10. Drag nach Schließen wieder aktiv

Nach:

- `X`,
- erneutem Info-Tap,

muss die bestehende Drag-Interaktion ohne Neuaufbau der fachlichen Sitzung wieder funktionieren.

Keine Entsperrung über `model.unlockInput()` nur wegen Overlay.

Das Overlay darf den fachlichen Lock nicht verändern.

Beispiel:

- Wenn fachlich `isInputLocked == true`, bleibt Drag auch nach Overlay-Schließen fachlich gesperrt.
- Wenn fachlich `isInputLocked == false`, darf Drag nach Overlay-Schließen wieder funktionieren.

## 11. Phasenwechsel schließt Overlay

Bei Übergang:

- Priorität → Team,
- Team → nächstes Ticket / Ergebnis,

darf kein altes Ticketinfo-Overlay bestehen bleiben.

Da der Zustand view-lokal ist, kann die View-Lebensdauer dies bereits sicherstellen. Prüfe es aber real.

Wenn der aktuelle SwiftUI-Aufbau den State erhalten könnte:

- explizit auf Phasenwechsel schließen.

Keine globale Resetlogik.

## 12. Kein Info-Button in Untersuchung

`InvestigationView` bleibt bezüglich F-19 unverändert.

Dort:

- vollständige Ticketkarte bereits sichtbar,
- kein zusätzlicher Info-Button,
- keine kompakte Overlaykopie.

Modul-015-HUD bleibt bestehen.

## 13. HUD und Hint schützen

Nicht verändern:

- `SessionHUDView`-Berechnung,
- Ticketfortschritt,
- Phasentitel,
- `InteractionHintView`-Texte.

Wenn Ticketinfo geöffnet:

- HUD darf je nach Layout weiterhin sichtbar sein oder vom Overlay optisch überlagert werden, solange die Übersicht klar nutzbar ist und nach Schließen alles unverändert zurückkehrt.
- Der untere Hinweis darf bestehen bleiben, obwohl Drag während Overlay deaktiviert ist; keine neue Tutoriallogik.

Keine Modul-015-Komponenten neu entwerfen, solange kein realer Layoutdefekt nachgewiesen ist.

## 14. Lokalisierung

Alle neuen sichtbaren und Accessibility-Texte in:

`Localizable.xcstrings`

Mindestens sinngemäß:

- Info-Button Accessibility-Label,
- Schließen-Accessibility-Label,
- Abschnittsbezeichnung User Impact/Auswirkung, falls nicht vorhandener Key wiederverwendbar,
- Symptome/Hinweise, falls nicht vorhandener Key wiederverwendbar.

Bestehende Investigation-Lokalisierungen bevorzugt wiederverwenden, wenn semantisch identisch.

Keine doppelten Schlüssel ohne Grund.

## 15. Accessibility

Info-Button:

- verständliches Accessibility-Label.

X-Button:

- verständliches Schließen-Label.

Ticketinfo:

- sinnvoll lesbare Reihenfolge,
- keine Referenzwerte im Accessibility-Text,
- Symptome verständlich gruppiert.

---

# Schutz der bestehenden Logik

Modul 016 darf nicht verändern:

- `savePriority(_:)`,
- `saveTeam(_:)`,
- `evaluatePriority()`,
- `evaluateTeam()`,
- Score,
- Audio,
- Feedbackdelay,
- Exactly-once,
- `isInputLocked`-Semantik,
- DropEvaluator,
- 50-%-Overlap,
- Z-Toleranz,
- DragBounds,
- Snapback,
- Zielpanelerzeugung,
- Monster-Asset-Mapping.

Keine neuen Zielpanels beim Öffnen/Schließen des Overlays.

Keine erneute Monsterladung für Ticketinfo.

---

# Harte Modulgrenze

Modul 016 bearbeitet **nur F-19 / AK-19**.

Nicht implementieren:

## Modul 017

- keine Startseitenbeschreibung,
- keine Minus-/Plus-Buttons.

## Modul 018

- kein grüner Haken,
- kein rotes Kreuz,
- kein `+100 Punkte`.

## Modul 019

- kein `Erneut laden`,
- keine Retry-Logik.

## Modul 020

- keine vollständige v1.1-Abnahme vorziehen.

Außerdem nicht:

- Tutorial,
- Persistenz,
- AppStorage,
- neue Fenster,
- neues Volume,
- Immersive Space,
- sichtbarer Score während Sitzung.

---

# Automatisierte Tests

Erhalte alle vorhandenen Tests.

Ausgangswert laut 015-Report:

228 Testdeklarationen.

Ergänze sinnvolle Tests für F-19/AK-19.

Mindestens absichern:

1. Ticketinfo-Darstellung verwendet Ticketnummer.
2. Titel wird übernommen.
3. Kurzbeschreibung wird übernommen.
4. User Impact wird übernommen.
5. alle Symptome werden übernommen.
6. Referenzpriorität ist nicht Teil eines darstellungsbezogenen Ticketinfo-Modells.
7. Referenzteam ist nicht Teil eines darstellungsbezogenen Ticketinfo-Modells.
8. Score/selectedPriority/selectedTeam werden nicht benötigt.
9. Overlay-State startet geschlossen.
10. Info-Toggle geschlossen → geöffnet.
11. Info-Toggle geöffnet → geschlossen.
12. Phasenwechsel-/View-Neustartzustand beginnt geschlossen.
13. Drag-Freigabe ist `false`, wenn Overlay geöffnet ist.
14. Drag-Freigabe ist `true`, wenn Overlay geschlossen und fachlicher Lock false ist.
15. fachlicher Lock bleibt maßgeblich: Overlay-Schließen darf `isInputLocked == true` nicht umgehen.

Falls eine kleine, rein UI-bezogene Hilfsstruktur für diese Logik sinnvoll ist, ist sie zulässig.

Keine neue fachliche State-Machine.

Nach Änderungen:

- vollständige Testsuite ausführen,
- reale neue Testzahl dokumentieren.

---

# Simulatorprüfung

## Priorisierung

1. Sitzung starten.
2. Priorisierung öffnen.
3. HUD und Interaktionshinweis aus Modul 015 sichtbar.
4. Info-Button aktivieren.
5. Ticketinfo öffnet für exakt aktuelles Ticket.
6. Prüfen:
   - Ticketnummer,
   - Titel,
   - Kurzbeschreibung,
   - Auswirkung,
   - alle Symptome.
7. Prüfen:
   - keine Priorität,
   - kein Team,
   - keine Lösung,
   - kein Score.
8. Bei geöffnetem Overlay versuchen, Monster zu greifen:
   - keine Drag-Reaktion.
9. `X`:
   - Overlay schließt,
   - Drag wieder möglich.
10. erneut öffnen und Info-Button erneut:
   - Overlay schließt,
   - Drag wieder möglich.

## Teamzuordnung

Gleicher Test.

## Phasenwechsel

Prioritätsinfo öffnen und dann den regulären weiteren Ablauf herstellen:

- in der nächsten Teamphase darf Overlay nicht mehr geöffnet sein.

Teaminfo öffnen und regulär weiter:

- nächstes Ticket/Ergebnis ohne altes Overlay.

## Exactly-once-Regression

Prüfe mindestens einen vollständigen Ticketzyklus:

- Overlay öffnen/schließen,
- Prioritätsdrop,
- Sound,
- Übergang,
- Overlay öffnen/schließen,
- Teamdrop,
- Sound,
- nächstes Ticket.

Keine:

- Doppelwertung,
- doppelten Sounds,
- doppelten Zielpanels,
- Phasenfehler.

---

# Voraussichtlich relevante Dateien

## Neu

- `Ticket_Tamer/Ticket_Tamer/Views/Components/CompactTicketInfoView.swift`

## Geändert

- `Ticket_Tamer/Ticket_Tamer/Views/PrioritizationView.swift`
- `Ticket_Tamer/Ticket_Tamer/Views/TeamAssignmentView.swift`
- `Ticket_Tamer/Ticket_Tamer/Resources/Localizable.xcstrings`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Nur falls für saubere rein lokale UI-Logik sinnvoll:

- kleine Komponente/Hilfsstruktur unter `Views/Components/`.

Nach Möglichkeit unverändert:

- `InvestigationView.swift`
- `SessionHUDView.swift`
- `InteractionHintView.swift`
- `SessionModel.swift`
- `Ticket.swift`
- Scoring-/Audio-Services
- Drop-/Geometry-Services
- MonsterAssetProvider
- ResultView
- StartView
- RealityKitContent

---

# DebugManager

Keine neue Kategorie.

Optional vorhandene Kategorien sparsam:

- `.input` für Info öffnen/schließen,
- `.lifecycle` für Overlay erscheinen.

Kein Render-Spam.

Keine Referenzpriorität oder Referenzteam loggen.

---

# Git

Nach erfolgreicher Abnahme:

`016: Kompakte Ticketinfo`

Vor Commit:

- Build,
- vollständige Tests,
- Simulatorprüfung,
- `git diff --check`,
- Scope-Diff prüfen.

Hash nicht erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch/HEAD
- Modul-015-Commit
- Working Tree
- Build/Test-Baseline
- 015-Simulatorstatus

## 2. Ticketinfo-Entwurf

- `CompactTicketInfoView`
- sichtbare Felder
- ausdrücklich ausgeschlossene Felder
- Layout
- Accessibility
- Lokalisierung

## 3. Overlay-State und Drag-Sperre

- lokale State-Variablen
- Info-Toggle
- X
- Phasenwechsel
- technische Drag-Deaktivierung
- Zusammenspiel mit `isInputLocked`

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

- Priorisierung
- Team
- Drag bei offenem Overlay blockiert
- Drag nach Schließen wieder aktiv
- Overlay bei Phasenwechsel geschlossen
- v1.0/015 unverändert

## 7. Vollständiger `016-Report.md`

Der Report muss zusätzlich ausdrücklich enthalten:

- tatsächlichen Git-Stand,
- tatsächliche Testzahl,
- neue Komponente und Schnittstelle,
- alle sichtbaren Ticketinfo-Felder,
- Bestätigung: keine Referenzpriorität,
- Bestätigung: kein Referenzteam,
- Bestätigung: kein Score/interne Bewertungsdaten,
- lokale `isTicketInfoPresented`-Semantik,
- genaue Drag-Sperre,
- Zusammenspiel mit `model.isInputLocked`,
- Schließen per X und erneutem Info-Tap,
- automatisches Schließen bei Phasenwechsel,
- Bestätigung: kein Info-Button in InvestigationView,
- HUD/Hint aus Modul 015 unverändert,
- Build/Test/Simulatorergebnis,
- Status AK-19,
- offene Risiken,
- Empfehlung für **Modul 017 — Startseiten-Usability**.

Baue nichts außerhalb dieses Moduls um.
