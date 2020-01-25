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
        XCTAssertTrue(viewModel.tvshowsResultSuccess.value)
        XCTAssertNil(viewModel.errorMessage.value)
    }
    
    func testLoadTVShowsFailure() {
        // Given
        serviceMock.calledLoadTVShows = false
        viewModel.tvshowsResultSuccess.value = false
        serviceMock.wantsLoadTVShowsError = true
        let loadingObserver = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: loadingObserver)
        
        // When
        viewModel.loadTVShows()
        
        // Then
        XCTAssertTrue(serviceMock.calledLoadTVShows)
        XCTAssertEqual(loadingObserver.values, [true, false])
        XCTAssertFalse(viewModel.tvshowsResultSuccess.value)
        XCTAssertNotNil(viewModel.errorMessage.value)
    }
    
    // MARK: Rate tv shows
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
}
