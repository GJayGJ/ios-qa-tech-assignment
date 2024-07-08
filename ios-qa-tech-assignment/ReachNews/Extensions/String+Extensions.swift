//
//  String+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import Foundation

extension String {
    var htmlString: String? {
        do {
            guard let data = data(using: String.Encoding.utf8) else { return nil }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil).string
        } catch { return nil }
    }
}
