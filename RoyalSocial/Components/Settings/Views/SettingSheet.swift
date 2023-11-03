//
//  SettingSheet.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/23/23.
//

import FirebaseAuth
import SwiftUI

struct SettingSheet: View {
    @State private var showDeleteAccountConfirmationAlert = false
    @State var showTermsOfService: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16){
                NavigationLink(destination: {
                    BlockedUsersView(viewModel: BlockedUsersViewModel())
                }, label: {
                    HStack{
                        Image(systemName: "person.fill.xmark.rtl")
                            .imageScale(.medium)
                        Text("Blocked users")
                            .font(.subheadline)
                        Spacer()
                    }
                })
                Divider()
                Button(action:{
                    showTermsOfService = true
                }, label: {
                    HStack{
                        Image(systemName: "newspaper")
                            .imageScale(.medium)
                        Text("Terms of Service")
                            .font(.subheadline)
//                            .padding(.leading,6)
                        Spacer()
                    }
                })
                Divider()
                Button(action: {
                        AuthService.shared.signout()
                }, label: {
                    HStack{
                        Image(systemName: "arrow.left.square")
                            .imageScale(.medium)
                        Text("Logout")
                            .font(.subheadline)
                            .padding(.leading,6)
                        Spacer()
                    }
                })
                Spacer()
                Button(action: {
                    showDeleteAccountConfirmationAlert.toggle()
                }, label: {
                    HStack{
                        Image(systemName: "exclamationmark.triangle")
                            .imageScale(.medium)
                        Text("Delete account")
                            .font(.subheadline)
                            .padding(.leading,6)
                        Spacer()
                    }
                    .foregroundColor(.red)
                })
            }
            .foregroundColor(.primary)
            .padding()
            .presentationDragIndicator(.visible)
            .alert(
                "Are you sure you want to delete your account?",
                isPresented: $showDeleteAccountConfirmationAlert,
                actions: {
                    Button(role: .destructive, action: {
                        AuthService.shared.deleteAccount()
                    }, label: {
                        Text("Yes")
                    })
                },
                message: { Text("This action is non-reversible") })
            .sheet(isPresented: $showTermsOfService) {
                TermsOfServiceView()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct SettingSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingSheet()
    }
}
