//
//  CommuPostListView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import SwiftUI

struct CommuPostListView: View {
    @EnvironmentObject private var userProfileSetting: UserProfileSetting
    
    @StateObject private var viewModel = CommuPostListViewModel()
    @State private var moveAddCummuPostView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    
                    List(viewModel.posts, id: \.id) { post in
                        NavigationLink {
                            DetailCommuPostView(post: post)
                        } label: {
                            CommuPostsCell(post: post)
                        }
                    }
                    .onAppear {
                        viewModel.requestData(token: userProfileSetting.token)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button {
                        moveAddCummuPostView = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 32, height: 32)
                            .padding()
                    }
                    .background(.mainColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding()
                }
            }
            .navigationDestination(isPresented: $moveAddCummuPostView) {
                AddCommuPostView()
                    .environmentObject(userProfileSetting)
            }
        }
        .tint(.mainColor)
    }
}

struct CommuPostListView_Previews: PreviewProvider {
    static var previews: some View {
        CommuPostListView()
            .environmentObject(UserProfileSetting(token: "123", user: User.mock()))
    }
}
