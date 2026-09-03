//
//  StartView.swift
//  Ticket_Tamer
//
//  Modul 004 — Startansicht und Einstellungen (SPEC F-01, AK-01)
//

import SwiftUI

/// Deutsche Startansicht mit Projekttitel, Kurzbeschreibung, Ticketsteuerung und Startschaltfläche.
///
/// Zeigt beim App-Start (Phase `.start`):
/// - Projekttitel „Ticket Tamer"
/// - Kurzbeschreibung des Spielziels
/// - Beschriftung, Minus-/Plus-Schaltflächen und ganzzahligen Regler 1–12 (Standardwert 6)
/// - sichtbaren aktuellen Zahlenwert
/// - Schaltfläche „Spiel starten"
///
/// Der Zustand liegt ausschließlich in `SessionModel`; es gibt keine lokale Zustandskopie.
/// Technisch ungültige Reglerwerte werden von `SessionModel.setTicketCount(_:)` geklemmt —
/// Modul 004 führt keine zweite, konkurrierende Validierungsregel ein.
struct StartView: View {

    // MARK: - Environment

    /// Einzige Zustandsquelle; wird von `Ticket_TamerApp` per `.environment()` bereitgestellt.
    @Environment(SessionModel.self) private var model

    // MARK: - Body

    var body: some View {
        VStack(spacing: LayoutConstants.rootSpacing) {

            // MARK: Projekttitel
            Text("app.title")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text(LocalizedStringKey(StartViewContent.description))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: LayoutConstants.startDescriptionMaximumWidth)

            // MARK: Ticketanzahl-Steuerung
            VStack(spacing: LayoutConstants.textSpacing) {
                Text("start.ticketCount.label")
                    .font(.headline)

                // Ganzzahliger Regler: `step: 1` erzwingt Ganzzahligkeit auf UI-Ebene.
                // Das Binding konvertiert Double ↔ Int und leitet jeden Wert durch
                // `setTicketCount(_:)`, das ungültige Werte auf 1–12 klemmt.
                // Kein lokaler `@State`-Spiegel — SessionModel ist die einzige Wahrheitsquelle.
                HStack(spacing: LayoutConstants.startTicketControlSpacing) {
                    Button {
                        model.setTicketCount(model.selectedTicketCount - 1)
                    } label: {
                        Image(systemName: "minus")
                            .frame(minWidth: LayoutConstants.startTicketButtonSize,
                                   minHeight: LayoutConstants.startTicketButtonSize)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!StartTicketCountControls.canDecrease(model.selectedTicketCount))
                    .accessibilityLabel(
                        Text(LocalizedStringKey(StartViewContent.decreaseAccessibilityLabel))
                    )

                    Slider(
                        value: Binding(
                            get: { Double(model.selectedTicketCount) },
                            set: { model.setTicketCount(Int($0.rounded())) }
                        ),
                        in: Double(GameplayConstants.minimumTicketCount)...Double(GameplayConstants.maximumTicketCount),
                        step: 1
                    )
                    // Eine reine maxWidth-Angabe liess den flexiblen Slider bei einem
                    // kleinen Layout-Proposal bevorzugt komprimieren. Die Designbreite
                    // ist jetzt explizit; die zentrale Root-Huelle garantiert ueber
                    // Cold Start und Replay dasselbe Proposal.
                    .frame(width: LayoutConstants.startSliderDesignWidth)
                    .accessibilityLabel(Text("start.ticketCount.accessibility"))
                    .accessibilityValue(Text(String(model.selectedTicketCount)))

                    Button {
                        model.setTicketCount(model.selectedTicketCount + 1)
                    } label: {
                        Image(systemName: "plus")
                            .frame(minWidth: LayoutConstants.startTicketButtonSize,
                                   minHeight: LayoutConstants.startTicketButtonSize)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!StartTicketCountControls.canIncrease(model.selectedTicketCount))
                    .accessibilityLabel(
                        Text(LocalizedStringKey(StartViewContent.increaseAccessibilityLabel))
                    )
                }

                // Sichtbarer aktueller Zahlenwert (AK-01)
                Text("\(model.selectedTicketCount)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    // Barrierefreiheit: Wert wird bereits über accessibilityValue des Reglers
                    // kommuniziert; zusätzliche Ansage würde doppeln.
                    .accessibilityHidden(true)
            }

            // MARK: Startschaltfläche
            Button {
                DebugManager.log(.input, "\"Spiel starten\" ausgeloest: \(model.selectedTicketCount) Ticket(s)")
                model.startSession()
            } label: {
                Text("start.button.startGame")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel(Text("start.button.startGame"))
        }
        .padding(LayoutConstants.rootPadding)
        .onAppear {
            DebugManager.log(.lifecycle, "Startansicht erscheint, selectedTicketCount: \(model.selectedTicketCount)")
        }
    }
}

/// Rein darstellungsbezogene Ableitungen für die Grenzzustände der Ticketsteuerung.
enum StartTicketCountControls {
    static func canDecrease(_ count: Int) -> Bool {
        count > GameplayConstants.minimumTicketCount
    }

    static func canIncrease(_ count: Int) -> Bool {
        count < GameplayConstants.maximumTicketCount
    }
}

/// Verbindliche sichtbare und barrierefreie Texte aus F-24 beziehungsweise AK-22.
enum StartViewContent {
    static let description = "Untersuche Support-Tickets und ordne die Monster einer Priorität und einem Team zu."
    static let decreaseAccessibilityLabel = "Ein Ticket weniger"
    static let increaseAccessibilityLabel = "Ein Ticket mehr"
}

#Preview(windowStyle: .volumetric) {
    StartView()
        .environment(SessionModel())
}
