//
//  PrivateSignUpView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct PrivateSignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    let gender = ["남", "여"]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("이름")
                    .font(.system(size: 24, weight: .medium))
                TextField("",text: $viewModel.name)
                    .font(.system(size: 24))
                    .frame(height: 44)
                    .background(.gray.opacity(0.1))
            }
            
            VStack(spacing: 4) {
                Text("생년월일")
                    .font(.system(size: 24, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                DatePicker("", selection: $viewModel.birthday, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .tint(.green)
                    .environment(\.locale, Locale.init(identifier: "ko"))
                    .labelsHidden()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("성별")
                    .font(.system(size: 24, weight: .medium))
                Picker("", selection: $viewModel.gender) {
                    ForEach(gender, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("본인확인 이메일")
                    .font(.system(size: 24, weight: .medium))
                TextField("example@example.com",text: $viewModel.email)
                    .font(.system(size: 24))
                    .frame(height: 44)
                    .background(.gray.opacity(0.1))
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Text($viewModel.emailCautionMessage.wrappedValue)
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("휴대전화 번호")
                    .font(.system(size: 24, weight: .medium))
                TextField("숫자만 입력",text: $viewModel.phoneCall)
                    .font(.system(size: 24))
                    .frame(height: 44)
                    .background(.gray.opacity(0.1))
                    .keyboardType(.phonePad)
            }
        }
    }
}

struct PrivateSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateSignUpView(viewModel: SignUpViewModel())
    }
}
