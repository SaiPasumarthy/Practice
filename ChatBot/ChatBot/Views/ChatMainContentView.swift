//
//  ChatMainContentView.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import SwiftUI

struct ChatMainContentView: View {
    @ObservedObject var viewModel: ChatViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if viewModel.isHistory {
                    loadHistoryView()
                    Divider()
                    loadCurrentView()
                } else {
                    loadCurrentView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func loadHistoryView() -> some View {
        ForEach(viewModel.shared.historyModel ?? [], id: \.self) { model in
            ForEach(model.messages, id: \.self) { message in
                Text(message.message)
                    .padding()
                    .padding(.bottom, 24)
                loadData(message)
            }
        }
    }
    
    @ViewBuilder
    private func loadCurrentView() -> some View {
        ForEach(viewModel.shared.currentModel ?? [], id: \.self) { model in
            ForEach(model.messages, id: \.self) { message in
                Text(message.message)
                    .padding()
                    .padding(.bottom, 24)
                loadData(message)
            }
        }
    }
    
    @ViewBuilder
    private func loadData(_ message: ChatMessage) -> some View {
        ForEach(message.data, id: \.self) { data in
            loadTemplateData(data)
                .padding()
        }
    }
    
    @ViewBuilder
    private func loadTemplateData(_ data: ChatTemplateData) -> some View {
        switch data.templateType {
        case .buttons:
            ChatButtonsView(buttons: data.buttons ?? [], viewModel: viewModel)
        case .card:
            ChatCardView(cards: data.cards ?? [], viewModel: viewModel)
        case .table:
            ChatTableView(tables: data.tables ?? [], viewModel: viewModel)
        case .unknown, .none:
            EmptyView()
        }
    }
}

//#Preview {
//    ChatMainContentView()
//}
