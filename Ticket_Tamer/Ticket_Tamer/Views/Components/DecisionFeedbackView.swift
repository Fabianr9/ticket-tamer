import Foundation
import SwiftUI

/// Rein visuelles Ergebnis einer bereits erfolgten Entscheidungsauswertung.
///
/// Der Typ kennt weder Ticket noch Referenzwerte oder Gesamtpunktestand. Er bildet nur
/// das von `SessionModel.evaluatePriority()` beziehungsweise `evaluateTeam()` gelieferte
/// Bool-Ergebnis auf die Darstellung ab.
enum DecisionFeedbackResult: Equatable {
    case correct
    case incorrect

    /// `nil` bedeutet, dass keine Bewertung stattgefunden hat und deshalb auch kein
    /// Feedback angezeigt werden darf.
    init?(evaluation: Bool?) {
        guard let evaluation else { return nil }
        self = evaluation ? .correct : .incorrect
    }

    var symbolName: String {
        switch self {
        case .correct: "checkmark"
        case .incorrect: "xmark"
        }
    }

    /// Sichtbare Kommunikation der bereits erfolgten Bewertung.
    var pointsText: String {
        switch self {
        case .correct: "+100 Punkte"
        case .incorrect: "0 Punkte"
        }
    }

    var accessibilityLabelKey: String {
        switch self {
        case .correct: "decisionFeedback.correct.accessibility"
        case .incorrect: "decisionFeedback.incorrect.accessibility"
        }
    }
}

/// Reine Darstellung einer bereits ausgewerteten Entscheidung.
struct DecisionFeedbackPresentation: Equatable {
    let result: DecisionFeedbackResult
    let awardedPoints: Int

    init?(evaluation: Bool?, awardedPoints: Int) {
        guard let result = DecisionFeedbackResult(evaluation: evaluation) else { return nil }
        self.result = result
        self.awardedPoints = result == .correct ? max(0, awardedPoints) : 0
    }

    var pointsText: String {
        guard result == .correct else { return "0 Punkte" }
        return String.localizedStringWithFormat(
            String(localized: "decisionFeedback.correct.points"),
            awardedPoints
        )
    }

    var accessibilityText: String {
        switch result {
        case .correct:
            String.localizedStringWithFormat(
                String(localized: "decisionFeedback.correct.points.accessibility"),
                awardedPoints
            )
        case .incorrect: "Entscheidung falsch, 0 Punkte"
        }
    }
}

/// Zentrales, nicht interaktives Feedback während des bestehenden 1,5-s-Fensters.
struct DecisionFeedbackView: View {
    let presentation: DecisionFeedbackPresentation

    private var result: DecisionFeedbackResult { presentation.result }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: result.symbolName)
                .font(.system(size: 76, weight: .bold))
                .foregroundStyle(feedbackColor)
                .frame(width: 132, height: 132)
                .background(feedbackColor.opacity(0.16), in: Circle())
                .overlay {
                    Circle().stroke(feedbackColor, lineWidth: 7)
                }
                .accessibilityHidden(true)

            Text(verbatim: presentation.pointsText)
                .font(.title.bold())
                .foregroundStyle(.primary)
        }
        .padding(32)
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 28))
        .shadow(radius: 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(verbatim: presentation.accessibilityText))
        .allowsHitTesting(false)
    }

    private var feedbackColor: Color {
        switch result {
        case .correct: .green
        case .incorrect: .red
        }
    }
}
