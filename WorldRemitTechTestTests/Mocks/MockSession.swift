//
//  MockSession.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
@testable import WorldRemitTechTest

class MockSession<R: Parsable>: Session {
    private(set) var receivedRequest: Request?
    private(set) var receivedCompletion: ((Result<R, Error>) -> Void)?
    private(set) var vendedCancellable: MockCancellable?

    func perform<T>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: Parsable {
        receivedRequest = request
        receivedCompletion = completion as? ((Result<R, Error>) -> Void)
        let cancellable = MockCancellable()
        vendedCancellable = cancellable
        return cancellable
    }
}

class MockCancellable: Cancellable {
    private(set) var receivedCancel: Bool = false

    func cancel() {
        receivedCancel = true
    }
}
