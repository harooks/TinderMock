//
//  AuthViewModel.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in")
    }
    
    func createUser(withEmail email: String, password: String, first_name: String, last_name: String, dob: Date, gender: Gender, sexuality: Sexuality) async throws {
        print("Create user")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, first_name: first_name, last_name: last_name, dob: dob, gender: gender, sexuality: sexuality)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        
    }
    
    func fetchUser() async {

    }
}

