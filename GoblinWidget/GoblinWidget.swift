//
//  GoblinWidget.swift
//  Goblin Widget
//
//  Created by Claude on 2/9/26.
//

import WidgetKit
import SwiftUI

struct GoblinWidgetEntry: TimelineEntry {
    let date: Date
    let rollName: String?
    let rollScript: String?
    let rollResult: String?
    let rollEntity: RollEntity?
    let isConfigured: Bool
    let isDeleted: Bool

    static var placeholder: GoblinWidgetEntry {
        GoblinWidgetEntry(
            date: .now,
            rollName: "D&D Attribute",
            rollScript: "sum largest 3 4d6",
            rollResult: "14",
            rollEntity: nil,
            isConfigured: true,
            isDeleted: false
        )
    }

    static var unconfigured: GoblinWidgetEntry {
        GoblinWidgetEntry(
            date: .now,
            rollName: nil,
            rollScript: nil,
            rollResult: nil,
            rollEntity: nil,
            isConfigured: false,
            isDeleted: false
        )
    }
}

struct GoblinWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> GoblinWidgetEntry {
        .placeholder
    }

    func snapshot(for configuration: SelectRollIntent, in context: Context) async -> GoblinWidgetEntry {
        guard let entity = configuration.roll else {
            return .unconfigured
        }

        if let roll = RollStore.findRoll(byID: entity.id) {
            return GoblinWidgetEntry(
                date: .now,
                rollName: roll.name,
                rollScript: roll.script,
                rollResult: roll.latest,
                rollEntity: entity,
                isConfigured: true,
                isDeleted: false
            )
        } else {
            return GoblinWidgetEntry(
                date: .now,
                rollName: nil,
                rollScript: nil,
                rollResult: nil,
                rollEntity: entity,
                isConfigured: true,
                isDeleted: true
            )
        }
    }

    func timeline(for configuration: SelectRollIntent, in context: Context) async -> Timeline<GoblinWidgetEntry> {
        guard let entity = configuration.roll else {
            return Timeline(entries: [.unconfigured], policy: .never)
        }

        let entry: GoblinWidgetEntry
        if let roll = RollStore.findRoll(byID: entity.id) {
            entry = GoblinWidgetEntry(
                date: .now,
                rollName: roll.name,
                rollScript: roll.script,
                rollResult: roll.latest,
                rollEntity: entity,
                isConfigured: true,
                isDeleted: false
            )
        } else {
            entry = GoblinWidgetEntry(
                date: .now,
                rollName: nil,
                rollScript: nil,
                rollResult: nil,
                rollEntity: entity,
                isConfigured: true,
                isDeleted: true
            )
        }

        return Timeline(entries: [entry], policy: .never)
    }
}

struct GoblinWidget: Widget {
    let kind = "GoblinWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectRollIntent.self,
            provider: GoblinWidgetProvider()
        ) { entry in
            GoblinWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Goblin Roll")
        .description("Roll dice from your home screen.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

@main
struct GoblinWidgetBundle: WidgetBundle {
    var body: some Widget {
        GoblinWidget()
    }
}
