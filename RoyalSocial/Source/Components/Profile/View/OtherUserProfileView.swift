//
//  ProfileView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/24/23.
//

import FirebaseAuth
import SwiftUI

struct OtherUserProfileView: View {
    var user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    @State private var showBlockUserAlert = false
    @State private var showBlockSuccessfulAlert = false
    
    init(user: User) {
        self.user = user
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            ProfileHeaderView()
                .environmentObject(profileViewModel)
            
            Divider()
            .padding(.top,24)
            
            PostGridView(config: .profile(user))
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if user.id != Auth.auth().currentUser?.uid ?? "" {
                    Button(
                        action: { showBlockUserAlert.toggle() },
                        label: {
                            VStack {
                                Image(systemName: "person.fill.xmark.rtl")
                                    .imageScale(.small)
                                    .scaledToFit()
                                    .foregroundColor(Color.theme.systemBackground)
                                Text("Block user")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        })
                }
            }
        }
        .alert("Are you sure you want to block this user?", isPresented: $showBlockUserAlert, actions: {
            Button("Yes", role: .destructive) {
                Task { await BlockingService.blockUser(currentUid: Auth.auth().currentUser?.uid, otherUid: user.id) }
            }
            Button("Cancel", role: .cancel) {
                showBlockUserAlert.toggle()
            }
        })
        .alert("This user has been blocked", isPresented: $showBlockSuccessfulAlert, actions: {
            Button("Ok") { showBlockSuccessfulAlert.toggle() }
        }, message: {
            Text("Log out and log in to see changes.")
        })
        .refreshable {
            profileViewModel.loadUserData()
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static let prototypeService = PrototypingService.shared
    static var previews: some View {
        OtherUserProfileView(user: prototypeService.user)
    }
}
