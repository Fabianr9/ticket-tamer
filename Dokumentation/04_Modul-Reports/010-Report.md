# Modul-Report — 010 Bewertung und Audiofeedback

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

---

## Zusammenfassung

Modul 010 implementiert die vollständige Bewertungs- und Feedbackschicht des Spiels. Nach jeder gültigen Prioritäts- oder Teamentscheidung wird diese genau einmal gegen den Referenzwert des aktiven Tickets bewertet (+100 bei richtig, +0 bei falsch, keine negativen Punkte). Unmittelbar nach der Bewertung spielt ein lokaler Richtig- oder Falsch-Sound. Nach ungefähr 1,5 Sekunden wechselt das Spiel automatisch in die nächste Phase. Die richtige Lösung wird zu keinem Zeitpunkt angezeigt.

---

## Vorab-Check

### Git

- **Branch:** `main`
- **Stand vor Modul 010:** `2a9b58c` (`feat: update docs module 009`)
- **Modul-009-Commit:** `0c38caf` (`feat:Modul009`)
- **Alle Referenz-Commits enthalten:** `200093b` ✓ / `b716ed1` ✓ / `7b873b7` ✓ / `0c38caf` ✓
- **Working Tree vor Modul 010:** sauber

### Testdeklarationen vor Modul 010

- 110 Deklarationen (86 vor Modul 009 + 24 `TeamAssignmentPhaseTests`)
- Vollständiger Testlauf: offen (Simulator-abhängig)

### Audioinventar vor Modul 010

Keine `.wav`, `.caf`, `.m4a`, `.aiff`, `.mp3`-Dateien vorhanden.

---

## Dateien

| Datei (mit Ordner) | Art | Zweck |
|---|---|---|
| `Resources/correct.wav` | neu | Richtig-Sound (Platzhalter) |
| `Resources/incorrect.wav` | neu | Falsch-Sound (Platzhalter) |
| `Services/AudioService.swift` | neu | AVAudioPlayer-Kapselung für Richtig-/Falsch-Feedback |
| `Support/AppConstants.swift` | ergänzt | `FeedbackConstants` mit Delay, Sound-Namen, Punkte-Konstante |
| `Models/SessionModel.swift` | ergänzt | `evaluatePriority()`, `evaluateTeam()`, `completeTicketAfterTeamFeedback()`, Bewertungsflags |
| `Views/PrioritizationView.swift` | ergänzt | `.onChange(selectedPriority)` → Bewertung + Sound + 1,5s → `beginTeamAssignmentPhase()` |
| `Views/TeamAssignmentView.swift` | ergänzt | `.onChange(selectedTeam)` → Bewertung + Sound + 1,5s → `completeTicketAfterTeamFeedback()` |
| `Ticket_TamerTests/Ticket_TamerTests.swift` | ergänzt | `ScoringAndFeedbackTests` (30 Tests) |

---

## Audioresourcen und Rechte

| Sound | Datei | Format | Quelle/Urheber | Lizenz/Rechte | Bundle-Pfad |
|---|---|---|---|---|---|
| Richtig | `correct.wav` | WAV 44100 Hz / 16 bit mono | Projekt-eigener Platzhalter, generiert per Python (`math.sin`, 880 Hz, 0,5 s) | **Projekt-eigene Datei, keine Fremdrechte** | `Ticket_Tamer.app/correct.wav` |
| Falsch | `incorrect.wav` | WAV 44100 Hz / 16 bit mono | Projekt-eigener Platzhalter, generiert per Python (`math.sin`, 220 Hz, 0,5 s) | **Projekt-eigene Datei, keine Fremdrechte** | `Ticket_Tamer.app/incorrect.wav` |

**Hinweis:** Beide Dateien sind klar als Platzhalter gekennzeichnet. Sie sind projekt-eigen und enthalten keine fremd-lizenzierten Samples. Sie können jederzeit durch finale Sounds gleicher Dateinamen ersetzt werden.

---

## Gewählte Audio-API

**AVFoundation / AVAudioPlayer**

Begründung: AVAudioPlayer ist die standardmäßige synchrone Abspiel-API auf allen Apple-Plattformen einschließlich visionOS. Sie benötigt weder einen RealityKit-Render-Loop noch eine Netzwerkverbindung. Kein globaler Service-Locator notwendig. RealityKit-Audio-Entities wären erst sinnvoll bei räumlich positioniertem 3D-Sound — nicht gefordert in Modul 010.

---

## Erfüllte Anforderungen

### F-11 — Bewertung

- [x] Richtige Priorität: +100 Punkte
- [x] Falsche Priorität: 0 Punkte
- [x] Richtiges Team: +100 Punkte
- [x] Falsches Team: 0 Punkte
- [x] Keine negativen Punkte
- [x] Pro Ticket maximal 200 Punkte

