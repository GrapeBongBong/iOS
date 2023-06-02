//
//  AddCommuPostView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import SwiftUI
import PhotosUI

struct AddCommuPostView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @StateObject var viewModel = AddCommuPostViewModel()
    
    @State var selectedItems = [PhotosPickerItem]()
    @State var selectedDatas = [Data]()
    @State var selectedUIImages = [UIImage]()
    @State var selectedImages = [Image]()
    
    @FocusState var focusState: Field?
    enum Field: Hashable {
        case title
        case content
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    CustomInputField(placeHolder: "제목", text: $viewModel.title, focusState: $focusState, focusing: .title, isSecure: false)
                    
                    PhotosPicker(selection: $selectedItems, matching: .images) {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 36)
                                    .foregroundColor(.gray)
                                Text("사진추가하기")
                                    .tint(.gray)
                                    .font(.customBody2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 80)
                            .background(.gray.opacity(0.15))
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedItems) { _ in
                        Task {
                            selectedDatas.removeAll()
                            selectedImages.removeAll()
                            selectedUIImages.removeAll()
                            
                            for item in selectedItems {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        selectedDatas.append(data)
                                        selectedUIImages.append(uiImage)
                                        
                                        let image = Image(uiImage: uiImage)
                                        selectedImages.append(image)
                                    } else {
                                        print("이미지 변환 실패")
                                    }
                                } else {
                                    print("데이터 변환이 안됨")
                                }
                            }
                        }
                    }
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<selectedImages.count, id: \.self) { i in
                                selectedImages[i]
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                    
                    CustomTextEditor<Field?>(text: $viewModel.content, focusState: $focusState, focusing: .content)
                    
                    Button {
                        print("selected datas: \(selectedDatas.count)")
                        viewModel.sendRequestWithPhoto(with: userProfileSetting.token, images: selectedUIImages)
                    } label: {
                        Text("등록하기")
                            .modifier(CustomButtonTextModifier())
                    }
                    .background(.mainColor)
                    .clipShape(Capsule())
                } // VStack
            } // ScrollView
            .alert("게시 성공", isPresented: $viewModel.isAddSuccess, actions: {
                Button("닫기") {
                    dismiss.callAsFunction()
                }
            }, message: {
                Text(viewModel.responseMessage)
            })
            .alert("게시 실패", isPresented: $viewModel.isAddFailed, actions: {
                Button("닫기") {}
            }, message: {
                Text(viewModel.responseMessage)
            })
            .padding()
            .navigationTitle("커뮤니티 글 등록하기")
        } // NavigationStack
    }
}

struct AddCommuPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddCommuPostView()
            .environmentObject(UserProfileSetting(token: "1233", user: User.mock()))
    }
}
