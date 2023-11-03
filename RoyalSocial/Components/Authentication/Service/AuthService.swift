//
//  AuthService.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/29/23.
//

import Foundation
import FirebaseAuth

enum LoginError: Int {
    case accountDisabled = 17005
    case invalidEmail = 17008
    case incorrectPassword = 17009
    case tooManyFailedAttempts = 17010
    case noUserWithThisEmail = 17011
    case networkConnectionIssue = 17020
}

enum SignupError: Int{
    case emailAlreadyInUse = 17007
    case invalidEmail = 17008
    case networkConnectionIssue = 17020
}


class AuthService: ObservableObject {
    @Published var user: User?
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    
    
    
    static let shared = AuthService()
    
    init() { Task { try await loadUserData() } }
    
    var userIsLoggedIn: Bool{ userSession != nil }
    
    private func handleFirebaseAuthError(_ error: NSError) {
        switch error.code {
        case SignupError.emailAlreadyInUse.rawValue:
            self.errorMessage = "This email is already in use"
        case SignupError.invalidEmail.rawValue:
            self.errorMessage = "Invalid email."
        case SignupError.networkConnectionIssue.rawValue:
            self.errorMessage = "Please check your network connection and try again."
        default:
            self.errorMessage = error.localizedDescription
        }
     }
    
    @MainActor
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let data: [String: Any] = [
                "email": email,
                "username": username,
                "id": result.user.uid
            ]
            
            try await FirestoreConstants.UserCollection.document(result.user.uid).setData(data)
            self.user = try await UserService.fetchUser(withUid: result.user.uid)
            
        } catch {
            
            if let error = error as NSError? {
                 handleFirebaseAuthError(error)
                 throw error
             } else {
                 self.errorMessage = error.localizedDescription
             }
            
        }
    }
    
    func deleteAccount(){
        self.userSession = nil
        self.user = nil
        try? Auth.auth().currentUser?.delete()
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            self.user = try await UserService.fetchUser(withUid: result.user.uid)
            self.errorMessage = nil  // Clear any previous error message
        } catch let error as NSError{
            handleFirebaseAuthError(error)
            throw error
        }
    }
    
    @MainActor
    func loadUserData() async throws {
        userSession = Auth.auth().currentUser
        
        if let session = userSession {
            self.user = try await UserService.fetchUser(withUid: session.uid)
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signout() {
        self.userSession = nil
        self.user = nil
        try? Auth.auth().signOut()
    }
}
