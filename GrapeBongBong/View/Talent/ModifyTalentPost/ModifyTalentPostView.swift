//
//  ModifyTalentPostView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/08.
//

import SwiftUI

struct ModifyTalentPostView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @Binding var post: Post
    @StateObject var viewModel = ModifyTalentPostViewModel()
    
    @State var previousPost: Post = Post.mock
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case title
        case giveTalent
        case takeTalent
        case content
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    CustomInputField(placeHolder: "제목", text: $post.title, focusState: $focusState, focusing: .title, isSecure: false)

                    HStack {
                        Picker("주는 재능", selection: $post.giveCate) {
                            ForEach(TalentCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.mainColor)
                        .background(.gray.opacity(0.15))
                        .clipShape(Capsule())

                        CustomInputField(placeHolder: "주는 재능", text: $post.giveTalent, focusState: $focusState, focusing: .giveTalent, isSecure: false)
                    }

                    HStack {
                        Picker("받는 재능", selection: $post.takeCate) {
                            ForEach(TalentCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.mainColor)
                        .background(.gray.opacity(0.15))
                        .clipShape(Capsule())

                        CustomInputField(placeHolder: "주는 재능", text: $post.takeTalent, focusState: $focusState, focusing: .giveTalent, isSecure: false)
                    }

                    Picker("요일 선택", selection: $post.availableTime.days[0]) {
                        ForEach(Days.allCases, id: \.self) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("시간대 선택", selection: $post.availableTime.timezone) {
                        ForEach(TimeZone.allCases, id: \.self) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)

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
            }
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
            .padding()
            .tint(.mainColor)
            .navigationBarTitle("재능교환 수정하기")
        }
        .onAppear {
            self.previousPost = post
        }
    }
}

struct ModifyTalentPostView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyTalentPostView(post: .constant(Post.mock))
//        ModifyTalentPostView()
    }
}
