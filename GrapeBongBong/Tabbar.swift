//
//  HomeView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/19.
//

import SwiftUI

struct Tabbar: View {
    var body: some View {
        TabView {
            Text("홈")
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            
            Text("봉사모집")
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("봉사모집")
                }
            
            Text("커뮤니티")
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("커뮤니티")
                }
            
            Text("프로필")
                .tabItem {
                    Image(systemName: "person")
                    Text("프로필")
                }
        }
        .tint(.green)
        .toolbar(.hidden)
    }
}

struct Tabbar_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
    }
}
