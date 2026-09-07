# Modul-Eingangsprompt — 029 Monster- und Streak-Audio

> Vom **Projektlogbuch** nach Einarbeitung des `028-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 029.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**.

# Modul

**Nummer:** 029  
**Titel:** Monster- und Streak-Audio  
**Erfüllt:** F-12, F-34, F-35, F-39 / AK-12, AK-34, AK-35 sowie Audio-Anteil von AK-39

**Ziel:** Integriere die acht bereitgestellten Monster-Feedbacksounds und die zwei bereitgestellten Streak-Sounds als lokale, zentral gemappte Audioressourcen. Nach jeder gültigen Prioritäts- oder Teamentscheidung wird genau ein zufälliger Sound aus der passenden 4er-Gruppe gespielt; die Auswahl muss deterministisch testbar sein und direkte Wiederholungen erlauben. Für spätere Streak-Integration wird ein zentrales Mapping bereitgestellt: Sound 01 für x2/x3, Sound 02 für x4+. Modul 029 führt noch keinen fachlichen Streak-State und kein Multiplikator-Scoring ein.

---

# Ausgangsstand

v1.0, v1.1 und v1.2 sind abgeschlossen.

v1.3:

- Modul 027 committed
- Modul 028 implementiert

Laut `028-Report.md`:

- Branch: `v1.3`
- HEAD vor 028: `72d3e0470a7a7ba9591733a5ce0c42e6191b6087`
- tatsächlicher Modul-027-Commit: `72d3e04` (`feat: Modul 27`)
- Modul-028-Commit im Report noch offen
- reale Tests vor 028: 340
- reale Tests nach 028: **369**
- Build/Test/Simulator: OPEN, Apple-Toolchain nicht vorhanden

Wichtig:

Der `027-Report.md` hatte 372 Tests genannt. Der reale Commit `72d3e04` enthielt vor Modul 028 aber 340. Für Modul 029 ist **369** der dokumentierte aktuelle Quellstand, sofern der reale Preflight nichts anderes zeigt.

---

# Vorab-Gate

## 1. Git

Ermittle real:

- Branch
- HEAD
- tatsächlichen Modul-028-Commit
- Working Tree
- staged/untracked Dateien

Wenn Modul 028 inzwischen committed ist:

- echten Hash dokumentieren.

Wenn 028 noch uncommitted ist:

- Logo-Diff klar vom Audio-Diff trennen,
- keine Teamlogo-Dateien unnötig anfassen,
- nach Möglichkeit 028 separat committen.

Keine Hashes erfinden.

## 2. Reale Testzahl

Dokumentierter Ausgangswert:

**369 `@Test`-Deklarationen**

Real zählen.

Bei Abweichung:

- reale Zahl verwenden,
- Ursache dokumentieren.

## 3. Bestehende Audioarchitektur vollständig lesen

Mindestens:

- `Services/AudioService.swift`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Support/AppConstants.swift`
- `Models/SessionModel.swift`
- `Views/Components/DecisionFeedbackView.swift`
- `Resources/`
- Tests für Scoring, Audio, Exactly-once und Feedback

Suche projektweit nach:

- `correct.wav`
- `incorrect.wav`
- `playCorrect`
- `playIncorrect`
- `playFeedback`
- `AVAudioPlayer`
- `AudioService`
- `FeedbackConstants`
- `.audio` Debuglogs

Dokumentiere die reale aktuelle API, statt historische Signaturen anzunehmen.

---

# Audio-Assetinventar — vor jeder Codeänderung

Suche vollständig nach allen bereitgestellten:

- `.wav`
- `.WAV`

insbesondere in möglichen Ordnern wie:

- `MonsterSounds`
- `Monstersounds`
- `Moonstersounds`
- `StreakSounds`
- `Streaksounds`
- `Audio`
- v1.3-Assetordnern

Exakte Dateinamen **nicht erfinden**.

Erstelle:

## Monster Correct

| Nr. | Quelldatei | Format | Größe | technisch valide |
|---|---|---|---:|---|
| 1 | | WAV | | |
| 2 | | WAV | | |
| 3 | | WAV | | |
| 4 | | WAV | | |

## Monster Incorrect

| Nr. | Quelldatei | Format | Größe | technisch valide |
|---|---|---|---:|---|
| 1 | | WAV | | |
| 2 | | WAV | | |
| 3 | | WAV | | |
| 4 | | WAV | | |

