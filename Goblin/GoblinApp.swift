//
//  GoblinApp.swift
//  Goblin
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI
import Troll
import WidgetKit

@main
struct GoblinApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var rolls: [Roll] = RollStore.loadRolls()

    var body: some Scene {
        WindowGroup {
            RollList(rolls: $rolls)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                RollStore.saveRolls(rolls)
            }
        }
    }
}
