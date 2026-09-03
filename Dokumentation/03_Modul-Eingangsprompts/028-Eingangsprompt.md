# Modul-Eingangsprompt — 028 Teamlogos v1.3

> Vom **Projektlogbuch** nach Einarbeitung des `027-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 028.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**.

# Modul

**Nummer:** 028  
**Titel:** Teamlogos v1.3  
**Erfüllt:** F-28, F-39 / AK-28 sowie Teamlogo-Anteil von AK-39

**Ziel:** Ersetze in den vier bestehenden Teamstationen die historischen SF-Symbole aus v1.2 durch die vier bereitgestellten lokalen JPEG-Teamlogos. Die deutschen Teamtexte bleiben vollständig sichtbar. Die Logo-Integration darf weder sichtbare Panelgröße noch Drop-Bounds, Target-IDs, 50-%-Overlap, Z-Toleranz oder Teamlogik verändern. Die vier Logos werden sauber in einem gemeinsamen lokalen Ressourcenbereich abgelegt und ausschließlich über eine zentrale Zuordnung referenziert.

---

# Ausgangsstand

v1.0, v1.1 und v1.2 sind abgeschlossen.

v1.3 Modul 027 ist implementiert.

Laut `027-Report.md`:

- Branch `v1.3`
- finaler v1.2-Abschlusscommit `44430b7 feat: Modul 26`
- HEAD vor 027 `44430b7daeb8c6b53f1266cb9ac781e6c6330dd4`
- Modul-027-Commit im Report noch offen
- Tests vor 027: 365
- Tests nach 027: **372**
- Build/Test/Simulator: OPEN, weil im Ausführungsumfeld Xcode/Swift/visionOS-Simulator fehlten

AK-01, AK-02, AK-03, AK-04 und AK-22 sind laut Report auf Code-/Testebene erfüllt.

AK-31 bleibt bis zur Laufzeitprüfung OPEN.

---

# Vorab-Gate

## 1. Git

Ermittle real:

- Branch
- HEAD
- Working Tree
- tatsächlichen Modul-027-Commit

Wenn Modul 027 inzwischen committed ist:

- echten Hash dokumentieren.

Wenn 027 noch uncommitted ist:

- 027-Diff klar vom Modul-028-Diff trennen.
- keine 027-Dateien unnötig erneut bearbeiten.
- nach Möglichkeit Build/Test/Simulator-Nachprüfung von 027 vorziehen und separat dokumentieren.

Keine Hashes erfinden.

## 2. Reale Testzahl

Dokumentierter Ausgangswert:

**372 `@Test`-Deklarationen**

Im Repository real prüfen.

Bei Abweichung:

- reale Zahl verwenden,
- Ursache dokumentieren.

## 3. Teamlogo-Assetinventar

Suche vollständig im Repository und in bereitgestellten v1.3-Assetordnern nach:

- `.jpg`
- `.jpeg`
- möglichen Ordnern wie:
  - `teamslogos`
  - `Teamslogos`
  - `TeamLogos`
  - `Team Logos`
  - vergleichbaren v1.3-Assetordnern

**Exakte Dateinamen nicht erfinden.**

Erstelle vor Änderung:

| Team | gefundene Quelldatei | Format | Größe | Quelle | Status |
|---|---|---|---:|---|---|
| Netzwerk | | JPEG | | | |
| Konto | | JPEG | | | |
| Software | | JPEG | | | |
| Hardware | | JPEG | | | |

Es müssen genau vier fachlich zuordenbare bereitgestellte Teamlogos identifiziert werden.

Wenn ein Logo fehlt oder eine Zuordnung nicht eindeutig ist:

- nicht durch ein selbst erzeugtes Logo ersetzen,
- im Report OPEN dokumentieren.

---

# Verbindliche Anforderungen

## F-28 — Teamlogos

Jede Teamstation zeigt zusätzlich zur Textbezeichnung das bereitgestellte lokale JPEG-Teamlogo für:

- Netzwerk
- Konto
- Software
- Hardware

Der Text bleibt sichtbar.

Drop-Geometrie und Teamlogik werden durch das Logo nicht verändert.

## F-39 — Ressourcenstruktur und zentrale Zuordnung

Die bereitgestellten Teamlogos müssen:

- lokal gebündelt,
- klar strukturiert,
- zentral gemappt

werden.

Views dürfen keine verstreuten vollständigen Dateipfade enthalten.

Fachliche Teamlogik darf nicht von Ressourcenpfaden abhängen.

---

# AK-28

1. Jede der vier Teamstationen zeigt das korrekte bereitgestellte JPEG-Logo ihres Teams.
2. Die Texte bleiben vollständig sichtbar:
   - `Netzwerk`
   - `Konto`
   - `Software`
   - `Hardware`
3. Logos ersetzen die bisherigen SF-Symbole.
4. Logos verändern nicht:
   - sichtbare Zielgröße
   - Drop-Bounds
   - Drop-Auswertung
5. Ein fehlendes Logo verändert die fachliche Teamzuordnung nicht und wird robust behandelt.

---

# AK-39 — Teamlogo-Anteil

Für Modul 028 relevant:

- die vier JPEG-Teamlogos liegen gemeinsam in einem Teamlogo-Ressourcenbereich,
- Team→Logo-Zuordnung erfolgt zentral,
- `TeamAssignmentView` enthält keine verstreuten vollständigen Ressourcenpfade,
- ein späterer Release-/Simulator-Build muss die Logos lokal ohne Netzwerkzugriff finden.

Audio- und Video-Anteile von AK-39 gehören erst zu Modul 029/030.

---

# Bestehende Teamstationsarchitektur zuerst lesen

Mindestens vollständig prüfen:

- `Views/TeamAssignmentView.swift`
- `Services/TargetPanelFactory.swift`
- `Services/TargetPanelLayout.swift`
- `Components/DropTargetComponent.swift`
- `Services/DropEvaluator.swift`
- Definition von `TeamTargetMapping`
- aktuelle `TeamTargetMapping.Presentation`
- `SupportTeam`
- `Support/AppConstants.swift`
- Ressourcen-/Assetstruktur
- `Ticket_TamerTests/...`

Aus Modul 023 ist historisch bekannt:

```text
TeamTargetMapping
→ TargetDefinition
→ TargetPanelLayout
→ TargetPanelFactory
→ DropTargetComponent
→ ViewAttachmentEntity
```

Die sichtbare Beschriftung/Präsentation ist von der Drop-Geometrie getrennt.

Diese Trennung muss erhalten bleiben.

---

# Historische Symbole ersetzen

Aktueller v1.2-Stand enthält voraussichtlich:

- Netzwerk → `network`
- Konto → `person.crop.circle`
- Software → `macwindow`
- Hardware → `desktopcomputer`

Diese SF-Symbole sind für den aktuellen v1.3-Zielstand **abgelöst**.

Nach Modul 028:

- sichtbares JPEG-Logo statt SF Symbol,
- Teamtext bleibt.

Keine parallele Darstellung:

`JPEG + altes SF Symbol + Text`

sofern die SPEC nicht ausdrücklich eine solche Kombination fordert.

Ziel:

`JPEG + Text`.

---

# Ziel-Ressourcenstruktur

Bevorzuge den bestehenden App-Ressourcenbereich:

```text
Ticket_Tamer/Ticket_Tamer/Resources/
└── TeamLogos/
    ├── <reale Netzwerk-Datei>.jpg
    ├── <reale Konto-Datei>.jpg
    ├── <reale Software-Datei>.jpg
    └── <reale Hardware-Datei>.jpg
