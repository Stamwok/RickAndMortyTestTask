//
//  CellDataSource.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 25.04.22.
//

import Foundation
import UIKit
import CollectionAndTableViewCompatible

class CellDataSource: NSObject, UITableViewDataSource {
    private var tableView: UITableView?
    var data = [TableViewCompatible]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]
        return model.cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }
}
