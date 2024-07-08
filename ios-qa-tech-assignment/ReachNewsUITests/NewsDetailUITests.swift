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
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Launch the app with an argument to clear UserDefaults
        app.launchArguments.append("--resetUserDefaults")
    }

    override func tearDownWithError() throws {
        app = nil
    }

    /// 1. Test that bookmarking an article behaves as expected
    ///  - In order to access the elements in the detailView, the identifier of the contentView in the scrollView from the xib must be set.
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
        
        let isNotBookmarkedRow = tableView.cells["article\(randomIndex)"]
        let isNotBookmarkedButton =  isNotBookmarkedRow.buttons["addBookmarkButton"]
        XCTAssertTrue(isNotBookmarkedButton.exists)
        
        // Tap the row that is not bookmarked, and the detail view is pushed into.
        isNotBookmarkedRow.tap()
        // Make sure the ScrollView appears
        let scrollView = app.scrollViews["articleDetailScrollView"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Add To Bookmarks"].exists)
        app.staticTexts["Add To Bookmarks"].tap()
        XCTAssertTrue(app.buttons["Remove From Bookmarks"].exists)
        app.staticTexts["Remove From Bookmarks"].tap()
        XCTAssertTrue(app.staticTexts["Add To Bookmarks"].exists)
    }
    
    /// 2. Test that a user can scroll through the article, and all elements are present
    func testScrollable() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        // Wait for the table view to appear
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(tableView.exists)
        
        let rowCount = tableView.cells.count
        let randomIndex = Int.random(in: 0..<rowCount)
        tableView.cells["article\(randomIndex)"].tap()
        
        // Make sure the ScrollView appears
        let scrollView = app.scrollViews["articleDetailScrollView"]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        let bottomElement = app.staticTexts["bodyLabel"]
        // Scroll until the bottom element is present
        while !bottomElement.isHittable {
            scrollView.swipeUp()
        }
        
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
        
        let tableView = app.tables["newsListTable"]
        // Wait for the table view to appear
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(tableView.exists)
        
        for cell in tableView.cells.allElementsBoundByIndex {
            cell.tap()
            // Make sure the ScrollView appears
            let scrollView = app.scrollViews["articleDetailScrollView"]
            XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
            let imageCredit = app.staticTexts["imageCreditLabel"]
            XCTAssertTrue(imageCredit.exists)
            app.buttons["Top Stories"].tap()
        }
    }
    
    /// 4. Test that all types are correctly displayed in the detailView e.g. news, opinion, live
    func testNewsTypeDisplayed() throws {
        app.launch()
        
        let tableView = app.tables["newsListTable"]
        // Wait for the table view to appear
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(tableView.exists)
        
        let tagSet = ["News", "Opinion", "Live"]
        
        for cell in tableView.cells.allElementsBoundByIndex {
            cell.tap()
            // Make sure the ScrollView appears
            let scrollView = app.scrollViews["articleDetailScrollView"]
            XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
            
            let tagButton = app.buttons["tagButton"]
            XCTAssertTrue(tagButton.exists)
            XCTAssertTrue(tagSet.contains(tagButton.label))
            app.buttons["Top Stories"].tap()
        }
    }
}
