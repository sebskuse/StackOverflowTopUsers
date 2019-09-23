//
//  Session.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

protocol Session {
    /// Performs a network operation using the specified `Request`, returning
    /// the result in `completion`.
    ///
    /// - Parameters:
    ///   - request: The request to make
    ///   - completion: The closure to call on completion, successful or otherwise.
    func perform<T: Decodable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void)
}

/// A thin wrapper around `URLSession` to provide testability.
class NetworkSession: Session {
    private let session: URLSession
    private let parser: ResponseParser

    init(session: URLSession = .shared, parser: ResponseParser = StandardResponseParser()) {
        self.session = session
        self.parser = parser
    }

    func perform<T: Decodable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) {
        /// Call back on the calling queue, or the main if that's unspecified.
        let callingQueue: OperationQueue = .current ?? .main

        let task = session.dataTask(with: request.urlRequest) { [weak self] data, response, error in
            // If the session's gone away, just bail here.
            guard let self = self else { return }
            // Perform the parsing on the queue URLSession calls back on to prevent
            // the UI getting sticky.
            let result: Result<T, Error> = self.parser.parse(data: data, response: response, error: error)
            callingQueue.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
}

extension Request {
    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url)

        headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        urlRequest.httpMethod = method.rawValue
        if let body = body {
            urlRequest.httpBody = body
        }
        return urlRequest
    }
}
