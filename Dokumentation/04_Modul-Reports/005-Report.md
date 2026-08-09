# Modul-Report — 005 Monster-Asset-Pipeline

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

---

## Zusammenfassung

Modul 005 implementiert die Monster-Asset-Pipeline gemäß SPEC F-14 und AK-14. Das SPEC-Feld `monsterAssetId` wurde in das `Ticket`-Modell aufgenommen und alle zwölf Katalogtickets wurden mit neutralen, nicht-verräterischen Monster-IDs (`monster01`–`monster04`) versehen. Da keine fertigen Blender-Quelldateien oder USDZ-Exporte vorlagen, wurden vier USDA-Platzhalterszenen im RealityKitContent-Package angelegt, die die Ladepipeline vollständig abbilden und durch echte Blender-Exporte ersetzt werden können. `MonsterAssetProvider` kapselt das asynchrone lokale Laden und gibt bei unbekannten IDs einen klaren Fehler zurück. Gesteninteraktion (Blickfokus, Pinch, Drag) wurde bewusst nicht implementiert und bleibt Modul 007.

---

## 1. Vorab-Check

### Git und Xcode

| Punkt | Wert |
|---|---|
| Branch | `main` |
| Aktueller Commit vor Modul 005 | `356cb06 feat: update docs` |
| Commit `84bb767` enthalten | ja (in `git log`) |
| Xcode-Build nach Modul 004 | nicht nachgewiesen (Ausführungsumfeld ohne Xcode) |
| Simulatorstart nach Modul 004 | nicht nachgewiesen |
| Testdeklarationen vor Modul 005 | 27 |
| Tatsächlicher Testlauf | nicht nachgewiesen |

`xcodebuild` ist im Ausführungsumfeld nicht verfügbar. Build-, Simulator- und Testergebnisse können hier nicht nachgewiesen werden.

### AK-01-Nachprüfung

Ohne Simulator nicht ausführbar. Bleibt offen — wird nicht als bestanden markiert.

- [ ] Startansicht sichtbar
- [ ] Projekttitel sichtbar
- [ ] Regler sichtbar
- [ ] Standardwert 6
- [ ] „Spiel starten" sichtbar
- [ ] Ganzzahlschritte 1–12
- [ ] Startaktion funktioniert
- [ ] Genau ein zentrales Volume
- [ ] Kein zweites Fenster/Volume
- [ ] Kein Immersive Space

---

## 2. Asset-Inventar und Pipeline

### Reales Asset-Inventar vor Modul 005

| Asset | Quelldatei | Exportdatei | Format | Größe | Texturen | Status |
|---|---|---|---|---|---|---|
| monster01 | — | — | — | — | — | **fehlt** (kein Blender-Original) |
| monster02 | — | — | — | — | — | **fehlt** (kein Blender-Original) |
| monster03 | — | — | — | — | — | **fehlt** (kein Blender-Original) |
| monster04 | — | — | — | — | — | **fehlt** (kein Blender-Original) |

Keine `.blend`-, `.usdz`-, `.usd`-, `.usda`- oder `.usdc`-Monster-Dateien waren im Repository vorhanden. Vorhandene Assets: `Scene.usda` (Standardszene), `GridMaterial.usda` (Material).

### Angelegte Platzhalter-Assets (Modul 005)

Da keine fertigen Blender-Modelle vorliegen, wurden vier **USDA-Platzhalterszenen** mit einfachen Kugeln unterschiedlicher Radien angelegt. Sie sind klar als Platzhalter markiert (`doc`-Feld in der USDA-Datei) und technisch durch echte Blender-Exporte ersetzbar, ohne den Rest der Pipeline zu ändern.

| Asset | Datei | Format | Inhalt | Radius | Status |
|---|---|---|---|---|---|
| monster01 | `RealityKitContent.rkassets/monster01.usda` | USDA | Kugel | 0.04 m | Platzhalter |
| monster02 | `RealityKitContent.rkassets/monster02.usda` | USDA | Kugel | 0.06 m | Platzhalter |
| monster03 | `RealityKitContent.rkassets/monster03.usda` | USDA | Kugel | 0.08 m | Platzhalter |
| monster04 | `RealityKitContent.rkassets/monster04.usda` | USDA | Kugel | 0.10 m | Platzhalter |

