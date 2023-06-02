//
//  Date+Extensions.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/04.
//

import Foundation

extension Date {
    func formatted(_ format: String) -> String {
        let myFormat = Date.FormatStyle().locale(Locale(identifier: "ko-KR"))
        switch format {
        case "MM-dd":
            return self.formatted(myFormat.month().day())
        case "yyyy-MM-dd":
            return self.formatted(myFormat.year().month().day())
        default:
            return self.formatted()
        }
    }
}
