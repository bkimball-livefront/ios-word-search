//
//  ContentView.swift
//  Word Search
//
//  Created by Benjamin Kimball on 8/20/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isSignedIn = false

    var body: some View {
        if isSignedIn {
            GameView()
        } else {
            LoginView(onSignedIn: { isSignedIn = true })
        }
    }
}

#Preview {
    ContentView()
}
