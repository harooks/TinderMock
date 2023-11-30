//
//  RegistrationView.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var first_name = ""
    @State private var last_name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var dob = Date.now
    @State private var gender = Gender.male
    @State private var sexuality = Sexuality.heterosexual
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            InputView(text: $first_name, title: "First name", placeholder: "Enter first name")
            InputView(text: $last_name, title: "Last name", placeholder: "Enter last name")
            
            // dob picker
            DatePicker(
                "Date of Birth",
                selection: $dob,
                displayedComponents: [.date]
            )
            .foregroundColor(Color(.darkGray))
            .fontWeight(.semibold)
            .font(.footnote)
            .datePickerStyle(CompactDatePickerStyle())
            .frame(height: 50)
            
            // gender and sexuality picker
            HStack {
                Text("Gender")
                    .foregroundColor(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.footnote)
                Picker("Gender", selection: $gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .pickerStyle(DefaultPickerStyle())
            }
            
            HStack {
                Text("Sexuality")
                    .foregroundColor(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.footnote)
                Picker("Sexuality", selection: $sexuality) {
                    ForEach(Sexuality.allCases, id: \.self) { sex in
                        Text(sex.rawValue).tag(sex)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .pickerStyle(DefaultPickerStyle())
            }
            .padding(.bottom, 10)

                    
            InputView(text: $email, title: "Email", placeholder: "Enter email")
            InputView(text: $password, title: "Password", placeholder: "Enter password", isSecureField: true)
            
            // sign up button
            Button {
                print("signing up")
            } label: {
                Text("Sign up")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 40)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)
            
            // go back to sign in
            Button {
                dismiss()
            } label: {
                VStack(spacing: 5) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 40)
        }
        .padding(.horizontal)
    }
}

#Preview {
    RegistrationView()
}
