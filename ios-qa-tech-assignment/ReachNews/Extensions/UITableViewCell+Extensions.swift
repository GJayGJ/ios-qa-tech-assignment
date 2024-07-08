//
//  UITableViewCell+Extensions.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 29/09/2022.
//

import UIKit.UITableViewCell

extension UITableViewCell {
    static func classString() -> String {
        return String(describing: self)
    }

    func setupTableCellSettings(_ tableCellSettings: TableCellSettings) {
        self.accessoryType = tableCellSettings.accessoryType
    }
}
