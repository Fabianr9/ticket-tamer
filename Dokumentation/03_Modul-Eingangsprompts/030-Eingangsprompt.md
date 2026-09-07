# Modul-Eingangsprompt — 030 Ticketvideo-System

> Vom **Projektlogbuch** nach Einarbeitung des `029-Report.md` erzeugt.  
> Diesen Prompt vollständig in einen **neuen Modul-Chat** einfügen.  
> Der Modul-Chat arbeitet ausschließlich an Modul 030.

---

Du bist Fachentwickler:in für **genau dieses eine Modul**.

# Modul

**Nummer:** 030  
**Titel:** Ticketvideo-System  
**Erfüllt:** F-03, F-32, F-33, F-39 / AK-03, AK-32, AK-33 sowie Video-Anteil von AK-39

**Ziel:** Integriere die 16 lokalen Ticketvideos `TT-001.mp4` bis `TT-016.mp4` in eine zentrale lokale Ressourcenstruktur und ergänze ausschließlich in der Untersuchungsphase die Aktion `Video ansehen`. Das Video darf erst nach dieser Benutzeraktion öffnen; danach startet es automatisch, kann pausiert/fortgesetzt und per sichtbarem `X` geschlossen werden, schließt sich am regulären Ende automatisch und kehrt zum unveränderten aktuellen Ticket zurück. Fehlende/defekte Videos dürfen weder Crash noch fachliche Zustandsänderung auslösen.

---

# Ausgangsstand

v1.0, v1.1 und v1.2 sind abgeschlossen.

v1.3:

- Modul 027 committed
- Modul 028 committed
- Modul 029 implementiert

Laut `029-Report.md`:

- Branch `v1.3`
- HEAD vor 029 `120ab6d3bf48533521a46cf7524fa3caedc87483`
- Modul-028-Commit `120ab6d` (`feat: Modul 28`)
- Modul-029-Commit im Report noch offen
- reale Tests vor 029: 401
- neue Tests: 35
- reale Tests nach 029: **436**
- Build/Test/Simulator/Hörprüfung: OPEN

---

# Vorab-Gate

## 1. Git

Ermittle real:

- Branch
- HEAD
- tatsächlichen Modul-029-Commit
- Working Tree
- staged/untracked Dateien

Wenn Modul 029 inzwischen committed ist:

- echten Hash dokumentieren.

Wenn 029 noch uncommitted ist:

- Audio-Diff klar vom Video-Diff trennen,
- Audioressourcen nicht unnötig anfassen,
- nach Möglichkeit Modul 029 separat committen.

Keine Hashes erfinden.

## 2. Reale Testzahl

Dokumentierter Ausgangswert:

**436 `@Test`-Deklarationen**

Real prüfen.

Bei Abweichung:

- reale Zahl verwenden,
- Ursache dokumentieren.

## 3. Bestehenden Video-Datenstand lesen

Mindestens:

- `Models/Ticket.swift`
- `Data/LocalTicketCatalog.swift`
- `Views/InvestigationView.swift`
- `Models/SessionModel.swift`
- `Views/RootVolumeView.swift`
- `Support/AppConstants.swift`
- `Resources/Localizable.xcstrings`
- Tests zu TT-001...TT-016 und `videoAssetName`

Verifizieren:

Jedes Ticket besitzt bereits exakt:

`TT-xxx.mp4`

als reine Datenreferenz.

Keine zweite parallele Video-ID einführen.

---

# Video-Inventar vor Codeänderung

Suche vollständig nach allen bereitgestellten MP4-Dateien.

Mögliche Quellordner:

- `Tickets`
- `Videos`
- `Ticketvideos`
- `Ticket Videos`
- v1.3-Assetordner

Inventar:

| Ticket | erwartete Datei | gefundener Quellpfad | Größe | technisch vorhanden |
|---|---|---|---:|---|
| TT-001 | TT-001.mp4 | | | |
| TT-002 | TT-002.mp4 | | | |
| ... | ... | | | |
| TT-016 | TT-016.mp4 | | | |

Verbindlich:

Es müssen genau die produktiv referenzierten Dateien:

