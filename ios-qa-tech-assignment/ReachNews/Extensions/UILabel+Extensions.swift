//
//  UILabel+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import UIKit.UILabel

extension UILabel {
    func setupLabelSettings(_ labelSettings: LabelSettings) {
        self.numberOfLines = labelSettings.numberOfLines
        self.textAlignment = labelSettings.textAlignment

        self.adjustsFontForContentSizeCategory = true
        self.font = labelSettings.font
    }
}
