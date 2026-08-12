import RealityKit
import RealityKitContent
import Foundation

// MARK: - Monster Asset Provider (F-14 / AK-14)

/// Ladeinterface für die vier lokalen Monster-Assets.
///
/// Ladestrategie (Modul 013 — Layout-Fix):
///
/// 1. Primär: USDC direkt per URL aus dem `MonsterAssets`-Ordner des RealityKitContent-Bundle.
///    Umgeht die Reality-Composer-Pro-Kompilierung, die externe USDC-Referenzen in USDA-Dateien
///    nicht zuverlässig auflöst.
///
/// 2. Fallback: Benannte Entity aus dem kompilierten rkassets-Bundle (`monster01`…`monster04`).
///    Greift, falls URL-Laden fehlschlägt (z. B. fehlende Ressource).
///
/// Layout-Fix: Blender exportiert USDC mit `upAxis = Z`. RealityKit verwendet Y-up.
/// Korrektur: -90 ° um X-Achse, angewendet nach jedem Laden unabhängig vom Ladepfad.
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

    /// Lädt die RealityKit-Entity für den angegebenen Monster-Bezeichner.
    ///
    /// - Parameter assetID: Einer der vier Monster-Bezeichner aus `AssetKeys.Monster`.
    /// - Returns: Die geladene `Entity`, bereit zur Anzeige. Orientation ist auf Y-up korrigiert.
    /// - Throws: `LoadError.unknownAssetID` bei unbekannter ID,
    ///   `LoadError.entityLoadFailed` wenn weder URL- noch Bundle-Laden gelingt.
    ///
    /// Kein Netzwerkzugriff. Kein Fallback auf ein fremdes Asset.
    static func loadMonster(assetID: String) async throws -> Entity {
        guard AssetKeys.Monster.allIDs.contains(assetID) else {
            DebugManager.log(.spawning, "Unbekannte Asset-ID abgewiesen: \(assetID)")
            throw LoadError.unknownAssetID(assetID)
        }

        let fileName = MonsterFileMapping.fileName(for: assetID)

        // 1. Versuch: USDC direkt per URL (kein rkassets-Compile-Schritt nötig)
        if let url = realityKitContentBundle.url(
            forResource: fileName,
            withExtension: "usdc",
            subdirectory: "MonsterAssets"
        ) {
            do {
                // Entity.load(contentsOf:) ist synchron; im async-Kontext auf MainActor akzeptabel.
                let loaded = try Entity.load(contentsOf: url)
                applyBlenderCorrection(to: loaded)
                let wrapper = wrapAndCenter(loaded)
                DebugManager.log(.spawning, "Asset per URL geladen: \(assetID) → \(fileName).usdc")
                return wrapper
            } catch {
                DebugManager.log(.spawning, "URL-Ladefehler fuer '\(assetID)': \(error.localizedDescription)")
            }
        } else {
            DebugManager.log(.spawning, "MonsterAssets-URL nicht gefunden fuer '\(assetID)' (fileName: \(fileName))")
        }

        // 2. Fallback: benannte Entity aus rkassets-Bundle
        do {
            let loaded = try await Entity(named: assetID, in: realityKitContentBundle)
            applyBlenderCorrection(to: loaded)
            let wrapper = wrapAndCenter(loaded)
            DebugManager.log(.spawning, "Asset per Name geladen: \(assetID)")
            return wrapper
        } catch {
            DebugManager.log(.spawning, "Ladefehler fuer '\(assetID)': \(error.localizedDescription)")
            throw LoadError.entityLoadFailed(assetID)
        }
    }

    // MARK: - Blender-Korrektur (Layout-Fix Modul 013)

    /// Korrigiert die Orientierung eines Blender-USDC-Exports von Z-up auf Y-up.
    ///
    /// Blender exportiert USD mit `upAxis = Z`. RealityKit verwendet Y-up.
    /// -90 ° um X dreht die Y-Achse auf die Z-Achse — der ehemalige Z-Vektor
    /// zeigt danach in die positive Y-Richtung (oben in RealityKit).
    private static func applyBlenderCorrection(to entity: Entity) {
        entity.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
        DebugManager.log(.spawning, "Blender-Z-up-Korrektur angewendet")
    }

    // MARK: - Zentrierung (Layout-Fix Modul 013)

    /// Kapselt die geladene Entity in einen Wrapper, dessen Ursprung mit dem visuellen
    /// Mittelpunkt des Modells zusammenfällt.
    ///
    /// Blender-Modelle haben ihren Origin oft am Fuß oder an einer anderen Extremstelle.
    /// Ohne Korrektur liegt die Kollisionssphäre (am Entity-Origin) nicht auf dem
    /// visuellen Zentrum → Greifen schlägt fehl. Der Wrapper-Ursprung wird so gesetzt,
    /// dass `wrapper.position` direkt die visuelle Mitte des Monsters angibt.
    ///
    /// Methode: `visualBounds(relativeTo: wrapper)` berücksichtigt bereits die
    /// Orientierungskorrektur von `loaded`, da es die volle lokale Transformation einbezieht.
    private static func wrapAndCenter(_ loaded: Entity) -> Entity {
        let wrapper = Entity()
        wrapper.addChild(loaded)

        // Bounds in Wrapper-Koordinaten = Weltkoordinaten (Orientierung der loaded-Entity inklusive)
        let bounds = loaded.visualBounds(recursive: true, relativeTo: wrapper)
        let extents = bounds.extents

        guard extents.x > 0.001 || extents.y > 0.001 || extents.z > 0.001 else {
            DebugManager.log(.spawning, "VisualBounds zu klein — Zentrierung übersprungen")
            return wrapper
        }

        // Verschiebe loaded so, dass bounds.center = (0,0,0) im Wrapper-Raum.
        loaded.position = -bounds.center
        DebugManager.log(.spawning, "Zentriert: center=\(bounds.center), extents=\(extents)")
        return wrapper
    }

    // MARK: - Dateiname-Mapping (intern)

    /// Zuordnung von neutralen Asset-IDs auf tatsächliche USDC-Dateinamen.
    ///
    /// Farbwahl (Modul 013): visuell unterscheidbar, keine Team-/Prioritätskodierung.
    private enum MonsterFileMapping {
        static func fileName(for assetID: String) -> String {
            switch assetID {
            case AssetKeys.Monster.monster01: return "Monster_1_blue"
            case AssetKeys.Monster.monster02: return "Monster_2_green"
            case AssetKeys.Monster.monster03: return "Monster_3_yellow"
            case AssetKeys.Monster.monster04: return "Monster_4_red"
            default:                           return assetID
            }
        }
    }
}
