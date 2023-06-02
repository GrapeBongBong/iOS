//
//  View+Extensions.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/04/27.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


extension View {
    public func dismissKeyboardOnDrag() -> some View {
        self.gesture(DragGesture().onChanged { _ in self.dismissKeyboard() })
    }
}
