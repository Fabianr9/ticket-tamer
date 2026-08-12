//
//  ResultView.swift
//  Ticket_Tamer
//
//  Modul 011 — Ergebnis und Neustart (F-15 / F-16 / AK-15 / AK-16)
//

import SwiftUI

/// Ergebnisansicht am Ende einer Spielsitzung.
///
/// Sichtbare Elemente ausschließlich laut SPEC F-15:
/// 1. Gesamtpunktzahl als Zahl (`SessionModel.score`)
/// 2. Schaltfläche „Erneut spielen"
///
/// Keine Detailstatistik, kein Badge, kein Rang, keine Ticketanzahl.
struct ResultView: View {

    // MARK: - Environment

    /// Einzige Zustandsquelle; bereitgestellt von `Ticket_TamerApp`.
    @Environment(SessionModel.self) private var model

    // MARK: - Body

    var body: some View {
        VStack(spacing: 32) {
            scoreLabel
            restartButton
        }
        .padding(40)
        .onAppear {
            DebugManager.log(.lifecycle, "Ergebnisansicht erscheint — Score: \(model.score)")
        }
    }

    // MARK: - Subviews

    /// Gesamtpunktzahl typografisch hervorgehoben.
    ///
    /// Quelle ausschließlich `model.score` — keine Neuberechnung in der View.
    /// Accessibility-Label ohne sichtbare Zusatzstatistik.
    @ViewBuilder
    private var scoreLabel: some View {
        Text("\(model.score)")
            .font(.system(size: 80, weight: .bold, design: .rounded))
            .monospacedDigit()
            .accessibilityLabel("Punkte: \(model.score)")
    }

    /// Schaltfläche „Erneut spielen" — ruft ausschließlich `model.reset()` auf.
    ///
    /// Nach Reset setzt `currentPhase = .start`, wodurch `RootVolumeView`
    /// automatisch zur `StartView` wechselt. Kein separates Routing nötig.
    @ViewBuilder
    private var restartButton: some View {
        Button {
            DebugManager.log(.input, "Erneut spielen ausgeloest")
            model.reset()
            DebugManager.log(.state, "Reset abgeschlossen — Phase: \(model.currentPhase)")
        } label: {
            Text("Erneut spielen")
                .font(.title2)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
    }
}

// MARK: - Preview

#Preview(windowStyle: .volumetric) {
    ResultView()
        .environment(SessionModel())
}
