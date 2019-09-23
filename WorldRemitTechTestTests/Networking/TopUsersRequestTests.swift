//
//  TopUsersRequestTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

@testable import WorldRemitTechTest
import XCTest

class TopUsersRequestTests: XCTestCase {
    func testTheRequestIsSetUpCorrectly() {
        let request = TopUsersRequest()
        XCTAssertEqual(request.headers, [:])
        XCTAssertEqual(request.method, .get)
        XCTAssertNil(request.body)
        XCTAssertEqual(request.url.absoluteString, "https://api.stackexchange.com/2.2/users?pagesize=20&order=desc&sort=reputation&site=stackoverflow")
    }

    func testThePageSizeCanBeChanged() {
        let request = TopUsersRequest(limit: 30)
        XCTAssertEqual(request.url.absoluteString, "https://api.stackexchange.com/2.2/users?pagesize=30&order=desc&sort=reputation&site=stackoverflow")
    }
}