`TT-001.mp4` bis `TT-016.mp4`

zugeordnet werden.

Falls zusätzliche Dateien existieren, z. B. historisch `TT-002A.mp4`:

- nicht automatisch produktiv zuordnen,
- klassifizieren,
- `Ticket.videoAssetName` bleibt maßgeblich.

Keine fehlende Datei selbst erzeugen.

---

# F-03 — Video-Referenz schützen

Jedes Ticket enthält genau eine feste lokale Video-Referenz.

Dieser Anteil ist bereits seit Modul 027 im Ticketmodell vorhanden.

Modul 030 darf:

- den Ressourcenprovider ergänzen,
- Bundle-Lookup ergänzen,
- Video-UI ergänzen.

Nicht:

- Ticket-IDs neu mappen,
- mehrere Videos pro Ticket einführen,
- dynamisch nach Titel statt `videoAssetName` suchen.

---

# F-32 — Videozuordnung und Video-Start

Verbindlich:

1. TT-001 → TT-001.mp4
2. ...
3. TT-016 → TT-016.mp4
4. In Investigation ist `Video ansehen` sichtbar.
5. Ohne Tap auf `Video ansehen` wird kein Video gestartet.
6. Der Button bezieht sich immer auf `model.currentTicket`.
7. Bei TT-007 öffnet exakt `TT-007.mp4`.

Kein Auto-Start beim bloßen Erscheinen der InvestigationView.

Kein Video-Preload mit automatischem Playback.

---

# F-33 — Video-Wiedergabe

Nach Tap auf `Video ansehen`:

- einfache Videoansicht öffnen,
- aktuelles Ticketvideo automatisch starten,
- Pause/Fortsetzen ermöglichen,
- sichtbares `X`,
- `X` jederzeit nutzbar,
- am regulären Videoende automatisch schließen,
- danach dasselbe Ticket in Investigation weiter anzeigen.

Video darf nicht:

- Priorisierung starten,
- Ticketindex ändern,
- Score ändern,
- Entscheidungen ändern,
- Streak ändern,
- Input-Lock fachlich verändern.

---

# Videoansicht

Bevorzuge eine kleine wiederverwendbare Komponente:

`TicketVideoView`

oder semantisch gleichwertig.

Geeignete Apple-Technik:

- AVKit / `VideoPlayer`
- AVFoundation / `AVPlayer`

Die SPEC erlaubt AVKit ausdrücklich.

Keine zusätzliche WindowGroup.

Kein zweites Volume.

Kein Immersive Space.

Die Videoansicht bleibt innerhalb des bestehenden zentralen Volume-/View-Kontexts.

---

# Präsentationsart

Bevorzuge:

- Overlay
- Sheet-/volumeninterne modale Präsentation
- ZStack über InvestigationView

je nachdem, was im aktuellen visionOS-Aufbau stabil funktioniert.

Verbindlich:

- `X` gut sichtbar
- Ticketkarte/Monster nicht gleichzeitig interaktiv im Hintergrund
- nach Schließen Investigation wieder normal nutzbar
- kein phasenweiter Routingumbau nötig

Keinen neuen `GamePhase.video` einführen, sofern nicht zwingend nötig.

Video ist optionale UI innerhalb der Investigation, kein neuer fachlicher Sitzungszustand.

---

# Lokaler View-State

Geeignet:

```text
isVideoPresented
```

und gegebenenfalls lokale Playback-/Load-State-Werte.

Nicht in `SessionModel`:

- `isVideoPresented`
- `isVideoPlaying`
- AVPlayer
- Video-Fehlertext
- Playbackposition

Diese sind UI-/Medienzustand, nicht fachlicher Sitzungszustand.

---

# Zentraler Video-Resource-Provider

Keine vollständigen Dateipfade in `InvestigationView`.

Bevorzuge z. B.:

```text
TicketVideoResourceProvider
- url(for videoAssetName:)
```

oder:

```text
TicketVideoCatalog
- resource(for ticket:)
```

Verbindlich:

