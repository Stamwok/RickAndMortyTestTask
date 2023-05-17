//
//  CharacterInfoComponent.swift
//  RickAndMortyMVVM+Combine
//
//  Created by Егор Шуляк on 12.04.23.
//

import Foundation
import NeedleFoundation

protocol CharacterInfoDependency: Dependency {
    var apiService: RickAndMortyApiProtocol { get }
}

protocol CharacterInfoBuilder {
    func getCharacterInfoViewModel(characterId: Int) -> CharacterInfoViewModel}

final class CharacterInfoComponent: Component<CharacterInfoDependency>, CharacterInfoBuilder {
    func getCharacterInfoViewModel(characterId: Int) -> CharacterInfoViewModel {
        return CharacterInfoViewModel(characterId: characterId, dependency: self)
    }
}
