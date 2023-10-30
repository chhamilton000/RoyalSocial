//
//  TabProfileView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 10/3/23.
//

import FirebaseAuth
import SwiftUI

struct CurrentUserProfileView: View {
    let user: User
    @StateObject var sharedProfileViewModel: ProfileViewModel
    @State private var showSettingsSheet = false
    @State private var selectedSettingsOption: SettingsItemModel?
    @State private var showDetail = false
    @State private var showDeleteAccountConfirmationAlert = false
    @State var showPrivacyPolicy: Bool = false
    
    init(user: User) {
        self.user = user
        self._sharedProfileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProfileHeaderView()
                    .environmentObject(sharedProfileViewModel)
                
                    Divider()
                    .padding(.top,24)
                
                    PostGridView(config: .profile(user))
                
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showDetail, destination: {
                Text(selectedSettingsOption?.title ?? "")
            })
            .sheet(isPresented: $showSettingsSheet) {
                SettingSheet()
                    .presentationDetents([.fraction(0.45)])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedSettingsOption = nil
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onChange(of: selectedSettingsOption) { newValue in
                guard let option = newValue else { return }
                
                if option != .logout {
                    self.showDetail.toggle()
                } else {
                    AuthService.shared.signout()
                }
            }
        }
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static let prototype = PrototypingService.shared
    static var previews: some View {
        CurrentUserProfileView(user: prototype.user)
    }
}