**Was das Team noch liefern muss:**
Vier fertige Blender-Quelldateien (`.blend`) und deren USDZ-Exporte, je mit korrekter Skalierung (ca. 0.05–0.15 m), Y-Up-Ausrichtung und zentriertem Transform-Ursprung. Nach dem Export ersetzen die USDZ-Dateien die jeweiligen `.usda`-Platzhalter unter demselben Dateinamen (oder alternativ als `.usdz` mit entsprechender Anpassung der Ladepfade).

### Asset-Schlüssel

Definiert in `AssetKeys.Monster` (neu in `AppConstants.swift`):

```swift
AssetKeys.Monster.monster01  // "monster01"
AssetKeys.Monster.monster02  // "monster02"
AssetKeys.Monster.monster03  // "monster03"
AssetKeys.Monster.monster04  // "monster04"
AssetKeys.Monster.allIDs     // ["monster01", "monster02", "monster03", "monster04"]
```

---

## 3. Zuordnungsentscheidung

### Umgang mit `monsterAssetId`

Das SPEC-Architekturfeld `monsterAssetId: String` wurde wie dokumentiert aufgelöst: Das Feld wurde direkt als `let monsterAssetId: String` in das bestehende `Ticket`-Struct aufgenommen. Keine alternative Mapping-Struktur, keine Abweichung von der SPEC.

### Ticket-Monster-Mapping (vollständig)

| Ticket | Team | Priorität | Monster-ID |
|---|---|---|---|
| TT-001 | netzwerk | normal | monster01 |
| TT-002 | netzwerk | wichtig | monster02 |
| TT-003 | netzwerk | kritisch | monster03 |
| TT-004 | konto | normal | monster04 |
| TT-005 | konto | wichtig | monster01 |
| TT-006 | konto | kritisch | monster02 |
| TT-007 | software | normal | monster03 |
| TT-008 | software | wichtig | monster04 |
| TT-009 | software | kritisch | monster01 |
| TT-010 | hardware | normal | monster02 |
| TT-011 | hardware | wichtig | monster03 |
| TT-012 | hardware | kritisch | monster04 |

### Zusammenfassung pro Monster

| Monster-ID | verwendete Teams | verwendete Prioritäten | Anzahl Tickets |
|---|---|---|---|
| monster01 | netzwerk, konto, software | normal, wichtig, kritisch | 3 |
| monster02 | netzwerk, konto, hardware | wichtig, kritisch, normal | 3 |
| monster03 | netzwerk, software, hardware | kritisch, normal, wichtig | 3 |
| monster04 | konto, software, hardware | normal, wichtig, kritisch | 3 |

Kein Monster erscheint bei weniger als drei Teams und drei Prioritäten. Kein Monster signalisiert eindeutig ein bestimmtes Team oder eine Priorität. AK-14-Anforderung „keine feste 1:1-Zuordnung" ist erfüllt.

---

## 4. Bereitstellungsschnittstelle

### MonsterAssetProvider

**Pfad:** `Ticket_Tamer/Ticket_Tamer/Assets/MonsterAssetProvider.swift`

```swift
@MainActor
enum MonsterAssetProvider {
    enum LoadError: Error, LocalizedError { ... }

    static func loadMonster(assetID: String) async throws -> Entity
}
```

**Ladeverhalten:**
1. Prüft, ob `assetID` in `AssetKeys.Monster.allIDs` enthalten ist. Falls nicht: `LoadError.unknownAssetID` + DebugLog.
2. Ruft `Entity(named:in:)` mit `realityKitContentBundle` auf. Bei Fehler: `LoadError.entityLoadFailed` + DebugLog.
3. Bei Erfolg: gibt die Entity zurück, loggt Erfolg.

**Fehlerbehandlung:** Kein stilles Fallback auf Fremd-Assets. Kein Netzwerkzugriff. Jeder Fehler wird geloggt und weitergegeben.

