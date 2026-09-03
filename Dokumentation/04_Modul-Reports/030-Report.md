# Modul-Report 030 — Ticketvideo-System

## 1. Vorab-Check

- Branch: `v1.3`
- HEAD vor Modul 030: `baf8a55495e9605bbc011dbf01de061638f6a11c`
- Modul-029-Commit: `baf8a55` (`feat: Modul 29`)
- Working Tree vor Modul 030: nur die bereits nach Modul 029 aktualisierten Stand-Dokumente und der untracked Eingangsprompt 030
- Reale Testzahl vor Modul 030: 436 `@Test`-Deklarationen
- Xcode, Swift-Toolchain und Simulator: auf dieser Plattform nicht vorhanden; Build, Testlauf und Simulatorprüfung OPEN

## 2. Video-Inventar

Alle Quellen und Ziele wurden als ISO-MP4 erkannt. Quell- und Zielkopie besitzen jeweils denselben SHA-256-Hash.

| Ticket | Quelle | Zielpfad | Größe | Status |
|---|---|---|---:|---|
| TT-001 | `Tickets/TT-001.mp4` | `Resources/Videos/TT-001.mp4` | 1759772 B | vorhanden, Hash gleich |
| TT-002 | `Tickets/TT-002.mp4` | `Resources/Videos/TT-002.mp4` | 2658558 B | vorhanden, Hash gleich |
| TT-003 | `Tickets/TT-003.mp4` | `Resources/Videos/TT-003.mp4` | 2827326 B | vorhanden, Hash gleich |
| TT-004 | `Tickets/TT-004.mp4` | `Resources/Videos/TT-004.mp4` | 2293395 B | vorhanden, Hash gleich |
| TT-005 | `Tickets/TT-005.mp4` | `Resources/Videos/TT-005.mp4` | 2908405 B | vorhanden, Hash gleich |
| TT-006 | `Tickets/TT-006.mp4` | `Resources/Videos/TT-006.mp4` | 2340706 B | vorhanden, Hash gleich |
| TT-007 | `Tickets/TT-007.mp4` | `Resources/Videos/TT-007.mp4` | 1754379 B | vorhanden, Hash gleich |
| TT-008 | `Tickets/TT-008.mp4` | `Resources/Videos/TT-008.mp4` | 2180463 B | vorhanden, Hash gleich |
| TT-009 | `Tickets/TT-009.mp4` | `Resources/Videos/TT-009.mp4` | 1924269 B | vorhanden, Hash gleich |
| TT-010 | `Tickets/TT-010.mp4` | `Resources/Videos/TT-010.mp4` | 2138022 B | vorhanden, Hash gleich |
| TT-011 | `Tickets/TT-011.mp4` | `Resources/Videos/TT-011.mp4` | 4058898 B | vorhanden, Hash gleich |
| TT-012 | `Tickets/TT-012.mp4` | `Resources/Videos/TT-012.mp4` | 2607290 B | vorhanden, Hash gleich |
| TT-013 | `Tickets/TT-013.mp4` | `Resources/Videos/TT-013.mp4` | 2642323 B | vorhanden, Hash gleich |
| TT-014 | `Tickets/TT-014.mp4` | `Resources/Videos/TT-014.mp4` | 1514579 B | vorhanden, Hash gleich |
| TT-015 | `Tickets/TT-015.mp4` | `Resources/Videos/TT-015.mp4` | 3495911 B | vorhanden, Hash gleich |
| TT-016 | `Tickets/TT-016.mp4` | `Resources/Videos/TT-016.mp4` | 2494710 B | vorhanden, Hash gleich |

`Tickets/TT-002A.mp4` (1922793 B) ist eine historische Zusatzdatei ohne Ticketreferenz. Sie wurde nicht produktiv kopiert oder zugeordnet.

## 3. Videoarchitektur

`Ticket.videoAssetName` bleibt die einzige fachliche Referenz. `TicketVideoResourceProvider` validiert einen reinen MP4-Dateinamen und sucht ihn lokal zuerst unter `Videos`, danach defensiv im flach kopierten Bundle. Netzwerk-URLs, absolute Pfade, Traversal und fremde Endungen werden abgelehnt.

`TicketVideoPresentationState` kapselt nur den lokalen Präsentationszustand. `TicketVideoView` erstellt pro Öffnung genau einen `AVPlayer`, startet erst in `onAppear` nach dem expliziten Tap und verwendet die Standardcontrols von `VideoPlayer` für Pause/Fortsetzen. Ein sichtbares X stoppt den Player; Ende-, Fehler- und Statusbeobachter werden beim Schließen beziehungsweise Verschwinden entfernt. Reguläres Ende schließt automatisch. Fehlende oder defekte Medien zeigen den lokalisierten Text `Video konnte nicht geladen werden.`.

