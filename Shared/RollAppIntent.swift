//
//  RollAppIntent.swift
//  Goblin
//
//  Created by Claude on 2/9/26.
//

import AppIntents
import WidgetKit
import Troll

struct SelectRollIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Roll"
    static var description: IntentDescription = "Choose a roll to display on the widget."

    @Parameter(title: "Roll")
    var roll: RollEntity?
}

struct PerformRollIntent: AppIntent {
    static var title: LocalizedStringResource = "Roll Dice"
    static var description: IntentDescription = "Roll dice using a saved Goblin roll."

    @Parameter(title: "Roll")
    var rollEntity: RollEntity

    init() {}

    init(entity: RollEntity) {
        self.rollEntity = entity
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        var rolls = RollStore.loadRolls()
        guard let index = rolls.firstIndex(where: { $0.id == rollEntity.id }) else {
            return .result(value: "Roll not found")
        }

        var roll = rolls[index]
        roll.compile()

        guard let result = roll.roll() else {
            return .result(value: "Could not evaluate")
        }

        rolls[index].latest = result
        RollStore.saveRolls(rolls)

        return .result(value: result)
    }
}

struct GoblinShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: PerformRollIntent(),
            phrases: [
                "Roll dice with \(.applicationName)",
                "Roll with \(.applicationName)"
            ],
            shortTitle: "Roll Dice",
            systemImageName: "die.face.6.fill"
        )
    }
}
