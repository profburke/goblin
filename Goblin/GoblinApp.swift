//
//  GoblinApp.swift
//  Goblin
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI

@main
struct GoblinApp: App {
    @State private var rolls = Roll.starterRolls

    var body: some Scene {
        WindowGroup {
            RollListView(rolls: $rolls)
        }
    }
}
