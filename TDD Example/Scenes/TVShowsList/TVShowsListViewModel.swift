//
//  TVShowsListViewModel.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import Foundation

protocol TVShowsListViewModelProtocol: AnyObject {
    var errorMessage: Dynamic<String?> { get }
    var loading: Dynamic<Bool> { get }
    var tvshowsResultSuccess: Dynamic<Bool> { get }
    var tvshows: [TVShow] { get }
    var tvshowsRatings: [TVShowRating] { get }
    
    func rateTVShowAtRow(_ row: Int, rating: Int)
    func tvshowRatingForCellAtRow(_ row: Int) -> Int?
}

class TVShowsListViewModel {
    
    // MARK: Variable
    private var service: TVShowsListServiceProtocol
    public var errorMessage: Dynamic<String?> = Dynamic(nil)
    public var loading: Dynamic<Bool> = Dynamic(false)
    public var tvshowsResultSuccess: Dynamic<Bool> = Dynamic(false)
    private(set) var tvshows = [TVShow]()
    private(set) var tvshowsRatings = [TVShowRating]()

    // MARK: Life Cycle
    init(service: TVShowsListServiceProtocol = TVShowsListService()) {
        self.service = service
        loadTVShows()
    }
    
    // MARK: Functions
    func loadTVShows() {
        loading.value = true
        service.loadTVShows { [weak self] result in
            guard let self = self else { return }
            self.loading.value = false
            switch result {
            case .success(let tvshows):
                self.tvshows = tvshows
                self.tvshowsResultSuccess.value = true
            case .failure(let error):
                switch error {
                case let serviceError as ServiceError:
                    self.showServiceError(serviceError)
                default:
                    self.errorMessage.value = "serviceDefaultError".localized()
                }
            }
        }
    }
    
    private func showServiceError(_ error: ServiceError) {
        switch error {
        case .fileNotFound:
            errorMessage.value = "serviceJsonNotFound".localized()
        }
    }
}

// MARK: - TVShowsListViewModelProtocol
extension TVShowsListViewModel: TVShowsListViewModelProtocol {
    
    func rateTVShowAtRow(_ row: Int, rating: Int) {
        let tvshow = tvshows[row]
        let tvshowRating = TVShowRating(tvshowId: tvshow.id, rating: rating)
        tvshowsRatings.append(tvshowRating)
    }
    
    func tvshowRatingForCellAtRow(_ row: Int) -> Int? {
        return tvshowsRatings.first(where: { $0.tvshowId == tvshows[row].id })?.rating
    }
}
