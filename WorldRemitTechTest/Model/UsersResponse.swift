//
//  UsersResponse.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

struct UsersResponse: Codable {
    let items: [User]
}

extension UsersResponse: Parsable {
    static func parse(data: Data?, response: URLResponse?, error: Error?) -> Result<UsersResponse, Error> {
        return StandardResponseParser.parse(data: data, response: response, error: error)
    }
}
