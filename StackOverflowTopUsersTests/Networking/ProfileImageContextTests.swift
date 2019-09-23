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

    func testAttemptingToParseNoDataReturnsTheCorrectError() throws {
        let result = ProfileImage.parse(data: nil, response: nil, error: nil)
        guard case let .failure(error) = result, let err = error as? SessionError else {
            XCTFail("Did not get a failure")
            return
        }
        guard case .noData = err else {
            XCTFail("Incorrect error received")
            return
        }
    }

    func testPassingANonHTTPResponseReturnsTheCorrectError() throws {
        let data = "{}".data(using: .utf8)!
        let urlResponse = URLResponse(url: testURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        let response = ProfileImage.parse(data: data, response: urlResponse, error: nil)

        guard case let .failure(error) = response, let err = error as? SessionError else {
            XCTFail("Did not get a failure")
            return
        }
        guard case .invalidResponse = err else {
            XCTFail("Incorrect error received")
            return
        }
    }

    func testPassingJunkNonImageDataReturnsTheCorrectFailure() throws {
        let result = ProfileImage.parse(data: Data(), response: testURLResponse(status: 200), error: nil)
        guard case let .failure(error) = result, let err = error as? ImageError else {
            XCTFail("Did not get a failure")
            return
        }
        guard case .unableToCreateImage = err else {
            XCTFail("Incorrect error received")
            return
        }
    }
}
