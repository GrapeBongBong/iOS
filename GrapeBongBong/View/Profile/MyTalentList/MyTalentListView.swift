//
//  MyTalentListView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/24.
//

import SwiftUI

struct MyTalentListView: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @StateObject var viewModel = PostApiRequest()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TalentListCell(posts: $viewModel.posts)
                .onAppear {
                    viewModel.requestList(token: userProfileSetting.token, urlStr: "/profile/exchange")
                }
                
                Spacer()
            }
        }
    }
    
    struct MyTalentListView_Previews: PreviewProvider {
        static var previews: some View {
            MyTalentListView()
                .environmentObject(UserProfileSetting(token: "123", user: User.mock()))
        }
    }
}
