import RealityKit
import SwiftUI

// MARK: - Investigation View (Modul 006 — F-06 / F-07 / AK-06 / AK-07)

/// Zeigt das aktuelle Ticket mit Monster und Ticketkarte in der Untersuchungsphase.
///
/// Datenquelle ist ausschließlich `SessionModel.currentTicket`.
/// Referenzpriorität und Referenzteam werden in dieser Phase nicht angezeigt.
/// Die Schaltfläche „Weiter zur Priorisierung" löst `SessionModel.beginPrioritizationPhase()` aus.
struct InvestigationView: View {

    // MARK: - Environment

    @Environment(SessionModel.self) private var model

    // MARK: - State

    /// Geladene Monster-Entity. Nil während Ladevorgang oder bei Fehler.
    @State private var monsterEntity: Entity? = nil

    /// Zeigt an, dass ein Ladevorgang läuft.
    @State private var isLoadingMonster: Bool = false

    /// Enthält den Ladefehler, falls der Monster-Load fehlgeschlagen ist.
    @State private var monsterLoadError: MonsterAssetProvider.LoadError? = nil

    // MARK: - Body

    var body: some View {
        if let ticket = model.currentTicket {
            mainContent(ticket: ticket)
                .onAppear {
                    DebugManager.log(.lifecycle, "Untersuchungsansicht erscheint: \(ticket.ticketNumber)")
                    loadMonster(for: ticket)
                }
                .onChange(of: model.currentTicketIndex) { _, _ in
                    resetMonster()
                    if let updated = model.currentTicket {
                        loadMonster(for: updated)
                    }
                }
        } else {
            noTicketView
                .onAppear {
                    DebugManager.log(.lifecycle, "Untersuchungsansicht: kein aktives Ticket")
                }
        }
    }

    // MARK: - Hauptinhalt

    @ViewBuilder
    private func mainContent(ticket: Ticket) -> some View {
        HStack(alignment: .top, spacing: LayoutConstants.investigationSpacing) {
            monsterPanel
                .frame(maxWidth: .infinity)

            ticketCard(ticket: ticket)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(LayoutConstants.investigationPadding)
    }

    // MARK: - Monster-Panel

    @ViewBuilder
    private var monsterPanel: some View {
        if isLoadingMonster {
            VStack(spacing: LayoutConstants.investigationCardSpacing) {
                ProgressView()
                    .controlSize(.large)
                Text("investigation.loading.monster")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let entity = monsterEntity {
            RealityView { content in
                entity.scale = SIMD3(repeating: LayoutConstants.monsterScale)
                content.add(entity)
            }
        } else if monsterLoadError != nil {
            VStack(spacing: LayoutConstants.investigationCardSpacing) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text("investigation.error.monsterLoad")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            // Initialer Zustand vor erstem Laden (kurze Lücke zwischen Erscheinen und Task-Start)
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Ticketkarte

    @ViewBuilder
    private func ticketCard(ticket: Ticket) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Scrollbarer Inhalt: Ticketdetails
            ScrollView {
                VStack(alignment: .leading, spacing: LayoutConstants.investigationCardSpacing) {

                    // Ticketnummer-Badge
                    Text(ticket.ticketNumber)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.secondary.opacity(0.15), in: Capsule())
                        .accessibilityLabel(Text("investigation.ticketNumber.label") + Text(ticket.ticketNumber))

                    // Titel
                    Text(ticket.title)
                        .font(.title3)
                        .bold()

                    Divider()

                    // Kurzbeschreibung
                    Text(ticket.shortDescription)
                        .font(.callout)

                    // Auswirkung
                    VStack(alignment: .leading, spacing: 3) {
                        Text("investigation.userImpact.label")
                            .font(.subheadline)
                            .bold()
                        Text(ticket.userImpact)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                    // Symptome / Hinweise
                    VStack(alignment: .leading, spacing: 3) {
                        Text("investigation.symptoms.label")
                            .font(.subheadline)
                            .bold()
                        ForEach(Array(ticket.symptoms.enumerated()), id: \.offset) { _, symptom in
                            Label {
                                Text(symptom)
                                    .font(.callout)
                            } icon: {
                                Image(systemName: "circle.fill")
                                    .imageScale(.small)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(LayoutConstants.investigationCardPadding)
            }

            Divider()
                .padding(.horizontal, LayoutConstants.investigationCardPadding)

            // Schaltfläche: immer sichtbar, außerhalb des Scroll-Bereichs (F-07 / AK-07)
            Button {
                DebugManager.log(.input, "Weiter zur Priorisierung ausgeloest: \(ticket.ticketNumber)")
                model.beginPrioritizationPhase()
            } label: {
                Text("investigation.button.nextPhase")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(LayoutConstants.investigationCardPadding)
        }
    }

    // MARK: - Fallback bei fehlendem Ticket

    private var noTicketView: some View {
        VStack(spacing: LayoutConstants.rootSpacing) {
            Image(systemName: "exclamationmark.circle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("investigation.error.noTicket")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Monster laden

    private func loadMonster(for ticket: Ticket) {
        guard !isLoadingMonster else { return }
        isLoadingMonster = true
        monsterLoadError = nil
        monsterEntity = nil

        Task {
            do {
                let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
                monsterEntity = entity
                DebugManager.log(.spawning, "Monster bereit fuer Anzeige: \(ticket.monsterAssetId)")
            } catch let error as MonsterAssetProvider.LoadError {
                monsterLoadError = error
            } catch {
                monsterLoadError = .entityLoadFailed(ticket.monsterAssetId)
            }
            isLoadingMonster = false
        }
    }

    private func resetMonster() {
        monsterEntity = nil
        isLoadingMonster = false
        monsterLoadError = nil
    }
}

// MARK: - Preview

#Preview(windowStyle: .volumetric) {
    let model = SessionModel()
    model.setTicketCount(1)
    model.startSession(using: { $0 })
    return InvestigationView()
        .environment(model)
}
