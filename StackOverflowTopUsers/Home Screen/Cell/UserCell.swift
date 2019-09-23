//
//  UserCell.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

class UserCellViewModel {
    private let imageContext: ProfileImageRetrieving
    private var cancellable: Cancellable?

    let username = Bindable<String?>(nil)
    let reputation = Bindable<String?>(nil)
    let profileImage = Bindable<UIImage?>(nil)
    let expanded = Bindable<Bool>(false)
    let followAction = Bindable<String?>(nil)
    let isFollowing = Bindable<Bool>(false)

    var model: UserState? {
        didSet {
            guard let user = model else { return }
            username.value = user.user.displayName
            reputation.value = "Reputation: \(String(describing: user.user.reputation))"
            expanded.value = user.expanded

            switch user.state {
            case .notFollowing, .blocked:
                followAction.value = "Follow"
                isFollowing.value = false
            case .following:
                followAction.value = "Unfollow"
                isFollowing.value = true
            }

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

    weak var delegate: UserCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        bindViewModel()

        blockButton.addTarget(self, action: #selector(blockUser), for: .primaryActionTriggered)
        followActionButton.addTarget(self, action: #selector(updateFollowStatus), for: .primaryActionTriggered)
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

        viewModel.isFollowing.update = { [weak self] following in
            self?.accessoryType = following ? .checkmark : .none
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel.prepareForReuse()
    }

    @IBAction func blockUser() {
        guard let user = viewModel.model?.user else { return }
        delegate?.userCell(self, requestingBlockUser: user)
    }

    @IBAction func updateFollowStatus() {
        guard let container = viewModel.model else { return }
        switch container.state {
        case .notFollowing:
            delegate?.userCell(self, requestingFollowUser: container.user)
        case .following:
            delegate?.userCell(self, requestingUnfollowUser: container.user)
        case .blocked:
            return
        }
    }
}

protocol UserCellDelegate: AnyObject {
    func userCell(_ cell: UserCell, requestingBlockUser user: User)

    func userCell(_ cell: UserCell, requestingFollowUser user: User)

    func userCell(_ cell: UserCell, requestingUnfollowUser user: User)
}
