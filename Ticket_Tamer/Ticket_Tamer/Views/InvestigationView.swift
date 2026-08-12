import RealityKit
import SwiftUI

// MARK: - Investigation View (Modul 006 — F-06 / F-07 / AK-06 / AK-07)

/// Zeigt das aktuelle Ticket mit Monster und Ticketkarte in der Untersuchungsphase.
///
/// Datenquelle ist ausschließlich `SessionModel.currentTicket`.
/// Referenzpriorität und Referenzteam werden in dieser Phase nicht angezeigt.
/// Die Schaltfläche „Weiter zur Priorisierung" löst `SessionModel.beginPrioritizationPhase()` aus.
///
/// Die Ticketkarte (`TicketCardView`) ist scrollfrei und wird über `ScaledToFitView`
/// gleichmäßig in den verfügbaren Bereich eingepasst — vollständig sichtbar, ohne Verzerrung.
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

    /// Teilt den verfuegbaren Bereich explizit zwischen Monster-Panel und Ticketkarte auf.
    ///
    /// Bewusst mit `GeometryReader` und festen Breitenanteilen statt mit `maxWidth: .infinity`:
    /// die `RealityView` des Monster-Panels besitzt keine intrinsische Groesse, wodurch die
    /// flexible Verteilung der Ticketkarte zu wenig Breite liess und sie „laenglich" wirkte.
    @ViewBuilder
    private func mainContent(ticket: Ticket) -> some View {
        GeometryReader { proxy in
            let contentWidth = max(proxy.size.width - CGFloat(LayoutConstants.investigationSpacing), 0)
            let cardWidth = contentWidth * CGFloat(LayoutConstants.investigationCardWidthFraction)
            let monsterWidth = contentWidth - cardWidth

            HStack(alignment: .center, spacing: LayoutConstants.investigationSpacing) {
                monsterPanel
                    .frame(width: monsterWidth, height: proxy.size.height)

                // Fit-to-Space: feste Design-Canvas, gleichmaessig in den Bereich eingepasst.
                ScaledToFitView(
                    designSize: CGSize(
                        width: LayoutConstants.ticketCardDesignWidth,
                        height: LayoutConstants.ticketCardDesignHeight
                    )
                ) {
                    TicketCardView(ticket: ticket) {
                        DebugManager.log(.input, "Weiter zur Priorisierung ausgeloest: \(ticket.ticketNumber)")
                        model.beginPrioritizationPhase()
                    }
                }
                .frame(width: cardWidth, height: proxy.size.height)
            }
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
