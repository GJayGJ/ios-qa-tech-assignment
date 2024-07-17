//
//  NewsDetailsTest.swift
//  ReachNewsTests
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import XCTest
@testable import ReachNews

class NewsDetailsTest: XCTestCase {
    var newsListViewModel: NewsListViewModel!
    var newsDetailsViewModel: NewsDetailsViewModel!
    var mockNewsAPIService: NewsAPIService!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        newsListViewModel = NewsListViewModel()
    }
    
    override func tearDownWithError() throws {
        newsListViewModel = nil
        newsDetailsViewModel = nil
        mockNewsAPIService = nil
    }
    
    
    // MARK: Unit Test Cases
    
    /// Test that images can be retrieved successfully
    func testGetLeadMediaSuccess() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockTwentyNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")
        
        // Arrange - NewsDetailsViewModel
        let rowCount = newsListViewModel.numberOfRows()
        let randomIndex = Int.random(in: 0..<rowCount)
        newsDetailsViewModel = newsListViewModel.newsDetailsViewModel(at: IndexPath(row: randomIndex, section: 0))
        
        // Arrange - mock image data
        let mockImageAPIService = MockImageAPIService()
        InjectedValues[\.imageAPIService] = mockImageAPIService
        let expectation = self.expectation(description: "Lead media fetched successfully")
        var isExpectationFulfilled = false
        
        // Expectation should be fulfilled once when completion handler is executed
        newsDetailsViewModel.leadMediaBind = { data in
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
        try await newsDetailsViewModel.getLeadMedia()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    /// Test that bookmarks can be toggled correctly
    func testToggleBookmark() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockTwentyNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")

        // Arrange - NewsDetailsViewModel
        let rowCount = newsListViewModel.numberOfRows()
        let randomIndex = Int.random(in: 0..<rowCount)
        newsDetailsViewModel = newsListViewModel.newsDetailsViewModel(at: IndexPath(row: randomIndex, section: 0))
        
        // Arrange - bookmarked state
        let initialBookmarkState = newsDetailsViewModel.isBookmarked
        
        // Act
        newsDetailsViewModel.toggleBookmark()
        
        // Assert
        let updatedBookmarkState = newsDetailsViewModel.isBookmarked
        XCTAssertNotEqual(updatedBookmarkState, initialBookmarkState)
    }
    
    /// Test that image credit is returned correctly
    func testImageCredit() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockOnlyOneNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")
        
        // Arrange - NewsDetailsViewModel
        newsDetailsViewModel = newsListViewModel.newsDetailsViewModel(at: IndexPath(row: 0, section: 0))
        
        // Act
        let imageCredit = newsDetailsViewModel.imageCredit
        
        // Assert
        XCTAssertEqual(imageCredit, "mock")
    }
    
    /// Test that headline is returned correctly
    func testHeadline() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockOnlyOneNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")
        
        // Arrange - NewsDetailsViewModel
        newsDetailsViewModel = newsListViewModel.newsDetailsViewModel(at: IndexPath(row: 0, section: 0))
        
        // Act
        let headline = newsDetailsViewModel.headline
        
        // Assert
        XCTAssertEqual(headline, "Mock Title")
    }
    
    /// Test that full description is returned correctly
    func testFullDescription() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockOnlyOneNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")
        
        // Arrange - NewsDetailsViewModel
        newsDetailsViewModel = newsListViewModel.newsDetailsViewModel(at: IndexPath(row: 0, section: 0))
        
        // Act
        let fullDescription = newsDetailsViewModel.fullDescription
        
        // Assert
        let expectedFullDescription = "This is mock data.\n\nThis is mock data.\n\nThis is mock data\n\n"
        XCTAssertEqual(fullDescription, expectedFullDescription)
    }
    
    /// Test that tag name is returned correctly
    func testTagName() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockOnlyOneNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")
        
        // Arrange - NewsDetailsViewModel
        newsDetailsViewModel = newsListViewModel.newsDetailsViewModel(at: IndexPath(row: 0, section: 0))
        
        // Act
        let tagName = newsDetailsViewModel.tagName
        
        // Assert
        XCTAssertEqual(tagName, "News")
    }
    
    
    /// Test that contents with images count is correct
    func testContentsWithImages() async throws {
        // Arrange - NewsListViewModel
        setupMockService(fileName: "MockOnlyOneNewsData")
        await fetchNewsData(expectationDescription: "News data fetched successfully")
        
        // Arrange - NewsDetailsViewModel
        newsDetailsViewModel = newsListViewModel.newsDetailsViewModel(at: IndexPath(row: 0, section: 0))
        
        // Act
        let contentsWithImagesCount = newsDetailsViewModel.contentsWithImages
        
        // Assert
        XCTAssertEqual(contentsWithImagesCount, 2)
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
