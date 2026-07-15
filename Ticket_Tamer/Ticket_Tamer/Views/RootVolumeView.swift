//
//  RootVolumeView.swift
//  Ticket_Tamer
//
//  Created by Fabian Raczkowski on 15.07.26.
//

import RealityKit
import RealityKitContent
import SwiftUI

/// Minimale Startoberflaeche innerhalb des zentralen Ticket-Tamer-Volumes.
struct RootVolumeView: View {

    // MARK: - Body

    var body: some View {
        VStack(spacing: LayoutConstants.rootSpacing) {
            Model3D(named: AssetKeys.defaultRealityKitScene, bundle: realityKitContentBundle)
                .padding(.bottom, LayoutConstants.modelBottomPadding)

            VStack(spacing: LayoutConstants.textSpacing) {
                Text("app.title")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text("app.modulePlaceholder")
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(LayoutConstants.rootPadding)
        .onAppear {
            DebugManager.log(.lifecycle, "Zentrales Volume angezeigt")
        }
    }
}

#Preview(windowStyle: .volumetric) {
    RootVolumeView()
}
