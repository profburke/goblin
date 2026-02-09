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

            NavigationLink(value: roll.id) {
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
            .foregroundColor(roll.compiled ? .purple : .gray)
            .onTapGesture {
                if roll.compiled {
                    roll.latest = roll.roll()
                    // NOTE: NSPasteboard has a completely different interface
                    UIPasteboard.general.string = roll.latest
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
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

#Preview("Compiled — Light", traits: .sizeThatFitsLayout) {
    RollRow(roll: .constant(Roll(name: "Some Roll", script: "4d6", latest: "3 3 4 5")))
        .padding()
        .colorScheme(.light)
}

#Preview("Uncompiled — Light", traits: .sizeThatFitsLayout) {
    RollRow(roll: .constant(Roll(name: "Won't Work", script: "2....4")))
        .padding()
        .colorScheme(.light)
}

#Preview("Compiled — Dark", traits: .sizeThatFitsLayout) {
    RollRow(roll: .constant(Roll(name: "Some Roll", script: "4d6", latest: "3 3 4 5")))
        .padding()
        .background(Color(UIColor.systemBackground))
        .colorScheme(.dark)
}
