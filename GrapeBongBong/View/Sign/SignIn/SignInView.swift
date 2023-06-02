//
//  ContentView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/19.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewModel()
    @State var isSignUp = false
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case identifier
        case password
    }
    
    let customTextFieldModifier = CustomTextFieldModifier()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                Spacer()
                
                Image(systemName: "tortoise.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.green, .orange)
                    .frame(width: 160)
                
                VStack(spacing: 20) {
                    CustomInputField<Field?>(placeHolder: "아이디 입력", text: $viewModel.identifier, focusState: $focusState, focusing: .identifier, isSecure: false)
                        .keyboardType(.alphabet)
                        .submitLabel(.next)
                    
                    CustomInputField<Field?>(placeHolder: "비밀번호 입력", text: $viewModel.password, focusState: $focusState, focusing: .password, isSecure: true)
                        .submitLabel(.done)
                }
                
                Spacer()
                    .frame(height: 20)
                
                VStack(spacing: 20) {
                    Button {
                        viewModel.sendRequest()
                    } label: {
                        Text("로그인")
                            .modifier(CustomButtonTextModifier())
                    }
                    .background(.mainColor)
                    .clipShape(Capsule())
                    
                    HStack(spacing: 12) {
                        VStack {
                            Divider()
                        }
                        
                        Text("또는")
                            .font(.customBody2)
                            .foregroundColor(.subColor)
                        
                        VStack {
                            Divider()
                        }
                    }
                    
                    Button {
                        isSignUp = true
                    } label: {
                        Text("회원가입")
                            .modifier(CustomButtonTextModifier())
                    }
                    .background(.orange)
                    .clipShape(Capsule())
                }
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isSignUp) {
                SignUpView(viewModel: SignUpViewModel())
            }
            .fullScreenCover(isPresented: $viewModel.isSignInSuccess) {
                Tabbar()
                    .environmentObject(UserProfileSetting(token: viewModel.signInResponse?.token, user: viewModel.signInResponse?.user))
            }
            .padding()
            .alert("로그인 실패", isPresented: $viewModel.isSignInFailed, actions: {
                Button("닫기") {
                    
                }
            }, message: {
                if let messge = viewModel.signInResponse?.message {
                    Text(messge)
                } else {
                    Text("오류가 발생했습니다.")
                }
            })
            .navigationTitle(Text("로그인"))
            .toolbar(.hidden)
            .dismissKeyboardOnDrag()
        } // VStack
        .tint(.mainColor)
    } //NavigationStack
} // body

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
