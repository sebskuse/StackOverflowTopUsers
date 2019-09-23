//
//  TestHelpers.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import XCTest

func testURL() -> URL {
    return URL(string: "http://localhost.com")!
}

func testURLResponse(status: Int = 500) -> HTTPURLResponse {
    return HTTPURLResponse(url: testURL(), statusCode: status, httpVersion: "2.0", headerFields: nil)!
}

extension XCTestCase {
    func stubJSON(named: String) throws -> Data {
        guard let url = Bundle(for: type(of: self)).url(forResource: named, withExtension: "json") else {
            throw JSONLoadingError.notFound
        }
        return try Data(contentsOf: url)
    }

    func testImage(named: String) throws -> UIImage {
        guard let url = Bundle(for: type(of: self)).url(forResource: named, withExtension: "jpg") else {
            throw JSONLoadingError.notFound
        }
        let data = try Data(contentsOf: url)
        guard let image = UIImage(data: data) else {
            throw JSONLoadingError.notFound
        }
        return image
    }
}

enum JSONLoadingError: Error {
    case notFound
}
