//
//  MockTopUsersRetrieving.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
@testable import WorldRemitTechTest

class MockTopUsersRetrieving: TopUsersRetrieving {
    private(set) var receivedCompletion: ((Result<[User], Error>) -> Void)?

    func retrieveTopUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        receivedCompletion = completion
    }
}
