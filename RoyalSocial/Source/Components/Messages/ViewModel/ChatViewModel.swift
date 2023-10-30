//
//  ChatViewModel.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 10/7/23.
//

import SwiftUI
import Firebase

class ChatViewModel: ObservableObject {
    let user: User
    @Published var messages = [Message]()
    
    init(user: User) {
        self.user = user
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = FirestoreConstants.MessagesCollection
            .document(currentUid)
            .collection(user.id)
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            var newMessages = changes.compactMap({ try? $0.document.data(as: Message.self) })
            
            for i in 0 ..< newMessages.count {
                let chatPartnerId = newMessages[i].chatPartnerId
                
                if chatPartnerId != currentUid {
                    newMessages[i].user = self.user
                }
            }
            
            self.messages.append(contentsOf: newMessages)
        }
    }
    
    func sendMessage(_ messageText: String) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let uid = user.id

        do {
            // Check if the user is blocked before sending a message
            let isBlocked = try await BlockingService.isUserBlocked(currentUid: currentUid, otherUid: uid)

            if isBlocked {                
                print("User is blocked, can't send message")
                return
            }

            let currentUserRef = FirestoreConstants.MessagesCollection.document(currentUid).collection(uid).document()
            let receivingUserRef = FirestoreConstants.MessagesCollection.document(uid).collection(currentUid)
            let receivingRecentRef = FirestoreConstants.MessagesCollection.document(uid).collection("recent-messages")
            let currentRecentRef =  FirestoreConstants.MessagesCollection.document(currentUid).collection("recent-messages")

            let messageID = currentUserRef.documentID

            let data: [String: Any] = ["text": messageText,
                                       "id": messageID,
                                       "fromId": currentUid,
                                       "toId": uid,
                                       "timestamp": Timestamp(date: Date())]

            let recipientData: [String: Any] = ["text": messageText,
                                                "id": messageID,
                                                "fromId": currentUid,
                                                "toId": uid,
                                                "timestamp": Timestamp(date: Date())]

            // Set data for both the sender and the receiver
            try await currentUserRef.setData(data)
            try await currentRecentRef.document(uid).setData(data)
            try await receivingUserRef.document(messageID).setData(recipientData)
            try await receivingRecentRef.document(currentUid).setData(recipientData)
        } catch {
            print("An error occurred: \(error)")
        }
    }
}
