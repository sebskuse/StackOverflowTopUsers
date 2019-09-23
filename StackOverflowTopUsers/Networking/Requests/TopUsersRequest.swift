//
//  TopUsersRequest.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

struct TopUsersRequest: Request {
    let url: URL
    let method: HTTPMethod = .get
    let headers: [String: String] = [:]
    let body: Data? = nil

    init(limit: Int = 20) {
        // Generally these request objects represent an endpoint
        var components = URLComponents(string: "https://api.stackexchange.com/2.2/users")
        components?.queryItems = [
            URLQueryItem(name: "pagesize", value: String(describing: limit)),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "sort", value: "reputation"),
            URLQueryItem(name: "site", value: "stackoverflow"),
        ]
        // Force unwrapping this here because, in this instance, we know this
        // URL will always be valid. If we're creating this URL based off params
        // that might cause URL creation to fail, this should be guard unwrapped
        // and the initialiser becomes a throwing one.
        url = components!.url!
    }
}
