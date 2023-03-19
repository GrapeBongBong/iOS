//
//  ContentView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/19.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel: SignInViewModel
    @FocusState var focused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "tortoise.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.green, .orange)
                .frame(width: 160)
            
            VStack {
                TextField("아이디 입력", text: $viewModel.identification)
                    .font(.system(size: 20))
                    .focused($focused)
                    .onAppear { focused = true }
                Divider()
                    .frame(height: 1)
                    .background(focused ? .green : .gray)
            }
            
            VStack {
                SecureField("비밀번호 입력", text: $viewModel.password)
                    .font(.system(size: 20))
                Divider()
                    .frame(height: 1)
                    .background(!focused ? .green : .gray)
            }
            
            Button {
                viewModel.checkAccount()
            } label: {
                Text("로그인")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .background(.green)
            .cornerRadius(30)

            Spacer()
            
            HStack(spacing: 20) {
                Button {
                    print("회원가입")
                } label: {
                    Text("회원가입")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.green)
                }

                Button {
                    print("비밀번호 찾기")
                } label: {
                    Text("비밀번호 찾기")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
