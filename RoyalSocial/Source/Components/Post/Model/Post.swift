//
//  Post.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/15/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Post: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    let ownerUid: String
    let caption: String
    var likes: Int
    let imageUrl: String
    let timestamp: Timestamp
    
    var user: User?
    
    var didLike: Bool? = false
    
    var likedBy: [String: Bool]?
    
    var priorityLevel: Int?
    
    var isDeleted: Bool? = false
}
