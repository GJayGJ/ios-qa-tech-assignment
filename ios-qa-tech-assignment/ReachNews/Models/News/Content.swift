//
//  Content.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

struct Content: Codable {
    let attributes: ContentAttribute
    let type: ContentType

    enum ContentType: String, Codable {
        case image, text
    }
}
