//
//  Profile.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/12/12.
//

import Foundation

struct Profile: Hashable, Identifiable {
    let _id: String
    let nick: String
    let email: String
    let posts: [String]
    let followers: [String]
    let following: [String]
    let profileImageString: String?

    let id = UUID()
}
