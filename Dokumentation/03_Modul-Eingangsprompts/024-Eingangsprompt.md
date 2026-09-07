# Modul-Eingangsprompt — 024 Debug-UI-Isolation

> Vom **Projektlogbuch** nach Einarbeitung des `023-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 024.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**.

# Modul

**Nummer:** 024  
**Titel:** Debug-UI-Isolation  
**Erfüllt:** F-29 / AK-29

**Ziel:** Entferne die Entwicklungs-Schaltfläche `🔧 Team [DEV]` vollständig aus dem normalen App-Ablauf – auch in einem regulären Debug-Build – ohne die eigentliche Priorisierungs- oder Teamzuordnungslogik zu verändern. Entwicklerfunktionen dürfen ausschließlich im separaten `DebugInteractionHarnessView` beziehungsweise in einem explizit aktivierten Debug-Kontext verfügbar bleiben.

---

# Ausgangsstand

v1.0 und v1.1 sind abgeschlossen.

v1.2:

- Modul 021: Replay-Layoutstabilisierung implementiert, AK-25 Laufzeit OPEN
- Modul 022: Punktekommunikation implementiert, AK-26/27 Laufzeit OPEN
- Modul 023: Teamstation-Symbole implementiert, AK-28 Laufzeit OPEN

Laut 023-Report:

- Branch `A`
- HEAD vor 023 `3c0b2fb feat: Modul 22`
- tatsächlicher Modul-022-Commit `3c0b2fb`
- Modul-023-Commit offen
- **333 Testdeklarationen**
- Build/Test/Simulator offen

---

# Vorab-Gate

## 1. Git

Ermittle real:

- Branch
- HEAD
- Working Tree
- tatsächlichen Modul-023-Commit

Wenn Modul 023 noch uncommitted:

- 023-Diff klar identifizieren
- nach Möglichkeit Build, vollständige 333 Tests und Simulatorprüfung nachholen
- Modul 023 separat committen
- Änderungen aus 023 und 024 nicht vermischen

Keine Hashes erfinden.

## 2. Reale Testzahl

Im Repository prüfen.

Dokumentierter Ausgangswert:

**333**

Bei Abweichung reale Zahl verwenden und Ursache dokumentieren.

## 3. Projektweite Debug-UI-Suche

Bevor du Code änderst, suche projektweit nach mindestens:

- `🔧 Team [DEV]`
- `Team [DEV]`
- `DEV`
- `DebugInteractionHarnessView`
- `#if DEBUG`
- `DebugManager`
- Buttons oder Navigation, die direkt in Team-/Priorisierungsphasen springen
- Debug-Harness-Routing
- Debug-only Overlays/Ornaments

Erstelle im Report eine Tabelle:

| Fundstelle | Datei | normaler Flow? | Debug-Harness? | Maßnahme |
|---|---|---|---|---|

Nicht pauschal alle Debug-Funktionen entfernen.

---

# F-29 — DEV-Schaltfläche aus normalem Flow entfernen

> Die Entwicklungs-Schaltfläche `🔧 Team [DEV]` erscheint nicht im normalen App-Ablauf, auch nicht in einem regulären Debug-Build. Entwicklungszugriffe bleiben ausschließlich im separaten Debug-Harness beziehungsweise in explizit aktivierten Debug-Kontexten verfügbar.

# AK-29

1. Normaler Debug-Build über `RootVolumeView`:
   - kompletter Spielablauf
   - `🔧 Team [DEV]` erscheint in keiner produktnahen Phase.
2. Release-Build:
   - ebenfalls keine DEV-Schaltfläche.
3. Separater `DebugInteractionHarnessView` beziehungsweise explizit aktivierter Debug-Kontext:
   - Entwicklerfunktion darf weiterhin verfügbar sein.
4. Entfernen der Schaltfläche verändert weder:
   - Priorisierungslogik
   - Teamzuordnungslogik

---

# Wichtigste Architekturregel

**Debug-Build ist nicht automatisch Debug-Harness.**

Ein normal gestarteter Debug-Build soll denselben produktnahen UI-Flow zeigen wie Release.

