//
//  ResponseParsingTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 19/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Nimble
@testable import WorldRemitTechTest
import XCTest

class ResponseParsingTests: XCTestCase {
    var parser: StandardResponseParser!

    override func setUp() {
        super.setUp()
        parser = StandardResponseParser()
    }

    override func tearDown() {
        parser = nil
        super.tearDown()
    }

    func testPassingANonHTTPResponseReturnsTheCorrectError() throws {
        let data = "{}".data(using: .utf8)!
        let urlResponse = URLResponse(url: testURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        let response: Result<EmptyResponse, Error> = parser.parse(data: data, response: urlResponse, error: nil)

        guard case .invalidResponse? = response.sessionError else {
            XCTFail("Did not get correct error")
            return
        }
    }

    // MARK: - Empty response

    func testAValidResponseCanBeParsedWithA200ResponseCode() throws {
        let data = "{}".data(using: .utf8)!
        let response: Result<EmptyResponse, Error> = parser.parse(data: data, response: testURLResponse(status: 200), error: nil)

        expect(try response.get()).notTo(beNil())
    }

    // MARK: - Non-matching types

    func testAnErrorIsReturnedWhenTryingToParseATypeThatDoesNotMatchTheResponse() {
        let data = "{}".data(using: .utf8)!
        let response: Result<NonEmptyResponse, Error> = parser.parse(data: data, response: testURLResponse(status: 200), error: nil)

        guard case let .failure(error) = response else {
            XCTFail("Did not get an error")
            return
        }
        expect(error as? DecodingError).notTo(beNil())
    }

    // MARK: - Parsing users

    func testAUsersResponseCanBeParsed() throws {
        let data = try stubJSON(named: "UsersResponse")

        let response: Result<UsersResponse, Error> = parser.parse(data: data, response: testURLResponse(status: 200), error: nil)

        let users = try response.get()

        expect(users.items).to(haveCount(20))
        expect(users.items.first?.displayName).to(equal("Jon Skeet"))
        expect(users.items.first?.profileImage.absoluteString).to(equal("https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=128&d=identicon&r=PG"))
        expect(users.items.first?.reputation).to(equal(1_132_941))
    }

    // MARK: - Errors

    func testWhenThereIsNoDataAnAppropriateErrorIsReturned() {
        let response: Result<EmptyResponse, Error> = parser.parse(data: nil, response: testURLResponse(), error: nil)

        guard case .noData? = response.sessionError else {
            XCTFail("Did not get correct error")
            return
        }
    }

    func testAResponseErrorWithAnErrorCodeReturnsTheCode() {
        let response: Result<EmptyResponse, Error> = parser.parse(data: Data(), response: testURLResponse(), error: nil)

        guard case let SessionError.statusError(code)? = response.sessionError else {
            XCTFail("Did not receive a server error")
            return
        }
        expect(code).to(equal(500))
    }
}

private struct EmptyResponse: Decodable {}
private struct NonEmptyResponse: Decodable {
    let something: String
}

private extension Result where Success == EmptyResponse {
    var sessionError: SessionError? {
        guard case let .failure(error as SessionError) = self else {
            return nil
        }
        return error
    }
}
