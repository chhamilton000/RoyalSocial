//
//  Constants.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/15/23.
//

import Firebase

struct FirestoreConstants {
    
    private static let Root = Firestore.firestore()

    static let BlockedUsersCollection = Root.collection("blockedUsers")
    
    static let FollowersCollection = Root.collection("followers")
    static let FollowingCollection = Root.collection("following")
    
    static let MessagesCollection = Root.collection("messages")

    static let NotificationsCollection = Root.collection("notifications")

    static let PostsCollection = Root.collection("posts")

    static let UserCollection = Root.collection("users")

}
