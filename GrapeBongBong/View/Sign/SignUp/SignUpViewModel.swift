//
//  SignUpViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import Foundation
import Combine
import RegexBuilder

final class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birth: Date = Date()
    @Published var gender: String = "남"
    @Published var phoneNum: String = ""
    @Published var address: String = "서울특별시 성북구"
    @Published var email: String = ""
    
    @Published var identifier: String = ""
    @Published var nickName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var networkingSuccess = false
    @Published var signUpResponse: SignUpResponse? = nil
    @Published var isSignUpSuccess = false
    var subscriptions = Set<AnyCancellable>()
    
    var isBirthValid: Bool {
        return birth.distance(to: Date.now) > .zero
    }
    
    var isPhoneNumValid: Bool {
        let regex = /^010\d{7,8}$/
        if let _ = phoneNum.wholeMatch(of: regex) {
            return true
        } else {
            return false
        }
    }
    
    var isEmailValid: Bool {
        let regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/
        if let _ = email.wholeMatch(of: regex) {
            return true
        } else {
            return false
        }
    }
    
    var isNickNameValid: Bool {
        let regex = /^[a-zA-Z가-힣0-9]{2,8}$/
        if let _ = nickName.wholeMatch(of: regex) {
            return true
        } else {
            return false
        }
    }
    
    var isIdentifierValid: Bool {
        let regex = /^[a-zA-Z가-힣0-9]{4,12}$/
        if let _ = identifier.wholeMatch(of: regex) {
            return true
        } else {
            return false
        }
    }
    
    var isPasswordValid: Bool {
        let regex = /^(?=.*\d)(?=.*[a-z])(?=.*[^\w\d\s:])([^\s]){8,20}$/
        if let _ = password.wholeMatch(of: regex) {
            return true
        } else {
            return false
        }
    }
    
    var isPasswordMatch: Bool {
        return password == confirmPassword
    }
    
    func sendRequest() {
        print("회원가입 sendRequest() 실행 중...")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let birthString = formatter.string(from: birth)
        
        let user = SignUpRequest(id: identifier, password: confirmPassword, name: name, nickName: nickName, birth: birthString, email: email, phoneNum: phoneNum, address: address, gender: gender)
        let encoder = JSONEncoder()
        let data = try? encoder.encode(user)
        
        let url = URL(string: URLList.baseURL + "/auth/join")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .map {
                self.networkingSuccess = true
                if let response = $0.response as? HTTPURLResponse {
                    if (200..<300).contains(response.statusCode) {
                        self.isSignUpSuccess = true
                    }
                }
                return $0.data
            }
            .retry(1)
            .receive(on: RunLoop.main)
            .decode(type: SignUpResponse.self, decoder: JSONDecoder())
            .sink { completion in
                print("회원가입 completion>>> \(completion)")
                switch completion {
                case .failure(_):
                    self.signUpResponse = nil
                case .finished:
                    break
                }
            } receiveValue: { message in
                self.signUpResponse = message
            }
            .store(in: &subscriptions)
    }
    
    func checkValidations() -> Bool {
        return isBirthValid && isEmailValid && isPasswordMatch && isPasswordValid && isIdentifierValid && isPhoneNumValid && isNickNameValid
    }
}

struct SignUpRequest: Encodable {
    let id, password, name, nickName: String
    let birth, email, phoneNum, address: String
    let gender: String
}

struct SignUpResponse: Decodable {
    let message: String
}
