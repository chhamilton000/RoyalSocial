//
//  TextFieldModifier.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/13/23.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
