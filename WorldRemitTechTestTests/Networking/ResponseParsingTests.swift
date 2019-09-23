//
//  ResponseParsingTests.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 19/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

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

        XCTAssertNotNil(try response.get())
    }

    // MARK: - Non-matching types

    func testAnErrorIsReturnedWhenTryingToParseATypeThatDoesNotMatchTheResponse() {
        let data = "{}".data(using: .utf8)!
        let response: Result<NonEmptyResponse, Error> = parser.parse(data: data, response: testURLResponse(status: 200), error: nil)

        guard case let .failure(error) = response else {
            XCTFail("Did not get an error")
            return
        }
        XCTAssertNotNil(error as? DecodingError)
    }

    // MARK: - Parsing users

    func testAUsersResponseCanBeParsed() throws {
        let data = try stubJSON(named: "UsersResponse")

        let response: Result<UsersResponse, Error> = parser.parse(data: data, response: testURLResponse(status: 200), error: nil)

        let users = try response.get()

        XCTAssertEqual(users.items.count, 20)
        XCTAssertEqual(users.items.first?.displayName, "Jon Skeet")
        XCTAssertEqual(users.items.first?.profileImage.absoluteString, "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=128&d=identicon&r=PG")
        XCTAssertEqual(users.items.first?.reputation, 1_132_941)
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
        XCTAssertEqual(code, 500)
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
