//
//  TestHelpers.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

func testURL() -> URL {
    return URL(string: "http://localhost.com")!
}

func testURLResponse(status: Int = 500) -> HTTPURLResponse {
    return HTTPURLResponse(url: testURL(), statusCode: status, httpVersion: "2.0", headerFields: nil)!
}
