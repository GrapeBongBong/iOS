//
//  ChatMessageCell.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/20.
//

import SwiftUI

struct ChatMessageCell: View {
    let chatMessage: ChatMessageResponse
    let userID: String
    
    var body: some View {
        VStack(spacing: 4) {
            let isOwner = chatMessage.senderID == userID
            if !isOwner {
                HStack {
                    Text(chatMessage.senderID)
                    Spacer()
                }
            }
            
            HStack {
                if isOwner {
                    Spacer()
                }
                Text(chatMessage.message)
                    .padding(10)
                    .background(isOwner ? .mainColor : .subColor)
                    .foregroundColor(.white)
                    .font(.customBody3)
                    .clipShape(Capsule())
                if !isOwner {
                    Spacer()
                }
            }
        }
        .padding(4)
    }
}

struct ChatMessageCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageCell(chatMessage: ChatMessageResponse(id: 1, roomID: 2, senderID: "abcd", message: "test임니돠~!"), userID: "abcd")
    }
}
