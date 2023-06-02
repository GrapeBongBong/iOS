//
//  Categories.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/22.
//

import Foundation

enum TalentCategory: String, CaseIterable, Codable {
    case it = "IT"
    case fitness = "운동"
    case languageStudy = "어학"
    case music = "음악"
    case art = "예술"
    case etc = "기타"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        if let talentCategory = TalentCategory(rawValue: rawString) {
            self = talentCategory
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Talent Category에 해당 케이스가 없습니다.")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case it = "IT"
        case fitness = "운동"
        case languageStudy = "어학"
        case music = "음악"
        case art = "예술"
        case etc = "기타"
    }
}

enum SearchCategory: String, CaseIterable, Encodable {
    case all = "All"
    case it = "IT"
    case fitness = "운동"
    case languageStudy = "어학"
    case music = "음악"
    case art = "예술"
    case etc = "기타"
    
    enum CodingKeys: String, CodingKey {
        case all = "All"
        case it = "IT"
        case fitness = "운동"
        case languageStudy = "어학"
        case music = "음악"
        case etc = "기타"
    }
}
