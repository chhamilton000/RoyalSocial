//
//  ConversationCell.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/7/23.
//

import SwiftUI
import Kingfisher

struct DirectMessageCell: View {
    let message: Message
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                CircularProfileImageView(user: message.user, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    if let user = message.user {
                        Text(user.fullname ?? "")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Text(message.text)
                        .font(.system(size: 15))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .foregroundColor(.black)
                .padding(.trailing)
                
                Spacer()
            }
            .padding(.vertical, 4)
            
            Divider()
        }
        
    }
}

struct DirectMessageCell_Previews: PreviewProvider{
    static var previews: some View{
        DirectMessageCell(message: prototype.message)
    }
}
