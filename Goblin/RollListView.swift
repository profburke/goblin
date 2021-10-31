//
//  RollListView.swift
//  Example
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI

struct RollListView: View {
    @Binding var rolls: [Roll]

    var body: some View {
        NavigationView {
            List {
                ForEach (rolls) { r in
                    RollRowView(roll: binding(for: r))
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Rolls")
            .navigationBarItems(trailing: Button(action: {
                self.addItem()
            }) {
                Image(systemName: "plus")
            })
        }
    }

    private func binding(for roll: Roll) -> Binding<Roll> {
        guard let index = rolls.firstIndex(where: { $0.id == roll.id }) else {
            fatalError("Can't find roll in array.")
        }

        return $rolls[index]
    }

    private func delete(at offsets: IndexSet) {
        rolls.remove(atOffsets: offsets)
    }

    private func addItem() {
        rolls.append(Roll(name: "New Roll"))
    }
}

struct RollListView_Previews: PreviewProvider {
    static var previews: some View {
        RollListView(rolls: .constant(Roll.starterRolls))
    }
}
