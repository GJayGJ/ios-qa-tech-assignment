//
//  Article.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

struct Article: Codable {
    let contents: [Content]
    let headline: String
    let id: String
    let leadMedia: Content
    let type: ArticleType

    // TODO: Add `live`
    enum ArticleType: String, Codable {
        case news, opinion
    }

    enum CodingKeys: String, CodingKey {
        case contents = "content"
        case headline, id, leadMedia, type
    }
}
