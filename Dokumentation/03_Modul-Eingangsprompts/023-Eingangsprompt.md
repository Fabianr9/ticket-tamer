# Modul-Eingangsprompt — 023 Teamstation-Symbole

> Vom Projektlogbuch nach Einarbeitung des `022-Report.md` erzeugt. In einen neuen Modul-Chat einfügen.

Du bist Fachentwickler:in für genau dieses eine Modul.

## Modul

**Nummer:** 023  
**Titel:** Teamstation-Symbole  
**Erfüllt:** F-28 / AK-28

**Ziel:** Ergänze jede der vier bestehenden Teamstationen um ein eindeutig verständliches semantisches Symbol zusätzlich zum vorhandenen deutschen Text. Die Symbolergänzung ist rein visuell: sichtbare Zielgröße, Drop-Bounds, Drop-Auswertung, 50-%-Overlap und Z-Toleranz dürfen sich nicht verändern.

---

# Ausgangsstand

v1.0 und v1.1 sind abgeschlossen.

v1.2:

- Modul 021 Replay-Layoutstabilisierung implementiert, AK-25 Laufzeit OPEN
- Modul 022 Punktekommunikation implementiert, AK-26/27 Laufzeit OPEN

Laut 022-Report:

- Branch `A`
- HEAD vor 022 `c11b464 fix: Modul 21`
- Modul-021-Commits `68268cb` bis `c11b464`
- Modul-022-Commit offen
- 313 Testdeklarationen
- Build/Test/Simulator offen

---

# Vorab-Gate

## 1. Git

Ermittle real:

- Branch
- HEAD
- Working Tree
- tatsächlichen Modul-022-Commit

Wenn Modul 022 noch uncommitted:

- 022-Diff klar identifizieren
- nach Möglichkeit Build/313 Tests/Simulatorabnahme ausführen
- 022 separat committen
- 023 nicht mit 022 vermischen

Keine Hashes erfinden.

## 2. Reale Testzahl

Im Repository prüfen.

Dokumentierter Ausgangswert:

**313**

Wenn abweichend:

- reale Zahl verwenden
- Ursache dokumentieren

## 3. Relevante Dateien vollständig lesen

Mindestens:

- `Views/TeamAssignmentView.swift`
- `Services/TargetPanelFactory.swift`
- `Services/TargetPanelLayout.swift`
- `Components/DropTargetComponent.swift`
- alle Typen/Hilfen für sichtbare Team-Labels oder Attachments
- `Support/AppConstants.swift`
- `Resources/Localizable.xcstrings`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Prüfe real:

- wie Teamstationen visuell erzeugt werden
- wie Text auf dem Panel gerendert wird
- ob SwiftUI Attachments, RealityKit TextEntities oder Material-/Texture-Lösung verwendet werden
- wo Panelgröße festgelegt wird
- wo Drop-Bounds entstehen
- ob dieselbe Box für sichtbares Panel und Drop-Geometrie verwendet wird

---

# F-28 — Teamstation-Symbole

Jede Teamstation zeigt zusätzlich zur bestehenden Textbezeichnung ein einfaches semantisch passendes Symbol. Der Text bleibt sichtbar und Farbe allein darf die Bedeutung nicht tragen.

# AK-28

1. Alle vier Teamstationen besitzen neben ihrem Text ein zusätzliches eindeutig unterscheidbares Symbol.
2. Semantik:
   - Netzwerk → Netzwerk-/Verbindungssymbol
   - Konto → Personen-/Schlüsselsymbol
   - Software → App-/Fenstersymbol
   - Hardware → Computer-/Werkzeugsymbol
   oder jeweils eine gleichwertig verständliche Alternative.
3. Die Texte bleiben vollständig sichtbar:
   - `Netzwerk`
   - `Konto`
   - `Software`
   - `Hardware`
