//
//  ContentView.swift
//  Example
//
//  Created by Matthew Burke on 10/29/21.
//

import SwiftUI

struct Roll: Identifiable {
    let id = UUID()
    let name: String
    let latest: String?

    init(name: String, latest: String? = nil) {
        self.name = name
        self.latest = latest
    }
}

struct RowView: View {
    let roll: Roll

    var body: some View {
        HStack {
            Image(systemName: "die.face.6")
                .onTapGesture {
                    print("Clicked \(roll.name)")
                }
                .padding(.trailing, 10.0)

            NavigationLink(destination: {
                EditorView(roll: roll)
            }) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(roll.name)
                            .font(.title)
                    }
                    if let latest = roll.latest {
                        Text(latest)
                            .font(.footnote)
                            .italic()
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var rolls: [Roll] = [
        Roll(name: "E 1"),
        Roll(name: "E 2"),
        Roll(name: "E 3", latest: "3 4 4 8"),
        Roll(name: "E 4"),
    ]

    var body: some View {
        NavigationView {
            List (rolls) { r in
                RowView(roll: r)
            }
            .navigationTitle("Rolls")
            .navigationBarItems(trailing: Button(action: {
                self.addItem()
            }) {
                Image(systemName: "plus")
            })
        }
    }

    private func addItem() {
        rolls.append(Roll(name: "New Roll"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
