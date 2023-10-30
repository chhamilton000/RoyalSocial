//
//  FeedView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/24/23.
//

import FirebaseAuth
import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    //    @State private var showReportReasonSheet = false
    //    @State private var reportReason = ""
    
    @State private var showConfirmationDialogueForDisfavorablePost = false
    @State private var confirmationDialogueForUserModificationOfPostPresented = false
    @State private var reportHasBeenSubmitted = false
    @State private var showUserBlockedSuccessfullyAlert = false
    
    @State private var showConfirmationDialogueForActionOnUsersOwnPost = false
    @State private var showDeletePostAlert = false
    @State private var showPostSuccessfullyDeletedAlert = false
    
    @State private var selectedPost: Post?
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        PostCell(post: post, selectedPost: $selectedPost,
                                 showConfirmationDialogueForDisfavorablePost: $showConfirmationDialogueForDisfavorablePost,
                                 showConfirmationDialogueForActionOnUsersOwnPost: $showConfirmationDialogueForActionOnUsersOwnPost)
                    }
                }
                .padding(.top)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ZStack {
                        Text("RoyalSocial")
                            .font(Font.custom("Billabong", size: 24))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: DirectMessagesCollectionView(),
                        label: {
                            Image("share")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .padding(4)
                                .symbolRenderingMode(.palette)
                                .foregroundColor(Color.theme.systemBackground)
                        })
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                Task { try await viewModel.fetchAllPosts() }
            }
            .navigationDestination(for: User.self) { user in
                OtherUserProfileView(user: user)
            }
            .navigationDestination(for: SearchViewModelConfig.self) { config in
                UserListView(config: config)
            }
            .modifier(ModuleForDisfavorableActionOnPost(
                showConfirmationDialogueForDisfavorablePost: $showConfirmationDialogueForDisfavorablePost,
                currentUserUid: Auth.auth().currentUser?.uid ?? "",
                otherUserUid: selectedPost?.ownerUid ?? ""
                
            ))
            .modifier(ModuleForUserActionOnTheirOwnPost(
                showConfirmationDialogueForActionOnUsersOwnPost: $showConfirmationDialogueForActionOnUsersOwnPost,
                post: $selectedPost
            ))
            .onAppear{
                Task {
                    try await viewModel.fetchAllPosts()
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
