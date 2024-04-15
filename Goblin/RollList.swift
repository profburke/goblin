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
//            ScrollViewReader { proxy in
                // https://www.hackingwithswift.com/quick-start/swiftui/how-to-scroll-to-a-specific-row-in-a-list
                // scroll to newly added item ... how to get proxy to the add button
                // handler
                List {
                    ForEach($rolls) { $roll in
                        RollRow(roll: $roll)
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Rolls")
                .navigationBarItems(leading: infoButton,
                                    trailing: addButton)
//            }
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
