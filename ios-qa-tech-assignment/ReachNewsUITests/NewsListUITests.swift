//
//  NewsListUITests.swift
//  ReachNewsUITests
//
//  Created by 黃冠傑 on 2024/7/6.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import XCTest

final class NewsListUITests: XCTestCase {
    var app: XCUIApplication!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Launch the app with an argument to clear UserDefaults
        app.launchArguments.append("--resetUserDefaults")
    }

    override func tearDownWithError() throws {
        // Take a screenshot if the test fails
        if self.testRun?.totalFailureCount ?? 0 > 0 {
            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.lifetime = .deleteOnSuccess
            add(attachment)
        }
        app = nil
    }
    
    
    // MARK: Test Cases
    
    /// 1. Test that the app correctly displays a list of 20 articles
    func testArticlesDeisplayed() throws {
        launchAppWithMockData("MockTwentyNewsData")
        
        let tableView = app.tables["newsListTable"]
        waitForTableView(tableView)
        
        let rowCount = tableView.cells.count
        XCTAssertEqual(rowCount, 20, "There should be exactly 20 articles displayed.")
    }
    
    /// 2. Test that bookmarking an article behaves as expected
    func testBookmarking() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        waitForTableView(tableView)
        
        // Pick a random row to bookmark
        let rowCount = tableView.cells.count
        let randomIndex = Int.random(in: 0..<rowCount)
        
        // Toggle a unbookmarked row
        let unbookmarkedCell = tableView.cells["article\(randomIndex)"]
        unbookmarkedCell.buttons["addBookmarkButton"].tap()

        // Terminate the app to ensure data exists in UserDefaults
        app.terminate()
        XCUIApplication().launch()

        // Toggle a bookmarked row
        let bookmarkedCell = tableView.cells["article\(randomIndex)"]
        bookmarkedCell.buttons["removeBookmarkButton"].tap()
    }
    
    /// 3. Test that sorting alphabetically by headline works as expected
    func testSortingAlphabeticallyByHeadline() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        waitForTableView(tableView)

        // Tap `sort alphabetically by title`
        app.navigationBars["Top Stories"].buttons["Sort"].tap()
        app.collectionViews.buttons["Alphabetically By Title"].tap()
        
        // Sort the cells again using a Swift function to ensure the original cells were already sorted
        let cells = tableView.cells.allElementsBoundByIndex
        let haedLines = cells.map { $0.staticTexts.element(boundBy: 0).label }
        XCTAssertEqual(haedLines, haedLines.sorted(), "Headlines are not sorted alphabetically.")
    }
    
    /// 4. Test that sorting alphabetically by bookmarked state works as expected
    func testSortingByBookmark() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        waitForTableView(tableView)
        
        let rowCount = tableView.cells.count
        // At least two rows are required to conduct sorting test
        guard rowCount > 1 else { return }
        
        // Pick several rows to bookmark randomly
        let randomBookmarkedItemCount = Int.random(in: 1...rowCount)
        if let uniqueRandomIndices = Array.uniqueRandomIntegers(count: randomBookmarkedItemCount, in: 0..<rowCount) {
            for uniqueRandomIndex in uniqueRandomIndices {
                tableView.cells["article\(uniqueRandomIndex)"].buttons["addBookmarkButton"].tap()
            }
        }
        
        // Tap `sort by bookmarks`
        app.navigationBars["Top Stories"].buttons["Sort"].tap()
        app.collectionViews.buttons["By Bookmarks"].tap()
        
        // Ensure bookmarked rows are on the top of the list
        for i in 0..<randomBookmarkedItemCount {
            let cell = tableView.cells.element(boundBy: i)
            let bookmarkedButton = cell.buttons["removeBookmarkButton"]
            XCTAssertTrue(bookmarkedButton.exists)
        }
    }
    
    /// 5. Test that all types are correctly displayed in the list e.g. news, opinion, live
    ///  - Testing data `MockAllTypesOfNewsData` is not acceptable because the type "live" is missing in the project code.
    ///  - accessibilityIdentifier for articleTypeLabel in NewsTableCell should be set to enhance the robustness of testing
    func testArticleTypesDeisplayed() throws {
        app.launch()
//        launchAppWithMockData("MockAllTypesOfNewsData")
        
        let tableView = app.tables["newsListTable"]
        waitForTableView(tableView)
        
        let expectedTags = ["News", "Opinion", "Live"]
        
        // Iterate through each row in the table
        for cell in tableView.cells.allElementsBoundByIndex {
            // It is better to access the element with its accessibilityIdentifier
            let articleTypeLabel = cell.staticTexts.allElementsBoundByIndex.last
            XCTAssertNotNil(articleTypeLabel)
            XCTAssertTrue(articleTypeLabel!.exists)
            XCTAssertTrue(expectedTags.contains(articleTypeLabel!.label))
        }
    }
    
    
    // MARK: Utilities
    
    /// Launch the app with mock data by passing it through environment key-value
    private func launchAppWithMockData(_ mockData: String) {
        app.launchEnvironment["MOCK_NEWS"] = mockData
        app.launch()
    }
    
    /// Prepare for the table in ListView
    private func waitForTableView(_ tableView: XCUIElement, timeout: TimeInterval = 5) {
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertTrue(tableView.exists)
    }
    
    /// Launch the app with a command line argument to reset UserDefaults
    private func resetUserDefaults() {
        app.launchArguments.append("--resetUserDefaults")
    }
}
