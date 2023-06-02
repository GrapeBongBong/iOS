//
//  PopularTalentCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/29.
//

import SwiftUI

struct PopularTalentCell: View {
    let post: Post
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(post.writerNick)
                        .font(.customHeadline3)
                    Text("(\(post.writerID))")
                        .font(.customBody3)
                    
                    Spacer()
                    
                    Text(post.date.formatted("MM-dd"))
                        .font(.customBody3)
                }
                HStack {
                    Text(post.title)
                        .font(.customHeadline2)
                    Spacer()
                    Text(post.status ? "교환 원해요!" : "교환 완료!")
                        .font(.customHeadline3)
                        .foregroundColor(.white)
                        .background(post.status ? .orange : .mainColor)
                        .cornerRadius(4)
                }
                
                if post.images.count > 0 {
                    ImageCell(imageURLs: post.images)
                        .frame(maxHeight: 80)
                } else {
                    Text("이미지가 없어요")
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.20))
                }
            
                Spacer()
                
                Text(post.content)
                    .font(.customBody3)
                    .lineLimit(3)
                    .frame(minWidth: 300, maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
            }
            
            HStack {
                Image(systemName: "thermometer.medium")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.orange, .green)
                Text("\(String(format: "%.1f", post.temperature))°C")
                
                Image(systemName: post.liked ? "leaf.fill" : "leaf")
                    .foregroundColor(.mainColor)
                Text("\(post.likeCount)")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct PopularTalentCell_Previews: PreviewProvider {
    static var previews: some View {
        PopularTalentCell(post: Post.mock)
    }
}
