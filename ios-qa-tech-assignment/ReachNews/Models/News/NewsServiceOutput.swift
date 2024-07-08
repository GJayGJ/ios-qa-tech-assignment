//
//  NewsServiceOutput.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

struct NewsServiceOutput: Codable {
    let name: String
    let type: NewsType
    let articles: [Article]

    enum NewsType: String, Codable {
        case articles
    }
}