Das bloße Umschließen der DEV-Schaltfläche mit:

```text
#if DEBUG
```

ist deshalb für F-29 **nicht ausreichend**, wenn sie dadurch im normalen Debug-App-Flow sichtbar bleibt.

Erlaubt:

- Debug-Harness besitzt die Funktion
- expliziter Debug-Kontext besitzt die Funktion

Nicht erlaubt:

- normaler `RootVolumeView` zeigt sie nur deshalb, weil Build Configuration Debug ist

---

# Bestehenden Debug-Harness schützen

Historisch existiert:

`DebugInteractionHarnessView`

Prüfe die reale aktuelle Datei und Verwendung.

Wenn der Harness:

- separat aufgerufen wird,
- nicht im normalen Routing hängt,
- ausschließlich Development-Zwecken dient,

darf die Entwicklerfunktion dort bestehen bleiben.

Nicht entfernen, nur um AK-29 schnell grün zu machen.

Ziel ist **Isolation**, nicht Löschung aller Debugmöglichkeiten.

---

# Normalen Routing-Pfad bestimmen

Dokumentiere real:

```text
Ticket_TamerApp
→ RootVolumeView
→ Start
→ Untersuchung
→ Priorisierung
→ Team
→ Ergebnis
```

Prüfe in jeder produktnahen View:

- StartView
- InvestigationView
- PrioritizationView
- TeamAssignmentView
- ResultView
- RootVolumeView

auf DEV-Einstiege.

Nach Modul 024 darf im gesamten normalen Routing keine sichtbare `🔧 Team [DEV]`-Schaltfläche mehr existieren.

---

# Mögliche saubere Lösungen

Die konkrete Lösung hängt vom aktuellen Code ab.

Bevorzuge minimal:

## Fall A — Button liegt direkt in produktiver View

Entferne ihn dort vollständig.

Falls dieselbe Debugfunktion benötigt wird:

- verschiebe/verwende sie im `DebugInteractionHarnessView`

## Fall B — Button ist über Debugflag eingeblendet

Wenn er trotz `#if DEBUG` im normalen Flow sichtbar ist:

- produktive View darf ihn nicht mehr rendern
- Debug-Harness rendert ihn separat

## Fall C — expliziter Debug-Kontext existiert bereits

Dann darf eine eindeutige explizite Bedingung verwendet werden, z. B. nur wenn die View tatsächlich im Harness betrieben wird.

Aber:

- keine neue globale Debug-State-Machine
- kein UserDefault/AppStorage nur für DEV-Button
- kein verstecktes produktives Menü

---

# Keine fachliche Team-Abkürzung im normalen Flow

Nach Modul 024 darf eine nutzende Person im normalen App-Flow nicht über einen DEV-Button:

- Priorisierung überspringen
- direkt zur Teamphase springen
- Entscheidung manipulieren
- Sessionzustand künstlich verändern

Der reguläre Ablauf bleibt:

`Untersuchung → Priorisierung → Team`

---

# Schutz von Priorisierung und Team

Nicht verändern:

- `savePriority`
- `saveTeam`
- `evaluatePriority`
- `evaluateTeam`
- `beginTeamAssignmentPhase`
- `completeTicketAfterTeamFeedback`
- Score
- Audio
- Exactly-once
- Input-Lock
- Feedback
- 50-%-Drop
- Snapback

Entferne nur den Debugzugriff aus dem normalen UI-Pfad.

---

# Schutz von Modul 023

Nicht verändern:

- `TeamTargetMapping.Presentation`
- Symbolzuordnungen:
  - `network`
  - `person.crop.circle`
  - `macwindow`
  - `desktopcomputer`
- Teamtexte
- Attachments
- Panelgeometrie
- Drop-Bounds
- DropEvaluator

Die Debug-Isolation darf die Teamstationdarstellung nicht berühren.

---

# Schutz von Modul 021/022

Nicht verändern:

- Replay-Rootarchitektur
- `GeometryReader3D`-Rootbasis
- `.defaultSize`
- Slider-Designbreite
- `X Punkte`
- `0 Punkte`
- `+100 Punkte`
- DecisionFeedback
- ResultView-Punkteformat

