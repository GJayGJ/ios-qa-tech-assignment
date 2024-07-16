//
//  ReachNewsTests.swift
//  ReachNewsTests
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import XCTest
@testable import ReachNews

final class NewsListTests: XCTestCase {
    var viewModel: NewsListViewModel!
    var mockNewsAPIService: NewsAPIService!
    
    override func setUpWithError() throws {
        viewModel = NewsListViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNewsAPIService = nil
    }
    
    
    // MARK: Unit Test Cases

    /// Test that news can be retrieved successfully
    func testGetNewsSuccess() async throws {
        // Arrange
        setupMockService()
        
        // Act
        await fetchNewsData(expectationDescription: "News data fetch successful")
        
        // Assert
        XCTAssertGreaterThanOrEqual(viewModel.numberOfRows(), 0)
    }
    
    /// Test that fetching news is failed
    func testGetNewsFailure() async throws {
        // Arrange
        setupMockService(fileName: "notExistingData")
        
        let expectation = self.expectation(description: "News data fetch failure")
        var isExpectationFulfilled = false
        
        // Expectation should be fulfilled once when completion handler is excuted
        viewModel.newsErrorBind = { errorMessage in
            if !isExpectationFulfilled {
                isExpectationFulfilled = true
                expectation.fulfill()
                XCTAssertNotNil(errorMessage)
            }
        }
        
        // Act
        viewModel.getNews()
        await fulfillment(of: [expectation], timeout: 5)
        
        // Assert
        XCTAssertEqual(viewModel.numberOfRows(), 0)
    }
    
    /// Test that number of rows matches number of articles
    func testNumberOfRows() async throws {
        // Arrange
        setupMockService(fileName: "MockTwentyNewsData")
        
        // Act
        await fetchNewsData(expectationDescription: "News data fetch successful")
        
        // Assert
        XCTAssertEqual(viewModel.numberOfRows(), 20)
    }
    
    /// Test that cellViewModel is created correctly
    func testCellViewModel() async throws {
        // Arrange
        setupMockService(fileName: "MockTwentyNewsData")
        
        // Act
        await fetchNewsData(expectationDescription: "News data fetch successful")
        
        // Assert - Verify the cellViewModel for a valid index path
        let indexPath = IndexPath(row: 0, section: 0)
        let cellViewModel = viewModel.cellViewModel(at: indexPath)
        XCTAssertNotNil(cellViewModel)
    }
    
    /// Test that newsDetailsViewModel is created correctly
    func testNewsDetailsViewModel() async throws {
        // Arrange
        setupMockService(fileName: "MockTwentyNewsData")
        
        // Act
        await fetchNewsData(expectationDescription: "News data fetch successful")
        
        // Assert - Verify the newsDetailsViewModel for a valid index path
        let indexPath = IndexPath(row: 0, section: 0)
        let newsDetailsViewModel = viewModel.newsDetailsViewModel(at: indexPath)
        XCTAssertNotNil(newsDetailsViewModel)
    }
    
    
    // MARK: private functions
    
    /// Arrange - Dependency Injection
    private func setupMockService(fileName: String? = nil) {
        if let fileName = fileName {
            mockNewsAPIService = MockNewsAPIService(fileName: fileName)
        } else {
            mockNewsAPIService = BitbucketNewsAPIService()
        }
        InjectedValues[\.newsAPIService] = mockNewsAPIService
    }
    
    /// For the test cases that fetch news data successfully
    private func fetchNewsData(expectationDescription: String) async {
        let expectation = self.expectation(description: expectationDescription)
        var isExpectationFulfilled = false
        
        // Expectation should be fulfilled once when completion handler is executed
        viewModel.updateUIBind = {
            if !isExpectationFulfilled {
                isExpectationFulfilled = true
                expectation.fulfill()
            }
        }
        
        viewModel.getNews()
        await fulfillment(of: [expectation], timeout: 5)
    }
}
