//
//  AddTalentPostView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/29.
//

import SwiftUI
import PhotosUI
import UIKit

struct AddTalentPostView: View {
    @Environment (\.dismiss) var isDismiss
    
    @StateObject var viewModel = AddTalentPostViewModel()
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @State var selectedItems = [PhotosPickerItem]()
    @State var selectedDatas = [Data]()
    @State var selectedUIImages = [UIImage]()
    @State var selectedImages = [Image]()
    
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
                    CustomInputField(placeHolder: "제목", text: $viewModel.title, focusState: $focusState, focusing: .title, isSecure: false)
                    HStack {
                        Picker("주는 재능", selection: $viewModel.giveCategory) {
                            ForEach(TalentCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.mainColor)
                        .background(.gray.opacity(0.15))
                        .clipShape(Capsule())
                        
                        CustomInputField(placeHolder: "주는 재능", text: $viewModel.giveTalent, focusState: $focusState, focusing: .giveTalent, isSecure: false)
                    }
                    
                    HStack {
                        Picker("받는 재능", selection: $viewModel.takeCategory) {
                            ForEach(TalentCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.mainColor)
                        .background(.gray.opacity(0.15))
                        .clipShape(Capsule())
                        
                        CustomInputField(placeHolder: "받는 재능", text: $viewModel.takeTalent, focusState: $focusState, focusing: .takeTalent, isSecure: false)
                    }
                    
                    Picker("요일 선택", selection: $viewModel.availableDays) {
                        ForEach(Days.allCases, id: \.self) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("시간대 선택", selection: $viewModel.availableTimeZone) {
                        ForEach(TimeZone.allCases, id: \.self) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    PhotosPicker(selection: $selectedItems, matching: .images) {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 36)
                                    .foregroundColor(.gray)
                                Text("사진추가하기")
                                    .foregroundColor(.gray)
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
                    isDismiss.callAsFunction()
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
            .navigationTitle("재능교환 등록하기")
        } // NavigationStack
    }
}

struct AddTalentPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddTalentPostView()
            .environmentObject(UserProfileSetting())
    }
}
