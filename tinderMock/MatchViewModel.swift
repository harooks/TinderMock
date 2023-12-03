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

class MatchViewModel: ObservableObject {
    @EnvironmentObject var authVM: AuthViewModel
    @Published var users: [User] = []
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
                        print("current gender and sex: \(currentUserGender)\(currentUserSexuality)")
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

}
