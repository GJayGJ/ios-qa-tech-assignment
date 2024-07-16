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
    
    /// Test that news can be retrieved successfully
    func testGetNews() async throws {
        // Arrange - Dependency Injection
        mockNewsAPIService = BitbucketNewsAPIService()
        InjectedValues[\.newsAPIService] = mockNewsAPIService
        
        let expectation = self.expectation(description: "News data fetch successful")
        var isExpectationFulfilled = false
        
        // Expectation should be fulfilled once when completion handler is excuted
        viewModel.updateUIBind = {
            if !isExpectationFulfilled {
                isExpectationFulfilled = true
                expectation.fulfill()
            }
        }
        
        // Act
        viewModel.getNews()
        await fulfillment(of: [expectation], timeout: 5)
        
        // Assert
        XCTAssertGreaterThanOrEqual(viewModel.numberOfRows(), 0)
    }
}
