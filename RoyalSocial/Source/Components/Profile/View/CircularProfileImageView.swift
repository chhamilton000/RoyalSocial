//
//  CircularProfileImageView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/1/23.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    
    var dimension: CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 36
        case .small: return 48
        case .medium: return 64
        case .large: return 80
        }
    }
}

struct CircularProfileImageView: View {
    var user: User?
    let size: ProfileImageSize
    var isCurrentUser: Bool = false
    
    var body: some View {
        let imageUrl = isCurrentUser ? UserService.shared.currentUser?.profileImageUrl : user?.profileImageUrl
        profileImage(imageUrl, size: size)
    }
    
    private func profileImage(_ imageUrl: String?, size: ProfileImageSize) -> some View {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            return AnyView(
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.dimension, height: size.dimension)
                    .clipShape(Circle())
            )
        } else {
            return AnyView(
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: size.dimension, height: size.dimension)
                    .foregroundColor(Color(.systemGray4))
            )
        }
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static let prototype = PrototypingService.shared
    static var previews: some View {
        CircularProfileImageView(user: prototype.user, size: .large)
    }
}
