//
//  UserProfileSetting.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/30.
//

import Foundation

final class UserProfileSetting: ObservableObject {
    @Published var token: String
    @Published var user: User
    
    init() {
        self.token = "test"
        self.user = User.mock()
    }
    
    init(token: String?, user: User?) {
        self.token = token ?? ""
        self.user = user ?? User.mock()
    }
}
