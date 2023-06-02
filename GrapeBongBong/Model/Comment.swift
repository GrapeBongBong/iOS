//
//  Comment.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/09.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: Int
    let postID: Int
    var content: String
//    let date: Date
    let date: String
    
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "commentId"
        case postID = "postId"
        case content
        case date
        case userID = "userId"
    }
}

extension Comment {
//    static var mock: Comment { Comment(id: 1, postID: 1, content: "dmdkdkdkdk", date: Date(), userID: 100000) }
    static var mock: Comment { Comment(id: 1, postID: 1, content: "dmdkdkdkdk", date: "123", userID: 100000) }
//    static var mocks: [Comment] {
//        [
//            Comment(id: 1, postID: 1, content: "dmdkdkdkdk1", date: Date(), userID: 100000),
//            Comment(id: 2, postID: 1, content: "dmdkdkdkdk2", date: Date(), userID: 100000),
//            Comment(id: 3, postID: 1, content: "dmdkdkdkdk3", date: Date(), userID: 100000),
//            Comment(id: 4, postID: 1, content: "dmdkdkdkdk4", date: Date(), userID: 100000),
//            Comment(id: 5, postID: 1, content: "dmdkdkdkdk5", date: Date(), userID: 100000),
//            Comment(id: 6, postID: 1, content: "dmdkdkdkdk6", date: Date(), userID: 100000)
//        ]
//    }
    static var mocks: [Comment] {
        [
            Comment(id: 1, postID: 1, content: "dmdkdkdkdk1", date: "123", userID: 100000),
            Comment(id: 2, postID: 1, content: "dmdkdkdkdk2", date: "123", userID: 100000),
            Comment(id: 3, postID: 1, content: "dmdkdkdkdk3", date: "123", userID: 100000),
            Comment(id: 4, postID: 1, content: "dmdkdkdkdk4", date: "123", userID: 100000),
            Comment(id: 5, postID: 1, content: "dmdkdkdkdk5", date: "123", userID: 100000),
            Comment(id: 6, postID: 1, content: "dmdkdkdkdk6", date: "123", userID: 100000)
        ]
    }
}
