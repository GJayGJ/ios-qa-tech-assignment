//
//  ContentAttribute.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

struct ContentAttribute: Codable {
    // MARK: Used for text type

    let text: String?

    // MARK: Used for text image

    let altText: String?
    let caption: String?
    let credit: String?
    let url: String?
}