4. Keine Teamstation ist ausschließlich über Farbe identifizierbar.
5. Die Symbole verändern weder sichtbare Zielgröße noch Drop-Bounds noch Drop-Auswertung.
6. Alle vier Stationen bleiben in vorgesehener Betrachtungsdistanz lesbar und unterscheidbar.

---

# Architekturregel

Die Änderung gehört ausschließlich in die **Darstellungs-/Labelschicht** der Teamstationen.

Nicht ändern:

- Panelbreite
- Panelhöhe
- Paneltiefe
- Panelposition
- DropTargetComponent
- Drop-Bounds
- Overlap-Berechnung
- Z-Toleranz
- Target-IDs
- SupportTeam-Mapping

Wenn vorhandene Architektur Text und Geometrie in demselben Factory-Typ erzeugt, darfst du nur den sichtbaren Labelinhalt erweitern.

---

# Symbolwahl

Bevorzuge Apple SF Symbols, sofern sie im realen visionOS-/SwiftUI-/Attachment-Aufbau ohne Zusatzassets funktionieren.

Mögliche Kandidaten, nur als Ausgangspunkt:

- Netzwerk → `network`, `antenna.radiowaves.left.and.right`, `point.3.connected.trianglepath.dotted`
- Konto → `person.crop.circle`, `person.badge.key`, `key`
- Software → `macwindow`, `rectangle.on.rectangle`, `app`
- Hardware → `desktopcomputer`, `wrench.and.screwdriver`, `cpu`

Die finale Wahl darf abweichen.

Wichtig:

- semantisch eindeutig
- in visionOS verfügbar
- gut lesbar
- nicht auf Farbe angewiesen

Prüfe reale SF-Symbol-Verfügbarkeit im verwendeten SDK.

Keine zusätzlichen Bildassets nötig, wenn SF Symbols genügen.

---

# Sichtbares Layout

Text und Symbol müssen gemeinsam in derselben bestehenden Zielstation sichtbar sein.

Bevorzugt:

```text
[ Symbol ]  Netzwerk
```

oder kompakt vertikal, falls das reale Panel dadurch besser lesbar bleibt:

```text
[ Symbol ]
Netzwerk
```

Aber:

**Panel-Außenmaße nicht vergrößern.**

Die innere Labeldarstellung muss sich an die bestehende Zielgröße anpassen.

---

# Panelgröße schützen

Vor Änderung Referenzwerte dokumentieren:

Für Teamziele:

- Panelbreite
- Panelhöhe
- Paneltiefe
- Positionen
- Target IDs
- Drop-Box/BBox

Nach Änderung dieselben Werte erneut prüfen.

Erwartung:

**identisch** innerhalb Floating-Toleranz.

Das Symbol darf nicht bewirken, dass SwiftUI-/RealityKit-Inhalt die physische Panelbox aufbläht.

---

# Drop-Bounds schützen

AK-28 verlangt ausdrücklich:

- keine Änderung an Drop-Bounds
- keine Änderung an Drop-Auswertung

Deshalb nicht ändern:

- `DropEvaluator`
- `minimumDropOverlapRatio`
- `dropDepthTolerance`
- `DropTargetComponent`-Geometrie
- `TargetPanelLayout`-Maße

Falls Layouttests bisher sichtbare Panelbox und Dropbox vergleichen, müssen sie weiterhin unverändert bestehen.

---

# Teamtexte schützen

Exakt sichtbar:

- Netzwerk
- Konto
- Software
- Hardware

Nicht ersetzen durch nur Symbole.

Nicht kürzen zu:

- Netz
- Account
- SW
- HW

Keine englischen Labels.

---

# Farbe

Bestehende Farben dürfen bleiben.

Aber jede Station muss auch ohne Farbwahrnehmung anhand von:

- Text
- Symbol

unterscheidbar sein.

Keine neue Farb-Codierung für fachliche Bedeutung einführen.

---

# Accessibility

Wenn Teamstationen als SwiftUI-Label/Attachment gebaut sind:

