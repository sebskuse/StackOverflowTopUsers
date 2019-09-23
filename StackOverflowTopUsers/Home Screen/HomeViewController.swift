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
        dataSource.delegate = self
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

extension HomeViewController: HomeDataSourceDelegate {
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
