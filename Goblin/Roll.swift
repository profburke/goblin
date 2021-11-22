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
    var script: String // put a didSet handler on this to try compiling...
    // no, not really... do we want to try compiling on every key stroke when it's being edited?
    // ok, well you could do like in the scrumdinger app...have a Roll.Data subtype and use
    // that in the editor view...
    var latest: String?
    var expression: Expr?

    var compiled: Bool {
        return expression != nil
    }

    enum CodingKeys: CodingKey {
        case name
        case script
        // add latest?
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

        compile()
    }

    // TODO: when do we want to invalidate the compiled expression?
    // if we don't bother, then the following can happen:
    // 1. enter new script
    // 2. compile and there's an error
    // 3. the previously compiled expression is still there
    
    mutating func compile() {
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
