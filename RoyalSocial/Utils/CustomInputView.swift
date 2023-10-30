//
//  CustomInputView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/30/23.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    let placeholder: String
    let buttonTitle: String
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(placeholder, text: $inputText, axis: .vertical)
                .padding(12)
                .padding(.leading, 4)
                .padding(.trailing, 48)
                .background(Color(.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .font(.subheadline)
            
            Button(action: action) {
                Text(buttonTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(inputText.isEmpty ? Color(.systemGray) : Color(.systemBlue))
            }
            .padding(.horizontal)
            .disabled(inputText.isEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
