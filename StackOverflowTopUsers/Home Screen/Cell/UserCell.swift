//
//  UserCell.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

/// This would obviously be a network call usually, rather than
/// just setting bools on this. I prefer to have immutable models,
/// so ideally the API would return the new user object which I can
/// just replace the local copy with to update the UI with.
class UserState {
    enum State {
        case notFollowing
        case following
        case blocked
    }

    let user: User
    var expanded: Bool
    var state: State

    init(user: User, expanded: Bool = false, state: State = .notFollowing) {
        self.user = user
        self.expanded = expanded
        self.state = state
    }
}

class UserCellViewModel {
    private let imageContext: ProfileImageRetrieving
    private var cancellable: Cancellable?

    let username = Bindable<String?>(nil)
    let reputation = Bindable<String?>(nil)
    let profileImage = Bindable<UIImage?>(nil)
    let expanded = Bindable<Bool>(false)
    let followAction = Bindable<String?>(nil)

    var model: UserState? {
        didSet {
            guard let user = model else { return }
            username.value = user.user.displayName
            reputation.value = "Reputation: \(String(describing: user.user.reputation))"
            expanded.value = user.expanded
            followAction.value = { () -> String in
                switch user.state {
                case .notFollowing, .blocked:
                    return "Follow"
                case .following:
                    return "Unfollow"
                }
            }()

            cancellable = imageContext.profileImage(for: user.user, completion: { [weak self] res in
                self?.profileImage.value = try? res.get()
            })
        }
    }

    init(imageContext: ProfileImageRetrieving = ProfileImageContext()) {
        self.imageContext = imageContext
    }

    func prepareForReuse() {
        cancellable?.cancel()
        cancellable = nil
    }
}

class UserCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var reputationLabel: UILabel!
    @IBOutlet var actionsContainer: UIView!
    @IBOutlet var followActionButton: UIButton!
    @IBOutlet var blockButton: UIButton!

    var viewModel = UserCellViewModel() {
        didSet {
            bindViewModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.username.update = { [weak self] username in
            self?.nameLabel.text = username
        }

        viewModel.reputation.update = { [weak self] reputation in
            self?.reputationLabel.text = reputation
        }

        viewModel.profileImage.update = { [weak self] image in
            self?.profileImageView.image = image
        }

        viewModel.expanded.update = { [weak self] expanded in
            self?.actionsContainer.isHidden = !expanded
        }

        viewModel.followAction.update = { [weak self] action in
            self?.followActionButton.setTitle(action, for: .normal)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel.prepareForReuse()
    }
}
