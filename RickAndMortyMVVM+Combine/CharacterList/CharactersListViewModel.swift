//
//  CharactersListViewModel.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation
import Combine
import UIKit

class CharactersListViewModel {
    private var subscriptions = Set<AnyCancellable>()
    private let utilityQueue = DispatchQueue(label: "utilityQueue", qos: .utility)
    
    
    enum Event {
        case onAppear
        case didSelectCharacter(id: Int)
        case listIsEnded
    }
    
    enum State {
        case ready
        case inProcess
        case finished(characters: [CharacterForList])
        case loadedLastPage(characters: [CharacterForList])
        case finishedWithEmptyResult
        case failedWithError(error: Error)
        case showsCharacterInfo(vc: UIViewController)
    }
    
    private var loadedPage = 1
    let state = CurrentValueSubject<State, Never>(.ready)
    
    
    func sendEvent(event: Event) {
        switch event {
        case .onAppear:
            state.send(.inProcess)
            fetchCharactersList(page: 1)
        case .didSelectCharacter(let id):
            let vc = CharacterInfoViewController(viewModel: CharacterInfoViewModel(characterId: id))
            vc.completionHandler = {
                self.state.send(.ready)
            }
            state.send(.showsCharacterInfo(vc: vc))
        case .listIsEnded:
            switch self.state.value {
            case .inProcess:
                break
            case .ready:
                state.send(.inProcess)
                loadedPage += 1
                fetchCharactersList(page: loadedPage)
            case .finishedWithEmptyResult:
                break
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
                    self.state.send(.ready)
                }
                self.subscriptions.removeAll()
            }, receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                if receivedValue.info.next == nil {
                    self.state.send(.loadedLastPage(characters: receivedValue.results))
                    self.subscriptions.removeAll()
                } else {
                    self.state.send(.finished(characters: receivedValue.results))
                }
            })
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
