# Modul-Report — 001 Projektgrundgerüst und zentrales Volume

> Vom **Modul-Chat** am Ende geschrieben. Zurück ans **Projektlogbuch** geben.
> Dies ist die einzige Übergabe — der Modul-Chat „vergisst" nach dem Schließen alles.

## Zusammenfassung

Modul 001 hat das visionOS-Projekt in ein kleines, buildfähiges Grundgerüst mit genau einem zentralen volumetrischen Fenster überführt. Der App-Einstieg verwendet `RootVolumeView` in einer volumetrischen `WindowGroup`; es gibt kein zweites Fenster und keinen Immersive Space. Debug-Grundlage, zentrale Constants, deutsche String-Catalog-Basistexte und ein Swift-Testing-Smoke-Test sind eingerichtet. AK-05 ist damit nur strukturell teilweise erfüllt; die vollständige lineare Sitzung folgt in späteren Modulen und wird erst in Modul 013 vollständig abgenommen.

## Dateien

| Datei (mit Ordner) | Art | Zweck |
|---|---|---|
| `Ticket_Tamer/App/Ticket_TamerApp.swift` | geändert/verschoben | App- und Scene-Einstieg; richtet genau eine volumetrische `WindowGroup` mit `RootVolumeView` ein. |
| `Ticket_Tamer/Views/RootVolumeView.swift` | neu/ersetzt | Minimale deutsche Root-Oberfläche im zentralen Volume mit eingebundener RealityKit-Standardszene. |
| `Ticket_Tamer/Debug/DebugManager.swift` | neu/integriert/geändert | Zentrale kategorisierte Debug-Steuerung; Buildfehler durch einmaliges Auflösen der Autoclosure vor Logger-Interpolation behoben. |
| `Ticket_Tamer/Support/AppConstants.swift` | neu | Minimale zentrale Konstanten für Volume-Maße, Layoutwerte, Ticketanzahl-Grundwerte und vorhandene Asset-Schlüssel. |
| `Ticket_Tamer/Resources/Localizable.xcstrings` | neu/geändert | Deutsche Lokalisierungsgrundlage für sichtbare Basistexte. |
| `Ticket_Tamer/Info.plist` | geändert | Scene-Rolle auf `UIWindowSceneSessionRoleVolumetricApplication` korrigiert. |
| `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift` | neu/geändert | Swift-Testing-Smoke-Test für positive Maße des zentralen Volumes. |
| `Ticket_Tamer.xcodeproj/project.pbxproj` | geändert | Projektstruktur/Dateieinbindung für App- und Testbestandteile über synchronisierte Projektgruppen aktualisiert. |
| `Ticket_Tamer/Assets.xcassets` | vorhanden | Asset-Katalog bleibt Bestandteil des App-Projekts. |
| `Packages/RealityKitContent/...` | vorhanden | Reality Composer Pro / RealityKitContent-Package bleibt eingebunden. |

Tatsächlich eingerichteter Datei- und Ordnerbaum des relevanten Projektbereichs:

```text
Ticket_Tamer/
├─ Ticket_Tamer/
│  ├─ App/
│  │  └─ Ticket_TamerApp.swift
│  ├─ Debug/
│  │  └─ DebugManager.swift
│  ├─ Resources/
│  │  └─ Localizable.xcstrings
│  ├─ Support/
│  │  └─ AppConstants.swift
│  ├─ Views/
│  │  └─ RootVolumeView.swift
│  ├─ Assets.xcassets
│  └─ Info.plist
├─ Ticket_TamerTests/
│  └─ Ticket_TamerTests.swift
├─ Packages/
│  └─ RealityKitContent/
│     ├─ README.md
│     ├─ Package.swift
│     ├─ Package.realitycomposerpro
│     └─ Sources/RealityKitContent/
│        ├─ RealityKitContent.swift
│        └─ RealityKitContent.rkassets/
│           ├─ Scene.usda
│           └─ Materials/GridMaterial.usda
└─ Products/
   ├─ Ticket_Tamer.app
   └─ Ticket_TamerTests.xctest
```

Neue Dateien:

- `Ticket_Tamer/Views/RootVolumeView.swift`
- `Ticket_Tamer/Debug/DebugManager.swift`
- `Ticket_Tamer/Support/AppConstants.swift`
- `Ticket_Tamer/Resources/Localizable.xcstrings`
- `Ticket_Tamer/Ticket_TamerTests/Ticket_TamerTests.swift`

