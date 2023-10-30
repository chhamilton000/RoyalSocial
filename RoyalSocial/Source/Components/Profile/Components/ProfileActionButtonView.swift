//
//  ProfileActionButtonView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/24/23.
//

import SwiftUI

struct ProfileActionButtonView: View {
    @EnvironmentObject var sharedProfileViewModel: ProfileViewModel
    var isFollowed: Bool { return sharedProfileViewModel.user.isFollowed ?? false }
    @State var showEditProfile = false
    
    var body: some View {
        VStack {
            if sharedProfileViewModel.user.isCurrentUser {
                Button(action: { showEditProfile.toggle() }, label: {
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 360, height: 32)
                        .foregroundColor(Color.theme.systemBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }).fullScreenCover(isPresented: $showEditProfile) {
                    EditProfileView(sharedProfileViewModel: sharedProfileViewModel) // Passing shared ProfileViewModel
                }
            } else {
                VStack {
                    HStack {
                        Button(action: { isFollowed ? sharedProfileViewModel.unfollow() : sharedProfileViewModel.follow() }, label: {
                            Text(isFollowed ? "Following" : "Follow")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 360, height: 32)
                                .foregroundColor(isFollowed ? .black : .white)
                                .background(isFollowed ? Color.white : Color.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0)
                                )
                        }).cornerRadius(6)
                        
                    }
                }
            }
            
//            Divider()
//                .padding(.top, 4)
        }
    }
}

//                        NavigationLink(value: viewModel.user) {
//                            Text("Message")
//                                .font(.system(size: 14, weight: .semibold))
//                                .frame(width: 172, height: 32)
//                                .foregroundColor(Color.theme.systemBackground)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 6)
//                                        .stroke(Color.gray, lineWidth: 1)
//                                )
//                        }
struct ProfileActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileActionButtonView()
            .environmentObject(ProfileViewModel(user: prototype.user))
    }
}
