//
//  DetailCommuPostView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import SwiftUI

struct DetailCommuPostView: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = DetailCommuPostViewModel()

    @State var post: CommuPost
    @State var inputComment = ""
    @State var isModify = false
    @State var isDelete = false

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
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
//                            ProfileImgCell(imageURL: post.writerImageURL)
//                                .frame(width: 60, height: 60)
                            Text("익명")
                        }

                        if post.images.count != 0 {
                            ImageCell(imageURLs: post.images)
                        }

                        Text(post.content)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .border(.mainColor)

                        LazyVStack {
                            ForEach(viewModel.comments) { comment in
                                CommentCell(comment: comment)
                                    .contextMenu {
                                        if comment.userID == userProfileSetting.user.uid {
                                            Button("삭제") {
                                                print("삭제")
                                                viewModel.requestDeleteComment(token: userProfileSetting.token, postID: post.id, commentID: comment.id)
                                                //                                                viewModel.requestComments(token: userProfileSetting.token, postID: post.id)
                                            }
                                            .tint(.red)
                                        }
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
                                    .foregroundColor(.mainColor)
                            } else {
                                Image(systemName: "leaf")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.mainColor)
                            }
                        }
                        
                        Text("\(viewModel.likeCount)")
                    }
                    
                    CustomInputField(placeHolder: "댓글", text: $inputComment, focusState: $focusState, focusing: .comment, isSecure: false, submitLabel: .send)
                        .onSubmit {
                            viewModel.requestAddComment(token: userProfileSetting.token, postID: post.id, comment: $inputComment.wrappedValue)
                            inputComment = ""
                            viewModel.requestComments(token: userProfileSetting.token, postID: post.id)
                        }
                }
            }
            .onAppear {
                self.viewModel.liked = post.liked
                self.viewModel.likeCount = post.likeCount
            }
            .dismissKeyboardOnDrag()
            .padding()
            .navigationTitle(post.title)
            .fullScreenCover(isPresented: $isModify, content: {
                ModifyCommuPostView(post: $post)
            })
            .alert("게시물 삭제", isPresented: $isDelete) {
                Button("취소하기", role: .cancel) {
                }

                Button("삭제하기", role: .destructive) {
                    viewModel.requestDeletePost(token: userProfileSetting.token, postID: post.id)
                }
            } message: {
                Text("정말 게시물을 삭제할까요?")
            }
            .alert(viewModel.responseTitle, isPresented: $viewModel.isRequestSuccess, actions: {
                Button("닫기") {
                    dismiss.callAsFunction()
                }
            }, message: {
                Text(viewModel.responseMessage)
            })
            .alert(viewModel.responseTitle, isPresented: $viewModel.isRequestFailed, actions: {
                Button("닫기") {}
            }, message: {
                Text(viewModel.responseMessage)
            })
            .toolbar {
                if post.uid == userProfileSetting.user.uid {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("수정") {
                            isModify = true
                        }
                        .foregroundColor(.mainColor)

                        Spacer()

                        Button("삭제") {
                            isDelete = true
                        }
                        .foregroundColor(.mainColor)
                    }
                }
            }
        }
    }
}

struct DetailCommuPostView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCommuPostView(post: CommuPost.mock)
            .environmentObject(UserProfileSetting(token: "123", user: User.mock()))
    }
}
