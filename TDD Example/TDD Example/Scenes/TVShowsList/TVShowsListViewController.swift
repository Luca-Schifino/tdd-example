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
    

    // MARK: Variables
    let viewModel: TVShowsListViewModelProtocol

    // MARK: Life Cycle
    init(viewModel: TVShowsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TVShowsListViewController.self), bundle: .main)
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
        
    }
}
