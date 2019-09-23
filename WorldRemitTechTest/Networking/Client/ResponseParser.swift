//
//  ResponseParser.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

protocol ResponseParser {
    /// Handles the raw URLResponse -> Decodable unwrapping.
    /// Split out so it can be tested.
    ///
    /// - Parameters:
    ///   - data: Data received in response to the URLSession task.
    ///   - response: Response received in response to the URLSession task.
    ///   - error: Error received, if any, from the URLSession task.
    /// - Returns: The result of attempting to parse the response.
    func parse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, Error>
}

class StandardResponseParser: ResponseParser {
    func parse<T>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, Error> where T: Decodable {
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
