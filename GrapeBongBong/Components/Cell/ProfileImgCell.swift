//
//  ProfileImgCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/25.
//

import SwiftUI
import Kingfisher

struct ProfileImgCell: View {
    let imageURL: String?
    
    var body: some View {
//        if let urlStr = userProfileSetting.user.profileImg {
//            KFImage(URL(string: urlStr))
//                .placeholder {
//                    Image(systemName: "person.circle")
//                        .resizable()
//                        .clipShape(Circle())
//                }
//                .resizable()
//                .clipShape(Circle())
//                .scaledToFit()
//        } else {
//            Image(systemName: "person.circle")
//                .resizable()
//                .clipShape(Circle())
//                .scaledToFit()
//        }
        if let urlStr = imageURL {
            KFImage(URL(string: urlStr))
                .placeholder {
                    Image(systemName: "person.circle")
                        .resizable()
                        .clipShape(Circle())
                }
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
        } else {
            Image(systemName: "person.circle")
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
        }
    }
}

struct ProfileImgCell_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImgCell(imageURL: nil)
    }
}
