//
//  AppConstants.swift
//  Goblin
//
//  Created by Claude on 2/9/26.
//

import Foundation

enum AppConstants {
    static let appGroupID = "group.net.bluedino.Goblin"

    static var sharedContainerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        )!
    }

    static var rollsFileURL: URL {
        sharedContainerURL.appendingPathComponent("rolls.json")
    }
}
