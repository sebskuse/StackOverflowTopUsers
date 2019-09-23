//
//  Bindable.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation

/// Super simple bindable container for use in ViewModels.
/// Usually i'd use something like Bond.
class Bindable<O> {
    var update: ((O) -> Void)? {
        didSet {
            update?(value)
        }
    }

    var value: O {
        didSet {
            update?(value)
        }
    }

    init(_ value: O) {
        self.value = value
    }
}
