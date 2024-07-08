//
//  API.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

struct API {
    var url: URL
    var requestType: RequestType = .get
    var headers: [String: String]?
    var body: [String: Any]?
}
