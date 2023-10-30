//
//  BlockedUsersViewModel.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/23/23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class BlockedUsersViewModel: ObservableObject{
    @Published var blockedUserCollection: [Block] = []
    
    init()  {
        Task{ await fetchBlockedUsers() }
    }
    
    
    @MainActor
    func fetchBlockedUsers() async {
        
        do{
            self.blockedUserCollection = try await BlockingService
                .fetchAllBlockedUsers(for: Auth.auth().currentUser?.uid ?? "")
        } catch {
            print(error)
        }
    }
    
    
    func unblockUser(currentUid: String, otherUid: String) async {
        do {
            await BlockingService.unblockUser(currentUid: currentUid, otherUid: otherUid)
//            self.blockedUserCollection.removeAll(where: { $0.blockedUid == otherUid })
            
            DispatchQueue.main.async {
                Task{
                    await self.fetchBlockedUsers()
                }
            }
        }
    }
    
}

//        do {
//            guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
//
//            let snapshot = try await FirestoreConstants.BlockedUsersCollection
//                .whereField("blockerUid", isEqualTo: currentUserUid)
//                .getDocuments()
//
//           let documents = snapshot.documents
//
//            self.blockedUserCollection = try documents.compactMap({ try $0.data(as: BlockedUser.self) })
//        } catch {
//            print(error)
//        }

