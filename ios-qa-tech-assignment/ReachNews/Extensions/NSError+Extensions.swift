//
//  NSError+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import Foundation

extension NSError {
    private enum Constants {
        static let domain = "FelipeDomain"
        static let genericMessage = Localized("alert_message")
    }

    static func defaulError(code: Int, message: String? = nil) -> NSError {
        return NSError(domain: Constants.domain, code: code, userInfo: [NSLocalizedDescriptionKey: message ?? Constants.genericMessage])
    }
}
