//
//  LoginView.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            
            //login form
            VStack(spacing: 20) {
                InputView(text: $email, title: "Email", placeholder: "Enter email")
                InputView(text: $password, title: "Password", placeholder: "Enter password", isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top,20)
            
            //sign in button
            Button {
                Task {
                    try await viewModel.signIn(withEmail:email, password: password)
                }
            } label: {
                Text("Sign in")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 40)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)
                            
            //sign up button
            NavigationLink {
                
            } label: {
                VStack(spacing: 5) {
                    Text("Don't have an account?")
                    Text("Sign up")
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 40)

        }
    }
}

#Preview {
    LoginView()
}
