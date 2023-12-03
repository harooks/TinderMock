//
//  MatchListView.swift
//  tinderMock
//
//  Created by Haruko Okada on 12/3/23.
//

import SwiftUI
import FirebaseCore

struct MatchListView: View {
    @EnvironmentObject var matchVM: MatchViewModel
    @State var matchedUserNames: [String] = [] // State to store matched user names
    
    var body: some View {
        List(matchVM.usersMatch, id: \.self) { userMatch in
            Text(userMatch)
                .foregroundColor(.white)
        }
        .background(Color.blue)
        .onAppear {
            Task {
                // Fetch matched users when loading view
                await matchVM.getAllMatches()
            }
        }
    }
}

#Preview {
    MatchListView()
}
