//
//  PostService.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/15/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct PostService {
    
    static func uploadPost(_ post: Post) async throws {
        guard let postData = try? Firestore.Encoder().encode(post) else { return }
        let _ = try await FirestoreConstants.PostsCollection.addDocument(data: postData)
        
//        try await updateUserFeedsAfterPost(postId: ref.documentID)
    }
    
    static func fetchPost(withId id: String) async throws -> Post {
        let postSnapshot = try await FirestoreConstants.PostsCollection.document(id).getDocument()
        let post = try postSnapshot.data(as: Post.self)
        return post
    }
    
    static func fetchUserPosts(user: User) async throws -> [Post] {
        let snapshot = try await FirestoreConstants.PostsCollection.whereField("ownerUid", isEqualTo: user.id).getDocuments()
        var posts = snapshot.documents.compactMap({try? $0.data(as: Post.self )})
        
        for i in 0 ..< posts.count {
            posts[i].user = user
        }
        
        return posts
    }
    
    static func deletePostFromFirebase(post: Post?) {
        guard let postId = post?.id else { return }
        Firestore.firestore().collection("posts").document(postId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func fetchAllPosts() async throws -> [Post]{
        
        guard let currentUser = Auth.auth().currentUser else { return [] }
        guard let currentUserData = try? await UserService.fetchUser(withUid: currentUser.uid) else { return [] }
        let blockedUsers = currentUserData.blockedUsers ?? [:]

        let snapshot = try? await FirestoreConstants.PostsCollection
            .order(by: "priorityLevel", descending: true)
            .getDocuments()
        guard let documents = snapshot?.documents else { return [] }

        var filteredPosts = documents.compactMap({ try? $0.data(as: Post.self) })
        // Remove posts from blocked users
        filteredPosts.removeAll { blockedUsers[$0.ownerUid] == true }

        // Create a dictionary to store the fetched users
        var fetchedUsers: [String: User] = [:]

        // Fetch users asynchronously
        try await withThrowingTaskGroup(of: (String, User).self) { taskGroup in
            for post in filteredPosts {
                let uid = post.ownerUid
                taskGroup.addTask {
                    return (uid, try await UserService.fetchUser(withUid: uid))
                }
            }

            for try await (uid, user) in taskGroup {
                fetchedUsers[uid] = user
            }
        }

        // Assign the fetched users to the corresponding posts
        for i in 0..<filteredPosts.count {
            if let user = fetchedUsers[filteredPosts[i].ownerUid] {
                filteredPosts[i].user = user
            }
        }

        PostService.moveRecentPostsToFront(&filteredPosts)
        
        filteredPosts.removeAll(where: { $0.isDeleted == true })
        
        return filteredPosts
        
    }

    static func moveRecentPostsToFront(_ posts: inout [Post]) {
        let currentTime = Date()
        posts.sort { post1, post2 in
            // Check if either post was created in the last 5 minutes
            let isPost1Recent = post1.timestamp.dateValue().timeIntervalSince(currentTime) >= -300
            let isPost2Recent = post2.timestamp.dateValue().timeIntervalSince(currentTime) >= -300
            
            // Move recent posts to the front
            if isPost1Recent && !isPost2Recent {
                return true
            }
            if !isPost1Recent && isPost2Recent {
                return false
            }
            
            // If both or neither are recent, sort by priority
            return post1.priorityLevel ?? 0 > post2.priorityLevel ?? 0
        }
    }

}

// MARK: - Likes

extension PostService {
//    static func likePost(_ post: Post) async throws {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        guard let postId = post.id else { return }
//
//        async let _ = try await FirestoreConstants.PostsCollection.document(postId).collection("post-likes").document(uid).setData([:])
//        async let _ = try await FirestoreConstants.PostsCollection.document(postId).updateData(["likes": post.likes + 1])
//        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(postId).setData([:])
//
//        async let _ = NotificationService.uploadNotification(toUid: post.ownerUid, type: .like, post: post)
//    }
    static func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post.id else { return }
        
        // Update the 'likedBy' field in the post document to include the current user's UID
        async let _ = try await FirestoreConstants.PostsCollection.document(postId).updateData([
            "likedBy.\(uid)": true,
            "likes": post.likes + 1  // You can still update the like count if you're using it elsewhere
        ])
        
        // Upload notification for the like
        async let _ = NotificationService.uploadNotification(toUid: post.ownerUid, type: .like, post: post)
    }

    static func unlikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post.id else { return }

        // Remove the user's UID from the 'likedBy' field in the post document
        async let _ = try await FirestoreConstants.PostsCollection.document(postId).updateData([
            "likedBy.\(uid)": FieldValue.delete(),
            "likes": max(post.likes - 1, 0)  // Decrement the like count, ensuring it doesn't go below zero
        ])

    }

    
    
//    static func unlikePost(_ post: Post) async throws {
//        guard post.likes > 0 else { return }
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        guard let postId = post.id else { return }
//
//        async let _ = try await FirestoreConstants.PostsCollection.document(postId).collection("post-likes").document(uid).delete()
//        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(postId).delete()
//        async let _ = try await FirestoreConstants.PostsCollection.document(postId).updateData(["likes": post.likes - 1])
//
//        async let _ = NotificationService.deleteNotification(toUid: uid, type: .like, postId: postId)
//    }
    
    static func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        return post.likedBy?[uid] ?? false

        //        guard let postId = post.id else { return false }
        

//        let snapshot = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(postId).getDocument()
//        return snapshot.exists
    }
}

// MARK: - Feed Updates

extension PostService {
    private static func updateUserFeedsAfterPost(postId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let followersSnapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        
        for document in followersSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(document.documentID)
                .collection("user-feed")
                .document(postId).setData([:])
        }
        
        try await FirestoreConstants.UserCollection.document(uid).collection("user-feed").document(postId).setData([:])
    }
}

