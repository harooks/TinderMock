//
//  UserCardView.swift
//  tinderMock
//
//  Created by Haruko Okada on 12/2/23.
//

import SwiftUI

struct UserCardView: View {
    let user: User

    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void

    var body: some View {
        var user_age = calcAge(birthday: user.dob)
        // Use Rectangle as a container
        Rectangle()
                    .fill(Color.white) // Set background color to white
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                    .cornerRadius(10) // Optional: Add corner radius for styling
                    
                    // Your user card content
                    .overlay(
                        VStack {
                            Text("Name: \(user.first_name)")
                                .foregroundColor(.black)
                            Text("Age: \(user_age)")
                                .foregroundColor(.black)
                        }
//                        Text("Name: \(user.first_name)")
//                            .padding()
//                            .foregroundColor(.black)
    
                    )
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 0 {
                            // User swiped right (like)
                            self.onSwipeRight()
                        } else {
                            // User swiped left (dislike)
                            self.onSwipeLeft()
                        }
                    }
            )
    }
    
    private func calcAge(birthday: Date) -> Int {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "MM/dd/yyyy"
//        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthday, to: now, options: [])
        let age = calcAge.year
        return age!
    }
}
