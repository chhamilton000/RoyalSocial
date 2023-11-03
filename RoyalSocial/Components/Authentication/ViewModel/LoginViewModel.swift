//
//  LoginViewModel.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/29/23.
//

import Foundation
import Combine

//class LoginViewModel: ObservableObject {
//    @Published var errorMessage: String?
//    func login(withEmail email: String, password: String) async throws {
//        try await AuthService.shared.login(withEmail: email, password: password)
//    }
//}

class LoginViewModel: ObservableObject {
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        AuthService.shared.$errorMessage
            .assign(to: &$errorMessage)
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async {
        try? await AuthService.shared.login(withEmail: email, password: password)
    }
}
