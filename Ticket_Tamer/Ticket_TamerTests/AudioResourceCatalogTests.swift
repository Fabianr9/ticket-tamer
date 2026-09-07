import Testing
@testable import Ticket_Tamer

@Suite("Modul 029 — Monster- und Streak-Audio")
struct AudioResourceCatalogTests {
    @Test("Correct-Gruppe enthaelt exakt vier Sounds")
    func fourCorrectSounds() { #expect(MonsterFeedbackSoundCatalog.correct.count == 4) }

    @Test("Incorrect-Gruppe enthaelt exakt vier Sounds")
    func fourIncorrectSounds() { #expect(MonsterFeedbackSoundCatalog.incorrect.count == 4) }

    @Test("Streak-Gruppe enthaelt exakt zwei Sounds")
    func twoStreakSounds() { #expect(StreakSoundCatalog.all.count == 2) }

    @Test("v1.3-Katalog enthaelt insgesamt zehn Sounds")
    func tenSoundsTotal() { #expect(MonsterFeedbackSoundCatalog.all.count + StreakSoundCatalog.all.count == 10) }

    @Test("Alle Ressourcennamen sind befuellt")
    func resourceNamesAreNotEmpty() {
        #expect(allResources.allSatisfy { !$0.name.isEmpty })
    }

    @Test("Alle Ressourcen sind WAV-Dateien")
    func allResourcesAreWav() {
        #expect(allResources.allSatisfy { $0.fileExtension.lowercased() == "wav" })
    }

    @Test("Alle Ressourcennamen sind eindeutig")
    func resourceNamesAreUnique() {
        #expect(Set(allResources.map(\.fileName)).count == 10)
    }

    @Test("Keine Ressource verwendet eine Netzwerk-URL")
    func noNetworkURLs() {
        #expect(allResources.allSatisfy { !$0.name.lowercased().hasPrefix("http") })
    }

    @Test("Keine Ressource verwendet einen absoluten Pfad")
    func noAbsolutePaths() {
        #expect(allResources.allSatisfy { !$0.name.hasPrefix("/") && !$0.subdirectory.hasPrefix("/") })
    }

    @Test("Correct-Sounds liegen in der Correct-Struktur")
    func correctSubdirectory() {
        #expect(MonsterFeedbackSoundCatalog.correct.allSatisfy { $0.subdirectory.hasSuffix("/Correct") })
    }

    @Test("Incorrect-Sounds liegen in der Incorrect-Struktur")
    func incorrectSubdirectory() {
        #expect(MonsterFeedbackSoundCatalog.incorrect.allSatisfy { $0.subdirectory.hasSuffix("/Incorrect") })
    }

    @Test("Streak-Sounds liegen in der Streak-Struktur")
    func streakSubdirectory() {
        #expect(StreakSoundCatalog.all.allSatisfy { $0.subdirectory.hasSuffix("/StreakSounds") })
    }

    @Test("True mappt ausschliesslich auf Correct")
    func trueMapsToCorrect() {
        #expect(MonsterFeedbackSoundCatalog.candidates(for: true) == MonsterFeedbackSoundCatalog.correct)
    }

    @Test("False mappt ausschliesslich auf Incorrect")
    func falseMapsToIncorrect() {
        #expect(MonsterFeedbackSoundCatalog.candidates(for: false) == MonsterFeedbackSoundCatalog.incorrect)
    }

    @Test("Nil-Bewertung erzeugt keine Kandidaten")
    func nilMapsToNoSound() {
        #expect(MonsterFeedbackSoundCatalog.candidates(for: nil).isEmpty)
        #expect(MonsterFeedbackSoundCatalog.select(for: nil, using: { $0.first }) == nil)
    }

    @Test("Correct-Selector kann Variante 1 waehlen")
    func correctVariant1() { expectSelection(true, index: 0) }

    @Test("Correct-Selector kann Variante 2 waehlen")
    func correctVariant2() { expectSelection(true, index: 1) }

    @Test("Correct-Selector kann Variante 3 waehlen")
    func correctVariant3() { expectSelection(true, index: 2) }

    @Test("Correct-Selector kann Variante 4 waehlen")
    func correctVariant4() { expectSelection(true, index: 3) }

    @Test("Incorrect-Selector kann Variante 1 waehlen")
    func incorrectVariant1() { expectSelection(false, index: 0) }

    @Test("Incorrect-Selector kann Variante 2 waehlen")
    func incorrectVariant2() { expectSelection(false, index: 1) }

    @Test("Incorrect-Selector kann Variante 3 waehlen")
    func incorrectVariant3() { expectSelection(false, index: 2) }

    @Test("Incorrect-Selector kann Variante 4 waehlen")
    func incorrectVariant4() { expectSelection(false, index: 3) }

    @Test("Direkte Correct-Wiederholung ist erlaubt")
    func repeatedCorrectSelection() {
        let selector: MonsterFeedbackSoundCatalog.Selector = { $0[2] }
        #expect(MonsterFeedbackSoundCatalog.select(for: true, using: selector) == MonsterFeedbackSoundCatalog.correct[2])
        #expect(MonsterFeedbackSoundCatalog.select(for: true, using: selector) == MonsterFeedbackSoundCatalog.correct[2])
    }

    @Test("Direkte Incorrect-Wiederholung ist erlaubt")
    func repeatedIncorrectSelection() {
        let selector: MonsterFeedbackSoundCatalog.Selector = { $0[1] }
        #expect(MonsterFeedbackSoundCatalog.select(for: false, using: selector) == MonsterFeedbackSoundCatalog.incorrect[1])
        #expect(MonsterFeedbackSoundCatalog.select(for: false, using: selector) == MonsterFeedbackSoundCatalog.incorrect[1])
    }

    @Test("Fremde Selector-Ressource wird verworfen")
    func foreignSelectionIsRejected() {
        #expect(MonsterFeedbackSoundCatalog.select(for: true, using: { _ in StreakSoundCatalog.sound01 }) == nil)
    }

    @Test("Leere Selector-Antwort erzeugt keinen Sound")
    func nilSelectionIsRejected() {
        #expect(MonsterFeedbackSoundCatalog.select(for: false, using: { _ in nil }) == nil)
    }

    @Test("Streak 0 und 1 haben keinen Sound")
    func noSoundBeforeStreak2() {
        #expect(StreakSoundCatalog.resource(forStreak: 0) == nil)
        #expect(StreakSoundCatalog.resource(forStreak: 1) == nil)
    }

    @Test("Negative Streakwerte haben keinen Sound")
    func noSoundForNegativeStreak() {
        #expect(StreakSoundCatalog.resource(forStreak: -1) == nil)
    }

    @Test("Streak 2 mappt auf Sound 01")
    func streak2UsesSound01() { #expect(StreakSoundCatalog.resource(forStreak: 2) == StreakSoundCatalog.sound01) }

    @Test("Streak 3 mappt auf Sound 01")
    func streak3UsesSound01() { #expect(StreakSoundCatalog.resource(forStreak: 3) == StreakSoundCatalog.sound01) }

    @Test("Streak 4 mappt auf Sound 02")
    func streak4UsesSound02() { #expect(StreakSoundCatalog.resource(forStreak: 4) == StreakSoundCatalog.sound02) }

    @Test("Streak 5 mappt auf Sound 02")
    func streak5UsesSound02() { #expect(StreakSoundCatalog.resource(forStreak: 5) == StreakSoundCatalog.sound02) }

    @Test("Streak 16 mappt auf Sound 02")
    func streak16UsesSound02() { #expect(StreakSoundCatalog.resource(forStreak: 16) == StreakSoundCatalog.sound02) }

    @Test("Streak-Mapping besitzt keinen kuenstlichen Cap")
    func streakHasNoArtificialCap() { #expect(StreakSoundCatalog.resource(forStreak: 10_000) == StreakSoundCatalog.sound02) }

    private var allResources: [LocalAudioResource] {
        MonsterFeedbackSoundCatalog.all + StreakSoundCatalog.all
    }

    private func expectSelection(_ evaluation: Bool, index: Int) {
        let candidates = MonsterFeedbackSoundCatalog.candidates(for: evaluation)
        #expect(MonsterFeedbackSoundCatalog.select(for: evaluation, using: { $0[index] }) == candidates[index])
    }
}
