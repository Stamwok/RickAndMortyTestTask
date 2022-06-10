//
//  CharactersListViewModel.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation
import Combine

class CharactersListViewModel {
    private var subscriptions = Set<AnyCancellable>()
    private let utilityQueue = DispatchQueue(label: "utilityQueue", qos: .utility)
    
    var loadedPage = 1
    let charactersList = CurrentValueSubject<[CharacterForList], Never>([])
    let process = CurrentValueSubject<Process, Never>(.ready)
    
    func fetchCharactersList(page: Int) {
        process.send(.inProcess)
        RickAndMortyApi().fetchCharactersList(page: page)
            .subscribe(on: utilityQueue)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.process.send(.failedWithError(error: error))
                    break
                default:
                    self.process.send(.ready)
                }
                self.subscriptions.removeAll()
            }, receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                if page == 1 {
                    self.charactersList.send(receivedValue.results)
                } else {
                    let oldValue = self.charactersList.value
                    let newValue = oldValue + receivedValue.results
                    self.charactersList.send(newValue)
                }
                if receivedValue.info.next == nil {
                    self.process.send(.finishedWithEmptyResult)
                    self.subscriptions.removeAll()
                } else {
                    self.process.send(.finished)
                }
            })
            .store(in: &subscriptions)
    }
    
    init() {
        self.fetchCharactersList(page: 1)
    }
}
