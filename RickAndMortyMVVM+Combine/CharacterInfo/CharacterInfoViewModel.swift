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
    let state = CurrentValueSubject<State, Never>(.idle)
    private let apiService: RickAndMortyApiProtocol
    private let characterId: Int
    
    enum State: Equatable {
        static func == (lhs: CharacterInfoViewModel.State, rhs: CharacterInfoViewModel.State) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        var rawValue: String? {
            return String(describing: self).components(separatedBy: "(").first
        }
        case idle
        case characterLoaded(character: CharacterInfo)
        case loading
        case failedWithError(error: Error)
    }
    
    enum Event {
        case onAppear
    }
    
    func sendEvent(event: Event) {
        switch event {
        case .onAppear:
            state.send(.loading)
            fetchCharacterInfo(characterId: characterId)
        }
    }
    
    private func fetchCharacterInfo(characterId: Int) {
        state.send(.loading)
        apiService.fetchCharacterInfo(characterId: characterId)
            .subscribe(on: utilityQueue)
            .sink { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure(let error):
                    self.state.send(.failedWithError(error: error))
                default:
                    break
                }
                self.subscriptions.removeAll()
            } receiveValue: { [weak self] characterInfo in
                guard let self = self else { return }
                self.state.send(.characterLoaded(character: characterInfo))
            }
            .store(in: &subscriptions)
        
    }
    
    init(characterId: Int, apiService: RickAndMortyApiProtocol) {
        self.apiService = apiService
        self.characterId = characterId
//        fetchCharacterInfo(characterId: characterId)
    }
    deinit {
        subscriptions.removeAll()
    }
}