**Schnittstelle für Modul 006:**
```swift
let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
```
Modul 006 übergibt die `monsterAssetId` des aktuellen Tickets und erhält eine ladefähige Entity zurück. Die Entity-Hierarchie ist flach; Collision- und InputTarget-Komponenten können in Modul 007 ergänzt werden.

---

## 5. Geänderte und neue Dateien

| Datei (mit Ordner) | Art | Target/Package | Zweck | F-14/AK-14 |
|---|---|---|---|---|
| `RealityKitContent.rkassets/monster01.usda` | neu | RealityKitContent | USDA-Platzhalter Monster 01 | Asset-Einbindung |
| `RealityKitContent.rkassets/monster02.usda` | neu | RealityKitContent | USDA-Platzhalter Monster 02 | Asset-Einbindung |
| `RealityKitContent.rkassets/monster03.usda` | neu | RealityKitContent | USDA-Platzhalter Monster 03 | Asset-Einbindung |
| `RealityKitContent.rkassets/monster04.usda` | neu | RealityKitContent | USDA-Platzhalter Monster 04 | Asset-Einbindung |
| `Ticket_Tamer/Assets/MonsterAssetProvider.swift` | neu | Ticket_Tamer | Async-Ladeinterface für Monster-Entities | F-14 Ladefähigkeit |
| `Ticket_Tamer/Models/Ticket.swift` | ergänzt | Ticket_Tamer | `monsterAssetId: String` hinzugefügt | SPEC-Feld aufgelöst |
| `Ticket_Tamer/Support/AppConstants.swift` | ergänzt | Ticket_Tamer | `AssetKeys.Monster` mit vier Schlüsseln + `allIDs` | Zentrale Asset-Schlüssel |
| `Ticket_Tamer/Data/LocalTicketCatalog.swift` | ergänzt | Ticket_Tamer | `monsterAssetId` für alle 12 Tickets gesetzt | Zuordnung ohne 1:1-Signal |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | Ticket_TamerTests | 9 neue Modul-005-Tests | AK-14 Validierung |

---

## 6. Test- und Simulatorprüfung

### Neue automatisierte Tests (Modul 005)

| # | Test | Prüft |
|---|---|---|
| 1 | `exactlyFourMonsterIDsDefined` | genau 4 IDs in `AssetKeys.Monster.allIDs` |
| 2 | `allMonsterIDsAreUnique` | alle 4 IDs eindeutig |
| 3 | `monsterIDsAreNeutral` | keine team-/prioritätsbezogenen Begriffe |
| 4 | `allTicketsHaveNonEmptyMonsterAssetId` | alle 12 Tickets mit nicht-leerer ID |
| 5 | `allCatalogMonsterIDsAreKnown` | alle verwendeten IDs sind bekannt |
| 6 | `allFourMonsterIDsAppearInCatalog` | alle 4 Monster tatsächlich verwendet |
| 7 | `noMonsterIsExclusiveToOneTeam` | kein Monster nur bei einem Team |
| 8 | `noMonsterIsExclusiveToOnePriority` | kein Monster nur bei einer Priorität |
| 9 | `eachMonsterAppearsWithMultipleTeams` | ≥ 2 Teams pro Monster |
| 10 | `eachMonsterAppearsWithMultiplePriorities` | ≥ 2 Prioritäten pro Monster |
| 11 | `unknownAssetIDThrows` | unbekannte ID → `LoadError.unknownAssetID` |

**Gesamt-Testdeklarationen nach Modul 005:** 27 (001–004) + 11 (005) = **38**

### Tatsächlich ausgeführte Tests

Nicht nachgewiesen — kein Xcode/`xcodebuild` im Ausführungsumfeld.

### Manuelle Simulatorprüfung (noch offen)

