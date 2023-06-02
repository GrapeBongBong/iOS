//
//  CommuPost.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import Foundation

struct CommuPost: Codable, Identifiable {
    var id: Int
    var title: String
    var content: String
    var date: Date
    var images: [PostImage]
    let writerNick, writerID: String
    let writerImageURL: String?
    var postType: String
    var likeCount: Int
    let uid: Int
    var liked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "pid"
        case title, content
        case date
        case images
        case writerNick
        case writerID = "writerId"
        case writerImageURL
        case postType
        case likeCount
        case uid
        case liked
    }
}

extension CommuPost {
    static let mock = CommuPost(id: 123, title: "test제목", content: "테스트 본문", date: Date(), images: [], writerNick: "test", writerID: "test", writerImageURL: nil,  postType: "A", likeCount: 0, uid: 100001, liked: false)
}
