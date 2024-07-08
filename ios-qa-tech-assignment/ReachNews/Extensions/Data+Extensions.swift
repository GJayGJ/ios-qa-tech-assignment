//
//  Data+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import UIKit.UIImage

extension Data {
    func toImage() -> UIImage {
        if let validImage = UIImage(data: self) {
            return validImage
        } else {
            return UIImage.placeHolderImage()
        }
    }
}
