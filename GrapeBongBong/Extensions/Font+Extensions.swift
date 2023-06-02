//
//  Font+Extensions.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/25.
//

import SwiftUI

extension Font {
    static var customHeadline: Font {
        return self.system(size: 24, weight: .semibold)
    }
    
    static var customHeadline2: Font {
        return self.system(size: 20, weight: .semibold)
    }
    
    static var customHeadline3: Font {
        return self.system(size: 16, weight: .semibold)
    }
    
    static var customBody1: Font {
        return self.system(size: 24, weight: .regular)
    }
    
    static var customBody2: Font {
        return self.system(size: 20, weight: .regular)
    }
    
    static var customBody3: Font {
        return self.system(size: 16, weight: .regular)
    }
}
