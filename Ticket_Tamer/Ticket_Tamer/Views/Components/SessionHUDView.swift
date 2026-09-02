import SwiftUI

// MARK: - Session HUD Content

/// Rein darstellungsbezogene, defensiv begrenzte Werte fuer das Sitzungs-HUD.
struct SessionHUDContent: Equatable {
    let currentTicketNumber: Int
    let totalTicketCount: Int
    let progress: Double
    let phaseTitle: String

    init(currentTicketIndex: Int, totalTicketCount: Int, phase: GamePhase) {
        self.totalTicketCount = max(totalTicketCount, 0)

        if totalTicketCount > 0 {
            currentTicketNumber = min(max(currentTicketIndex + 1, 1), totalTicketCount)
            progress = min(max(Double(currentTicketNumber) / Double(totalTicketCount), 0), 1)
        } else {
            currentTicketNumber = 0
            progress = 0
        }

        phaseTitle = Self.title(for: phase)
    }

    static func title(for phase: GamePhase) -> String {
        switch phase {
        case .untersuchen:
            String(localized: "hud.phase.investigation")
        case .priorisieren:
            String(localized: "hud.phase.prioritization")
        case .teamZuordnen:
            String(localized: "hud.phase.teamAssignment")
        case .start, .ergebnis:
            ""
        }
    }
}

// MARK: - Session HUD View

/// Kompaktes, nicht interaktives HUD fuer Ticketnummer, Phase und Ticketfortschritt.
struct SessionHUDView: View {
    private let content: SessionHUDContent

    init(currentTicketIndex: Int, totalTicketCount: Int, phase: GamePhase) {
        content = SessionHUDContent(
            currentTicketIndex: currentTicketIndex,
            totalTicketCount: totalTicketCount,
            phase: phase
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 16) {
                Text(content.phaseTitle)
                    .font(.headline)
                Spacer(minLength: 8)
                Text(
                    String.localizedStringWithFormat(
                        String(localized: "hud.ticket.position"),
                        content.currentTicketNumber,
                        content.totalTicketCount
                    )
                )
                .font(.subheadline.monospacedDigit())
            }

            ProgressView(value: content.progress, total: 1)
                .progressViewStyle(.linear)
                .accessibilityLabel(Text("hud.progress.accessibility"))
                .accessibilityValue(Text(content.progress, format: .percent))
        }
        .frame(width: 320)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 18))
        .allowsHitTesting(false)
    }
}
