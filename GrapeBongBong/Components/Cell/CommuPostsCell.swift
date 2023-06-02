//
//  CommuPostsCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import SwiftUI

struct CommuPostsCell: View {
    let post: CommuPost
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("익명")
                    .font(.customHeadline3)
                Spacer()
                Text(post.date.formatted("MM-dd"))
                    .font(.customBody3)
            }
            
            Text(post.title)
                .font(.customHeadline2)
            
            HStack(spacing: 0) {
                Text(post.content)
                    .font(.customBody3)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .topLeading)
                HStack {
                    Image(systemName: post.liked ? "leaf.fill" : "leaf")
                        .foregroundColor(.mainColor)
                    Text("\(post.likeCount)")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding()
    }
}

struct CommuPostsCell_Previews: PreviewProvider {
    static var previews: some View {
        CommuPostsCell(post: CommuPost.mock)
    }
}