---

# Release-Build-Prüfung

AK-29 fordert explizit auch Release.

Mindestens statisch prüfen:

- DEV-Schaltfläche ist nicht Bestandteil der normalen produktiven View-Hierarchie.
- Kein Codepfad rendert sie im Release.

Wenn Xcode verfügbar:

- Debug-Build normal starten
- Release-Build oder Release-nahe Konfiguration prüfen

Wenn Release-Simulatorlauf nicht praktikabel:

- Build + Codepfad dokumentieren
- Status nur so weit als PASS markieren, wie tatsächlich belegt

---

# Debug-Harness-Prüfung

Separaten Harness öffnen beziehungsweise dessen Preview/Testpfad prüfen.

Wenn die Entwicklerfunktion dort vorgesehen ist:

- darf verfügbar bleiben
- muss klar vom normalen Routing getrennt sein

Falls der Harness derzeit nicht ausführbar/eingehängt ist:

- nicht für Modul 024 eine neue produktive Navigation dorthin bauen
- strukturell dokumentieren, dass er separat existiert

---

# Quellcodehygiene

Nach Entfernung darf kein toter produktiver Code übrig bleiben wie:

- ungenutzte `showDevButton`
- überflüssige `#if DEBUG`-Blöcke nur für entfernten Button
- tote Button-Actions
- tote lokale States

Aber:

Nicht ganze DebugManager-/Harness-Strukturen löschen, wenn sie anderweitig genutzt werden.

---

# Lokalisierung

Falls `🔧 Team [DEV]` im String Catalog als produktiver Key existiert:

- prüfen, ob er ausschließlich dieser entfernten UI dient
- nur dann entfernen, wenn keine Debug-Harness-Nutzung mehr darauf angewiesen ist

Wenn Harness denselben String weiter nutzt:

- Key darf bleiben

Keine unnötige Lokalisierungsbereinigung außerhalb Scope.

---

# Automatisierte Tests

Ausgangswert laut 023-Report:

**333 Testdeklarationen**

Reale Zahl im Preflight prüfen.

Ergänze mindestens sinnvolle Tests/Strukturprüfungen für:

1. produktive TeamAssignment-Präsentation enthält keinen DEV-Button-Konfigurationswert.
2. normaler Root-Routingpfad besitzt keinen DEV-Team-Shortcut.
3. Debug-Harness-Typ bleibt vorhanden.
4. Debug-Harness darf weiterhin eine explizite Entwickleraktion besitzen, falls aktuell vorgesehen.
5. Priorisierungsphase wechselt regulär nur über bestehende fachliche Transition zur Teamphase.
6. Entfernen der DEV-UI verändert `savePriority` nicht.
7. Entfernen der DEV-UI verändert `saveTeam` nicht.
8. TeamTargetMapping bleibt identisch.
9. Team-Symbole aus Modul 023 bleiben identisch.
10. Release-nahe produktive Präsentation besitzt keinen DEV-Labeltext.

Vermeide fragile Sourcecode-Stringtests, wenn eine kleine Präsentations-/Routingstruktur semantisch testbar ist.

Falls keine sinnvolle Unit-Test-Oberfläche existiert:

- bestehende Kernlogiktests erhalten
- gezielte statische Projekt-Suche als Nachweis dokumentieren
- keine künstliche Architektur nur für Testbarkeit einführen

---

# Statische Abschluss-Suche

Nach der Änderung erneut projektweit suchen nach:

`🔧 Team [DEV]`

Jede verbleibende Fundstelle muss klassifiziert sein:

- erlaubt im Debug-Harness
- Dokumentation/Testfixture
- oder Fehler

Im normalen produktiven View-Code darf keine Fundstelle übrig bleiben.

---

# Simulatorprüfung

## Normaler Debug-Build

Kompletter Ablauf:

1. Start
2. Untersuchung
3. Priorisierung
4. Team
5. Ergebnis

Prüfen:

- nirgends `🔧 Team [DEV]`

