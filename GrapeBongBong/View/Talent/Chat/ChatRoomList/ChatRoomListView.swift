//
//  ChatRoomListView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/15.
//

import SwiftUI

struct ChatRoomListView: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    @StateObject var viewModel = ChatRoomListViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var post: Post
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.chatRoomList) { chatRoom in
                    NavigationLink(chatRoom.roomName) {
                        ChatRoomView(chatRoomID: chatRoom.id, chatRoomName: chatRoom.roomName, isOwner: true, postID: chatRoom.pid)
                    }
                }
                .onAppear {
                    print("1233123")
                    viewModel.requestChatRoomList(token: userProfileSetting.token, postID: post.id)
                }
                .refreshable {
                    viewModel.requestChatRoomList(token: userProfileSetting.token, postID: post.id)
                }
            }
            .navigationTitle("채팅방 목록 조회")
        }
    }
}

struct ChatRoomListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomListView(post: .constant(Post.mock))
            .environmentObject(UserProfileSetting(token: "123", user: User.mock()))
    }
}
