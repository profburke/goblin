//
//  RollRow.swift
//  Goblin
//
//  Created by Matthew Burke on 10/31/21.
//

import SwiftUI

struct RollRow: View {
    @Binding var roll: Roll

    var body: some View {
        HStack {
            DieView(roll: $roll)

            NavigationLink(destination:
                EditorView(roll: $roll)
            ) {
                RollDataView(roll: roll)
            }
        }
    }
}

struct DieView: View {
    @Binding var roll: Roll

    var body: some View {
        Image(systemName: "die.face.6.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 28.0)
            .foregroundColor(roll.compiled ? .red : .gray)
            .onTapGesture {
                if roll.compiled {
                    roll.latest = roll.roll()
                    // TODO: NSPasteboard has a completely different interface
                    UIPasteboard.general.string = roll.latest
                }
            }
            .padding(.trailing, 10.0)

    }
}

struct RollDataView: View {
    let roll: Roll

    var body: some View {
        VStack(alignment: .leading) {
            Text(roll.name)
                .foregroundColor(.primary)
                .font(.callout)

            if let latest = roll.latest {
                Text(latest)
                    .foregroundColor(.primary)
                    .font(.system(.footnote, design: .monospaced))
                    .italic()
            }
        }
    }
}

let rowBackgroundColor = UIColor.systemBackground

struct RollRowView_Previews: PreviewProvider {
    static let roll = Roll(name: "Some Roll", script: "4d6", latest: "3 3 4 5")
    static let uncompiledRoll = Roll(name: "Won't Work", script: "2....4")

    static var previews: some View {
        RollRow(roll: .constant(roll))
            .padding()
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)

        RollRow(roll: .constant(uncompiledRoll))
            .padding()
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)

        RollRow(roll: .constant(roll))
            .padding()
            .previewLayout(.sizeThatFits)
            .background(Color(rowBackgroundColor))
            .colorScheme(.dark)
    }
}
