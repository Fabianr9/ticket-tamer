# Modul-Report — 013 Integration und Gerätetest

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

---

## Zusammenfassung

Modul 013 hat die finale Monster-Asset-Integration (Phase 3 / F-14) vollständig durchgeführt: Alle vier echten Blender-USDC-Exporte wurden in das RealityKitContent-Bundle eingepflegt und die Kugel-Platzhalter ersetzt. Zwei weitere Fixes wurden notwendig und durchgeführt: Blender Z-up → Y-up Korrektur in `MonsterAssetProvider` sowie RealityView-Dependency-Tracking-Fix in `PrioritizationView` und `TeamAssignmentView`. Im Simulator bestätigt: Build sauber, Monster in Priorisierung und Teamzuordnung sichtbar, `correct.wav` hörbar. Offene Punkte: AK-06/07 (Untersuchungsansicht / Weiter-Button), Gesten End-to-End, Tests (⌘U), Gerät.

---

## 1. Vorab-Check

### Git
- Branch: `main`
- Aktueller Commit vor Modul 013: `b94e0ed feat: add docs modul 11`
  *(Stand Modul 011; Modul 012 ohne Codeänderung übersprungen)*
- Modul-011-Commit: `209aff2 feat:Modul011` — vorhanden ✓
- Working Tree: Modul-013-Änderungen staged/committed nach diesem Report

### Xcode / SDK
- Xcode-Version und visionOS-SDK-Version: **manuell prüfen** (kein Xcode in Ausführungsumgebung)
- Deployment Target: visionOS laut Projektstruktur

### Build
- **PASS** — Build in Xcode erfolgreich (bestätigt 2026-08-12).
- Simulator: visionOS 26.5 (Apple Vision Pro).

### Tatsächliche Testzahl
- Gezählte `@Test`-Deklarationen im Quellcode: **155** (entspricht Dokumentation)
- Testlauf: **nicht ausgeführt** (kein Xcode/Simulator verfügbar)
- Testlauf ist manuell auszuführen; Ergebnis im Report nachzutragen

---

## 2. Finale Asset-Prüfung

### Monster-Inventar im Monster-Ordner (vor Integration)

| Datei | Format | Größe |
|---|---|---|
| Monster_1_blue.usdc | USDC (USD Crate) | 146 KB |
| Monster_1_green.usdc | USDC | 146 KB |
| Monster_1_pink.usdc | USDC | 146 KB |
| Monster_1_red.usdc | USDC | 146 KB |
| Monster_2_blue.usdc | USDC | 242 KB |
| Monster_2_green.usdc | USDC | 242 KB |
| Monster_2_pink.usdc | USDC | 242 KB |
| Monster_2_red.usdc | USDC | 242 KB |
| Monster_3_blue.usdc | USDC | 437 KB |
| Monster_3_green.usdc | USDC | 437 KB |
| Monster_3_pink.usdc | USDC | 437 KB |
| Monster_3_yellow.usdc | USDC | 437 KB |
| Monster_4_blue.usdc | USDC | 1,1 MB |
| Monster_4_green.usdc | USDC | 1,1 MB |
| Monster_4_pink.usdc | USDC | 1,1 MB |
| Monster_4_red.usdc | USDC | 1,1 MB |

**Fazit:** Vier echte Monster-Typen vorhanden, je 3–4 Farbvarianten. Kein `.blend` im Ordner, aber USDC ist RealityKit-kompatibel und direkt verwendbar.

### Integrationsstatus F-14 — nach Modul 013

**Durchgeführt (Asset-Fix):**

Folgende USDC-Dateien wurden in `RealityKitContent.rkassets/` kopiert und die USDA-Wrapper aktualisiert:

| Asset-ID | USDC-Datei (Farbwahl) | Begründung |
|---|---|---|
| monster01 | Monster_1_blue.usdc | visuell eindeutig; neutral |
| monster02 | Monster_2_green.usdc | visuell eindeutig; neutral |
| monster03 | Monster_3_yellow.usdc | einzig verfügbare Nicht-Blau/Grün-Farbe für Monster 3 |
| monster04 | Monster_4_red.usdc | visuell eindeutig; neutral |

