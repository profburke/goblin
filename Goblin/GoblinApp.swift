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
    static let rollFilename = "rolls.json"

    @Environment(\.scenePhase) private var scenePhase
    @State private var rolls: [Roll] = {
        let url = GoblinApp.saveFileURL

        if FileManager().fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url),
           let rolls = try? JSONDecoder().decode([Roll].self, from: data),
           rolls.count >= 1 {
            return rolls
        } else {
            // TODO: signal could not find custom data, reading defaults?
            return Roll.starterRolls
        }
    }()

    var body: some Scene {
        WindowGroup {
            RollListView(rolls: $rolls)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                if let data = try? JSONEncoder().encode(rolls) {
                    try? data.write(to: GoblinApp.saveFileURL)
                } else {
                    // TODO: signal error if cannot save
                }
            }
        }
    }

    static private var saveFileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory.appendingPathComponent(rollFilename)
    }
}
