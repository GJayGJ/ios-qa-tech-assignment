//
//  NewsListTableCellTests.swift
//  ReachNewsTests
//
//  Created by 黃冠傑 on 2024/7/16.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import XCTest
@testable import ReachNews

final class NewsListTableCellTests: XCTestCase {
    var newsListViewModel: NewsListViewModel!
    var newsTableCellViewModel: NewsTableCellViewModel!
    var mockNewsAPIService: NewsAPIService!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        newsListViewModel = NewsListViewModel()
    }
    
    override func tearDownWithError() throws {
        newsListViewModel = nil
        newsTableCellViewModel = nil
        mockNewsAPIService = nil
    }
    
    
    // MARK: Unit Test Cases
    
    /// Test that images can be retrieved successfully
    func testGetLeadMediaSuccess() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockTwentyNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")
        
        // Arrange - NewsTableCellViewModel
        let rowCount = newsListViewModel.numberOfRows()
        let randomIndex = Int.random(in: 0..<rowCount)
        newsTableCellViewModel = newsListViewModel.cellViewModel(at: IndexPath(row: randomIndex, section: 0))
        
        // Arrange - mock image data
        let mockImageAPIService = MockImageAPIService()
        InjectedValues[\.imageAPIService] = mockImageAPIService
        let expectation = self.expectation(description: "Lead media fetched successfully")
        var isExpectationFulfilled = false
        
        // Expectation should be fulfilled once when completion handler is executed
        newsTableCellViewModel.leadMediaBind = { data in
            if !isExpectationFulfilled {
                isExpectationFulfilled = true
                expectation.fulfill()

                // Assert
                XCTAssertNotNil(data)
                XCTAssertFalse(data!.isEmpty)
                XCTAssertEqual(data!.toImage().size.width, 300)
                XCTAssertEqual(data!.toImage().size.height, 158)
            }
        }
        
        // Act
        newsTableCellViewModel.getLeadMedia()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    /// Test that bookmarks can be toggled correctly
    func testToggleBookmark() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockTwentyNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")

        // Arrange - NewsTableCellViewModel
        let rowCount = newsListViewModel.numberOfRows()
        let randomIndex = Int.random(in: 0..<rowCount)
        newsTableCellViewModel = newsListViewModel.cellViewModel(at: IndexPath(row: randomIndex, section: 0))
        
        // Arrange - bookmarked state
        let initialBookmarkState = newsTableCellViewModel.isBookmarked
        
        // Act
        newsTableCellViewModel.toggleBookmark()
        
        // Assert
        let updatedBookmarkState = newsTableCellViewModel.isBookmarked
        XCTAssertNotEqual(updatedBookmarkState, initialBookmarkState)
    }
    
    
    // MARK: private functions
    
    /// Arrange - Dependency Injection for News
    private func setupMockService(fileName: String? = nil) {
        if let fileName = fileName {
            mockNewsAPIService = MockNewsAPIService(fileName: fileName)
        } else {
            mockNewsAPIService = BitbucketNewsAPIService()
        }
        InjectedValues[\.newsAPIService] = mockNewsAPIService
    }
    
    /// Prepare for the required news data
    private func fetchNewsData(expectationDescription: String) async {
        let expectation = self.expectation(description: expectationDescription)
        var isExpectationFulfilled = false
        
        // Expectation should be fulfilled once when completion handler is executed
        newsListViewModel.updateUIBind = {
            if !isExpectationFulfilled {
                isExpectationFulfilled = true
                expectation.fulfill()
            }
        }
        
        newsListViewModel.getNews()
        await fulfillment(of: [expectation], timeout: 5)
    }
}
