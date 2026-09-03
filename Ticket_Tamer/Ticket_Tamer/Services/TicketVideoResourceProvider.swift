import Foundation

/// Loest die feste Video-Referenz eines Tickets ausschliesslich im lokalen App-Bundle auf.
struct TicketVideoResourceProvider {
    static let subdirectory = "Videos"

    let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func url(for videoAssetName: String) -> URL? {
        let fileURL = URL(fileURLWithPath: videoAssetName)
        guard !videoAssetName.isEmpty,
              fileURL.lastPathComponent == videoAssetName,
              fileURL.pathExtension.lowercased() == "mp4" else {
            return nil
        }

        let name = fileURL.deletingPathExtension().lastPathComponent
        return bundle.url(forResource: name, withExtension: "mp4", subdirectory: Self.subdirectory)
            ?? bundle.url(forResource: name, withExtension: "mp4")
    }
}

/// Rein lokaler UI-Zustand der Videopraesentation; enthaelt keinen Sitzungszustand.
struct TicketVideoPresentationState: Equatable {
    private(set) var presentedAssetName: String?

    var isPresented: Bool { presentedAssetName != nil }

    mutating func present(videoAssetName: String) {
        guard !isPresented, !videoAssetName.isEmpty else { return }
        presentedAssetName = videoAssetName
    }

    mutating func close() {
        presentedAssetName = nil
    }

    mutating func closeIfTicketChanged(to videoAssetName: String?) {
        guard presentedAssetName != videoAssetName else { return }
        close()
    }

    mutating func closeIfInvestigationEnded(_ phase: GamePhase) {
        guard phase != .untersuchen else { return }
        close()
    }
}
