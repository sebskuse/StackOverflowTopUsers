//
//  TopUsersContextTests.swift
//  StackOverflowTopUsersTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

@testable import StackOverflowTopUsers
import XCTest

class TopUsersContextTests: XCTestCase {
    var context: TopUsersContext!
    var session: MockSession<UsersResponse>!

    override func setUp() {
        super.setUp()
        session = MockSession()
        context = TopUsersContext(session: session)
    }

    override func tearDown() {
        super.tearDown()
        session = nil
        context = nil
    }

    func testRetrievingUsersMakesTheCorrectRequest() {
        context.retrieveTopUsers(completion: { _ in })
        XCTAssertNotNil(session.receivedRequest as? TopUsersRequest)
    }

    func testRetrievingUsersReturnsTheUsersResponseUsersPayload() throws {
        var result: Result<[User], Error>?
        context.retrieveTopUsers(completion: { res in
            result = res
        })
        let user = User(displayName: "Test User", profileImage: testURL(), reputation: 1)
        let response = UsersResponse(items: [user])
        session.receivedCompletion?(.success(response))
        let users = try result?.get()
        XCTAssertEqual(users?.count, 1)
        XCTAssertEqual(users?.first?.displayName, "Test User")
    }
}
