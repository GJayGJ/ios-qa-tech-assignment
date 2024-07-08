//
//  MockNewsAPIService.swift
//  ReachNews
//
//  Created by 黃冠傑 on 2024/7/6.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import Foundation

class MockNewsAPIService: NewsAPIService {
    func getNewsData() async throws -> [Article] {
        let mockNewsDataName = ProcessInfo.processInfo.environment["MOCK_NEWS"]
        let fileURL = Bundle.main.url(forResource: mockNewsDataName, withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
        let newsServiceOutput = try JSONDecoder().decode(NewsServiceOutput.self, from: data)
        return newsServiceOutput.articles
    }
}
