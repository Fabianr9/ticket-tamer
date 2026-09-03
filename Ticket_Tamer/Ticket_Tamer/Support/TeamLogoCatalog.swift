import Foundation

/// Lokale, rein visuelle JPEG-Ressource einer Teamstation.
struct TeamLogoResource: Equatable {
    let name: String
    let fileExtension: String

    var fileName: String { "\(name).\(fileExtension)" }

    /// Xcode kann Dateien aus einem synchronisierten Ressourcenordner je nach
    /// Build-Einstellung mit oder ohne Unterordner in das Bundle kopieren.
    func url(in bundle: Bundle = .main) -> URL? {
        bundle.url(
            forResource: name,
            withExtension: fileExtension,
            subdirectory: TeamLogoCatalog.bundleSubdirectory
        ) ?? bundle.url(forResource: name, withExtension: fileExtension)
    }
}

/// Einzige Team-zu-Logo-Zuordnung der App (Modul 028 — F-28 / F-39).
///
/// Fachliche Team-IDs und Drop-Geometrie bleiben außerhalb dieses Katalogs. Ein
/// fehlendes Bild kann daher nur die Darstellung, nie die Teamzuordnung ändern.
enum TeamLogoCatalog {
    static let bundleSubdirectory = "TeamLogos"

    struct Entry: Equatable {
        let team: SupportTeam
        let resource: TeamLogoResource
    }

    private static let network = TeamLogoResource(
        name: "Network_team_icon_design_202609032139", fileExtension: "jpeg"
    )
    private static let account = TeamLogoResource(
        name: "Team_icon_design_profile_lock_202609032138", fileExtension: "jpeg"
    )
    private static let software = TeamLogoResource(
        name: "Software_team_icon_design_202609032138", fileExtension: "jpeg"
    )
    private static let hardware = TeamLogoResource(
        name: "Hardware_team_icon_design_202609032138", fileExtension: "jpeg"
    )

    static let entries: [Entry] = [
        .init(team: .netzwerk, resource: network),
        .init(team: .konto, resource: account),
        .init(team: .software, resource: software),
        .init(team: .hardware, resource: hardware),
    ]

    static func resource(for team: SupportTeam) -> TeamLogoResource {
        // `SupportTeam` und der Katalog besitzen verbindlich dieselben vier Faelle.
        // Der Switch hält den Lookup trotzdem total und unabhängig vom Bundlezustand.
        switch team {
        case .netzwerk: network
        case .konto: account
        case .software: software
        case .hardware: hardware
        }
    }
}
