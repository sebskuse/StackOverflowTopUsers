//
//  HomeViewModelTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Nimble
@testable import WorldRemitTechTest
import XCTest

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var context: MockTopUsersRetrieving!

    override func setUp() {
        super.setUp()
        context = MockTopUsersRetrieving()
        viewModel = HomeViewModel(context: context)
    }

    override func tearDown() {
        super.tearDown()
        context = nil
        viewModel = nil
    }

    func testRetrievingUsersUpdatesTheUsersPropertyAndLoadingState() {
        expect(self.viewModel.isLoading.value).to(beFalse())
        viewModel.fetchUsers()
        expect(self.viewModel.isLoading.value).to(beTrue())
        expect(self.context.receivedCompletion).notTo(beNil())
        context.receivedCompletion?(.success([User(displayName: "Test", profileImage: testURL(), reputation: 1)]))
        expect(self.viewModel.isLoading.value).to(beFalse())
        expect(self.viewModel.users.value).to(haveCount(1))
        expect(self.viewModel.users.value.first?.displayName).to(equal("Test"))
    }

    func testWhenThereIsAnErrorTheErrorPropertyIsUpdated() {
        viewModel.fetchUsers()
        context.receivedCompletion?(.failure(MockError.test))
        expect(self.viewModel.error.value).notTo(beNil())
        expect(self.viewModel.isLoading.value).to(beFalse())
    }

    func testWhenFetchingIsRetriedAfterAnErrorTheErrorIsClearedIfItIsSuccessful() {
        viewModel.error.value = DisplayableError(message: "Error", underlying: MockError.test)
        viewModel.fetchUsers()
        context.receivedCompletion?(.success([User(displayName: "Test", profileImage: testURL(), reputation: 1)]))
        expect(self.viewModel.error.value).to(beNil())
        expect(self.viewModel.users.value).to(haveCount(1))
    }
}

enum MockError: LocalizedError {
    case test

    var errorDescription: String? {
        return "Mock Error"
    }
}
