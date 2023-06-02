//
//  Post.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/30.
//

import Foundation

final class Post: Identifiable, Codable, ObservableObject {
    let id: Int
    var title, content: String
    var date: Date
    var images: [PostImage]
    var writerNick, writerID: String
    var writerImageURL: String?
    var postType: String
    var likeCount: Int
    var giveCate: TalentCategory
    var giveTalent: String
    var takeCate: TalentCategory
    var takeTalent: String
    var availableTime: AvailableTime
    let uid: Int
    var status: Bool
    var liked: Bool
    var temperature: Double
    
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
        case giveCate, giveTalent, takeCate, takeTalent, availableTime
        case uid
        case status
        case liked
        case temperature
    }
    
    init(id: Int, title: String, content: String, date: Date, images: [PostImage], writerNick: String, writerID: String, writerImageURL: String?, postType: String, likeCount: Int, giveCate: TalentCategory, giveTalent: String, takeCate: TalentCategory, takeTalent: String, availableTime: AvailableTime, uid: Int, status: Bool, liked: Bool, temperature: Double) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.images = images
        self.writerNick = writerNick
        self.writerID = writerID
        self.postType = postType
        self.giveCate = giveCate
        self.giveTalent = giveTalent
        self.takeCate = takeCate
        self.takeTalent = takeTalent
        self.availableTime = availableTime
        self.uid = uid
        self.status = status
        self.likeCount = likeCount
        self.writerImageURL = writerImageURL
        self.liked = liked
        self.temperature = temperature
    }
}

extension Post {
    static let mock = Post(id: 1, title: "더미더미 제목제목", content: "더미더미\n더미더미\n본문본문", date: Date(), images: [PostImage](), writerNick: "더미 닉네임", writerID: "dummy ID", writerImageURL: nil, postType: "T", likeCount: 0, giveCate: .it, giveTalent: "더미 주는 재능", takeCate: .fitness, takeTalent: "더미 받는 재능", availableTime: AvailableTime(days: [.fri], timezone: .dawn), uid: 100001, status: false, liked: false, temperature: 37.0)
}

struct PostImage: Codable, Identifiable {
    let id: Int
    let fileURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fileURL = "fileUrl"
    }
}
