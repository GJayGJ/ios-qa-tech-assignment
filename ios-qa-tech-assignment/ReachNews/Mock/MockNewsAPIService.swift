//
//  MockNewsAPIService.swift
//  ReachNews
//
//  Created by 黃冠傑 on 2024/7/6.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import Foundation

class MockNewsAPIService: NewsAPIService {
    var mockFileName: String?
    
    init(fileName: String? = nil) {
        self.mockFileName = fileName
    }
    
    func getNewsData() async throws -> [Article] {
        if mockFileName == nil {
            mockFileName = ProcessInfo.processInfo.environment["MOCK_NEWS"]
        }
        let fileURL = Bundle.main.url(forResource: mockFileName, withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
        let newsServiceOutput = try JSONDecoder().decode(NewsServiceOutput.self, from: data)
        return newsServiceOutput.articles
    }
}
