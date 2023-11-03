//
//  BlockedUsersView.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/23/23.
//

import FirebaseAuth
import SwiftUI

struct BlockedUsersView: View {
//    var currentUser: User?
    @ObservedObject var viewModel: BlockedUsersViewModel
    @State private var showUnblockSuccessfulAlert = false
    
    
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(viewModel.blockedUserCollection){ blockedUser in
                    
                    HStack{
                        Text(blockedUser.username)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Button("Unblock"){
                            Task{
                                
                                await viewModel.unblockUser(currentUid: Auth.auth().currentUser?.uid ?? "", otherUid: blockedUser.blockedUid )
                            }
                        }
                        .font(.footnote)
                        .padding(6)
                        .foregroundColor(.white)
                        .background(Color.blue.cornerRadius(8))
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical,4)
                    Divider()
                    
                }

            }
        }
        .navigationTitle("Blocked Users")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct BlockedUsersView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedUsersView(viewModel: BlockedUsersViewModel())
    }
}
