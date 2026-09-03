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

    /// Laedt eine bereits beim Sitzungsstart ausgewaehlte konkrete Farbvariante.
    static func loadMonster(variant: MonsterAssetVariant) async throws -> Entity {
        guard MonsterVariantCatalog.contains(variant) else {
            DebugManager.log(.spawning, "Unbekannte Monster-Variante abgewiesen: \(variant.assetFileName)")
            throw LoadError.unknownAssetID(variant.assetFileName)
        }

        guard let url = realityKitContentBundle.url(
            forResource: variant.assetFileName,
            withExtension: "usdc",
            subdirectory: "MonsterAssets"
        ) else {
            throw LoadError.entityLoadFailed(variant.assetFileName)
        }

        do {
            let loaded = try Entity.load(contentsOf: url)
            applyBlenderCorrection(to: loaded)
            let wrapper = wrapAndCenter(loaded)
            DebugManager.log(.spawning, "Variante geladen: \(variant.assetFileName).usdc")
            return wrapper
        } catch {
            DebugManager.log(.spawning, "Varianten-Ladefehler fuer '\(variant.assetFileName)': \(error.localizedDescription)")
            throw LoadError.entityLoadFailed(variant.assetFileName)
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

    // MARK: - Einpassung (Framing)

    /// Skaliert `entity` proportional, bis ihre größte sichtbare Ausdehnung `maxExtent` Meter beträgt.
    ///
    /// Grund für die Messung statt eines festen Faktors: die vier Blender-Exporte besitzen
    /// unterschiedliche Rohmaße. Ein konstanter `scale` ergibt deshalb je Asset eine andere
    /// physische Größe — ein Monster passt, ein anderes ragt über die sichtbaren Grenzen
    /// hinaus und wird beschnitten. Über `visualBounds` gemessen ist die Endgröße
    /// assetunabhängig und damit vorhersagbar.
    ///
    /// Ein einziger Faktor für X, Y und Z ⇒ keine Streckung, keine Verzerrung.
    ///
    /// `relativeTo: entity` schließt die eigene Skalierung der Entity aus. Die Funktion ist
    /// dadurch idempotent und darf bei jedem Layoutdurchlauf erneut aufgerufen werden.
    ///
    /// - Parameters:
    ///   - entity: Die einzupassende Entity, üblicherweise der Wrapper aus `loadMonster(assetID:)`.
    ///   - maxExtent: Gewünschte größte Kantenlänge in Metern.
    /// - Returns: Die tatsächlichen Ausdehnungen nach der Einpassung in Metern.
    @discardableResult
    static func fit(_ entity: Entity, toMaxExtent maxExtent: Float) -> SIMD3<Float> {
        let extents = entity.visualBounds(recursive: true, relativeTo: entity).extents
        let largestExtent = max(extents.x, max(extents.y, extents.z))

        guard largestExtent > LayoutConstants.monsterMinimumUsableExtent, maxExtent > 0 else {
            DebugManager.log(.spawning, "VisualBounds unbrauchbar — Einpassung uebersprungen")
            return extents * entity.scale.x
        }

        let scale = maxExtent / largestExtent
        entity.scale = SIMD3<Float>(repeating: scale)
        DebugManager.log(.spawning, "Eingepasst: extents=\(extents), scale=\(scale), ziel=\(maxExtent)")
        return extents * scale
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

// MARK: - Sichtbare Bounds (Modul 013 — Drag-/Drop-Randfix)

extension MonsterAssetProvider {

    /// Sichtbare Ausdehnung des Monsters **relativ zu seinem Root**, inklusive Skalierung.
    ///
    /// Grundlage für `DragBounds.safeRegion(volume:monsterBounds:padding:)` und für die
    /// Überlappungsprüfung in `DropEvaluator.bestTarget`.
    ///
    /// ## Warum nicht das Nennmaß `LayoutConstants.monsterDragDropTargetSize`
    ///
    /// Das Nennmaß beschreibt nur das **Ziel** der Einpassung, nicht das Ergebnis:
    ///
    /// * `fit(_:toMaxExtent:)` bricht bei unbrauchbaren `visualBounds` still ab und lässt
    ///   die Skalierung unverändert — das Nennmaß gilt dann gar nicht,
    /// * es beschreibt ausschließlich die **größte** Kante. Ein Modell von 0.13 m Höhe
    ///   und 0.06 m Breite würde horizontal doppelt so stark eingeschränkt wie nötig,
    /// * es sagt nichts darüber, wie die Hülle um den Ursprung verteilt ist.
    ///
    /// Gemessen wird deshalb tatsächlich, je Asset und je Seite.
    ///
    /// - Parameter entity: Der Wrapper aus `loadMonster(assetID:)`, üblicherweise bereits
    ///   über `fit(_:toMaxExtent:)` eingepasst.
    /// - Returns: Box mit den Offsets `minX/maxX/minY/maxY/minZ/maxZ` relativ zum Root.
    ///   Für ein über `wrapAndCenter` zentriertes Modell liegt sie annähernd symmetrisch
    ///   um den Ursprung; für ein Modell mit Ursprung am Fuß entsprechend verschoben.
    static func localVisualBounds(of entity: Entity) -> BoundingBox {
        // `relativeTo: entity` misst im Eigenraum und schließt die eigene Transformation
        // aus. Anschließend wird sie explizit angewendet — aber ohne Translation, denn
        // gesucht sind die Offsets **relativ zum Root**.
        //
        // Bewusst über die volle Matrix statt nur über `entity.scale`: so gehen auch eine
        // Eigenrotation der Entity und eine ungleichmäßige Skalierung korrekt ein.
        // `BoundingBox.transformed(by:)` transformiert alle acht Ecken und bildet daraus
        // wieder eine achsenparallele Box — genau das, was die Überlappungsprüfung braucht.
        let raw = entity.visualBounds(recursive: true, relativeTo: entity)

        var matrix = entity.transform.matrix
        matrix.columns.3 = SIMD4<Float>(0, 0, 0, 1)

        return raw.transformed(by: matrix)
    }
}