## Streak

| Zweck | Quelldatei | Format | Größe | technisch valide |
|---|---|---|---:|---|
| 01 — x2/x3 | | WAV | | |
| 02 — x4+ | | WAV | | |

Es müssen exakt:

- 4 Correct
- 4 Incorrect
- 2 Streak

bereitgestellte Sounds identifiziert werden.

Wenn Dateien fehlen oder Zuordnung unklar ist:

- keine eigenen Ersatzsounds erzeugen,
- keinen alten Platzhalter still als neuen Sound deklarieren,
- im Report OPEN dokumentieren.

---

# F-12 — Monster-Feedbacksounds

Nach jeder **gültigen** Einzelentscheidung:

## richtig

Genau ein Sound aus der Correct-Gruppe.

## falsch

Genau ein Sound aus der Incorrect-Gruppe.

## ungültiger Drop

Kein Bewertungssound.

Keine doppelte Soundausgabe bei Exactly-once-gesperrter Mehrfacheingabe.

---

# F-34 — 4+4 zufällige Monster-Soundvarianten

Die acht neuen Monster-Feedbacksounds werden lokal strukturiert.

Bei jeder gültigen Einzelentscheidung:

- richtige Entscheidung → zufällig 1 von 4 Correct
- falsche Entscheidung → zufällig 1 von 4 Incorrect
- exakt ein Monster-Sound
- direkte Wiederholung derselben Variante ist erlaubt

**Keine Anti-Wiederholungslogik.**

Nicht:

```text
wenn letzter Sound == neu → nochmal würfeln
```

Die SPEC erlaubt direkte Wiederholung ausdrücklich.

---

# F-35 — Streak-Sounds

Zwei zusätzliche lokale Sounds:

- Streak-Sound 01 → x2 und x3
- Streak-Sound 02 → x4 und höher
- Streak 0/1 → kein Streak-Sound
- niemals bei Prioritätsentscheidung
- höchstens ein Streak-Sound je qualifiziertem Teamabschluss

## Wichtige Modulgrenze

Der fachliche `streak`-State entsteht erst in Modul 031.

Die produktive Teamabschluss-Visualisierung und der tatsächliche Streak-Soundtrigger werden in Modul 032 mit dem realen Streak-State verdrahtet.

Deshalb soll Modul 029 **jetzt**:

1. beide Streak-WAVs integrieren,
2. zentrales Mapping `streak -> Sound 01 / Sound 02 / nil` bereitstellen,
3. Playback-Schnittstelle bereitstellen,
4. die Semantik deterministisch testen,

aber **nicht**:

- `SessionModel.streak` hinzufügen,
- Streak verändern,
- Teamabschluss fachlich neu bewerten,
- Multiplikator berechnen,
- x2/x3/x4-Overlay anzeigen,
- den Streak-Sound anhand erfundener lokaler View-Streakwerte produktiv triggern.

AK-35 ist nach Modul 029 daher in zwei Teile zu unterscheiden:

- Ressourcen/Mapping/API: kann PASS sein,
- realer produktiver Teamabschluss-Trigger: bleibt bis Modul 031/032 OPEN.

---

# F-39 — Audio-Ressourcenstruktur

Zielstruktur:

```text
Ticket_Tamer/Ticket_Tamer/Resources/
└── Audio/
    ├── MonsterSounds/
    │   ├── Correct/
    │   │   ├── <reale Datei 1>.wav
    │   │   ├── <reale Datei 2>.wav
    │   │   ├── <reale Datei 3>.wav
    │   │   └── <reale Datei 4>.wav
    │   └── Incorrect/
    │       ├── <reale Datei 1>.wav
    │       ├── <reale Datei 2>.wav
    │       ├── <reale Datei 3>.wav
    │       └── <reale Datei 4>.wav
    └── StreakSounds/
        ├── <reale Sound-01-Datei>.wav
        └── <reale Sound-02-Datei>.wav
```

Oder eine funktional gleichwertige, klar getrennte lokale Struktur, wenn das reale Xcode-Projekt dies erfordert.

Keine:

- Netzwerk-URLs
- absolute Entwicklerpfade
- verstreuten Dateipfade in Views

---

# Historische v1.0-Platzhaltersounds

Historisch existierten:

- `correct.wav`
- `incorrect.wav`

Diese waren einfache Projekt-Platzhalter.

Modul 029 muss projektweit prüfen, ob sie noch produktiv referenziert werden.

