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
            DieView(roll: $roll)

            NavigationLink(destination: {
                EditorView(roll: $roll)
            }) {
                RollDataView(roll: roll)
            }
        }
    }
}

struct DieView: View {
    @Binding var roll: Roll

    var body: some View {
        Image(systemName: "die.face.6.fill")
        // https://stackoverflow.com/questions/56505692/how-to-resize-image-with-swiftui
        // .resizable().aspectRatio(contentMode: ContentMode.fit).scaledToFit()
        // https://sarunw.com/posts/how-to-resize-swiftui-image-and-keep-aspect-ratio/
            .foregroundColor(roll.compiled ? .red : .gray)
            .onTapGesture {
                if roll.compiled {
                    roll.latest = roll.roll()
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
                .font(.callout)

            if let latest = roll.latest {
                Text(latest)
                    .font(.system(.footnote, design: .monospaced))
                    .italic()
            }
        }
    }
}

struct RollRowView_Previews: PreviewProvider {
    static let roll = Roll(name: "Some Roll", script: "4d6", latest: "3 3 4 5")

    static var previews: some View {
        RollRowView(roll: .constant(roll))
    }
}
