//
//  SessionErrors.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case noData
    case invalidData
    case invalidResponse
    case statusError(status: Int)
}
