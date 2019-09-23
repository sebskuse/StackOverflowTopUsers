//
//  HomeDataSource.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Foundation
import UIKit

class HomeDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var users: [UserState] = []

    weak var delegate: HomeDataSourceDelegate?

    func setUsers(_ users: [User]) {
        self.users = users.map { UserState(user: $0) }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeue(for: indexPath)
        cell.viewModel.model = users[indexPath.row]
        cell.delegate = self
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        users[indexPath.row].expanded.toggle()
        delegate?.reloadRow(at: indexPath)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let user = users[indexPath.row]
        return user.expanded ? 100 : 80
    }

    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch users[indexPath.row].state {
        case .blocked:
            return nil
        default:
            return indexPath
        }
    }
}

extension HomeDataSource: UserCellDelegate {
    func userCell(_: UserCell, requestingBlockUser user: User) {
        if let index = update(user: user, state: .blocked) {
            users[index.row].expanded = false
            delegate?.reloadRow(at: index)
        }
    }

    func userCell(_: UserCell, requestingFollowUser user: User) {
        if let index = update(user: user, state: .following) {
            delegate?.reloadRow(at: index)
        }
    }

    func userCell(_: UserCell, requestingUnfollowUser user: User) {
        if let index = update(user: user, state: .notFollowing) {
            delegate?.reloadRow(at: index)
        }
    }

    private func update(user: User, state: UserState.State) -> IndexPath? {
        guard let index = users.firstIndex(where: { $0.user.accountId == user.accountId }) else {
            return nil
        }
        users[index].state = state
        return IndexPath(row: index, section: 0)
    }
}

protocol HomeDataSourceDelegate: AnyObject {
    func reloadRow(at indexPath: IndexPath)
}
