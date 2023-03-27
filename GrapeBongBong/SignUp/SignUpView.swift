//
//  SignUpView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel:  SignUpViewModel
    
    @Environment (\.dismiss) var isDismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    PrivateSignUpView(viewModel: viewModel, customTextFieldModifier: CustomTextFieldModifier())
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(.green)
                        .padding(EdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 0))
                    
                    PublicSignUpView(viewModel: viewModel, customTextFieldModifier: CustomTextFieldModifier())
                    
                    Spacer()
                        .frame(height: 32)
                    
                    Button {
                        isDismiss.callAsFunction()
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
            .navigationTitle(Text("회원가입"))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}
