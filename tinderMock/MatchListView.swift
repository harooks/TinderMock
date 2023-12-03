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
        List(matchVM.matchedUsers) { userMatch in
            Text(userMatch.first_name)
                .foregroundColor(.black)
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
