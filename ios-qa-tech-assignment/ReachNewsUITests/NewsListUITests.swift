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
    
    // TODO: Modify the fixed number to variable
    /// 1. Test that the app correctly displays a list of 20 articles
    func testArticlesDeisplayed() throws {
        app.launchEnvironment["MOCK_NEWS"] = "MockTwentyNewsData"
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        // Wait for the table view to appear
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(tableView.exists)
        let rowCount = tableView.cells.count
        
        XCTAssertEqual(rowCount, 20, "There are exactly 20 articles")
    }
    
    /// 2. Test that bookmarking an article behaves as expected
    func testBookmarking() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        // Wait for the table view to appear
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(tableView.exists)
        
        let rowCount = tableView.cells.count
        let randomIndex = Int.random(in: 0..<rowCount)
        
        tableView.cells["article\(randomIndex)"].buttons["addBookmarkButton"].tap()
        app.terminate()
        
        XCUIApplication().launch()
        tableView.cells["article\(randomIndex)"].buttons["removeBookmarkButton"].tap()
    }
    
    /// 3. Test that sorting alphabetically by headline works as expected
    func testSortingAlphabeticallyByHeadline() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        // Wait for the table view to appear
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(tableView.exists)

        app.navigationBars["Top Stories"].buttons["Sort"].tap()
        app.collectionViews.buttons["Alphabetically By Title"].tap()
        let cells = tableView.cells.allElementsBoundByIndex
        let haedLines = cells.map { $0.staticTexts.element(boundBy: 0).label }
        XCTAssertEqual(haedLines, haedLines.sorted(), "Headlines are not sorted alphabetically.")
    }
    
    /// 4. Test that sorting alphabetically by bookmarked state works as expected
    func testSortingByBookmark() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        // Wait for the table view to appear
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(tableView.exists)
        
        let rowCount = tableView.cells.count
        // At least two rows are required to conduct sorting test
        guard rowCount > 1 else { return }
        let randomBookmarkedItemCount = Int.random(in: 1...rowCount)
        if let uniqueRandomIndices = Array.uniqueRandomIntegers(count: randomBookmarkedItemCount, in: 0..<rowCount) {
            for uniqueRandomIndex in uniqueRandomIndices {
                tableView.cells["article\(uniqueRandomIndex)"].buttons["addBookmarkButton"].tap()
            }
        }
        
        app.navigationBars["Top Stories"].buttons["Sort"].tap()
        app.collectionViews.buttons["By Bookmarks"].tap()
        
        for i in 0..<randomBookmarkedItemCount {
            let cell = tableView.cells.element(boundBy: i)
            let bookmarkedButton = cell.buttons["removeBookmarkButton"]
            XCTAssertTrue(bookmarkedButton.exists)
        }
    }
    
    /// 5. Test that all types are correctly displayed in the list e.g. news, opinion, live
    func testArticleTypesDeisplayed() throws {
        app.launchEnvironment["MOCK_NEWS"] = "MockAllTypesOfNewsData"
        app.launch()
    }
}
