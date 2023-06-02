//
//  ImageCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/20.
//

import SwiftUI
import Kingfisher

struct ImageCell: View {
    @State var isZoomed: Bool = false
    let imageURLs: [PostImage]
    @State var pageIndex = 1
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack{
                ForEach(imageURLs) { image in
                    KFImage(URL(string: image.fileURL))
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .sheet(isPresented: $isZoomed) {
                            //                            ZoomedImageView(pageIndex: pageIndex, images: images)
                            ZoomedImageView(pageIndex: pageIndex, imageURLs: imageURLs)
                        }
                        .onTapGesture {
                            isZoomed = true
                            pageIndex = image.id
                        }
                }
            }
        }
    }
}

struct ZoomedImageView: View {
    @Environment(\.dismiss) var dismiss
    @State var pageIndex: Int
    
    let imageURLs: [PostImage]
    //    let images: [UIImage?]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            TabView(selection: $pageIndex) {
                ForEach(imageURLs) { imageURL in
                    KFImage(URL(string: imageURL.fileURL))
                        .placeholder {
                            Image(systemName: "tortoise.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.green, .orange)
                                .frame(width: 160)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .tag(imageURL.id)
                }
            }
            .tabViewStyle(.page)
        }
    }
}

struct ImageCell_Previews: PreviewProvider {
    static var previews: some View {
        ImageCell(imageURLs: [
            PostImage(id: 1, fileURL: "tortoise.fill"),
            PostImage(id: 2, fileURL: "tortoise.fill"),
            PostImage(id: 3, fileURL: "tortoise.fill"),
            PostImage(id: 4, fileURL: "tortoise.fill"),
            PostImage(id: 5, fileURL: "tortoise.fill")
        ])
    }
}