Accessibility soll mindestens Teamname sinnvoll enthalten.

Optional darf Symbolbeschreibung einfließen, sofern sie keine redundante oder verwirrende Ausgabe erzeugt.

Beispiele:

- `Netzwerk`
- `Konto`
- `Software`
- `Hardware`

müssen weiterhin verständlich erfasst werden.

Nicht nur `network icon` ohne Teamtext.

---

# Lokalisierung

Teamtexte existieren bereits.

Keine neuen sichtbaren deutschen Teamnamen anlegen, wenn vorhandene Strings wiederverwendbar sind.

Symbole selbst benötigen normalerweise keine sichtbare Lokalisierung.

Falls Accessibility-Beschreibungen ergänzt werden:

- String Catalog verwenden
- keine Lösung/Referenzwerte nennen

---

# Schutz von v1.2-Modul 021

Nicht verändern:

- RootVolumeView
- GeometryReader3D-Rootbasis
- `.defaultSize`
- Start-Sliderbreite
- Replay-Layoutlogik
- Monstergrößen
- HUD-/Hint-Anker

# Schutz von Modul 022

Nicht verändern:

- ResultView `X Punkte`
- DecisionFeedback `0 Punkte` / `+100 Punkte`
- Accessibility-Punktetexte
- Scoring
- Audio
- 1,5-s-Transition

---

# Harte Modulgrenze

Modul 023 bearbeitet ausschließlich F-28 / AK-28.

Nicht implementieren:

- DEV-Button-Isolation → Modul 024
- 16 Monster-Farbvarianten → Modul 025
- Gesamtintegration → Modul 026

Nicht nebenbei Layout-Replay oder Punktefeedback weiter verfeinern.

---

# Automatisierte Tests

Ausgangswert laut 022-Report:

**313 Testdeklarationen**

Reale Zahl im Preflight prüfen.

Ergänze mindestens Tests für:

1. Netzwerk besitzt Symbolkonfiguration.
2. Konto besitzt Symbolkonfiguration.
3. Software besitzt Symbolkonfiguration.
4. Hardware besitzt Symbolkonfiguration.
5. alle vier Symbolwerte sind nicht leer.
6. alle vier Symbolwerte sind untereinander sinnvoll unterscheidbar.
7. Netzwerk-Text bleibt `Netzwerk`.
8. Konto-Text bleibt `Konto`.
9. Software-Text bleibt `Software`.
10. Hardware-Text bleibt `Hardware`.
11. Team-Target-ID Netzwerk unverändert.
12. Team-Target-ID Konto unverändert.
13. Team-Target-ID Software unverändert.
14. Team-Target-ID Hardware unverändert.
15. Team-Panelbreite vor/nach Symbolintegration unverändert.
16. Team-Panelhöhe unverändert.
17. Team-Paneltiefe unverändert.
18. Drop-Bounds unverändert.
19. bestehende 50-%-Overlap-Auswertung unverändert.
20. Symbolkonfiguration benötigt keine Referenzpriorität oder Referenzteam-Lösung über das vorhandene Teamziel hinaus.

Wenn eine kleine reine Darstellungsstruktur sinnvoll ist, z. B.:

```text
TeamTargetPresentation
- title
- systemImageName
```

ist das zulässig.

Sie darf keine Drop-Geometrie besitzen.

---

# Simulatorprüfung

## Alle vier Teamstationen

Prüfe frontal:

- Netzwerk: Text + passendes Symbol
- Konto: Text + passendes Symbol
- Software: Text + passendes Symbol
- Hardware: Text + passendes Symbol

## Lesbarkeit

Prüfe:

- keine abgeschnittenen Texte
- keine übergroßen Symbole
- Symbol/Text nicht überlappend
- alle Stationen klar unterscheidbar

## Betrachtungswinkel

Mindestens:

- frontal
- leicht links
- leicht rechts
- leicht oben

