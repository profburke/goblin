//
//  Roll.swift
//  Goblin
//
//  Created by Matthew Burke on 10/30/21.
//

import Foundation
import Troll

class CollectingErrorReporter: ErrorReporter {
    private(set) var messages: [String] = []

    func error(line: Int, position: Int, message: String) {
        messages.append("[line \(line), pos \(position)] \(message)")
    }
}

struct Roll: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var script: String
    var latest: String?
    var expression: Expr?

    var compiled: Bool {
        return expression != nil
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case script
        case latest
    }

    init(name: String, script: String = "d6", latest: String? = nil) {
        self.id = UUID()
        self.name = name
        self.script = script
        self.latest = latest

        compile()
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        script = try values.decode(String.self, forKey: .script)
        latest = try? values.decode(String?.self, forKey: .latest)

        compile()
    }

    static func == (lhs: Roll, rhs: Roll) -> Bool {
        lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.script == rhs.script
        && lhs.latest == rhs.latest
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    enum TranslationError: Error {
        case generic(String)
    }

    @discardableResult
    mutating func compile() -> Result<Void, TranslationError> {
        convertSmartQuotesToPlain()
        expression = nil

        let reporter = CollectingErrorReporter()
        let scanner = Scanner(script, reporter: reporter)

        return scanner.scan()
            .mapError { _ in
                .generic(reporter.messages.joined(separator: "\n"))
            }
            .flatMap { tokens in
                let parser = Parser(tokens, reporter: reporter)
                return parser.parse()
                    .mapError { _ in
                        .generic(reporter.messages.joined(separator: "\n"))
                    }
                    .flatMap { data in
                        expression = data.expression
                        return .success(())
                    }
            }
    }

    func roll() -> String? {
        guard let expression = expression else { return nil }

        let interpeter = Interpreter(reporter: CircularFileErrorRerporter())
        let result = interpeter.evaluate(expression)

        switch result {
        case .failure:
            // TODO: runtime error - signal somehow
            // possibly just return error as string
            return nil
        case .success(let value):
            return "\(value)"
        }
    }
}

extension Roll {
    static var starterRolls: [Roll] = [
        Roll(name: "Tap die to roll", script: "d6"),
        Roll(name: "Tap elsewhere to edit", script: "d10 + d20"),
        Roll(name: "Rolls copied to clipboard"),
        Roll(name: "Press info button in editor"),
        Roll(name: "To learn about Troll scripting"),
        Roll(name: "D&D Attribute", script: "x := largest 3 4d6; [sum x, x]"),
        Roll(name: "D&D Character Gen", script: #""Str |>Dex|>Con|>Int|>Wis|>Chr" || 6'sum largest 3 4d6"#),
        Roll(name: "Yahtzee", script: "5d6"),
        Roll(name: "Ridiculous", script: "40 d7"),
        Roll(name: "Pizza or Buger", script: "if ?0.5 then \"🍕\" else \"🍔\""),
    ]
}

extension Roll { 
    // if only SwiftUI would allow you to disable smart quotes...
    private mutating func convertSmartQuotesToPlain() {
        script = script.replacingOccurrences(of: "“", with: #"""#)
            .replacingOccurrences(of: "”", with: #"""#)
            .replacingOccurrences(of: "‘", with: "'")
    }
}
