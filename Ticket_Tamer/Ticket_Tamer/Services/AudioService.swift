//
//  AudioService.swift
//  Ticket_Tamer
//
//  Modul 010 — F-12: Lokales Richtig-/Falsch-Audiofeedback
//
//  Gewählte API: AVFoundation / AVAudioPlayer
//  Begründung: AVAudioPlayer ist die standardmäßige, synchrone, lokal arbeitende
//  Abspiel-API auf allen Apple-Plattformen einschließlich visionOS. Sie benötigt
//  weder einen RealityKit-Render-Loop noch eine Netzwerkverbindung, erzeugt keinen
//  Overhead durch eine globale Service-Locator-Infrastruktur und bietet
//  genug Kontrolle für genau-einmal-Semantik (play() + stop()). RealityKit-
//  Audio-Entities wären erst sinnvoll, wenn räumlich positionierter 3D-Sound
//  benötigt würde — das ist in Modul 010 nicht gefordert.
//

import AVFoundation

// MARK: - Feedback-Sound-Enum

/// Fachlicher Feedback-Typ — wird nie als Text in der UI dargestellt.
enum FeedbackSound {
    /// Richtige Entscheidung.
    case correct
    /// Falsche Entscheidung.
    case incorrect
}

// MARK: - AudioService

/// Schlanke Kapselung für das lokale Richtig-/Falsch-Audiofeedback (F-12).
///
/// Lädt beide Ressourcen bei der Initialisierung aus dem App-Bundle.
/// Fehler beim Laden werden über `DebugManager.audio` dokumentiert; kein Crash.
/// Kein globaler Service-Locator — wird als lokale Instanz in den Views gehalten.
@MainActor
final class AudioService {

    // MARK: - Private Zustand

    private var correctPlayer: AVAudioPlayer?
    private var incorrectPlayer: AVAudioPlayer?

    // MARK: - Init

    init() {
        correctPlayer = loadPlayer(name: FeedbackConstants.correctSoundName,
                                   ext: FeedbackConstants.soundExtension)
        incorrectPlayer = loadPlayer(name: FeedbackConstants.incorrectSoundName,
                                    ext: FeedbackConstants.soundExtension)
    }

    // MARK: - Abspielen

    /// Spielt genau einen Feedback-Sound ab.
    ///
    /// Jeder Aufruf startet die Wiedergabe von Beginn an (keine Überlagerung).
    /// Fehler werden geloggt, kein Absturz, kein doppelter Punkt-Vergabeweg.
    ///
    /// - Parameter sound: `.correct` oder `.incorrect`.
    func play(_ sound: FeedbackSound) {
        switch sound {
        case .correct:
            guard let player = correctPlayer else {
                DebugManager.log(.audio, "Richtig-Sound nicht verfügbar (Player nil)")
                return
            }
            player.currentTime = 0
            player.play()
            DebugManager.log(.audio, "Richtig-Sound abgespielt: \(FeedbackConstants.correctSoundName).\(FeedbackConstants.soundExtension)")

        case .incorrect:
            guard let player = incorrectPlayer else {
                DebugManager.log(.audio, "Falsch-Sound nicht verfügbar (Player nil)")
                return
            }
            player.currentTime = 0
            player.play()
            DebugManager.log(.audio, "Falsch-Sound abgespielt: \(FeedbackConstants.incorrectSoundName).\(FeedbackConstants.soundExtension)")
        }
    }

    // MARK: - Laden

    /// Lädt eine Bundle-Ressource als `AVAudioPlayer` oder gibt nil zurück.
    private func loadPlayer(name: String, ext: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            DebugManager.log(.audio, "Sound-Ressource nicht im Bundle: \(name).\(ext)")
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            DebugManager.log(.audio, "Sound geladen: \(name).\(ext)")
            return player
        } catch {
            DebugManager.log(.audio, "AVAudioPlayer-Fehler für \(name).\(ext): \(error.localizedDescription)")
            return nil
        }
    }
}
