//
//  ModifyCommuPostView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/22.
//

import SwiftUI

struct ModifyCommuPostView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @Binding var post: CommuPost
    @StateObject var viewModel = ModifyCommuPostViewModel()
    
    @State var previousPost: CommuPost = CommuPost.mock
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case title
        case content
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomInputField(placeHolder: "제목", text: $post.title, focusState: $focusState, focusing: .title, isSecure: false)
                
                CustomTextEditor<Field?>(text: $post.content, focusState: $focusState, focusing: .content)
                
                Button {
                    viewModel.sendRequest(with: post, token: $userProfileSetting.token.wrappedValue)
                } label: {
                    Text("수정하기")
                        .modifier(CustomButtonTextModifier())
                }
                .background(.mainColor)
                .clipShape(Capsule())
            }
            .navigationBarTitle("커뮤니티 수정하기")
            .alert("수정 성공", isPresented: $viewModel.isModifySuccess, actions: {
                Button("닫기") {
                    dismiss.callAsFunction()
                }
            }, message: {
                Text(viewModel.responseMessage)
            })
            .alert("수정 실패", isPresented: $viewModel.isModifyFailed, actions: {
                Button("닫기") {
                    post = previousPost
                }
            }, message: {
                Text(viewModel.responseMessage)
            })
            .toolbar(content: {
                Button("취소") {
                    dismiss.callAsFunction()
                }
                .foregroundColor(.mainColor)
            })
            .padding()
            .dismissKeyboardOnDrag()
        }
    }
}

struct ModifyCommuPostView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyCommuPostView(post: .constant(CommuPost.mock))
            .environmentObject(UserProfileSetting(token: "123", user: User.mock()))
    }
}
