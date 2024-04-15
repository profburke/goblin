//
//  LanguageExplainerView.swift
//  Goblin
//
//  Created by Matthew Burke on 2/2/22.
//

import SwiftUI

struct LanguageExplainerView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)

            Button("press to dismiss") {
                dismiss()
            }
            .padding()
            .background(Color.black)
        }
    }
}

struct LanguageExplainerView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageExplainerView()
    }
}
