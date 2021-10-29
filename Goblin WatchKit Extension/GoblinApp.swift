//
//  GoblinApp.swift
//  Goblin WatchKit Extension
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI

@main
struct GoblinApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
