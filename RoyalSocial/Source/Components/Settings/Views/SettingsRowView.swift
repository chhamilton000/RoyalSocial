//
//  SettingsRowView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/13/23.
//

import SwiftUI

struct SettingsRowView: View {
    let model: SettingsItemModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: model.imageName)
                .imageScale(.medium)
            
            Text(model.title)
                .font(.subheadline)
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(model: .logout)
    }
}
