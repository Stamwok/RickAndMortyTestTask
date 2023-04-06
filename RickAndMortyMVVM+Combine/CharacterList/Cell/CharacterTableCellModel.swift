//
//  CellDataModel.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 25.04.22.
//

import Foundation
import CollectionAndTableViewCompatible
import UIKit
import Combine

final class CharacterTableCellModel: TableViewCompatible, Equatable {
    static func == (lhs: CharacterTableCellModel, rhs: CharacterTableCellModel) -> Bool {
        return lhs.avatar == rhs.avatar &&
        lhs.name == rhs.name &&
        lhs.species == rhs.species &&
        lhs.gender == rhs.gender &&
        lhs.character == rhs.character
    }
    

    let avatar: String
    let name: String
    let species: String
    let gender: String
    
    let character: CharacterForList
    
    var reuseIdentifier: String = CharacterTableViewCell.reuseID
    var selected: Bool = false
    
    init(character: CharacterForList) {
        self.character = character
        self.avatar = character.image
        self.name = character.name
        self.species = character.species
        self.gender = character.species
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseID, for: indexPath) as? CharacterTableViewCell else { fatalError("wrong cell") }
        cell.configure(withModel: self)
        return cell
    }
}
