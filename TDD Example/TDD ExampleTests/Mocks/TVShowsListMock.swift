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
        TVShow(title: "Test 1"),
        TVShow(title: "Test 2")
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
        TVShow(title: "Test 1"),
        TVShow(title: "Test 2"),
        TVShow(title: "Test 3")
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
}