Besonders Priorisierung und Team.

## Fachlicher Flow

Prüfe:

- Weiter zur Priorisierung
- gültiger Prioritätsdrop
- regulärer Auto-Übergang zur Teamphase
- gültiger Teamdrop
- Ergebnis

Kein Debugshortcut nötig.

## Debug-Harness

Wenn separat ausführbar:

- Entwicklerfunktion weiterhin nutzbar
- klar getrennt vom normalen Flow

## Regression

Kurz prüfen:

- Team-Symbole 023
- Punktekommunikation 022
- Replay-Root 021

---

# Harte Modulgrenze

Modul 024 bearbeitet ausschließlich F-29 / AK-29.

Nicht implementieren:

- Monster-Farbvarianten → 025
- v1.2-Gesamtintegration → 026
- neue Debug-Menüs
- neue produktive Debugnavigation
- neue Settings
- neue UserDefaults/AppStorage-Schalter

---

# Voraussichtlich relevante Dateien

Zuerst real durch Suche bestimmen.

Mögliche Kandidaten:

- `Views/TeamAssignmentView.swift`
- `Views/PrioritizationView.swift`
- `Views/RootVolumeView.swift`
- `Views/DebugInteractionHarnessView.swift`
- `Debug/DebugManager.swift`
- Tests

Ändere nur Dateien, die tatsächlich für die Isolation nötig sind.

Nach Möglichkeit unverändert:

- `SessionModel.swift`
- TeamTargetMapping-/Panel-/Drop-Code
- `DecisionFeedbackView.swift`
- `ResultView.swift`
- Replay-Layoutcode
- MonsterAssetProvider
- Retry-Code

---

# DebugManager

Keine neue Kategorie.

Vorhandenen DebugManager nicht entfernen.

F-29 betrifft sichtbare DEV-UI im normalen Flow, nicht Logging.

---

# Git

Vor Modul 024:

Modul 023 separat committen, sobald Build/Test/Simulatorabnahme möglich ist.

Vorgesehen:

`023: Teamstation-Symbole`

Modul 024:

`024: Debug-UI-Isolation`

Keine Hashes erfinden.

Vor Commit:

- Build
- vollständige Tests
- normaler Debug-Flow
- Release-Prüfung
- Debug-Harness-Prüfung
- projektweite DEV-String-Suche
- `git diff --check`
- Scope-Diff

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 023-Commit
- Working Tree
- reale Testzahl
- Build/Test/Simulatorstatus

## 2. Debug-UI-Inventar

| Fundstelle | Datei | normaler Flow | Harness | Maßnahme |
|---|---|---|---|---|

## 3. Routing vor/nach

- normaler RootVolumeView-Flow
- Debug-Harness
- genaue Trennung

## 4. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 5. Statische DEV-Suche nach Änderung

Alle verbleibenden Treffer klassifizieren.

## 6. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 7. Simulator-/Release-/Regressionstest

- normaler Debug-Build
- Release
- Debug-Harness
- regulärer Priority→Team-Flow
- Team-Symbole
- Punktekommunikation
- Replay

## 8. Vollständiger `024-Report.md`

Der Report muss ausdrücklich enthalten:

- tatsächlichen Gitstand
- tatsächlichen 023-Commit
- reale Testzahl
- ursprüngliche Fundstelle von `🔧 Team [DEV]`
- genaue Maßnahme
- Bestätigung: normaler Debug-Flow ohne DEV-Schaltfläche
- Bestätigung: Release ohne DEV-Schaltfläche
- Status des DebugInteractionHarness
- Bestätigung: Debugfunktion nur separat/explizit
- Bestätigung: Priorisierungslogik unverändert
- Bestätigung: Teamlogik unverändert
- Bestätigung: Team-Symbole unverändert
- vollständige verbleibende DEV-String-Fundstellen
- Build/Test/Simulatorstatus
- AK-29 PASS/OPEN/FAIL
- offene Risiken
- Empfehlung für **Modul 025 — Monster-Farbvarianten**

Baue nichts außerhalb dieses Moduls um.
