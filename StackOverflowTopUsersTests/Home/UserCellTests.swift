//
//  UserCellTests.swift
//  StackOverflowTopUsersTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

@testable import StackOverflowTopUsers
import XCTest

class UserCellTests: XCTestCase {
    var cell: UserCell!
    var imageRetriever: MockProfileImageRetrieving!
    var cancellable: MockCancellable!
    // swiftlint:disable:next weak_delegate
    var delegate: MockUserCellDelegate!

    override func setUp() {
        super.setUp()
        delegate = MockUserCellDelegate()
        cancellable = MockCancellable()
        imageRetriever = MockProfileImageRetrieving()
        imageRetriever.vendedCancellable = cancellable
        cell = UserCell.loadFromNib()
        cell.viewModel = UserCellViewModel(imageContext: imageRetriever)
        cell.delegate = delegate
    }

    override func tearDown() {
        super.tearDown()
        cell = nil
        imageRetriever = nil
        cancellable = nil
        delegate = nil
    }

    func testWhenAUserIsSetTheProfileImageIsRetrieved() {
        XCTAssertNil(imageRetriever.receivedUser)
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1))
        XCTAssertEqual(imageRetriever.receivedUser?.displayName, "Test")
    }

    func testWhenAValidImageIsReturnedItIsSetInTheCell() throws {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1))
        let image = try testImage(named: "sampleProfilePic")
        imageRetriever.receivedCompletion?(.success(image))
        XCTAssertEqual(image, cell.profileImageView.image)
    }

    func testIfTheCellIsReusedWhileARequestIsInProgressItGetsCancelled() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1))
        cell.prepareForReuse()
        XCTAssertTrue(cancellable.receivedCancel)
    }

    func testWhenTheStateIsNotFollowingTheActionButtonIsFollow() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .notFollowing)
        XCTAssertEqual(cell.followActionButton.currentTitle, "Follow")
    }

    func testWhenTheStateIsFollowingTheActionButtonIsUnfollow() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .following)
        XCTAssertEqual(cell.followActionButton.currentTitle, "Unfollow")
    }

    func testTappingTheBlockButtonSendsTheAppropriateMessage() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .following)
        cell.blockButton.sendActions(for: .primaryActionTriggered)
        XCTAssertEqual(delegate.receivedCall, .block)
        XCTAssertEqual(delegate.receivedCell, cell)
        XCTAssertEqual(delegate.receivedUser?.displayName, "Test")
    }

    func testTappingTheFollowButtonSendsTheAppropriateMessage() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .following)
        cell.followActionButton.sendActions(for: .primaryActionTriggered)
        XCTAssertEqual(delegate.receivedCall, .unfollow)
        XCTAssertEqual(delegate.receivedCell, cell)
        XCTAssertEqual(delegate.receivedUser?.displayName, "Test")
    }

    func testTappingTheUnfollowButtonSendsTheAppropriateMessage() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .notFollowing)
        cell.followActionButton.sendActions(for: .primaryActionTriggered)
        XCTAssertEqual(delegate.receivedCall, .follow)
        XCTAssertEqual(delegate.receivedCell, cell)
        XCTAssertEqual(delegate.receivedUser?.displayName, "Test")
    }

    func testTheCellStateIsConfiguredCorrectlyForFollowing() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .following)
        XCTAssertEqual(cell.accessoryType, .checkmark)
        XCTAssertEqual(cell.backgroundColor, .white)
    }

    func testTheCellStateIsConfiguredCorrectlyForUnfollowing() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .notFollowing)
        XCTAssertEqual(cell.accessoryType, .none)
        XCTAssertEqual(cell.backgroundColor, .white)
    }

    func testTheCellIsGreyedOutForBlocked() {
        cell.viewModel.model = UserState(user: User(displayName: "Test", profileImage: testURL(), reputation: 1), state: .blocked)
        XCTAssertEqual(cell.backgroundColor, .gray)
    }
}
