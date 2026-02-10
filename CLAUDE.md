# CLAUDE.md — Goblin

## Project Overview

Goblin is a SwiftUI dice-rolling app for iOS and watchOS. Users write dice scripts using the **Troll** DSL (domain-specific language), compile them, and roll to get results. Results are copied to the clipboard on iOS.

## Build & Run

This is an Xcode-only project (no workspace, no CocoaPods/Carthage).

```bash
# Open in Xcode
open Goblin.xcodeproj

# Build iOS app from CLI
xcodebuild -project Goblin.xcodeproj -scheme Goblin -configuration Debug

# Build watchOS app from CLI
xcodebuild -project Goblin.xcodeproj -scheme "Goblin WatchKit App" -configuration Debug

# Build widget extension from CLI
xcodebuild -project Goblin.xcodeproj -scheme GoblinWidget -configuration Debug
```

- Minimum deployment: iOS 17.0, watchOS 8.0
- Swift 5.0, SwiftUI framework

## Architecture

### Targets
- **Goblin** — iOS app (iPhone + iPad)
- **GoblinWidget** — interactive home screen widget extension
- **Goblin WatchKit App** / **Goblin WatchKit Extension** — watchOS companion (incomplete/minimal)

### File Structure
```
Goblin/
  GoblinApp.swift                # App entry, roll loading/saving
  Roll.swift                     # Core model + CollectingErrorReporter
  RollList.swift                 # Main list of saved rolls
  RollRow.swift                  # Row with die icon, haptic feedback on roll
  EditorView.swift               # Script editor with inline compile errors
  InfoView.swift                 # About/support/legal sheet
  LanguageExplainerView.swift    # Help sheet for Troll syntax
  Goblin.entitlements            # App group capability
Shared/                          # Code shared between app and widget
  AppConstants.swift             # App group container URL, rolls file path
  RollStore.swift                # Load/save rolls (shared persistence)
  RollAppIntent.swift            # AppIntents for widget config & Siri shortcuts
  RollEntity.swift               # AppEntity for rolls
GoblinWidget/                    # Home screen widget extension
  GoblinWidget.swift             # Widget config, timeline provider
  GoblinWidgetViews.swift        # Widget family view implementations
  Assets.xcassets/
Goblin WatchKit Extension/       # watchOS (incomplete)
Goblin.xcodeproj/
```

### Key Data Flow

```
Roll script (String)
  → Scanner (tokenize)
  → Parser (build AST)
  → Expr (expression tree)
  → Interpreter (evaluate)
  → result String (copied to clipboard)
```

### Persistence
- Rolls are saved as JSON to `rolls.json` in the shared app group container (`group.net.bluedino.Goblin`) so the widget can access them
- Persistence logic lives in `Shared/RollStore.swift`; `RollStore.save()` calls `WidgetCenter.shared.reloadAllTimelines()` to keep the widget in sync
- Save triggers when the app scene phase becomes inactive
- On first launch, `Roll.starterRolls` provides defaults
- The `expression` field is excluded from Codable — it's recompiled on load

## Dependencies

- **Troll** — Dice DSL parser/interpreter, via SPM from `https://github.com/profburke/troll` (>= 0.5.0)

No other external dependencies.

## Important Conventions

- **Smart quote conversion**: SwiftUI's text editor enables smart quotes by default. `Roll.compile()` converts `""''` to plain ASCII quotes before passing scripts to the Troll scanner, since the parser expects plain quotes.
- **No test target**: The project has no unit or UI tests.
- **watchOS app is incomplete**: The WatchKit extension exists but is minimal.
- **Roll result clipboard**: On iOS, rolling copies the result string to `UIPasteboard.general`.
- **Inline compile errors**: `CollectingErrorReporter` captures scanner/parser errors; `EditorView` displays them in red below the compile button. The interpreter still uses `CircularFileErrorReporter()` at runtime.
- **Haptic feedback**: Die tap triggers `UIImpactFeedbackGenerator(style: .heavy)`.
- **AppIntents / Siri Shortcuts**: `RollAppIntent.swift` provides `SelectRollIntent` (widget config) and `PerformRollIntent` (Siri).
- **#Preview macro**: All views use the modern `#Preview` macro instead of `PreviewProvider`.
