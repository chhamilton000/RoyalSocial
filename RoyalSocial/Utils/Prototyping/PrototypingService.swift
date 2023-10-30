//
//  PreviewProvider+prototyping.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 9/29/23.
//

import SwiftUI
import Firebase


class PrototypingService {
    static let shared = PrototypingService()
    
    var message: Message{
        Message(id: "igqsivIkVWGHkzWjgDLe", fromId: "rtYgCNKc9HPIIAs3Kjj7Ld8fTLx2", toId: "OEhdWBKSaxU6P2itLLpJHAjpl0S2",
                timestamp: Timestamp(date: Date.now),
                text: self.dummyLoremIpsumText,
                user: self.user )
    }
    
    let userCollection: [User] = [
        User(uid: "EsAz8roF07eXYgDV5dbPTR9OMfp1", username: "cleopatra", email: "email4projectss+cleopatra@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2FD3047756-F46F-4434-AAB1-B79AAFBD70CB?alt=media&token=718467d8-e619-4ff7-98ab-4aec4f3f866f", fullname: "Cleopatra"),
        
        User(uid: "H3u3GgKMYYZJbAXJ1VJZrN8hJ6Z2", username: "empress_wu_zetian", email: "email4projectss+empress_wu_zetian@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F56BBDF00-54E6-41D5-9EED-1F3324877875?alt=media&token=2ec90be3-26cc-4ff1-87a3-57c8709ba7c9", fullname: "Empress Wu Zetian"),
        
        User(uid: "0EhdWBKSaxU6P2itLLpJHAjpI0S2", username: "joan_of_arc", email: "email4projectss+joan_of_arc@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F75A2DC05-4342-4E34-8CB1-3D20AA79C43D?alt=media&token=47fbcad8-e44f-4f2b-99fd-1a22421af5df", fullname: "Joan of Arc"),
        
        User(uid: "ROJ3yilhwXMh8byTRaeykSE3LcL2", username: "marie_antoinette", email: "email4projectss+marie_antoinette@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F4594011D-B2D8-48B3-ABCC-15FC9B73D5F8?alt=media&token=f94be46b-fbdd-4a8c-a9ab-c3162a6e7b2b", fullname: "Marie Antoinette"),
        
        User(uid: "UP2ERHpHcGdAKlkZOSExyzhzbzF3", username: "anne_boleyn", email: "email4projectss+anne_boleyn@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F1328E95F-1E0E-4B07-9CF1-501DDE3BDEAA?alt=media&token=e6dcb37d-6070-4092-a85c-f80b03975602", fullname: "Anne Boleyn"),
        
        User(uid: "VCN4brPWB2WyCsZm4rxz04RUTE63", username: "peter_the_great", email: "email4projectss+peter_the_great@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F28C51CE5-C1DB-49EF-A0F3-DE26A96C59B6?alt=media&token=193c82a3-b124-4ac6-9789-d68d257c27ef", fullname: "Peter the Great"),
        
        User(uid: "aHXEyCC80BNzWNFxoaaSgrelaP2", username: "akbar_the_great", email: "email4projectss+akbar_the_great@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2FE4A1F485-EF46-499C-848F-221A2DE7023B?alt=media&token=26a9ff26-92e5-4fcd-9dae-2b1b8e1a9880", fullname: "Akbar the Great"),
        
        User(uid: "gSt989LH6gce14Ui6xhEfBbLq0x1", username: "king_henry_viii", email: "email4projectss+king_henry_viii@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F2C4D35FD-DE94-4F03-A561-B28EB4E1264F?alt=media&token=ad77b8d2-ed11-4d17-9e03-6d06cc9613ae", fullname: "King Henry VIII"),
        
        User(uid: "nnWs9vce8jcv8nRMZiPlIkMc5A2", username: "moctezuma_ii", email: "email4projectss+moctezuma_ii@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2FF0B44BF9-1C12-4E65-A59A-9B078A87BD4E?alt=media&token=af9d2eff-c4cd-4519-8203-f27f82699cac", fullname: "Moctezuma ii"),
        
        User(uid: "rtYgCNkC9PHlIAs3Kjj7Ld8fTLx2", username: "caesar", email: "email4projectss+caesar@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F325C4201-54B1-4CAC-90C6-5FB29B7DF649?alt=media&token=eee83daf-33f6-42d9-aca7-1d966c5840b7", fullname: "Caesar"),
        
        User(uid: "uZXN9w5YWAcTe2pOVlG2ASKvmLh1", username: "mansa_musa", email: "email4projectss+mansa_musa@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F2FE124F6-3F08-4D02-A85B-7B506E631387?alt=media&token=ae57ec83-ecab-4fab-8ccb-5c683f7f933d", fullname: "Mansa Musa")
    ]
    
    let messageCollection: [Message] = [
        Message(id: UUID().uuidString,
                 fromId: PrototypeUser.cleopatra.id,
                 toId: "OEhdWBKSaxU6P2itLLpJHAjpl0S2",
                 timestamp: Timestamp(date: Date.now),
                 text: "Hey how are you",
                 user: PrototypeUser.cleopatra ),
        
        Message(id: UUID().uuidString,
                 fromId: PrototypeUser.cleopatra.id,
                 toId: "OEhdWBKSaxU6P2itLLpJHAjpl0S2",
                 timestamp: Timestamp(date: Date.now),
                 text: "I'm fine, and you?",
                 user: PrototypeUser.cleopatra ),
        
        Message(id: UUID().uuidString,
                 fromId: PrototypeUser.mansa_musa.id,
                 toId: "OEhdWBKSaxU6P2itLLpJHAjpl0S2",
                 timestamp: Timestamp(date: Date.now),
                 text: "Hey how are you",
                 user: PrototypeUser.cleopatra ),
        
        Message(id: UUID().uuidString,
                 fromId: PrototypeUser.cleopatra.id,
                 toId: "OEhdWBKSaxU6P2itLLpJHAjpl0S2",
                 timestamp: Timestamp(date: Date.now),
                 text: "I'm fine, and you?",
                 user: PrototypeUser.cleopatra ),
        
    ]

    
    let dummyLoremIpsumText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    
    let user = User(uid: "EsAz8roFO7eXYgDV5dbPT9ROMfp1",
                    username: "cleopatra",
                    email: "email4projecttasks+cleopatra@gmail.com",
                    profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2FD3047756-F46F-4434-AAB1-B79AAFBD70CB?alt=media&token=718467d8-e619-4ff7-98ab-4aec4f3f866f", fullname: "Cleopatra")
    
    
    var post = Post(ownerUid: "ROJ3yiIhwXMh8byTRaeykSE3LcL2",
                    caption: "Let them eat cake... but make it a #CakeSelfie 🍰",
                    likes: 7,
                    imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/post_images%2F56DCD826-809D-496F-BA7B-F3BFA0BBD2DA?alt=media&token=c5c7c58b-1ee5-43db-9907-72d921cd0d48",
                    timestamp: Timestamp(date: Date.now),
                    user: User(username: "marie_antoinette",
                               email: "",profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-reverse-engineer.appspot.com/o/profile_images%2F4594011D-B2D8-48B3-ABCC-15FC9B73D5F8?alt=media&token=f94be46b-fbdd-4a8c-a9ab-c3162a6e7b2b"
                              ))
    
}
