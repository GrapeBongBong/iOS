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
    
    @State var isSignIn = false
    @State var isFailed = false
    
    var body: some View {
        NavigationStack {
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
                        .tint(.green)
                        .font(.system(size: 20))
                        .focused($focused)
                        .onAppear { focused = true }
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    Divider()
                        .frame(height: 1)
                        .background(focused ? .green : .gray)
                }
                
                VStack {
                    SecureField("비밀번호 입력", text: $viewModel.password)
                        .tint(.green)
                        .font(.system(size: 20))
                    Divider()
                        .frame(height: 1)
                        .background(!focused ? .green : .gray)
                }
                
                Button {
                    isSignIn = viewModel.checkAccount()
                    if !isSignIn {
                        isFailed = true
                    }
                } label: {
                    Text("로그인")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                .background(.green)
                .clipShape(Capsule())

                
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
                .navigationDestination(isPresented: $isSignIn) {
                    Tabbar()
                }
            }
            .padding()
            .alert(isPresented: $isFailed) {
                Alert(
                    title: Text("로그인 실패"),
                    message: Text("아이디 또는 비밀번호를 다시 한번 확인해주세요."),
                    dismissButton: .default(Text("닫기"))
                )
            }
        }
        .toolbar(.hidden)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
