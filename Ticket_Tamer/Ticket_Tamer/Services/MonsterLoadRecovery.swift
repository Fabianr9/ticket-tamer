import Foundation

/// Lokaler, rein technischer Zustand eines Monster-Ladevorgangs (F-23 / AK-23).
///
/// Der Typ kennt weder `SessionModel` noch fachliche Entscheidungen. Er verhindert
/// parallele Versuche, merkt sich die angefragte Asset-ID und bildet immer hoechstens
/// ein erfolgreich geladenes Monster ab.
struct MonsterLoadRecovery: Equatable {
    enum Status: Equatable {
        case idle
        case loading
        case loaded
        case failed
    }

    private(set) var status: Status = .idle
    private(set) var requestedAssetID: String?

    var isLoading: Bool { status == .loading }
    var hasError: Bool { status == .failed }
    var canRetry: Bool { hasError && !isLoading }
    var displayedMonsterCount: Int { status == .loaded ? 1 : 0 }

    /// Beginnt genau einen Versuch und loescht dabei einen vorherigen Fehler.
    @discardableResult
    mutating func begin(assetID: String) -> Bool {
        guard !isLoading else { return false }
        requestedAssetID = assetID
        status = .loading
        return true
    }

    mutating func finishSuccessfully() {
        guard isLoading else { return }
        status = .loaded
    }

    mutating func finishWithFailure() {
        guard isLoading else { return }
        status = .failed
    }

    mutating func reset() {
        status = .idle
        requestedAssetID = nil
    }
}
