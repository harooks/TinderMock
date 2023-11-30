//
//  ContentView.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MatchingView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
