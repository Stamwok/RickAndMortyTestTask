//
//  UITableView+isLastCell.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 19.04.22.
//

import Foundation
import UIKit

extension UITableView {
    func isLastCell(indexPath: IndexPath) -> Bool {
        return indexPath.section == numberOfSections - 1 && indexPath.row == numberOfRows(inSection: indexPath.section) - 1
    }
}
