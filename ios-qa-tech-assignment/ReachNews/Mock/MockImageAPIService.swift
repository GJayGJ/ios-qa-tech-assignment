//
//  MockImageAPIService.swift
//  ReachNews
//
//  Created by 黃冠傑 on 2024/7/16.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import Foundation

class MockImageAPIService: ImageAPIService {
    var mockImageUrl: String
    
    init(url: String = "https://seeklogo.com/images/R/reach-plc-logo-7442B2E126-seeklogo.com.png") {
        self.mockImageUrl = url
    }
    
    func getImageData(for url: URL) async throws -> Data {
        let mockUrl = URL(string: mockImageUrl)!
        let api = API(url: mockUrl)
        let result = try await Request.request(api: api, shouldCache: true)
        return result
    }
}
