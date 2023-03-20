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
    
//    private var subscription = Set<AnyCancellable>()
}
