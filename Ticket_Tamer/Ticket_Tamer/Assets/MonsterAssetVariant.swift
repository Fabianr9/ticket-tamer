import Foundation

/// Eine konkrete, lokal gebuendelte Farbvariante eines fachlich neutralen Monstertyps.
///
/// Die Struktur enthaelt bewusst weder Team-, Prioritaets- noch Bewertungsdaten.
struct MonsterAssetVariant: Equatable, Hashable {
    let monsterTypeID: String
    let variantKey: String
    let assetFileName: String
}

/// Explizites Mapping der real vorhandenen USDC-Dateien.
///
/// Dateinamen werden absichtlich nicht aus Farbwerten konstruiert: insbesondere besitzt
/// Typ 3 eine gelbe statt einer roten Variante.
enum MonsterVariantCatalog {
    static let variantsByMonsterType: [String: [MonsterAssetVariant]] = [
        AssetKeys.Monster.monster01: [
            .init(monsterTypeID: AssetKeys.Monster.monster01, variantKey: "blue", assetFileName: "Monster_1_blue"),
            .init(monsterTypeID: AssetKeys.Monster.monster01, variantKey: "green", assetFileName: "Monster_1_green"),
            .init(monsterTypeID: AssetKeys.Monster.monster01, variantKey: "pink", assetFileName: "Monster_1_pink"),
            .init(monsterTypeID: AssetKeys.Monster.monster01, variantKey: "red", assetFileName: "Monster_1_red"),
        ],
        AssetKeys.Monster.monster02: [
            .init(monsterTypeID: AssetKeys.Monster.monster02, variantKey: "blue", assetFileName: "Monster_2_blue"),
            .init(monsterTypeID: AssetKeys.Monster.monster02, variantKey: "green", assetFileName: "Monster_2_green"),
            .init(monsterTypeID: AssetKeys.Monster.monster02, variantKey: "pink", assetFileName: "Monster_2_pink"),
            .init(monsterTypeID: AssetKeys.Monster.monster02, variantKey: "red", assetFileName: "Monster_2_red"),
        ],
        AssetKeys.Monster.monster03: [
            .init(monsterTypeID: AssetKeys.Monster.monster03, variantKey: "blue", assetFileName: "Monster_3_blue"),
            .init(monsterTypeID: AssetKeys.Monster.monster03, variantKey: "green", assetFileName: "Monster_3_green"),
            .init(monsterTypeID: AssetKeys.Monster.monster03, variantKey: "pink", assetFileName: "Monster_3_pink"),
            .init(monsterTypeID: AssetKeys.Monster.monster03, variantKey: "yellow", assetFileName: "Monster_3_yellow"),
        ],
        AssetKeys.Monster.monster04: [
            .init(monsterTypeID: AssetKeys.Monster.monster04, variantKey: "blue", assetFileName: "Monster_4_blue"),
            .init(monsterTypeID: AssetKeys.Monster.monster04, variantKey: "green", assetFileName: "Monster_4_green"),
            .init(monsterTypeID: AssetKeys.Monster.monster04, variantKey: "pink", assetFileName: "Monster_4_pink"),
            .init(monsterTypeID: AssetKeys.Monster.monster04, variantKey: "red", assetFileName: "Monster_4_red"),
        ],
    ]

    static let allVariants: [MonsterAssetVariant] = AssetKeys.Monster.allIDs.flatMap {
        variantsByMonsterType[$0] ?? []
    }

    static func variants(for monsterTypeID: String) -> [MonsterAssetVariant] {
        variantsByMonsterType[monsterTypeID] ?? []
    }

    static func contains(_ variant: MonsterAssetVariant) -> Bool {
        variants(for: variant.monsterTypeID).contains(variant)
    }
}
