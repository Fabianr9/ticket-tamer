# Modul-Eingangsprompt — 027 Neue Ticketdaten und 16er-Sitzung

> Vom Projektlogbuch zum Start von Ticket Tamer v1.3 erzeugt. In einen neuen Modul-Chat einfügen.

Du bist Fachentwickler:in für genau dieses eine Modul.

## Modul

**Nummer:** 027  
**Titel:** Neue Ticketdaten und 16er-Sitzung  
**Erfüllt:** F-01, F-02, F-03, F-04, F-22, F-31 / AK-01, AK-02, AK-03, AK-04, AK-22, AK-31

**Ziel:** Ersetze den bisherigen Ticketinhalt vollständig durch die 16 bereitgestellten v1.3-Tickets TT-001 bis TT-016 aus `Tickets/Ticket-Tamer_Tickets.md`, sichere die verbindliche Referenzverteilung und erweitere Start-/Sitzungsauswahl sauber auf 1...16. Standardwert 6 bleibt. Video-UI, Logos, neue Sounds und Streak-System nicht vorziehen.

---

# Vorab-Check

Da kein finaler `026-Report.md` im Logbuch eingearbeitet wurde, zuerst real ermitteln:

- Branch
- HEAD
- finalen v1.2-Abschlusscommit
- Working Tree
- tatsächliche aktuelle `@Test`-Zahl
- Build-/Teststatus
- Xcode/visionOS-Konfiguration

Keine alten Werte oder Hashes erfinden.

Lies mindestens:

- `Models/Ticket.swift`
- `Models/SessionModel.swift`
- lokalen Ticketkatalog
- `Views/StartView.swift`
- `Support/AppConstants.swift`
- Tests
- alle Stellen mit Grenze 12 / `1...12`

---

# Verbindliche Inhaltsquelle

Suche und lies vollständig:

`Tickets/Ticket-Tamer_Tickets.md`

Diese Datei ist die einzige verbindliche Quelle für:

- Titel
- Kurzbeschreibung
- User Impact
- Symptome/Hinweise

von TT-001 bis TT-016.

Nicht:

- alte Inhalte fortschreiben
- Tickettexte erfinden
- Quelltexte still umformulieren
- Markdown zur Laufzeit parsen

Wenn die Datei fehlt, das Modul nicht mit erfundenen Inhalten abschließen.

---

# Ticketmatrix

TT-001 bis TT-012 behalten die bestehende 4×3-Referenzmatrix:

| Team | Normal | Wichtig | Kritisch |
|---|---|---|---|
| Netzwerk | TT-001 | TT-002 | TT-003 |
| Konto | TT-004 | TT-005 | TT-006 |
| Software | TT-007 | TT-008 | TT-009 |
| Hardware | TT-010 | TT-011 | TT-012 |

Zusätzlich verbindlich:

- TT-013 → Netzwerk + Wichtig
- TT-014 → Konto + Normal
- TT-015 → Software + Wichtig
- TT-016 → Hardware + Kritisch

Gesamt:

- Netzwerk 4
- Konto 4
- Software 4
- Hardware 4
- Normal 5
- Wichtig 6
- Kritisch 5

Automatisiert prüfen.

---

# Ticketmodell

Jedes Ticket benötigt:

- ticketNumber
- title
- shortDescription
- userImpact
- 1...3 symptoms
- referencePriority
- referenceTeam
- Monsterzuordnung
- genau eine Video-Referenz

Video-Mapping:

```text
TT-001 → TT-001.mp4
...
TT-016 → TT-016.mp4
```

Falls im aktuellen `Ticket` noch kein Feld existiert, minimal ergänzen:

```swift
videoAssetName: String
```

Nur Datenreferenz. Keine Wiedergabelogik in Modul 027.

---

# Auswahlbereich 1...16

Aktualisiere alle relevanten Grenzen konsistent:

- Slider 1...16
- technische Clamp 1...16
- Plus/Minus
- Sessionauswahl
- Tests

Standard bleibt 6.

Grenzen:

- bei 1 Minus disabled
- bei 16 Plus disabled

Bevorzuge zentrale Konstanten statt verteilter Magic Numbers.

---

# Sitzungsauswahl

Beim Start mit n:

- genau n Tickets
- 1 ≤ n ≤ 16
- keine Ticket-ID doppelt
- Auswahl aus genau 16 produktiven Tickets

Mehrere Sitzungen dürfen unterschiedliche Reihenfolgen/Auswahlen erzeugen.

Die bestehende v1.2-Monster-Variantenauswahl muss weiterhin für jedes gewählte Ticket genau eine Variante erzeugen.

---

# Reset

Unverändert korrekt:

- selectedTicketCount = 6
- score = 0
- currentTicketIndex = 0
- Entscheidungen nil
- sessionTickets leer
- input lock frei
- Monster-Variantenmapping leer

Streak-State noch nicht in Modul 027 implementieren.

---

