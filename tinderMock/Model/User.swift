//
//  User.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import Foundation

struct User: Identifiable, Encodable, Decodable {
    let id: String
    let email: String
    let first_name: String
    let last_name: String
    let dob: Date
    let gender: Gender
    let sexuality: Sexuality
}
