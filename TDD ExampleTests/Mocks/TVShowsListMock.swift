//
//  TVShowsListMock.swift
//  TDD ExampleTests
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import Foundation
@testable import TDD_Example

class TVShowsListServiceMock: TVShowsListServiceProtocol {
    
    enum ErrorsMock: Error {
        case `default`
    }
    
    var calledLoadTVShows = false
    var wantsLoadTVShowsError = false
    var tvshows = [
        TVShow(id: "700a1e0a-4649-4ea0-9ed5-4dc0a51378db", title: "Test 1"),
        TVShow(id: "778131e3-4df8-43f0-bb2e-56bc7cd80117", title: "Test 2"),
        TVShow(id: "5713de74-ab08-4a31-9708-8ecba3e3f17d", title: "Test 3"),
        TVShow(id: "a8d961c9-540e-409b-85fb-a3665b7f5da8", title: "Test 4")
    ]
    
    func loadTVShows(completion: @escaping (Result<[TVShow], Error>) -> Void) {
        calledLoadTVShows = true
        if wantsLoadTVShowsError {
            completion(.failure(ErrorsMock.default))
        } else {
            completion(.success(tvshows))
        }
    }
}

class TVShowsListViewModelMock: TVShowsListViewModelProtocol {
    var errorMessage: Dynamic<String?> = Dynamic(nil)
    var loading: Dynamic<Bool> = Dynamic(false)
    var reloadData: Dynamic<Bool> = Dynamic(false)
    var tvshows: [TVShow] = [
        TVShow(id: "37e3b149-e47d-4f6a-a970-d1cc8932a6b7", title: "Test 1"),
        TVShow(id: "f30b5192-5589-4126-a312-1250d9d3a7ee", title: "Test 2"),
        TVShow(id: "76114537-c68a-4e3b-8914-e2b8daecc269", title: "Test 3")
    ]
    var tvshowsRatings: [TVShowRating] = [
        TVShowRating(tvshowId: "37e3b149-e47d-4f6a-a970-d1cc8932a6b7", rating: 8)
    ]
    
    func setErrorMessage(_ message: String?) {
        errorMessage.value = message
    }
    
    func setLoading(_ isLoading: Bool) {
        loading.value = isLoading
    }
    
    func setReloadData(_ success: Bool) {
        reloadData.value = success
    }
    
    var ratedRow: Int?
    func rateTVShowAtRow(_ row: Int, rating: Int) {
        ratedRow = row
    }
    
    let mockedRatingRow = 1
    let mockedRating = 6
    func tvshowRatingForCellAtRow(_ row: Int) -> Int? {
        if row == mockedRatingRow {
            return mockedRating
        }
        return nil
    }
    
    var calledRandomRating = false
    func randomRating() {
        calledRandomRating = true
    }
    
    var calledClearAllRatings = false
    func clearAllRatings() {
        calledClearAllRatings = true
    }
}
