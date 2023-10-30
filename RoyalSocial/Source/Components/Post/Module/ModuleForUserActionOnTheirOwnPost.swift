//
//  ModuleForUserActionOnTheirOwnPost.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/22/23.
//

import SwiftUI

struct ModuleForUserActionOnTheirOwnPost: ViewModifier{
    @Binding var showConfirmationDialogueForActionOnUsersOwnPost: Bool
    @State var showDeletePostAlert: Bool = false
    @State var showPostSuccessfullyDeletedAlert: Bool = false
    @Binding var post: Post?
    func body(content: Content) -> some View {
        content
            .confirmationDialog("Options",
            isPresented: $showConfirmationDialogueForActionOnUsersOwnPost,
            actions: {
                Button("Delete Post", role: .destructive) {
                    showDeletePostAlert.toggle()
                }
            })
            .alert("Are you sure you want to delete this post?", isPresented: $showDeletePostAlert, actions: {
                Button("Yes", role: .destructive) {
                    DispatchQueue.main.async {
                        post?.isDeleted = true
                    }
                    PostService.deletePostFromFirebase(post: post)
                    showPostSuccessfullyDeletedAlert.toggle()
                }
            })
            .alert("This post has been deleted", isPresented: $showPostSuccessfullyDeletedAlert, actions: {
                Button("Ok"){
                    showPostSuccessfullyDeletedAlert.toggle()
                }
            }, message: {
                Text("Post has been deleted, log out then log back in to see changes.")
            })

    }
}
