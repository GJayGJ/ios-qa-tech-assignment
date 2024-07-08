//
//  LabelSettings.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import UIKit

struct LabelSettings {
    let numberOfLines: Int
    let textAlignment: NSTextAlignment
    let isItalic: Bool
    private let fontSize: CGFloat
    private let fontWeight: UIFont.Weight
    
    var font: UIFont {
        let font = UIFont.systemFont(ofSize: self.fontSize, weight: self.fontWeight)
        
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: self.isItalic ? font.italic : font)
    }
    
    init(numberOfLines: Int, textAlignment: NSTextAlignment, fontSize: CGFloat, fontWeight: UIFont.Weight, isItalic: Bool = false) {
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.isItalic = isItalic
    }
}
        
