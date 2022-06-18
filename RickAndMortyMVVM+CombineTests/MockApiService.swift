//
//  MockApiService.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 18.06.22.
//

import Foundation
import Combine

class MockApiService: RickAndMortyApiProtocol {
    
    var fetchCharactersListResult: AnyPublisher<ResponseForCharactersList, Error>!
    var fetchCharacterInfoResult: AnyPublisher<CharacterInfo, Error>!
    
    func fetchCharactersList(page: Int) -> AnyPublisher<ResponseForCharactersList, Error> {
        return fetchCharactersListResult
    }
    
    func fetchCharacterInfo(characterId: Int) -> AnyPublisher<CharacterInfo, Error> {
        return fetchCharacterInfoResult
    }
    
    func fetchCaractersListSuccess() {
        let charactersListToTest = ResponseForCharactersList(
            info: PageInfo(count: 826, pages: 42, next: "Second page", prev: nil),
            results: [CharacterForList](
                repeating: CharacterForList(id: 1, name: "", species: "", gender: "", image: ""),
                count: 20
            )
        )
        fetchCharactersListResult = Result
            .success(charactersListToTest)
            .publisher
            .eraseToAnyPublisher()
    }
    
    func fetchCharactersListFailure() {
        let someError = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Some error"])
        fetchCharactersListResult = Result
            .failure(someError)
            .publisher
            .eraseToAnyPublisher()
    }
    
    func fetchLastPage() {
        let charactersListToTest = ResponseForCharactersList(
            info: PageInfo(count: 826, pages: 42, next: nil, prev: "Previous page"),
            results: [CharacterForList](
                repeating: CharacterForList(id: 1, name: "", species: "", gender: "", image: ""),
                count: 20
            )
        )
        fetchCharactersListResult = Result
            .success(charactersListToTest)
            .publisher
            .eraseToAnyPublisher()
    }
    
    func fetchCharacterInfoSuccess() {
        let characterInfoToTest = CharacterInfo(id: 1, name: "", species: "", gender: "", image: "", status: "", location: Location(name: "", url: ""), episode: [String]())
        fetchCharacterInfoResult = Result
            .success(characterInfoToTest)
            .publisher
            .eraseToAnyPublisher()
    }
    
    func fetchCharacterInfoFailure() {
        let someError = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Some error"])
        fetchCharacterInfoResult = Result
            .failure(someError)
            .publisher
            .eraseToAnyPublisher()
    }
}
