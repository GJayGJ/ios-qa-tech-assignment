//
//  UIImageView+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import UIKit.UIImageView

extension UIImageView {
    func setupImageViewSettings(_ imageViewSettings: ImageViewSettings) {
        self.contentMode = imageViewSettings.contentMode
        
        self.layer.cornerRadius = imageViewSettings.roundImage ? min(self.frame.height, self.frame.width) / 2 : 0
        
        if let accessibilityText = imageViewSettings.accessibilityText {
            self.accessibilityLabel = "\(Localized("accessibility_imageViewPrefix")) \(accessibilityText)"
        }
    }
}
