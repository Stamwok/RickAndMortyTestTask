//
//  CharactersListFlowController.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 16.06.22.
//

import UIKit

class CharactersListFlowController: UINavigationController {
    private lazy var charactersListViewModel = CharactersListViewModel()
    private lazy var charactersListViewController = CharactersListViewController(viewModel: charactersListViewModel)
    private lazy var showCharacterInfo: ((Int) -> Void) = { [weak self] id in
        let viewModel = CharacterInfoViewModel(characterId: id)
        let vc = CharacterInfoViewController(viewModel: viewModel)
        self?.present(vc, animated: true)
    }
    
    func start() {
        charactersListViewModel.showCharacterInfo = self.showCharacterInfo
        self.pushViewController(charactersListViewController, animated: true)
    }
}