- lokale Bundle-Auflösung
- keine Netzwerk-URL
- keine absoluten Entwicklerpfade
- defensive Fehlerbehandlung

Die fachliche Ticketdatenquelle enthält nur `videoAssetName`.

---

# F-39 — Video-Ressourcenstruktur

Ziel:

```text
Ticket_Tamer/Ticket_Tamer/Resources/
└── Videos/
    ├── TT-001.mp4
    ├── TT-002.mp4
    ├── ...
    └── TT-016.mp4
```

oder funktional gleichwertige lokal eingebundene Struktur.

Alle 16 Videos gemeinsam.

Keine verstreuten Kopien in Views/Services.

Zentrale Auffindbarkeit über Ticket-ID/`videoAssetName`.

---

# Video-Ressourcenprüfung

Für alle 16 soweit lokal möglich:

- existiert
- > 0 Byte
- MP4-Dateityp
- Quell-/Zielhash nach Kopie
- eindeutige Dateinamen
- keine Netzwerkabhängigkeit

Optional:

- Dauer
- Auflösung
- Codec

nur wenn zuverlässig ermittelbar.

Keine Umkodierung oder Qualitätsänderung ohne Notwendigkeit.

---

# Auto-Start nach Benutzeraktion

Ablauf:

```text
Investigation
→ Tap "Video ansehen"
→ Bundle-URL auflösen
→ Videoansicht präsentieren
→ AVPlayer starten
```

Nicht:

```text
Investigation erscheint
→ Player.play()
```

AK-32 verlangt ausdrücklich:

Ohne Benutzeraktion kein Video.

---

# Pause/Fortsetzen

Die nutzende Person muss:

- pausieren
- fortsetzen

können.

Wenn `VideoPlayer` Standardkontrollen bereitstellt und visionOS sie stabil anbietet:

- diese nutzen.

Keine eigenen komplexen Playercontrols nötig.

---

# Sichtbares X

Unabhängig von Playercontrols:

sichtbares `X` zum Schließen.

Accessibility:

`Video schließen`

oder semantisch gleichwertiger deutscher String.

Beim X:

- Player pausieren/stoppen,
- Beobachter sauber entfernen,
- Videoansicht schließen.

Kein fachlicher Modelaufruf.

---

# Automatisches Schließen am Videoende

Beobachte das Ende des **aktuellen** AVPlayerItem.

Beim regulären Ende:

1. Playback beenden.
2. Observer bereinigen.
3. Videoansicht schließen.
4. Investigation bleibt beim selben Ticket.

Keine zusätzliche Nutzeraktion.

Kein `Weiter zur Priorisierung`.

---

# Observer-/Task-Lebenszyklus

Besonders sauber behandeln:

- Videoende-Notification
- View verschwunden
- manuelles X
- Ticketwechsel
- erneutes Öffnen desselben Videos

Keine mehrfach registrierten Observer.

Kein doppeltes Auto-Close.

Kein stale Callback eines alten Players, der eine neue Videoansicht schließt.

Bevorzuge gekapselte Player-/View-Lifecycle-Logik.

---

# Phasenwechsel-Schutz

Falls Investigation verlassen wird, während Video offen wäre:

- Videoansicht schließen,
- Player stoppen,
- Observer entfernen.

Ein Video darf nicht in Priorisierung weiterlaufen.

Der reguläre `Weiter zur Priorisierung`-Button sollte bei offenem Video nicht im Hintergrund interaktiv sein.

---

# Fachzustand vor/nach Video

Dokumentiere vor dem Öffnen und nach manuellem sowie automatischem Schließen:

| Feld | muss unverändert bleiben |
|---|---|
| currentTicket | ja |
| currentTicketIndex | ja |
| currentPhase | `.untersuchen` |
| score | ja |
| selectedPriority | ja |
| selectedTeam | ja |
| isInputLocked | fachlich unverändert |
| Monster-Variantenmapping | ja |

Streak:

Falls Modul 031 noch nicht existiert:

- keinen Streak hinzufügen.

Falls im realen Repository bereits ein vorbereiteter Streak-State vorhanden ist:

- muss unverändert bleiben.

---

