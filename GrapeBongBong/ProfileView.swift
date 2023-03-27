//
//  ProfileView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var isDismiss
    
    var body: some View {
        Button("로그아웃") {
            isDismiss.callAsFunction()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
