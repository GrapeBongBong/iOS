//
//  CustomTextField.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/16.
//

import SwiftUI

struct CustomInputField<T: Hashable>: View {
    let modifier = CustomTextFieldModifier()
    
    var placeHolder: String
    var text: Binding<String>
    
    var focusState: FocusState<T>.Binding
    var focusing: T
    
    let isSecure: Bool
    var submitLabel: SubmitLabel = .go
    
    var body: some View {
        VStack {
            if !isSecure {
                TextField(placeHolder, text: text)
                    .modifier(modifier)
                    .focused(focusState, equals: focusing)
                    .submitLabel(submitLabel)
            } else {
                SecureField(placeHolder, text: text)
                    .modifier(modifier)
                    .focused(focusState, equals: focusing)
                    .submitLabel(submitLabel)
            }
            Divider()
                .frame(height: 1)
                .background(focusState.wrappedValue == focusing ? .green : .gray)
        }
    }
}
