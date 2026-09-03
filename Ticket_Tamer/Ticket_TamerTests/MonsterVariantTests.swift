import Testing
@testable import Ticket_Tamer

@MainActor
struct MonsterVariantCatalogTests {
    @Test("Variantenkatalog besitzt exakt vier Monstertypen")
    func fourMonsterTypes() {
        #expect(MonsterVariantCatalog.variantsByMonsterType.count == 4)
    }

    @Test("Jeder Monstertyp besitzt exakt vier Varianten")
    func fourVariantsPerType() {
        #expect(MonsterVariantCatalog.variantsByMonsterType.values.allSatisfy { $0.count == 4 })
    }

    @Test("Variantenkatalog besitzt insgesamt exakt 16 Eintraege")
    func sixteenVariants() {
        #expect(MonsterVariantCatalog.allVariants.count == 16)
    }

    @Test("Alle Dateinamen sind befuellt")
    func nonEmptyFileNames() {
        #expect(MonsterVariantCatalog.allVariants.allSatisfy { !$0.assetFileName.isEmpty })
    }

    @Test("Alle produktiven Dateinamen sind eindeutig")
    func uniqueFileNames() {
        #expect(Set(MonsterVariantCatalog.allVariants.map(\.assetFileName)).count == 16)
    }

    @Test("Typ 3 besitzt die reale gelbe Variante")
    func typeThreeHasYellow() {
        #expect(keys(for: AssetKeys.Monster.monster03) == Set(["blue", "green", "pink", "yellow"]))
    }

    @Test("Typ 3 besitzt keine erfundene rote Variante")
    func typeThreeHasNoRed() {
        #expect(!keys(for: AssetKeys.Monster.monster03).contains("red"))
    }

    @Test("Typ 1 besitzt alle vier realen Varianten")
    func typeOneVariants() {
        #expect(keys(for: AssetKeys.Monster.monster01) == Set(["blue", "green", "pink", "red"]))
    }

    @Test("Typ 2 besitzt alle vier realen Varianten")
    func typeTwoVariants() {
        #expect(keys(for: AssetKeys.Monster.monster02) == Set(["blue", "green", "pink", "red"]))
    }

    @Test("Typ 4 besitzt alle vier realen Varianten")
    func typeFourVariants() {
        #expect(keys(for: AssetKeys.Monster.monster04) == Set(["blue", "green", "pink", "red"]))
    }

    @Test("Jede Variante nennt ihren Katalogtyp")
    func variantsBelongToCatalogType() {
        for (type, variants) in MonsterVariantCatalog.variantsByMonsterType {
            #expect(variants.allSatisfy { $0.monsterTypeID == type })
        }
    }

    @Test("Unbekannter Monstertyp wird defensiv behandelt")
    func unknownTypeIsEmpty() {
        #expect(MonsterVariantCatalog.variants(for: "monsterXX").isEmpty)
    }

    @Test("Manipulierte Variante ist nicht katalogisiert")
    func unknownVariantIsRejected() {
        let unknown = MonsterAssetVariant(monsterTypeID: AssetKeys.Monster.monster01, variantKey: "orange", assetFileName: "missing")
        #expect(!MonsterVariantCatalog.contains(unknown))
    }

    @Test("Alle Varianten verwenden konkrete Monster-Dateinamen")
    func concreteFileNames() {
        #expect(MonsterVariantCatalog.allVariants.allSatisfy { $0.assetFileName.hasPrefix("Monster_") })
    }

    @Test("Variantenschluessel enthalten keine Teamnamen")
    func noTeamEncoding() {
        let teams = Set(SupportTeam.allCases.map(\.rawValue))
        #expect(MonsterVariantCatalog.allVariants.allSatisfy { !teams.contains($0.variantKey) })
    }

    @Test("Variantenschluessel enthalten keine Prioritaetsnamen")
    func noPriorityEncoding() {
        let priorities = Set(TicketPriority.allCases.map(\.rawValue))
        #expect(MonsterVariantCatalog.allVariants.allSatisfy { !priorities.contains($0.variantKey) })
    }

    private func keys(for type: String) -> Set<String> {
        Set(MonsterVariantCatalog.variants(for: type).map(\.variantKey))
    }
}

@MainActor
struct SessionMonsterVariantTests {
    @Test("Jedes Sitzungsticket erhaelt genau eine Variante")
    func everySessionTicketGetsOneVariant() {
        let model = deterministicModel(key: "blue")
        #expect(model.selectedMonsterVariantByTicketID.count == model.sessionTickets.count)
    }

    @Test("Gewaehlt wird nur innerhalb des vorhandenen Monstertyps")
    func selectionMatchesMonsterType() {
        let model = deterministicModel(key: "pink")
        for ticket in model.sessionTickets {
            #expect(model.selectedMonsterVariant(for: ticket)?.monsterTypeID == ticket.monsterAssetId)
        }
    }

    @Test("Injizierter Selector waehlt exakt die vorgegebene Variante")
    func injectedSelectorIsExact() {
        let model = deterministicModel(key: "green")
        #expect(model.selectedMonsterVariantByTicketID.values.allSatisfy { $0.variantKey == "green" })
    }

    @Test("Drei Lookups derselben Sitzung bleiben identisch")
    func repeatedLookupsAreStable() {
        let model = deterministicModel(key: "pink")
        let ticket = model.sessionTickets[0]
        #expect(model.selectedMonsterVariant(for: ticket) == model.selectedMonsterVariant(for: ticket))
        #expect(model.selectedMonsterVariant(for: ticket) == model.selectedMonsterVariant(for: ticket))
    }

