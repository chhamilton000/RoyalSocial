//
//  ContentView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authService = AuthService.shared
    @State var selectedIndex = 0
    
    var body: some View {
        Group {
            if authService.userIsLoggedIn{
                if let user = authService.user {
                    MainTabView(user: user,
                                selectedIndex: $selectedIndex)
                    .environmentObject(authService)
                }
            } else {
                LoginView()
                    .environmentObject(RegistrationViewModel())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthService())
//            .environmentObject(ContentViewModel())
    }
}
