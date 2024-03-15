//
//  ChatNetworkService.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 15/03/24.
//

import Foundation

enum ChatError: Error {
    case parseError
}

// In real, this body data which will go in POST request
struct Payload {
    let requestId: String
}
protocol NetworkLoader {
    func loadInitRequest(completion: @escaping (Result<[ChatModel], Error>) -> Void)
    func loadRequest(for payload: Payload, completion: @escaping (Result<[ChatModel], Error>) -> Void)
}

class ChatNetworkService: NetworkLoader {
    func loadInitRequest(completion: @escaping (Result<[ChatModel], Error>) -> Void) {
        // Simulating network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let result = self?.loadHomeResponse() else {
                completion(.failure(ChatError.parseError))
                return
            }
            
            completion(.success(result))
        }
    }
    
    func loadRequest(for payload: Payload, completion: @escaping (Result<[ChatModel], Error>) -> Void) {
        // Simulating network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let result = self?.loadServerResponse(payload.requestId) else {
                completion(.failure(ChatError.parseError))
                return
            }
            
            completion(.success(result))
        }
    }
    
    private func loadServerResponse(_ id: String) -> [ChatModel] {
        if id == "card" {
            return loadCardResponse()
        } else if id == "table" {
            return loadTableResponse()
        } else if id == "home" {
            return loadHomeResponse()
        } else if id == "error" {
            return loadErrorResponse()
        }
        return []
    }
}

// These responses will be decoded from the backend json itself
// Added for demo purpose
extension ChatNetworkService {
    private func loadHomeResponse() -> [ChatModel] {
        return [
            ChatModel(
                messages: [
                    ChatMessage(
                        message: "This is initial load",
                        data: [ChatTemplateData(
                            templateType: .buttons,
                            buttons: [
                                ChatButtonData(title: "Load Card Data" , buttonID: "card"),
                                ChatButtonData(title: "Load Table Data", buttonID: "table"),
                                ChatButtonData(title: "Simulate Error", buttonID: "error")
                            ])])])]
    }
    
    private func loadCardResponse() -> [ChatModel] {
        return [
            ChatModel(
                messages: [
                    ChatMessage(
                        message: "This is card template",
                        data: [
                            ChatTemplateData(
                                templateType: .card,
                                cards: [
                                    ChatCardData(title: "Card 1"),
                                    ChatCardData(title: "Card 2"),
                                    ChatCardData(title: "Card 3"),
                                    ChatCardData(title: "Card 4")
                                ]),
                            ChatTemplateData(
                                templateType: .buttons,
                                buttons: [
                                    ChatButtonData(title: "Go Home" , buttonID: "home")
                                ])
                        ])])]
    }
    
    private func loadTableResponse() -> [ChatModel] {
        return [
            ChatModel(
                messages: [
                    ChatMessage(
                        message: "This is table template",
                        data:[
                            ChatTemplateData(
                                templateType: .table,
                                tables: [
                                    ChatTableData(title: "Table 1 title", subtitle: "Table 1 subtitle"),
                                    ChatTableData(title: "Table 2 title", subtitle: "Table 2 subtitle"),
                                    ChatTableData(title: "Table 3 title", subtitle: "Table 3 subtitle"),
                                    ChatTableData(title: "Table 4 title", subtitle: "Table 4 subtitle")
                                ]),
                            ChatTemplateData(
                                templateType: .buttons,
                                buttons: [
                                    ChatButtonData(title: "Go Home" , buttonID: "home")
                                ])
                        ])])]
    }
    
    private func loadErrorResponse() -> [ChatModel] {
        return [
            ChatModel(
                messages: [
                    ChatMessage(
                        message: "There is a network issue. I cannot process your request right now.\n\nPlease try again later.",
                        data: [ChatTemplateData()])])]
    }
}