# Untersuchung / Ticketinfo / HUD

Prüfe, dass TT-001 bis TT-016 ohne zusätzliche Sonderlogik funktionieren:

- Investigation zeigt neuen Quellinhalt
- Ticketinfo zeigt denselben aktuellen Datensatz
- HUD kann `Ticket X von 16`
- keine Referenzlösung sichtbar

Keine hardcodierte Annahme `<= 12`.

---

# Monsterzuordnung

Bestehende Monstertypzuordnung nicht unnötig neu aufbauen.

Die konkrete Farbvariante bleibt v1.2-Sitzungslogik und darf nicht fest im Ticketinhalt kodiert werden.

Keine Team-/Prioritätscodierung über Monster oder Farbe.

---

# Harte Modulgrenze

Nicht implementieren:

- Modul 028: JPEG-Teamlogos
- Modul 029: neue Monster-/Streak-Sounds
- Modul 030: VideoPlayer, AVKit, `Video ansehen`
- Modul 031: Streak-State oder Multiplikator-Scoring
- Modul 032: x2/x3/x4-Overlay/Animation

Geschützt bleiben:

- Replay-Root
- `X Punkte`
- `0 Punkte` / `+100 Punkte`
- Debug-UI-Isolation
- Dropgeometrie
- 50-%-Overlap
- Z-Toleranz
- Snapback
- Exactly-once
- Monster-Farbvarianten
- Retry derselben Variante

---

# Tests

Reale Ausgangszahl im Preflight ermitteln.

Mindestens abdecken:

1. exakt 16 Tickets
2. IDs exakt TT-001...TT-016
3. IDs eindeutig
4. je Ticket 1...3 Symptome
5. vollständige Pflichtfelder
6. Video-Mapping TT-xxx.mp4
7. TT-001...TT-012 4×3-Matrix
8. TT-013 Netzwerk/Wichtig
9. TT-014 Konto/Normal
10. TT-015 Software/Wichtig
11. TT-016 Hardware/Kritisch
12. Teams 4/4/4/4
13. Prioritäten 5/6/5
14. Auswahl 1
15. Auswahl 6
16. Auswahl 16
17. keine Wiederholung
18. Clamp >16 → 16
19. Clamp <1 → 1
20. Plus 15→16
21. Plus bei 16 disabled
22. Minus 2→1
23. Minus bei 1 disabled
24. Slider akzeptiert 16
25. Reset → 6
26. neue Ticketinhalte entsprechen der Markdown-Quelle
27. alte historische Tickettexte sind nicht mehr produktiv
28. Session mit 16 Tickets erzeugt weiter 16 Monster-Variantenzuordnungen
29. Reset leert Variantenmapping

---

# Report-Tabelle

Erstelle für alle 16:

| ID | Titel | Priorität | Team | MonsterType | Video |
|---|---|---|---|---|---|

Titel aus der realen Markdown-Quelle.

Keine langen Beschreibungen unnötig im Report duplizieren.

---

# Simulatorprüfung

- Startwert 6
- Slider 1...16
- Plus/Minus-Grenzen
- Sitzung mit 16 Tickets
- HUD `Ticket 1 von 16` bis `Ticket 16 von 16`
- keine Wiederholung
- Stichproben TT-001, TT-007, TT-013, TT-016 gegen Quelltext
- Ticketinfo mit neuen Inhalten
- keine Referenzlösung
- Reset auf 6
- v1.2 Replay-/Punkte-/Monsterfarben-Regression

---

# Git

Vorgesehener Commit:

`027: Neue Ticketdaten und 16er-Sitzung`

Vor Commit:

- Build
- vollständige Tests
- 16er-Katalogprüfung
- Matrixprüfung
- Startsteuerung 1...16
- Simulatorprüfung
- `git diff --check`
- Scope-Diff

Keine Hashes erfinden.

---

# Vollständiger `027-Report.md`

Der Report muss enthalten:

- realen Gitstand
- finalen v1.2-Abschlusscommit
- reale Testzahl
- tatsächlichen Pfad zur Ticket-Markdown-Datei
- genau TT-001 bis TT-016
- Bestätigung: alte Tickettexte vollständig ersetzt
- Referenzmatrix TT-001...TT-012
- Referenzen TT-013...TT-016
- Teamverteilung 4/4/4/4
- Prioritäten 5/6/5
- Ticketanzahl 1...16
- Standard/Reset 6
- Video-Referenz TT-xxx.mp4 pro Ticket
- Bestätigung: keine Video-UI vorgezogen
- Bestätigung: keine Audio-/Streak-/Logo-Arbeit vorgezogen
- Monster-Farbvariantenregression
- Build/Test/Simulatorstatus
- AK-01, AK-02, AK-03, AK-04, AK-22 und AK-31 jeweils PASS/OPEN/FAIL
- offene Risiken
- Empfehlung für **Modul 028 — Teamlogos v1.3**

Baue nichts außerhalb dieses Moduls um.
