//
//  EditorView.swift
//  Goblin
//
//  Created by Matthew Burke on 10/30/21.
//

import SwiftUI

struct EditorView: View {
    @Binding var roll: Roll

    var body: some View {
        VStack {
            Text(roll.name)
                .font(.largeTitle)
            Spacer()
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(roll: .constant(Roll(name: "Sample")))
    }
}
