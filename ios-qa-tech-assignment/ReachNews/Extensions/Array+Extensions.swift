//
//  Array+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import Foundation

extension Array {
    subscript(safe index: Int?) -> Element? {
        if let index = index {
            return indices.contains(index) ? self[index] : nil
        } else {
            return nil
        }
    }
}
