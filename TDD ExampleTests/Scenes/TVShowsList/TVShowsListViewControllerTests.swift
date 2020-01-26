//
//  TVShowViewControllerTests.swift
//  TDD ExampleTests
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import XCTest
@testable import TDD_Example

class TVShowViewControllerTests: XCTestCase {

    var viewModelMock: TVShowsListViewModelMock!
    var viewController: TVShowsListViewController!
    
    override func setUp() {
        viewModelMock = TVShowsListViewModelMock()
        viewController = TVShowsListViewController(viewModel: viewModelMock)
        _ = viewController.view
    }

    override func tearDown() {
        viewModelMock = nil
        viewController = nil
    }
    
    // MARK: Dynamic Bind
    func testBind() {
        // Given
        XCTAssertNotNil(viewController)
        
        // Then
        XCTAssertTrue(viewModelMock.loading.isBinded())
        XCTAssertTrue(viewModelMock.errorMessage.isBinded())
        XCTAssertTrue(viewModelMock.reloadData.isBinded())
    }
    
    // MARK: Loader
    func testLoaderAnimating() {
        // Given
        viewModelMock.setLoading(true)
        
        // When
        waitForMainDispatchQueue()
        
        // Then
        XCTAssertTrue(viewController.loader.isAnimating)
        XCTAssertFalse(viewController.loader.isHidden)
    }
    
    func testLoaderStopAnimating() {
        // Given
        viewModelMock.setLoading(false)
        
        // When
        waitForMainDispatchQueue()
        
        // Then
        XCTAssertFalse(viewController.loader.isAnimating)
        XCTAssertTrue(viewController.loader.isHidden)
    }
    
    // MARK: Navigation Item
    func testClearAllRatingsAction() {
        // Given
        guard let leftBarButtonItem = viewController.navigationItem.leftBarButtonItem,
            let selector = leftBarButtonItem.action else {
            XCTFail("Couldn't find leftBarButtonItem with Selector")
            return
        }
        
        // When
        viewController.performSelector(onMainThread: selector, with: nil, waitUntilDone: true)
        
        // Then
        XCTAssertTrue(viewModelMock.calledClearAllRatings)
    }
    
    func testRandomRatingAction() {
        // Given
        guard let rightBarButtonItem = viewController.navigationItem.rightBarButtonItem,
            let selector = rightBarButtonItem.action else {
            XCTFail("Couldn't find rightBarButtonItem with Selector")
            return
        }
        
        // When
        viewController.performSelector(onMainThread: selector, with: nil, waitUntilDone: true)
        
        // Then
        XCTAssertTrue(viewModelMock.calledRandomRating)
        
    }
    
    // MARK: Cells
    func testNumberOfCells() {
        // Given
        viewModelMock.setReloadData(true)
        
        // Then
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), viewModelMock.tvshows.count)
    }
    
    func testCellsContent() {
        // Given
        viewModelMock.setReloadData(true)
        
        // Then
        let tvshows = viewModelMock.tvshows
        for index in 0...tvshows.count-1 {
            guard let cell = viewController.tableView(viewController.tableView,
                                                      cellForRowAt: IndexPath(row: index, section: 0))
                as? TVShowTableViewCell else {
                XCTFail("Couldn't find cell")
                return
            }
            if index == viewModelMock.mockedRatingRow {
                XCTAssertEqual(cell.ratingLabel.text, "\(viewModelMock.mockedRating)")
                XCTAssertFalse(cell.ratingLabel.isHidden)
            } else {
                XCTAssertTrue(cell.ratingLabel.isHidden)
            }
            XCTAssertEqual(cell.titleLabel.text, tvshows[index].title)
        }
    }
    
    // MARK: Rating
    func testShowRatingView() {
        // Given
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // When
        waitForMainDispatchQueue()
        
        // Then
        XCTAssertTrue(viewController.view.hasSubviewOf(type: RatingView.self))
    }
    
    func testRateTVShow() {
        // Given
        let selectedRow = 0
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row: selectedRow, section: 0))
        waitForMainDispatchQueue()
        XCTAssertTrue(viewController.view.hasSubviewOf(type: RatingView.self))
        
        // When
        guard let ratingView = viewController.view.getSubviewOf(type: RatingView.self) as? RatingView else {
            XCTFail("Could not fin RatingView")
            return
        }
        ratingView.collectionView(ratingView.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        ratingView.confirmButton.sendActions(for: .touchUpInside)
        waitForMainDispatchQueue()
        
        // Then
        XCTAssertFalse(viewController.view.hasSubviewOf(type: RatingView.self))
        XCTAssertEqual(viewModelMock.ratedRow, selectedRow)
    }
    
    private func waitForMainDispatchQueue() {
        let expectation = self.expectation(description: "dispatch_main")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