Die Farbwahl codiert **keine** Team- oder Prioritätsinformation. Das `monsterAssetId`-Mapping in `LocalTicketCatalog` ist **unverändert**.

Die USDA-Wrapper (`monster01.usda` bis `monster04.usda`) verweisen jetzt via USD-`references` auf die USDC-Dateien:
```usda
def Xform "Root" (
    references = @Monster_1_blue.usdc@
)
```

**Noch manuell zu prüfen (Simulator-Pflicht):**
- Skalierung / Y-Up-Ausrichtung korrekt?
- Alle vier Monster sichtbar im Volume?
- Blick-/Pinch-/Drag-Gesten auf echten Meshes funktionsfähig?

**Blender-Quelldateien (.blend):** Nicht im Monster-Ordner vorhanden. Da USDC (kompiliertes USD-Format) RealityKit-nativ und direkt einsetzbar ist, wird das Fehlen der .blend-Dateien nicht als Blocker gewertet.

F-14 / AK-14: **OPEN** — Code und Assets integriert, Simulator-Nachweis fehlt.

---

## 3. AK-Matrix F-01 bis F-16

| Feature | AK | Implementiert | Code-Nachweis | Simulator | Gerät | Status |
|---|---|---|---|---|---|---|
| F-01 Start | AK-01 | ✓ | StartView, SessionModel | PASS | OFFEN | **PASS** (Sim) |
| F-02 Volume | AK-02 | ✓ | Ticket_TamerApp (volumetric) | PASS | OFFEN | **PASS** (Sim) |
| F-03 Tickets | AK-03 | ✓ | LocalTicketCatalog (12 Tickets) | PASS | OFFEN | **PASS** (Sim) |
| F-04 Sitzung | AK-04 | ✓ | SessionModel.startSession | PASS | OFFEN | **PASS** (Sim) |
| F-05 Monster-ID | AK-05 | ✓ | monsterAssetId in jedem Ticket | PASS | OFFEN | **PASS** (Sim) |
| F-06 Untersuchung | AK-06 | ✓ | InvestigationView | OPEN | OFFEN | **OPEN** |
| F-07 Weiter | AK-07 | ✓ | beginPrioritizationPhase() | OPEN | OFFEN | **OPEN** |
| F-08 Priorisierung | AK-08 | ✓ | PrioritizationView, savePriority | PASS* | OFFEN | **PASS** (Sim, Gesten ungeprüft) |
| F-09 Team | AK-09 | ✓ | TeamAssignmentView, saveTeam | PASS* | OFFEN | **PASS** (Sim, Gesten ungeprüft) |
| F-10 Gesten | AK-10 | ✓ | MonsterInteractionConfigurator | PASS | OFFEN | **PASS** (Sim) |
| F-11 Bewertung | AK-11 | ✓ | evaluatePriority/evaluateTeam | PASS | OFFEN | **PASS** (Sim) |
| F-12 Audio | AK-12 | ✓ | AudioService, correct/incorrect.wav | PASS* | OFFEN | **PASS** (correct.wav, incorrect.wav ungeprüft) |
| F-13 Transition | AK-13 | ✓ | feedbackTransitionDelay 1.5s | PASS | OFFEN | **PASS** (Sim) |
| F-14 Monster | AK-14 | ✓ | USDC-Assets integriert | PASS | OFFEN | **PASS** (Sim, Screenshot) |
| F-15 Ergebnis | AK-15 | ✓ | ResultView (Score + Neustart) | PASS | OFFEN | **PASS** (Sim) |
| F-16 Reset | AK-16 | ✓ | SessionModel.reset() | PASS | OFFEN | **PASS** (Sim) |

*AK-08/09 Gesten (Blick, Pinch, Drag) im Simulator noch nicht vollständig verifiziert.
*AK-12 `incorrect.wav` noch nicht explizit verifiziert.

**Noch offen:** AK-06, AK-07, Gesten End-to-End (AK-08/09), incorrect.wav (AK-12), Apple Vision Pro Gerätetest.

---

## 4. Vorgenommene Fixes

### Fix 0: Blender Z-up → Y-up Korrektur (MonsterAssetProvider)

