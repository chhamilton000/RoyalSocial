//
//  ChatView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/7/23.
//

import SwiftUI

struct ChatView: View {
    let user: User
    @StateObject var viewModel: ChatViewModel
    @State var messageText: String = ""
    
    init(user: User, messageText: String? = nil) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
        self._messageText = State(initialValue: messageText ?? "")
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageView(viewModel: MessageViewModel(message: message))
                        
                    }
                }
            }.padding(.top)
            
            CustomInputView(inputText: $messageText,
                            placeholder: "Message...",
                            buttonTitle: "Send",
                            action: sendMessage)
            
            
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    func sendMessage() {
        Task{
            await viewModel.sendMessage(messageText)
            messageText = ""
        }
    }
}

struct ChatView_Previews: PreviewProvider{
    static var previews: some View{
        ChatView(user: prototype.user, messageText: prototype.dummyLoremIpsumText)
    }
}
