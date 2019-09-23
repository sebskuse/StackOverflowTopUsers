//
//  Session.swift
//  StackOverflowTopUsers
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
    @discardableResult
    func perform<T: Parsable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}

/// A thin wrapper around `URLSession` to provide testability.
class NetworkSession: Session {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    @discardableResult
    func perform<T: Parsable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        /// Call back on the calling queue, or the main if that's unspecified.
        let callingQueue: OperationQueue = .current ?? .main

        let task = session.dataTask(with: request.urlRequest) { data, response, error in
            // Perform the parsing on the queue URLSession calls back on to prevent
            // the UI getting sticky.
            let result: Result<T, Error> = T.parse(data: data, response: response, error: error)
            callingQueue.addOperation {
                completion(result)
            }
        }
        task.resume()
        return task
    }
}

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {}

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
