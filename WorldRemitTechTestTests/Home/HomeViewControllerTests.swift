//
//  HomeViewControllerTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Nimble
@testable import WorldRemitTechTest
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
        expect(self.mockContext.receivedCompletion).to(beNil())
        viewController.loadViewIfNeeded()
        expect(self.mockContext.receivedCompletion).notTo(beNil())
        expect(self.viewController.loadingSpinner.isAnimating).to(beTrue())
    }

    func testWhenAnErrorIsReceivedTheErrorLabelShowsTheErrorAndHidesTheTable() {
        viewController.loadViewIfNeeded()
        expect(self.viewController.errorLabel.isHidden).to(beTrue())
        mockContext.receivedCompletion?(.failure(MockError.test))
        expect(self.viewController.errorLabel.isHidden).to(beFalse())
        expect(self.viewController.errorLabel.text).to(equal("Mock Error"))
        expect(self.viewController.tableView.isHidden).to(beTrue())
    }

    func testWhenUsersAreRetrievedItClearAnyPreExistingError() {
        viewController.viewModel.error.value = DisplayableError(message: "Error", underlying: MockError.test)
        viewController.loadViewIfNeeded()
        mockContext.receivedCompletion?(.success([User(displayName: "Test", profileImage: testURL(), reputation: 1)]))
        expect(self.viewController.errorLabel.isHidden).to(beTrue())
        expect(self.viewController.errorLabel.text).to(beNil())
    }
}
