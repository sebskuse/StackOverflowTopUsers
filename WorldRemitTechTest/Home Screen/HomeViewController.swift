//
//  HomeViewController.swift
//  WorldRemitTechTest
//
//  Created by Seb Skuse on 23/09/2019.
//  Copyright © 2019 Seb Skuse. All rights reserved.
//

import Bond
import UIKit

class HomeViewController: UIViewController {
    var viewModel = HomeViewModel()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.error.map { $0 == nil }.bind(to: errorLabel.reactive.isHidden)
        viewModel.error.map { $0 != nil }.bind(to: tableView.reactive.isHidden)
        viewModel.error.map { $0?.message }.bind(to: errorLabel.reactive.text)
        viewModel.isLoading.bind(to: loadingSpinner.reactive.isAnimating)

        viewModel.users.bind(to: tableView, cellType: UserCell.self) { cell, user in
            cell.viewModel.model = user
        }

        viewModel.fetchUsers()
    }
}