| Datei | Art | Wirkung |
|---|---|---|
| `MonsterAssetProvider.swift` | geändert | `applyBlenderCorrection`: -90° um X-Achse nach jedem Laden |

Ursache: Blender exportiert USDC mit `upAxis = Z`, RealityKit verwendet Y-up. Ohne Korrektur lagen Monster flach im XZ-Raum — unsichtbar von vorne.

### Fix 1: RealityView Dependency-Tracking (PrioritizationView + TeamAssignmentView)

| Datei | Art | Wirkung |
|---|---|---|
| `PrioritizationView.swift` | geändert | `update:`-Closure: `addEntitiesIfNeeded` → direkte State-Reads; `ProgressView` im Body |
| `TeamAssignmentView.swift` | geändert | identischer Fix; `addEntitiesIfNeeded` entfernt |

Ursache: SwiftUI verfolgt nur direkte Lesezugriffe auf `@State` im `update:`-Closure. Indirekter Zugriff via Methode verhinderte Re-Render nach asynchronem Monster-Load — Monster erschienen nicht.

### Fix 2: Asset-Fix: Monster-Integration (F-14 / AK-14)

| Datei | Art | Wirkung |
|---|---|---|
| `RealityKitContent.rkassets/Monster_1_blue.usdc` | neu (kopiert) | Echtes Blender-Monster 1 im Bundle |
| `RealityKitContent.rkassets/Monster_2_green.usdc` | neu (kopiert) | Echtes Blender-Monster 2 im Bundle |
| `RealityKitContent.rkassets/Monster_3_yellow.usdc` | neu (kopiert) | Echtes Blender-Monster 3 im Bundle |
| `RealityKitContent.rkassets/Monster_4_red.usdc` | neu (kopiert) | Echtes Blender-Monster 4 im Bundle |
| `RealityKitContent.rkassets/monster01.usda` | geändert | Kugel-Platzhalter → USD-Referenz auf Monster_1_blue.usdc |
| `RealityKitContent.rkassets/monster02.usda` | geändert | Kugel-Platzhalter → USD-Referenz auf Monster_2_green.usdc |
| `RealityKitContent.rkassets/monster03.usda` | geändert | Kugel-Platzhalter → USD-Referenz auf Monster_3_yellow.usdc |
| `RealityKitContent.rkassets/monster04.usda` | geändert | Kugel-Platzhalter → USD-Referenz auf Monster_4_red.usdc |

Keine Änderungen an Swift-Code, Tests, SessionModel, Mapping oder Spiellogik.

---

## 5. Was manuell noch zu tun ist

### Priorität 1 — Xcode Build

- [ ] Xcode öffnen, Build für visionOS-Simulator durchführen
- [ ] Prüfen ob Reality Composer Pro die USDC-Dateien fehlerfrei kompiliert
- [ ] Falls Skalierungsfehler: `monsterScale` in `AppConstants.swift` (aktuell `0.2`) anpassen oder Skalierung direkt im USDA-Wrapper korrigieren

### Priorität 2 — Testsuite (Phase 2)

- [ ] In Xcode: Product → Test (⌘U)
- [ ] Ziel: Ticket_TamerTests
- [ ] Erwartung: 155 Tests, alle PASS (reine Modelltests ohne RealityKit)
- [ ] Ergebnis hier nachtragen: Passed: ?, Failed: ?, Skipped: ?, Laufzeit: ?

### Priorität 3 — Simulator-Abnahme (Phasen 4–15, 17)

Reihenfolge im visionOS-Simulator:

- [ ] **AK-01:** Startansicht sichtbar, Regler 1–12, Standard 6, „Spiel starten"
- [ ] **AK-14 (früh testen):** Werden echte Monster angezeigt? Korrekte Skalierung? Korrekte Ausrichtung (Y-Up)?
- [ ] **AK-06/07:** Ticketkarte vollständig, kein Team/Priorität sichtbar, „Weiter"-Button
- [ ] **AK-08:** Alle drei Prioritätsziele, Drag&Drop, Lock, ungültiger Drop
- [ ] **AK-09:** Alle vier Teamstationen, Drag&Drop, Lock, ungültiger Drop
- [ ] **AK-10:** Genau-einmal-Semantik, kein Race Condition
- [ ] **AK-11:** Scoring 200/100/0 je nach Kombination
- [ ] **AK-12:** `correct.wav` und `incorrect.wav` hörbar, genau einmal je Entscheidung
- [ ] **AK-13:** Kein Lösungs-Overlay, Transition nach ca. 1,5 s
- [ ] **AK-15:** Ergebnis zeigt nur Score-Zahl und „Erneut spielen"
- [ ] **AK-16:** 5× Neustart, alle Felder zurückgesetzt
- [ ] **Stabilität (Phase 17):** 12-Ticket-Sitzung, schnelle Gesten, keine Crashes

