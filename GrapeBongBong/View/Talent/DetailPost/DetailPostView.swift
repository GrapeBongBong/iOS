//
//  DetailPostView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/03.
//

import SwiftUI
import Kingfisher

struct DetailPostView: View {
    @Environment (\.dismiss) var isDismiss
    
    @StateObject var viewModel = DetailPostViewModel()
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @State var post: Post
    @State var viewChatRoomList = false
    @State var viewChatRoom = false
    @State var isModifiy = false
    @State var isDelete = false
    @State var inputComment = ""
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case comment
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(post.date.formatted("yyyy-MM-dd"))
                        
                        HStack {
                            ProfileImgCell(imageURL: post.writerImageURL)
                                .frame(width: 80, height: 80)
                            
                            VStack {
                                Text(post.writerID)
                                Text(post.writerNick)
                            }
                            
                            Spacer()
                            
                            Text(post.status ? "교환 원해요!" : "교환 완료!")
                                .font(.customHeadline3)
                                .foregroundColor(.white)
                                .background(post.status ? .orange : .mainColor)
                                .cornerRadius(4)
                        }
                        
                        HStack {
                            Text("줄 수 있는 재능: ")
                                .font(.customHeadline2)
                            Text("\(post.giveTalent) [\(post.giveCate.rawValue)]")
                        }
                        
                        HStack {
                            Text("받고 싶은 재능:")
                                .font(.customHeadline2)
                            Text("\(post.takeTalent) [\(post.takeCate.rawValue)]")
                        }
                        
                        HStack {
                            Text("가능한 요일: ")
                                .font(.customHeadline2)
                            Text(post.availableTime.days[0].rawValue)
                        }
                        
                        HStack {
                            Text("가능한 시간대: ")
                                .font(.customHeadline2)
                            Text(post.availableTime.timezone.rawValue)
                        }
                        
                        if post.images.count != 0 {
                            ImageCell(imageURLs: post.images)
                        }
                        
                        Text(post.content)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .border(.mainColor)
                    }
                    .font(.customBody2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("댓글>")
                        .font(.customHeadline2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVStack {
                        ForEach(viewModel.comments) { comment in
                            CommentCell(comment: comment)
                                .contextMenu {
                                    if comment.userID == userProfileSetting.user.uid {
                                        Button("삭제") {
                                            print("삭제")
                                            viewModel.requestDeleteComment(token: userProfileSetting.token, postID: post.id, commentID: comment.id)
                                            viewModel.requestComments(token: userProfileSetting.token, postID: post.id)
                                        }
                                        .tint(.red)
                                    }
                                }
                        }
                    }
                    .onAppear {
                        viewModel.requestComments(token: userProfileSetting.token, postID: post.id)
                        print(post.images)
                    }
                }
                .refreshable {
                    viewModel.requestComments(token: userProfileSetting.token, postID: post.id)
                }
                
                HStack {
                    VStack {
                        Button {
                            if viewModel.liked {
                                viewModel.requestLike(token: userProfileSetting.token, postID: post.id)
                            } else {
                                viewModel.requestLike(token: userProfileSetting.token, postID: post.id)
                            }
                        } label: {
                            if post.liked {
                                Image(systemName: "leaf.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                            } else {
                                Image(systemName: "leaf")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                            }
                        }
                        
                        Text("\(viewModel.likeCount)")
                            .foregroundColor(.labelColor)
                    }
                    
                    CustomInputField(placeHolder: "댓글", text: $inputComment, focusState: $focusState, focusing: .comment, isSecure: false, submitLabel: .send)
                        .onSubmit {
                            viewModel.requestAddComment(token: userProfileSetting.token, postID: post.id, comment: $inputComment.wrappedValue)
                            inputComment = ""
                            viewModel.requestComments(token: userProfileSetting.token, postID: post.id)
                        }
                }
                
                if userProfileSetting.user.uid == post.uid {
                    NavigationLink {
                        ChatRoomListView(post: $post)
                    } label: {
                        Text("채팅방 조회하기")
                            .modifier(CustomButtonTextModifier())
                    }
                    .background(.mainColor)
                    .clipShape(Capsule())
                } else {
                    Button {
                        viewModel.configureChatRoom(token: userProfileSetting.token, postID: post.id, userID: userProfileSetting.user.id, viewChatRoom: $viewChatRoom)
                        
                    } label: {
                        Text("대화하기")
                            .modifier(CustomButtonTextModifier())
                    }
                    .background(.mainColor)
                    .clipShape(Capsule())
                }
            }
            .navigationDestination(isPresented: $viewChatRoom, destination: {
                ChatRoomView(chatRoomID: viewModel.chatResponse.roomID, chatRoomName: viewModel.chatResponse.roomName, isOwner: false, postID: post.id)
            })
            .navigationDestination(isPresented: $viewChatRoomList, destination: {
                ChatRoomListView(post: $post)
            })
            .navigationDestination(isPresented: $isModifiy, destination: {
                ModifyTalentPostView(post: $post)
            })
            .padding()
            .navigationTitle(post.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if post.uid == userProfileSetting.user.uid {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink("수정") {
                            ModifyTalentPostView(post: $post)
                        }
                        
                        Spacer()
                        
                        Button("삭제") {
                            isDelete = true
                        }
                    }
                }
            }
            .alert("게시물 삭제", isPresented: $isDelete) {
                Button("취소하기", role: .cancel) {
                    
                }
                
                Button("삭제하기", role: .destructive) {
                    viewModel.requestDeletePost(token: userProfileSetting.token, postID: post.id)
                }
            } message: {
                Text("정말 게시물을 삭제할까요?")
            }
            .alert(viewModel.responseTitle, isPresented: $viewModel.isReqeustSuccess, actions: {
                Button("닫기") {
                    isDismiss.callAsFunction()
                }
            }, message: {
                Text(viewModel.responseMessage)
            })
            .alert(viewModel.responseTitle, isPresented: $viewModel.isRequestFailed, actions: {
                Button("닫기") {}
            }, message: {
                Text(viewModel.responseMessage)
            })
            .tint(.mainColor)
        }
        .onAppear {
            self.viewModel.likeCount = post.likeCount
            self.viewModel.liked = post.liked
        }
    }
}

struct DetailPostView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPostView(post: Post.mock)
            .environmentObject(UserProfileSetting(token: "234234", user: User.mock()))
    }
}
