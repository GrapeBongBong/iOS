//
//  ChatRoomView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/15.
//

import SwiftUI

struct ChatRoomView: View {
    let chatRoomID: Int
    let chatRoomName: String
    let isOwner: Bool
    let postID: Int
    
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    @StateObject private var viewModel = ChatRoomViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State var text = ""
    @State var doMatch = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView{
                    ScrollViewReader { proxy in
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.chatMessages, id: \.id) { message in
                                ChatMessageCell(chatMessage: message, userID: userProfileSetting.user.id)
                            }
                        }
                        .onChange(of: viewModel.chatMessages.count) { _ in
                            if let message = viewModel.chatMessages.last {
                                withAnimation(.easeOut(duration: 0.4)) {
                                    proxy.scrollTo(message.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    TextField("채팅 입력", text: $text)
                        .padding(10)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                        .onSubmit {
                            viewModel.send(roomID: chatRoomID, senderID: userProfileSetting.user.id, text: text)
                            text = ""
                        }
                    
                    Button(action: {
                        viewModel.send(roomID: chatRoomID, senderID: userProfileSetting.user.id, text: text)
                        text = ""
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.right")
                            .padding(6)
                    })
                    .foregroundColor(.white)
                    .background(.mainColor)
                    .cornerRadius(8)
                }
            }
            .padding()
            .toolbar(content: {
                if isOwner {
                    Button {
                        doMatch = true
                    } label: {
                        Image(systemName: "hands.sparkles")
                            .foregroundColor(.mainColor)
                    }
                }
            })
            .alert("재능 교환", isPresented: $doMatch, actions: {
                Button("취소하기", role: .destructive) {  }
                
                Button("교환하기", role: .cancel) {
                    viewModel.requestToMatch(token: userProfileSetting.token, postID: postID)
                }
            }, message: {
                Text("신청자와 재능교환을 할까요?")
            })
            .alert(viewModel.responseTitle, isPresented: $viewModel.isAlert, actions: {
                Button("닫기") { }
            }, message: {
                Text(viewModel.responseMessage)
            })
            .onAppear {
                viewModel.connect(chatRoomID: chatRoomID)
            }
            .onDisappear {
                viewModel.disconnect()
                dismiss.callAsFunction()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView(chatRoomID: 1, chatRoomName: "temp", isOwner: true, postID: 123)
            .environmentObject(UserProfileSetting(token: "123213", user: User.mock()))
    }
}
