//
//  SignUpViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var gender: String = ""
    @Published var phoneCall: String = ""
    
    @Published var email: String = ""
    @Published var identifier: String = ""
    @Published var nickName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    var pwCautionMessage: String = ""
    var cpwCautionMessage: String = ""
    var emailCautionMessage: String = ""
    
    private var subscription = Set<AnyCancellable>()
    
    func checkPasswordValidation(_ password: String) -> Bool {
        return password.range(of: "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}", options: .regularExpression) != nil
    }
    
    init() {
        $password.sink { [self] pw in
            if checkPasswordValidation(pw) || pw == ""  { // struct + enum으로 바꿀 수 있을 듯
                pwCautionMessage = ""
            } else {
                pwCautionMessage = "영어 + 숫자 + 특수기호로 8~20자 작성해주세요."
            }
        }.store(in: &subscription)
        
        $confirmPassword.sink { [self] cpw in
            if confirmPassword == password || confirmPassword == "" {
                cpwCautionMessage = ""
            } else {
                cpwCautionMessage = "비밀번호가 일치하지 않습니다."
            }
        }.store(in: &subscription)
        
        $email.sink { [self] em in
            if em.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .regularExpression) != nil || em == "" {
                emailCautionMessage = ""
            } else {
                emailCautionMessage = "이메일 형식을 다시 한 번 확인해주세요."
            }
        }.store(in: &subscription)
    }
}
