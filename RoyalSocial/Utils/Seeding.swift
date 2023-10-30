//
//  Seeding.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 10/18/23.
//

import FirebaseFirestore
import Foundation

class BackendWork{
    static func seedLikesForPosts(){
        // List of user IDs
        let userIds = [
            "EsAz8roFO7eXYgDV5dbPT9ROMfp1",
            "H3u3GgKMYXZJbAXJ1VJZrN8Jh6Z2",
            "OEhdWBKSaxU6P2itLLpJHAjpl0S2",
            "ROJ3yiIhwXMh8byTRaeykSE3LcL2",
            "UP2ERHpHcGdAkIKZOSEyxzhzbzF3",
            "VCN4brPWB2WyCsZm4rxz04RUTE63",
            "aHXEyCC80BNzWnFXoxaasGreIaP2",
            "gSt989LH6gce14Ui6xhEfBbLq0x1",
            "rtYgCNKc9HPIIAs3Kjj7Ld8fTLx2",
            "uZNx9w5YWAcTe2pOVIG2ASKvmLh1"
        ]

        // Reference to the posts Firestore collection
        let postsCollection = Firestore.firestore().collection("posts")

        // Fetch all documents from 'posts' collection
        postsCollection.getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            // Initialize a write batch
            let batch = Firestore.firestore().batch()
            
            // Loop through all documents and update
            for document in documents {
                let docRef = postsCollection.document(document.documentID)
                
                // Generate a random subset of user IDs
                let randomUserIds = userIds.shuffled().prefix(Int.random(in: 0...userIds.count))
                
                // Create the 'likedBy' dictionary
                var likedByDict: [String: Bool] = [:]
                for userId in randomUserIds {
                    likedByDict[userId] = true
                }
                
                // Update the 'likedBy' and 'likes' fields
                batch.updateData([
                    "likedBy": likedByDict,
                    "likes": randomUserIds.count
                ], forDocument: docRef)
            }

            // Commit the batch
            batch.commit { (error) in
                if let error = error {
                    print("Error updating batch: \(error)")
                } else {
                    print("Batch update succeeded.")
                }
            }
        }
    }

    static func removeDuplicateNotifications() {
        let db = Firestore.firestore()
        let notificationsRef = db.collection("notifications")
        let targetNotificationIDs = [
            "EsAz8roFO7eXYgDV5dbPT9ROMfp1",
            "H3u3GgKMYXZJbAXJ1VJZrN8Jh6Z2",
            "HmHTlHqIs6foI60Wu11p2aMlQ5b2",
            "OEhdWBKSaxU6P2itLLpJHAjpl0S2",
            "ROJ3yiIhwXMh8byTRaeykSE3LcL2",
            "UP2ERHpHcGdAkIKZOSEyxzhzbzF3",
            "VCN4brPWB2WyCsZm4rxz04RUTE63",
            "Y0UsQ6sfYmWh1RQ4i6hMSLogFmm2",
            "aE9FQ2HyWXOBOoVcb0kpqc36wDU2",
            "aHXEyCC80BNzWnFXoxaasGreIaP2",
            "evQRJ5SPCKP506AwChr0b2U3tfc2",
            "fT5J5uu6mlh237I6PgI3NGUKmTE3",
            "gSt989LH6gce14Ui6xhEfBbLq0x1",
            "hgUmvkzqv1YXWxT57oWWWN2NUz03",
            "lGTdCWw5ixOc3sIf8PxlTwnXRzu2",
            "lsozhxUtR0MlPtsxhBYasBCxZSf2",
            "qz8ynt24tzbwmVPSIsbmg2p4O773",
            "rtYgCNKc9HPIIAs3Kjj7Ld8fTLx2",
            "uZNx9w5YWAcTe2pOVIG2ASKvmLh1"
        ]
        
        // Loop through each target notification ID
        for notificationID in targetNotificationIDs {
            let userNotificationsRef = notificationsRef.document(notificationID).collection("user-notifications")
            
            var uidDict: [String: [DocumentReference]] = [:]
            
            userNotificationsRef.getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting user notifications: \(err)")
                    return
                }
                
                // Populate uidDict
                for doc in querySnapshot!.documents {
                    let uid = doc.data()["uid"] as? String ?? ""
                    if uidDict[uid] == nil {
                        uidDict[uid] = []
                    }
                    uidDict[uid]?.append(doc.reference)
                }
                
                // Create a batch
                var batch = db.batch()
                var batchCount = 0
                
                // Loop through uidDict to delete duplicates
                for (_, docRefs) in uidDict {
                    if docRefs.count <= 1 { continue }
                    
                    for i in 1..<docRefs.count {
                        batch.deleteDocument(docRefs[i])
                        batchCount += 1
                        
                        if batchCount >= 500 {
                            batch.commit { (batchErr) in
                                if let batchErr = batchErr {
                                    print("Error committing batch: \(batchErr)")
                                }
                            }
                            // Reset batch and count
                            batch = db.batch()
                            batchCount = 0
                        }
                    }
                }
                
                // Commit any remaining deletes in the batch
                if batchCount > 0 {
                    batch.commit { (batchErr) in
                        if let batchErr = batchErr {
                            print("Error committing batch: \(batchErr)")
                        }
                    }
                }
            }
        }
    }

}
