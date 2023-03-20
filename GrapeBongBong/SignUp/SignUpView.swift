//
//  SignUpView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel:  SignUpViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    InputStringView(infoString: "이름", bindString: $viewModel.identifier)
                    
                    HStack {
                        Text("생년월일")
                            .font(.system(size: 20, weight: .medium))
                        
                        DatePicker("", selection: $viewModel.birthday, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                    
                    InputStringView(infoString: "본인 확인  이메일", bindString: $viewModel.email)
                    
                    InputStringView(infoString: "전화번호", bindString: $viewModel.phoneCall)
                    
                    Spacer()
                    
                    InputStringView(infoString: "닉네임", bindString: $viewModel.nickName)
                    
                    InputStringView(infoString: "아이디", bindString: $viewModel.identifier)
                    
                    InputStringView(infoString: "비밀번호", bindString: $viewModel.identifier)
                    
                    InputStringView(infoString: "비밀번호 재확인", bindString: $viewModel.identifier)
                    
                    NavigationLink {
                        SignInView(viewModel: SignInViewModel())
                    } label: {
                        Text("회원가입")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                    }
                    .background(.green)
                    .clipShape(Capsule())
                }
                .padding()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}
