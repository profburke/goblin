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
                ForEach ($rolls) { $roll in
                    RollRowView(roll: $roll)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Rolls")
            .navigationBarItems(trailing: addButton)
        }
    }

    private func delete(at offsets: IndexSet) {
        rolls.remove(atOffsets: offsets)
    }

    private func addItem() {
        rolls.append(Roll(name: "New Roll"))
    }

    private var addButton: Button<Image> {
        return Button(action: {
            self.addItem()
        }) {
            Image(systemName: "plus")
        }
    }
}

struct RollListView_Previews: PreviewProvider {

    static var previews: some View {
        RollListView(rolls: .constant(Roll.starterRolls))
            .colorScheme(.dark)

        RollListView(rolls: .constant(Roll.starterRolls))
            .colorScheme(.light)
    }
}