# Fehlerfall — Video fehlt/nicht ladbar

Bei fehlender oder defekter Ressource:

- kein Crash,
- keine Force-Unwraps,
- verständliche deutsche Fehlermeldung,
- Ticket bleibt normal spielbar.

Geeigneter Text sinngemäß:

`Video konnte nicht geladen werden.`

String Catalog verwenden.

Nach Fehler:

- `X` oder Schließen möglich,
- `Weiter zur Priorisierung` danach normal nutzbar,
- Score/Index/Phase unverändert.

Kein Retry zwingend gefordert.

Keine automatische Netzwerksuche.

---

# Fehlermeldungsdarstellung

Kann innerhalb der Videoansicht erfolgen:

- Fehlericon
- deutscher Text
- X

Nicht erforderlich:

- komplexer Error-Code
- Dateipfad
- technische Details für Nutzende

Technische Details nur im Debuglog.

---

# DebugManager

Bestehende Kategorien verwenden.

Geeignet:

`.state` oder `.lifecycle`

für:

- Video geöffnet
- Video geschlossen
- Videoende

Optional `.spawning` für Ressourcenauflösung.

Keine neue Kategorie nötig.

Nicht loggen:

- vollständige lokale absolute Nutzerpfade im UI
- Referenzteam/-priorität

---

# InvestigationView schützen

Bestehende Inhalte bleiben:

- Monster
- Ticketkarte
- HUD
- `Weiter zur Priorisierung`
- Monster-Retry

Neu:

- `Video ansehen`

Videoaktion darf vorhandene Layout-/Replaystabilität nicht destabilisieren.

Bei geschlossenem Video bleibt die bestehende Investigation unverändert.

---

# Monster-Retry schützen

Video und Monsterload sind getrennt.

Nicht:

- Video öffnen → Monster neu laden
- Video schließen → Monster neu laden
- Videofehler → MonsterloadError verändern

Der vorhandene MonsterLoadRecovery-State bleibt unabhängig.

---

# Audio aus Modul 029 schützen

Video-Playback ist nicht mit Monster-/Streak-Audiofeedback zu koppeln.

Nicht verändern:

- AudioResourceCatalog
- Monster-Soundauswahl
- Streak-Soundmapping
- AudioService-Feedbackflow

Falls Videoton über AVPlayer abgespielt wird, ist dies Player-eigener Medienton und keine Änderung am Feedback-Audiosystem.

---

# Teamlogos aus Modul 028 schützen

Nicht verändern:

- TeamLogoCatalog
- JPEG-Teamlogos
- TeamAttachment
- Dropgeometrie

---

# Ticketdaten aus Modul 027 schützen

Nicht verändern:

- TT-001...TT-016
- Tickettexte
- Referenzmatrix
- 1...16-Auswahl
- `videoAssetName`-Mapping

Die Videoressourcen müssen dem vorhandenen Mapping folgen.

---

# Harte Modulgrenze

Modul 030 implementiert nicht:

## Modul 031
- keinen Streak-State
- keine Streak-Mutation
- kein Multiplikator-Scoring
- keine Score-Differenzgutschrift

## Modul 032
- kein Multiplikator-Overlay
- kein x2/x3/x4+-Puls
- keinen produktiven Streak-Soundtrigger

Keine Audio-, Logo- oder Ticketneustrukturierung außerhalb des Videoanteils.

---

# Automatisierte Tests

Ausgangswert laut 029-Report:

**436 Testdeklarationen**

Reale Zahl im Preflight prüfen.

Ergänze mindestens Tests für:

## Videozuordnung

1. exakt 16 Ticketvideo-Referenzen.
2. TT-001 → TT-001.mp4.
3. TT-007 → TT-007.mp4.
4. TT-016 → TT-016.mp4.
5. alle 16 Referenzen eindeutig.
6. alle Endungen `.mp4`.
7. keine HTTP-/HTTPS-Referenz.
8. keine absoluten Entwicklerpfade.

## Provider

