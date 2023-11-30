//
//  MatchingView.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import SwiftUI

struct MatchingView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Other content in your MatchingView
                Text("Hello, World!")
            }
            
            .navigationBarItems(
                trailing: Button(action: {
                    viewModel.signOut()
                }) {
                    Text("Sign Out")
                })
        }
    }
}

#Preview {
    MatchingView()
}
