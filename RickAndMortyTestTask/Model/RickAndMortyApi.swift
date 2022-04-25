//
//  RickAndMortyApi.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 17.04.22.
//

import Foundation
import Alamofire
import ObjectMapper

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
    
    struct ResponseForCharactersList: Mappable {
        var info: PageInfo?
        var results: [CharacterForList]?
        
        init?(map: Map) {}
        
        mutating func mapping(map: Map) {
            info <- map["info"]
            results <- map["results"]
        }
    }
    
    func getDetailInfo(id: Int, completionHandler: @escaping (CharacterForDetailScreen) -> Void) {
        let url = "https://rickandmortyapi.com/api/character" + "/\(id)"
        let header: HTTPHeaders = ["Content-Type": contentType]
        AF.request(
            url,
            method: .get,
            headers: header
        ).responseString { response in
            switch response.result {
            case .success(let JSONdata):
                guard let data = CharacterForDetailScreen(JSONString: JSONdata) else { return }
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
        ).responseString { [weak self] response in
            switch response.result {
            case .success(let JSONdata):
                guard let data = ResponseForCharactersList(JSONString: JSONdata),
                      let resultList = data.results else { return }
                self?.nextCharactersPage = data.info?.next
                
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
