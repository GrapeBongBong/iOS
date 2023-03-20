//
//  ProfileView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                SignInView(viewModel: SignInViewModel())
            } label: {
                Text("로그아웃")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
