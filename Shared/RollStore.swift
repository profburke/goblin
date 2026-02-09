//
//  RollStore.swift
//  Goblin
//
//  Created by Claude on 2/9/26.
//

import Foundation
import WidgetKit

enum RollStore {
    static func loadRolls() -> [Roll] {
        let url = AppConstants.rollsFileURL

        if FileManager.default.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url),
           let rolls = try? JSONDecoder().decode([Roll].self, from: data),
           rolls.count >= 1 {
            return rolls
        } else {
            return Roll.starterRolls
        }
    }

    static func saveRolls(_ rolls: [Roll]) {
        if let data = try? JSONEncoder().encode(rolls) {
            try? data.write(to: AppConstants.rollsFileURL)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func findRoll(byID id: UUID) -> Roll? {
        loadRolls().first { $0.id == id }
    }
}
