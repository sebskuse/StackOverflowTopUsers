//
//  StandardResponseParser.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

struct StandardResponseParser {
    static func parse<T>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, Error> where T: Decodable {
        guard let data = data else {
            return .failure(SessionError.noData)
        }
        guard let response = response as? HTTPURLResponse else {
            return .failure(SessionError.invalidResponse)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        if response.statusCode < 400 {
            do {
                let result = try decoder.decode(T.self, from: data)
                return .success(result)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(SessionError.statusError(status: response.statusCode))
        }
    }
}
