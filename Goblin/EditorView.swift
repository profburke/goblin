//
//  EditorView.swift
//  Goblin
//
//  Created by Matthew Burke on 10/30/21.
//

import SwiftUI

enum CompileState {
    case compiled   // last compile succeeded
    case error      // last compile failed
    case dirty      // script changed since last compile (or never compiled)
}

struct EditorView: View {
    @State private var showingSheet = false
    @Binding var roll: Roll

    @State private var compileState: CompileState = .dirty
    @State private var lastCompiledScript: String = ""
    @State private var originalScript: String = ""
    @State private var showBackAlert = false

    @Environment(\.dismiss) private var dismiss

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
        .navigationBarBackButtonHidden(compileState == .dirty)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if compileState == .dirty {
                    Button {
                        showBackAlert = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
            }
        }
        .alert("Uncompiled Changes", isPresented: $showBackAlert) {
            Button("Compile") {
                let result = roll.compile()
                switch result {
                case .success:
                    compileState = .compiled
                case .failure:
                    compileState = .error
                }
                lastCompiledScript = roll.script
                dismiss()
            }
            Button("Discard") {
                roll.script = originalScript
                roll.compile()
                dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("Your script has changes that haven't been compiled.")
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

    private var stateIcon: some View {
        switch compileState {
        case .compiled:
            return Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.blue)
        case .error:
            return Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
        case .dirty:
            return Image(systemName: "flag.fill")
                .foregroundColor(.gray)
        }
    }

    private var controlPanel: some View {
        HStack {
            stateIcon

            Button(action: {
                let result = roll.compile()
                switch result {
                case .success:
                    compileState = .compiled
                case .failure:
                    compileState = .error
                }
                lastCompiledScript = roll.script
            }) {
                Text("Compile")
            }
            .buttonStyle(BorderedButtonStyle())
            .disabled(compileState != .dirty)

            Spacer()

            Button(action: {
                showingSheet.toggle()
            }) {
                Image(systemName: "questionmark.circle.fill")
            }
            .buttonStyle(BorderedButtonStyle())
        }
        .onAppear {
            originalScript = roll.script
            lastCompiledScript = roll.script
            compileState = roll.expression != nil ? .compiled : .dirty
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
                    let trimmedNew = roll.script.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedOld = lastCompiledScript.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmedNew != trimmedOld {
                        compileState = .dirty
                    }
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