Nach v1.3-Audioumstellung:

- produktive Entscheidungen müssen die neuen 4er-Gruppen verwenden,
- alte Einzel-Platzhaltersounds dürfen nicht still weiter produktiv gespielt werden.

Wenn die alten Dateien anschließend vollständig unreferenziert sind:

- dürfen sie sauber entfernt werden,
- Entfernung im Report dokumentieren.

Wenn sie noch für historische Tests/Fixtures benötigt werden:

- nicht blind löschen,
- klar als nicht-produktive Altressource klassifizieren.

Keine parallele produktive Audiosemantik.

---

# Zentrale Audioressourcen-Zuordnung

Views dürfen keine Dateinamenlisten verwalten.

Bevorzuge einen zentralen Katalog, z. B.:

```text
MonsterFeedbackSoundCatalog
- correct: [AudioResource]
- incorrect: [AudioResource]

StreakSoundCatalog
- sound01
- sound02
- resource(forStreak:)
```

oder semantisch gleichwertig.

Eine Ressource kann enthalten:

```text
resourceName
fileExtension
subdirectory
```

Keine fachlichen Ticket-/Teamdaten.

---

# Monster-Sound-Auswahl deterministisch testbar

Produktiv:

zufällige Auswahl.

Tests:

injizierbare Auswahlfunktion.

Sinngemäß:

```text
selectMonsterSound(
    from candidates: [AudioResource],
    using selector: ([AudioResource]) -> AudioResource?
)
```

oder:

```text
AudioService.playMonsterFeedback(
    result: .correct,
    selector: ...
)
```

Die konkrete API soll zur bestehenden Architektur passen.

Verbindlich:

- Selector kann jede der vier Varianten gezielt auswählen,
- Correct und Incorrect getrennt,
- kein global schwer testbarer Random-State,
- keine Anti-Wiederholungslogik.

---

# Genau ein Monster-Sound pro Entscheidung

Bestehender Feedbackflow bleibt maßgeblich.

Prüfe in:

- `PrioritizationView`
- `TeamAssignmentView`

wie Sound heute ausgelöst wird.

Modul 029 darf den bestehenden einzelnen Audioaufruf **ersetzen**, aber keinen zweiten parallelen Entscheidungs-Task hinzufügen.

Ziel:

```text
gültige Bewertung
→ Bool-Ergebnis
→ genau ein Monster-Sound auswählen
→ genau einmal abspielen
→ bestehendes visuelles Feedback
→ bestehender Transition-Flow
```

Nicht:

```text
alter correct.wav-Aufruf
+ neuer Varianten-Aufruf
```

sonst doppelte Ausgabe.

---

# Exactly-once schützen

Unverändert:

- `feedbackTaskStarted`
- `isInputLocked`
- `evaluatePriority()`
- `evaluateTeam()`
- Phasenwechsel

Schnelles Mehrfach-Pinchen darf weiterhin nur erzeugen:

- 1 Bewertung
- 1 Monster-Sound
- 1 visuelles Feedback
- 1 Transition

Monster-Soundzufall darf keine neue Bewertung auslösen.

---

# AudioService

Behalte die zentrale Service-Verantwortung.

Nicht Soundlogik direkt in Views verteilen.

Geeignete Verantwortungen:

```text
AudioService
- Bundle-Ressource auflösen
- Player erzeugen/halten
- Monster-Feedbacksound spielen
- Streak-Sound spielen
```

Katalog/Mapping:

separat oder als klar abgegrenzte statische Struktur.

---

# Player-Lebensdauer

Prüfe die aktuelle `AVAudioPlayer`-Architektur.

Sicherstellen:

- Player lebt lang genug für vollständige Wiedergabe,
- pro Monsterentscheidung genau ein Playerstart,
- neuer Monster-Sound darf den vorgesehenen neuen Feedbacksound korrekt starten.

Für Streak:

Spätere Anforderung aus AK-35:

positiver Monster-Sound und zusätzlicher Streak-Sound sollen leicht zeitversetzt beziehungsweise nacheinander laufen, nicht versehentlich exakt gleichzeitig doppelt losgehen.

Modul 029 soll die Service-API so vorbereiten, dass Modul 032 dies sauber steuern kann.

Keine invasive Audioengine nötig, sofern `AVAudioPlayer` ausreicht.

---

# Streak-Sound-Mapping

Zentrale reine Semantik:

