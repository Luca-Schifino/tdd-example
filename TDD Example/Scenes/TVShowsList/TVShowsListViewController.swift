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
            tableView.delegate = self
            tableView.registerNib(for: TVShowTableViewCell.self)
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    // MARK: Variables
    let viewModel: TVShowsListViewModelProtocol
    private var selectedIndex = IndexPath()

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
        viewModel.reloadData.bindAndFire { shouldReload in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, shouldReload else { return }
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension TVShowsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tvshows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TVShowTableViewCell? = tableView.dequeueReusableCell()
        cell?.configure(tvshow: viewModel.tvshows[indexPath.row],
                        rating: viewModel.tvshowRatingForCellAtRow(indexPath.row))
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension TVShowsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addModalMaskView()
            self.showRatingView(delegate: self, initialRating: self.viewModel.tvshowRatingForCellAtRow(indexPath.row))
        }
    }
}

// MARK: - RatingViewDelegate
extension TVShowsListViewController: RatingViewDelegate {
    
    func willDismissRatingView(withRating rating: Int?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeModalMaskView()
            self.tableView.deselectRow(at: self.selectedIndex, animated: true)
        }
        if let rating = rating {
            viewModel.rateTVShowAtRow(selectedIndex.row, rating: rating)
            tableView.reloadData()
        }
    }
}
