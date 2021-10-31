//
//  RollRowView.swift
//  Goblin
//
//  Created by Matthew Burke on 10/31/21.
//

import SwiftUI

struct RollRowView: View {
    @Binding var roll: Roll

    var body: some View {
        HStack {
            Image(systemName: "die.face.6.fill")
                .foregroundColor(roll.compiled ? .red : .gray)
                .onTapGesture {
                    if roll.compiled {
                        print("Clicked \(roll.name)")
                    }
                }
                .padding(.trailing, 10.0)

            NavigationLink(destination: {
                EditorView(roll: $roll)
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

struct RollRowView_Previews: PreviewProvider {
    static var previews: some View {
        RollRowView(roll: .constant(Roll.starterRolls[0]))
    }
}
