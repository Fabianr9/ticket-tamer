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

    /// Rein lokaler Lade-/Retry-Zustand; enthaelt keinen fachlichen Sitzungszustand.
    @State private var monsterLoadRecovery = MonsterLoadRecovery()

    /// Gemessener Quader des Monster-Panels (Restpunkt AK-06).
    ///
    /// Nil, solange noch keine brauchbare Messung vorliegt; die Einpassung faellt dann
    /// auf die bisherige Schaetzung zurueck.
    @State private var framing: InvestigationFraming? = nil

    // MARK: - Body

    var body: some View {
        if let ticket = model.currentTicket {
            mainContent(ticket: ticket)
                .ornament(
                    attachmentAnchor: .scene(
                        UnitPoint3D(
                            x: 0.5,
                            y: LayoutConstants.investigationHUDSceneAnchorY,
                            z: 0.5
                        )
                    ),
                    contentAlignment: .bottom
                ) {
                    sessionHUD
                }
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

    private var sessionHUD: some View {
        SessionHUDView(
            currentTicketIndex: model.currentTicketIndex,
            totalTicketCount: model.sessionTickets.count,
            phase: model.currentPhase
        )
    }

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
    /// Der reale Panelquader wird gemessen (`measurePanel(proxy:content:)`), nicht
    /// gerechnet. `availableSize` dient nur noch der Rueckfallebene im ersten
    /// Layoutdurchlauf.
    ///
    /// - Parameter availableSize: Vom Layout zugewiesene Panelflaeche in Punkten.
    @ViewBuilder
    private func monsterPanel(availableSize: CGSize) -> some View {
        if monsterLoadRecovery.isLoading {
            VStack(spacing: LayoutConstants.investigationCardSpacing) {
                ProgressView()
                    .controlSize(.large)
                Text("investigation.loading.monster")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let entity = monsterEntity {
            // `GeometryReader3D` liefert den tatsaechlichen Rahmen des Panels; zusammen
            // mit `content.convert(_:from:to:)` ergibt sich daraus der reale Quader in
            // Metern. Groesse und Position des Monsters leiten sich allein daraus ab.
            GeometryReader3D { proxy in
                RealityView { content in
                    measurePanel(proxy: proxy, content: content)
                    fitMonster(entity, fallback: availableSize)
                    content.add(entity)
                } update: { content in
                    // Fenster- oder Layoutaenderung: neu messen, neu einpassen.
                    measurePanel(proxy: proxy, content: content)
                    fitMonster(entity, fallback: availableSize)
                }
            }
            // Ohne explizite Tiefe haette die RealityView praktisch keine Z-Ausdehnung
            // und wuerde Modellteile vor/hinter der Ebene beschneiden. Wieviel Tiefe
            // real gewaehrt wird, misst `measurePanel(proxy:content:)`.
            .frame(depth: LayoutConstants.monsterPanelDepth)
        } else if monsterLoadRecovery.hasError {
            VStack(spacing: LayoutConstants.investigationCardSpacing) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text("investigation.error.monsterLoad")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button("Erneut laden") {
                    loadMonster(for: model.currentTicket)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(monsterLoadRecovery.isLoading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(10)
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

    // MARK: - Panel vermessen (Restpunkt AK-06)

    /// Misst den tatsaechlichen Quader des Monster-Panels in Szenen-Metern.
    ///
    /// Wird beim Aufbau **und** bei jedem `RealityView`-Update aufgerufen, damit eine
    /// Groessenaenderung des Volumes sofort in die Einpassung einfliesst. Zustand wird
    /// nur geschrieben, wenn sich die Messung geaendert hat — sonst entstuende eine
    /// Update-Schleife.
    ///
    /// Die Entity wird per `content.add(_:)` an dieselbe Szenenwurzel gehaengt;
    /// `entity.position` und die gemessene Box beschreiben deshalb denselben Raum.
    private func measurePanel(proxy: GeometryProxy3D, content: RealityViewContent) {
        let localFrame = proxy.frame(in: .local)
        let panel = content.convert(localFrame, from: .local, to: .scene)
        let measured = InvestigationFraming(panel: panel)

        guard measured.isUsable, framing != measured else { return }

        DebugManager.log(
            .spawning,
            "Monster-Panel gemessen: " + measured.debugSummary(
                assumedDepth: Float(LayoutConstants.monsterPanelDepth)
            )
        )

        Task { @MainActor in
            framing = measured
        }
    }

    // MARK: - Monster einpassen (Framing)

    /// Skaliert und positioniert das Monster so, dass es vollstaendig im Panel liegt.
    ///
    /// Warum dynamisch statt fester Faktor: die vier Blender-Exporte haben unterschiedliche
    /// Rohmasse. Ein konstanter `scale` (frueher 0.2) ergibt deshalb je Asset eine andere
    /// physische Groesse — ein Monster passte, ein anderes ragte ueber die Panelgrenzen
    /// hinaus und wurde von der `RealityView` beschnitten.
    ///
    /// Warum **gemessen** statt gerechnet (Restpunkt AK-06): der verfuegbare Quader wurde
    /// bisher aus `layoutPointsPerMeter` und `monsterPanelDepth` geschaetzt. Beide Werte
    /// beschreiben das Panel nicht: der erste ist gegen eine Volume-Hoehe von 0.8 m
    /// kalibriert (heute 1.0 m), der zweite ist das *angeforderte*, nicht das gewaehrte
    /// Tiefenmass in einem nur 0.4 m tiefen Volume. Da `fit(_:toMaxExtent:)` die
    /// **groesste** Modellausdehnung auf die Grenze abbildet, traf der Fehler zuerst das
    /// Asset, dessen groesste Ausdehnung in der Tiefe liegt — sichtbar als Anschnitt bei
    /// `monster04`. `InvestigationFraming` ersetzt beide Annahmen durch die Messung aus
    /// `measurePanel(proxy:content:)`.
    ///
    /// Solange keine brauchbare Messung vorliegt (erster Layoutdurchlauf), greift die
    /// bisherige Schaetzung als Rueckfallebene — nie Nullwerte.
    ///
    /// - Parameters:
    ///   - entity: Der Wrapper aus `MonsterAssetProvider.loadMonster(assetID:)`.
    ///   - fallback: Vom 2D-Layout zugewiesene Panelflaeche in Punkten, nur fuer die
    ///     Rueckfallebene.
    private func fitMonster(_ entity: Entity, fallback availableSize: CGSize) {
        let inset = LayoutConstants.monsterFramingInset
        let cap = LayoutConstants.monsterTargetSize

        // 1. Zielmass bestimmen — bevorzugt aus der Messung, unter Beruecksichtigung
        //    der tatsaechlichen Modellausdehnungen (dieselbe Quelle, die auch
        //    `MonsterAssetProvider.fit(_:toMaxExtent:)` verwendet).
        let modelExtents = entity.visualBounds(recursive: true, relativeTo: entity).extents

        let limit: Float
        if let framing {
            limit = framing.maxExtent(forModelExtents: modelExtents, inset: inset, cap: cap)
        } else {
            limit = estimatedMaxExtent(for: availableSize, inset: inset, cap: cap)
        }

        guard limit > 0 else { return }

        // 2. Proportional einpassen (idempotent — misst ohne die eigene Skalierung).
        //    Ein einziger Faktor fuer X, Y und Z ⇒ keine Streckung, keine Verzerrung.
        let fittedExtents = MonsterAssetProvider.fit(entity, toMaxExtent: limit)

        // 3. In die Panelmitte setzen und nur so weit nach vorne schieben, wie die
        //    nutzbare Tiefe abzueglich der Modelltiefe es erlaubt.
        let desiredForward = LayoutConstants.monsterForwardOffset
        if let framing {
            entity.position = framing.position(
                desiredForward: desiredForward,
                fittedDepth: fittedExtents.z,
                inset: inset
            )
        } else {
            let depthMeters = Float(LayoutConstants.monsterPanelDepth) * (1 - inset)
            let maxForward = max((depthMeters - fittedExtents.z) / 2, 0)
            entity.position = SIMD3<Float>(0, 0, min(desiredForward, maxForward))
        }

        DebugManager.log(
            .spawning,
            "Monster-Panel: limit=\(limit), pos=\(entity.position), gemessen=\(framing != nil)"
        )
    }

    /// Rueckfallebene: Zielmass aus der 2D-Panelflaeche schaetzen.
    ///
    /// Ausschliesslich fuer den ersten Layoutdurchlauf, bevor `measurePanel` einen
    /// brauchbaren Quader geliefert hat. Bewusst unveraendert gegenueber dem bisherigen
    /// Verhalten, damit die Rueckfallebene kein neues Risiko einfuehrt.
    private func estimatedMaxExtent(for availableSize: CGSize, inset: Float, cap: Float) -> Float {
        let factor = 1 - inset
        let widthMeters = Float(availableSize.width / LayoutConstants.layoutPointsPerMeter) * factor
        let heightMeters = Float(availableSize.height / LayoutConstants.layoutPointsPerMeter) * factor
        let depthMeters = Float(LayoutConstants.monsterPanelDepth) * factor

        return min(min(widthMeters, heightMeters), min(depthMeters, cap))
    }

    // MARK: - Monster laden

    private func loadMonster(for ticket: Ticket?) {
        guard let ticket, monsterLoadRecovery.begin(assetID: ticket.monsterAssetId) else { return }
        DebugManager.log(.spawning, "Monster-Retry/Laden gestartet: \(ticket.monsterAssetId)")
        monsterEntity = nil

        Task {
            do {
                let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
                monsterEntity = entity
                monsterLoadRecovery.finishSuccessfully()
                DebugManager.log(.spawning, "Monster-Retry/Laden erfolgreich: \(ticket.monsterAssetId)")
            } catch {
                monsterLoadRecovery.finishWithFailure()
                DebugManager.log(.spawning, "Monster-Retry/Laden fehlgeschlagen: \(ticket.monsterAssetId) – \(error.localizedDescription)")
            }
        }
    }

    private func resetMonster() {
        monsterEntity = nil
        monsterLoadRecovery.reset()
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
