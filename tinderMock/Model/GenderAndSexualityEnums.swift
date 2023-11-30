//
//  GenderAndSexualityEnums.swift
//  tinderMock
//
//  Created by Haruko Okada on 11/30/23.
//

import Foundation
import SwiftUI

enum Gender: String,Equatable, CaseIterable {
    case female = "Female"
    case male = "Male"
    case other = "Other"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

enum Sexuality: String, Equatable, CaseIterable {
    case heterosexual = "Heterosexual"
    case homosexual = "Homosexual"
    case bisexual = "Bisexual"
    case pansexual = "Pansexual"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

