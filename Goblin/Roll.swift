//
//  Roll.swift
//  Goblin
//
//  Created by Matthew Burke on 10/30/21.
//

import Foundation
import Troll

struct Roll: Identifiable, Codable {
    let id = UUID()
    var name: String
    var script: String
    var latest: String?
    var expression: Expr?

    var compiled: Bool {
        return expression != nil
    }

    enum CodingKeys: CodingKey {
        case name
        case script
        case latest
    }

    init(name: String, script: String = "d6", latest: String? = nil) {
        self.name = name
        self.script = script
        self.latest = latest

        compile()
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        script = try values.decode(String.self, forKey: .script)
        latest = try? values.decode(String?.self, forKey: .latest)

        compile()
    }

    mutating func compile() {
        convertSmartQuotesToPlain()
            expression = nil
        let scanner = Scanner(script)
        guard case .success(let tokens) = scanner.scan() else { return }
        let parser = Parser(tokens)
        guard case .success(let data) = parser.parse() else { return }
        expression = data.expression
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
            Roll(name: "D&D Attribute", script: "x := largest 3 4d6; [sum x, x]"),
            Roll(name: "D&D Character Gen", script: #""Str |>Dex|>Con|>Int|>Wis|>Chr" || 6'sum largest 3 4d6"#),
            Roll(name: "Yahtzee", script: "5d6"),
            Roll(name: "d6"),
            Roll(name: "This should not be rollable", script: "12......14"),
            Roll(name: "Ridiculous", script: "40 d7"),
        ]
}

extension Roll { // if only SwiftUI would allow you to disable smart quotes...
    private mutating func convertSmartQuotesToPlain() {
        script = script.replacingOccurrences(of: "“", with: #"""#)
            .replacingOccurrences(of: "”", with: #"""#)
            .replacingOccurrences(of: "‘", with: "'")
    }
}
