# Modul-Report 029 — Monster- und Streak-Audio

## 1. Vorab-Check

- Branch: `v1.3`
- HEAD vor Modul 029: `120ab6d3bf48533521a46cf7524fa3caedc87483`
- Modul-028-Commit: `120ab6d` (`feat: Modul 28`)
- Working Tree vor Modul 029: geänderte Stand-Dokumentation und untracked `029-Eingangsprompt.md`; kein offener Modul-028-Code
- Reale Testzahl vor Modul 029: 401 `@Test`-Deklarationen (statt der im Eingangsprompt erwarteten 369; der reale Modul-028-Commit enthält 401)
- Xcode, Swift-Toolchain und Simulator: auf dieser Plattform nicht vorhanden; Build, Testlauf und Hörprüfung OPEN
- Bisherige API: `AudioService.play(_:)` mit je einem vorgeladenen `correct.wav`-/`incorrect.wav`-Player

## 2. Audio-Inventar

Alle Quellen und Ziele sind valide RIFF/WAVE-Dateien, PCM 16 Bit, Stereo, 48 kHz. Quelle und Ziel besitzen jeweils denselben SHA-256-Hash.

### Correct

| Nr. | Quelle | Zielpfad | Größe |
|---:|---|---|---:|
| 1 | `Monstersounds/Richtige Zuweisung/01.wav` | `Resources/Audio/MonsterSounds/Correct/monster_correct_01.wav` | 192078 B |
| 2 | `Monstersounds/Richtige Zuweisung/02.wav` | `Resources/Audio/MonsterSounds/Correct/monster_correct_02.wav` | 192078 B |
| 3 | `Monstersounds/Richtige Zuweisung/03.wav` | `Resources/Audio/MonsterSounds/Correct/monster_correct_03.wav` | 192078 B |
| 4 | `Monstersounds/Richtige Zuweisung/04.wav` | `Resources/Audio/MonsterSounds/Correct/monster_correct_04.wav` | 192078 B |

### Incorrect

| Nr. | Quelle | Zielpfad | Größe |
|---:|---|---|---:|
| 1 | `Monstersounds/Falsche Zuweisung/01.wav` | `Resources/Audio/MonsterSounds/Incorrect/monster_incorrect_01.wav` | 92238 B |
| 2 | `Monstersounds/Falsche Zuweisung/02.wav` | `Resources/Audio/MonsterSounds/Incorrect/monster_incorrect_02.wav` | 92238 B |
| 3 | `Monstersounds/Falsche Zuweisung/03.wav` | `Resources/Audio/MonsterSounds/Incorrect/monster_incorrect_03.wav` | 92238 B |
| 4 | `Monstersounds/Falsche Zuweisung/04.wav` | `Resources/Audio/MonsterSounds/Incorrect/monster_incorrect_04.wav` | 92238 B |

### Streak

| Mapping | Quelle | Zielpfad | Größe |
|---|---|---|---:|
| x2/x3 | `Streaksound/01.wav` | `Resources/Audio/StreakSounds/streak_01.wav` | 576078 B |
| x4+ | `Streaksound/02.wav` | `Resources/Audio/StreakSounds/streak_02.wav` | 576078 B |

## 3. Audioarchitektur

`LocalAudioResource` kapselt Name, WAV-Endung, Unterordner und fehlertoleranten Bundle-Lookup. `MonsterFeedbackSoundCatalog` hält getrennte 4er-Gruppen und die injizierbare Schnittstelle:

```swift
select(for evaluation: Bool?, using selector: ([LocalAudioResource]) -> LocalAudioResource?)
```

Produktiv verwendet der Selector `randomElement()`. Es existiert bewusst keine Speicherung der letzten Variante und keine Anti-Repeat-Logik. Eine fremde Selector-Ressource oder `nil` wird abgelehnt.

`AudioService.playMonsterFeedback(evaluation:selector:)` hält einen Monster-Player. `playStreak(for:)` hält einen separaten Streak-Player, sodass Modul 032 die Wiedergabe zeitversetzt steuern kann. Fehlende oder defekte Ressourcen werden unter `.audio` geloggt und beeinflussen den fachlichen Flow nicht.

## 4. Entscheidungsflow

```text
gültige Einzelentscheidung
→ bestehende Exactly-once-Bewertung
→ Correct/Incorrect-Gruppe
→ genau 1 von 4 auswählen
→ genau 1 Monster-Sound
→ bestehendes Feedback-/Transitionfenster
```

