//
//  OptionalString+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import Foundation

extension Optional where Wrapped == String {
    var validValue: String {
        return self ?? ""
    }

    var isEmpty: Bool {
        guard let validSelf = self else { return true }
        return validSelf.isEmpty
    }
}
