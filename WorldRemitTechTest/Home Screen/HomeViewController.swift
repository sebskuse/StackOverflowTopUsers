//
//  HomeViewController.swift
//  WorldRemitTechTest
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
            self?.dataSource.users = users
            self?.tableView.reloadData()
        }

        viewModel.fetchUsers()
    }
}

class HomeDataSource: NSObject, UITableViewDataSource {
    var users: [User] = []

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeue(for: indexPath)
        cell.viewModel.model = users[indexPath.row]
        return cell
    }
}
