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

    private var flagColor: Color {
        (roll.expression != nil) ? .green : .gray
    }

    var body: some View {
        VStack {
            List {
                Section(header: Text("Name")) {
                    TextField("Title", text: $roll.name)
                    // TODO: the following is supposed to work for both iOS
                    // and macOS
                        //.textInputAutocapitalization(.never)
                        .autocapitalization(.none)
                        .font(.body.lowercaseSmallCaps())
                        .disableAutocorrection(true)
                }

                Section(header: Text("Script")) {
                    HStack {
                        Image(systemName: "flag.fill")
                            .renderingMode(.template)
                            .foregroundColor(flagColor)

                        Button(action: {
                            roll.compile()
                        }) {
                            Text("Compile")
                        }
                        .buttonStyle(BorderedButtonStyle())

                        Spacer()

                        Button(action: {
                            showingSheet.toggle()
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }

                    // TODO: use onCommit to attempt to compile?
                    TextEditor(text: $roll.script)
                        .font(.system(.body, design: .monospaced))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 200)
                }
            }
            Spacer()
        }
        // .fullScreenCover(isPresented: $showingSheet) {
        // or
        .sheet(isPresented: $showingSheet) {
                     LanguageExplainerView()
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
