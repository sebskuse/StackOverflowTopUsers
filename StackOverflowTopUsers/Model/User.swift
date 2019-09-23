//
//  User.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

struct User: Codable {
    let accountId: Int
    let displayName: String
    let profileImage: URL
    let reputation: Int
}
