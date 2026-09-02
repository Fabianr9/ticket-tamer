import SwiftUI

// MARK: - Compact ticket information

/// The complete, presentation-only data set used by the compact ticket overlay.
///
/// Deliberately contains no reference answer, selection, score, internal ticket ID, or
/// monster asset identifier. This keeps the decision phases free of solution hints.
struct CompactTicketInfoContent: Equatable {
    let ticketNumber: String
    let title: String
    let shortDescription: String
    let userImpact: String
    let symptoms: [String]

    init(ticket: Ticket) {
        ticketNumber = ticket.ticketNumber
        title = ticket.title
        shortDescription = ticket.shortDescription
        userImpact = ticket.userImpact
        symptoms = ticket.symptoms
    }
}

/// Small, testable rules for the view-local overlay state.
enum TicketInfoInteraction {
    static let initialPresentation = false

    static func toggled(_ isPresented: Bool) -> Bool {
        !isPresented
    }

    static func isDragEnabled(isPresented: Bool, isInputLocked: Bool) -> Bool {
        !isPresented && !isInputLocked
    }
}

/// Compact ticket overview used in prioritization and team assignment.
struct CompactTicketInfoView: View {
    private let content: CompactTicketInfoContent
    let onClose: () -> Void

    init(ticket: Ticket, onClose: @escaping () -> Void) {
        content = CompactTicketInfoContent(ticket: ticket)
        self.onClose = onClose
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Text(content.ticketNumber)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(Text("investigation.ticketNumber.label") + Text(content.ticketNumber))

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.headline)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .accessibilityLabel(Text("ticketInfo.close.accessibility"))
            }

            Text(content.title)
                .font(.title2.bold())
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            Text(content.shortDescription)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            informationSection(label: "investigation.userImpact.label", text: content.userImpact)

            VStack(alignment: .leading, spacing: 6) {
                Text("investigation.symptoms.label")
                    .font(.headline)

                ForEach(Array(content.symptoms.enumerated()), id: \.offset) { _, symptom in
                    Label(symptom, systemImage: "circle.fill")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(
            width: LayoutConstants.compactTicketInfoDesignWidth,
            height: LayoutConstants.compactTicketInfoDesignHeight,
            alignment: .topLeading
        )
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 24))
        .accessibilityElement(children: .contain)
    }

    private func informationSection(label: LocalizedStringKey, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.headline)
            Text(text)
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
