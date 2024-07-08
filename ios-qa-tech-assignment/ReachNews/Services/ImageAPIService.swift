//
//  ImageAPIService.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 01/10/2022.
//

import Foundation

protocol ImageAPIService {
    func getImageData(for url: URL) async throws -> Data
}

class RandomImageAPIService: ImageAPIService {
    // MARK: - Public Methods

    func getImageData(for url: URL) async throws -> Data {
        let api = API(url: url)
        let result = try await Request.request(api: api, shouldCache: true)
        return result
    }
}

private struct ImageAPIServiceServiceKey: InjectionKey {
    static var currentValue: ImageAPIService = RandomImageAPIService()
}

extension InjectedValues {
    var imageAPIService: ImageAPIService {
        get { Self[ImageAPIServiceServiceKey.self] }
        set { Self[ImageAPIServiceServiceKey.self] = newValue }
    }
}
