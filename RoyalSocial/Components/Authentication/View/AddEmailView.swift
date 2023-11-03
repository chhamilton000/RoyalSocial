//
//  AddEmailView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/28/23.
//

import SwiftUI

struct AddEmailView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showCreateUsernameView = false
    @State private var showTermsOfService = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Add your email")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("You'll use this email to sign in to your account.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            ZStack(alignment: .trailing) {
                TextField("Email", text: $viewModel.email)
                    .modifier(TextFieldModifier())
                    .padding(.top)
                    .autocapitalization(.none)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.trailing, 40)
                        .padding(.top, 14)
                }
                
                if viewModel.emailValidationFailed {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemRed))
                        .padding(.trailing, 40)
                        .padding(.top, 14)
                }
            }
            
            if viewModel.emailValidationFailed {
                Text("This email is already in use. Please login or try again.")
                    .font(.caption)
                    .foregroundColor(Color(.systemRed))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 28)
            }
                            
            Button {
                Task {
                    try await viewModel.validateEmail()
                }
            } label: {
                Text("Next")
                    .modifier(IGButtonModifier())
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            
            Spacer()
            
            VStack {
                Text("By tapping Next, you acknowledge that you have read")
                    .opacity(0.75)
                HStack(spacing:4){
//                    Button("Privacy Policy"){
//                        showPrivacyPolicy.toggle()
//                    }
                    Text("and agree to the")
                        .opacity(0.75)
                    Button("Terms of Service"){
                        showTermsOfService.toggle()
                    }
                }
            }
            .padding()
            .font(.footnote)
        }
        .sheet(isPresented: $showTermsOfService) {
            TermsOfServiceView()
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$emailIsValid, perform: { emailIsValid in
            if emailIsValid {
                self.showCreateUsernameView.toggle()
            }
        })
        .navigationDestination(isPresented: $showCreateUsernameView, destination: {
            CreateUsernameView()
        })
        .onAppear {
            showCreateUsernameView = false
            viewModel.resetEmailValidationState()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

extension AddEmailView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && viewModel.email.contains(".")
    }
}

struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddEmailView()
                .environmentObject(RegistrationViewModel())
        }
    }
}
