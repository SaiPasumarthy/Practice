//
//  ChatView.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @Binding var showChat: Bool
    @State var textInput: String = ""
    var body: some View {
        VStack {
            ChatHeaderView(viewModel: viewModel) {
                showChat = false
            }
            Spacer()
            if viewModel.chatState == .loading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ChatMainContentView(viewModel: viewModel)
            }
            Spacer()
            TextField("Type here", text: $textInput)
                .border(Color.black)
                .padding()
        }
        .onAppear(perform: {
            viewModel.loadInitData()
        })
    }
}

struct ChatHeaderView: View {
    let viewModel: ChatViewModel
    let callback: () -> Void
    var body: some View {
        HStack {
            Button(action: {
                viewModel.loadHistory()
            }, label: {
                Text("History")
                    .foregroundColor(.black)
            })
            Spacer()
            Text("Chat View")
                .font(.title3.bold())
            Spacer()
            Button(action: callback, label: {
                Image(systemName: "xmark")
            })
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

#Preview {
    ChatView(showChat: .constant(true))
}
