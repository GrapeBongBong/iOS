//
//  ProfileView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @Environment(\.dismiss) var isDismiss
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                List {
                    Section("프로필") {
                        NavigationLink {
                            let user = userProfileSetting.user
                            ModifyProfileView(userNickname: user.nickName, userPhoneNum: user.phoneNum)
                        } label: {
                            ProfileCell()
                        }
                        .frame(minHeight: 60)
                    }
                    .frame(alignment: .center)
                    
                    Section {
                        NavigationLink("내가 속한 재능교환 채팅방 조회하기") {
                            MyChatListView()
                        }
                        
                        NavigationLink("매칭완료된 재능교환 게시물 조회하기") {
                            MyMatchListView()
                        }
                        
                        NavigationLink("작성한 재능교환 게시물 조회하기") {
                            MyTalentListView()
                        }
                        
                        NavigationLink("작성한 커뮤니티 게시물 조회하기") {
                            MyCommuListView()
                        }
                    }
                    
                    Button("로그아웃") {
                        isDismiss.callAsFunction()
                    }
                    .foregroundColor(.red)
                }
                
                Spacer()
            }
        }
    }
}

struct ProfileCell: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    var body: some View {
        HStack {
            ProfileImgCell(imageURL: userProfileSetting.user.profileImg)
                .frame(minWidth: 20, idealWidth: 40, maxWidth: 60, minHeight: 20, idealHeight: 40, maxHeight: 60)
            
            Spacer(minLength: 4)
            
            VStack {
                Text(userProfileSetting.user.id)
                Text(userProfileSetting.user.nickName)
            }
            
            Spacer(minLength: 4)
            
            HStack {
                Image(systemName: "thermometer.medium")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.orange, .green)
                
                Text("\(String(format: "%.1f", userProfileSetting.user.temperature))°C")
                    .font(.customHeadline2)
            }
            
            Spacer(minLength: 0)
        }
        .tint(Color(uiColor: UIColor.label))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserProfileSetting(token: "123123", user: User.mock()))
    }
}