    @Test("Untersuchung Priorisierung und Team verwenden denselben Assetnamen")
    func phasesShareAssetName() {
        let model = deterministicModel(key: "blue")
        let ticket = model.sessionTickets[0]
        let investigation = model.selectedMonsterVariant(for: ticket)?.assetFileName
        let priority = model.selectedMonsterVariant(for: ticket)?.assetFileName
        let team = model.selectedMonsterVariant(for: ticket)?.assetFileName
        #expect(investigation == priority && priority == team)
    }

    @Test("Retry-Lookup bleibt beim gespeicherten Assetnamen")
    func retryKeepsAssetName() {
        let model = deterministicModel(key: "green")
        let ticket = model.sessionTickets[0]
        let first = model.selectedMonsterVariant(for: ticket)?.assetFileName
        let retry = model.selectedMonsterVariant(for: ticket)?.assetFileName
        #expect(retry == first)
    }

    @Test("Mehrfacher Retry wuerfelt nicht neu")
    func repeatedRetryKeepsAssetName() {
        let model = deterministicModel(key: "pink")
        let ticket = model.sessionTickets[0]
        let names = (0..<3).map { _ in model.selectedMonsterVariant(for: ticket)?.assetFileName }
        #expect(Set(names.compactMap { $0 }).count == 1)
    }

    @Test("Neue Sitzung darf eine andere Variante waehlen")
    func newSessionCanSelectAgain() {
        let model = deterministicModel(key: "blue")
        let ticketID = model.sessionTickets[0].id
        let old = model.selectedMonsterVariantByTicketID[ticketID]
        model.startSession(using: { $0 }, variantSelector: { $0.first { $0.variantKey == "green" } })
        #expect(model.selectedMonsterVariantByTicketID[ticketID] != old)
    }

    @Test("Reset leert alle Variantenzuordnungen")
    func resetClearsMapping() {
        let model = deterministicModel(key: "blue")
        model.reset()
        #expect(model.selectedMonsterVariantByTicketID.isEmpty)
    }

    @Test("Neue Sitzung enthaelt nur Zuordnungen ihrer Tickets")
    func newSessionOnlyMapsItsTickets() {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { Array($0.reversed()) }, variantSelector: { $0.first })
        #expect(Set(model.selectedMonsterVariantByTicketID.keys) == Set(model.sessionTickets.map(\.id)))
    }

    @Test("Ungueltige Selector-Ausgabe erzeugt keine stille Ersatzwahl")
    func invalidSelectorDoesNotReselect() {
        let model = SessionModel()
        model.setTicketCount(1)
        let invalid = MonsterAssetVariant(monsterTypeID: "wrong", variantKey: "wrong", assetFileName: "wrong")
        model.startSession(using: { $0 }, variantSelector: { _ in invalid })
        #expect(model.selectedMonsterVariantByTicketID.isEmpty)
        #expect(model.selectedMonsterVariant(for: model.sessionTickets[0]) == nil)
    }

    @Test("Fehlende Selector-Ausgabe erzeugt keine spaete Auswahl")
    func nilSelectorDoesNotReselect() {
        let model = SessionModel()
        model.setTicketCount(1)
        model.startSession(using: { $0 }, variantSelector: { _ in nil })
        let ticket = model.sessionTickets[0]
        #expect(model.selectedMonsterVariant(for: ticket) == nil)
        #expect(model.selectedMonsterVariant(for: ticket) == nil)
    }

    @Test("Gleicher Monstertyp kann pro Ticket andere Farben erhalten")
    func sameTypeCanReceiveDifferentColors() {
        let model = SessionModel()
        model.setTicketCount(12)
        var indexByType: [String: Int] = [:]
        model.startSession(using: { $0 }, variantSelector: { variants in
            guard let type = variants.first?.monsterTypeID else { return nil }
            let index = indexByType[type, default: 0]
            indexByType[type] = index + 1
            return variants[index % variants.count]
        })
        let typeOneKeys = model.sessionTickets
            .filter { $0.monsterAssetId == AssetKeys.Monster.monster01 }
            .compactMap { model.selectedMonsterVariant(for: $0)?.variantKey }
        #expect(Set(typeOneKeys).count > 1)
    }

    @Test("Dieselbe Farbe ist unabhaengig von Team und Prioritaet moeglich")
    func sameColorAcrossGameplayReferences() {
        let model = deterministicModel(key: "blue", ticketCount: 12)
        #expect(Set(model.sessionTickets.map(\.referenceTeam.rawValue)).count > 1)
        #expect(Set(model.sessionTickets.map(\.referencePriority.rawValue)).count > 1)
        #expect(model.selectedMonsterVariantByTicketID.values.allSatisfy { $0.variantKey == "blue" })
    }

    private func deterministicModel(key: String, ticketCount: Int = 6) -> SessionModel {
        let model = SessionModel()
        model.setTicketCount(ticketCount)
        model.startSession(using: { $0 }, variantSelector: { variants in
            variants.first { $0.variantKey == key } ?? variants.first
        })
        return model
    }
}

@MainActor
struct MonsterVariantRetryTests {
    @Test("Recovery merkt sich die konkrete Varianten-ID")
    func recoveryStoresConcreteVariantID() {
        var recovery = MonsterLoadRecovery()
        _ = recovery.begin(assetID: "Monster_3_yellow")
        #expect(recovery.requestedAssetID == "Monster_3_yellow")
    }

    @Test("Recovery-Reset entfernt die konkrete Varianten-ID")
    func recoveryResetClearsVariantID() {
        var recovery = MonsterLoadRecovery()
        _ = recovery.begin(assetID: "Monster_4_pink")
        recovery.finishWithFailure()
        recovery.reset()
        #expect(recovery.requestedAssetID == nil)
    }
}
