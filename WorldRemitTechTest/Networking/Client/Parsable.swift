//
//  Parsable.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

public protocol Parsable {
    // Parses an object from the supplied data
    static func parse(data: Data?, response: URLResponse?, error: Error?) -> Result<Self, Error>
}
