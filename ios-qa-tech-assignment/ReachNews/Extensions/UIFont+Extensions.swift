//
//  UIFont+Extensions.swift
//  ReachNews
//
//  Created by Gabriel Nica on 14/02/2023.
//  Copyright © 2023 Reach Plc. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    var italic: UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
}
