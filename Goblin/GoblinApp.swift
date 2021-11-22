//
//  GoblinApp.swift
//  Goblin
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI
import Troll
import UIKit

@main
struct GoblinApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var rolls: [Roll] = {
        let filePath = GoblinApp.dataPath(for: "rolls.json")
        if FileManager().fileExists(atPath: filePath.path),
           let data = try? Data(contentsOf: filePath),
           let rolls = try? JSONDecoder().decode([Roll].self, from: data),
           rolls.count >= 1 {
            return rolls
            // TODO: this doesn't apparently use the init, because it's not
            // calling .compile
        } else {
            return Roll.starterRolls
        }
    }()

    var body: some Scene {
        WindowGroup {
            RollListView(rolls: $rolls)
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .inactive {
                if let data = try? JSONEncoder().encode(rolls) {
                   let filePath = GoblinApp.dataPath(for: "rolls.json")
                    try? data.write(to: filePath)
                }
                // TODO: signal error if cannot save
            }
        }
    }

    static private func dataPath(for filename: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory.appendingPathComponent(filename)
    }
}
