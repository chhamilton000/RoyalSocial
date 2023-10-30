//
//  MainTabView.swift
//  InstagramReverseEngineered
//
//  Created by Caley Hamilton on 9/24/23.
//

import SwiftUI

struct MainTabView: View {
    let user: User
    @Binding var selectedIndex: Int
    
    var body: some View {
            TabView(selection: $selectedIndex) {
                FeedView()
                    .tabItem {
                        Image(systemName: selectedIndex == 0 ? "house.fill" : "house")
                            .environment(\.symbolVariants, selectedIndex == 0 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 0 }
                    .tag(0)
                
                SearchView()
                    .tabItem { Image(systemName: "magnifyingglass") }
                    .onAppear { selectedIndex = 1 }
                    .tag(1)
                    
                UploadMediaView(tabIndex: $selectedIndex)
                    .tabItem { Image(systemName: "plus.app.fill") }
                    .onAppear { selectedIndex = 2 }
                    .tag(2)
                
                NotificationsView()
                    .tabItem {
                        Image(systemName: selectedIndex == 3 ? "heart.fill" : "heart")
                            .environment(\.symbolVariants, selectedIndex == 3 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 3 }
                    .tag(3)
                
                CurrentUserProfileView(user: user)
                    .tabItem {
                        Image(systemName: selectedIndex == 4 ? "person.fill" : "person")
                            .environment(\.symbolVariants, selectedIndex == 4 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 4 }
                    .tag(4)
            }
            .tint(Color.theme.systemBackground)
    }
    
}

struct MainTabView_Previews: PreviewProvider{
    static var previews: some View{
        @State var selectedIndex = 0
        MainTabView(user: prototype.user, selectedIndex: $selectedIndex)
    }
}
