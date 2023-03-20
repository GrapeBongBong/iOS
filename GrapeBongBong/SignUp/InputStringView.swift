//
//  SwiftUIView.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/03/20.
//

import SwiftUI
import Combine

struct InputStringView: View {
    var infoString: String
    var bindString: Binding<String>
    
    var body: some View {
        HStack(spacing: 10) {
            Text(infoString)
                .font(.system(size: 20, weight: .medium))
            TextField(infoString,text: bindString)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SignUpViewModel()
        
        InputStringView(infoString: "아이디", bindString: .constant(viewModel.identifier))
    }
}
