//
//  TVShowsListViewModel.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import Foundation

protocol TVShowsListViewModelProtocol: AnyObject {
}

class TVShowsListViewModel {
    private var service: TVShowsListServiceProtocol

    init(service: TVShowsListServiceProtocol = TVShowsListService()) {
        self.service = service
    }
}

extension TVShowsListViewModel: TVShowsListViewModelProtocol {}
