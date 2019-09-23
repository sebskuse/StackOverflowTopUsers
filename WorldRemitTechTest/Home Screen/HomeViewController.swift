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

    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
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

        viewModel.fetchUsers()
    }
}
