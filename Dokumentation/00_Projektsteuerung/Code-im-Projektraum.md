# Code im Projektraum handhaben

Wie geht man mit dem wachsenden Projekt-Code um, wenn im **Projektraum mit hinterlegtem Kontext** gearbeitet wird?

## Das Kernproblem (und seine Ursache)

Ein Projektraum ist ein **Wissensspeicher mit Ähnlichkeitssuche — kein Versionsverwaltungssystem.** Er kennt keine Historie, nur „Dokumente". Legt man Code aus verschiedenen Phasen ab, existieren gleichnamige Dateien mehrfach (`XView.swift` alt + neu). Die Suche zieht dann auch den **alten** Stand hervor — und schon wird eine längst überarbeitete Datei erneut reklamiert. Genau das hast du erlebt.

**Grundregel:** Der Projektraum hält immer **nur den aktuellen Stand**, niemals eine Historie. Historie gehört in **Git** (auf der Platte). Jede zweite, gleichnamige Altkopie ist die Fehlerquelle.

## Empfehlung (gestuft)

### A) Bevorzugt: Code gehört gar nicht in den Projektraum

Im Raum liegen nur die **Dokumente**: Projektbeschreibung, SPEC, Akzeptanzkriterien, aktueller `Logbuch-Stand.md`, Modul-Reports. Der **Code-Wahrheitsstand ist das Xcode-Projekt + Git**; jedes Modul ist ein Commit. Der Steuer-Chat (Logbuch) braucht keinen Volltext-Code, sondern **Zustand und Schnittstellen** — und die stehen ohnehin in den Reports und im Schnittstellen-Register. Wenn ein **Modul-Chat** konkrete Dateien braucht, fügt die/der Studierende sie **frisch von der Platte** ein (immer der echte, aktuelle Stand).

Ergänzend als „Landkarte": ein einziges, stets aktuelles **`Projekt-Stand.md`** (Dateibaum + Zweck je Datei + öffentliche Schnittstellen), das nach jedem Modul neu erzeugt und **ersetzt** wird. Klein, lesbar, eindeutig — und für die Suche unverwechselbar.

### B) Falls Code im Raum sichtbar sein soll: genau EIN aktuelles Textbündel

Dann **eine** flache Textbündelung, z. B. `Aktueller-Code.md`, in der alle `.swift`-Dateien mit einer Pfad-Überschrift aneinandergehängt sind — **replace-in-place** nach jedem Modul, **nie** eine zweite oder ältere Kopie. Vorteil gegenüber ZIP: Der Raum kann **Text lesen und durchsuchen**; ein ZIP ist für das Modell praktisch undurchsichtig (Inhalt wird nicht zuverlässig indexiert) und schleppt `.xcodeproj`-/Binärrauschen mit.

## Zu deinem ZIP-Vorschlag

Als **menschlicher Checkpoint/Backup** ist das ZIP sinnvoll — als **Maschinen-Kontext** aber schwach: Das Modell „sieht" in der Regel nicht in die ZIP hinein, und der Austausch löst das Grundproblem nur, wenn wirklich **vollständig ersetzt** wird. Wenn ZIP, dann bitte: strikt ersetzen (nie zwei Stände gleichzeitig), plus ein lesbares `Projekt-Stand.md` als eigentlicher Kontext, plus das von dir vorgeschlagene **README.md** mit Kurzstand — das README ist eine gute Idee, behalte es.

## Warum die Namensgleichheit der Auslöser war

Zwei Dateien mit identischem Namen (alt + neu) im selben Speicher → die Suche kann die alte treffen. Die Lösung ist in **allen** Varianten dieselbe: immer nur **ein** Exemplar, Alt-Stände sofort entfernen, Historie ausschließlich in Git.

## Der Cowork-Fall (zum Vergleich)

Arbeitet man stattdessen im **Cowork-Verfahren**, liest das Modell den **Live-Ordner** — immer aktuell, Git-gestützt. Das Duplikatsproblem entsteht dort gar nicht. Die Projektraum-Empfehlung ahmt genau das nach: **ein einziger aktueller Stand**, keine Archivkopien.

## Checkliste pro Modul

- [ ] Git-Commit `00X: …` (das ist die Historie — nicht der Projektraum).
- [ ] `Projekt-Stand.md` neu erzeugen und im Raum **ersetzen** (nicht danebenlegen).
- [ ] Optional Code-Bündel/ZIP ebenfalls **ersetzen** + README-Kurzstand aktualisieren.
- [ ] `Logbuch-Stand.md` aktualisieren.
- [ ] Prüfen: Liegt im Raum noch **irgendein** Altstand mit gleichem Namen? → löschen.
