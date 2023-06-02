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
    
    let genders = ["남", "여"]
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    CustomInputField<Field?>(placeHolder: "이름", text: $viewModel.name, focusState: $focusState, focusing: .name, isSecure: false)
                    
                    DatePicker("", selection: $viewModel.birth, displayedComponents: [.date])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .environment(\.locale, Locale.init(identifier: "ko"))
                        .transformEffect(.init(scaleX: 1, y: 1))
                    
                    Picker("성별", selection: $viewModel.gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                    
                    EntryView<Field?>(customInputField: CustomInputField(placeHolder: "전화번호", text: $viewModel.phoneNum, focusState: $focusState, focusing: .phoneNum, isSecure: false)
                                      , prompt: "숫자만 입력해주세요.", isHidden: viewModel.isPhoneNumValid)
                    .keyboardType(.numberPad)
                    
                    EntryView<Field?>(customInputField: CustomInputField(placeHolder: "이메일", text: $viewModel.email, focusState: $focusState, focusing: .email, isSecure: false)
                                      , prompt: "이메일 형식을 지켜주세요.", isHidden: viewModel.isEmailValid)
                    .keyboardType(.emailAddress)
                }
                
                Group {
                    EntryView<Field?>(
                        customInputField: CustomInputField(placeHolder: "닉네임", text: $viewModel.nickName, focusState: $focusState, focusing: .nickName, isSecure: false),
                        prompt: "2~8자 / 영어, 한글, 숫자 포함",
                        isHidden: viewModel.isNickNameValid
                    )
                    
                    EntryView<Field?>(
                        customInputField: CustomInputField(placeHolder: "아이디", text: $viewModel.identifier, focusState: $focusState, focusing: .identifier, isSecure: false),
                        prompt: "4~12자 / 영어, 한글, 숫자 포함",
                        isHidden: viewModel.isIdentifierValid
                    )
                    .keyboardType(.alphabet)
                    
                    EntryView<Field?>(customInputField: CustomInputField(placeHolder: "비밀번호", text: $viewModel.password, focusState: $focusState, focusing: .password, isSecure: true)
                                      , prompt: "4~12자 / 영어, 한글, 숫자, 특수문자 포함", isHidden: viewModel.isPasswordValid)
                    
                    EntryView<Field?>(customInputField: CustomInputField(placeHolder: "비밀번호 확인", text: $viewModel.confirmPassword, focusState: $focusState, focusing: .confirmPassword, isSecure: true), prompt: "비밀번호가 일치하지 않습니다.", isHidden: viewModel.isPasswordMatch)
                }
                
                Button {
                    if viewModel.checkValidations() {
                        viewModel.sendRequest()
                    }
                } label: {
                    Text("회원가입")
                        .modifier(CustomButtonTextModifier())
                }
                .background(.mainColor)
                .clipShape(Capsule())
            }
        }
        .padding()
        .scrollDismissesKeyboard(.immediately)
        .alert($viewModel.isSignUpSuccess.wrappedValue ? "회원가입 성공" : "회원가입 실패", isPresented: $viewModel.networkingSuccess, actions: {
            Button("닫기") {
                print($viewModel.signUpResponse.wrappedValue!)
                if $viewModel.isSignUpSuccess.wrappedValue {
                    isDismiss.callAsFunction()
                }
            }
        }, message: {
            if let message = viewModel.signUpResponse {
                Text(message.message)
            } else {
                Text("오류가 발생했습니다.")
            }
        })
        .navigationTitle(Text("회원가입"))
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}

struct EntryView<T: Hashable>: View {
    let customInputField: CustomInputField<T>
    var prompt: String
    var isHidden: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            customInputField
                .autocorrectionDisabled()
            Text(prompt)
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(isHidden ? 0 : 1)
        }
    }
}
