//
//  SignUpView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel:  SignUpViewModel
    @State var showsDatePicker = false
    
    @Environment (\.dismiss) var isDismiss
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case name
        case birth
        case address
        case phoneNum
        case email
        case nickName
        case identifier
        case password
        case confirmPassword
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: 20) {
                        CustomTextField<Field?>(title: "이름", text: $viewModel.name, focusState: $focusState, focusing: .name)
                        
                        Button {
                            print("생일이다옹")
                        } label: {
                            VStack {
                                Text("2023-04-17")
                                    .foregroundColor(.black)
                                Divider()
                                    .frame(width: 2)
                                    .background(focusState == .birth ? .mainColor : .subColor)
                            }
                        }
                        .focused($focusState, equals: .address)
                        
                        Button {
                            print("주소다옹")
                        } label: {
                            VStack {
                                Text("서울시 성북구")
                                    .foregroundColor(.black)
                                Divider()
                                    .frame(width: 2)
                                    .background(focusState == .birth ? .mainColor : .subColor)
                            }
                        }
                        .focused($focusState, equals: .address)
                        
                        CustomTextField<Field?>(title: "전화번호", text: $viewModel.phoneNum, focusState: $focusState, focusing: .phoneNum)
                        
                        CustomTextField<Field?>(title: "이메일", text: $viewModel.email, focusState: $focusState, focusing: .email)
                        
                        CustomTextField<Field?>(title: "닉네임", text: $viewModel.nickName, focusState: $focusState, focusing: .nickName)
                        
                        CustomTextField<Field?>(title: "아이디", text: $viewModel.identifier, focusState: $focusState, focusing: .identifier)
                        
                        CustomSecureField<Field?>(title: "비밀번호", text: $viewModel.password, focusState: $focusState, focusing: .password, submitLabel: .next)
                        
                        CustomSecureField<Field?>(title: "비밀번호 확인", text: $viewModel.confirmPassword, focusState: $focusState, focusing: .confirmPassword)
                    }
                    .onSubmit {
                        switch(focusState) {
                        case .name:
                            focusState = .birth
                        case .birth:
                            focusState = .address
                        case .address:
                            focusState = .phoneNum
                        case .phoneNum:
                            focusState = .email
                        case .email:
                            focusState = .nickName
                        case .nickName:
                            focusState = .identifier
                        case .identifier:
                            focusState = .password
                        case .password:
                            focusState = .confirmPassword
                        default:
                            isDismiss.callAsFunction()
                        }
                    }
                    
                    Spacer(minLength: 60)
                    
                    Button {
                        isDismiss.callAsFunction()
                    } label: {
                        Text("회원가입")
                            .modifier(CustomButtonTextModifier())
                    }
                    .background(.mainColor)
                    .clipShape(Capsule())
                    
                }.padding()
            }
            .navigationTitle(Text("회원가입"))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}
