//
//  HomeView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/19.
//

import SwiftUI

struct Tabbar: View {
    @State var tabSelection = 1
    @State var goHome = UUID()
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(1)
            
            TalentPostListView()
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("재능교환")
                }
                .tag(2)
            
            CommuPostListView()
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("커뮤니티")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("프로필")
                }
                .tag(4)
        }
        .id(goHome)
        .onTapGesture(count: 2, perform: {
            goHome = UUID()
        })
        .toolbar(.hidden)
    }
}

struct Tabbar_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar().environmentObject(UserProfileSetting())
    }
}
