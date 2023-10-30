//
//  FeedCellViewModel.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/24/23.
//

import SwiftUI
import Firebase

@MainActor
class FeedCellViewModel: ObservableObject {
    @Published var post: Post
    
    var likeString: String {
        let label = post.likes == 1 ? "like" : "likes"
        return "\(post.likes) \(label)"
    }
    
    init(post: Post) {
        self.post = post
        
        Task { try await checkIfUserLikedPost() }
    }
    
//    func like() async throws {
//        self.post.didLike = true
//        try await PostService.likePost(self.post)
//        self.post.likes += 1
//    }
    func like() async throws {
        self.post.didLike = true
        try await PostService.likePost(self.post)
        self.post.likes += 1
    }


    func unlike() async throws {
        self.post.didLike = false
        try await PostService.unlikePost(self.post)
        self.post.likes -= 1
    }

    
//    func like() async throws {
//        self.post.didLike = true
//        Task {
//            try await PostService.likePost(post)
//            self.post.likes += 1
//        }
//    }
//
//    func unlike() async throws {
//        self.post.didLike = false
//        Task {
//            try await PostService.unlikePost(post)
//            self.post.likes -= 1
//        }
//    }
    
    func checkIfUserLikedPost() async throws {
        self.post.didLike = try await PostService.checkIfUserLikedPost(post)
    }
}
