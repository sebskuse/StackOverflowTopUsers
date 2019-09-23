//
//  HomeViewModel.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

class HomeViewModel {
    private let context: TopUsersRetrieving

    let users = Bindable<[User]>([])
    let isLoading = Bindable<Bool>(false)
    let error = Bindable<DisplayableError?>(nil)

    init(context: TopUsersRetrieving = TopUsersContext()) {
        self.context = context
    }

    func fetchUsers() {
        isLoading.value = true
        context.retrieveTopUsers { [weak self] res in
            switch res {
            case let .success(users):
                self?.error.value = nil
                self?.users.value = users
            case let .failure(error):
                // DisplayableError is here so if we want to do something
                // more intelligent than just using the `localizedDescription`.
                self?.error.value = DisplayableError(message: error.localizedDescription, underlying: error)
            }
            self?.isLoading.value = false
        }
    }
}

struct DisplayableError: Error {
    let message: String
    let underlying: Error
}
