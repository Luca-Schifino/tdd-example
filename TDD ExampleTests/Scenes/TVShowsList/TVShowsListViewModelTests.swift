//
//  TVShowViewModelTests.swift
//  TDD ExampleTests
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import XCTest
@testable import TDD_Example

class TVShowListViewModelTests: XCTestCase {

    var serviceMock: TVShowsListServiceMock!
    var viewModel: TVShowsListViewModel!
    
    override func setUp() {
        UserDefaultsStorage.removeObject(forKey: .ratings)
        serviceMock = TVShowsListServiceMock()
        viewModel = TVShowsListViewModel(service: serviceMock)
    }

    override func tearDown() {
        serviceMock = nil
        viewModel = nil
    }
    
    // MARK: Load TV Shows
    func testCalledLoadTVShowsOnInit() {
        // Given
        XCTAssertNotNil(viewModel)
        
        // Then
        XCTAssertTrue(serviceMock.calledLoadTVShows)
    }
    
    func testLoadTVShowsSuccess() {
        // Given
        serviceMock.calledLoadTVShows = false
        let loadingObserver = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: loadingObserver)
        
        // When
        viewModel.loadTVShows()
        
        // Then
        XCTAssertTrue(serviceMock.calledLoadTVShows)
        XCTAssertEqual(loadingObserver.values, [true, false])
        XCTAssertEqual(viewModel.tvshows, serviceMock.tvshows)
        XCTAssertTrue(viewModel.reloadData.value)
        XCTAssertNil(viewModel.errorMessage.value)
    }
    
    func testLoadTVShowsFailure() {
        // Given
        serviceMock.calledLoadTVShows = false
        viewModel.reloadData.value = false
        serviceMock.wantsLoadTVShowsError = true
        let loadingObserver = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: loadingObserver)
        
        // When
        viewModel.loadTVShows()
        
        // Then
        XCTAssertTrue(serviceMock.calledLoadTVShows)
        XCTAssertEqual(loadingObserver.values, [true, false])
        XCTAssertFalse(viewModel.reloadData.value)
        XCTAssertNotNil(viewModel.errorMessage.value)
    }
    
    // MARK: Rate tv shows
    func testLoadInitialRatingsAfterTVShows() {
        // Given
        let tvshowRatings = [
            TVShowRating(tvshowId: "test123", rating: 2),
            TVShowRating(tvshowId: "test345", rating: 4)
        ]
        try? UserDefaultsStorage.encodeObject(data: tvshowRatings, forKey: .ratings)
        
        // When
        viewModel.loadTVShows()
        
        // Then
        XCTAssertEqual(viewModel.tvshowsRatings, tvshowRatings)
    }
    
    func testRateTVShow() {
        // Given
        let rowToRate = 2
        let tvshowToRate = serviceMock.tvshows[rowToRate]
        
        // When
        viewModel.rateTVShowAtRow(rowToRate, rating: 3)
        
        // Then
        XCTAssertTrue(viewModel.tvshowsRatings.map {
            $0.tvshowId
        }.contains(tvshowToRate.id))
    }
    
    func testOrderTVShowByRating() {
        // Given
        var tvshowsAux = [TVShow]()
        for (index, tvshow) in serviceMock.tvshows.enumerated() {
            viewModel.rateTVShowAtRow(index, rating: 10 - index)
            tvshowsAux.append(tvshow)
        }
        
        // Then
        XCTAssertEqual(viewModel.tvshows, tvshowsAux)
        XCTAssertEqual(try? UserDefaultsStorage.decodeObject(forKey: .ratings), viewModel.tvshowsRatings)
    }
    
    func testClearAllRatings() {
        // Given
        viewModel.rateTVShowAtRow(2, rating: 3)
        XCTAssertFalse(viewModel.tvshowsRatings.isEmpty)
        let preTestStorageRatings = (try? UserDefaultsStorage.decodeObject(forKey: .ratings)) ?? [TVShowRating]()
        XCTAssertFalse(preTestStorageRatings.isEmpty)
        
        // When
        viewModel.clearAllRatings()
        
        // Then
        XCTAssertTrue(viewModel.tvshowsRatings.isEmpty)
        let storageRatings = (try? UserDefaultsStorage.decodeObject(forKey: .ratings)) ?? [TVShowRating]()
        XCTAssertTrue(storageRatings.isEmpty)
        
    }
    
    // MARK: Random Rating
    func testStartRandomRating() {
        // Given
        let preRandomnessRatings = viewModel.tvshowsRatings
        
        // When
        viewModel.randomRating()
        viewModel.randomRatingTimer?.fire()
        
        // Then
        XCTAssertTrue(viewModel.randomRatingTimer?.isValid ?? false)
        XCTAssertNotEqual(viewModel.tvshowsRatings, preRandomnessRatings)
    }
    
    func testStopRandomRating() {
        // Given
        viewModel.randomRating()
        viewModel.randomRatingTimer?.fire()
        
        // When
        let afterRandomnessRatings = viewModel.tvshowsRatings
        viewModel.randomRating()
        
        // Then
        XCTAssertFalse(viewModel.randomRatingTimer?.isValid ?? false)
        XCTAssertEqual(viewModel.tvshowsRatings, afterRandomnessRatings)
    }
}
