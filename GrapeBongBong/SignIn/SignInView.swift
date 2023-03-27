//
//  ContentView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/19.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel: SignInViewModel
    
    @State var isSignUp = false
    @State var signInSuccess = false
    @State var signInFailed = false
    
    @FocusState var focusedField: Field?
    enum Field {
        case identifier
        case password
    }
    
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
                    VStack {
                        TextField("아이디 입력", text: $viewModel.identification)
                            .tint(.green)
                            .font(.customBody1)
                            .focused($focusedField, equals: .identifier)
                            .textInputAutocapitalization(.never)
                            .submitLabel(.next)
                            .autocorrectionDisabled()
                        Divider()
                            .frame(height: 1)
                            .background(focusedField == .identifier ? .green : .gray)
                    }
                    
                    VStack {
                        SecureField("비밀번호 입력", text: $viewModel.password)
                            .tint(.green)
                            .font(.customBody1)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.done)
                        Divider()
                            .frame(height: 1)
                            .background(focusedField == .password ? .green : .gray)
                    }
                } // VStack
                .onSubmit {
                    switch(focusedField) {
                    case .identifier:
                        focusedField = .password
                    default:
                        signInSuccess = viewModel.checkAccount()
                        signInFailed = !signInSuccess
                    }
                }
                
                Button {
                    signInSuccess = viewModel.checkAccount()
                    if !signInSuccess {
                        signInFailed = true
                    }
                } label: {
                    Text("로그인")
                        .font(.customHeadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                .background(.green)
                .clipShape(Capsule())
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        isSignUp = true
                    } label: {
                        Text("회원가입")
                            .font(.customBody3)
                            .foregroundColor(.green)
                    }
                    
                    Button {
                        print("비밀번호 찾기")
                    } label: {
                        Text("비밀번호 찾기")
                            .font(.customBody3)
                            .foregroundColor(.gray)
                    }
                }
                .navigationDestination(isPresented: $signInSuccess) {
                    Tabbar()
                }
                .navigationDestination(isPresented: $isSignUp) {
                    SignUpView(viewModel: SignUpViewModel())
                }
            } // VStack
            .padding()
            .alert(isPresented: $signInFailed) {
                Alert(
                    title: Text("로그인 실패"),
                    message: Text("아이디 또는 비밀번호를 다시 한번 확인해주세요."),
                    dismissButton: .default(Text("닫기"))
                )
            }
            .navigationTitle(Text("로그인"))
            .toolbar(.hidden)
        } //NavigationStack
    } // body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
