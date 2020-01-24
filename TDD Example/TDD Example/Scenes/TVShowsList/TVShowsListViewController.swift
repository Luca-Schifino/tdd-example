//
//  TVShowsListViewController.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

final class TVShowsListViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.registerNib(for: TVShowTableViewCell.self)
            tableView.allowsSelection = false
        }
    }
    
    // MARK: Variables
    let viewModel: TVShowsListViewModelProtocol

    // MARK: Life Cycle
    init(viewModel: TVShowsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TVShowsListViewController.self), bundle: .main)
        title = "listTitle".localized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = TVShowsListViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinds()
    }

    // MARK: Functions
    private func setupBinds() {
        viewModel.loading.bindAndFire { isLoading in
            DispatchQueue.main.async {  [weak self]  in
                guard let self = self else { return }
                if isLoading {
                    self.loader.startAnimating()
                } else {
                    self.loader.stopAnimating()
                }
                self.loader.isHidden = !isLoading
            }
        }
        viewModel.errorMessage.bindAndFire { message in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let message = message else { return }
                let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok".localized(), style: .default, handler: nil)
                alert.addAction(okAction)
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
        viewModel.tvshowsResultSuccess.bindAndFire { success in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, success else { return }
                self.tableView.reloadData()
            }
        }
    }
}

extension TVShowsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tvshows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TVShowTableViewCell? = tableView.dequeueReusableCell()
        cell?.configure(tvshow: viewModel.tvshows[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