```text
streak <= 1 → nil
streak == 2 → sound01
streak == 3 → sound01
streak >= 4 → sound02
```

Kein künstlicher Cap.

Tests auch:

- 4
- 5
- 16
- optional größer als 16 defensiv → sound02

Keine Team-/Priority-Information nötig.

---

# Priorität darf niemals Streak-Sound triggern

Modul 029 soll **keinen** Streak-Sound-Aufruf in `PrioritizationView` hinzufügen.

Die Prioritätsphase spielt ausschließlich:

- Correct-Monster-Sound
oder
- Incorrect-Monster-Sound

Genau einen.

---

# Teamphase in Modul 029

Die Teamentscheidung spielt aktuell ebenfalls genau einen Monster-Sound.

Das bleibt so.

Noch **kein produktiver Streak-Sound-Aufruf**, solange der zentrale Streak-State aus Modul 031 fehlt.

Nur API/Katalog für Modul 032 vorbereiten.

---

# Soundvalidierung

Für alle zehn WAV-Dateien soweit lokal möglich prüfen:

- Datei existiert
- > 0 Byte
- WAV-Signatur/Ressourcentyp
- eindeutige Datei
- Quelle/Ziel identischer Hash nach Kopie
- keine Netzwerkabhängigkeit

Optional technische Metadaten dokumentieren:

- Samplingrate
- Kanäle
- Bit-Tiefe
- Dauer

Nur wenn zuverlässig auslesbar.

Keine Qualitätsurteile erfinden.

---

# Monster-Sounds und verständliche Sprache

Die SPEC fordert für Monster-Sounds:

- keine verständliche Sprache.

Wenn die bereitgestellten **Monster-Feedbacksounds** erkennbare Sprache enthalten:

- nicht selbst neu produzieren,
- im Report als Konflikt mit NFR dokumentieren.

Diese Einschränkung nicht automatisch auf die separat bereitgestellten Streak-Sounds übertragen, wenn die Quelle dies nicht verlangt.

---

# DebugManager

Bestehende Kategorie:

`.audio`

verwenden.

Sinnvolle Logs:

- ausgewählte Monster-Soundressource
- correct/incorrect Gruppe
- Ressourcenfehler
- Streak-Soundressource bei direktem Service-Test

Nicht loggen:

- Referenzlösung
- unnötige Ticketinhalte

Kein Renderframe-Spam.

---

# Fehlende Ressource

Audio-Ladefehler darf die Sitzung nicht crashen.

Bei fehlender Sounddatei:

- Bewertung bleibt gültig,
- Score bleibt korrekt,
- Feedbackflow geht weiter,
- Phase wechselt weiter,
- Fehler loggen.

Audio ist Feedback, nicht fachlicher Gatekeeper.

Nicht:

- Entscheidung rückgängig machen
- Input dauerhaft gesperrt lassen
- Crash/force unwrap

---

# Schutz Modul 028

Nicht verändern:

- `TeamLogoCatalog`
- JPEG-Dateien
- TeamAttachment-Darstellung
- Teamtext
- Panel-/Dropgeometrie
- Fallback

---

# Schutz Modul 027

Nicht verändern:

- TT-001...TT-016
- 1...16-Auswahl
- `videoAssetName`
- Tickettexte
- Referenzmatrix
- Monsterzuordnung

---

# Schutz v1.2

Nicht verändern:

- Replay-Root
- `X Punkte`
- `0 Punkte`/`+100 Punkte`
- Debug-UI-Isolation
- Monster-Farbvarianten
- Monster-Retry
- 50-%-Drop
- Snapback
- Exactly-once

---

# Harte Modulgrenze

Modul 029 implementiert **nicht**:

## Modul 030
- keine Videoansicht
- kein AVKit
- keine MP4-Umsortierung

## Modul 031
- kein `streak` im SessionModel
- keine Streak-Mutation
- kein `currentPriorityWasCorrect`
- kein Multiplikator-Scoring
- keine Team-Differenzgutschrift

## Modul 032
- kein x2/x3/x4+-Overlay
- keine Streak-Pulsanimation
- noch keine produktive Teamabschluss-Verdrahtung des Streak-Sounds

---

# Automatisierte Tests

Ausgangswert laut 028-Report:

**369 Testdeklarationen**

Reale Zahl im Preflight prüfen.

Ergänze mindestens Tests für:

## Ressourcen-Katalog

