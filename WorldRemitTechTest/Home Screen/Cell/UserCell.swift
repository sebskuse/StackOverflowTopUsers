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
    let username = Bindable<String?>(nil)
    let reputation = Bindable<String?>(nil)
    let profileImage = Bindable<UIImage?>(nil)

    var model: User? {
        didSet {
            username.value = model?.displayName
            reputation.value = model.map { "Reputation: \(String(describing: $0.reputation))" }
        }
    }
}

class UserCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var reputationLabel: UILabel!

    var viewModel = UserCellViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel.username.update = { [weak self] username in
            self?.nameLabel.text = username
        }

        viewModel.reputation.update = { [weak self] reputation in
            self?.reputationLabel.text = reputation
        }

        viewModel.profileImage.update = { [weak self] image in
            self?.profileImageView.image = image
        }
    }
}
