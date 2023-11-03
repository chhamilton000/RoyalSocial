//
//  LoginView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/15/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                
                ZStack{
                    Text("RoyalSocial")
                        .font(Font.custom("Billabong", size: 60))
                }
                
                VStack(spacing: 8) {
                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Password", text: $password)
                        .modifier(TextFieldModifier())
                }
                
                HStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: ResetPasswordView(email: $email),
                        label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.top)
                                .padding(.trailing, 28)
                        })
                }
                
                
                Button(action: {
                    Task {
                        await viewModel.login(withEmail: email, password: password)
                        if viewModel.errorMessage != nil { showAlert = true }
                    }
                }, label: {
                    Text("Log In")
                        .modifier(IGButtonModifier())
                })
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Failed"),
                        message: Text(viewModel.errorMessage ?? "Unknown error"),
                        dismissButton: .default(Text("OK")) {
                            showAlert = false  // Dismiss the alert
                        }
                    )
                }
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    AddEmailView()
                        .environmentObject(registrationViewModel)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                        
                        Text("Sign Up")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .padding(.vertical, 16)
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(RegistrationViewModel())
    }
}
