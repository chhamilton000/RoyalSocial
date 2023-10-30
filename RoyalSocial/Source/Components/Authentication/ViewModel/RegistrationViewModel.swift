//
//  RegistrationViewModel.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/29/23.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var emailIsValid = false
    @Published var usernameIsValid = false
    @Published var isLoading = false
    @Published var emailValidationFailed = false
    @Published var usernameValidationFailed = false
    @Published var errorMessage: String = ""
    
    func createUser() async throws {
       try await AuthService.shared.createUser(email: email,
                                               password: password,
                                               username: username)
    }
    
    @MainActor
    func validateEmail() async throws {
        self.isLoading = true
        self.emailValidationFailed = false
        
        let snapshot = try await FirestoreConstants
            .UserCollection
            .whereField("email", isEqualTo: email)
            .getDocuments()
        
//        self.emailValidationFailed = !snapshot.isEmpty
//        self.emailIsValid = snapshot.isEmpty
        
        if snapshot.isEmpty{
            self.emailIsValid = true
        } else {
            errorMessage = "This email is already in use"
            emailValidationFailed = true
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func validateUsername() async throws {
        self.isLoading = true
        self.usernameValidationFailed = false
        
        let snapshot = try await FirestoreConstants
            .UserCollection
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        if snapshot.isEmpty{
            self.usernameIsValid = true
        } else {
            errorMessage = "This username is taken"
            usernameValidationFailed = true
        }
        
        self.isLoading = false
    }
    
    func resetEmailValidationState(){
        self.emailIsValid = false
    }
    
    func resetUsernameValidationState(){
        self.usernameIsValid = false
    }
}
