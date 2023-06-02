//
//  chatMessages.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/17.
//

import Foundation

struct ChatMessage: Codable {
    let roomID: Int
    let senderID: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case senderID = "senderId"
        case message
    }
}

struct ChatMessageResponse: Decodable, Identifiable {
    let id: Int
    let roomID: Int
    let senderID: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case id = "chatMessageId"
        case roomID = "roomId"
        case senderID = "senderId"
        case message
    }
}
