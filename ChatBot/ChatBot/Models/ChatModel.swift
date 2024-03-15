//
//  ChatModel.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import Foundation

protocol ChatModelCodable: Codable, Hashable { }

struct ChatModel: ChatModelCodable {
    let messages: [ChatMessage]
}

struct ChatMessage: ChatModelCodable {
    let message: String
    let data: [ChatTemplateData]
}

enum TemplateType: String, ChatModelCodable {
    case buttons
    case card
    case table
    case unknown
}

struct ChatTemplateData: ChatModelCodable {
    var templateType: TemplateType?
    var buttons: [ChatButtonData]?
    var cards: [ChatCardData]?
    var tables: [ChatTableData]?
}

struct ChatButtonData: ChatModelCodable {
    let title: String
    // added this id for demo but in real this id and some other button data
    // will be sent to backend to identify by the backend to give respective response
    let buttonID: String
}

struct ChatCardData: ChatModelCodable {
    let title: String
}

struct ChatTableData: ChatModelCodable {
    let title: String
    let subtitle: String
}
