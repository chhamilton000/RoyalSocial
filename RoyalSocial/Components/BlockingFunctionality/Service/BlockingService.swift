//
//  BlockingService.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/23/23.
//

import Foundation

class BlockingService {
    
    @Published var currentUser: User?
    
    static let shared = BlockingService()
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        return user
    }

    
    @MainActor
    static func blockUser(currentUid: String?, otherUid: String) async {
        do{
            guard let currentUid = currentUid else { return }
            let blockedUser = try await fetchUser(withUid: otherUid)
            let blockingData = Block(blockerUid: currentUid, blockedUid: otherUid, username: blockedUser.username)

            
            let blockDocRef = FirestoreConstants.BlockedUsersCollection.document("\(currentUid)-\(otherUid)")
            let userDocRef = FirestoreConstants.UserCollection.document(currentUid)
            
            
            
            try blockDocRef.setData(from: blockingData)
            try await userDocRef.updateData(["blockedUsers.\(otherUid)": true])
            
        } catch{
            print(error)
        }
    }

    @MainActor
    static func unblockUser(currentUid: String, otherUid: String) async {
        do{
            let blockedDocRef = FirestoreConstants.BlockedUsersCollection
                .document("\(currentUid)-\(otherUid)")
            let userDocRef = FirestoreConstants.UserCollection.document(currentUid)
            
            try await blockedDocRef.delete()
            try await userDocRef.updateData(["blockedUsers.\(otherUid)": false])
            
            
            
        } catch {
            print(error)
        }
        
        
    }
    
    static func isUserBlocked(currentUid: String, otherUid: String) async throws -> Bool {
        let docRef = FirestoreConstants.BlockedUsersCollection
            .document("\(currentUid)-\(otherUid)")
//            .document(currentUid)
//            .collection("blockedByMe")
//            .document(otherUid)
//
        let snapshot = try await docRef.getDocument()
        
        return snapshot.exists
    }
    
    static func fetchAllBlockedUsers(for currentUid: String) async throws -> [Block]{
        do{
            let snapshot = try await FirestoreConstants.BlockedUsersCollection
                .whereField("blockerUid", isEqualTo: currentUid)
                .getDocuments()
            
            return snapshot.documents.compactMap({ try? $0.data(as: Block.self) })
            
        } catch {
            print(error)
            return []
        }
    }

}
