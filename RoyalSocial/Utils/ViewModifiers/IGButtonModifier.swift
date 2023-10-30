//
//  IGButtonModifier.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/29/23.
//

import SwiftUI

struct IGButtonModifier: ViewModifier {    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 360, height: 44)
            .background(Color(.systemBlue))
            .cornerRadius(8)
            .padding()
    }
}
