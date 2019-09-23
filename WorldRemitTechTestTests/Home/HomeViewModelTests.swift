//
//  HomeViewModelTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

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
        XCTAssertFalse(viewModel.isLoading.value)
        viewModel.fetchUsers()
        XCTAssertTrue(viewModel.isLoading.value)
        XCTAssertNotNil(context.receivedCompletion)
        context.receivedCompletion?(.success([User(displayName: "Test", profileImage: testURL(), reputation: 1)]))
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertEqual(viewModel.users.value.count, 1)
        XCTAssertEqual(viewModel.users.value.first?.displayName, "Test")
    }

    func testWhenThereIsAnErrorTheErrorPropertyIsUpdated() {
        viewModel.fetchUsers()
        context.receivedCompletion?(.failure(MockError.test))
        XCTAssertNotNil(viewModel.error.value)
        XCTAssertFalse(viewModel.isLoading.value)
    }

    func testWhenFetchingIsRetriedAfterAnErrorTheErrorIsClearedIfItIsSuccessful() {
        viewModel.error.value = DisplayableError(message: "Error", underlying: MockError.test)
        viewModel.fetchUsers()
        context.receivedCompletion?(.success([User(displayName: "Test", profileImage: testURL(), reputation: 1)]))
        XCTAssertNil(viewModel.error.value)
        XCTAssertEqual(viewModel.users.value.count, 1)
    }
}

enum MockError: LocalizedError {
    case test

    var errorDescription: String? {
        return "Mock Error"
    }
}
