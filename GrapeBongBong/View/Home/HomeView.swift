//
//  HomeView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/30.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @StateObject var viewModel = HomeViewModel()
    
    @State var talentPage = 0
    @State var commuPage = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 20)
                
                ScrollView {
                    VStack {
                        Divider()
                        
                        HStack {
                            Image(systemName: "thermometer.medium")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.orange, .green)
                            
                            VStack {
                                Text("\(userProfileSetting.user.nickName) 님의")
                                    .font(.customHeadline2)
                                Text("온도는 \(String(format: "%.1f", userProfileSetting.user.temperature))°C 입니다.")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("재능교환 인기 게시물")
                            .font(.customHeadline)
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                        TabView(selection: $talentPage) {
                            ForEach(viewModel.talentPosts) { talentPost in
                                NavigationLink {
                                    DetailPostView(post: talentPost)
                                } label: {
                                    PopularTalentCell(post: talentPost)
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .tint(.black)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 32)
                                                .stroke(talentPost.status ? .orange :  .green, lineWidth: 1)
                                        )
                                }
                                .tag(talentPost.id)
                            }
                            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                        .onAppear {
                            viewModel.requestTalentPosts(token: userProfileSetting.token)
                        }
                        .foregroundColor(Color(uiColor: UIColor.label))
                        .frame(minHeight: 300)
                    }
                    
                    Divider()
                        .frame(height: 1)
                    
                    VStack(alignment: .leading) {
                        Text("커뮤니티 인기 게시물")
                            .font(.customHeadline)
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                        TabView(selection: $commuPage) {
                            ForEach(viewModel.commuPosts) { commuPost in
                                NavigationLink {
                                    DetailCommuPostView(post: commuPost)
                                } label: {
                                    PopularCommuCell(post: commuPost)
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .tint(.black)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 32)
                                                .stroke(.labelColor, lineWidth: 1)
                                        )
                                }
                                .tag(commuPost.id)
                            }
                            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                        .onAppear {
                            viewModel.requestCommuPosts(token: userProfileSetting.token)
                        }
                        .foregroundColor(Color(uiColor: UIColor.label))
                        .frame(minHeight: 300)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserProfileSetting())
    }
}
