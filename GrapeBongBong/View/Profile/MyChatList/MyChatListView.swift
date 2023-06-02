//
//  MyChatList.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/24.
//

import SwiftUI

struct MyChatListView : View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    @StateObject var viewModel = MyChatListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                List(viewModel.chatRoomList) { chatRoom in
                    let isOwner = userProfileSetting.user.uid == chatRoom.postWriterUID
                    NavigationLink(chatRoom.roomName) {
                        ChatRoomView(chatRoomID: chatRoom.id, chatRoomName: chatRoom.roomName, isOwner: isOwner, postID: chatRoom.pid)
                    }
                    
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.requestChatRoomList(token: userProfileSetting.token)
        }
    }
}

struct MyChatList_Previews: PreviewProvider {
    static var previews: some View {
        MyChatListView()
            .environmentObject(UserProfileSetting(token: "123123", user: User.mock()))
    }
}
