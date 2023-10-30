//
//  RoyalSocialApp.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/18/23.
//

import Firebase
import SwiftUI

@main
struct RoyalSocialApp: App {
    init() { FirebaseApp.configure() }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
