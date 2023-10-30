//
//  UIApplication+endEditing.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/20/23.
//

import SwiftUI
import UIKit


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
