//
//  MatchingView.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import SwiftUI

struct MatchingView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var matchVM: MatchViewModel
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if !matchVM.users.isEmpty && currentIndex < matchVM.users.count {
                        UserCardView(user: matchVM.users[currentIndex]) {
                            matchVM.swiped(swipedUser: matchVM.users[currentIndex], liked: false)
                            self.currentIndex += 1
                        } onSwipeRight: {
                            matchVM.swiped(swipedUser: matchVM.users[currentIndex], liked: false)
                            self.currentIndex += 1
                        }
                    } else {
                        Text("No more users")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    matchVM.fetchUsers()
                 }
                
                .navigationBarItems(
                    trailing: Button(action: {
                        authVM.signOut()
                    }) {
                        Text("Sign Out")
                    })
            }
        }
    }
}

#Preview {
    MatchingView()
}
