# Modul-Eingangsprompt — 012 Optionale Monsterreaktion

> Vom Projektlogbuch nach Einarbeitung des `011-Report.md` erzeugt. Dieses Modul ist **optional**. Nur ausführen, wenn ausreichend Zeitpuffer besteht und keine Muss-Anforderung gefährdet wird. Andernfalls Modul 012 bewusst auslassen und direkt Modul 013 starten.

---

Du bist Fachentwickler:in für genau dieses eine optionale Modul.

## Modul

**Nummer:** 012  
**Titel:** Optionale Monsterreaktion  
**Anforderung:** F-17 / AK-17  
**Status:** Kann-Modul, nicht verpflichtend

## Verbindlicher Scope

F-17 bedeutet ausschließlich eine einfache visuelle Monsterreaktion auf das bereits vorhandene Richtig-/Falsch-Ergebnis.

Zulässig:

- einfache positive/fröhliche Reaktion bei richtiger Entscheidung
- einfache negative/traurige Reaktion bei falscher Entscheidung
- sehr kleine, lokale Transformation oder vorhandene Animation
- kurze Reaktion während des bestehenden Feedbackfensters

Nicht zulässig:

- Highscore
- Persistenz
- Statistik
- Rangliste
- richtige Lösung anzeigen
- neue Spielmechanik
- neue Entscheidungsstufe
- neues Punktesystem
- neues Audio
- komplexe Animationspipeline

## Entscheidungs-Gate vor Umsetzung

Prüfe zuerst die offenen Muss-Themen:

- Build nach Modul 011
- vollständige 155 Tests
- Gesten-End-to-End
- Audiohörbarkeit
- 1,5-Sekunden-Transitions
- Ergebnis-/Resetprüfung
- finale Blender-Monster
- Gerätetestplanung

Wenn eines dieser Muss-Themen durch Modul 012 zeitlich gefährdet wird:

**Modul 012 nicht implementieren.**

Dann im Report nur dokumentieren:

- F-17 bewusst ausgelassen
- Begründung: Fokus auf Muss-Anforderungen
- Empfehlung: direkt Modul 013

## Vorab-Check

Ermittle:

- aktuellen Branch
- aktuellen Commit
- tatsächlichen Modul-011-Commit
- Working Tree
- Buildstatus
- Teststand
- Simulatorstand
- Assetstatus

Prüfe außerdem, ob die echten Blender-Monster inzwischen vorliegen.

Wenn weiterhin nur USDA-Kugeln vorhanden sind, ist eine sinnvolle Gesichts-/Animationsreaktion möglicherweise nicht umsetzbar. In diesem Fall bevorzugt Modul 012 auslassen statt eine künstliche neue Asset-Lösung aufzubauen.

## Bevorzugte Implementierung

Nur wenn bereits geeignete Monsterassets oder vorhandene Animationsmöglichkeiten existieren:

- richtige Entscheidung → kurze positive Reaktion
- falsche Entscheidung → kurze negative Reaktion
- Reaktion dauert höchstens innerhalb des bestehenden Feedbackfensters
- kein zusätzlicher Delay
- kein Einfluss auf Score
- kein Einfluss auf Phase
- kein Einfluss auf Input-Lock
- kein Einfluss auf Ticketindex

Die Reaktion darf den bestehenden 1,5-Sekunden-Flow aus Modul 010 nicht verlängern oder blockieren.

## Keine Lösungsinformation

Die Reaktion darf nur Richtig/Falsch signalisieren.

Sie darf niemals verraten:

- welche Priorität richtig gewesen wäre
- welches Team richtig gewesen wäre
- welche Referenzwerte gespeichert sind

Kein Text.

## Architektur

Bevorzuge eine sehr kleine, klar isolierte Lösung.

Geeignet wären beispielsweise:

- vorhandene Animation abspielen
- kurze Skalierungs-/Positions-/Rotationsreaktion
- vorhandenen Morph/Blendshape triggern

Nur wenn im realen Asset technisch vorhanden.

Keine neue allgemeine Animationsengine.

## Integration

Die Reaktion darf nur an das bereits vorhandene boolesche Bewertungsergebnis aus Modul 010 gekoppelt werden.

Nicht erneut:

- `referencePriority` vergleichen
- `referenceTeam` vergleichen
- Score berechnen

Die Bewertung bleibt alleinige Verantwortung von Modul 010.

## Tests

Bestehende 155 Tests erhalten.

Falls Modul 012 umgesetzt wird, mindestens prüfen:

- richtige Reaktion verändert Score nicht
- falsche Reaktion verändert Score nicht
- Phase bleibt während Reaktion unverändert
- Ticketindex bleibt unverändert
- Reaktion verändert gespeicherte Entscheidungen nicht
- kein zusätzlicher Feedbackdelay
- Reset hinterlässt keinen Reaktionszustand

Visuelle Animation zusätzlich im Simulator/Gerät prüfen.

## Simulator-/Geräteprüfung

Wenn implementiert:

- richtige Entscheidung → positive Reaktion sichtbar
- falsche Entscheidung → negative Reaktion sichtbar
- Sound weiterhin hörbar
- Übergang weiterhin nach ca. 1,5 s
- keine Lösung sichtbar
- keine Interaktionsblockade zusätzlich zum bestehenden Lock

## Git

Falls umgesetzt:

`012: Optionale Monsterreaktion`

Falls ausgelassen:

Keinen leeren Feature-Commit nur für F-17 erzeugen, außer eure Projektdokumentation verlangt dies ausdrücklich.

## Ausgabeformat

1. Vorab-Check
2. Entscheidung: umsetzen oder bewusst auslassen
3. Falls umgesetzt: technische Reaktion
4. Änderungen je Datei
5. Tests/Simulator
6. vollständiger `012-Report.md`

Der Report muss explizit festhalten:

- F-17 ist optional
- kein Highscore/Persistenz
- keine richtige Lösung sichtbar
- kein Einfluss auf Score/Flow
- Status der finalen Blender-Monster
- Empfehlung für Modul 013

Wenn Modul 012 ausgelassen wird, reicht ein sauberer kurzer Report mit Entscheidung und Begründung.
