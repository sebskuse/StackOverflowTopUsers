//
//  MockSession.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
@testable import WorldRemitTechTest

class MockSession<R: Decodable>: Session {
    private(set) var receivedRequest: Request?
    private(set) var receivedCompletion: ((Result<R, Error>) -> Void)?

    func perform<T>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        receivedRequest = request
        receivedCompletion = completion as? ((Result<R, Error>) -> Void)
    }
}