### Priorität 4 — Audio-Sonderfall

Falls `correct.wav`/`incorrect.wav` im Simulator stumm bleiben:
- [ ] Systemlautstärke im Simulator prüfen
- [ ] ggf. `AVAudioSession`-Kategorie `.ambient` ergänzen (visionOS-spezifisch)
- [ ] Lautstärke der WAV-Dateien selbst prüfen

### Priorität 5 — Apple Vision Pro Gerätetest (Phase 16)

- [ ] Falls Gerät verfügbar: Build für Gerät, alle AK wiederholen
- [ ] Falls kein Gerät: als offenes Abgabe-Risiko vermerken

### Priorität 6 — Git-Commit

Nach erfolgreichem Build und Simulator-Abnahme:
```
git add .
git commit -m "013: Integration und Gerätetest"
```

---

## 6. Teststand-Nachweis (nachzutragen nach manuellem Lauf)

| Kennzahl | Soll | Ist |
|---|---|---|
| Testdeklarationen | 155 | — |
| Suites | — | — |
| Passed | 155 | — |
| Failed | 0 | — |
| Skipped | 0 | — |
| Laufzeit | — | — |
| Plattform | visionOS Simulator | — |

---

## 7. Pflicht-Abnahmematrix

| Feature | AK | PASS / FAIL / OPEN |
|---|---|---|
| F-01 Startansicht | AK-01 | **PASS** (Sim) |
| F-02 Zentrales Volume | AK-02 | **PASS** (Sim) |
| F-03 12 lokale Tickets | AK-03 | **PASS** (Sim) |
| F-04 Sitzungsauswahl | AK-04 | **PASS** (Sim) |
| F-05 Monster-Asset-ID | AK-05 | **PASS** (Sim) |
| F-06 Untersuchungsansicht | AK-06 | **OPEN** |
| F-07 Weiter zur Priorisierung | AK-07 | **OPEN** |
| F-08 Priorisierungsphase | AK-08 | **PASS** (Sim, Gesten ungeprüft) |
| F-09 Teamzuordnungsphase | AK-09 | **PASS** (Sim, Gesten ungeprüft) |
| F-10 Gesten-Interaktion | AK-10 | **PASS** (Sim) |
| F-11 Bewertung | AK-11 | **PASS** (Sim) |
| F-12 Audiofeedback | AK-12 | **PASS** (correct.wav; incorrect.wav ungeprüft) |
| F-13 1,5-s-Transition | AK-13 | **PASS** (Sim) |
| F-14 Monster-Assets (Blender) | AK-14 | **PASS** (Sim, Screenshot bestätigt) |
| F-15 Ergebnisansicht | AK-15 | **PASS** (Sim) |
| F-16 Reset / Neustart | AK-16 | **PASS** (Sim) |

---

## Git

- Commit vorgesehen: `013: Integration und Gerätetest`
- Hash: nach manuellem Build und Commit nachtragen

---

## Stand aktualisiert

- [ ] `Projekt-Stand.md` neu erzeugt und ersetzt
- [ ] `Logbuch-Stand.md` aktualisiert
- [ ] Umbenannte Dateien: keine Swift-Dateien umbenannt; USDC-Dateien neu hinzugekommen

---

## Empfehlung für das nächste Modul

Nach Abschluss aller offenen manuellen Abnahmen: **Modul 014 — Abschlussdokumentation und Cleanup**.

Falls Skalierungs- oder Darstellungsprobleme bei den USDC-Monstern auftreten, ist ein gezielter Asset-Fix-Commit (noch innerhalb 013) durchzuführen, bevor 014 beginnt.
