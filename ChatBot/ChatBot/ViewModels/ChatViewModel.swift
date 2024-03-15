//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import Foundation

enum ChatState {
    case idle
    case loading
    case loaded
}

class ChatDataShared: ObservableObject {
    static var instance = ChatDataShared()
    @Published var currentModel: [ChatModel]? = []
    @Published var historyModel: [ChatModel]? = []
    
    private init() {}
}

class ChatViewModel: ObservableObject {
    @Published var chatState: ChatState = .idle
    @Published var shared = ChatDataShared.instance
    @Published var isHistory: Bool = false

    private let networkService: NetworkLoader
    
    init(networkService: NetworkLoader = ChatNetworkService()) {
        self.networkService = networkService
    }
    
    func loadInitData() {
        chatState = .loading
        
        networkService.loadInitRequest { [weak self] result in
            if case let .success(data) = result {
                self?.handleNetworkResponse(data)
            }
        }
    }
    
    func loadHistory() {
        isHistory.toggle()
    }
    
    func buttonViewAction(_ id: String) {
        chatState = .loading
        
        // update history
        updateHistoryData()
        
        let payload = Payload(requestId: id)
        networkService.loadRequest(for: payload) { [weak self] result in
            if case let .success(data) = result {
                self?.handleNetworkResponse(data)
            }
        }
    }
    
    private func handleNetworkResponse(_ model: [ChatModel]) {
        chatState = .loaded
        shared.currentModel = model
    }
    
    func cardViewAction() {
        // this method will be called from ChatCardView like buttonViewAction called from CardButtonsView
        // and send network request
    }
    
    func tableViewAction() {
        // this method will be called from ChatTableView like buttonViewAction called from CardButtonsView
        // and send network request
    }
    
    func chatInputAction() {
        // this method will be called when user input the text in textfield like buttonViewAction called from CardButtonsView
        // and send network request
    }
    
    func closeChat() {
        // Do closing activities (informing backend to close the chat session)
    }
    
    // This method will update history model by coping the neccessary current model data into it
    private func updateHistoryData() {
        if let model = shared.currentModel {
            self.shared.historyModel?.append(contentsOf: model)
        }
        clearCurrentModel()
    }
    private func clearCurrentModel() {
        shared.currentModel?.removeAll()
    }
}


