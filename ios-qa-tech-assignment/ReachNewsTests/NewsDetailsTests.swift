//
//  NewsDetailsTest.swift
//  ReachNewsTests
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import XCTest
@testable import ReachNews

class NewsDetailsTest: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        
    }
    
    func testHeadlineValue() throws {
        let newsDetailsViewModel = createNewsDetailsViewModelMock()
        
        let expectedHeadline = "Headline test"
        
        XCTAssert(newsDetailsViewModel.headline == expectedHeadline)
    }
    
    func testImagesContentCount() throws {
        let newsDetailsViewModel = createNewsDetailsViewModelImagesMock()
        
        let expectedContentsWithImage = 2
        
        XCTAssert(newsDetailsViewModel.contentsWithImages == expectedContentsWithImage)
    }
    
    private func createNewsDetailsViewModelMock() -> NewsDetailsViewModel {
        let contents = [Content(attributes: ContentAttribute(text: "&#62;Text 1&#171;", altText: nil, caption: nil, credit: nil, url: nil), type: .text),
                        Content(attributes: ContentAttribute(text: "&#62;Text 2&#171;", altText: nil, caption: nil, credit: nil, url: nil), type: .text),
                        Content(attributes: ContentAttribute(text: "&#62;Text 3!!!", altText: nil, caption: nil, credit: nil, url: nil), type: .text),
                        Content(attributes: ContentAttribute(text: "NOT TO BE ADDED", altText: nil, caption: nil, credit: nil, url: nil), type: .image)]
        
        let leadMedia = Content(attributes: ContentAttribute(text: nil, altText: nil, caption: nil, credit: nil, url: nil), type: .image)
        
        let article = Article(contents: contents, headline: "Headline test", id: "1", leadMedia: leadMedia, type: .news)
        
        let newsDetailsViewModelDependencies = NewsDetailsViewModel.Dependencies(article: article)
        
        return NewsDetailsViewModel(dependencies: newsDetailsViewModelDependencies)
    }
    
    private func createNewsDetailsViewModelImagesMock() -> NewsDetailsViewModel {
        let imageMock = "https://bitbucket.org/trinitymirror-ondemand/ios-tech-test/src/main/images/reach-logo.svg"
        
        let contents = [Content(attributes: ContentAttribute(text: "Test 1", altText: nil, caption: nil, credit: nil, url: nil), type: .text),
                        Content(attributes: ContentAttribute(text: nil, altText: nil, caption: nil, credit: nil, url: imageMock), type: .image),
                        Content(attributes: ContentAttribute(text: "Test 2", altText: nil, caption: nil, credit: nil, url: nil), type: .text),
                        Content(attributes: ContentAttribute(text: nil, altText: nil, caption: nil, credit: nil, url: imageMock), type: .image)]
        
        let leadMedia = Content(attributes: ContentAttribute(text: nil, altText: nil, caption: nil, credit: nil, url: nil), type: .image)
        
        let article = Article(contents: contents, headline: "Headline test", id: "2", leadMedia: leadMedia, type: .news)
        
        let newsDetailsViewModelDependencies = NewsDetailsViewModel.Dependencies(article: article)
        
        return NewsDetailsViewModel(dependencies: newsDetailsViewModelDependencies)
    }
}
