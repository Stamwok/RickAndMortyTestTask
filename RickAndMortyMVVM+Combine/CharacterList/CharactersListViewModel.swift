//
//  CharactersListViewModel.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation
import Combine
import CollectionAndTableViewCompatible

class CharactersListViewModel {
    private var subscriptions = Set<AnyCancellable>()
    private let utilityQueue = DispatchQueue(label: "utilityQueue", qos: .utility)
    
    var data = [TableViewCompatible]()
    
    var showCharacterInfo: ((Int) -> Void)?
    
    enum Event {
        case onAppear
        case listIsEnded
        case didSelectCharacter(row: Int)
    }
    
    enum State {
        case idle
        case loading
        case loaded(characters: [CharacterForList], hasNext: Bool)
        case failedWithError(error: Error)
    }
    
    private var loadedPage = 1
    let state = CurrentValueSubject<State, Never>(.idle)
    
    
    func sendEvent(event: Event) {
        switch event {
        case .onAppear:
            state.send(.loading)
            fetchCharactersList(page: 1)
        case .didSelectCharacter(let row):
            guard let cellModel = data[row] as? CellModel,
                  let showCharacterInfo = showCharacterInfo else { return }
            let characterId = cellModel.character.id
            showCharacterInfo(characterId)
        case .listIsEnded:
            switch self.state.value {
            case .idle:
                state.send(.loading)
                loadedPage += 1
                fetchCharactersList(page: loadedPage)
            default:
                break
            }
        }
    }
    
    private func fetchCharactersList(page: Int) {
        RickAndMortyApi().fetchCharactersList(page: page)
            .subscribe(on: utilityQueue)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.state.send(.failedWithError(error: error))
                    break
                default:
                    self.state.send(.idle)
                }
                self.subscriptions.removeAll()
            }, receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                if receivedValue.info.next == nil {
                    self.state.send(.loaded(characters: receivedValue.results, hasNext: false))
                    self.subscriptions.removeAll()
                } else {
                    self.state.send(.loaded(characters: receivedValue.results, hasNext: true))
                }
            })
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
