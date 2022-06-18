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
    private let apiService: RickAndMortyApiProtocol
    
    var showCharacterInfo: ((Int) -> Void)?
    
    enum Event {
        case onAppear
        case listIsEnded
        case didSelectCharacter(row: Int)
    }
    
    enum State: Equatable {
        static func == (lhs: CharactersListViewModel.State, rhs: CharactersListViewModel.State) -> Bool {
            return lhs.rawValue == rhs.rawValue 
        }
        var rawValue: String? {
            return String(describing: self).components(separatedBy: "(").first
        }
        case idle
        case loading
        case loaded(hasNext: Bool)
        case failedWithError(error: Error)
    }
    
    
    private var loadedPage = 1
    let state = CurrentValueSubject<State, Never>(.idle)
    
    init(apiService: RickAndMortyApiProtocol) {
        self.apiService = apiService
    }
    
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
            case .loaded(hasNext: true):
                state.send(.loading)
                loadedPage += 1
                fetchCharactersList(page: loadedPage)
            default:
                break
            }
        }
    }
    
    private func fetchCharactersList(page: Int) {
        apiService.fetchCharactersList(page: page)
            .subscribe(on: utilityQueue)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.state.send(.failedWithError(error: error))
                default:
                    break
                }
                self.subscriptions.removeAll()
            }, receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                for character in receivedValue.results {
                    self.data.append(CellModel(character: character))
                }
                if receivedValue.info.next == nil {
                    self.state.send(.loaded(hasNext: false))
                } else {
                    self.state.send(.loaded(hasNext: true))
                }
            })
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
