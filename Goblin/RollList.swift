//
//  RollList.swift
//  Example
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI

// TODO: use the new(ish) HintKit ...

struct RollList: View {
    @Binding var rolls: [Roll]

    var body: some View {
        NavigationView {
            List {
                ForEach($rolls) { $roll in
                    RollRow(roll: $roll)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Rolls")
            .navigationBarItems(leading: infoButton,
                                trailing: addButton)
        }
    }

    private func delete(at offsets: IndexSet) {
        rolls.remove(atOffsets: offsets)
    }

    private func addItem() {
        rolls.append(Roll(name: "New Roll"))
    }

    private var infoButton: Button<Image> {
        return Button(action: {

        }) {
            Image(systemName: "info.circle.fill")
        }
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
        RollList(rolls: .constant(Roll.starterRolls))
            .colorScheme(.dark)

        RollList(rolls: .constant(Roll.starterRolls))
            .colorScheme(.light)
    }
}
