//
//  CharacterListComponent.swift
//  RickAndMortyMVVM+Combine
//
//  Created by Егор Шуляк on 12.04.23.
//

import Foundation
import NeedleFoundation

final class CharacterListComponent: BootstrapComponent {
    var apiService: RickAndMortyApiProtocol {
        return RickAndMortyApi()
    }
    var characterInfoComponent: CharacterInfoComponent {
        return CharacterInfoComponent(parent: self)
    }
    var characterListViewModel: any ObservableObject {
        return CharactersListViewModel(dependency: self)
    }
}



