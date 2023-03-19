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
    @Published var identification: String = ""
    @Published var password: String = ""
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        $identification.sink { id in
            // TO-DO
        }.store(in: &subscriptions)
        
        $password.sink { pw in
            // TO-DO
        }.store(in: &subscriptions)
    }
    
    func checkAccount() -> Bool {
        if identification == "admin" && password == "1234" {
            return true
        }
        
        return false
    }
}
