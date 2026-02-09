//
//  RollEntity.swift
//  Goblin
//
//  Created by Claude on 2/9/26.
//

import AppIntents

struct RollEntity: AppEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Roll")
    static var defaultQuery = RollEntityQuery()

    var id: UUID
    var name: String
    var script: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)", subtitle: "\(script)")
    }

    init(id: UUID, name: String, script: String) {
        self.id = id
        self.name = name
        self.script = script
    }

    init(from roll: Roll) {
        self.id = roll.id
        self.name = roll.name
        self.script = roll.script
    }
}

struct RollEntityQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [RollEntity] {
        let rolls = RollStore.loadRolls()
        return identifiers.compactMap { id in
            guard let roll = rolls.first(where: { $0.id == id }) else { return nil }
            return RollEntity(from: roll)
        }
    }

    func suggestedEntities() async throws -> [RollEntity] {
        RollStore.loadRolls()
            .filter { $0.compiled }
            .map { RollEntity(from: $0) }
    }
}
