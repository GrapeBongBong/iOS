//
//  PrivateSignUpView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct PrivateSignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    let customTextFieldModifier: CustomTextFieldModifier
    let gender = ["남", "여"]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("이름")
                    .font(.customHeadline)
                TextField("", text: $viewModel.name)
                    .modifier(customTextFieldModifier)
            }
            
            VStack(spacing: 4) {
                Text("생년월일")
                    .font(.customHeadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                DatePicker("", selection: $viewModel.birthday, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .tint(.green)
                    .environment(\.locale, Locale.init(identifier: "ko"))
                    .labelsHidden()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("성별")
                    .font(.customHeadline)
                Picker("", selection: $viewModel.gender) {
                    ForEach(gender, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("본인확인 이메일")
                        .font(.customHeadline)
                    Text($viewModel.emailCautionMessage.wrappedValue)
                        .foregroundColor(.red)
                }
                TextField("example@example.com",text: $viewModel.email)
                    .modifier(customTextFieldModifier)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("휴대전화 번호")
                    .font(.customHeadline)
                TextField("숫자만 입력",text: $viewModel.phoneCall)
                    .modifier(customTextFieldModifier)
                    .keyboardType(.phonePad)
            }
        }
    }
}

struct PrivateSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateSignUpView(viewModel: SignUpViewModel(), customTextFieldModifier: CustomTextFieldModifier())
    }
}