### F-12 — Audiofeedback

- [x] Richtig → `correct.wav` (880 Hz Sinuston, Platzhalter)
- [x] Falsch → `incorrect.wav` (220 Hz Sinuston, Platzhalter)
- [x] Die richtige Lösung wird **nicht** angezeigt oder erklärt
- [x] Kein Label, kein Popup, kein Overlay

### F-13 — Eingabesperre und automatischer Übergang

- [x] Eingabe bleibt nach gültiger Entscheidung gesperrt
- [x] Feedbackdauer: `FeedbackConstants.feedbackTransitionDelay = 1.5` Sekunden
- [x] `.priorisieren → .teamZuordnen` nach Prioritätsfeedback
- [x] `.teamZuordnen → .untersuchen` (nächstes Ticket) oder `.ergebnis` (letztes Ticket)

---

## Akzeptanzkriterien-Status

| AK | Beschreibung | Status |
|---|---|---|
| AK-08 | Prioritätsdrop und Speicherung (Gesten) | Offen (Simulator) |
| AK-09 | Teamdrop und Speicherung (Gesten) | Offen (Simulator) |
| AK-10 | Vollständige Spiellauflinie | Offen (Simulator) |

*(Simulator-Abnahme liegt außerhalb der reinen Code-Implementierung dieses Moduls.)*

---

## Zwingende Scope-Regel — Bestätigung

**Die richtige Lösung wird nicht angezeigt.**

Folgendes wurde nicht implementiert und ist nicht vorhanden:

- kein Text „Richtig wäre …" oder „Richtiges Team: …"
- kein Lösungs-Overlay
- kein sichtbares Richtig/Falsch-Label
- keine farbliche Markierung des richtigen Ziels
- keine Erklärung

Feedback besteht ausschließlich aus: internem Score, lokalem Sound, automatischem Übergang.

---

## Neue SessionModel-Schnittstellen

### `evaluatePriority() -> Bool?`

- **Vorbedingungen:** `currentPhase == .priorisieren`, `selectedPriority != nil`, `currentTicket != nil`, noch nicht bewertet
- **Richtig:** `score += 100`, Flag gesetzt → `true`
- **Falsch:** kein Score, Flag gesetzt → `false`
- **No-Op:** `nil`
- **Genau-einmal:** zweiter Aufruf → `nil`, kein weiterer Score

### `evaluateTeam() -> Bool?`

- Analog zu `evaluatePriority()`, für `currentPhase == .teamZuordnen`

### `completeTicketAfterTeamFeedback()`

- **Vorbedingung:** `currentPhase == .teamZuordnen`
- **Weiteres Ticket:** Index +1, Entscheidungen nil, Flags zurück, Input entsperrt, Phase `.untersuchen`, Score erhalten
- **Letztes Ticket:** Phase `.ergebnis`, Input entsperrt, Score und Sitzungsdaten erhalten
- Kein vollständiger Reset

---

## Bewertungs- und genau-einmal-Semantik

Interne `private var priorityEvaluated: Bool` und `private var teamEvaluated: Bool` verhindern doppelte Punkte durch:
- View-Neuberechnung
- mehrfachen `Task`-Start
- mehrfaches Release-Ereignis
- erneuten direkten Methodenaufruf

Flags werden in `completeTicketAfterTeamFeedback()` für das neue Ticket zurückgesetzt und in `reset()` und `startSession()` gelöscht.

---

## Automatischer Flow

### Prioritätsflow

```
savePriority(_:) setzt selectedPriority + sperrt Input
  ↓
.onChange(selectedPriority) feuert (wenn noch kein Task läuft)
  ↓
evaluatePriority() → true/false
  ↓
audioService.play(.correct / .incorrect)
  ↓
Task.sleep(1.5s)
  ↓
beginTeamAssignmentPhase() → Phase: .teamZuordnen, Input entsperrt
```

### Teamflow

```
saveTeam(_:) setzt selectedTeam + sperrt Input
  ↓
.onChange(selectedTeam) feuert (wenn noch kein Task läuft)
  ↓
evaluateTeam() → true/false
  ↓
audioService.play(.correct / .incorrect)
  ↓
Task.sleep(1.5s)
  ↓
completeTicketAfterTeamFeedback()
  → weiteres Ticket: Index+1, Phase: .untersuchen
  → letztes Ticket: Phase: .ergebnis
```

### Mehrfach-Task-Schutz

`@State private var feedbackTaskStarted: Bool` in beiden Views verhindert parallele Tasks. Rückgesetzt auf `false` beim View-Erscheinen ohne gespeicherte Entscheidung (`onAppear`).

---

## DebugManager-Nutzung

| Kategorie | Wo |
|---|---|
| `.state` | Bewertungsergebnis, Scoreänderung, Phasenwechsel, No-Ops |
| `.audio` | Sound geladen, abgespielt, Fehler beim Laden |