Geänderte Dateien:

- `Ticket_Tamer/App/Ticket_TamerApp.swift`
- `Ticket_Tamer/Info.plist`
- `Ticket_Tamer.xcodeproj/project.pbxproj`
- `Ticket_Tamer/Debug/DebugManager.swift`

Verschobene Dateien:

- `Ticket_TamerApp.swift` liegt jetzt unter `Ticket_Tamer/App/Ticket_TamerApp.swift`.
- Weitere Verschiebungen sind im bestätigten Stand nicht gesondert belegt.

Entfernte oder ersetzte Dateien:

- Eine frühere Default-`ContentView` ist im aktuellen Projektbaum nicht mehr vorhanden beziehungsweise nicht mehr Teil des aktiven App-Einstiegs.
- Es existiert keine separate `DebugManager.swift`-Vorlage mehr im Repository-Stamm.
- Es wurden keine parallelen `New`-, `Old`-, `Copy`- oder `Backup`-Dateien angelegt.

## Erfüllte Akzeptanzkriterien

- [ ] AK-05 — „GEGEBEN eine Sitzung wurde gestartet, WENN sie vollständig durchlaufen wird, DANN erfolgt die Reihenfolge Start, Untersuchen, Priorisieren, Team zuordnen, nächstes Ticket und Ergebnis.“ Offen, weil die eigentlichen Sitzungsphasen in späteren Modulen implementiert werden.
- [x] AK-05 struktureller Teil — „Während der gesamten Sitzung bleibt die Anwendung innerhalb eines zentralen Volumes.“ Strukturell teilweise erfüllt durch genau eine zentrale volumetrische `WindowGroup`; vollständige Sitzungsprüfung erst nach Umsetzung der späteren Phasen möglich.
- [x] AK-05 struktureller Teil — „Es wird weder ein zweites Volume noch ein vollständiger Immersive Space geöffnet.“ Geprüft durch erfolgreichen Simulatorstart: kein zweites Fenster, kein zweites Volume und kein Immersive Space.

Weitere geprüfte Anforderungen aus Modul 001:

- Build erfolgreich.
- visionOS-Simulatorstart erfolgreich.
- Genau ein zentrales volumetrisches Fenster bestätigt.
- Deutsche Basistexte werden korrekt angezeigt.
- RealityKit-Standardszene wird angezeigt.
- Swift-Testing-Target `Ticket_TamerTests` läuft erfolgreich.
- Testergebnis: 1 Test in 1 Suite bestanden.
- Bestandener Test: „Die Maße des zentralen Volumes sind positiv“.
- Testplattform: `arm64-apple-xros1.0-simulator`.

## Bereitgestellte Schnittstellen (für Folgemodule)

- `Ticket_TamerApp` — App-Einstieg mit genau einer volumetrischen Scene.
- `RootVolumeView` — minimale SwiftUI-Root-Oberfläche innerhalb des zentralen Volumes.
- `DebugManager` — zentrale Debug-Steuerung.
- `DebugManager.Category` — Log-Kategorien `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`.
- `DebugManager.log(_:_:function:)` — kategorisierte Debug-Ausgabe mit nicht-escaping Autoclosure.
- `DebugManager.toggle(_:)` — Laufzeit-Umschaltung einer Debug-Kategorie.
- `DebugPanel` — optionales SwiftUI-Debug-Panel; nicht Teil des regulären Nutzerablaufs.
- `LayoutConstants` — zentrale Layout- und Volume-Maße.
- `GameplayConstants` — zentrale Ticketanzahl-Grundwerte aus der SPEC.
- `AssetKeys` — zentrale Schlüssel für vorhandene lokale Ressourcen.

Konkrete Constants:

- `LayoutConstants.centralVolumeWidth = 0.8`
- `LayoutConstants.centralVolumeHeight = 0.6`
- `LayoutConstants.centralVolumeDepth = 0.4`
- `LayoutConstants.rootPadding = 32.0`
- `LayoutConstants.rootSpacing = 24.0`
- `LayoutConstants.textSpacing = 8.0`
- `LayoutConstants.modelBottomPadding = 24.0`
- `GameplayConstants.minimumTicketCount = 1`
- `GameplayConstants.maximumTicketCount = 12`
- `GameplayConstants.defaultTicketCount = 6`
- `AssetKeys.defaultRealityKitScene = "Scene"`

