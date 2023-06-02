//
//  Color+Extensions.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/16.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var mainColor: Color {
        return .green
    }
    
    static var subColor: Color {
        return .gray
    }
    
    static var labelColor: Color {
        return Color(uiColor: .label)
    }
}
