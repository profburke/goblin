//
//  LanguageExplainerView.swift
//  Goblin
//
//  Created by Matthew Burke on 2/2/22.
//

import SwiftUI

struct LanguageExplainerView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Label("About Troll", systemImage: "die.face.5")
                            .font(.headline)
                            .foregroundStyle(.purple)

                        Text("Goblin uses the **Troll** dice language to describe and evaluate dice rolls from tabletop games. A single die is written as **d** followed by the number of faces — for example `d20` for a twenty-sided die. To roll multiple dice, prefix with a count like `3d6`, which produces a **collection** of individual results.")

                        Text("Troll goes well beyond simple rolls. You can combine dice with arithmetic, filter and select from collections, and use conditionals and loops to model almost any rolling convention.")
                    }

                    // MARK: - Operations
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Operations", systemImage: "function")
                            .font(.headline)
                            .foregroundStyle(.orange)

                        operationRow(
                            name: "Arithmetic",
                            detail: "Add, subtract, multiply, and divide results with +, -, *, and /."
                        )
                        operationRow(
                            name: "Selection",
                            detail: "Pick the highest or lowest from a collection with largest and least, or filter with keep and drop."
                        )
                        operationRow(
                            name: "Aggregation",
                            detail: "Reduce a collection to a single value with sum, count, min, max, or median."
                        )
                        operationRow(
                            name: "Conditionals",
                            detail: "Branch with if … then … else to roll differently based on a condition."
                        )
                        operationRow(
                            name: "Repetition",
                            detail: "Loop with repeat, accumulate, or foreach to repeat or iterate over rolls."
                        )
                    }

                    // MARK: - Examples
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Examples", systemImage: "text.page")
                            .font(.headline)
                            .foregroundStyle(.green)

                        exampleCard(code: "d20", description: "Roll a single twenty-sided die")
                        exampleCard(code: "2d6", description: "Roll two six-sided dice — returns a collection of two results")
                        exampleCard(code: "sum largest 3 4d6", description: "Roll four d6 and sum the three highest (classic D&D attribute generation)")
                        exampleCard(code: "if d20 >= 15 then 2d6 else d6", description: "Roll a d20; on 15 or higher roll 2d6, otherwise roll a single d6")
                        exampleCard(code: "foreach x in 3d6 do x * 2", description: "Roll 3d6 and double each individual die result")
                    }

                    // MARK: - Learn More
                    VStack(spacing: 8) {
                        Link(destination: URL(string: "https://hjemmesider.diku.dk/~torbenm/Troll/")!) {
                            Label("Troll Language Reference", systemImage: "safari")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)

                        Text("Opens in Safari")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
            }
        }
    }

    private func operationRow(name: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .fontWeight(.semibold)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }

    private func exampleCard(code: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(code)
                .font(.system(.callout, design: .monospaced))
                .fontWeight(.medium)
                .foregroundStyle(.purple)
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}

struct LanguageExplainerView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageExplainerView()
    }
}