`BalancingConstants` wurde nicht angelegt, weil Modul 001 noch keine Bewertungs-, Audio- oder automatische Übergangslogik implementiert und keine künstliche leere Struktur eingeführt werden sollte.

## DebugManager

- Ergänzte Kategorie(n): keine neuen Kategorien.
- Beibehaltene Kategorien: `lifecycle`, `input`, `physics`, `spawning`, `state`, `audio`.
- Wo geloggt wird: beim App-Einstieg in `Ticket_TamerApp.init()` und beim Anzeigen des zentralen Volumes in `RootVolumeView.onAppear`.
- Stand der aktiven Datei: genau eine `DebugManager.swift` unter `Ticket_Tamer/Debug/DebugManager.swift`.
- Abweichung von der Vorlage: Der Buildfehler „Escaping autoclosure captures non-escaping parameter 'message'“ wurde behoben, indem `message()` einmalig in `let resolvedMessage = message()` ausgewertet und anschließend `resolvedMessage` in `logger.debug` verwendet wird.
- `message` bleibt nicht-escaping; die öffentliche Signatur von `log` wurde nicht verändert.
- Das optionale `DebugPanel` ist nicht Teil des regulären Nutzerablaufs.

## Annahmen / offene Punkte / Risiken

- AK-05 ist nur strukturell teilweise erfüllt. Die vollständige lineare Zustandsfolge `Start -> Untersuchen -> Priorisieren -> Team zuordnen -> nächstes Ticket -> Ergebnis` ist bewusst noch nicht implementiert.
- Es wurden keine Ticketmodelle, kein Ticketkatalog, kein Sitzungsmodell, keine Monster-Pipeline, keine Drag-and-Drop-Logik, keine Punkteberechnung, kein Audiofeedback und keine Ergebnisansicht implementiert.
- `RootVolumeView` ist eine minimale Grundansicht und keine fertige Startansicht gemäß F-01.
- Die vorhandene RealityKit-Standardszene dient nur als Platzhalter. Eigene Monster-Assets gehören zu Modul 005.
- Die vollständige Prüfung auf echter Apple Vision Pro bleibt außerhalb dieses bestätigten Simulatorstands offen.
- `Ticket_Tamer.xcodeproj/project.pbxproj`, `Ticket_Tamer/App/Ticket_TamerApp.swift` und `Ticket_Tamer/Support/AppConstants.swift` sind potenziell konfliktanfällige Dateien für Folgemodule.
- Die Scene-Rolle wurde auf `UIWindowSceneSessionRoleVolumetricApplication` korrigiert; diese Konfiguration ist für den erfolgreichen volumetrischen Start relevant.

## Git

- Commit: `001: Projektgrundgerüst und zentrales Volume`
- Hash: offen; im Modul-Chat wurde kein Commit ausgeführt und kein Commit-Hash erzeugt.
- Vorgeschlagene Commit-Nachricht: `001: Projektgrundgerüst und zentrales Volume`

## Stand aktualisiert

- [ ] `Projekt-Stand.md` neu erzeugt und im Projektraum **ersetzt** (kein Altstand mit gleichem Namen daneben).
- [ ] `Logbuch-Stand.md` aktualisiert.
- [ ] Umbenannte/gelöschte Dateien im Projekt-Stand unter „nicht mehr vorhanden" vermerkt.

Diese Standdokumente wurden in diesem Schritt bewusst nicht aktualisiert, weil sie später vom Projektlogbuch-Chat gepflegt werden sollen.

## Empfehlung für das nächste Modul

Als Nächstes sollte Modul 002 umgesetzt werden: Ticketdatenmodell und lokaler Katalog. Modul 001 stellt dafür die stabile App-, Volume-, Debug-, Constants-, Lokalisierungs- und Testgrundlage bereit. Modul 002 sollte nun die fachlichen Datentypen, Enumerationen und genau zwölf lokalen Tickets mit vollständigen Referenzwerten einführen, ohne bereits Sitzungszustand oder Auswahl-/Reset-Logik aus Modul 003 vorwegzunehmen.
