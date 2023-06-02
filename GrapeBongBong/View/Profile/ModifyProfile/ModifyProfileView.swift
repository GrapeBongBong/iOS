//
//  ModifyProfileView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/24.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ModifyProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @StateObject var viewModel = ModifyProfileViewModel()
    
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImgData: Data? = nil
    @State var userNickname: String
    @State var userPhoneNum: String
    @State var userPassword: String = ""
    
    let modifier = CustomTextFieldModifier()
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case phoneNum
        case email
        case nickName
        case password
        case confirmPassword
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                PhotosPicker(selection: $selectedItem) {
                    if let selectedImgData, let image = UIImage(data: selectedImgData) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 120)
                    } else {
                        ProfileImgCell(imageURL: userProfileSetting.user.profileImg)
                            .frame(width: 120)
                            .foregroundColor(.labelColor)
                    }
                }
                .onChange(of: selectedItem) { newValue in
                    Task {
                        if let data = try await newValue?.loadTransferable(type: Data.self) {
                            selectedImgData = data
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                let user = userProfileSetting.user
                ProfileInfoRow(title: "이름", content: user.name)
                ProfileInfoRow(title: "성별", content: user.gender)
                ProfileInfoRow(title: "생년월일", content: user.birth)
                ProfileInfoRow(title: "아이디", content: user.id)
                ProfileInfoRow(title: "이메일", content: user.email)
            }
            .modifier(modifier)
            
            HStack {
                Text("닉네임:")
                    .modifier(modifier)
                CustomInputField(placeHolder: "닉네임", text: $userNickname, focusState: $focusState, focusing: .nickName, isSecure: false)
            }
            
            HStack {
                Text("전화번호:")
                    .modifier(modifier)
                CustomInputField(placeHolder: "닉네임", text: $userPhoneNum, focusState: $focusState, focusing: .phoneNum, isSecure: false)
                    .keyboardType(.numberPad)
            }
            
            HStack {
                Text("비밀번호:")
                    .modifier(modifier)
                CustomInputField(placeHolder: "비밀번호", text: $userPassword, focusState: $focusState, focusing: .password, isSecure: false)
            }
            
            Button {
                viewModel.requestChangeProfileImg(token: userProfileSetting.token, imgData: selectedImgData, userID: userProfileSetting.user.id)
                
                viewModel.requestProfileModify(token: userProfileSetting.token, userID: userProfileSetting.user.id, nickname: userNickname, email: userProfileSetting.user.email, phoneNum: userPhoneNum, password: userPassword)
            } label: {
                Text("회원정보 수정")
                    .modifier(CustomButtonTextModifier())
            }
            .background(.mainColor)
            .clipShape(Capsule())
        }
        .padding()
        .frame(maxWidth: .infinity)
        .alert(viewModel.responseTitle, isPresented: $viewModel.isAlert) {
            Button("닫기") {
                if viewModel.isRequestSuccess {
                    dismiss.callAsFunction()
                    if let _ = viewModel.profileImageURL {
                        userProfileSetting.user.profileImg = viewModel.profileImageURL
                    }
                    userProfileSetting.user.nickName = userNickname
                    userProfileSetting.user.phoneNum = userPhoneNum
                }
            }
        } message: {
            Text(viewModel.responseMessage)
        }
    }
}

struct ProfileInfoRow: View {
    let title: String
    let content: String
    let modifier = CustomTextFieldModifier()
    
    var body: some View {
        HStack {
            Text("\(title):")
            Text(content)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ModifyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyProfileView(userNickname: "123", userPhoneNum: "123")
            .environmentObject(UserProfileSetting(token: "1213123", user: User.mock()))
    }
}
