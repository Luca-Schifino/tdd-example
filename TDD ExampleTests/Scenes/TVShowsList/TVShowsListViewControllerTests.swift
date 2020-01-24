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

    var viewModel: TVShowsListViewModelMock!
    var viewController: TVShowsListViewController!
    
    override func setUp() {
        viewModel = TVShowsListViewModelMock()
        viewController = TVShowsListViewController(viewModel: viewModel)
        _ = viewController.view
    }

    override func tearDown() {
        viewModel = nil
        viewController = nil
    }
    
    // MARK: Dynamic Bind
    func testBind() {
        // Given
        XCTAssertNotNil(viewController)
        
        // Then
        XCTAssertTrue(viewModel.loading.isBinded())
        XCTAssertTrue(viewModel.errorMessage.isBinded())
        XCTAssertTrue(viewModel.tvshowsResultSuccess.isBinded())
    }
    
    // MARK: Loader
    func testLoaderAnimating() {
        // Given
        viewModel.setLoading(true)
        
        // When
        waitForMainDispatchQueue()
        
        // Then
        XCTAssertTrue(viewController.loader.isAnimating)
        XCTAssertFalse(viewController.loader.isHidden)
    }
    
    func testLoaderStopAnimating() {
        // Given
        viewModel.setLoading(false)
        
        // When
        waitForMainDispatchQueue()
        
        // Then
        XCTAssertFalse(viewController.loader.isAnimating)
        XCTAssertTrue(viewController.loader.isHidden)
    }
    
    // MARK: Cells
    func testNumberOfCells() {
        // Given
        viewModel.setTVShowsResultSuccess(true)
        
        // Then
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), viewModel.tvshows.count)
    }
    
    func testCellsContent() {
        // Given
        viewModel.setTVShowsResultSuccess(true)
        
        // Then
        let tvshows = viewModel.tvshows
        for index in 0...tvshows.count-1 {
            guard let cell = viewController.tableView(viewController.tableView,
                                                      cellForRowAt: IndexPath(row: index, section: 0))
                as? TVShowTableViewCell else {
                XCTFail("Couldn't find cell")
                return
            }
            XCTAssertEqual(cell.titleLabel.text, tvshows[index].title)
        }
    }
    
    private func waitForMainDispatchQueue() {
        let expectation = self.expectation(description: "dispatch_main")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
