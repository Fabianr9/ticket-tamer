import RealityKit
import RealityKitContent
import Foundation

// MARK: - Monster Asset Provider (F-14 / AK-14)

/// Ladeinterface für die vier lokalen Monster-Assets aus dem RealityKitContent-Package.
///
/// Kapselt die wiederkehrende RealityKit-Ladelogik und stellt Modul 006 eine
/// einfache Schnittstelle bereit: Asset-ID rein, Entity raus – ohne Netzwerkzugriff,
/// ohne Team- oder Prioritätsentscheidung, ohne Gestenlogik.
///
/// Gesteninteraktion (Blickfokus, Pinch, Drag) wird in Modul 007 ergänzt.
/// Die zurückgegebene Entity-Hierarchie ist bewusst flach gehalten, damit
/// spätere Collision- und InputTarget-Komponenten ohne Umbau ergänzt werden können.
@MainActor
enum MonsterAssetProvider {

    // MARK: - Fehlertypen

    /// Ladefehler der Monster-Asset-Pipeline.
    enum LoadError: Error, LocalizedError {

        /// Die angegebene ID ist keinem der vier bekannten Monster-Assets zugeordnet.
        case unknownAssetID(String)

        /// Das Asset ist bekannt, konnte aber nicht aus dem lokalen Bundle geladen werden.
        case entityLoadFailed(String)

        var errorDescription: String? {
            switch self {
            case .unknownAssetID(let id):
                return "Unbekannte Monster-Asset-ID: '\(id)'. Gueltige IDs: \(AssetKeys.Monster.allIDs.joined(separator: ", "))."
            case .entityLoadFailed(let id):
                return "Lokale Asset-Datei fuer '\(id)' konnte nicht geladen werden."
            }
        }
    }

    // MARK: - Laden

    /// Lädt die RealityKit-Entity für den angegebenen Monster-Bezeichner aus dem
    /// lokalen RealityKitContent-Bundle.
    ///
    /// - Parameter assetID: Einer der vier Monster-Bezeichner aus `AssetKeys.Monster`
    ///   (z. B. `AssetKeys.Monster.monster01`).
    /// - Returns: Die geladene `Entity`, bereit zur Anzeige im zentralen Volume.
    /// - Throws: `LoadError.unknownAssetID` bei unbekannter ID,
    ///   `LoadError.entityLoadFailed` wenn das Bundle-Asset nicht geladen werden kann.
    ///
    /// Kein Netzwerkzugriff. Kein Fallback auf ein fremdes Asset.
    /// Fehlschlag wird geloggt und als Fehler weitergegeben.
    static func loadMonster(assetID: String) async throws -> Entity {
        guard AssetKeys.Monster.allIDs.contains(assetID) else {
            DebugManager.log(.spawning, "Unbekannte Asset-ID abgewiesen: \(assetID)")
            throw LoadError.unknownAssetID(assetID)
        }

        do {
            let entity = try await Entity(named: assetID, in: realityKitContentBundle)
            DebugManager.log(.spawning, "Asset erfolgreich geladen: \(assetID)")
            return entity
        } catch {
            DebugManager.log(.spawning, "Ladefehler fuer '\(assetID)': \(error.localizedDescription)")
            throw LoadError.entityLoadFailed(assetID)
        }
    }
}
