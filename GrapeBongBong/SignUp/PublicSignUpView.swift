//
//  PublicSignUp.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct PublicSignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    let customTextFieldModifier: CustomTextFieldModifier
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("닉네임")
                    .font(.customHeadline)
                TextField("",text: $viewModel.nickName)
                    .modifier(customTextFieldModifier)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("아이디")
                    .font(.customHeadline)
                TextField("",text: $viewModel.identifier)
                    .modifier(customTextFieldModifier)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("비밀번호")
                        .font(.customHeadline)
                    
                    Text($viewModel.pwCautionMessage.wrappedValue)
                        .foregroundColor(.red)
                }
                SecureField("",text: $viewModel.password)
                    .modifier(customTextFieldModifier)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("비밀번호 확인")
                        .font(.customHeadline)
                    
                    Text($viewModel.cpwCautionMessage.wrappedValue)
                        .foregroundColor(.red)
                }
                SecureField("",text: $viewModel.confirmPassword)
                    .modifier(customTextFieldModifier)
            }
        }
    }
}

struct PublicSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        PublicSignUpView(viewModel: SignUpViewModel(), customTextFieldModifier: CustomTextFieldModifier())
    }
}
