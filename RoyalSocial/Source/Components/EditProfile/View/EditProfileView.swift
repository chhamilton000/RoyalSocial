//
//  EditProfileView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/30/23.
//

import SwiftUI
import Kingfisher
import PhotosUI

import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @ObservedObject var sharedProfileViewModel: ProfileViewModel
    
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    
    init(sharedProfileViewModel: ProfileViewModel) {
        self.sharedProfileViewModel = sharedProfileViewModel
        self._user = Binding<User>(
            get: { sharedProfileViewModel.user },
            set: { sharedProfileViewModel.user = $0 }
        )
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: sharedProfileViewModel.user))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 8) {
                    Divider()
                    
                    PhotosPicker(selection: $viewModel.selectedImage) {
                        VStack {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .foregroundColor(Color(.systemGray4))
                            } else {
                                CircularProfileImageView(user: user, size: .large)
                            }
                            Text("Edit profile picture")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                }
                .padding(.bottom, 4)
                
                VStack {
                    EditProfileRowView(title: "Name", placeholder: "Enter your name..", text: $viewModel.fullname)
                    
                    EditProfileRowView(title: "Bio", placeholder: "Enter your bio..", text: $viewModel.bio)
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            do {
                                try await viewModel.updateUserData()
                                DispatchQueue.main.async {
                                    sharedProfileViewModel.user = viewModel.user
                                }
                                dismiss()
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            .onReceive(viewModel.$user, perform: { user in
                self.user = user
            })
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(sharedProfileViewModel: ProfileViewModel(user: prototype.user))
    }
}
