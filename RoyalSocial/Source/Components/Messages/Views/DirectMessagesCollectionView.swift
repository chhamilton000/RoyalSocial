//
//  ConversationsView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 10/7/23.
//

import SwiftUI

struct DirectMessagesCollectionView: View {
    @State var isShowingNewDMView = false
    @State var showChat = false
    @State var user: User?
    @StateObject var viewModel = ConversationsViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.recentMessages.isEmpty{
                    Text("You have no messages at this time")
                        .fontWeight(.thin)
                } else {
                    ForEach(viewModel.recentMessages) { message in
                        NavigationLink {
                            if let user = message.user {
                                ChatView(user: user)
                            }
                        } label: {
                            DirectMessageCell(message: message)
                        }
                    }
                }
            }.padding()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingNewDMView, content: {
            NewDirectMessageView(startChat: $showChat, user: $user)
        })
        .toolbar(content: {
            Button {
                isShowingNewDMView.toggle()
            } label: {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
                    .foregroundColor(Color.theme.systemBackground)
            }
            
        })
        .onAppear {
            viewModel.loadData()
        }
        .navigationDestination(isPresented: $showChat) {
            if let user = user {
                ChatView(user: user)
            }
        }
    }
}

struct DirectMessageCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        DirectMessagesCollectionView()
    }
}
