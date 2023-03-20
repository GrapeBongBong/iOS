//
//  PublicSignUp.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct PublicSignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("닉네임")
                    .font(.system(size: 24, weight: .medium))
                TextField("",text: $viewModel.nickName)
                    .font(.system(size: 24))
                    .frame(height: 44)
                    .background(.gray.opacity(0.1))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("아이디")
                    .font(.system(size: 24, weight: .medium))
                TextField("",text: $viewModel.identifier)
                    .font(.system(size: 24))
                    .frame(height: 44)
                    .background(.gray.opacity(0.1))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("비밀번호")
                    .font(.system(size: 24, weight: .medium))
                SecureField("",text: $viewModel.password)
                    .font(.system(size: 24))
                    .frame(height: 44)
                    .background(.gray.opacity(0.1))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("비밀번호 확인")
                    .font(.system(size: 24, weight: .medium))
                SecureField("",text: $viewModel.confirmPassword)
                    .font(.system(size: 24))
                    .frame(height: 44)
                    .background(.gray.opacity(0.1))
            }
        }
    }
}

struct PublicSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        PublicSignUpView(viewModel: SignUpViewModel())
    }
}
