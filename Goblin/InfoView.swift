//
//  InfoView.swift
//  Goblin
//
//  Created by Matthew Burke on 2/8/26.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Header

                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "dice.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)

                        Text("Goblin")
                            .font(.title.bold())

                        Text("Roll any dice your table demands")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }

                // MARK: - Tip

                Section {
                    Button {
                        // TODO: Implement tip jar
                    } label: {
                        Label("Leave a Tip", systemImage: "heart.fill")
                            .foregroundColor(.pink)
                    }
                }

                // MARK: - Support

                Section("Support") {
                    Button {
                        openURL(URL(string: "mailto:support@bluedino.net?subject=Goblin:%20Report%20bug")!)
                    } label: {
                        Label("Report a Bug", systemImage: "ladybug.fill")
                    }

                    Button {
                        openURL(URL(string: "mailto:support@bluedino.net?subject=Goblin:%20Feature%20request")!)
                    } label: {
                        Label("Suggest a Feature", systemImage: "lightbulb.fill")
                    }

                    Button {
                        // TODO: App Store rating link
                    } label: {
                        Label("Rate on the App Store", systemImage: "star.fill")
                    }

                    Button {
                        // TODO: App Store review link
                    } label: {
                        Label("Review on the App Store", systemImage: "square.and.pencil")
                    }
                }

                // MARK: - About

                Section("About") {
                    Text("Goblin is a dice-rolling utility for tabletop gamers. Write scripts in the Troll dice language to describe any roll your game demands — from a simple d20 to complex multi-step procedures with conditionals and loops. Tap the die to roll, and the result is copied to your clipboard, ready to paste wherever you need it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // MARK: - Legal

                Section("Legal") {
                    Link(destination: URL(string: "https://bluedino.net/watchlife/privacy-policy.html")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .colorScheme(.dark)

        InfoView()
            .colorScheme(.light)
    }
}
