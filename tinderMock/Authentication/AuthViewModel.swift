//
//  AuthViewModel.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in")
    }
    
    func createUser(withEmail email: String, password: String, first_name: String, last_name: String, dob: Date, gender: Gender, sexuality: Sexuality) async throws {
        print("Create user")
    }
    
    func signOut() {
        
    }
    
    func fetchUser() async {
        
    }
}

