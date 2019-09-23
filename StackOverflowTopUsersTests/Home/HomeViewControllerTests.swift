//
//  HomeViewControllerTests.swift
//  StackOverflowTopUsersTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

@testable import StackOverflowTopUsers
import XCTest

class HomeViewControllerTests: XCTestCase {
    var viewController: HomeViewController!
    var mockContext: MockTopUsersRetrieving!

    override func setUp() {
        super.setUp()
        mockContext = MockTopUsersRetrieving()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeView = storyboard.instantiateInitialViewController() as? HomeViewController else {
            preconditionFailure("Initial view contorller is not the home VC")
        }
        viewController = homeView
        viewController.viewModel = HomeViewModel(context: mockContext)
    }

    override func tearDown() {
        super.tearDown()
        viewController = nil
        mockContext = nil
    }

    func testWhenTheViewControllerLoadsTheListOfUsersIsRetrieved() {
        XCTAssertNil(mockContext.receivedCompletion)
        viewController.loadViewIfNeeded()
        XCTAssertNotNil(mockContext.receivedCompletion)
        XCTAssertTrue(viewController.loadingSpinner.isAnimating)
    }

    func testWhenAnErrorIsReceivedTheErrorLabelShowsTheErrorAndHidesTheTable() {
        viewController.loadViewIfNeeded()
        XCTAssertTrue(viewController.errorLabel.isHidden)
        mockContext.receivedCompletion?(.failure(MockError.test))
        XCTAssertFalse(viewController.errorLabel.isHidden)
        XCTAssertEqual(viewController.errorLabel.text, "Mock Error")
        XCTAssertTrue(viewController.tableView.isHidden)
    }

    func testWhenUsersAreRetrievedItClearAnyPreExistingError() {
        viewController.viewModel.error.value = DisplayableError(message: "Error", underlying: MockError.test)
        viewController.loadViewIfNeeded()
        mockContext.receivedCompletion?(.success([User(displayName: "Test", profileImage: testURL(), reputation: 1)]))
        XCTAssertTrue(viewController.errorLabel.isHidden)
        XCTAssertNil(viewController.errorLabel.text)
    }

    func testWhenUsersAreLoadedThereAreCellsForEachUser() {
        givenUsersHaveLoaded()
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), 2)
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell as? UserCell)
    }

    func testTappingARowExpandsIt() throws {
        givenUsersHaveLoaded()
        var cell = try givenACell()
        XCTAssertFalse(cell.viewModel.expanded.value)

        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        cell = try givenACell()

        XCTAssertTrue(cell.viewModel.expanded.value)
    }

    private func givenACell() throws -> UserCell {
        enum DequeueError: Error {
            case noCell
        }
        guard let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserCell else {
            XCTFail("Could not dequeue cell")
            throw DequeueError.noCell
        }
        return cell
    }

    private func givenUsersHaveLoaded() {
        let users = [
            User(displayName: "Test", profileImage: testURL(), reputation: 1),
            User(displayName: "Test2", profileImage: testURL(), reputation: 2),
        ]
        viewController.loadViewIfNeeded()
        mockContext.receivedCompletion?(.success(users))
    }
}
