//
//  NewsDetailUITests.swift
//  ReachNewsUITests
//
//  Created by 黃冠傑 on 2024/7/6.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import XCTest

final class NewsDetailUITests: XCTestCase {
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
    
    /// 1. Test that bookmarking an article behaves as expected
    ///  - In order to access the elements in the detailView, the identifier of the contentView in the scrollView from the xib must be set.
    func testBookmarking() throws {
        app.launch()
        let tableView = waitForTableView()
        
        // Prepare a random row in the table
        let rowCount = tableView.cells.count
        let randomIndex = Int.random(in: 0..<rowCount)
        let isNotBookmarkedRow = tableView.cells["article\(randomIndex)"]
        let isNotBookmarkedButton =  isNotBookmarkedRow.buttons["addBookmarkButton"]
        XCTAssertTrue(isNotBookmarkedButton.exists)
        
        // Tap the row that is not bookmarked, and the detail view is pushed into.
        isNotBookmarkedRow.tap()
        // Make sure the ScrollView appears
        _ = waitForScrollView()
        
        // Not bookmarked -> bookedmarked
        XCTAssertTrue(app.staticTexts["Add To Bookmarks"].exists)
        app.staticTexts["Add To Bookmarks"].tap()
        
        // Bookedmarked -> not bookmarked
        XCTAssertTrue(app.buttons["Remove From Bookmarks"].exists)
        app.staticTexts["Remove From Bookmarks"].tap()
        XCTAssertTrue(app.staticTexts["Add To Bookmarks"].exists)
    }
    
    /// 2. Test that a user can scroll through the article, and all elements are present
    func testScrollable() throws {
        app.launch()
        let tableView = waitForTableView()
        
        // Prepare a random row in the table and tap it
        let rowCount = tableView.cells.count
        let randomIndex = Int.random(in: 0..<rowCount)
        tableView.cells["article\(randomIndex)"].tap()
        
        let scrollView = waitForScrollView()
        let bottomElement = app.staticTexts["bodyLabel"]
        
        // Scroll until the bottom element is present
        while !bottomElement.isHittable {
            scrollView.swipeUp()
        }
        
        // Ensure each element is present
        XCTAssert(app.images["headlineImageView"].exists)
        XCTAssert(app.buttons["tagButton"].exists)
        XCTAssert(app.buttons["toggleBookmarkButton"].exists)
        XCTAssert(app.staticTexts["imageCreditLabel"].exists)
        XCTAssert(app.staticTexts["headlineLabel"].exists)
        XCTAssert(app.staticTexts["bodyLabel"].exists)
    }
    
    /// 3. Test that all articles display an image credit
    func testCreditDisplayed() throws {
        app.launch()
        let tableView = waitForTableView()
        
        // Iterate through each row in the table
        for cell in tableView.cells.allElementsBoundByIndex {
            // Navigate to the DetailView
            cell.tap()
            
            _ = waitForScrollView()
            
            // Ensure imageCredit is present
            let imageCredit = app.staticTexts["imageCreditLabel"]
            XCTAssertTrue(imageCredit.exists)
            
            // Pop the screen back to the ListView
            app.buttons["Top Stories"].tap()
        }
    }
    
    /// 4. Test that all types are correctly displayed in the detailView e.g. news, opinion, live
    func testNewsTypeDisplayed() throws {
        app.launch()
        let tableView = waitForTableView()
        
        let expectedTags = ["News", "Opinion", "Live"]
        
        // Iterate through each row in the table
        for cell in tableView.cells.allElementsBoundByIndex {
            // Navigate to the DetailView
            cell.tap()
            
            _ = waitForScrollView()
            
            // Ensure tagButton is one of the members in expectedTags
            let tagButton = app.buttons["tagButton"]
            XCTAssertTrue(tagButton.exists)
            XCTAssertTrue(expectedTags.contains(tagButton.label))
            
            // Pop the screen back to the ListView
            app.buttons["Top Stories"].tap()
        }
    }
    
    
    // MARK: Utilities
    
    /// Prepare for the table in ListView
    private func waitForTableView() -> XCUIElement {
        let tableView = app.tables["newsListTable"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(tableView.exists)
        return tableView
    }
    
    /// Prepare for the ScrollView in DetailView
    private func waitForScrollView() -> XCUIElement {
        let scrollView = app.scrollViews["articleDetailScrollView"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        return scrollView
    }
}