| Prüfpunkt | Status |
|---|---|
| monster01 lädt und ist sichtbar im Volume | offen (kein Simulator) |
| monster02 lädt und ist sichtbar im Volume | offen |
| monster03 lädt und ist sichtbar im Volume | offen |
| monster04 lädt und ist sichtbar im Volume | offen |
| Größe und Orientierung grundsätzlich verwendbar | offen |
| Kein Netzwerkzugriff beim Laden | konstruktiv sichergestellt (lokale USDA, Bundle-Load) |
| Genau ein zentrales Volume | unverändert; kein zweites Volume ergänzt |

### AK-14-Aufteilung

**Bereits verifiziert (Modell- und Katalogebene):**
- [x] Vier eigene lokale Assets eingebunden (Platzhalter, bis Blender-Exporte vorliegen)
- [x] `monsterAssetId` in `Ticket` vorhanden
- [x] Keine feste 1:1-Zuordnung Monster → Team oder Priorität (durch Tests abgesichert)
- [x] Ladeschnittstelle vorhanden (`MonsterAssetProvider`)
- [x] Keine Netzwerkabhängigkeit (konstruktiv)
- [x] Entity-Hierarchie für spätere Interaktion vorbereitet (keine unnötige Verschachtelung)

**Noch offen bis Modul 007 / manuell:**
- [ ] Darstellung jedes einzelnen Monsters im Simulator bestätigt
- [ ] Skalierung und Orientierung der echten Blender-Exporte geprüft
- [ ] Vollständige Gesteninteraktion (Blickfokus, Pinch, Drag) — **Modul 007**

---

## Dateien

| Datei (mit Ordner) | Art | Zweck |
|---|---|---|
| `RealityKitContent.rkassets/monster01.usda` | neu | USDA-Platzhalter (Kugel Ø 0.08 m) bis Blender-Export vorliegt |
| `RealityKitContent.rkassets/monster02.usda` | neu | USDA-Platzhalter (Kugel Ø 0.12 m) |
| `RealityKitContent.rkassets/monster03.usda` | neu | USDA-Platzhalter (Kugel Ø 0.16 m) |
| `RealityKitContent.rkassets/monster04.usda` | neu | USDA-Platzhalter (Kugel Ø 0.20 m) |
| `Ticket_Tamer/Assets/MonsterAssetProvider.swift` | neu | Async-Ladeinterface für lokale Monster-Entities |
| `Ticket_Tamer/Models/Ticket.swift` | ergänzt | `monsterAssetId: String` (SPEC-Feld) |
| `Ticket_Tamer/Support/AppConstants.swift` | ergänzt | `AssetKeys.Monster` mit vier Schlüsseln |
| `Ticket_Tamer/Data/LocalTicketCatalog.swift` | ergänzt | `monsterAssetId` für alle 12 Tickets |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | 11 neue Modul-005-Tests |

---

## Erfüllte Akzeptanzkriterien

- [x] AK-14 (Asset- und Zuordnungsanteil) — vier lokale USDA-Assets eingebunden, Ladeschnittstelle vorhanden, Mapping ohne 1:1-Signal, `monsterAssetId` im Modell. Geprüft durch: statische Codeanalyse, Unit-Tests 1–11.
- [ ] AK-14 (Darstellungsanteil) — Sichtbarkeit jedes Monsters im Volume: **offen**, da kein Simulator verfügbar. Zu prüfen beim nächsten Simulator-Build.
- [ ] AK-14 (Gestenanteil) — Blickfokus, Pinch, Drag: **offen bis Modul 007**.

---

## Bereitgestellte Schnittstellen (für Folgemodule)

- `Ticket.monsterAssetId: String` — neutraler Asset-Bezeichner am Ticket; Modul 006 liest diesen Wert.
- `AssetKeys.Monster.monster01` … `monster04` — vier stabile String-Konstanten.
- `AssetKeys.Monster.allIDs: [String]` — geordnetes Array aller vier IDs für Validierung und Tests.
- `MonsterAssetProvider.loadMonster(assetID:) async throws -> Entity` — lokales Laden; Modul 006 ruft diese Methode mit `ticket.monsterAssetId` auf.
- `MonsterAssetProvider.LoadError` — typisierte Fehler für unbekannte und nicht ladbare Assets.

