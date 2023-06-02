//
//  UIImage+Extensions.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/08.
//

import Foundation
import SwiftUI

extension UIImage {
    func resizeImage(width: CGFloat) -> UIImage {
        let scale = self.size.width / width
        let height = self.size.height * scale
        let size = CGSize(width: width, height: height)
        
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}
