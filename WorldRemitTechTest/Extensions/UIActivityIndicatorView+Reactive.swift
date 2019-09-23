//
//  UIActivityIndicatorView+Reactive.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit
import UIKit

extension ReactiveExtensions where Base: UIActivityIndicatorView {
    var isAnimating: Bond<Bool> {
        return bond {
            if $1 {
                $0.startAnimating()
            } else {
                $0.stopAnimating()
            }
        }
    }
}