1. Correct-Gruppe exakt 4.
2. Incorrect-Gruppe exakt 4.
3. Streak-Gruppe exakt 2.
4. insgesamt 10 v1.3-Audioressourcen.
5. alle Ressourcennamen nicht leer.
6. alle Endungen WAV.
7. keine HTTP-/HTTPS-Pfade.
8. keine absoluten Entwicklerpfade.
9. Correct-Dateien unter Correct-Struktur.
10. Incorrect-Dateien unter Incorrect-Struktur.
11. Streak-Dateien unter Streak-Struktur.

## Monster-Auswahl

12. Correct-Selector kann Variante 1 erzwingen.
13. Correct Variante 2.
14. Correct Variante 3.
15. Correct Variante 4.
16. Incorrect Variante 1.
17. Incorrect Variante 2.
18. Incorrect Variante 3.
19. Incorrect Variante 4.
20. direkte Wiederholung derselben Correct-Variante zulässig.
21. direkte Wiederholung derselben Incorrect-Variante zulässig.
22. keine Anti-Repeat-Logik.

## Bewertungs-Mapping

23. `true` → Correct-Gruppe.
24. `false` → Incorrect-Gruppe.
25. ungültiger/nil-Bewertungsfall → kein Monster-Sound.
26. Prioritätsentscheidung verwendet nur Monster-Sound.
27. Teamentscheidung verwendet zunächst ebenfalls genau einen Monster-Sound.

## Streak-Mapping

28. 0 → nil.
29. 1 → nil.
30. 2 → Sound 01.
31. 3 → Sound 01.
32. 4 → Sound 02.
33. 5 → Sound 02.
34. 16 → Sound 02.
35. kein künstlicher Cap.

## Fehlerrobustheit

36. fehlende Monster-Audiodatei mutiert keinen Score.
37. fehlende Audiodatei verändert keine Phase fachlich.
38. Audiofehler verändert keine ausgewählte Priorität.
39. Audiofehler verändert kein ausgewähltes Team.

## Regression

40. Exactly-once-Tests bleiben.
41. correct/incorrect Scoring bleibt.
42. Feedback-Mapping bleibt.
43. 1.5-s-Transitionkonstante bleibt unverändert, sofern Modul 029 sie nicht fachlich anfassen muss.

Keine künstliche neue Architektur nur zur Erhöhung der Testzahl.

---

# Statische Abschlussprüfung

Projektweit suchen nach historischen produktiven Referenzen auf:

- `correct.wav`
- `incorrect.wav`

Jede verbleibende Referenz klassifizieren.

Ziel:

Produktiver Bewertungsflow verwendet ausschließlich den neuen v1.3-Monster-Soundkatalog.

Prüfe außerdem:

- keine Audio-Dateipfade in `PrioritizationView`
- keine Audio-Dateipfade in `TeamAssignmentView`
- keine Audio-Dateipfade in `SessionModel`

---

# Simulatorprüfung

Wenn Xcode verfügbar:

## Correct-Monster-Sounds

Deterministisch oder über Debug/Test-Hook nacheinander alle vier Varianten prüfen.

Mindestens:

- richtige Priorität
- richtiges Team

Alle vier müssen ladbar/hörbar sein.

## Incorrect-Monster-Sounds

Alle vier Varianten prüfen für:

- falsche Priorität
- falsches Team

## Exactly-once

Schnelles Mehrfach-Pinchen:

- genau ein Monster-Sound

## Direkte Wiederholung

Dieselbe Variante zweimal hintereinander darf funktionieren.

Kein Anti-Repeat.

## Ungültiger Drop

- kein Bewertungssound.

## Audiofehler

Kontrolliert fehlende Ressource simulieren:

- kein Crash
- Bewertung/Flow bleibt intakt.

## Streak-Sounds

Da Modul 031/032 noch nicht umgesetzt sind:

- beide Streak-Soundressourcen direkt über Service/Test-Hook ladbar/hörbar prüfen,
- Mapping 2/3→01 und 4+→02 automatisiert prüfen,
- **nicht** behaupten, der echte Teamabschluss-Streaktrigger sei bereits produktiv abgenommen.

---

# Voraussichtlich relevante Dateien

Zuerst real ermitteln.

Wahrscheinlich:

