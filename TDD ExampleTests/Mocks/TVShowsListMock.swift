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
        TVShow(id: "1", title: "Test 1"),
        TVShow(id: "2", title: "Test 2"),
        TVShow(id: "3", title: "Test 3"),
        TVShow(id: "4", title: "Test 4")
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
    var tvshowsResultSuccess: Dynamic<Bool> = Dynamic(false)
    var tvshows: [TVShow] = [
        TVShow(id: "1", title: "Test 1"),
        TVShow(id: "2", title: "Test 2"),
        TVShow(id: "3", title: "Test 3")
    ]
    var tvshowsRatings: [TVShowRating] = [
        TVShowRating(tvshowId: "1", rating: 8)
    ]
    
    func setErrorMessage(_ message: String?) {
        errorMessage.value = message
    }
    
    func setLoading(_ isLoading: Bool) {
        loading.value = isLoading
    }
    
    func setTVShowsResultSuccess(_ success: Bool) {
        tvshowsResultSuccess.value = success
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
}
