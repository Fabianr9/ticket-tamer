# Vorschlag für die GitHub-Repository-Struktur — Ticket Tamer

## Status der Festlegung

- Die **Dokumentationsstruktur** wird mit diesem Vorschlag verbindlich festgelegt.
- Die interne **Xcode-, Swift- und Target-Struktur** ist ausdrücklich nur ein Prüfrahmen. Ihre endgültige Form wird erst in Modul 001 nach Analyse des vorhandenen Xcode-Projekts eingerichtet.
- Bestehende Xcode-Dateien, Target-Namen und Gruppen dürfen nicht anhand dieses Vorschlags angenommen oder erfunden werden.
- Für 3D- und Audio-Assets gibt es jeweils genau einen fachlichen Wahrheitsstand. Doppelte, voneinander abweichende Exportkopien sind zu vermeiden.

## Repository-Baum

```text
Ticket-Tamer/
├─ README.md
├─ .gitignore
│
├─ Code/
│  └─ Ticket Tamer/                         # vorhandenes Xcode-Projekt
│     ├─ [Xcode-Projektdateien]              # Ist-Zustand in Modul 001 prüfen
│     ├─ [App-Target]                        # exakten Namen und Pfad in Modul 001 prüfen
│     │  ├─ App/                             # vorgeschlagener Verantwortungsbereich
│     │  ├─ Views/                           # vorgeschlagener Verantwortungsbereich
│     │  ├─ Models/                          # vorgeschlagener Verantwortungsbereich
│     │  ├─ Entities/                        # vorgeschlagener Verantwortungsbereich
│     │  ├─ Components/                      # vorgeschlagener Verantwortungsbereich
│     │  ├─ Protocols/                       # vorgeschlagener Verantwortungsbereich
│     │  ├─ Extensions/                      # vorgeschlagener Verantwortungsbereich
│     │  ├─ Services/                        # vorgeschlagener Verantwortungsbereich
│     │  ├─ Debug/                           # vorgeschlagener Ort für DebugManager.swift
│     │  └─ Resources/                       # Runtime-Ressourcen des App-Bundles
│     │     ├─ Localization/
│     │     ├─ Audio/
│     │     └─ Models3D/
│     ├─ [Swift-Testing-Target]              # Namen und aktuellen Inhalt in Modul 001 prüfen
│     │  ├─ Unit/
│     │  └─ Integration/
│     └─ RealityKitContent/                  # laut Ausgangsstand vorhandenes Package
│
├─ Assets/
│  ├─ 3D/
│  │  ├─ Blender-Source/                     # editierbare .blend-Dateien
│  │  ├─ Exports/                            # freigegebene RealityKit-kompatible Exporte
│  │  ├─ Previews/                           # Vorschaubilder für Doku und Review
│  │  └─ Asset-Register.md                   # Name, Version, Ursprung, Einsatz, Status
│  ├─ Audio/
│  │  ├─ Source/                             # editierbare oder unbearbeitete Ausgangsdateien
│  │  ├─ Exports/                            # freigegebene App-Audiodateien
│  │  └─ Audio-Register.md                   # Ursprung, Lizenz, Lautstärkeprüfung, Status
│  └─ Quellen-und-Lizenzen.md
│
├─ Dokumentation/
│  ├─ 00_Projektsteuerung/
│  │  ├─ Start-Prompt-Projektlogbuch.md
│  │  └─ Code-im-Projektraum.md
│  ├─ 01_Kontext/
│  │  ├─ Projektbeschreibung.md
│  │  ├─ SPEC.md
│  │  └─ Akzeptanzkriterien.md
│  ├─ 02_Vorlagen/
│  │  ├─ Projektlogbuch-Vorlage.md
│  │  ├─ Projekt-Stand-Vorlage.md
│  │  ├─ Modul-Eingangsprompt-Vorlage.md
│  │  └─ Modul-Report-Vorlage.md
│  ├─ 03_Modul-Eingangsprompts/
│  │  ├─ 001-Eingangsprompt.md
│  │  ├─ 002-Eingangsprompt.md
│  │  └─ ...
│  ├─ 04_Modul-Reports/
│  │  ├─ 001-Report.md
│  │  ├─ 002-Report.md
│  │  └─ ...
│  ├─ 05_Aktueller-Stand/
│  │  ├─ Logbuch-Stand.md
│  │  └─ Projekt-Stand.md
│  └─ 06_Abgabe/
│     ├─ KI-Dokumentation/
│     ├─ Quellen-und-Assets.md
│     ├─ Abgabe-Checkliste.md
│     └─ README-Abgabe.md
│
└─ Vorlagen/
   └─ DebugManager.swift                     # bereitgestellte Codevorlage, noch nicht App-Code
```

## Verbindliche Regeln für die Dokumentation

1. `Dokumentation/05_Aktueller-Stand/Logbuch-Stand.md` und `Projekt-Stand.md` existieren jeweils genau einmal und werden nach jedem Modul ersetzt.
2. Eingangsprompts und Modul-Reports werden nummeriert und nicht überschrieben, weil sie die Übergaben zwischen den Modul-Chats dokumentieren.
3. Historische Code-Stände werden nicht als zusätzliche Dateien in den Projektraum gelegt. Die Code-Historie liegt ausschließlich in Git.
4. `Projekt-Stand.md` beschreibt nur den aktuell bestätigten Dateibaum, den Zweck der Dateien und öffentliche Schnittstellen.
5. Noch nicht geprüfte Xcode-Dateien oder Gruppen werden weder in `Projekt-Stand.md` noch in Eingangsprompts als vorhanden behauptet.
6. Der bereitgestellte `DebugManager.swift` bleibt bis zur kontrollierten Integration in Modul 001 unter `Vorlagen/` und wird nicht parallel als zweite aktive Projektdatei geführt.

## Technische Prüfaufgabe für Modul 001

Modul 001 muss den tatsächlichen Xcode-Dateibaum, die Target-Zugehörigkeiten, die physischen Ordner und die Xcode-Gruppen prüfen. Danach richtet es eine einfache Struktur ein, die SwiftUI, RealityKit, Zustands-/Datenmodelle, Services, Debugging, Ressourcen und Tests trennt. Die oben genannten technischen Unterordner sind Kandidaten, keine vorweggenommene endgültige Architektur.
