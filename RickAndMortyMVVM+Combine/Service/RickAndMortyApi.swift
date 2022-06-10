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
    func downloadImage(url: String) -> AnyPublisher<UIImage, Error>
}

class RickAndMortyApi: RickAndMortyApiProtocol {
    
    private var baseUrlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        return urlComponents
    }
    private var nextCharactersPage: String?
    
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
                if let string = String(data: data, encoding: .utf8) {
                    print(string)
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
                if let string = String(data: data, encoding: .utf8) {
                    print(string)
                }
                return data
            }
            .decode(type: CharacterInfo.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func downloadImage(url: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        if let image = CacheManager.shared.getImageFromCache(request: request) {
            return Just<UIImage>(image)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return URLSession.shared.dataTaskPublisher(for: request)
                .timeout(10, scheduler: RunLoop.main, customError: { URLError(.timedOut) })
                .retry(3)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                    else {
                        throw URLError(.badServerResponse)
                    }
    
                    let cache = CachedURLResponse(response: response, data: data)
                    CacheManager.shared.storeAtCache(data: cache, request: request)
                    
                    return data
                }.tryMap {
                    guard let image = UIImage(data: $0) else {
                        throw URLError(.cannotDecodeContentData)
                    }
                    return image
                }
                .eraseToAnyPublisher()
        }
    }
    static func cacheImage(url: String)  {
        guard let url = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: url)
            
        if CacheManager.shared.getImageFromCache(request: request) != nil {
            return
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode
                else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                let cache = CachedURLResponse(response: response, data: data)
                CacheManager.shared.storeAtCache(data: cache, request: request)
            })
            .resume()
        }
    }
}
