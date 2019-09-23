//
//  TopUsersRequestTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Nimble
@testable import WorldRemitTechTest
import XCTest

class TopUsersRequestTests: XCTestCase {
    func testTheRequestIsSetUpCorrectly() {
        let request = TopUsersRequest()
        expect(request.headers).to(equal([:]))
        expect(request.method).to(equal(.get))
        expect(request.body).to(beNil())
        expect(request.url.absoluteString).to(equal("https://api.stackexchange.com/2.2/users?pagesize=20&order=desc&sort=reputation&site=stackoverflow"))
    }

    func testThePageSizeCanBeChanged() {
        let request = TopUsersRequest(limit: 30)
        expect(request.url.absoluteString).to(equal("https://api.stackexchange.com/2.2/users?pagesize=30&order=desc&sort=reputation&site=stackoverflow"))
    }
}
