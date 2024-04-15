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
    @Environment(\.scenePhase) private var scenePhase
    @State private var rolls: [Roll] = GoblinApp.loadRolls()

    var body: some Scene {
        WindowGroup {
            RollList(rolls: $rolls)
        }
        .onChange(of: scenePhase) { newPhase in
            saveRolls(newPhase)
        }
    }
}

extension GoblinApp {
    static let rollFilename = "rolls.json"

    static private var saveFileURL: URL {
        return URL.documentsDirectory.appendingPathComponent(rollFilename)
    }

    static private func loadRolls() -> [Roll] {
        let url = GoblinApp.saveFileURL

        if FileManager().fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url),
           let rolls = try? JSONDecoder().decode([Roll].self, from: data),
           rolls.count >= 1 {
            return rolls
        } else {
            // TODO: signal could not find custom data, reading defaults
            return Roll.starterRolls
        }
    }

    private func saveRolls(_ newPhase: ScenePhase) {
        if newPhase == .inactive {
            if let data = try? JSONEncoder().encode(rolls) {
                try? data.write(to: GoblinApp.saveFileURL)
            } else {
                // TODO: signal error if cannot save
            }
        }
    }
}
