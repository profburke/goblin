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
        List {
            Section(header: Text("Name")) {
                TextField("Title", text: $roll.name)
                    .font(.title)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }

            Section(header: Text("Script")) {
                // TODO: use onCommit to attempt to compile?
                // TODO: use a monospaced font?
                TextEditor(text: $roll.script)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button(action: {
                    print("compiling...")
                    roll.compile()
                }) {
                    Text("Compile")
                }
            }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(roll: .constant(Roll(name: "Sample")))
    }
}
