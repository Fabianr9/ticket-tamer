//
//  RootVolumeView.swift
//  Ticket_Tamer
//
//  Created by Fabian Raczkowski on 15.07.26.
//

import RealityKit
import RealityKitContent
import SwiftUI

/// Wurzelansicht innerhalb des einzigen zentralen Ticket-Tamer-Volumes.
///
/// Schaltet phasenabhängig zwischen `StartView` (Phase `.start`) und einem neutralen
/// Platzhalter für noch nicht implementierte Folgeschritte um.
/// Kein zweites Fenster, kein zweites Volume, kein Immersive Space.
struct RootVolumeView: View {

    // MARK: - Environment

    /// Einzige Zustandsquelle; wird von `Ticket_TamerApp` per `.environment()` bereitgestellt.
    @Environment(SessionModel.self) private var model

    // MARK: - Body

    var body: some View {
        switch model.currentPhase {
        case .start:
            StartView()
        case .untersuchen:
            // Modul 006: Untersuchungsphase (F-06 / F-07)
            InvestigationView()
        case .priorisieren:
            // Modul 008: Echte Priorisierungsansicht — sowohl im DEBUG- als auch im Release-Build.
            // DebugInteractionHarnessView bleibt als Development-Datei erhalten, ist aber nicht mehr
            // im normalen .priorisieren-Routing aktiv.
            PrioritizationView()
        default:
            // Neutraler Platzhalter für Phasen, die in späteren Modulen implementiert werden.
            // Die vorhandene RealityKit-Standardszene bleibt als räumliches Element erhalten.
            sessionPlaceholderView
        }
    }

    // MARK: - Subviews

    /// Einfacher, nicht-fachlicher Platzhalter nach dem Sitzungsstart.
    ///
    /// Zeigt die RealityKit-Standardszene und einen deutschen Hinweistext.
    /// Keinerlei Untersuchungs-, Priorisierungs- oder Teamzuordnungslogik.
    @ViewBuilder
    private var sessionPlaceholderView: some View {
        VStack(spacing: LayoutConstants.rootSpacing) {
            Model3D(named: AssetKeys.defaultRealityKitScene, bundle: realityKitContentBundle)
                .padding(.bottom, LayoutConstants.modelBottomPadding)

            Text("root.sessionPlaceholder")
                .font(.title3)
                .multilineTextAlignment(.center)
        }
        .padding(LayoutConstants.rootPadding)
        .onAppear {
            DebugManager.log(.state, "Sitzungsplatzhalter sichtbar, Phase: \(model.currentPhase)")
        }
    }
}

#Preview(windowStyle: .volumetric) {
    RootVolumeView()
        .environment(SessionModel())
}
