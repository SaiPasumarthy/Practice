//
//  ContentView.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showChat: Bool = false
    var body: some View {
        Button {
            showChat = true
        } label: {
            Text("Enter Chat")
        }
        .fullScreenCover(isPresented: $showChat) {
            ChatView(showChat: $showChat)
        }
    }
}

#Preview {
    ContentView()
}
