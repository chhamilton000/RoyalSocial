//
//  NotificationCell.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/15/23.
//

import FirebaseAuth
import SwiftUI
import Kingfisher

struct NotificationCell: View {
    @ObservedObject var viewModel: NotificationCellViewModel
    @Binding var notification: Notification
    
    @State var showConfirmationDialogueForActionOnUsersOwnPost: Bool = false
    @State var showConfirmationDialogueForDisfavorablePost: Bool = false

    
    var isFollowed: Bool {
        return notification.isFollowed ?? false
    }
    
    init(notification: Binding<Notification>) {
        self.viewModel = NotificationCellViewModel(notification: notification.wrappedValue)
        self._notification = notification
    }
    
    var body: some View {
        HStack {
            if let user = notification.user {
                NavigationLink(
                    destination: OtherUserProfileView(user: user)
                ) {
                    CircularProfileImageView(user: user, size: .xSmall)
                    
                    HStack {
                        Text(user.username)
                            .font(.system(size: 14, weight: .semibold)) +
                        
                            Text(notification.type.notificationMessage)
                            .font(.system(size: 14)) +
                        
                        Text(" \(notification.timestamp.timestampString())")
                            .foregroundColor(.gray).font(.system(size: 12))
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            if notification.type != .follow {
                if let post = notification.post {
                    NavigationLink(destination:
                                    PostCell(post: post, selectedPost: $notification.post,
                                        showConfirmationDialogueForDisfavorablePost: $showConfirmationDialogueForDisfavorablePost,
                                        showConfirmationDialogueForActionOnUsersOwnPost: $showConfirmationDialogueForActionOnUsersOwnPost
                                    )
                                        .modifier(ModuleForDisfavorableActionOnPost(
                                            showConfirmationDialogueForDisfavorablePost: $showConfirmationDialogueForDisfavorablePost,
                                            currentUserUid: Auth.auth().currentUser?.uid ?? "",
                                            otherUserUid: notification.post?.ownerUid ?? ""
                                        ))
                                        .modifier(ModuleForUserActionOnTheirOwnPost(
                                            showConfirmationDialogueForActionOnUsersOwnPost: $showConfirmationDialogueForActionOnUsersOwnPost,
//                                            showDeletePostAlert: $showDeletePostAlert,
//                                            showPostSuccessfullyDeletedAlert: $showPostSuccessfullyDeletedAlert,
                                            post: $notification.post
                                        ))

                    ) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipped()
                    }
                }
            } else {
                Button(action: {
                    isFollowed ? viewModel.unfollow() : viewModel.follow()
                    notification.isFollowed?.toggle()
                }, label: {
                    Text(isFollowed ? "Following" : "Follow")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 100, height: 32)
                        .foregroundColor(isFollowed ? .black : .white)
                        .background(isFollowed ? Color.white : Color.blue)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0)
                        )
                })
            }
            
        }
        .padding(.horizontal)
    }
}
