import SwiftUI

enum StreakFeedbackEmphasis: Equatable {
    case normal
    case emphasized
}

/// Lokaler UI-Snapshot der fachlich bereits berechneten Teamabschlussdaten.
struct TeamFeedbackPresentation: Equatable {
    let decision: DecisionFeedbackPresentation
    let fullyCorrect: Bool
    let resultingStreak: Int

    init?(evaluation: Bool?, awardedPoints: Int, fullyCorrect: Bool, resultingStreak: Int) {
        guard let decision = DecisionFeedbackPresentation(
            evaluation: evaluation,
            awardedPoints: awardedPoints
        ) else { return nil }
        self.decision = decision
        self.fullyCorrect = fullyCorrect
        self.resultingStreak = resultingStreak
    }

    var streak: StreakFeedbackPresentation {
        StreakFeedbackPresentation(
            fullyCorrect: fullyCorrect,
            streak: resultingStreak,
            context: .teamCompletion
        )
    }
}

enum StreakFeedbackContext: Equatable {
    case priorityDecision
    case teamCompletion
}

struct StreakFeedbackPresentation: Equatable {
    let fullyCorrect: Bool
    let streak: Int
    let context: StreakFeedbackContext

    var isVisible: Bool {
        context == .teamCompletion && fullyCorrect && streak >= 2
    }

    var text: String { "x\(streak)" }

    var emphasis: StreakFeedbackEmphasis {
        streak >= 4 ? .emphasized : .normal
    }

    var accessibilityText: String {
        String.localizedStringWithFormat(
            String(localized: "streakFeedback.accessibility"),
            streak
        )
    }

    var shouldPlaySound: Bool { isVisible }
}

struct StreakFeedbackView: View {
    let presentation: StreakFeedbackPresentation
    @State private var isPulsed = false

    var body: some View {
        Text(verbatim: presentation.text)
            .font(.system(
                size: presentation.emphasis == .emphasized ? 72 : 48,
                weight: .black,
                design: .rounded
            ))
            .foregroundStyle(.yellow)
            .padding(.horizontal, 26)
            .padding(.vertical, 12)
            .background(.thickMaterial, in: Capsule())
            .shadow(color: .yellow.opacity(0.45), radius: 18)
            .scaleEffect(isPulsed ? 1.12 : 1)
            .accessibilityLabel(Text(verbatim: presentation.accessibilityText))
            .allowsHitTesting(false)
            .onAppear {
                guard presentation.emphasis == .emphasized else { return }
                withAnimation(.easeInOut(duration: FeedbackConstants.streakPulseDuration).repeatCount(2, autoreverses: true)) {
                    isPulsed = true
                }
            }
    }
}
