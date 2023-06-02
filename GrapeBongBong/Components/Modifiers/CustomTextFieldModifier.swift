//
//  CustomTextFieldModifier.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/25.
//

import SwiftUI

struct CustomTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.customBody1)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .tint(.green)
    }
}
