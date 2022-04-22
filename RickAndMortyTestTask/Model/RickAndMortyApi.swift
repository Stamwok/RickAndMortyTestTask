//
//  RickAndMortyApi.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 17.04.22.
//

import Foundation
import Alamofire

protocol ApiProtocol {
    var isLastPage: Bool { get set }
    func getDetailInfo(id: Int, completionHandler: @escaping (CharacterForDetailScreen) -> Void)
    func getCharactersList(nextPage: Bool, completionHandler: @escaping ([CharacterForList]) -> Void)
}

final class RickAndMortyApi: ApiProtocol {
    private let contentType: String = "application/json"
    private var nextCharactersPage: String?
    private var currentCharactersPage = "https://rickandmortyapi.com/api/character"
    private var loadingInProgress = false
    var isLastPage = false
    
    struct ResponseForCharactersList: Decodable {
        let info: Result<PageInfo, DecodingError>
        let results: [Result<CharacterForList, DecodingError>]
    }
    
    func getDetailInfo(id: Int, completionHandler: @escaping (CharacterForDetailScreen) -> Void) {
        let url = "https://rickandmortyapi.com/api/character" + "/\(id)"
        let header: HTTPHeaders = ["Content-Type": contentType]
        AF.request(
            url,
            method: .get,
            headers: header
        ).responseDecodable(of: CharacterForDetailScreen.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCharactersList(nextPage: Bool, completionHandler: @escaping ([CharacterForList]) -> Void) {
        guard loadingInProgress == false else { return }
        if let nextCharactersPage = nextCharactersPage, nextPage {
            currentCharactersPage = nextCharactersPage
        }
        
        let header: HTTPHeaders = ["Content-Type": contentType]
        loadingInProgress = true
        AF.request(
            currentCharactersPage,
            method: .get,
            headers: header
        ).responseDecodable(of: ResponseForCharactersList.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                let resultList = data.results.compactMap { $0.value }
                self?.nextCharactersPage = data.info.value?.next
                if self?.nextCharactersPage == nil {
                    self?.isLastPage = true
                }
                completionHandler(resultList)
                self?.loadingInProgress = false
            case .failure(let error):
                print(error)
                completionHandler([])
                self?.loadingInProgress = false
            }
        }
    }
}
