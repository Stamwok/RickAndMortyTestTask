//
//  CellDataModel.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 25.04.22.
//

import Foundation
import CollectionAndTableViewCompatible
import UIKit

final class CellModel: TableViewCompatible {
    var character: CharacterForList?
    
    var reuseIdentifier: String = CharacterCell.reuseID
    var selected: Bool = false
    
    init(character: CharacterForList) {
        self.character = character
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseID, for: indexPath) as? CharacterCell else { fatalError("wrong cell") }
        cell.configure(withModel: self)
        return cell
    }
}
