//
//  CustomTextEditor.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/06/01.
//

import SwiftUI

struct CustomTextEditor<T: Hashable>: View {
    var text: Binding<String>
    
    var focusState: FocusState<T>.Binding
    var focusing: T
    
    var body: some View {
        TextEditor(text: text)
            .modifier(CustomTextFieldModifier())
            .focused(focusState, equals: focusing)
            .border(focusState.wrappedValue == focusing ? .green : .subColor)
            .tint(.mainColor)
            .frame(maxWidth: .infinity, minHeight: 300, idealHeight: 600, maxHeight: 600)
    }
}

//struct CustomTextEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextEditor()
//    }
//}
