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

final class CellModel: TableViewCompatible {

    let avatar: String
    let name: String
    let species: String
    let gender: String
    
    private let character: CharacterForList
    
    var reuseIdentifier: String = CharacterCell.reuseID
    var selected: Bool = false
    
    init(character: CharacterForList) {
        self.character = character
        self.avatar = character.image
        self.name = character.name
        self.species = character.species
        self.gender = character.species
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseID, for: indexPath) as? CharacterCell else { fatalError("wrong cell") }
        cell.configure(withModel: self)
        return cell
    }
}
