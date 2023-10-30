//
//  BlockedUser.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/23/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct Block: Identifiable, Codable{
    @DocumentID var id: String?
    var blockerUid: String
    var blockedUid: String
    var username: String
}
