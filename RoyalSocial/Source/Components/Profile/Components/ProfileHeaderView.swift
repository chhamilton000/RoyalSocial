//
//  ProfileHeaderView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/24/23.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
    @EnvironmentObject var sharedProfileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                CircularProfileImageView(user: sharedProfileViewModel.user, size: .large)
                    .padding(.leading)
                
                Spacer()
                
                HStack(spacing: 16) {
                    UserStatView(value: sharedProfileViewModel.user.stats?.posts, title: "Posts")
                    
                    NavigationLink(value: SearchViewModelConfig.followers(sharedProfileViewModel.user.id)) {
                        UserStatView(value: sharedProfileViewModel.user.stats?.followers, title: "Followers")
                    }
                    .disabled(sharedProfileViewModel.user.stats?.followers == 0)
                    
                    NavigationLink(value: SearchViewModelConfig.following(sharedProfileViewModel.user.id)) {
                        UserStatView(value: sharedProfileViewModel.user.stats?.following, title: "Following")
                    }
                    .disabled(sharedProfileViewModel.user.stats?.following == 0)
                }
                .padding(.trailing)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let fullname = sharedProfileViewModel.user.fullname {
                    Text(fullname)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.leading)
                }
                
                if let bio = sharedProfileViewModel.user.bio {
                    Text(bio)
                        .font(.footnote)
                        .padding(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ProfileActionButtonView()
                .padding(.top)
            
        }
        .navigationDestination(for: SearchViewModelConfig.self) { config in
            UserListView(config: config)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
            .environmentObject(ProfileViewModel(user: prototype.user))
    }
}
