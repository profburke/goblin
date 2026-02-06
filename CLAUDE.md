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
```

- Minimum deployment: iOS 17.0, watchOS 8.0
- Swift 5.0, SwiftUI framework

## Architecture

### Targets
- **Goblin** — iOS app (iPhone + iPad)
- **Goblin WatchKit App** / **Goblin WatchKit Extension** — watchOS companion (incomplete/minimal)

### File Structure
```
Goblin/
  GoblinApp.swift              # App entry, roll loading/saving
  Models/
    Roll.swift                 # Core model: name, script, compiled expr, result
  Views/
    RollList.swift             # Main list of saved rolls
    RollRow.swift              # Row with die icon and roll data
    EditorView.swift           # Script editor
    LanguageExplainerView.swift # Help sheet for Troll syntax
Goblin WatchKit Extension/     # watchOS implementation
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
- Rolls are saved as JSON to `rolls.json` in the app's Documents directory
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
- **Error reporter**: Uses `CircularFileErrorReporter()` from Troll for interpreter errors.
