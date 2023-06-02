//
//  MyMatchList.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/31.
//

import SwiftUI

struct MyMatchListView: View {
    @StateObject var viewModel = MyMatchListViewModel()
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    
    @State var post: Post?
    @State var viewScoreCell = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.posts) { post in
                        VStack {
                            NavigationLink {
                                DetailPostView(post: post)
                            } label: {
                                TalentPostsCell(post: post)
                                    .foregroundColor(.labelColor)
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .foregroundColor(.labelColor)
                            
                            Button("평점 남기기") {
                                self.post = post
                            }
                            .foregroundColor(.mainColor)
                            
                            Divider()
                                .frame(height: 1)
                        }
                    }
                    .sheet(item: $post) { post in
                        RatingCell(post: post)
                            .presentationDetents([.height(360)])
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.requestList(token: userProfileSetting.token)
        }
    }
}

struct ScoreCell: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    @StateObject var viewModel = MyMatchListViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State var selectedScore = "⭐️⭐️⭐️"
    @State var message = ""
    
    let post: Post
    
    var scores = [
        "⭐️",
        "⭐️⭐️",
        "⭐️⭐️⭐️",
        "⭐️⭐️⭐️⭐️",
        "⭐️⭐️⭐️⭐️⭐️"
    ]
    
    var body: some View {
        VStack {
            Text(post.title)
                .font(.customHeadline2)
            
            Picker("", selection: $selectedScore) {
                ForEach(scores, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)
            
            Button {
                viewModel.requestScore(token: userProfileSetting.token, postID: post.id, score: selectedScore.count)
            } label: {
                Text("평점매기기")
                    .modifier(CustomButtonTextModifier())
            }
            .background(.mainColor)
            .clipShape(Capsule())
        }
        .alert(viewModel.title, isPresented: $viewModel.isRequested, actions: {
            Button("닫기") {
                if viewModel.isSuccess {
                    dismiss.callAsFunction()
                }
            }
        }, message: {
            Text(viewModel.message)
        })
        .padding()
    }
}

struct RatingCell: View {
    @EnvironmentObject var userProfileSetting: UserProfileSetting
    @StateObject var viewModel = MyMatchListViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State var rating = 3
    
    let post: Post
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text(post.title)
                    .font(.customHeadline)
                    .padding()
                Text("재능 교환은 어떠셨나요?")
                    .font(.customBody2)
                Text("평점을 남겨주세요.")
                    .font(.customBody2)
            }
            
            HStack {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    image(for: number)
                        .resizable().scaledToFit().frame(width: 40, height: 40)
                        .foregroundColor(number > rating ? offColor : onColor)
                        .onTapGesture {
                            rating = number
                        }
                }
            }
            .padding()
            
            Button {
                viewModel.requestScore(token: userProfileSetting.token, postID: post.id, score: rating)
            } label: {
                Text("평점매기기")
                    .modifier(CustomButtonTextModifier())
            }
            .background(.mainColor)
            .clipShape(Capsule())
        }
        .alert(viewModel.title, isPresented: $viewModel.isRequested, actions: {
            Button("닫기") {
                if viewModel.isSuccess {
                    dismiss.callAsFunction()
                }
            }
        }, message: {
            Text(viewModel.message)
        })
        .padding()
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct MyMatchList_Previews: PreviewProvider {
    static var previews: some View {
        MyMatchListView()
            .environmentObject(UserProfileSetting(token: "123", user: User.mock()))
    }
}
