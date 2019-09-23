//
//  MockUserCellDelegate.swift
//  StackOverflowTopUsersTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
@testable import StackOverflowTopUsers
import UIKit

class MockUserCellDelegate: UserCellDelegate {
    enum ReceivedCall {
        case block
        case follow
        case unfollow
    }

    private(set) var receivedCell: UserCell?
    private(set) var receivedUser: User?
    private(set) var receivedCall: ReceivedCall?

    func userCell(_ cell: UserCell, requestingBlockUser user: User) {
        receivedCell = cell
        receivedUser = user
        receivedCall = .block
    }

    func userCell(_ cell: UserCell, requestingFollowUser user: User) {
        receivedCell = cell
        receivedUser = user
        receivedCall = .follow
    }

    func userCell(_ cell: UserCell, requestingUnfollowUser user: User) {
        receivedCell = cell
        receivedUser = user
        receivedCall = .unfollow
    }
}
