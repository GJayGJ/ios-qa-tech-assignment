//
//  MockNewsAPIService.swift
//  ReachNews
//
//  Created by 黃冠傑 on 2024/7/6.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import Foundation

enum MockNewsAPIServiceError: Error {
    case mockFileNameNotSet
    case fileURLCreationFailed(String)
    case dataDecodingFailed(Error)
}

class MockNewsAPIService: NewsAPIService {
    var mockFileName: String?
    
    init(fileName: String? = nil) {
        self.mockFileName = fileName
    }
    
    func getNewsData() async throws -> [Article] {
        if mockFileName == nil {
            // Mock files can be fetched either by a given file name or by an environment key-value.
            mockFileName = ProcessInfo.processInfo.environment["MOCK_NEWS"]
        }
        
        guard let fileName = mockFileName else {
            throw MockNewsAPIServiceError.mockFileNameNotSet
        }
        
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw MockNewsAPIServiceError.fileURLCreationFailed("\(fileName).json")
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let newsServiceOutput = try JSONDecoder().decode(NewsServiceOutput.self, from: data)
            return newsServiceOutput.articles
        } catch let error {
            throw MockNewsAPIServiceError.dataDecodingFailed(error)
        }
    }
}