9. Provider löst bekannte Ressource zentral auf.
10. Provider meldet fehlende Ressource defensiv.
11. Provider verändert kein Ticket.
12. Provider kennt keine Priorität.
13. Provider kennt kein Team.
14. Provider kennt keinen Score.

## Präsentationszustand

15. initial kein Video präsentiert.
16. nur `Video ansehen` setzt Präsentation aktiv.
17. Schließen setzt Präsentation inaktiv.
18. Ticketwechsel schließt Video.
19. Phasenwechsel schließt Video.
20. wiederholtes Öffnen erzeugt keine parallelen aktiven Playerstates.

## Fachzustandsschutz

21. manuelles Schließen verändert Score nicht.
22. manuelles Schließen verändert Index nicht.
23. manuelles Schließen verändert Phase nicht.
24. Auto-Close verändert Score nicht.
25. Auto-Close verändert Index nicht.
26. Auto-Close verändert Phase nicht.
27. Videofehler verändert Score nicht.
28. Videofehler verändert Index nicht.
29. Videofehler verändert Entscheidungen nicht.
30. Videofehler verändert Monster-Variantenmapping nicht.

## Fehlerfall

31. fehlende Videoressource → nutzerverständlicher Fehlerzustand.
32. Fehlerzustand ist schließbar.
33. Ticket bleibt spielbar.
34. kein Force-Unwrap/Crashpfad erforderlich.

## Regression

35. `Weiter zur Priorisierung` bleibt fachlich unverändert.
36. Investigation zeigt weiterhin Ticketdaten.
37. Monster-Retry bleibt unabhängig.
38. kein Video-Start ohne Nutzeraktion.

Keine unnötige Player-Abstraktion nur für Tests aufbauen; eine kleine testbare Presentation-/Resource-State-Struktur ist zulässig.

---

# Assetprüfung

Erstelle:

| Ticket | Quelldatei | Zielpfad | Größe | Hash gleich | Bundle statisch |
|---|---|---|---:|---|---|
| TT-001 | | Resources/Videos/TT-001.mp4 | | | |
| ... | | ... | | | |
| TT-016 | | Resources/Videos/TT-016.mp4 | | | |

Zusätzliche MP4-Dateien separat klassifizieren.

---

# Simulatorprüfung

Wenn Xcode verfügbar:

## Kein Autostart

Investigation öffnen.

Ohne Tap:

- kein Video
- kein Playeroverlay
- kein Ton aus Ticketvideo

## TT-007

- TT-007 aktiv
- `Video ansehen`
- exakt TT-007.mp4
- startet automatisch

## Playersteuerung

- Pause
- Fortsetzen

## X

- während Playback schließen
- gleiche Investigation
- gleiches Ticket

## Auto-Close

- Video bis Ende
- Ansicht schließt automatisch
- gleiche Investigation

## Fehlerfall

Kontrolliert fehlende Ressource über testbaren Provider simulieren:

- verständliche Fehlermeldung
- kein Crash
- anschließend Ticket normal weiterbearbeitbar

## Statusmatrix

Vor/nach manuell und automatisch:

- Ticket gleich
- Index gleich
- Phase Untersuchung
- Score gleich
- Entscheidungen gleich

## Mehrfachöffnen

Video mehrfach öffnen/schließen:

- kein Observer-Duplikat
- kein Crash
- kein doppeltes Auto-Close

## 16 Videos

Mindestens automatisiert Bundle-Lookup für alle 16.

Soweit praktikabel alle 16 im Simulator kurz öffnen.

---

# Accessibility

Mindestens:

- `Video ansehen`
- `Video schließen`

verständlich beschriftet.

Player-Standardkontrollen müssen bedienbar bleiben.

Fehlermeldung lesbar.

Keine Bedienaktion nur über Farbe/Icon ohne Label.

---

# Performance

Videoressourcen lokal.

Kein Netzwerk.

Öffnen darf normalen UI-Flow nicht dauerhaft blockieren.

Nicht alle 16 Videos gleichzeitig in den Speicher laden.

Pro Öffnung nur aktuelles Ticketvideo.

---

# Voraussichtlich relevante Dateien

Zuerst real ermitteln.

Wahrscheinlich:

