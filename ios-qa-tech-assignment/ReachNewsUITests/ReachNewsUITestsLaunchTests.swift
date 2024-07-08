//
//  ReachNewsUITestsLaunchTests.swift
//  ReachNewsUITests
//
//  Created by Gabriel Nica on 14/02/2023.
//  Copyright © 2023 Reach Plc. All rights reserved.
//

import XCTest

final class ReachNewsUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
