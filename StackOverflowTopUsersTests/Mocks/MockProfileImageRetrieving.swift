//
//  MockProfileImageRetrieving.swift
//  StackOverflowTopUsersTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
@testable import StackOverflowTopUsers
import UIKit

class MockProfileImageRetrieving: ProfileImageRetrieving {
    private(set) var receivedUser: User?
    private(set) var receivedCompletion: ((Result<UIImage, Error>) -> Void)?

    var vendedCancellable: Cancellable?

    func profileImage(for user: User, completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable {
        receivedUser = user
        receivedCompletion = completion
        guard let cancellable = vendedCancellable else {
            fatalError("No cancellable set on profile image retriever")
        }
        return cancellable
    }
}
