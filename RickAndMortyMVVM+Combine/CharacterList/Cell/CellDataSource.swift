//
//  CellDataSource.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 25.04.22.
//

import Foundation
import UIKit

enum Section: Int, CaseIterable {
    case main
}

class CellDataSource: UITableViewDiffableDataSource<Section, CharacterForList> {
    private var tableView: UITableView?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { tableView, indexPath, source in
            let model = CellModel(character: source)
            return model.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        }
    }
}
