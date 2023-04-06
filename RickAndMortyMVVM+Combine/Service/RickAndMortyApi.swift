//
//  RickAndMortyApi.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation
import Combine
import UIKit

protocol RickAndMortyApiProtocol: AnyObject {
    func fetchCharactersList(page: Int) -> AnyPublisher<ResponseForCharactersList, Error>
    func fetchCharacterInfo(characterId: Int) -> AnyPublisher<CharacterInfo, Error>
}

class RickAndMortyApi: RickAndMortyApiProtocol {
    
    private var baseUrlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        return urlComponents
    }
    
    func fetchCharactersList(page: Int) -> AnyPublisher<ResponseForCharactersList, Error> {
        
        var urlComponents = baseUrlComponents
        urlComponents.path = "/api/character"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ResponseForCharactersList.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchCharacterInfo(characterId: Int) -> AnyPublisher<CharacterInfo, Error> {
        var urlComponents = baseUrlComponents
        urlComponents.path = "/api/character/\(characterId)"
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CharacterInfo.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
