//
//  PostCell.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/24/23.
//

import SwiftUI
import Kingfisher
import Firebase

struct PostCell: View {
    @ObservedObject var viewModel: FeedCellViewModel
    
    var didLike: Bool { return viewModel.post.didLike ?? false }
    
    @State var isTapped: Bool = false
    
    @State var isHeartAnimationActive = false
    
    init(post: Post, selectedPost: Binding<Post?>,
         showConfirmationDialogueForDisfavorablePost: Binding<Bool>,
         showConfirmationDialogueForActionOnUsersOwnPost: Binding<Bool>
    ) {
        self.viewModel = FeedCellViewModel(post: post)
        self._selectedPost = selectedPost
        self._showConfirmationDialogueForDisfavorablePost = showConfirmationDialogueForDisfavorablePost
        self._showConfirmationDialogueForActionOnUsersOwnPost = showConfirmationDialogueForActionOnUsersOwnPost
    }
    
    private var user: User? {
        return viewModel.post.user
    }
    
    private var post: Post {
        return viewModel.post
    }
    
    var currentUsersUid: String{
        Auth.auth().currentUser?.uid ?? ""
    }
    
    @Binding var selectedPost: Post?
    @Binding var showConfirmationDialogueForActionOnUsersOwnPost: Bool
    @Binding var showConfirmationDialogueForDisfavorablePost: Bool
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CircularProfileImageView(user: user, size: .xSmall)
                
                NavigationLink(value: user) {
                    Text(user?.username ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.systemBackground)
                }
                
                Spacer()
                
                Button(action: {
                    DispatchQueue.main.async {
                        selectedPost = post
                        if post.ownerUid == currentUsersUid{
                            showConfirmationDialogueForActionOnUsersOwnPost = true
                        } else {
                            showConfirmationDialogueForDisfavorablePost = true
                        }
                    }
//                        DispatchQueue.main.async {
//                            showConfirmationDialogueForActionOnUsersOwnPost = true
//                        }
//                    } else{
//                        DispatchQueue.main.async {
//                            showConfirmationDialogueForDisfavorablePost = true
//                        }
//                    }
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .padding(.trailing)
                })
            }
            .padding([.leading, .bottom], 8)
            
            ZStack{
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 400)
                    .clipped()
                    .contentShape(Rectangle())
                
                HeartAnimation(isTapped: $isHeartAnimationActive)
            }
            .onTapGesture(count: 2) { likePost() }
            
            
            
            HStack(spacing: 4) {
                Button(action: {
                    Task { didLike ? try await viewModel.unlike() : try await viewModel.like() }
                }, label: {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(didLike ? .red : Color.theme.systemBackground)
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                })
                
                NavigationLink(destination: CommentsView(post: post)) {
                    Image("comment")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                        .symbolRenderingMode(.palette)
                        .foregroundColor(Color.theme.systemBackground)
                }
                
                Button(action: {}, label: {
                    Image("share")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(4)
                        .symbolRenderingMode(.palette)
                        .foregroundColor(Color.theme.systemBackground)
                })
            }
            .padding(.leading, 4)
            
            NavigationLink(value: SearchViewModelConfig.likes(viewModel.post.id ?? "")) {
                Text(viewModel.likeString)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.leading, 8)
                    .padding(.bottom, 0.5)
                    .foregroundColor(Color.theme.systemBackground)
            }
            
            HStack {
                Text(post.user?.username ?? "").font(.system(size: 14, weight: .semibold)) +
                Text(" \(post.caption)")
                    .font(.system(size: 14))
            }.padding(.horizontal, 8)
            
            Text(post.timestamp.timestampString())
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .padding(.top, -2)
        }
    }
    
    func likePost(){
        if viewModel.post.didLike != nil { // Check if data is loaded
            isHeartAnimationActive = true
            Task {
                isTapped = true
                do {
                    if !didLike {
                        try await viewModel.like()
                    }
                } catch {
                    print("Error liking the post: \(error)")
                }
                
                // Reset the state variable so that the animation can be triggered again
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isHeartAnimationActive = false
                }
            }
        }
        
    }
}


struct FeedCell_Previews: PreviewProvider{
    static let prototype = PrototypingService.shared
    
    static var previews: some View{
        PostCell(post: prototype.post, selectedPost: .constant(prototype.post),
                 showConfirmationDialogueForDisfavorablePost: .constant(false),
                 showConfirmationDialogueForActionOnUsersOwnPost: .constant(false))
    }
}
