//
//  CommentCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/09.
//

import SwiftUI

struct CommentCell: View {
    @State var comment: Comment
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("익명")
                    .font(.customHeadline2)
                Spacer()
                Text(comment.date)
            }
            
            Text(comment.content)
                .font(.customBody2)
        }
        .background(.subColor.opacity(0.16))
        .cornerRadius(10)
        .padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
    }
}

struct CommentCell_Previews: PreviewProvider {
    static var previews: some View {
        CommentCell(comment: Comment.mock)
            .previewLayout(.fixed(width: 393, height: 100))
    }
}
