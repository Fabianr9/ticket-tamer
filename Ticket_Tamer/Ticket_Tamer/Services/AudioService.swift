import AVFoundation

/// Zentrale Wiedergabe lokaler Monster- und Streak-Sounds (Modul 029).
/// Audiofehler beeinflussen weder Bewertung noch Score oder Phasenwechsel.
@MainActor
final class AudioService {
    private var monsterFeedbackPlayer: AVAudioPlayer?
    private var streakPlayer: AVAudioPlayer?

    /// Waehlt und startet genau einen Monster-Sound fuer eine erfolgte Bewertung.
    /// Der Selector ist fuer Tests injizierbar; produktiv wird mit erlaubter direkter
    /// Wiederholung unabhaengig per `randomElement()` ausgewaehlt.
    @discardableResult
    func playMonsterFeedback(
        evaluation: Bool?,
        selector: MonsterFeedbackSoundCatalog.Selector = { $0.randomElement() }
    ) -> LocalAudioResource? {
        guard let resource = MonsterFeedbackSoundCatalog.select(for: evaluation, using: selector) else {
            if evaluation != nil {
                DebugManager.log(.audio, "Keine gueltige Monster-Soundressource ausgewaehlt")
            }
            return nil
        }

        monsterFeedbackPlayer = loadPlayer(resource)
        guard let monsterFeedbackPlayer else { return resource }
        monsterFeedbackPlayer.currentTime = 0
        monsterFeedbackPlayer.play()
        let group = evaluation == true ? "correct" : "incorrect"
        DebugManager.log(.audio, "Monster-Sound abgespielt [\(group)]: \(resource.fileName)")
        return resource
    }

    /// API fuer die spaetere Teamabschluss-Integration. Modul 029 verdrahtet sie
    /// bewusst noch nicht mit den Entscheidungs-Views.
    @discardableResult
    func playStreak(for streak: Int) -> LocalAudioResource? {
        guard let resource = StreakSoundCatalog.resource(forStreak: streak) else { return nil }
        streakPlayer = loadPlayer(resource)
        guard let streakPlayer else { return resource }
        streakPlayer.currentTime = 0
        streakPlayer.play()
        DebugManager.log(.audio, "Streak-Sound abgespielt: \(resource.fileName), Streak: \(streak)")
        return resource
    }

    private func loadPlayer(_ resource: LocalAudioResource) -> AVAudioPlayer? {
        guard let url = resource.url() else {
            DebugManager.log(.audio, "Sound-Ressource nicht im Bundle: \(resource.subdirectory)/\(resource.fileName)")
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            DebugManager.log(.audio, "AVAudioPlayer-Fehler fuer \(resource.fileName): \(error.localizedDescription)")
            return nil
        }
    }
}
