//
//  Request.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

/// Defines the behaviour of a network request.
protocol Request {
    /// The URL to fetch
    var url: URL { get }

    /// The HTTP method for this request
    var method: HTTPMethod { get }

    /// The headers for the request
    var headers: [String: String] { get }

    /// The body of the request
    var body: Data? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    /// etc... only supplying the ones I need here for brevity.
}
