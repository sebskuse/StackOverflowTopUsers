//
//  UserCell.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

class UserCellViewModel {
    var model: User?
}

class UserCell: UITableViewCell {
    var viewModel = UserCellViewModel()
}
