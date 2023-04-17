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
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case identifier
        case password
    }
    
    let customTextFieldModifier = CustomTextFieldModifier()
    
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
                    CustomTextField<Field?>(title: "아이디 입력", text: $viewModel.identifier, focusState: $focusState, focusing: .identifier)
                        .submitLabel(.next)
                    
                    CustomSecureField<Field?>(title: "비밀번호 입력", text: $viewModel.password, focusState: $focusState, focusing: .password)
                        .submitLabel(.done)
                } // VStack
                .onSubmit {
                    switch(focusState) {
                    case .identifier:
                        focusState = .password
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
                        .modifier(CustomButtonTextModifier())
                }
                .background(.mainColor)
                .clipShape(Capsule())
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        isSignUp = true
                    } label: {
                        Text("회원가입")
                            .font(.customBody3)
                            .foregroundColor(.mainColor)
                    }
                    
                    Button {
                        print("비밀번호 찾기")
                    } label: {
                        Text("비밀번호 찾기")
                            .font(.customBody3)
                            .foregroundColor(.subColor)
                    }
                } // HStack
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