## Drag/Drop-Regression

Für jede der vier Stationen:

- Monster draggen
- >= 50 % Overlap
- korrektes Team gespeichert

Ungültiger Bereich:

- Snapback weiterhin korrekt

Prüfe:

- sichtbare Box gleich groß wie vorher
- Dropbox gleich groß
- keine veränderte Trefferzone

## Farbenblindheits-/Semantikcheck

Ignoriere gedanklich die Farbe:

Kann jede Station allein anhand von Text + Symbol unterschieden werden?

Muss ja sein.

---

# Voraussichtlich relevante Dateien

Wahrscheinlich:

- `Views/TeamAssignmentView.swift`
- bestehende Team-Label-/Attachment-Komponente
- `Services/TargetPanelFactory.swift`
- eventuell kleine neue reine Präsentationsstruktur unter `Views/Components/` oder `Support/`
- `Ticket_TamerTests/Ticket_TamerTests.swift`

Nur falls Accessibility-Texte nötig:

- `Resources/Localizable.xcstrings`

Nach Möglichkeit unverändert:

- `TargetPanelLayout.swift`
- `DropEvaluator.swift`
- `DropTargetComponent.swift`
- `MonsterDragGeometry.swift`
- `SessionModel.swift`
- `RootVolumeView.swift`
- `ResultView.swift`
- `DecisionFeedbackView.swift`
- Audio
- Retry
- Monsterassets

---

# DebugManager

Keine neue Kategorie.

Keine zusätzlichen Logs erforderlich.

Falls zur Geometrieprüfung nötig:

- `.state`
- einmalige Panelmaße

Kein Render-Spam.

---

# Git

Vor Modul 023:

Modul 022 separat committen, sobald Build/Test/Simulatorabnahme möglich ist.

Vorgesehen:

`022: Punktekommunikation v1.2`

Modul 023:

`023: Teamstation-Symbole`

Keine Hashes erfinden.

Vor Commit 023:

- Build
- vollständige Tests
- Simulatorprüfung
- Geometrie-Vorher/Nachher
- `git diff --check`
- Scope-Diff

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 022-Commit
- Working Tree
- reale Testzahl
- Build/Test/Simulatorstatus

## 2. Bestehende Teamstationsarchitektur

- Panelerzeugung
- Textdarstellung
- Drop-Geometrie
- IDs
- Maße

## 3. Symbolentscheidung

Tabelle:

| Team | Text | Symbol | Begründung |
|---|---|---|---|
| Netzwerk | Netzwerk | | |
| Konto | Konto | | |
| Software | Software | | |
| Hardware | Hardware | | |

## 4. Geometrieschutz

Vorher/Nachher:

| Wert | vorher | nachher |
|---|---|---|
| Panelbreite | | |
| Panelhöhe | | |
| Paneltiefe | | |
| Drop-Bounds | | |

## 5. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 6. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 7. Simulator-/Regressionstest

- alle vier Symbole
- alle vier Texte
- Betrachtungswinkel
- Drag auf alle vier Ziele
- ungültiger Drop
- Geometrie unverändert
- Replay-/Punktekommunikation Regression

## 8. Vollständiger `023-Report.md`

Der Report muss ausdrücklich enthalten:

- tatsächlichen Gitstand
- tatsächlichen 022-Commit
- reale Testzahl
- finale vier Symbolnamen
- Begründung der Symbolwahl
- Bestätigung: alle vier Texte bleiben sichtbar
- Bestätigung: Farbe nicht alleinige Bedeutung
- Panelgröße vor/nach
- Drop-Bounds vor/nach
- Bestätigung: DropEvaluator unverändert
- Bestätigung: 50-%-Overlap unverändert
- Build/Test/Simulatorstatus
- AK-28 PASS/OPEN/FAIL
- offene Risiken
- Empfehlung für **Modul 024 — Debug-UI-Isolation**

Baue nichts außerhalb dieses Moduls um.
