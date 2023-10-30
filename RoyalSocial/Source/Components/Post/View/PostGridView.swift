//
//  PostGridView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/24/23.
//

import FirebaseAuth
import SwiftUI
import Kingfisher

struct PostGridView: View {
    private let items = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    private let width = (UIScreen.main.bounds.width / 3) - 2
    
    let config: PostGridConfiguration
    @StateObject var viewModel: PostGridViewModel
    
    init(config: PostGridConfiguration) {
        self.config = config
        self._viewModel = StateObject(wrappedValue: PostGridViewModel(config: config))
    }
    
    @State private var showConfirmationDialogueForDisfavorablePost = false
    @State private var showConfirmationDialogueForActionOnUsersOwnPost = false
    
    @State var selectedPost: Post?

    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: items, spacing: 2, content: {
                ForEach(viewModel.posts) { post in
                    NavigationLink(value: post) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: width)
                            .clipped()
                    }
                    .onAppear {
                        guard let index = viewModel.posts.firstIndex(where: { $0.id == post.id }) else { return }
                        if case .explore = config, index == viewModel.posts.count - 1 {
                            viewModel.fetchExplorePagePosts()
                        }
                    }
                }
            })
            .navigationDestination(for: Post.self) { post in
                PostCell(post: post, selectedPost: $selectedPost,
                         showConfirmationDialogueForDisfavorablePost: $showConfirmationDialogueForDisfavorablePost,
                         showConfirmationDialogueForActionOnUsersOwnPost: $showConfirmationDialogueForActionOnUsersOwnPost)
                    .modifier(ModuleForDisfavorableActionOnPost(showConfirmationDialogueForDisfavorablePost: $showConfirmationDialogueForDisfavorablePost,
                        currentUserUid: Auth.auth().currentUser?.uid ?? "",
                        otherUserUid: post.ownerUid
                    ))
                    .modifier(ModuleForUserActionOnTheirOwnPost(
                        showConfirmationDialogueForActionOnUsersOwnPost: $showConfirmationDialogueForActionOnUsersOwnPost,
                        post: $selectedPost
                    ))
            }
            .refreshable {
                viewModel.fetchPosts(forConfig: config)
            }
        }
    }
}

struct PostGridView_Previews: PreviewProvider {
    static var previews: some View {
        PostGridView(config: .profile(prototype.user))
    }
}
