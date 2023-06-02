//
//  ChatRoom.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/15.
//

import Foundation

struct ChatRoom: Decodable, Identifiable {
    let postWriterUID: Int
    let pid: Int
    let id: Int
    let roomName: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case postWriterUID
        case pid
        case id = "roomId"
        case roomName
        case date
    }
}
