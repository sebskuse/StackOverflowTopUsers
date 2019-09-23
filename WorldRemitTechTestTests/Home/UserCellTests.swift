//
//  UserCellTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

@testable import WorldRemitTechTest
import XCTest

class UserCellTests: XCTestCase {
    var cell: UserCell!
    var imageRetriever: MockProfileImageRetrieving!
    var cancellable: MockCancellable!

    override func setUp() {
        super.setUp()
        cancellable = MockCancellable()
        imageRetriever = MockProfileImageRetrieving()
        imageRetriever.vendedCancellable = cancellable
        cell = UserCell.loadFromNib()
        cell.viewModel = UserCellViewModel(imageContext: imageRetriever)
    }

    override func tearDown() {
        super.tearDown()
        cell = nil
        imageRetriever = nil
        cancellable = nil
    }

    func testWhenAUserIsSetTheProfileImageIsRetrieved() {
        XCTAssertNil(imageRetriever.receivedUser)
        cell.viewModel.model = User(displayName: "Test", profileImage: testURL(), reputation: 1)
        XCTAssertEqual(imageRetriever.receivedUser?.displayName, "Test")
    }

    func testWhenAValidImageIsReturnedItIsSetInTheCell() throws {
        cell.viewModel.model = User(displayName: "Test", profileImage: testURL(), reputation: 1)
        let image = try testImage(named: "sampleProfilePic")
        imageRetriever.receivedCompletion?(.success(image))
        XCTAssertEqual(image, cell.profileImageView.image)
    }

    func testIfTheCellIsReusedWhileARequestIsInProgressItGetsCancelled() {
        cell.viewModel.model = User(displayName: "Test", profileImage: testURL(), reputation: 1)
        cell.prepareForReuse()
        XCTAssertTrue(cancellable.receivedCancel)
    }
}

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
