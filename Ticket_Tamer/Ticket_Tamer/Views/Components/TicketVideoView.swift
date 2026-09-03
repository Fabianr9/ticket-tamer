import AVFoundation
import AVKit
import SwiftUI

/// Volumeninterne Videodarstellung mit Standard-Playbackcontrols und eigenem Schliessen.
struct TicketVideoView: View {
    let videoAssetName: String
    let onClose: () -> Void

    private let resourceProvider: TicketVideoResourceProvider

    @State private var player: AVPlayer?
    @State private var endObserver: NSObjectProtocol?
    @State private var failureObserver: NSObjectProtocol?
    @State private var statusObservation: NSKeyValueObservation?
    @State private var playbackFailed = false

    init(
        videoAssetName: String,
        resourceProvider: TicketVideoResourceProvider = TicketVideoResourceProvider(),
        onClose: @escaping () -> Void
    ) {
        self.videoAssetName = videoAssetName
        self.resourceProvider = resourceProvider
        self.onClose = onClose
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 28)
                .fill(.black.opacity(0.94))

            if playbackFailed {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    Text("investigation.video.error")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let player {
                VideoPlayer(player: player)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
            } else {
                ProgressView()
                    .tint(.white)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Button(action: closeManually) {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .frame(width: 52, height: 52)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
            .accessibilityLabel(Text("investigation.video.close"))
            .padding(20)
        }
        .padding(24)
        .onAppear(perform: prepareAndPlay)
        .onDisappear(perform: tearDown)
    }

    private func prepareAndPlay() {
        guard player == nil, endObserver == nil else { return }
        guard let url = resourceProvider.url(for: videoAssetName) else {
            playbackFailed = true
            DebugManager.log(.lifecycle, "Ticketvideo nicht gefunden: \(videoAssetName)")
            return
        }

        let item = AVPlayerItem(url: url)
        let newPlayer = AVPlayer(playerItem: item)
        player = newPlayer
        statusObservation = item.observe(\.status, options: [.new]) { item, _ in
            guard item.status == .failed else { return }
            Task { @MainActor in
                player?.pause()
                playbackFailed = true
                DebugManager.log(.lifecycle, "Ticketvideo ist nicht lesbar: \(videoAssetName)")
            }
        }
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            Task { @MainActor in
                DebugManager.log(.lifecycle, "Ticketvideo regulaer beendet: \(videoAssetName)")
                tearDown()
                onClose()
            }
        }
        failureObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            Task { @MainActor in
                player?.pause()
                playbackFailed = true
                DebugManager.log(.lifecycle, "Ticketvideo konnte nicht abgespielt werden: \(videoAssetName)")
            }
        }
        newPlayer.play()
    }

    private func closeManually() {
        DebugManager.log(.lifecycle, "Ticketvideo manuell geschlossen: \(videoAssetName)")
        tearDown()
        onClose()
    }

    private func tearDown() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        statusObservation?.invalidate()
        statusObservation = nil
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
            self.endObserver = nil
        }
        if let failureObserver {
            NotificationCenter.default.removeObserver(failureObserver)
            self.failureObserver = nil
        }
    }
}
