//
//  NewsAPIService.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 01/10/2022.
//

import Foundation

protocol NewsAPIService {
    func getNewsData() async throws -> [Article]
}

class BitbucketNewsAPIService: NewsAPIService {
    // MARK: - Private Properties

    private let getNewsAPI: API = .init(url: URL(string: "https://bitbucket.org/trinitymirror-ondemand/ios-tech-test/raw/a2852d3b53a451d4782849e6e5a5ba61596deaf2/articlelist.json")!)
    
    // MARK: - Init / Deinit

    deinit {
        print("Deinit: \(String(describing: type(of: self)))")
    }
    
    // MARK: - Public Methods

    func getNewsData() async throws -> [Article] {
        let result = try await Request.request(api: self.getNewsAPI, shouldCache: false)
        let newsServiceOutput = try JSONDecoder().decode(NewsServiceOutput.self, from: result)
        return newsServiceOutput.articles
    }
}

private struct NewsAPIServiceServiceKey: InjectionKey {
    static var currentValue: NewsAPIService = BitbucketNewsAPIService()
}

extension InjectedValues {
    var newsAPIService: NewsAPIService {
        get { Self[NewsAPIServiceServiceKey.self] }
        set { Self[NewsAPIServiceServiceKey.self] = newValue }
    }
}

