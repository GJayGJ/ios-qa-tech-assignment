//
//  ReachNewsTests.swift
//  ReachNewsTests
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

@testable import ReachNews
import XCTest

class NewsListTests: XCTestCase {
    func testPlaceholderImage() throws {
        let placeholderImage = UIImage.placeHolderImage()
        
        XCTAssertNotNil(placeholderImage)
    }
    
    func testLabelSettings() throws {
        let label = UILabel()
        
        let labelSettings = LabelSettings(numberOfLines: 2,
                                          textAlignment: .center,
                                          fontSize: 10,
                                          fontWeight: .regular)
        
        label.setupLabelSettings(labelSettings)
        
        XCTAssert(label.numberOfLines == labelSettings.numberOfLines)
        XCTAssert(label.textAlignment == labelSettings.textAlignment)
        XCTAssert(label.font == labelSettings.font)
    }
}
