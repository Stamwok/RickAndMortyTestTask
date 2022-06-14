//
//  CharacterInfoViewModel.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 10.06.22.
//

import Foundation
import Combine
import UIKit

class CharacterInfoViewModel {
    private let utilityQueue = DispatchQueue(label: "utilityQueue", qos: .utility)
    private var subscriptions = Set<AnyCancellable>()
    let state = CurrentValueSubject<State, Never>(.ready)
    
    enum State {
        case ready
        case characterLoaded(character: CharacterInfo)
        case inProcess
        case failedWithError(error: Error)
    }
    
    func fetchCharacterInfo(characterId: Int) {
        state.send(.inProcess)
        RickAndMortyApi().fetchCharacterInfo(characterId: characterId)
            .subscribe(on: utilityQueue)
            .sink { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure(let error):
                    self.state.send(.failedWithError(error: error))
                    break
                default:
                    self.state.send(.ready)
                    break
                }
                self.subscriptions.removeAll()
            } receiveValue: { [weak self] characterInfo in
                guard let self = self else { return }
                self.state.send(.characterLoaded(character: characterInfo))
            }
            .store(in: &subscriptions)
        
    }
    
    init(characterId: Int) {
        fetchCharacterInfo(characterId: characterId)
    }
    deinit {
        subscriptions.removeAll()
    }
}
