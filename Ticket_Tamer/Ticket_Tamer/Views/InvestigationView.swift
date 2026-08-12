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
                monsterPanel(availableSize: CGSize(width: monsterWidth, height: proxy.size.height))
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

    /// Zeigt das Monster mittig im zugewiesenen Bereich, vollständig und unverzerrt.
    ///
    /// - Parameter availableSize: Vom Layout zugewiesene Panelfläche in Punkten.
    ///   Wird zusammen mit `LayoutConstants.monsterPanelDepth` in einen physischen
    ///   Rahmen umgerechnet, in den das Modell eingepasst wird.
    @ViewBuilder
    private func monsterPanel(availableSize: CGSize) -> some View {
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
                fitMonster(entity, into: availableSize)
                content.add(entity)
            } update: { _ in
                // Fenster- oder Layoutänderung: Einpassung neu berechnen.
                fitMonster(entity, into: availableSize)
            }
            // Ohne explizite Tiefe hätte die RealityView praktisch keine Z-Ausdehnung
            // und würde Modellteile vor/hinter der Ebene beschneiden.
            .frame(depth: LayoutConstants.monsterPanelDepth)
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

    // MARK: - Monster einpassen (Framing)

    /// Skaliert und positioniert das Monster so, dass es vollständig im Panel liegt.
    ///
    /// Warum dynamisch statt fester Faktor: die vier Blender-Exporte haben unterschiedliche
    /// Rohmaße. Ein konstanter `scale` (früher 0.2) ergibt deshalb je Asset eine andere
    /// physische Größe — ein Monster passte, ein anderes ragte über die Panelgrenzen hinaus
    /// und wurde von der `RealityView` beschnitten.
    ///
    /// Vorgehen:
    /// 1. Rohmaße über `visualBounds` messen (ohne die eigene Transformation der Entity).
    /// 2. Verfügbaren Quader aus Panelbreite, Panelhöhe und `monsterPanelDepth` bilden,
    ///    abzüglich `monsterFramingInset` als Sicherheitsrand zu allen Begrenzungen.
    /// 3. Die *größte* Modellausdehnung auf die *kleinste* Quaderkante abbilden.
    ///    Ein einziger Faktor für X, Y und Z ⇒ keine Streckung, keine Verzerrung.
    /// 4. Modell mittig setzen und so weit nach vorne schieben, wie die Tiefe es zulässt.
    private func fitMonster(_ entity: Entity, into availableSize: CGSize) {
        // 1. Rohmaße. `relativeTo: entity` schließt die eigene Skalierung aus und ist
        //    damit unabhängig davon, ob bereits eingepasst wurde (idempotent).
        let extents = entity.visualBounds(recursive: true, relativeTo: entity).extents
        let largestExtent = max(extents.x, max(extents.y, extents.z))

        guard largestExtent > LayoutConstants.monsterMinimumUsableExtent else {
            DebugManager.log(.spawning, "VisualBounds unbrauchbar — Einpassung uebersprungen")
            return
        }

        // 2. Verfügbarer Quader in Metern, abzüglich Sicherheitsrand.
        let inset = 1 - LayoutConstants.monsterFramingInset
        let widthMeters = Float(availableSize.width / LayoutConstants.pointsPerMeter) * inset
        let heightMeters = Float(availableSize.height / LayoutConstants.pointsPerMeter) * inset
        let depthMeters = Float(LayoutConstants.monsterPanelDepth) * inset

        // 3. Kleinste Kante begrenzt; zusätzlich durch die gewünschte Zielgröße gedeckelt.
        let limit = min(
            min(widthMeters, heightMeters),
            min(depthMeters, LayoutConstants.monsterTargetSize)
        )

        guard limit > 0 else { return }

        let scale = limit / largestExtent
        entity.scale = SIMD3<Float>(repeating: scale)

        // 4. Zentrieren und so weit nach vorne schieben, wie die halbe Tiefe abzüglich
        //    der halben Modelltiefe es erlaubt — sonst würde das Modell vorne anstoßen.
        let fittedDepth = extents.z * scale
        let maxForward = max((depthMeters - fittedDepth) / 2, 0)
        let forward = min(LayoutConstants.monsterForwardOffset, maxForward)
        entity.position = SIMD3<Float>(0, 0, forward)

        DebugManager.log(
            .spawning,
            "Monster eingepasst: extents=\(extents), scale=\(scale), z=\(forward)"
        )
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
