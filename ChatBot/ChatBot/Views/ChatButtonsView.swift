//
//  ChatButtonsView.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import SwiftUI

struct ChatButtonsView: View {
    let buttons: [ChatButtonData]
    let viewModel: ChatViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(buttons, id: \.self) { button in
                Button(action: {
                    viewModel.buttonViewAction(button.buttonID)
                }, label: {
                    Text("\(button.title)")
                })
            }
        }
    }
}

//#Preview {
//    ChatButtonsView()
//}
