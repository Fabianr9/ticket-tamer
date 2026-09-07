import SwiftUI

// MARK: - Interaction Hint Content

/// Lokalisierte, exakt festgelegte Hinweise der beiden Zuweisungsphasen.
enum InteractionHintContent {
    static var prioritization: String {
        String(localized: "interactionHint.prioritization")
    }

    static var teamAssignment: String {
        String(localized: "interactionHint.teamAssignment")
    }
}

// MARK: - Interaction Hint View

/// Dauerhafter, nicht interaktiver Hinweis fuer die benoetigte Drag-Geste.
struct InteractionHintView: View {
    let text: String

    var body: some View {
        Label(text, systemImage: "hand.draw")
            .font(.callout)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .glassBackgroundEffect(in: Capsule())
            .allowsHitTesting(false)
    }
}