PrioritizationView und TeamAssignmentView enthalten keine Dateinamen. Beide ersetzen ausschließlich den bisherigen einzelnen Audioaufruf innerhalb des vorhandenen, durch `feedbackTaskStarted` geschützten Tasks. Ein ungültiger Drop und eine `nil`-Bewertung lösen keinen Sound aus.

## 5. Streak-Mapping

| Streak | Sound |
|---:|---|
| ≤ 1 | keiner |
| 2 | 01 |
| 3 | 01 |
| ≥ 4 | 02 |

Der produktive Teamabschluss-Trigger folgt erst in Modul 032 nach Einführung des Streak-State in Modul 031. Modul 029 fügt weder Streak-State noch Multiplikator-Scoring oder Overlay hinzu. Prioritätsentscheidungen können keinen Streak-Sound triggern.

## 6. Historische Sounds

- `Resources/correct.wav`: bleibt als unreferenzierte historische Ressource bestehen; kein produktiver Code verweist darauf.
- `Resources/incorrect.wav`: bleibt als unreferenzierte historische Ressource bestehen; kein produktiver Code verweist darauf.

Die alten Dateien werden nicht mehr geladen oder abgespielt. Ihre Entfernung kann später als reine Ressourcenbereinigung erfolgen.

## 7. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Support/AudioResourceCatalog.swift` | neu | 4+4-Katalog, Selector, Streak-Mapping | F-34, F-35, F-39 |
| `Services/AudioService.swift` | geändert | zentrale dynamische Wiedergabe, getrennte Player | F-12, F-34, F-35 |
| `Views/PrioritizationView.swift` | geändert | alten Einzel-Soundaufruf ersetzen | F-12, F-34 |
| `Views/TeamAssignmentView.swift` | geändert | alten Einzel-Soundaufruf ersetzen | F-12, F-34 |
| `Support/AppConstants.swift` | geändert | veraltete Einzel-Soundnamen entfernt | F-39 |
| `Resources/Audio/**` | neu | zehn lokale WAVs | F-34, F-35, F-39 |
| `AudioResourceCatalogTests.swift` | neu | Katalog-, Selector- und Mappingtests | AK-12, AK-34, AK-35, AK-39 |
| `Ticket_TamerTests.swift` | geändert | historische Audio-Mappingtests aktualisiert | AK-12 |

Geschützte Ticketdaten, Teamlogos, Teamgeometrie, Drop-Bounds, SessionModel und v1.2-Flow wurden nicht geändert.

## 8. Tests und Prüfungen

- Vorher: 401 `@Test`-Deklarationen
- Neu: 35
- Nachher: 436
- `git diff --check`: PASS für Modul-029-Code; die bereits vor Modul 029 geänderten Stand-Dokumente enthalten weiterhin historische Markdown-Zeilenumbrüche mit nachgestellten Leerzeichen
- WAV-Signatur, Format, Anzahl 4+4+2, Größe > 0 und Quell-/Zielhash: PASS
- Produktive Referenzen auf `correct.wav`/`incorrect.wav`: keine
- Sounddateipfade in Views oder SessionModel: keine
- Automatischer Testlauf: OPEN (Apple-Toolchain fehlt)
- Build: OPEN (Xcode fehlt)
- Simulator-/Audioprüfung: OPEN

## 9. Akzeptanzstatus

- AK-12: Code-/statische Testebene PASS; reale Wiedergabe OPEN
- AK-34: Katalog, Zufallsauswahl, deterministische Auswahl und direkte Wiederholung PASS; Hörprüfung OPEN
- AK-35 Ressourcen/Mapping/API: PASS
- AK-35 produktiver Teamabschluss-Trigger: OPEN bis Modul 031/032
- AK-39 Audio-Anteil: Code-/Ressourcenebene PASS; Bundle-/Simulatorlauf OPEN

Offenes Risiko: Die tatsächliche Bundle-Auffindbarkeit und hörbare Qualität aller zehn Dateien kann erst mit Xcode/Simulator bestätigt werden. Ob die Monster-Sounds verständliche Sprache enthalten, wurde ohne Hörmöglichkeit nicht behauptet und bleibt OPEN.

## 10. Empfehlung

Als Nächstes Modul 030 — Ticketvideo-System umsetzen. Die Audioarchitektur dabei nicht mit Video-Playback koppeln und die Modulgrenze zu Streak-State/Scoring weiterhin einhalten.
