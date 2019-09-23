//
//  HomeViewController.swift
//  StackOverflowTopUsers
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var viewModel = HomeViewModel()
    var dataSource = HomeDataSource()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        UserCell.register(in: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        viewModel.error.update = { [weak self] error in
            self?.errorLabel.isHidden = error == nil
            self?.tableView.isHidden = error != nil
            self?.errorLabel.text = error?.message
        }
        viewModel.isLoading.update = { [weak self] loading in
            if loading {
                self?.loadingSpinner.startAnimating()
            } else {
                self?.loadingSpinner.stopAnimating()
            }
        }

        viewModel.users.update = { [weak self] users in
            self?.dataSource.setUsers(users)
            self?.tableView.reloadData()
        }

        viewModel.fetchUsers()
    }
}

class HomeDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var users: [UserState] = []

    func setUsers(_ users: [User]) {
        self.users = users.map { UserState(user: $0) }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeue(for: indexPath)
        cell.viewModel.model = users[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        users[indexPath.row].expanded.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let user = users[indexPath.row]
        return user.expanded ? 100 : 80
    }
}
