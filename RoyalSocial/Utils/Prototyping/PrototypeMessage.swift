//
//  MessagePrototype.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/23/23.
//

import Foundation
import Firebase

struct PrototypeMessage{
    static let message1 = Message(id: "1a2b3c4d",
                                     fromId: PrototypeUser.cleopatra.id,
                                     toId: PrototypeUser.empress_wu_zetian.id,
                                     timestamp: Timestamp(date: Date()),
                                     text: "Hey, how are you?")
}

//import Foundation

//struct PrototypeMessage {
//    let text: String
//    let user: User
//    let messageId: String
//    let sentDate: Date
//
//    static let cleopatraMessage1 = Message(text: "The beauty of the Nile is unparalleled.",
//                                                    user: PrototypeUser.cleopatra,
//                                                    messageId: UUID().uuidString,
//                                                    sentDate: Date().addingTimeInterval(-86400*4)) // 4 days ago
//
//    static let wuZetianMessage1 = Message(text: "The Tang dynasty is at its peak.",
//                                                   user: PrototypeUser.empress_wu_zetian,
//                                                   messageId: UUID().uuidString,
//                                                   sentDate: Date().addingTimeInterval(-86400*3)) // 3 days ago
//
//    static let mansaMusaMessage1 = Message(text: "The wealth of Mali is vast and endless.",
//                                                    user: PrototypeUser.mansa_musa,
//                                                    messageId: UUID().uuidString,
//                                                    sentDate: Date().addingTimeInterval(-86400*2)) // 2 days ago
//
//    static let caesarMessage1 = Message(text: "Veni, vidi, vici.",
//                                                 user: PrototypeUser.caesar,
//                                                 messageId: UUID().uuidString,
//                                                 sentDate: Date().addingTimeInterval(-86400*1)) // 1 day ago
//
//    static let cleopatraMessage2 = Message(text: "The Sphinx is a mystery even to me.",
//                                                    user: PrototypeUser.cleopatra,
//                                                    messageId: UUID().uuidString,
//                                                    sentDate: Date()) // Today
//}
//