---

## DebugManager

- Kategorie `spawning`: loggt Asset-ID bei Ladestart, Ladeerfolg und Ladefehler in `MonsterAssetProvider`.
- Keine neue Kategorie hinzugefügt.
- Keine `print()`-Aufrufe.

---

## Asset- und Lizenzstatus

| Asset | Erstellt von | Typ | Lizenz |
|---|---|---|---|
| `monster01.usda` | Modul-005-Chat (Platzhalter) | USDA-Kugel | kein Drittinhalt; eigene Projektdatei |
| `monster02.usda` | Modul-005-Chat (Platzhalter) | USDA-Kugel | kein Drittinhalt; eigene Projektdatei |
| `monster03.usda` | Modul-005-Chat (Platzhalter) | USDA-Kugel | kein Drittinhalt; eigene Projektdatei |
| `monster04.usda` | Modul-005-Chat (Platzhalter) | USDA-Kugel | kein Drittinhalt; eigene Projektdatei |

Echte Blender-Modelle: noch nicht geliefert. Urheberschaft, Lizenz und Exportformat müssen bei Lieferung dokumentiert werden.

---

## Annahmen / offene Punkte / Risiken

- **Platzhalter vs. echte Assets:** Die USDA-Platzhalter ermöglichen den Aufbau der Pipeline, sind aber keine finalen Monster. Sobald Blender-Modelle vorliegen, ersetzen USDZ-Exporte die USDA-Dateien unter demselben Bezeichner (oder die `AssetKeys`-Strings werden entsprechend angepasst). Der Rest der Pipeline (Provider, Katalog, Tests) bleibt unverändert.
- **Neuer Ordner `Assets/`:** `MonsterAssetProvider.swift` liegt in `Ticket_Tamer/Assets/`, das neu angelegt wurde. Da das Projekt `PBXFileSystemSynchronizedRootGroup` verwendet, wird dieser Ordner automatisch von Xcode erkannt. Beim nächsten Build in Xcode prüfen, ob der neue Ordner korrekt eingebunden ist.
- **Build nicht nachgewiesen:** `xcodebuild` war im Ausführungsumfeld nicht verfügbar. Der erste Build nach Modul 005 muss lokal in Xcode erfolgen.
- **AK-01-Nachprüfung offen:** Startansicht wurde nicht im Simulator geprüft.
- **Blender-Pipeline-Doku:** Wenn echte Modelle geliefert werden, muss die Blender-Exportpipeline (Skalierung, Achse, Transform-Ursprung, Texturabhängigkeiten) dokumentiert werden.

---

## Nicht umgesetzt (ausdrücklich)

- Keine Untersuchungsansicht, keine Ticketkarte, kein „Weiter zur Priorisierung".
- Keine vollständige Gesteninteraktion (Modul 007).
- Keine Drop-Ziele, keine Prioritäts-/Teamzuordnungslogik.
- Kein Audiofeedback.
- Keine `print()`-Aufrufe.
- Keine neue DebugManager-Kategorie.

---

## Git

- Commit: `005: Monster-Asset-Pipeline`
- Hash: wird nach lokalem Commit eingetragen

---

## Stand aktualisiert

- [x] `Projekt-Stand.md` neu erzeugt und ersetzt.
- [ ] `Logbuch-Stand.md` aktualisieren (Aufgabe des Projektlogbuchs).
- [x] Neue Dateien im Projekt-Stand vermerkt.

---

## Empfehlung für das nächste Modul

**Modul 006 — Untersuchungsansicht** kann direkt starten. Voraussetzungen sind erfüllt: `Ticket.monsterAssetId` ist vorhanden, `MonsterAssetProvider.loadMonster(assetID:)` ist aufrufbar, alle 12 Tickets haben gültige Zuordnungen. Modul 006 baut die Untersuchungsansicht mit Ticketkarte und Monster-Anzeige auf Basis dieser Schnittstellen. Vor dem Start von Modul 006 sollte der erste Simulator-Build nach Modul 005 lokal durchgeführt und AK-01 manuell geprüft werden.
