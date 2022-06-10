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
    
    let process = CurrentValueSubject<Process, Never>(.ready)
    
    let avatar = CurrentValueSubject<UIImage, Never>(UIImage())
    let name = CurrentValueSubject<String, Never>("")
    let species = CurrentValueSubject<String, Never>("")
    let gender = CurrentValueSubject<String, Never>("")
    var status = CurrentValueSubject<String, Never>("")
    var locationName = CurrentValueSubject<String, Never>("")
    var episode = CurrentValueSubject<[String], Never>([])
    
    func fetchCharacterInfo(characterId: Int) {
        RickAndMortyApi().fetchCharacterInfo(characterId: characterId)
            .subscribe(on: utilityQueue)
            .sink { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure(let error):
                    self.process.send(.failedWithError(error: error))
                    break
                default:
                    self.process.send(.ready)
                }
                self.subscriptions.removeAll()
            } receiveValue: { [weak self] characterInfo in
                guard let self = self else { return }
                self.name.send(characterInfo.name)
                self.species.send(characterInfo.species)
                self.gender.send(characterInfo.status)
                self.locationName.send(characterInfo.location.name)
                self.episode.send(characterInfo.episode)
                self.status.send(characterInfo.status)
                RickAndMortyApi().downloadImage(url: characterInfo.image)
                    .sink( receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        default:
                            break
                        }
                    }, receiveValue: { [weak self] image in
                        guard let self = self else { return }
                        self.avatar.send(image)
                    })
                    .store(in: &self.subscriptions)
                
            }
            .store(in: &subscriptions)
        
    }
    
    init(characterId: Int) {
        fetchCharacterInfo(characterId: characterId)
    }
}
