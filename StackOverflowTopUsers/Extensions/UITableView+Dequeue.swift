//
//  UITableView+Dequeue.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var dequeueIdentifier: String {
        return String(describing: self)
    }

    static func register(in table: UITableView) {
        let nib = UINib(nibName: Self.dequeueIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: dequeueIdentifier)
    }
}

extension UITableView {
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.dequeueIdentifier, for: indexPath) as? T else {
            fatalError("Incorrect cell type")
        }
        return cell
    }
}
