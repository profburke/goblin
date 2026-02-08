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
    @State private var path: [UUID] = []
    @State private var pendingNewRollID: UUID?

    var body: some View {
        NavigationStack(path: $path) {
            ScrollViewReader { proxy in
                List {
                    ForEach($rolls) { $roll in
                        RollRow(roll: $roll)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                .navigationTitle("Rolls")
                .navigationBarItems(leading: infoButton,
                                    trailing: addButton)
                .toolbar { EditButton() }
                .navigationDestination(for: UUID.self) { id in
                    if let index = rolls.firstIndex(where: { $0.id == id }) {
                        EditorView(roll: $rolls[index])
                    }
                }
                .onChange(of: pendingNewRollID) { _, newValue in
                    guard let id = newValue else { return }
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        path.append(id)
                        pendingNewRollID = nil
                    }
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        rolls.remove(atOffsets: offsets)
    }

    private func move(from source: IndexSet, to destination: Int) {
        rolls.move(fromOffsets: source, toOffset: destination)
    }

    private func addItem() {
        let newRoll = Roll(name: "New Roll")
        rolls.append(newRoll)
        pendingNewRollID = newRoll.id
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
