//
//  PostListView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/30.
//

import SwiftUI

struct TalentPostListView: View {
    @State var isAddPostView = false
    @State var giveCategory: SearchCategory = .all
    @State var takeCategory: SearchCategory = .all
    @StateObject var postApiRequest = PostApiRequest()
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    HStack(spacing: 20) {
                        Picker("주는 재능", selection: $giveCategory) {
                            ForEach(SearchCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.mainColor)
                        .background(.gray.opacity(0.15))
                        .clipShape(Capsule())
                        .onChange(of: giveCategory) { newValue in
                            print("give change: \(newValue)")
                            postApiRequest.requestList(token: userProfileSetting.token, giveCategory: giveCategory, takeCategory: takeCategory)
                        }
                        
                        Image(systemName: "arrow.right")
                        
                        Picker("받는 재능", selection: $takeCategory) {
                            ForEach(SearchCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.mainColor)
                        .background(.gray.opacity(0.15))
                        .clipShape(Capsule())
                        .onChange(of: takeCategory) { newValue in
                            print("take change: \(newValue)")
                            postApiRequest.requestList(token: userProfileSetting.token, giveCategory: giveCategory, takeCategory: takeCategory)
                        }
                    }
                    
                    Divider()
                        .frame(height: 1)
                    
//                    ScrollView {
//                        LazyVStack {
//                            ForEach(postApiRequest.posts) { post in
//                                NavigationLink {
//                                    DetailPostView(post: post)
//                                } label: {
//                                    VStack {
//                                        TalentPostsCell(post: post)
//                                            .foregroundColor(.labelColor)
//                                            .padding()
//                                        Divider()
//                                            .frame(height: 1)
//                                    }
//                                }
//                            }
//                        }
//                        .padding()
//                    }
                    TalentListCell(posts: $postApiRequest.posts)
                    .onAppear {
                        postApiRequest.requestList(token: userProfileSetting.token, giveCategory: giveCategory, takeCategory: takeCategory)
                    }
                    .refreshable {
                        postApiRequest.requestList(token: userProfileSetting.token, giveCategory: giveCategory, takeCategory: takeCategory)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button {
                        isAddPostView = true
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
            .navigationDestination(isPresented: $isAddPostView) {
                AddTalentPostView()
                    .environmentObject(userProfileSetting)
            }
        }
        .tint(.mainColor)
    }
}

struct TalentPostsiew_Previews: PreviewProvider {
    static var previews: some View {
        TalentPostListView()
            .environmentObject(UserProfileSetting())
    }
}
