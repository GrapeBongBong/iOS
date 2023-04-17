//
//  CustomButtomTextModifier.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/16.
//

import SwiftUI

struct CustomButtonTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.customHeadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
    }
}
