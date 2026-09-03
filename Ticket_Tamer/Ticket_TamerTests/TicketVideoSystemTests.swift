import Foundation
import Testing
@testable import Ticket_Tamer

@Suite("Modul 030 — Ticketvideo-System")
@MainActor
struct TicketVideoSystemTests {
    private var tickets: [Ticket] { LocalTicketCatalog.allTickets }

    @Test("Exakt 16 Ticketvideo-Referenzen sind vorhanden")
    func exactReferenceCount() { #expect(tickets.count == 16) }

    @Test("TT-001 verweist auf TT-001.mp4")
    func firstMapping() { #expect(tickets[0].videoAssetName == "TT-001.mp4") }

    @Test("TT-007 verweist auf TT-007.mp4")
    func seventhMapping() { #expect(tickets[6].videoAssetName == "TT-007.mp4") }

    @Test("TT-016 verweist auf TT-016.mp4")
    func lastMapping() { #expect(tickets[15].videoAssetName == "TT-016.mp4") }

    @Test("Alle Video-Referenzen sind eindeutig")
    func referencesAreUnique() { #expect(Set(tickets.map(\.videoAssetName)).count == 16) }

    @Test("Alle Video-Referenzen verwenden MP4")
    func referencesAreMP4() { #expect(tickets.allSatisfy { $0.videoAssetName.hasSuffix(".mp4") }) }

    @Test("Video-Referenzen enthalten keine Netzwerk-URL")
    func referencesAreLocal() {
        #expect(tickets.allSatisfy { !$0.videoAssetName.lowercased().hasPrefix("http") })
    }

    @Test("Video-Referenzen enthalten keine absoluten Pfade")
    func referencesHaveNoAbsolutePaths() {
        #expect(tickets.allSatisfy { !$0.videoAssetName.hasPrefix("/") })
    }

    @Test("Provider lehnt eine fehlende Ressource defensiv ab")
    func missingResourceIsNil() {
        #expect(TicketVideoResourceProvider().url(for: "TT-999.mp4") == nil)
    }

    @Test("Provider lehnt HTTP-Referenzen ab")
    func providerRejectsHTTP() {
        #expect(TicketVideoResourceProvider().url(for: "https://example.test/video.mp4") == nil)
    }

    @Test("Provider lehnt absolute Pfade ab")
    func providerRejectsAbsolutePath() {
        #expect(TicketVideoResourceProvider().url(for: "/tmp/TT-001.mp4") == nil)
    }

    @Test("Provider lehnt andere Dateiendungen ab")
    func providerRejectsWrongExtension() {
        #expect(TicketVideoResourceProvider().url(for: "TT-001.mov") == nil)
    }

    @Test("Provider lehnt leere Referenzen ab")
    func providerRejectsEmptyReference() {
        #expect(TicketVideoResourceProvider().url(for: "") == nil)
    }

    @Test("Provider lehnt Verzeichniswechsel ab")
    func providerRejectsTraversal() {
        #expect(TicketVideoResourceProvider().url(for: "../TT-001.mp4") == nil)
    }

    @Test("Provider-Aufruf veraendert das Ticket nicht")
    func providerDoesNotMutateTicket() {
        let ticket = tickets[0]
        _ = TicketVideoResourceProvider().url(for: ticket.videoAssetName)
        #expect(ticket == tickets[0])
    }

    @Test("Bundle-Lookup findet alle 16 produktiven Videos")
    func bundleContainsEveryTicketVideo() {
        let provider = TicketVideoResourceProvider()
        #expect(tickets.allSatisfy { provider.url(for: $0.videoAssetName) != nil })
    }

    @Test("Praesentationszustand startet geschlossen")
    func presentationStartsClosed() {
        #expect(!TicketVideoPresentationState().isPresented)
    }

    @Test("Explizites Oeffnen aktiviert die Praesentation")
    func explicitOpenPresentsVideo() {
        var state = TicketVideoPresentationState()
        state.present(videoAssetName: "TT-007.mp4")
        #expect(state.presentedAssetName == "TT-007.mp4")
    }

    @Test("Leere Referenz oeffnet keine Praesentation")
    func emptyReferenceDoesNotOpen() {
        var state = TicketVideoPresentationState()
        state.present(videoAssetName: "")
        #expect(!state.isPresented)
    }

    @Test("Schliessen deaktiviert die Praesentation")
    func closeDismissesVideo() {
        var state = presentedState()
        state.close()
        #expect(!state.isPresented)
    }

    @Test("Ticketwechsel schliesst ein offenes Video")
    func ticketChangeDismissesVideo() {
        var state = presentedState()
        state.closeIfTicketChanged(to: "TT-008.mp4")
        #expect(!state.isPresented)
    }

    @Test("Dasselbe Ticket laesst das offene Video bestehen")
    func sameTicketKeepsVideo() {
        var state = presentedState()
        state.closeIfTicketChanged(to: "TT-007.mp4")
        #expect(state.isPresented)
    }

    @Test("Phasenwechsel schliesst ein offenes Video")
    func phaseChangeDismissesVideo() {
        var state = presentedState()
        state.closeIfInvestigationEnded(.priorisieren)
        #expect(!state.isPresented)
    }

    @Test("Untersuchungsphase schliesst das Video nicht")
    func investigationKeepsVideo() {
        var state = presentedState()
        state.closeIfInvestigationEnded(.untersuchen)
        #expect(state.isPresented)
    }

    @Test("Wiederholtes Oeffnen erzeugt nur einen aktiven Zustand")
    func repeatedOpenKeepsSingleAsset() {
        var state = presentedState()
        state.present(videoAssetName: "TT-008.mp4")
        #expect(state.presentedAssetName == "TT-007.mp4")
    }

    @Test("Mehrfaches Schliessen bleibt idempotent")
    func repeatedCloseIsIdempotent() {
        var state = presentedState()
        state.close()
        state.close()
        #expect(!state.isPresented)
    }

    @Test("Erneutes Oeffnen nach Schliessen ist moeglich")
    func reopenAfterClose() {
        var state = presentedState()
        state.close()
        state.present(videoAssetName: "TT-007.mp4")
        #expect(state.isPresented)
    }

    @Test("Fehlendes Folgeticket schliesst ein offenes Video")
    func absentTicketDismissesVideo() {
        var state = presentedState()
        state.closeIfTicketChanged(to: nil)
        #expect(!state.isPresented)
    }

    @Test("Manuelles Schliessen schuetzt den Fachzustand")
    func manualCloseProtectsDomainState() {
        let model = startedModel()
        let before = snapshot(model)
        var state = presentedState()
        state.close()
        #expect(snapshot(model) == before)
    }

    @Test("Auto-Close schuetzt den Fachzustand")
    func automaticCloseProtectsDomainState() {
        let model = startedModel()
        let before = snapshot(model)
        var state = presentedState()
        state.close()
        #expect(snapshot(model) == before)
    }

    @Test("Fehlende Ressource schuetzt den Fachzustand")
    func missingResourceProtectsDomainState() {
        let model = startedModel()
        let before = snapshot(model)
        _ = TicketVideoResourceProvider().url(for: "missing.mp4")
        #expect(snapshot(model) == before)
    }

    @Test("Schliessen veraendert den Score nicht")
    func closeKeepsScore() {
        let model = startedModel()
        var state = presentedState()
        state.close()
        #expect(model.score == 0)
    }

    @Test("Schliessen veraendert den Ticketindex nicht")
    func closeKeepsIndex() {
        let model = startedModel()
        var state = presentedState()
        state.close()
        #expect(model.currentTicketIndex == 0)
    }

    @Test("Schliessen veraendert die Untersuchungsphase nicht")
    func closeKeepsPhase() {
        let model = startedModel()
        var state = presentedState()
        state.close()
        #expect(model.currentPhase == .untersuchen)
    }

    @Test("Schliessen veraendert Entscheidungen nicht")
    func closeKeepsDecisions() {
        let model = startedModel()
        var state = presentedState()
        state.close()
        #expect(model.selectedPriority == nil)
        #expect(model.selectedTeam == nil)
    }

    @Test("Schliessen veraendert den Input-Lock nicht")
    func closeKeepsInputLock() {
        let model = startedModel()
        var state = presentedState()
        state.close()
        #expect(!model.isInputLocked)
    }

    @Test("Schliessen veraendert das Monster-Mapping nicht")
    func closeKeepsMonsterMapping() {
        let model = startedModel()
        let variants = model.selectedMonsterVariantByTicketID
        var state = presentedState()
        state.close()
        #expect(model.selectedMonsterVariantByTicketID == variants)
    }

    @Test("Weiter zur Priorisierung bleibt fachlich unveraendert")
    func continuationStillChangesOnlyPhase() {
        let model = startedModel()
        let ticket = model.currentTicket
        let index = model.currentTicketIndex
        let score = model.score
        model.beginPrioritizationPhase()
        #expect(model.currentPhase == .priorisieren)
        #expect(model.currentTicket == ticket)
        #expect(model.currentTicketIndex == index)
        #expect(model.score == score)
    }

    private func presentedState() -> TicketVideoPresentationState {
        var state = TicketVideoPresentationState()
        state.present(videoAssetName: "TT-007.mp4")
        return state
    }

    private func startedModel() -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 }, variantSelector: { $0.first })
        return model
    }

    private func snapshot(_ model: SessionModel) -> DomainSnapshot {
        DomainSnapshot(
            ticket: model.currentTicket,
            index: model.currentTicketIndex,
            phase: model.currentPhase,
            score: model.score,
            priority: model.selectedPriority,
            team: model.selectedTeam,
            inputLocked: model.isInputLocked,
            variants: model.selectedMonsterVariantByTicketID
        )
    }
}

private struct DomainSnapshot: Equatable {
    let ticket: Ticket?
    let index: Int
    let phase: GamePhase
    let score: Int
    let priority: TicketPriority?
    let team: SupportTeam?
    let inputLocked: Bool
    let variants: [Ticket.ID: MonsterAssetVariant]
}
