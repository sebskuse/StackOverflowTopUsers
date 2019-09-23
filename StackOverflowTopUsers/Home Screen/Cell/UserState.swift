//
//  UserState.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

/// This would obviously be a network call usually, rather than
/// just setting bools on this. I prefer to have immutable models,
/// so ideally the API would return the new user object which I can
/// just replace the local copy with to update the UI with.
class UserState {
    enum State {
        case notFollowing
        case following
        case blocked
    }

    let user: User
    var expanded: Bool
    var state: State

    init(user: User, expanded: Bool = false, state: State = .notFollowing) {
        self.user = user
        self.expanded = expanded
        self.state = state
    }
}