```

Falls das reale Xcode-Projekt bereits eine gleichwertige zentral eingebundene Assetstruktur besitzt, darf diese verwendet werden.

Wichtig:

- alle vier Logos gemeinsam,
- lokale Ressourcen,
- keine Netzwerk-URL,
- keine verstreuten Kopien,
- keine Dubletten ohne Zweck.

Prüfe Target-/Bundle-Einbindung.

---

# Zentrale Team→Logo-Zuordnung

Nicht in `TeamAssignmentView` viermal hart codieren.

Bevorzuge eine kleine zentrale Darstellungs-/Assetstruktur.

Beispielhaft, nicht zwingend exakt:

```text
struct TeamLogoResource {
    let team: SupportTeam
    let resourceName: String
    let fileExtension: String
}
```

oder:

```text
enum TeamLogoCatalog {
    static func resource(for team: SupportTeam) -> ...
}
```

oder die vorhandene:

`TeamTargetMapping.Presentation`

so erweitern, dass sie statt `systemImageName` einen zentralen Logoressourcenschlüssel trägt.

Verbindlich:

- fachliches `SupportTeam` bleibt unverändert,
- keine Dateipfade in `SessionModel`,
- keine Dateipfade in `DropTargetComponent`,
- keine Dateipfade in `TargetPanelLayout`,
- keine Teamlogik abhängig vom Vorhandensein eines Bildes.

---

# Darstellung

Die vier Teamstationen sollen weiterhin eindeutig lesbar sein.

Bevorzugte Struktur je Attachment:

```text
[ Logo ]  Netzwerk
```

oder, wenn es im realen Panel besser passt:

```text
[ Logo ]
Netzwerk
```

Aber:

**Außenmaße des Panels bleiben unverändert.**

Die Logoanzeige muss sich in die bestehende innere Label-/Attachmentfläche einpassen.

Geeignete Maßnahmen:

- `scaledToFit`
- definierte maximale Logo-Innenfläche
- `clipped` nur wenn nötig und ohne relevante Logoanteile abzuschneiden
- ausreichend Abstand zum Text

Nicht:

- Panelmesh größer machen
- Targetpositionen verschieben
- Dropdown-/Dropbounds an Logoabmessungen koppeln

---

# JPEG-Seitenverhältnis schützen

Die bereitgestellten Logos dürfen nicht verzerrt werden.

Prüfe:

- originales Seitenverhältnis,
- kein Stretch auf feste Breite+Höhe mit falschem Verhältnis,
- keine sichtbare Pixelverzerrung.

Wenn Logos unterschiedlich proportioniert sind:

- gleiche maximale Innenbox,
- `scaledToFit`.

Keine Bildbearbeitung der Quelldateien, sofern nicht zwingend nötig.

---

# Fehlendes Logo robust behandeln

AK-28 verlangt:

Ein fehlendes Logo darf die Teamzuordnung nicht verändern.

Deshalb:

- Teamtext bleibt sichtbar,
- Dropziel bleibt vorhanden,
- Team-ID bleibt vorhanden,
- Drop-Bounds bleiben vorhanden.

Wenn eine Ressource nicht geladen werden kann:

bevorzuge einen robusten visuellen Fallback wie:

- Text-only Teamstation,
- optional neutrales nicht-fachliches Platzhaltersymbol,

und logge den Ressourcenfehler.

Nicht:

- Zielstation entfernen,
- Team deaktivieren,
- anderes Teamlogo verwenden,
- Crash erzwingen.

---

# DebugManager

Nutze bestehende Kategorie:

`.spawning` oder `.state`

für einmalige Ressourcenbefunde, falls nötig.

Beispiele:

- Teamlogo gefunden
- Teamlogo fehlt
- Fallback verwendet

Keine neue Kategorie nötig.

Kein Log pro Renderframe.

---

# Geometrieschutz — besonders wichtig

Aus Modul 023 wurde für eine Referenzgeometrie dokumentiert:

- Panelbreite `0.195 m`
- Panelhöhe `0.117 m`
- Paneltiefe `0.020 m`
- `minimumDropOverlapRatio = 0.50`
- `dropDepthTolerance = 0.05 m`

Die reale Implementierung bleibt dynamisch, aber das Prinzip ist verbindlich:

**Logo beeinflusst niemals die physische Zielgeometrie.**

Vorher/Nachher dokumentieren:

| Wert | vor Modul 028 | nach Modul 028 |
|---|---:|---:|
| Panelbreite | | |
| Panelhöhe | | |
| Paneltiefe | | |
| Targetpositionen | | |
| Drop halfExtents | | |
| Overlap-Schwelle | | |
| Z-Toleranz | | |

Erwartung:

identisch innerhalb Floating-Toleranz.

---

# Nicht ändern

Unverändert bleiben müssen:

- `TargetPanelLayout`
- `TargetPanelFactory`, soweit kein rein visueller Material-/Attachmentgrund vorliegt
- `DropTargetComponent`
- `DropEvaluator`
- `minimumDropOverlapRatio`
- `dropDepthTolerance`
- `TeamTargetMapping`-fachliche IDs
- `SupportTeam`
- `saveTeam`
- `evaluateTeam`
- Input-Lock
- Exactly-once
- Snapback
- Team-Monsterdrag

Wenn du eine Datei wie `TargetPanelFactory` berührst, muss der Report ausdrücklich erklären, warum die Änderung rein visuell ist.

---

# Schutz Modul 027

Nicht verändern:

- TT-001 bis TT-016
- neue Tickettexte
- Referenzmatrix
- `videoAssetName`
- 1...16-Steuerung
- Standard/Reset 6
- Monsterzuordnung
- Variantenmapping

Die zusätzliche Datei `TT-002A.mp4` ist keine produktive Ticketreferenz und gehört nicht zu Modul 028.

---

# Schutz Module 021–025

Nicht verändern:

- Replay-Root
- Punktekommunikation
- `0 Punkte` / `+100 Punkte`
- Debug-UI-Isolation
- Monster-Farbvariantenauswahl
- Monster-Retry

---

# Keine Scope-Ausweitung

Nicht implementieren:

## Modul 029
- keine neuen Monster-Sounds
- keine Streak-Sounds
- keine Audiozufallsauswahl

## Modul 030
- keine Videoansicht
- kein AVKit
- keine Video-Fehlerbehandlung

## Modul 031
- kein Streak-State
- kein Multiplikator-Scoring

## Modul 032
- kein x2/x3/x4+-Feedback

---

# Automatisierte Tests

Ausgangswert laut 027-Report:

**372 Testdeklarationen**

Reale Zahl im Preflight prüfen.

Ergänze mindestens Tests für:

## Logo-Katalog

1. genau vier Teamlogo-Zuordnungen.
2. Netzwerk besitzt eine nicht leere JPEG-Ressourcenreferenz.
3. Konto besitzt eine nicht leere JPEG-Ressourcenreferenz.
4. Software besitzt eine nicht leere JPEG-Ressourcenreferenz.
5. Hardware besitzt eine nicht leere JPEG-Ressourcenreferenz.
6. alle vier Ressourcenreferenzen eindeutig.
7. alle vier Dateiendungen JPEG/JPG.
8. keine HTTP-/HTTPS-Pfade.
9. keine absoluten Entwicklerpfade.

## Teamdarstellung

10. Netzwerk-Text bleibt `Netzwerk`.
11. Konto-Text bleibt `Konto`.
12. Software-Text bleibt `Software`.
13. Hardware-Text bleibt `Hardware`.
14. historische SF-Symbolnamen werden für die produktive Teamstation nicht mehr benötigt.
15. Präsentationsmapping benötigt keine Referenzpriorität.
16. Präsentationsmapping benötigt kein Ticket.
17. Präsentationsmapping benötigt keinen Score.

## Geometrie

18. Team-Target-IDs unverändert.
19. Panelbreite bei identischer Referenzgeometry unverändert.
20. Panelhöhe unverändert.
21. Paneltiefe unverändert.
22. Targetpositionen unverändert.
23. Drop-halfExtents unverändert.
24. `minimumDropOverlapRatio == 0.50` unverändert.
25. `dropDepthTolerance == 0.05` unverändert.

## Fallback

26. fehlende Logo-Ressource verändert das gemappte `SupportTeam` nicht.
27. fehlende Logo-Ressource entfernt das Ziel nicht.
28. Fallback liefert weiterhin Teamtext.
29. Fallback verändert keine Dropgeometrie.

Keine Architektur nur für Tests aufblasen.

---

# Asset-/Bundle-Prüfung

Für jedes Logo dokumentieren:

| Team | Datei | Ressourcenpfad | Bundle gefunden | JPEG validiert |
|---|---|---|---|---|
| Netzwerk | | | | |
| Konto | | | | |
| Software | | | | |
| Hardware | | | | |

Prüfe, soweit in der Umgebung möglich:

- Dateisignatur/Format,
- eindeutige Dateien,
- keine 0-Byte-Dateien,
- Xcode-/Target-Einbindung,
- lokale Bundle-Auffindbarkeit.

Falls Xcode nicht verfügbar:

- statisch prüfen,
- Runtime als OPEN markieren.

---

# Simulatorprüfung

## Vier Teamstationen

Prüfe:

- korrektes Netzwerk-Logo + `Netzwerk`
- korrektes Konto-Logo + `Konto`
- korrektes Software-Logo + `Software`
- korrektes Hardware-Logo + `Hardware`

## Lesbarkeit

- keine Textabschnitte abgeschnitten,
- Logo vollständig erkennbar,
- Seitenverhältnis korrekt,
- kein Überlappen Logo/Text,
- alle vier Stationen klar unterscheidbar.

## Blickwinkel

Mindestens:

- frontal,
- leicht links,
- leicht rechts,
- leicht oben.

## Drag/Drop-Regression

Für alle vier Ziele:

- Monster draggen,
- gültiger Drop speichert weiterhin exakt das gewählte Team,
- ungültiger Drop → Snapback,
- Exactly-once unverändert.

## Geometrie

Vorher/Nachher prüfen:

- sichtbare Panelbox gleich,
- Dropbox gleich,
- Targetpositionen gleich.

## Fehlendes-Logo-Test

Kontrolliert eine Logoressource nicht auflösbar machen, ohne produktive Dateien dauerhaft zu beschädigen.

Prüfe:

- App stürzt nicht ab,
- Teamtext bleibt,
- Ziel bleibt interaktiv,
- fachliche Teamzuordnung funktioniert.

Wenn eine sichere Laufzeitinjektion dafür nicht existiert, einen kleinen testbaren Resource-Lookup/Fallback verwenden; keine produktive Datei absichtlich löschen.

---

# v1.3-/v1.2-Regression

Kurz prüfen:

- 16 Tickets aus Modul 027 weiterhin vorhanden,
- Slider bis 16,
- Replay stabil,
- Punktefeedback korrekt,
- DEV-Shortcut fehlt,
- Monsterfarben stabil,
- Teamdrag unverändert.

---

# Voraussichtlich relevante Dateien

Zuerst real bestimmen.

Wahrscheinlich:

- `Views/TeamAssignmentView.swift`
- Definition von `TeamTargetMapping.Presentation`
- neue kleine Ressourcenzuordnung, z. B. unter:
  - `Assets/`
  - `Support/`
  - oder `Services/`
- `Resources/TeamLogos/*.jpg`
- Tests

Nur falls wirklich erforderlich:

- `Support/AppConstants.swift`

Nach Möglichkeit unverändert:

- `SessionModel.swift`
- `LocalTicketCatalog.swift`
- `Ticket.swift`
- `TargetPanelLayout.swift`
- `DropEvaluator.swift`
- `DropTargetComponent.swift`
- `ResultView.swift`
- `DecisionFeedbackView.swift`
- `AudioService.swift`
- Monster-Loader/VariantCatalog
- Video-Datenreferenzen

---

# Git

Vor Modul 028:

Modul 027 separat committen, wenn noch offen.

Vorgesehen:

`027: Neue Ticketdaten und 16er-Sitzung`

Modul 028:

`028: Teamlogos v1.3`

Keine Hashes erfinden.

Vor Commit 028:

- Build, wenn Xcode verfügbar
- vollständige Tests
- Logo-Bundleprüfung
- Simulatorprüfung
- Geometrie-Vorher/Nachher
- `git diff --check`
- Scope-Diff

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 027-Commit
- Working Tree
- reale Testzahl
- Build/Test/Simulatorstatus

## 2. Logo-Inventar

| Team | Quelldatei | Format | Abmessungen/Dateigröße | Zielpfad |
|---|---|---|---|---|

## 3. Teamlogo-Architektur

- zentrale Mappingstruktur
- Bundle-/Resource-Lookup
- Fallback
- Accessibility
- warum keine fachliche Kopplung entsteht

## 4. Vorher/Nachher Teamstation

| Team | vorher | nachher | Text bleibt |
|---|---|---|---|
| Netzwerk | SF Symbol | JPEG | ja |
| Konto | SF Symbol | JPEG | ja |
| Software | SF Symbol | JPEG | ja |
| Hardware | SF Symbol | JPEG | ja |

## 5. Geometrieschutz

| Wert | vorher | nachher |
|---|---|---|
| Panelbreite | | |
| Panelhöhe | | |
| Paneltiefe | | |
| Targetpositionen | | |
| Drop halfExtents | | |
| Overlap | 0.50 | |
| Z-Toleranz | 0.05 | |

## 6. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 7. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 8. Simulator-/Regressionstest

- vier Logos
- vier Texte
- Blickwinkel
- Drag auf alle vier Ziele
- Invalid Drop/Snapback
- fehlendes Logo/Fallback
- Geometrie
- Modul-027-Regression

## 9. Vollständiger `028-Report.md`

Der Report muss ausdrücklich enthalten:

- realen Gitstand
- tatsächlichen 027-Commit
- reale Testzahl
- exakte vier bereitgestellte JPEG-Dateinamen
- ursprüngliche Quellpfade
- finale produktive Zielpfade
- Team→Logo-Mapping
- Bestätigung: alte SF-Symbole in der produktiven Teamstation ersetzt
- Bestätigung: Teamtexte bleiben sichtbar
- Bestätigung: Panelgröße unverändert
- Bestätigung: Drop-Bounds unverändert
- Bestätigung: DropEvaluator unverändert
- Bestätigung: 50-%-Overlap unverändert
- Bestätigung: Z-Toleranz unverändert
- Verhalten bei fehlendem Logo
- AK-28 PASS/OPEN/FAIL
- AK-39 Teamlogo-Anteil PASS/OPEN/FAIL
- Build/Test/Simulatorstatus
- offene Risiken
- Empfehlung für **Modul 029 — Monster- und Streak-Audio**

Baue nichts außerhalb dieses Moduls um.
