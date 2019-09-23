//
//  ProfileImageRequest.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

struct ProfileImageRequest: Request {
    let url: URL
    let method: HTTPMethod = .get
    let headers: [String: String] = [:]
    let body: Data? = nil
}
