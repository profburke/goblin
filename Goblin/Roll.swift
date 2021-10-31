//
//  Roll.swift
//  Goblin
//
//  Created by Matthew Burke on 10/30/21.
//

import Foundation
import Troll

// TODO: mutable or not?
// TODO: add a history of roll results...

struct Roll: Identifiable {
    let id = UUID()
    var name: String
    var script: String? // put a didSet handler on this to try compiling...
    var latest: String?
    var expression: Expr?

    var compiled: Bool {
        return expression != nil
    }

    init(name: String, script: String? = nil, latest: String? = nil) {
        self.name = name
        self.script = script
        self.latest = latest
    }

    mutating func roll() {
        guard let expression = expression else { return }

        let interpeter = Interpreter(reporter: CircularFileErrorRerporter())
        let result = interpeter.evaluate(expression)

        switch result {
        case .failure:
            // TODO: runtime error - signal somehow
            break
        case .success(let value):
            latest = "\(value)"
        }
    }
}

extension Roll {
    static var starterRolls: [Roll] {
        [
            Roll(name: "D&D Attributes", script: "largest 3 4d6"),
            Roll(name: "Yahtzee", script: "5d6"),
        ]
    }
}
