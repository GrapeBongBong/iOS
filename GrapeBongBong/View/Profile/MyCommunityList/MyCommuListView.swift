//
//  MyCommunityListView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/24.
//

import SwiftUI

struct MyCommuListView: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    @StateObject var viewModel = CommuPostListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                List(viewModel.posts, id: \.id) { post in
                    NavigationLink {
                        DetailCommuPostView(post: post)
                    } label: {
                        CommuPostsCell(post: post)
                    }
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.requestData(token: userProfileSetting.token, urlStr: "/profile/anonymous")
            }
        }
    }
}

struct MyCommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        MyCommuListView()
            .environmentObject(UserProfileSetting(token: "123", user: User.mock()))
    }
}