- `Views/InvestigationView.swift`
- neue `Views/Components/TicketVideoView.swift`
- neuer `Services/TicketVideoResourceProvider.swift` oder `Support/TicketVideoCatalog.swift`
- `Resources/Videos/*.mp4`
- `Resources/Localizable.xcstrings`
- Tests

Nur falls zwingend:

- `Support/AppConstants.swift`

Nach Möglichkeit unverändert:

- `SessionModel.swift`
- `Ticket.swift`
- `LocalTicketCatalog.swift`
- `AudioService.swift`
- `AudioResourceCatalog.swift`
- `TeamLogoCatalog.swift`
- PrioritizationView
- TeamAssignmentView
- TargetPanelLayout
- DropEvaluator
- ResultView
- RootVolumeView

---

# Git

Vor Modul 030:

Modul 029 separat committen, falls noch offen.

Vorgesehen:

`029: Monster- und Streak-Audio`

Modul 030:

`030: Ticketvideo-System`

Vor Commit:

- 16 MP4s inventarisieren
- Bundle-/Providerprüfung
- Tests
- Build falls möglich
- Simulatorprüfung
- Fehlerfall
- `git diff --check`
- Scope-Diff

Keine Hashes erfinden.

---

# Ausgabeformat

## 1. Vorab-Check

- Branch
- HEAD
- tatsächlicher 029-Commit
- Working Tree
- reale Testzahl
- Build/Test/Simulatorstatus

## 2. Video-Inventar

| Ticket | Quelle | Zielpfad | Größe | Status |
|---|---|---|---:|---|

Alle 16.

## 3. Videoarchitektur

- Ticketvideo-Provider
- Bundle-Lookup
- TicketVideoView
- lokaler Presentation-State
- Observer-Lifecycle
- Fehlerzustand

## 4. Nutzerflow

```text
Investigation
→ Video ansehen
→ Auto-Play
→ Pause/Fortsetzen
→ X oder Videoende
→ gleiche Investigation / gleiches Ticket
```

## 5. Fachzustandsschutz

Vorher/Nachher-Tabelle für:

- Ticket
- Index
- Phase
- Score
- Entscheidungen
- Input-Lock
- Variantenmapping
- Streak falls bereits vorhanden

## 6. Fehlerfall

- fehlende Ressource
- verständliche Meldung
- kein Crash
- Ticket weiter spielbar

## 7. Änderungen je Datei

| Datei | Art | Zweck | F/AK |
|---|---|---|---|

## 8. Tests

- vorher
- neu
- nachher
- Passed/Failed/Skipped
- Plattform

## 9. Simulator-/Regressionstest

- kein Autostart
- TT-007
- Pause/Fortsetzen
- X
- Auto-Close
- Fehlerfall
- Mehrfachöffnen
- 16 Bundle-Lookups
- Modul-027/028/029 Regression

## 10. Vollständiger `030-Report.md`

Der Report muss ausdrücklich enthalten:

- realen Gitstand
- tatsächlichen 029-Commit
- reale Testzahl
- Liste aller 16 produktiven MP4-Dateien
- ursprüngliche Quellpfade
- finale Zielpfade
- Bestätigung: TT-xxx → TT-xxx.mp4
- zentrale Video-Provider-/Mappingstruktur
- Bestätigung: kein Video ohne Nutzeraktion
- Bestätigung: nach Aktion Auto-Start
- Pause/Fortsetzen
- sichtbares X
- Auto-Close am Ende
- Bestätigung: gleiches Ticket/gleiche Phase nach Schließen
- Score/Index/Entscheidungen unverändert
- Verhalten bei fehlendem Video
- Bestätigung: kein Streak-State/Scoring vorgezogen
- AK-03 PASS/OPEN/FAIL
- AK-32 PASS/OPEN/FAIL
- AK-33 PASS/OPEN/FAIL
- AK-39 Video-Anteil PASS/OPEN/FAIL
- Build/Test/Simulatorstatus
- offene Risiken
- Empfehlung für **Modul 031 — Streak-State und Scoring**

Baue nichts außerhalb dieses Moduls um.
