//
//  CharactersListFlowController.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 16.06.22.
//

import UIKit

class CharactersListFlowController: UINavigationController {
    private lazy var charactersListViewModel = CharactersListViewModel(apiService: RickAndMortyApi())
    private lazy var charactersListViewController = CharactersListViewController(viewModel: charactersListViewModel)
    
    func start() {
//        charactersListViewModel.showCharacterInfo = self.showCharacterInfo
        self.pushViewController(charactersListViewController, animated: true)
    }
}
