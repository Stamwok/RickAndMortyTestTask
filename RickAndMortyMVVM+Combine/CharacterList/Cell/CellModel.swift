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
    private var subscriptions = Set<AnyCancellable>()
    
    let avatar = CurrentValueSubject<UIImage, Never>(UIImage())
    let name = CurrentValueSubject<String, Never>("")
    let species = CurrentValueSubject<String, Never>("")
    let gender = CurrentValueSubject<String, Never>("")
    
    private let character: CharacterForList
    
    var reuseIdentifier: String = CharacterCell.reuseID
    var selected: Bool = false
    
    init(character: CharacterForList) {
        self.character = character
        self.name.send(self.character.name)
        self.species.send(self.character.species)
        self.gender.send(self.character.gender)
        RickAndMortyApi().downloadImage(url: character.image)
            .sink( receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] image in
                guard let self = self else { return }
                self.avatar.send(image)
            })
            .store(in: &subscriptions)
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseID, for: indexPath) as? CharacterCell else { fatalError("wrong cell") }
        cell.configure(withModel: self)
        return cell
    }
}
