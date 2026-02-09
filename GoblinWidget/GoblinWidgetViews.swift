//
//  GoblinWidgetViews.swift
//  Goblin Widget
//
//  Created by Claude on 2/9/26.
//

import SwiftUI
import WidgetKit
import AppIntents

// MARK: - Main Entry View

struct GoblinWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: GoblinWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .accessoryCircular:
            CircularWidgetView()
        case .accessoryRectangular:
            RectangularWidgetView(entry: entry)
        case .accessoryInline:
            InlineWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - System Small

struct SmallWidgetView: View {
    let entry: GoblinWidgetEntry

    var body: some View {
        if !entry.isConfigured {
            unconfiguredView
        } else if entry.isDeleted {
            deletedView
        } else {
            configuredView
        }
    }

    private var configuredView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.rollName ?? "")
                .font(.caption.bold())
                .lineLimit(1)

            if let result = entry.rollResult {
                Text(result)
                    .font(.system(.body, design: .monospaced))
                    .lineLimit(3)
                    .minimumScaleFactor(0.6)
            } else {
                Text("Tap to roll")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let entity = entry.rollEntity {
                Button(intent: PerformRollIntent(entity: entity)) {
                    Image(systemName: "die.face.6.fill")
                        .font(.title2)
                        .foregroundStyle(.purple)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var unconfiguredView: some View {
        VStack(spacing: 8) {
            Image(systemName: "die.face.6.fill")
                .font(.largeTitle)
                .foregroundStyle(.purple)
            Text("Edit widget to choose a roll")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }

    private var deletedView: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(.orange)
            Text("Roll deleted — edit widget to choose another")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - System Medium

struct MediumWidgetView: View {
    let entry: GoblinWidgetEntry

    var body: some View {
        if !entry.isConfigured {
            unconfiguredView
        } else if entry.isDeleted {
            deletedView
        } else {
            configuredView
        }
    }

    private var configuredView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.rollName ?? "")
                    .font(.headline)
                    .lineLimit(1)

                Text(entry.rollScript ?? "")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Spacer()

                if let result = entry.rollResult {
                    Text(result)
                        .font(.system(.body, design: .monospaced))
                        .lineLimit(4)
                        .minimumScaleFactor(0.6)
                } else {
                    Text("No result yet")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if let entity = entry.rollEntity {
                Button(intent: PerformRollIntent(entity: entity)) {
                    Image(systemName: "die.face.6.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.purple)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var unconfiguredView: some View {
        HStack(spacing: 12) {
            Image(systemName: "die.face.6.fill")
                .font(.largeTitle)
                .foregroundStyle(.purple)
            Text("Edit widget to choose a roll")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }

    private var deletedView: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(.orange)
            Text("Roll deleted — edit widget to choose another")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Accessory Circular

struct CircularWidgetView: View {
    var body: some View {
        Image(systemName: "die.face.6.fill")
            .font(.title2)
            .widgetAccentable()
    }
}

// MARK: - Accessory Rectangular

struct RectangularWidgetView: View {
    let entry: GoblinWidgetEntry

    var body: some View {
        if !entry.isConfigured {
            Text("Edit to choose a roll")
                .font(.caption)
        } else if entry.isDeleted {
            Text("Roll deleted")
                .font(.caption)
        } else {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.rollName ?? "")
                    .font(.caption.bold())
                    .lineLimit(1)
                    .widgetAccentable()

                if let result = entry.rollResult {
                    Text(result)
                        .font(.system(.caption2, design: .monospaced))
                        .lineLimit(2)
                } else {
                    Text("Tap to roll")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Accessory Inline

struct InlineWidgetView: View {
    let entry: GoblinWidgetEntry

    var body: some View {
        if !entry.isConfigured {
            Text("Goblin: Edit to configure")
        } else if entry.isDeleted {
            Text("Goblin: Roll deleted")
        } else if let result = entry.rollResult {
            Text("\(entry.rollName ?? "Roll"): \(result)")
        } else {
            Text("\(entry.rollName ?? "Roll"): —")
        }
    }
}

// MARK: - Previews

#Preview("Small", as: .systemSmall) {
    GoblinWidget()
} timeline: {
    GoblinWidgetEntry.placeholder
    GoblinWidgetEntry.unconfigured
}

#Preview("Medium", as: .systemMedium) {
    GoblinWidget()
} timeline: {
    GoblinWidgetEntry.placeholder
    GoblinWidgetEntry.unconfigured
}
