//
//  NewMessageView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 10/7/23.
//

import SwiftUI

struct NewDirectMessageView: View {
    @State var searchText = ""
    @Binding var startChat: Bool
    @Binding var user: User?
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                TextField("To: ", text: $searchText)
                    .frame(height: 44)
                    .padding(.leading)
                    .background(Color(.systemGroupedBackground))

                LazyVStack(alignment: .leading) {
                    ForEach(searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)) { user in
                        HStack { Spacer() }
                        
                        UserCell(user: user)
                            .onTapGesture {
                                dismiss()
                                startChat.toggle()
                                self.user = user
                            }
                    }
                }
                .padding(.leading)
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider{
    @Environment(\.dismiss) static var dismiss
    static var previews: some View{
        NewDirectMessageView(startChat: .constant(true),
                       user: .constant(prototype.user),
                       dismiss: Environment<DismissAction>(\.dismiss))
    }
}
