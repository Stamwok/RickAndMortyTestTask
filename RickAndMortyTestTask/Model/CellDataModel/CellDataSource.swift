//
//  CellDataSource.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 25.04.22.
//

import Foundation
import UIKit

class CellDataSource: NSObject, UITableViewDataSource {
    private var tableView: UITableView?
    var data = [CharacterForList]() {
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
        let model = CellModel(character: data[indexPath.row])
        return model.cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }
}
