//
//  TopUsersContext.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

protocol TopUsersRetrieving {
    /// Retrieves the top users by reputation.
    /// - Parameter completion: A closure called on retrieval.
    func retrieveTopUsers(completion: @escaping (Result<[User], Error>) -> Void)
}

class TopUsersContext: TopUsersRetrieving {
    private let session: Session

    init(session: Session = NetworkSession()) {
        self.session = session
    }

    func retrieveTopUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        session.perform(TopUsersRequest()) { (result: Result<UsersResponse, Error>) in
            completion(result.map { $0.items })
        }
    }
}
