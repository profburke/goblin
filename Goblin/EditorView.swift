//
//  EditorView.swift
//  Goblin
//
//  Created by Matthew Burke on 10/30/21.
//

import SwiftUI

struct EditorView: View {
    @State private var showingSheet = false
    @Binding var roll: Roll

    var body: some View {
        VStack {
            List {
                header
                editorPanel
            }

            Spacer()
        }
        .sheet(isPresented: $showingSheet) {
            LanguageExplainerView()
        }
    }

    private var header: some View {
        Section(header: Text("Name")) {
            TextField("Title", text: $roll.name)
            // TODO: `textInputAutocapitalization` is supposed to work
            //       for both iOS and macOS
            //.textInputAutocapitalization(.never)
                .autocapitalization(.none)
                .font(.body.lowercaseSmallCaps())
                .disableAutocorrection(true)
        }
    }

    private var flagColor: Color {
        (roll.expression != nil) ? .green : .gray
    }

    @State private var compiled = true

    private var controlPanel: some View {
        HStack {
            Image(systemName: "flag.fill")
                .renderingMode(.template)
                .foregroundColor(flagColor)

            Button(action: {
                roll.compile()
                compiled = true
            }) {
                Text("Compile")
            }
            .buttonStyle(BorderedButtonStyle())
            .disabled(compiled)

            Spacer()

            Button(action: {
                showingSheet.toggle()
            }) {
                Image(systemName: "questionmark.circle.fill")
            }
            .buttonStyle(BorderedButtonStyle())
        }
        .onAppear() {
            compiled = roll.expression != nil
        }
    }

    private var editorPanel: some View {
        Section(header: Text("Script")) {
            controlPanel

            // TODO: use onCommit to attempt to compile?
            TextEditor(text: $roll.script)
                .font(.system(.body, design: .monospaced))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(height: 200)
                .onChange(of: roll.script) {
                    compiled = false
                }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(roll: .constant(Roll(name: "Sample")))
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)

        EditorView(roll: .constant(Roll(name: "Sample")))
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}
