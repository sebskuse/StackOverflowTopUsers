//
//  ProfileImageContextTests.swift
//  StackOverflowTopUsersTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

@testable import StackOverflowTopUsers
import XCTest

class ProfileImageContextTests: XCTestCase {
    var context: ProfileImageContext!
    var session: MockSession<ProfileImage>!

    override func setUp() {
        super.setUp()
        session = MockSession()
        context = ProfileImageContext(session: session)
    }

    override func tearDown() {
        super.tearDown()
        session = nil
        context = nil
    }

    func testRetrievingAProfileImageMakesTheCorrectRequest() {
        let user = User(accountId: 1, displayName: "test", profileImage: testURL(), reputation: 1)
        _ = context.profileImage(for: user, completion: { _ in })
        XCTAssertNotNil(session.receivedRequest as? ProfileImageRequest)
        XCTAssertEqual(session.receivedRequest?.url.absoluteString, "http://localhost.com")
    }

    func testAnImageCanBeReturned() throws {
        let image = try testImage(named: "sampleProfilePic")
        var result: Result<UIImage, Error>?

        let user = User(accountId: 1, displayName: "test", profileImage: testURL(), reputation: 1)
        _ = context.profileImage(for: user, completion: { res in
            result = res
        })

        session.receivedCompletion?(ProfileImage.parse(data: image.jpegData(compressionQuality: 1.0), response: testURLResponse(status: 200), error: nil))

        let receivedImage = try result?.get()

        XCTAssertNotNil(receivedImage)
    }
}
