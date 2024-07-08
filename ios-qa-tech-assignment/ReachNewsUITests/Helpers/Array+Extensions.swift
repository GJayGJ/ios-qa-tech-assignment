//
//  Array+Extensions.swift
//  ReachNewsUITests
//
//  Created by 黃冠傑 on 2024/7/7.
//  Copyright © 2024 Reach Plc. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    static func uniqueRandomIntegers(count: Int, in range: Range<Int>) -> [Int]? {
        guard count <= range.count else {
            // impossible to get the required number of unique numbers in the given range
            return nil
        }

        var uniqueIntegers = Set<Int>()
        while uniqueIntegers.count < count {
            let randomInt = Int.random(in: range)
            uniqueIntegers.insert(randomInt)
        }

        return Array(uniqueIntegers)
    }
}