## 4. Nutzerflow

```text
Investigation
→ Tap „Video ansehen"
→ lokale Bundle-URL auflösen
→ Overlay + Auto-Play
→ Pause/Fortsetzen über Standardcontrols
→ X oder reguläres Videoende
→ gleiche Investigation / gleiches Ticket
```

Ohne Tap wird weder Provider noch Player durch die View aufgerufen. Während des Overlays ist der Hintergrund nicht interaktiv. Ticket- oder Phasenwechsel sowie `onDisappear` schließen die Präsentation.

## 5. Fachzustandsschutz

| Feld | vor/nach manuellem oder automatischem Schließen |
|---|---|
| `currentTicket` | unverändert |
| `currentTicketIndex` | unverändert |
| `currentPhase` | `.untersuchen` |
| `score` | unverändert |
| `selectedPriority` / `selectedTeam` | unverändert |
| `isInputLocked` | unverändert |
| Monster-Variantenmapping | unverändert |
| Streak | nicht eingeführt |

Videozustand und Player liegen nicht im `SessionModel`. Audio-, Teamlogo-, Monster-, Drag-/Drop- und Scoringlogik wurden nicht verändert.

## 6. Fehlerfall

Fehlende Ressourcen, ungültige Referenzen und nicht lesbare PlayerItems führen nicht zu einem Force-Unwrap oder einer fachlichen Mutation. Die Videoansicht bleibt per X schließbar; anschließend kann das aktuelle Ticket normal zur Priorisierung weitergeführt werden. Es erfolgt keine Netzwerksuche.

## 7. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|
| `Services/TicketVideoResourceProvider.swift` | neu | Bundle-Lookup und lokaler Präsentationszustand | F-03, F-32, F-39 |
| `Views/Components/TicketVideoView.swift` | neu | Playback, Controls, X, Auto-Close, Fehlerzustand | F-33 |
| `Views/Components/TicketCardView.swift` | geändert | Aktion `Video ansehen` | F-32 |
| `Views/InvestigationView.swift` | geändert | lokales Overlay und Lifecycle-Schutz | F-32, F-33 |
| `Resources/Videos/*.mp4` | neu | 16 lokale Ticketvideos | F-39 |
| `Resources/Localizable.xcstrings` | geändert | Videoaktion, Fehler- und Accessibilitytext | AK-32, AK-33 |
| `TicketVideoSystemTests.swift` | neu | Mapping-, Provider-, Präsentations- und Fachzustandstests | AK-03, AK-32, AK-33, AK-39 |

## 8. Tests und Prüfungen

- Vorher: 436 `@Test`-Deklarationen
- Neu: 38
- Nachher: 474
- JSON-Validierung des String Catalog: PASS
- MP4-Anzahl, Dateityp, Größe > 0 und Quell-/Zielhash: PASS
- genau TT-001 bis TT-016 im produktiven Videoordner: PASS
- statische Prüfung auf Netzwerk-/absolute Pfade und Force-Unwrap im Video-Code: PASS
- `git diff --check` für Modul-030-Code: PASS; historische nachgestellte Leerzeichen in den vorbestehenden Stand-Dokumenten wurden bei deren Aktualisierung entfernt
- automatischer Testlauf: OPEN (Apple-Toolchain fehlt)
- Build: OPEN (Xcode fehlt)
- Simulator-/Playbackprüfung einschließlich TT-007: OPEN

## 9. Akzeptanzstatus

- AK-03: bestehende eindeutige Referenzen unverändert; Ressourcen vollständig — statisch PASS
- AK-32: explizite Aktion, TT-007-Mapping und kein View-Autostart — Code-/Testebene PASS; Simulator OPEN
- AK-33: Auto-Play nach Tap, Pause/Fortsetzen, X, Auto-Close, Fehlerzustand — Codeebene PASS; reale Wiedergabe OPEN
- AK-39 Video-Anteil: gemeinsame lokale Struktur und zentraler Lookup — Ressourcenebene PASS; Bundle-Lauf OPEN

## 10. Git und Empfehlung

- Modul-030-Commit: offen
- Empfohlen als Nächstes: Modul 031 — Streak-State und Scoring. Das Ticketvideo-System bleibt dabei reiner UI-/Medienzustand.
