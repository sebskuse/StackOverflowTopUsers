//
//  TopUsersContextTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Nimble
@testable import WorldRemitTechTest
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
        expect(self.session.receivedRequest).to(beAKindOf(TopUsersRequest.self))
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
        expect(users).to(haveCount(1))
        expect(users?.first?.displayName).to(equal("Test User"))
    }
}
