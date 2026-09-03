# Modul-Eingangsprompt — 025 Monster-Farbvarianten

> Vom **Projektlogbuch** nach Einarbeitung des `024-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 025.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**.

# Modul

**Nummer:** 025  
**Titel:** Monster-Farbvarianten  
**Erfüllt:** F-30 / AK-30

**Ziel:** Mache alle 16 bereits vorhandenen Monster-Farbvarianten produktiv nutzbar. Für jedes Sitzungsticket wird beim Sitzungsstart genau eine konkrete Variante seines vorhandenen Monstertyps ausgewählt und während Untersuchung, Priorisierung, Teamzuordnung und `Erneut laden` stabil beibehalten. Eine neue Sitzung darf neu auswählen. Die Auswahl muss deterministisch testbar sein und darf weder Team noch Priorität codieren.

---

# Ausgangsstand

v1.0 und v1.1 sind abgeschlossen.

v1.2:

- 021 Replay-Layoutstabilisierung implementiert, AK-25 Laufzeit OPEN
- 022 Punktekommunikation implementiert, AK-26/27 Laufzeit OPEN
- 023 Teamstation-Symbole implementiert, AK-28 Laufzeit OPEN
- 024 Debug-UI-Isolation implementiert, AK-29 Laufzeit OPEN

Laut 024-Report:

- Branch `A`
- HEAD vor 024 `4ced478 feat: Modul 23`
- tatsächlicher 023-Commit `4ced478`
- Modul-024-Commit offen
- **333 Testdeklarationen**
- Build/Test/Simulator offen

---

# Vorab-Gate

## 1. Git

Ermittle real:

- aktuellen Branch
- HEAD
- Working Tree
- tatsächlichen Modul-024-Commit

Wenn Modul 024 noch uncommitted:

- 024-Diff klar identifizieren
- nach Möglichkeit Build, vollständige Tests und Debug-/Release-/Simulatorprüfung durchführen
- 024 separat committen
- 025 nicht mit 024 vermischen

Keine Hashes erfinden.

## 2. Reale Testzahl

Dokumentierter Ausgangswert:

**333**

Im Repository real prüfen.

Bei Abweichung:

- reale Zahl verwenden
- Ursache dokumentieren

## 3. Alle vorhandenen Monsterassets inventarisieren

Bevor du Code änderst, suche vollständig in:

- `RealityKitContent`
- produktiver Ressourcenstruktur
- `MonsterAssets`
- bestehenden USDA/USDC/USDZ-Dateien
- `Assets/MonsterAssetProvider.swift`
- `Support/AppConstants.swift`
- Ticketkatalog / Monster-Type-Mapping

Erstelle im Report eine vollständige Tabelle:

| Monstertyp | Variante | exakter Dateiname | produktive Ressource? | ladbar? |
|---|---|---|---|---|

Es müssen am Ende **16 konkrete produktiv ladbare Assets** vorhanden sein.

---

# F-30 — 16 Monster-Farbvarianten

Das System kann alle 16 vorhandenen Monster-Farbvarianten laden. Für jedes Sitzungsticket wird beim Sitzungsstart eine Variante seines Monstertyps ausgewählt und für Untersuchung, Priorisierung, Teamzuordnung sowie Retry stabil beibehalten. Eine neue Sitzung darf neu auswählen; die Farbe codiert weder Priorität noch Team noch Richtigkeit.

# AK-30 — verbindliche Abnahme

1. Vier Monstertypen × vier Varianten = **16 ladbare Monsterassets**.
2. Für jeden Monstertyp lassen sich alle vier real vorhandenen Dateien laden und darstellen.
3. Beim Start einer neuen Sitzung erhält jedes ausgewählte Ticket genau eine konkrete Variante seines Monstertyps.
4. Ein Ticket behält dieselbe Assetdatei/Farbvariante in:
   - Untersuchung
   - Priorisierung
   - Teamzuordnung
5. `Erneut laden` lädt exakt dieselbe zuvor ausgewählte Variante erneut.
6. `Erneut spielen` startet eine neue Sitzung; gegenüber vorher dürfen andere Varianten gewählt werden.
7. Farbe darf keinen festen Rückschluss auf:
   - Priorität
   - Team
   erlauben.
8. Mit allen 16 Varianten funktionieren unverändert:
   - Skalierung
   - Blender-Ausrichtungskorrektur
   - Kollision
   - Drag-Grenzen
   - Snapback
   - Drop-Auswertung
9. Mit injizierter deterministischer Auswahlfunktion muss exakt die vorgegebene Variante gespeichert und reproduzierbar sein.
10. `reset()` verwirft Varianten-Zuordnungen der vorherigen Sitzung.

---

# Wichtiger Asset-Bestandshinweis

Die SPEC nennt ausdrücklich:

- Monstertyp 3 besitzt laut Bestandsanalyse die Varianten:
  - `blue`
  - `green`
  - `pink`
  - `yellow`

- die übrigen Typen besitzen:
  - `blue`
  - `green`
  - `pink`
  - `red`

**Aber:** Die konkreten Dateinamen müssen im echten Repository ermittelt werden.

Nicht einfach Dateinamen aus:

```text
Monster_3_red
```

oder anderen angenommenen Mustern konstruieren.

Es wird ein **explizites Mapping tatsächlicher Dateinamen** verlangt.

---

# Produktive Ressourcenquelle

Die 16 Dateien müssen in der produktiv eingebundenen lokalen RealityKitContent-Ressourcenquelle liegen.

Die SPEC verlangt sinngemäß:

`RealityKitContent/MonsterAssets`

oder die tatsächlich im Projekt verwendete entsprechende produktive Resource-Struktur.

Der Root-Ordner `Monster/` allein genügt nicht, wenn er nicht als Build-Ressource eingebunden ist.

Prüfe:

- Target Membership / Package Resource Inclusion
- reale Loader-Pfade
- Bundle-/RealityKitContent-Verfügbarkeit

Keine Netzwerkquelle.

---

# Bestehenden Monstertyp erhalten

Tickets besitzen bereits eine neutrale Zuordnung zu einem Monstertyp / bisherigen `monsterAssetId`.

Modul 025 darf diese fachliche Typzuordnung nicht neu würfeln.

Beispiel:

```text
Ticket TT001 → monster01
```

bleibt Typ `monster01`.

Neu gewählt wird nur eine der vier Farbvarianten dieses Typs.

Nicht:

```text
TT001 wechselt zufällig von monster01 zu monster04
```

---

# Neue Datenstruktur

Führe eine kleine, klare Variantenrepräsentation ein.

Sinngemäß:

```swift
struct MonsterAssetVariant: Equatable, Hashable {
    let monsterTypeId: String
    let variantKey: String
    let assetFileName: String
}
```

Die exakte Form darf zum realen Projekt passen.

Wichtig:

- expliziter Dateiname
- expliziter Monstertyp
- Variantenschlüssel
- keine Team-/Prioritätsinformation

---

# Explizites Variantenmapping

Bevorzuge einen zentralen Katalog, z. B. im `MonsterAssetProvider` oder einer kleinen Asset-Katalogstruktur:

```text
monster01 → [vier konkrete Varianten]
monster02 → [vier konkrete Varianten]
monster03 → [vier konkrete Varianten]
monster04 → [vier konkrete Varianten]
```

Genau vier pro Typ.

Keine dynamische Dateinamenskonstruktion aus einem Farbnamen.

Tests müssen exakt 4/4/4/4 nachweisen.

---

# Sitzungsbezogener Zustand

Die konkrete ausgewählte Variante ist **sitzungsbezogener Zustand**.

Geeignete Form sinngemäß:

```text
selectedMonsterVariantByTicketID:
[Ticket.ID: MonsterAssetVariant]
```

Sie darf im `SessionModel` liegen, weil die Auswahl für den Lebenszyklus der Sitzung stabil sein muss.

Alternativ kleine eindeutig sitzungsbezogene Struktur, falls bestehende Architektur dies sauberer abbildet.

Nicht:

- View-lokal neu würfeln
- global persistent
- AppStorage
- UserDefaults
- Datenbank

---

# Auswahlzeitpunkt

Die Varianten werden genau beim Aufbau einer **neuen Sitzung** ausgewählt.

Sinngemäß in:

`startSession()`

Ablauf:

```text
Tickets auswählen
→ für jedes ausgewählte Ticket dessen Monstertyp bestimmen
→ genau eine Variante dieses Typs auswählen
→ Zuordnung unter Ticket-ID speichern
```

Nicht erst in:

- InvestigationView.onAppear
- PrioritizationView.task
- TeamAssignmentView.task
- Retry

würfeln.

---

# Auswahlfunktion deterministisch testbar

Die Auswahl muss injizierbar sein.

Bevorzuge eine kleine Closure/Funktion, sinngemäß:

```text
variantSelector:
([MonsterAssetVariant]) -> MonsterAssetVariant
```

Produktiv:

- zufällige Auswahl

Test:

- vorgegebene deterministische Auswahl

Keine globale Zufallsquelle schwer mockbar machen.

Keine komplexe DI-Architektur.

---

# Exakt eine Variante pro Sitzungsticket

Nach `startSession()`:

Für jedes `sessionTicket`:

```text
selectedMonsterVariantByTicketID[ticket.id] != nil
```

Und genau eine.

Keine zweite parallele Map.

Kein Lazy-Neuwürfeln.

---

# Lookup für Views

Stelle eine klare Schnittstelle bereit, sinngemäß:

```text
selectedMonsterVariant(for ticket: Ticket) -> MonsterAssetVariant?
```

oder:

```text
selectedMonsterAssetName(for ticket: Ticket) -> String?
```

Views sollen nicht selbst zufällig auswählen.

Sie fragen nur:

**Welche Variante wurde für dieses Ticket bereits gespeichert?**

---

# Untersuchung

Monsterloading verwendet nicht mehr pauschal nur den Typnamen, sondern die gespeicherte konkrete Varianten-Assetdatei.

Das aktive Ticket muss dieselbe gespeicherte Variante laden.

Keine neue Auswahl beim Erscheinen.

---

# Priorisierung

Dasselbe Ticket lädt exakt dieselbe konkrete Assetdatei wie Untersuchung.

Nicht erneut zufällig auswählen.

Monster-Scaling, Interaktionskonfiguration und Dropgeometrie bleiben unverändert.

---

# Teamzuordnung

Dasselbe Ticket lädt exakt dieselbe konkrete Assetdatei wie Untersuchung und Priorisierung.

Keine neue Auswahl.

---

# Retry aus Modul 019

Besonders wichtig:

`Erneut laden`

muss exakt dieselbe Variante erneut laden.

Nicht:

- neue Variantenauswahl
- Fallback auf Basismonster
- neue Farbe

Retry verwendet den gespeicherten Variantennamen des aktuellen Tickets.

`MonsterLoadRecovery.requestedAssetID` beziehungsweise reale aktuelle Lade-ID muss die konkrete Variante repräsentieren.

---

# Reset

`SessionModel.reset()`

muss zusätzlich:

```text
selectedMonsterVariantByTicketID = [:]
```

beziehungsweise semantisch gleichwertig ausführen.

Nach Reset:

- keine alten Varianten-Zuordnungen.

Neue Sitzung:

- neue Auswahl zulässig.

---

# Erneut spielen

`Erneut spielen`:

1. fachlicher Reset
2. zurück zur Startansicht
3. neue Sitzung später über `Spiel starten`
4. Varianten werden neu gewählt

Nicht beim bloßen Zurückkehren zur Startansicht bereits Varianten erzeugen.

---

# Keine Farb-Codierung

Variantenwahl muss unabhängig sein von:

- `referencePriority`
- `referenceTeam`
- selectedPriority
- selectedTeam
- richtig/falsch
- Score

Nicht:

```text
kritisch → rot
Netzwerk → blau
```

oder ähnliche feste Regeln.

---

# AssetProvider

Prüfe reale aktuelle API.

Historisch:

```text
MonsterAssetProvider.loadMonster(assetID:)
```

Modul 025 darf die API so erweitern/anpassen, dass konkrete Variantendateien geladen werden.

Bevorzuge klare Trennung:

```text
monster type
→ VariantCatalog
→ konkrete assetFileName
→ loadMonster(...)
```

Nicht neue Loader pro Farbe.

---

# Skalierungs-/Ausrichtungsschutz

Alle 16 Varianten müssen dieselbe bestehende Pipeline durchlaufen:

- Y-up-/Blender-Ausrichtungskorrektur
- `fit(toMaxExtent:)`
- Collision/Interaction setup
- Scale
- DragBounds
- Snapback
- DropEvaluator

Keine Variante erhält phasenspezifische Sonderkorrektur ohne echten Assetgrund.

Falls einzelne Varianten unterschiedliche Rohbounds haben:

- bestehendes `fit(...)` muss sie normalisieren
- im Report reale Maße dokumentieren

---

# Keine Änderung an Scoring/Gameplay

Nicht verändern:

- Ticketreferenzwerte
- Prioritätslogik
- Teamlogik
- Scoring
- Audio
- Exactly-once
- Feedback
- 50-%-Overlap
- Z-Toleranz
- Snapback
- ResultView
- Replay-Root
- Debug-UI-Isolation

---

# Schutz der Module 021–024

## 021
Replay-Root unangetastet.

## 022
`X Punkte`, `0 Punkte`, `+100 Punkte` unverändert.

## 023
Team-Symbole und Panelgeometrie unverändert.

## 024
Kein neuer produktiver DEV-Shortcut.

---

# Automatisierte Tests

Ausgangswert laut 024-Report:

**333 Testdeklarationen**

Reale Zahl im Preflight prüfen.

Ergänze mindestens Tests für:

## Assetkatalog

1. exakt 4 Monstertypen.
2. jeder Typ exakt 4 Varianten.
3. insgesamt exakt 16 Varianten.
4. alle 16 `assetFileName` nicht leer.
5. alle 16 produktiven Dateinamen eindeutig.
6. monster03 besitzt laut realem Bestand seine vier tatsächlichen Varianten inklusive `yellow`.
7. keine pauschale Annahme, dass jeder Typ `red` besitzt.

## Sitzungswahl

8. jedes sessionTicket erhält genau eine Variante.
9. Variante gehört zum Monstertyp des Tickets.
10. deterministische Selector-Closure wählt exakt vorgegebene Variante.
11. gleiche Session liefert bei drei Lookups dieselbe Variante.
12. Investigation/Priority/Team-Lookup liefert denselben Assetnamen.
13. Retry-Lookup liefert denselben Assetnamen.
14. neue Sitzung darf neu auswählen.
15. Reset leert Variantenmapping.

## Neutralität

16. Auswahl benötigt keine Referenzpriorität.
17. Auswahl benötigt kein Referenzteam.
18. gleicher Monstertyp kann bei unterschiedlichen Tickets verschiedene Farben haben.
19. gleiche Farbe kann bei unterschiedlichen Team-/Prioritätskombinationen vorkommen.
20. keine Score-/Feedbackabhängigkeit.

## Loader

21. alle vier Varianten Typ 1 katalogisiert.
22. alle vier Typ 2.
23. alle vier Typ 3.
24. alle vier Typ 4.
25. unbekannter Monstertyp wird defensiv behandelt.
26. fehlendes Variant-Mapping führt nicht zu stiller Neuauswahl mitten in einer Sitzung.

## Reset/Retry

27. Retry würfelt nicht neu.
28. mehrfacher Retry bleibt gleiche konkrete Asset-ID.
29. Reset löscht alle Zuordnungen.
30. Start einer neuen Sitzung erzeugt Zuordnungen nur für deren Tickets.

Wenn praktikabel zusätzliche Asset-Ladeintegrationstests.

Keine Test-Ticketdaten mit kaputten produktiven Asset-IDs in den echten Katalog einbauen.

---

# Simulator-/Assetprüfung

## Alle 16 Varianten erzwingen

Für jeden Monstertyp jede Variante kontrolliert laden.

Tabelle:

| Typ | Variante | geladen | sichtbar | Fit | Kollision | Drag |
|---|---|---|---|---|---|---|

Alle 16 müssen erfolgreich sein.

## Sitzungskonsistenz

Ein Ticket:

1. Untersuchung → Variante notieren
2. Priorisierung → exakt gleiche Datei
3. Team → exakt gleiche Datei
4. Ladefehler provozieren
5. `Erneut laden` → exakt gleiche Datei

## Neue Sitzung

Nach `Erneut spielen` + neuem `Spiel starten`:

- neue Varianten dürfen auftreten
- müssen aber nicht zwingend bei jedem Ticket anders sein, da Zufall

Nicht als Fehler werten, wenn zufällig dieselbe Variante erneut gewählt wird.

## Reset

Nach Reset:

- altes Mapping leer
- keine alte Variantenzuordnung übernommen

## Drag-/Drop-Regression

Mit allen 16 Varianten soweit praktikabel prüfen:

- Monster vollständig sichtbar
- Focus/Pinch/Drag
- DragBounds
- Snapback
- 50-%-Drop
- Team-/Prioritätsziele

Mindestens automatisiert/strukturell alle 16 durch die identische Fit-/Interaction-Pipeline führen.

---

# Assetdateien und Build-Ressourcen

Prüfe explizit:

- liegen alle 16 in produktiver RealityKitContent-Ressource?
- sind sie im Package/Target enthalten?
- lädt Release dieselben Ressourcen?
- keine Datei nur im Arbeitsordner ohne Build-Einbindung?

Falls Dateien verschoben/kopiert werden müssen:

- exakte Quelle
- exaktes Ziel
- warum
- keine Duplikate im produktiven Bundle

dokumentieren.

---

# Harte Modulgrenze

Modul 025 bearbeitet ausschließlich F-30 / AK-30.

Nicht implementieren:

- Gesamtintegration 026
- neue Monsteranimationen
- neue Farbwahlauswahl durch Nutzer
- Farbsettings
- persistente Lieblingsfarben
- zusätzliche Monster-Typen
- neue Spielmodi

---

# Voraussichtlich relevante Dateien

Wahrscheinlich:

- `Assets/MonsterAssetProvider.swift`
- neue/erweiterte Varianten-Katalogstruktur
- `Models/SessionModel.swift`
- `Views/InvestigationView.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Services/MonsterLoadRecovery.swift`
- `Support/AppConstants.swift` nur falls AssetKeys dort liegen
- `Ticket_TamerTests/Ticket_TamerTests.swift`
- `RealityKitContent/.../MonsterAssets/...`

Nur ändern, wenn real erforderlich.

Nach Möglichkeit unverändert:

- RootVolumeView
- StartView
- ResultView
- DecisionFeedbackView
- TeamTargetMapping/Drop-Geometrie
- DebugInteractionHarnessView
- Scoring/Audio

---

# DebugManager

Keine neue Kategorie nötig.

Bestehende `.spawning` nutzen für:

- ausgewählte Variante
- konkrete Assetdatei laden
- Retry derselben Variante

Keine Referenzpriorität/-team loggen.

Kein Render-Spam.

---

# Git

Vor Modul 025:

Modul 024 separat committen, sobald seine Abnahme möglich ist.

Vorgesehen:

`024: Debug-UI-Isolation`

Modul 025:

`025: Monster-Farbvarianten`

Vor Commit:

- Build
- vollständige Tests
- alle 16 Assets prüfen
- Sitzungs-/Retry-Stabilität
- Reset
- `git diff --check`
- Scope-Diff

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 024-Commit
- Working Tree
- reale Testzahl
- Build/Test/Simulatorstatus

## 2. Asset-Inventar

| Typ | Variante | Dateiname | Ressource | Ladbar |
|---|---|---|---|---|

Alle 16.

## 3. Variantenarchitektur

- `MonsterAssetVariant`
- expliziter Katalog
- sitzungsbezogenes Mapping
- injizierbarer Selector
- Lookup
- Reset

## 4. Datenfluss

```text
startSession
→ Ticket
→ Monstertyp
→ Variante wählen
→ speichern
→ Investigation
→ Priority
→ Team
→ Retry
```

## 5. Schutz der Gameplaylogik

Explizit bestätigen:

- keine Team-/Prioritätscodierung
- Scoring unverändert
- Drop unverändert
- Exactly-once unverändert
- Retry würfelt nicht neu

## 6. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 7. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 8. Simulator-/Assetabnahme

- alle 16 laden
- drei Phasen gleiche Variante
- Retry gleiche Variante
- neue Sitzung darf neu wählen
- Reset
- Drag/Drop

## 9. Vollständiger `025-Report.md`

Der Report muss ausdrücklich enthalten:

- tatsächlichen Gitstand
- tatsächlichen 024-Commit
- reale Testzahl
- vollständige Liste aller 16 realen Dateinamen
- Bestätigung 4 Varianten pro Typ
- finale Varianten-Datenstruktur
- finale Selector-Schnittstelle
- Bestätigung: Auswahl einmal pro Sitzungsticket
- Bestätigung: Untersuchung/Priorisierung/Team identische Variante
- Bestätigung: Retry identische Variante
- Bestätigung: neue Sitzung darf neu wählen
- Bestätigung: Reset leert Mapping
- Bestätigung: keine Team-/Prioritätscodierung
- Bestätigung: alle 16 durch gleiche Fit-/Collision-/Drag-Pipeline
- Build/Test/Simulatorstatus
- AK-30 PASS/OPEN/FAIL
- offene Risiken
- Empfehlung für **Modul 026 — Integration und Abnahme v1.2**

Baue nichts außerhalb dieses Moduls um.
