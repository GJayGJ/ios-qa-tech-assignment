//
//  OptionalData+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import UIKit.UIImage

extension Optional where Wrapped == Data {
    func toImage() -> UIImage {
        if let validData = self, let validImage = UIImage(data: validData) {
            return validImage
        } else {
            return UIImage.placeHolderImage()
        }
    }
}
