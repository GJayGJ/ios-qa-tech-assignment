//
//  Request.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

class Request {
    static func request(api: API, shouldCache: Bool) async throws -> Data {
        var request = URLRequest(url: api.url)
        
        request.cachePolicy = shouldCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
        
        request.httpMethod = api.requestType.rawValue
        
        request.allHTTPHeaderFields = api.headers
        
        if let body = api.body, api.requestType != .get {
            let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = httpBody
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return data
    }
}
