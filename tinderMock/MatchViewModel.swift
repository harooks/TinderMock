//
//  MatchViewModel.swift
//  tinderMock
//
//  Created by Haruko Okada on 12/2/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

@MainActor
class MatchViewModel: ObservableObject {
    @EnvironmentObject var authVM: AuthViewModel
    @Published var users: [User] = []
    // Dictionary to keep track of matches
    @Published var usersMatchId: [String] = []
    @Published var matchedUsers: [User] = []

    var partnerPreferences: [String: [String]] = [:]
    let db = Firestore.firestore()
    
    func fetchUsers() {
        let usersCollection = db.collection("users")
        let currentUser = Auth.auth().currentUser
        var currentUserGender = ""
        var currentUserSexuality = ""
        var partnerGenderPreferences: [String: [String]] = [:]
        var partnerSexualityPreferences: [String: [String]] = [:]
        
        func handleUserData(fetchedGender: String, fetchedSexuality: String) {

            print("Fetched gender: \(fetchedGender)")

            switch fetchedGender {
            case "Female":
                partnerGenderPreferences = ["Heterosexual": ["Male"], "Homosexual": ["Female"], "Bisexual": ["Female", "Male"], "Pansexual": ["Female", "Male", "Other"]]
            case "Male":
                partnerGenderPreferences = ["Heterosexual": ["Female"], "Homosexual": ["Male"], "Bisexual": ["Female", "Male"], "Pansexual": ["Female", "Male", "Other"]]
            default:
                partnerGenderPreferences = ["Heterosexual": ["Female", "Male", "Other"], "Homosexual": ["Female", "Male", "Other"], "Bisexual": ["Female", "Male", "Other"], "Pansexual": ["Female", "Male", "Other"]]
            }
        }
        
        // get current user's gender and sexuality
        usersCollection.whereField("id", isEqualTo: currentUser?.uid)
            .getDocuments() { (querySnapshot, err) in
                print("Fetching gender and sex")
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("Document found: \(document)")
                        let fetchedGender = document.get("gender") as? String ?? "Other"
                        let fetchedSexuality = document.get("sexuality") as? String ?? "Heterosexual"
                        let fetchedEmail = document.get("email") as? String ?? ""
                        currentUserGender = fetchedGender
                        currentUserSexuality = fetchedSexuality

                        // Handle the fetched data using the defined function
                        handleUserData(fetchedGender: fetchedGender, fetchedSexuality: fetchedSexuality)
                        secondQuery(currentUserGender, currentUserSexuality, fetchedEmail)
                    }
                }
        }
        
        func secondQuery(_ gender: String, _ sexuality: String,_ currentUserEmail: String) {
            
            db.collection("users")
//                .whereField("id", isNotEqualTo: currentUserid)
                .whereField("gender", in: partnerGenderPreferences[sexuality] ?? [])
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching users: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("No users found")
                        return
                    }
                    
                    self.users = documents.compactMap { document in
                        do {
                            let user = try document.data(as: User.self)
                            if user.email != currentUserEmail {
                                return user
                            } else {
                                return nil
                            }

                        } catch {
                            print("Error decoding user: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
    
    func swiped(swipedUser: User, liked: Bool) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user")
            return
        }
        
        let combinedId = "\(currentUser.uid)_\(swipedUser.id)"
        
        let swipeCollection = Firestore.firestore().collection("swipes")
        let documentRef = swipeCollection.document(combinedId)
        
        let data: [String: Any] = [
            "liked": liked,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        documentRef.setData(data, merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func getAllMatches() async {
        
        var matchesDict: [String: [String]] = [:]
        
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user")
            return
        }
        
        let currentUserId = currentUser.uid
        
        do {
            let snapshot = try await db.collection("swipes").getDocuments()
            snapshot.documents.forEach { document in
                // Parse document name (document.documentID) to get user IDs
                let splitId = document.documentID.components(separatedBy: "_")
                let curUserId = splitId[0]
                let swipedUserId = splitId[1]

                // Check if "liked" field is true
                if let likedByUser = document.data()["liked"] as? Bool, likedByUser {
                    // Append swipedUserId to the array for curUserId
                    if var existingMatches = matchesDict[curUserId] {
                        existingMatches.append(swipedUserId)
                        matchesDict[curUserId] = existingMatches
                    } else {
                        matchesDict[curUserId] = [swipedUserId]
                    }
                }
            }
        
            self.matchedUsers = await findMatches(curUserId: currentUserId, allMatches: matchesDict)
//            print(usersMatch)
        } catch {
            // Handle the error here
            print("Error fetching documents: \(error)")
        }
        
    }
    
    func findMatches(curUserId: String, allMatches: [String: [String]]) -> [User] {
        guard let matchedUserIds = allMatches[curUserId] else {
            return []
        }
        
        db.collection("users")
            .whereField("id", in: matchedUserIds)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No users found")
                    return
                }
                
                self.matchedUsers = documents.compactMap { document in
                    do {
                        let user = try document.data(as: User.self)
                        return user
                    } catch {
                        print("Error decoding user: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
        
        return matchedUsers
    }
}
