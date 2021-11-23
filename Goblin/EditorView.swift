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
        List {
            Section(header: Text("Name")) {
                TextField("Title", text: $roll.name)
                    .font(.body.lowercaseSmallCaps())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }

            Section(header: Text("Script")) {
                // TODO: use onCommit to attempt to compile?
                TextEditor(text: $roll.script)
                    .font(.system(.body, design: .monospaced))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(height: 200)

                Button(action: {
                    print("compiling...")
                    roll.compile()
                }) {
                    Text("Compile")
                }
            }
        }
            Spacer()
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(roll: .constant(Roll(name: "Sample")))
    }
}
