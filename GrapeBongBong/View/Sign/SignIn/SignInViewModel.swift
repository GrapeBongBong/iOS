//
//  SignInViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/19.
//

import Foundation
import SwiftUI
import Combine

final class SignInViewModel: ObservableObject {
    @Published var identifier: String = ""
    @Published var password: String = ""
    
    @Published var isSignInSuccess = false
    @Published var isSignInFailed = false
    @Published var signInResponse: SignInResponse? = nil // Published 없어도 될 것 같음
    
    var subscrptions = Set<AnyCancellable>()
    
    func sendRequest() {
        print("로그인 sendRequest() 실행 중...")
        let signInRequest = SignInRequest(id: identifier, password: password)
        let encoder = JSONEncoder()
        let data = try? encoder.encode(signInRequest)
        let url = URL(string: "http://3.34.75.23:8080" + "/auth/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .retry(1)
            .receive(on: RunLoop.main)
            .sink { completion in
                print("로그인 completion>>> \(completion)")
                switch completion {
                case .failure(_):
                    self.isSignInFailed = true
                case .finished:
                    break
                }
            } receiveValue: { (data, response) in
                do {
                    guard let response = response as? HTTPURLResponse else {
                        print("로그인 뷰>>> 응답이 없음")
                        return
                    }
                    
                    if (200..<300).contains(response.statusCode) {
                        self.isSignInSuccess = true
                        
                        self.signInResponse = try? JSONDecoder().decode(SignInResponse.self, from: data)
                    } else {
                        self.isSignInFailed = true
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let message = json["message"] as? String {
                                print(message)
                                self.signInResponse = SignInResponse(message: message, token: nil, user: nil)
                            }
                        }
                    }
                } catch {
                    print("로그인 뷰>>> 통신오류;")
                }
            }
            .store(in: &subscrptions)
    }
}

struct SignInRequest: Encodable {
    let id, password: String
}

struct SignInResponse: Decodable {
    let message: String
    let token: String?
    let user: User?
}
