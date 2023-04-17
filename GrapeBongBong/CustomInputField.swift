//
//  CustomTextField.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/16.
//

import SwiftUI

struct CustomTextField<T: Hashable>: View {
    let modifier = CustomTextFieldModifier()
    
    var title: String
    var text: Binding<String>
    
    var focusState: FocusState<T>.Binding
    var focusing: T
    
    var submitLabel: SubmitLabel = .next
    
    var body: some View {
        VStack {
            TextField(title, text: text)
                .modifier(modifier)
                .focused(focusState, equals: focusing)
                .submitLabel(submitLabel)
            Divider()
                .frame(height: 1)
                .background(focusState.wrappedValue == focusing ? .green : .gray)
        }
    }
}

struct CustomSecureField<T: Hashable>: View {
    let modifier = CustomTextFieldModifier()
    
    var title: String
    var text: Binding<String>
    
    var focusState: FocusState<T>.Binding
    var focusing: T
    
    var submitLabel: SubmitLabel = .done
    
    var body: some View {
        VStack {
            SecureField(title, text: text)
                .modifier(modifier)
                .focused(focusState, equals: focusing)
                .submitLabel(submitLabel)
            Divider()
                .frame(height: 1)
                .background(focusState.wrappedValue == focusing ? .green : .gray)
        }
    }
}

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField<SignUpEnum>(
//            title: "아이디 입력",
//            text: .constant(SignInViewModel().identification),
//            focusState: ,
//            focusing: .identifier
//        )
//    }
//}
