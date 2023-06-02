//
//  TalentPostsCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/30.
//

import SwiftUI
import Kingfisher

struct TalentPostsCell: View {
    let post: Post
    let label = Color(uiColor: UIColor.label)
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 32) {
                VStack {
                    if post.images.isEmpty {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 60, maxHeight: 60)
                    } else {
                        KFImage(URL(string: post.images[0].fileURL)!)
                            .placeholder({
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 60, maxHeight: 60)
                            })
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 60, maxHeight: 60)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.customHeadline2)
                    Text("주는 재능: \(post.giveTalent)[\(post.giveCate.rawValue)]")
                    Text("받는 재능: \(post.takeTalent)[\(post.takeCate.rawValue)]")
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "thermometer.medium")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.orange, .green)
                        Text("\(String(format: "%.1f", post.temperature))°C")
                        
                        Image(systemName: post.liked ? "leaf.fill" : "leaf")
                            .foregroundColor(.mainColor)
                        Text("\(post.likeCount)")
                    }
                }
            }
        }
    }
}

struct TalentPostsCell_Previews: PreviewProvider {
    static var previews: some View {
        TalentPostsCell(post: Post.mock)
            .previewLayout(.fixed(width: 393, height: 100))
    }
}
