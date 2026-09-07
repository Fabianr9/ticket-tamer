import Foundation

/// Beschreibung einer lokalen WAV-Ressource, ohne Abhaengigkeit von einem konkreten Bundle.
struct LocalAudioResource: Equatable, Hashable {
    let name: String
    let fileExtension: String
    let subdirectory: String

    var fileName: String { "\(name).\(fileExtension)" }

    /// Unterstuetzt erhaltene Ordnerstrukturen und von Xcode flach kopierte Ressourcen.
    func url(in bundle: Bundle = .main) -> URL? {
        bundle.url(forResource: name, withExtension: fileExtension, subdirectory: subdirectory)
            ?? bundle.url(forResource: name, withExtension: fileExtension)
    }
}

enum MonsterFeedbackSoundCatalog {
    typealias Selector = ([LocalAudioResource]) -> LocalAudioResource?

    static let correctSubdirectory = "Audio/MonsterSounds/Correct"
    static let incorrectSubdirectory = "Audio/MonsterSounds/Incorrect"

    static let correct: [LocalAudioResource] = (1...4).map {
        LocalAudioResource(name: String(format: "monster_correct_%02d", $0), fileExtension: "wav", subdirectory: correctSubdirectory)
    }
    static let incorrect: [LocalAudioResource] = (1...4).map {
        LocalAudioResource(name: String(format: "monster_incorrect_%02d", $0), fileExtension: "wav", subdirectory: incorrectSubdirectory)
    }
    static var all: [LocalAudioResource] { correct + incorrect }

    static func candidates(for evaluation: Bool?) -> [LocalAudioResource] {
        guard let evaluation else { return [] }
        return evaluation ? correct : incorrect
    }

    /// Eine ungueltige Selector-Antwort wird verworfen statt eine fremde Ressource abzuspielen.
    static func select(for evaluation: Bool?, using selector: Selector = { $0.randomElement() }) -> LocalAudioResource? {
        let candidates = candidates(for: evaluation)
        guard !candidates.isEmpty,
              let selected = selector(candidates),
              candidates.contains(selected) else { return nil }
        return selected
    }
}

enum StreakSoundCatalog {
    static let subdirectory = "Audio/StreakSounds"
    static let sound01 = LocalAudioResource(name: "streak_01", fileExtension: "wav", subdirectory: subdirectory)
    static let sound02 = LocalAudioResource(name: "streak_02", fileExtension: "wav", subdirectory: subdirectory)
    static let all = [sound01, sound02]

    static func resource(forStreak streak: Int) -> LocalAudioResource? {
        switch streak {
        case ...1: nil
        case 2...3: sound01
        default: sound02
        }
    }
}