- `Services/AudioService.swift`
- neue Audio-Katalogdatei unter `Services/`, `Assets/` oder `Support/`
- `Views/PrioritizationView.swift`
- `Views/TeamAssignmentView.swift`
- `Support/AppConstants.swift` nur falls Audio-Konstanten dort zentral liegen
- `Resources/Audio/MonsterSounds/Correct/*.wav`
- `Resources/Audio/MonsterSounds/Incorrect/*.wav`
- `Resources/Audio/StreakSounds/*.wav`
- Tests

Nach Möglichkeit unverändert:

- `SessionModel.swift`
- `TeamLogoCatalog.swift`
- `LocalTicketCatalog.swift`
- `Ticket.swift`
- `TargetPanelLayout.swift`
- `DropEvaluator.swift`
- `MonsterAssetProvider.swift`
- `ResultView.swift`
- `RootVolumeView.swift`

---

# Git

Vor Modul 029:

Modul 028 separat committen, falls noch offen.

Vorgesehen:

`028: Teamlogos v1.3`

Modul 029:

`029: Monster- und Streak-Audio`

Vor Commit:

- vollständige Ressourcenzählung 4+4+2
- Audio-Katalogtests
- Auswahltests
- Streak-Mappingtests
- Build wenn möglich
- vollständige Tests
- Simulator-/Hörprüfung wenn möglich
- projektweite Alt-Sound-Suche
- `git diff --check`
- Scope-Diff

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 028-Commit
- Working Tree
- reale Testzahl
- Build/Test/Simulatorstatus
- bestehende AudioService-API

## 2. Audio-Inventar

### Correct

| Nr. | Quelle | Zielpfad | Format | Größe |
|---|---|---|---|---|

### Incorrect

| Nr. | Quelle | Zielpfad | Format | Größe |
|---|---|---|---|---|

### Streak

| Mapping | Quelle | Zielpfad | Format | Größe |
|---|---|---|---|---|

## 3. Audioarchitektur

- MonsterSoundCatalog
- StreakSoundCatalog
- Selector
- AudioService
- Bundle-Lookup
- Fehlerfall

## 4. Entscheidungsflow

```text
gültige Einzelentscheidung
→ Bewertung
→ Correct/Incorrect
→ 1 von 4 auswählen
→ genau 1 Monster-Sound
→ bestehender Feedback-/Transitionflow
```

## 5. Streak-Mapping

| Streak | Sound |
|---:|---|
| 0 | keiner |
| 1 | keiner |
| 2 | 01 |
| 3 | 01 |
| 4+ | 02 |

Explizit dokumentieren:

Produktiver Teamabschluss-Trigger folgt erst in Modul 032 nach Einführung des Streak-State in Modul 031.

## 6. Historische Sounds

- `correct.wav`
- `incorrect.wav`

Für jede Datei:

- verbleibt?
- entfernt?
- noch referenziert?
- warum?

## 7. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 8. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 9. Simulator-/Audioprüfung

- 4 Correct
- 4 Incorrect
- direkte Wiederholung
- ungültiger Drop
- Exactly-once
- Audiofehler
- Streak-Sound 01 direkt
- Streak-Sound 02 direkt

## 10. Vollständiger `029-Report.md`

Der Report muss ausdrücklich enthalten:

- realen Gitstand
- tatsächlichen 028-Commit
- reale Testzahl
- exakte Dateinamen aller 10 WAV-Dateien
- ursprüngliche Quellpfade
- finale produktive Zielpfade
- Correct-/Incorrect-Katalog
- Streak-Sound-Mapping
- finale Selector-Schnittstelle
- Bestätigung: genau ein Monster-Sound pro gültiger Einzelentscheidung
- Bestätigung: direkte Wiederholung erlaubt
- Bestätigung: keine Anti-Repeat-Logik
- Bestätigung: ungültiger Drop ohne Bewertungssound
- Bestätigung: keine Sounddateipfade in Views/SessionModel
- Status der alten `correct.wav`/`incorrect.wav`
- Bestätigung: kein Streak-State/Scoring vorgezogen
- AK-12 PASS/OPEN/FAIL
- AK-34 PASS/OPEN/FAIL
- AK-35 Ressourcen/Mapping PASS/OPEN/FAIL
- AK-35 produktiver Trigger OPEN bis Modul 031/032, sofern noch nicht real möglich
- AK-39 Audio-Anteil PASS/OPEN/FAIL
- Build/Test/Simulatorstatus
- offene Risiken
- Empfehlung für **Modul 030 — Ticketvideo-System**

Baue nichts außerhalb dieses Moduls um.
