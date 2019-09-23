//
//  NibLoading.swift
//  WorldRemitTechTestTests
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

/// Protocol to be extended with implementations
public protocol UIViewLoading {}

/// Extend UIView to declare that it includes nib loading functionality
extension UIView: UIViewLoading {}

/// Protocol implementation
public extension UIViewLoading where Self: UIView {
    /**
     Creates a new instance of the class on which this method is invoked,
     instantiated from a nib of the given name. If no nib name is given
     then a nib with the name of the class is used.

     - parameter nibNameOrNil: The name of the nib to instantiate from, or
     nil to indicate the nib with the name of the class should be used.

     - returns: A new instance of the class, loaded from a nib.
     */
    static func loadFromNib(nibNameOrNil: String? = nil) -> Self {
        let nibName = nibNameOrNil ?? String(describing: self)
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let loadedNib = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not load: \(String(describing: nibNameOrNil))")
        }
        return loadedNib
    }
}
