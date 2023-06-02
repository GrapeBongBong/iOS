//
//  TalentListCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/06/01.
//

import SwiftUI

struct TalentListCell: View {
    @Binding var posts: [Post]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(posts) { post in
                    NavigationLink {
                        DetailPostView(post: post)
                    } label: {
                        VStack {
                            TalentPostsCell(post: post)
                                .foregroundColor(.labelColor)
                            Divider()
                                .frame(height: 1)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct TalentListCell_Previews: PreviewProvider {
    static var previews: some View {
        TalentListCell(posts: .constant([Post.mock]))
    }
}
