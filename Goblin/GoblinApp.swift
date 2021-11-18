//
//  GoblinApp.swift
//  Goblin
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI
import Troll

@main
struct GoblinApp: App {
    @State private var rolls: [Roll] = {
        var rolls: [Roll] = []
        for var roll in Roll.starterRolls {
            roll.compile()
            rolls.append(roll)
        }
        return rolls
    }()

    var body: some Scene {
        WindowGroup {
            RollListView(rolls: $rolls)
        }
    }
}
