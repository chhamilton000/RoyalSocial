//
//  EditProfileRowView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/22/23.
//

import SwiftUI

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
                            
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 36)
    }
}

struct EditProfileRowView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileRowView(title: "foo", placeholder: "bar", text: .constant(""))
    }
}
