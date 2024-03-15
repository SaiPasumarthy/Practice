//
//  ChatCardView.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import SwiftUI

struct ChatCardView: View {
    let cards: [ChatCardData]
    let viewModel: ChatViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(cards, id: \.self) { card in
                Text("**** \(card.title) ****")
                    .frame(height: 100)
                    .border(Color.black)
            }
        }
    }
}

//#Preview {
//    ChatCardView()
//}
