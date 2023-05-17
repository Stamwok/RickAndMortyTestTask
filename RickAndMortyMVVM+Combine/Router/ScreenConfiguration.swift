//
//  ScreenConfiguration.swift
//  RickAndMortyMVVM+Combine
//
//  Created by Егор Шуляк on 16.04.23.
//

import Foundation
import RouteComposer

protocol ScreenConfiguration {
    var listScreen: DestinationStep<CharactersListViewController, CharactersListViewModel> { get }
    var infoScreen: DestinationStep<CharacterInfoViewController, CharacterInfoViewModel> { get }
}

extension ScreenConfiguration {
    var listScreen: DestinationStep<CharactersListViewController, CharactersListViewModel> {
        return StepAssembly(finder: ClassFinder<CharactersListViewController, CharactersListViewModel>, factory: CharactersListViewControllerFactory()).using(GeneralAction.presentModally()).from(GeneralStep.root()).assemble()
    }
}