Keine neue Kategorie. Keine Referenzwerte im UI-sichtbaren Text. Interne boolesche Ergebnisse (richtig/falsch) erscheinen nur in Debug-Logs.

---

## DEBUG-Teambutton

Der `🔧 Team [DEV]`-Button in `PrioritizationView` bleibt als `#if DEBUG`-Hilfsmittel bestehen. Er ist weiterhin nützlich für manuelle Simulator-Entwicklungssprünge und erscheint nie im Release-Build.

---

## Teststand

- **Vor Modul 010:** 110 Testdeklarationen
- **Neu hinzugefügt:** 30 Tests (`ScoringAndFeedbackTests`)
- **Nach Modul 010:** 140 Testdeklarationen

### Abgedeckte Testfälle

**Prioritätsbewertung (1–5):** richtig +100, falsch +0, genau-einmal, No-Op ohne Entscheidung, No-Op falsche Phase.

**Teambewertung (6–10):** richtig +100, falsch +0, genau-einmal, No-Op ohne Team, No-Op falsche Phase.

**Kombination (11–15):** beide richtig 200, Priorität richtig/Team falsch 100, Priorität falsch/Team richtig 100, beide falsch 0, kein negativer Score.

**Flow (16–25):** Phase wechselt nach Prioritätsfeedback, Priorität bleibt erhalten, Teamphase entsperrt, Index +1, `.untersuchen`, Entscheidungen nil, Score erhalten, letztes Ticket → `.ergebnis`, kein Überlauf, Reset löscht Flags.

**Genau-einmal (26–27):** mehrfacher Prioritäts- / Teamaufruf gibt keine doppelten Punkte.

**Audio-Mapping (28–30):** Sound-Namen nicht leer, nicht HTTP, eindeutig.

---

## Build-/Simulator-/Verifikationsstand

| Prüfung | Stand |
|---|---|
| 009-Commit | `0c38caf` (bestätigt) |
| Code-Änderungen Modul 010 | implementiert, committed als `010: Bewertung und Audiofeedback` |
| Build nach Modul 010 | offen (Xcode / Simulator) |
| Simulator-Prüfung Audiofeedback | offen |
| 140 Tests vollständig | offen |
| AK-08 Gesten | offen |
| AK-09 Gesten | offen |
| AK-10 komplette Laufzeit | offen |

---

## Monster-Asset-Status

| Monster-ID | aktuelles Asset | finales Blender-Modell |
|---|---|---|
| monster01 | USDA-Platzhalter | fehlt |
| monster02 | USDA-Platzhalter | fehlt |
| monster03 | USDA-Platzhalter | fehlt |
| monster04 | USDA-Platzhalter | fehlt |

---

## Offene Punkte / Risiken

- Finale Sound-Dateien müssen bereitgestellt werden (aktuelle Sounds sind Platzhalter — gleiche Dateinamen, einfacher Austausch).
- Build / Simulator-Abnahme nach Modul 010 noch offen.
- AK-08 / AK-09 / AK-10 Gestenprüfung noch offen.
- Finale Blender-Monster fehlen.
- `.DS_Store`-Bereinigung bleibt offen.
- AudioService initialisiert `AVAudioPlayer` ohne `AVAudioSession`-Kategorie. Falls auf visionOS kein Sound hörbar ist, muss geprüft werden, ob eine explizite Session-Konfiguration notwendig ist.

---

## Bereitgestellte Schnittstellen (für Folgemodule)

- `SessionModel.score` — akkumulierter Punktestand der Sitzung (für Modul 011)
- `SessionModel.sessionTickets` — vollständige Ticketliste für Statistik (für Modul 011)
- `SessionModel.currentTicketIndex` — Fortschritt (für Modul 011)
- `GamePhase.ergebnis` — wird nach letztem Teamfeedback gesetzt

---

## Git

- **Commit:** `010: Bewertung und Audiofeedback`
- **Hash:** `0ab0ef7`

---

## Stand aktualisiert

- [ ] `Projekt-Stand.md` neu erzeugt und ersetzt
- [ ] `Logbuch-Stand.md` aktualisiert
- [x] Neue Dateien im Projekt-Stand dokumentiert

---

## Empfehlung für Modul 011

Modul 011 implementiert die Ergebnisansicht für `GamePhase.ergebnis`. Verfügbar sind: `score`, `sessionTickets`, `currentTicketIndex`. Die Ergebnisansicht soll Score, Ticketanzahl und eine „Erneut spielen"-Schaltfläche zeigen, die `reset()` aufruft und zur Startansicht zurückführt. Optional: eine einfache Ticket-für-Ticket-Statistik (ohne die richtigen Lösungen zu zeigen).
