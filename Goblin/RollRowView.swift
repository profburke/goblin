//
//  RollRowView.swift
//  Goblin
//
//  Created by Matthew Burke on 10/31/21.
//

import SwiftUI

// Current Brick Wall:
// can click on one of the enabled rolls and have it
// update its "latest" property, once. Subsequent clicks
// have no effect.
//
// Clicking on any other roll has no effect either.

struct RollRowView: View {
    @Binding var roll: Roll

    var body: some View {
        HStack {
            Image(systemName: "die.face.6.fill")
                .foregroundColor(roll.compiled ? .red : .gray)
                .onTapGesture {
                    if roll.compiled {
                        roll.latest = roll.roll()
                    }
                }
                .padding(.trailing, 10.0)

            NavigationLink(destination: {
                EditorView(roll: $roll)
            }) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(roll.name)
                            .font(.callout)
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

// Merging these back into the above until I get the binding
// issues sorted.

//struct DieView: View {
//    @Binding var roll: Roll
//
//    var body: some View {
//        Image(systemName: "die.face.6.fill")
//            .foregroundColor(roll.compiled ? .red : .gray)
//            .onTapGesture {
//                if roll.compiled {
//                    roll.latest = roll.roll()
//                }
//            }
//            .padding(.trailing, 10.0)
//
//    }
//}

//struct RollDataView: View {
//    let roll: Roll
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text(roll.name)
//                    .font(.callout)
//            }
//            if let latest = roll.latest {
//                Text(latest)
//                    .font(.footnote)
//                    .italic()
//            }
//        }
//    }
//}

struct RollRowView_Previews: PreviewProvider {
    static let roll = Roll(name: "Some Roll", script: nil, latest: "3 3 4 5")

    static var previews: some View {
        RollRowView(roll: .constant(roll))
    }
}
